Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244F8560F56
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 04:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiF3Cva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 22:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiF3Cv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 22:51:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04F23EABC;
        Wed, 29 Jun 2022 19:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F66DB82718;
        Thu, 30 Jun 2022 02:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A18C34114;
        Thu, 30 Jun 2022 02:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656557485;
        bh=7o/dgjlFYs1bQQdmIIpXb50diRu874eo6R8qw05RQrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e3IP0FInGVXbCMdMKC2f7/sxgvWBW7DmuwSN9AefGIFpzaI7ZixuakTr9/rRN1rsq
         fjZVxhU317gw+tI3Bu3on9HkWG3SwgM0baTQydjXoxO1W/WIxDtKbURnGd+of3fnq2
         rBiK56OK7o5AuYCsAdOSTLcbUavxXl4fEEory8JpJqG8msGW1WRn4TePD7nY0R2AdG
         rXOjVkC8znpsZZfOeSY6b2CGHXhz+TVbVVPzjvy6VRJHW0oGM31p6JxUbRxWO3nlHp
         3fZAxBA2qo33GNbUACtDUDckCH15OjQ5W5OjbRZ48i3sL2TwZAT6Ncbd4q+Ia/64oq
         pbQmcCmoQv/7Q==
Date:   Wed, 29 Jun 2022 19:51:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] virtio-net: fix the race between refill work and
 close
Message-ID: <20220629195123.610eed9f@kernel.org>
In-Reply-To: <20220630020805.74658-1-jasowang@redhat.com>
References: <20220630020805.74658-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 10:08:04 +0800 Jason Wang wrote:
> +static void enable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock(&vi->refill_lock);
> +	vi->refill_work_enabled = true;
> +	spin_unlock(&vi->refill_lock);
> +}
> +
> +static void disable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock(&vi->refill_lock);
> +	vi->refill_work_enabled = false;
> +	spin_unlock(&vi->refill_lock);
> +}
> +
>  static void virtqueue_napi_schedule(struct napi_struct *napi,
>  				    struct virtqueue *vq)
>  {
> @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  	}
>  
>  	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> -		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> -			schedule_delayed_work(&vi->refill, 0);
> +		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> +			spin_lock(&vi->refill_lock);
> +			if (vi->refill_work_enabled)
> +				schedule_delayed_work(&vi->refill, 0);
> +			spin_unlock(&vi->refill_lock);

Are you sure you can use the basic spin_lock() flavor in all cases?
Isn't the disable/enable called from a different context than this
thing here?

The entire delayed work construct seems a little risky because the work
may go to sleep after disabling napi, causing large latency spikes.
I guess you must have a good reason no to simply reschedule the NAPI
and keep retrying with GFP_ATOMIC...

Please add the target tree name to the subject.
