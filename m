Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7933C4C9AC8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiCBB4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiCBB4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEABF60CE1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 17:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED8861605
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF06C340EE;
        Wed,  2 Mar 2022 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646186154;
        bh=gQyboF7DDHW5AzlwmX9W3VMczqtDNDDhIiHjEGVzFTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i505Dk57r4nnjl3jomLjt5e2GJRUDupABpvmkhb2oSE9MyOkGumfsrUUV+b2dR9NN
         H5KKEAJtOtAGv7hfUWUlICGaf8eTa+Q0thbCS9wjy5dZgVECdr6+w5myjyA/eeKE+h
         EuKNA6EhBdS3iCr8V2+Sz3xZW2qXS+HIf3Tr5UlDORsJ5etaRClrVDKKnMtWnPVkrW
         z6V7HvUfp1fBdgELWwksWnDpDwlmvlerUdfjtrQ1fQ6AjdZ5gKqH1iM5tb238KsaoV
         H585nlQjMfiYTSGLJQmANRK/e7PwNyesS3lRMlbYtQ+nT2FWpi3kgK6GDJgpIcbAMm
         DOWxPAqeg1/9A==
Date:   Tue, 1 Mar 2022 17:55:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     davem@davemloft.net, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, roid@nvidia.com, oss-drivers@corigine.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v1] flow_offload: improve extack msg for user
 when adding invalid filter
Message-ID: <20220301175553.55274863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
References: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
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

On Mon, 28 Feb 2022 18:44:15 +0800 Baowen Zheng wrote:
> Add extack message to return exact message to user when adding invalid
> filter with conflict flags for TC action.
> 
> In previous implement we just return EINVAL which is confusing for user.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> ---
>  net/sched/act_api.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index ca03e72..eb0d7bd 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1446,6 +1446,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  				continue;
>  			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
>  			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Conflict occurs for TC action and filter flags");

Good improvement but I think we can reword a little, how about:

"Mismatch between action and filter offload flags" ?

>  				err = -EINVAL;
>  				goto err;
>  			}

