Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6216E8728
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjDTBIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTBIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F474448E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 184CD60C6E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E245C433D2;
        Thu, 20 Apr 2023 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681952913;
        bh=b4ES3WtXJgJHKqB9UPDJ554dfqIJEOX3ncaBn3z7oKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMTI2MK2hiBH1VOybYqngf0+yGfJRDhzbpK0y3AnggS+PVs9Jp/Tj71HjUOh8/Hi0
         7rhoK0uJN7Mc8I7JVCymIFcBNM8oEKcw4vFdpiVLVJLbO6RHXAXjsmFWF1+7lWkhHc
         pY/7OXIC4n24OgmCoB/5sf8USP4CHI2766IR/QpOg+VrX1C13849BeTWj+UQ/vCYvv
         s83PP3rJFlrUGZeIpZIPT7zuyxK7E3R2T6vBGBDTTBViFwJI1a18ZXcvEhJBGeewOi
         aSlxTVfOPa22lZg7hXgdIRLGjeh3kyH8iWcaZQ2haf9uorAuvP4gF7OmIqhl6FMnqr
         Ch2yEKgHSpjRQ==
Date:   Wed, 19 Apr 2023 18:08:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/4] net/sched: sch_htb: use extack on
 errors messages
Message-ID: <20230419180832.3f0b7729@kernel.org>
In-Reply-To: <20230417171218.333567-2-pctammela@mojatatu.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
        <20230417171218.333567-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 14:12:15 -0300 Pedro Tammela wrote:
> @@ -1917,8 +1917,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  			};
>  			err = htb_offload(dev, &offload_opt);
>  			if (err) {
> -				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
> -				       err);
> +				NL_SET_ERR_MSG(extack,
> +					       "Failed to offload leaf alloc queue");
>  				goto err_kill_estimator;
>  			}
>  			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
> @@ -1937,8 +1937,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  			};
>  			err = htb_offload(dev, &offload_opt);
>  			if (err) {
> -				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
> -				       err);
> +				NL_SET_ERR_MSG(extack,
> +					       "Failed to offload leaf to inner");

I missed the message changes on v1, but since the patches are already
Changes Requested in patchwork...

IDK what TC_HTB_LEAF_TO_INNER is exactly, neither do I understand
"Failed to offload leaf to inner". The first one should be "Failed to
alloc offload leaf queue" if anything.

Let's just stick to the existing messages?
