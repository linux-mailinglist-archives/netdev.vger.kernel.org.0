Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7747E5319BD
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbiEWS3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244223AbiEWS17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C2213C1D1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:03:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB88B81219
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 18:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1835C385AA;
        Mon, 23 May 2022 18:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653328997;
        bh=uwUXmHOdUN258e/8u67bhWO6RMsD3iUhmw3VpFqzp78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hktbq3dzl8zZxgOfp07IazYvPCBRBw93F5Dm0hejQD2IWwZXqXiq7ixiqmgCTqn1+
         dPpLBlUBiA7Y1Mh+VjnTRR9oKx+9mqMxmlEvG8dpFemUkqJcz7yxTTzu2hqVKunFIk
         IQMmAik0itb9VdAfVBV/TSLfWi9iFQ7NBGLGZDOOEX5FZYDuUxLx/12NIudehfWuqc
         Aij2ZUk6dxZbqOicKYd+zFXh23rGnZH7bxUUmT7LqlgQN1L5lFW8DdqIbbUwoQ9G78
         bwVOIMgzbmdKS4g8MH3gGRU5aiTfsqQBnjirjkSkH0XRnEyDf0Yv3i9nRc5SK/44K5
         ByDdryr2qKIpg==
Date:   Mon, 23 May 2022 11:03:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 03/19] net: add dev_hold_track() and
 dev_put_track() helpers
Message-ID: <20220523110315.6f0637ed@kernel.org>
In-Reply-To: <20211202032139.3156411-4-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
        <20211202032139.3156411-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 19:21:23 -0800 Eric Dumazet wrote:
> +static inline void dev_hold_track(struct net_device *dev,
> +				  netdevice_tracker *tracker, gfp_t gfp)
> +{
> +	if (dev) {
> +		dev_hold(dev);
> +#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
> +		ref_tracker_alloc(&dev->refcnt_tracker, tracker, gfp);
> +#endif
> +	}
> +}
> +
> +static inline void dev_put_track(struct net_device *dev,
> +				 netdevice_tracker *tracker)
> +{
> +	if (dev) {
> +#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
> +		ref_tracker_free(&dev->refcnt_tracker, tracker);
> +#endif
> +		dev_put(dev);
> +	}
> +}

Hi Eric, how bad would it be if we renamed dev_hold/put_track() to
netdev_hold/put()? IIUC we use the dev_ prefix for "historic reasons"
could this be an opportunity to stop doing that?

