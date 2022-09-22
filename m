Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A275E64E1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiIVOO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiIVOOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:14:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310CD3CBDB;
        Thu, 22 Sep 2022 07:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEFD2B8376C;
        Thu, 22 Sep 2022 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BACC433D6;
        Thu, 22 Sep 2022 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663856089;
        bh=LpDsfUiZsVGanIM4Gs2BdJkChHrUyvu7yHYD+XKozOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qaMsdqToEy27LU98ts7fgQHvlODXa0ihV5wE5g6iKGyI0Y3a8dOqG5rxbRYiCTFN0
         yVkjHCUCAFyN3PXu9HWeHirwwjcMYk5Vh3dKwqEJ9kicIAm2b2fAXbRjAN+zeYvqE+
         mJVMWpF1nDeZcbgiag3ooEjVN6fii+X16nzwr6I5iylB2puFPdAs6X7a/wkZfzDKBL
         q3mKbzEno7nZJjjxgDGFRrTCnfqrkhlvGbkJuVm3Q1wD1v7vO+Lsa258ykGatrL/yR
         iuLVf5Hw4WjvIqij5sx/a+bHiXSk/HIHx+fRUDDULPhZ+ZdiFjlIYpEpNTohkV/Z1F
         0RxXxYO9oM9TQ==
Date:   Thu, 22 Sep 2022 07:14:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        paulb@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: act_ct: fix possible refcount leak in
 tcf_ct_init()
Message-ID: <20220922071448.4f4eb475@kernel.org>
In-Reply-To: <20220921090600.29673-1-hbh25y@gmail.com>
References: <20220921090600.29673-1-hbh25y@gmail.com>
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

On Wed, 21 Sep 2022 17:06:00 +0800 Hangyu Hua wrote:
> Subject: [PATCH] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

[PATCH net] please

> nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
> to avoid possible refcount leak when tcf_ct_flow_table_get fails.
> 
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/sched/act_ct.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index d55afb8d14be..3646956fc717 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1412,6 +1412,8 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>  cleanup:
>  	if (goto_ch)
>  		tcf_chain_put_by_act(goto_ch);
> +	if (params->tmpl)
> +		nf_ct_put(params->tmpl);

This is buggy, params could be NULL here. Please add a new label above
cleanup (cleanup_params for example) and make the
tcf_ct_flow_table_get() failure path jump there instead.
