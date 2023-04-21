Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A486EA1B4
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbjDUCgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUCgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709AB2680
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1B164079
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15290C433D2;
        Fri, 21 Apr 2023 02:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682044602;
        bh=Md6mB7+PpLVJCjeyfAi6BAqWlAddx4JFXCSWReooMi8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IRDV/udIzLwHwFlD3lAveBSjU6RS/69Mzu3NOmwg4rcCcGfQr80gd140Yx1NOewrT
         x+OJKwlyT/h6jxP3KgoCgOniE7W9hyEBiYKcpH9nvzYVd92JAjQfwPrL418Q867vHE
         QwWhnjahu7+G783jAB7MpB7JT26a1sNZHjtFvsQN6pTGyoIqlQ6x73r8DPoDqOcsmM
         ZRk+xN7lV0gIXDifPOhAkRE/ul0KYmx4GDPwMMIjLHclZ07PLdzwftssVauI2b84oT
         HtXLieUSR+zpq//izsoz0OQcbDZ1adrPYCKVi7gj7+gRFF/vptveWUXP1hL+xs+lyO
         8gxVDKXjdtTQA==
Date:   Thu, 20 Apr 2023 19:36:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 2/5] net/sched: act_pedit: use extack in
 'ex' parsing errors
Message-ID: <20230420193640.028e69cd@kernel.org>
In-Reply-To: <20230418234354.582693-3-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
        <20230418234354.582693-3-pctammela@mojatatu.com>
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

On Tue, 18 Apr 2023 20:43:51 -0300 Pedro Tammela wrote:
> -		if (nla_type(ka) != TCA_PEDIT_KEY_EX)
> +		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
> +			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
>  			goto err_out;
> +		}

This is a check on ka, we should use NL_SET_ERR_MSG_ATTR()

>  		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
>  		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
>  
>  		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
> -		    k->cmd > TCA_PEDIT_CMD_MAX)
> +		    k->cmd > TCA_PEDIT_CMD_MAX) {
> +			NL_SET_ERR_MSG_MOD(extack, "Extended key is malformed");

And these are checks for tb[TCA_PEDIT_KEY_EX_HTYPE] and
tb[TCA_PEDIT_KEY_EX_CMD], should be part of the parsing policy.
-- 
pw-bot: cr
