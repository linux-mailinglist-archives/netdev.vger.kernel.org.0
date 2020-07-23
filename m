Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B87322A6FA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGWFio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgGWFio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 01:38:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3540C0619DC;
        Wed, 22 Jul 2020 22:38:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d7so2037078plq.13;
        Wed, 22 Jul 2020 22:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Onkxxt1KvjHNTiaY1A1kT/O/mITa9ddnS/eXBAaG1Z4=;
        b=dP/aXDOAmB2s0o55uGvwL3qUYygREi9gvUsxYQVfazZlAJQrq2e6fcluIcWbCzc+CQ
         PvOZgC5n/8F8FxWf2IOzchy/l+bjdocaqkVmnR187nrWHbu0kS6/PL3DpCrsxBvVt7KX
         cQbSFFDj2qTglf8OtpfYquX2o1Ms1loWs5IkjlzvNP/El2sy8f8oPmWu2GNcJBstAq9C
         +GHkuMKsIAoxzgrFnUgYoNOCieGfCC/fk8U83pPK8NcocSuxxua9ZvJ7erkgS1KBQtXg
         IHNus1xY0FP1qX0GA6pg7QBw5mEn2E48BcpnbjRxIfgJpCl4gYzbd//MU/HBQoyZOnqX
         D/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Onkxxt1KvjHNTiaY1A1kT/O/mITa9ddnS/eXBAaG1Z4=;
        b=GhhP7ceVo9C25aqQKkAOB4vE4d+GOofP/3u65LhZ8gGYbWe3MmYgfCFgc2FzdgpDQD
         hrrsIZJ87lWRwbaf+/Q5d77F0XRvzPr5UeGJ0GeNxMu1szQYqYdq8PreJJV0wBNscS5y
         yIUqmujaBUIEWAI7xqS1/PxE1Igeo0mmA69Xbk68vRbJE+Xk6M+G4KUsprT44Nd1fzTA
         CdQgPva/Vu4viUIUzOab3IGjDc/Zmn0DIBzqvm4STMCVabJhi2m0HEkwXPPBsxytlP5a
         eBXt09X717iBWbMwfnur6o2J1KtOB5NgM8sR7nCnLhbyQQQV2Wuv05DkNh6l9U1Twlm5
         L67g==
X-Gm-Message-State: AOAM530yXocR+o2ftbU+RnyX0Bfpkz3O6E1EBnwU84RY5IK4SdTwrh7w
        hlnSVONie54PHQuGnr4ZuzB4bkMq
X-Google-Smtp-Source: ABdhPJyROstPbS4hBgLk3I6F/PiyY0WzIDNN5S6OkRoPuA15UAquJz9iccdRqNQfGClbQFJwLk9qbQ==
X-Received: by 2002:a17:90a:1a83:: with SMTP id p3mr2489156pjp.113.1595482723166;
        Wed, 22 Jul 2020 22:38:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6cd6])
        by smtp.gmail.com with ESMTPSA id v197sm1477385pfc.35.2020.07.22.22.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 22:38:42 -0700 (PDT)
Date:   Wed, 22 Jul 2020 22:38:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 01/13] bpf: refactor bpf_iter_reg to have
 separate seq_info member
Message-ID: <20200723053840.tnqzumivvtjwy3tv@ast-mbp.dhcp.thefacebook.com>
References: <20200722184945.3777103-1-yhs@fb.com>
 <20200722184945.3777163-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722184945.3777163-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:49:45AM -0700, Yonghong Song wrote:
> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
> index 8a7af11b411f..5812dd465c49 100644
> --- a/kernel/bpf/map_iter.c
> +++ b/kernel/bpf/map_iter.c
> @@ -85,17 +85,21 @@ static const struct seq_operations bpf_map_seq_ops = {
>  BTF_ID_LIST(btf_bpf_map_id)
>  BTF_ID(struct, bpf_map)
>  
> -static struct bpf_iter_reg bpf_map_reg_info = {
> -	.target			= "bpf_map",
> +static const struct bpf_iter_seq_info bpf_map_seq_info = {
>  	.seq_ops		= &bpf_map_seq_ops,
>  	.init_seq_private	= NULL,
>  	.fini_seq_private	= NULL,
>  	.seq_priv_size		= sizeof(struct bpf_iter_seq_map_info),
> +};
> +
> +static struct bpf_iter_reg bpf_map_reg_info = {
> +	.target			= "bpf_map",
>  	.ctx_arg_info_size	= 1,
>  	.ctx_arg_info		= {
>  		{ offsetof(struct bpf_iter__bpf_map, map),
>  		  PTR_TO_BTF_ID_OR_NULL },
>  	},
> +	.seq_info		= &bpf_map_seq_info,
>  };

ahh. this patch needs one more rebase, since I've just added prog_iter.
Could you please respin ? Thanks!
