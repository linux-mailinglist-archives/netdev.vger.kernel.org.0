Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AA55BEA84
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiITPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiITPuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA9A4B0D9;
        Tue, 20 Sep 2022 08:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE2D2B82AE8;
        Tue, 20 Sep 2022 15:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFADC433B5;
        Tue, 20 Sep 2022 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689007;
        bh=FIFrickRT5IR27TOEhl7VCKk7I3dAiMuoEyZVAqQngo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gd80cjg6WTiLPonE5Os7ZgYbBCnFUZvauLqfYYJ9PpXKpcQZBpAtj0Eq/qT60Gocg
         /uWQ05K04Ei+VUUcySKTfWKyZe/8doobk1WSIjZ/7eh2VIr3n8zUd+axpcCXfuoqjy
         r+LNq/Xck3N/Ou4VCQA2yxDxGOX+S9wpF8UQwlvFW6gN2gkOr3GyN7WgGNqMUw9dEE
         Yf5NYv1iPN1QbPnZKNGUJlQ0yJiG4qwCbgjaLdCJEonur+2YwzEcuAYM52vTwqbzXH
         N67Ot144bxgWT0umkf3iqsmoEW/jtY2aoeCbZNsMA/8Otl38OYKsDsuckDIru5w1CP
         WeWIgGQQTdF+w==
Date:   Tue, 20 Sep 2022 08:50:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix possible refcount leak in
 tc_new_tfilter()
Message-ID: <20220920085006.32c743be@kernel.org>
In-Reply-To: <20220915085804.20894-1-hbh25y@gmail.com>
References: <20220915085804.20894-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Sep 2022 16:58:04 +0800 Hangyu Hua wrote:
> tfilter_put need to be called to put the refount got by tp->ops->get to

s/refount/refcount/

> avoid possible refcount leak when chain->tmplt_ops == NULL or
> chain->tmplt_ops != tp->ops.

This should say:

  when cain->tmplt_ops != NULL and ...

otherwise the commit message does not match the code.

> Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/sched/cls_api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 790d6809be81..51d175f3fbcb 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2137,6 +2137,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	}
>  
>  	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
> +		tfilter_put(tp, fh);
>  		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
>  		err = -EINVAL;
>  		goto errout;

