Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D96B8685
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCNADE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNADD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:03:03 -0400
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2398E8ABE2;
        Mon, 13 Mar 2023 17:02:45 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id s23so9455018uae.5;
        Mon, 13 Mar 2023 17:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678752164;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbdndxFOJWyha9TEPIcXkLFnCMKWrl0RV6CcuU9J1v8=;
        b=mCndW13wwGxlEcdjz2Q6C/CGeolIK/v3KKi00bKgcwVbP8U/bqlPegD5mlBHAHoV61
         fZaT4kIbdy6NwDjpxYQ37ShENq9c7dLALxa4CQZQsBJr2icxZSb6o0nufay/03+I/1RB
         XTXH/SJlGx3OqJ4ovjpZQfuEtxfkicmEN14ufSCesqcIEoaZzBuPqRAF3FpTfBkCgnKw
         R2rmHW/0tJjBDQh2VUyPliieB4A1ACmbJI8rQCJ/s1T9tDhVkGpdi64oi0oIzKol4X/W
         u0z/3htZn3SaAJo8oOOhNu89Uo4QBHNgjAcohbtdXwwKDiOVePgaMvVz7xuObeDWTS4S
         k5jA==
X-Gm-Message-State: AO0yUKVhfgi51G7jz/FXZFliaAtOT6PDPhh34TVwv3o/a9hFR2x//4v4
        itTjywSQ6hqWYF/zNgFYb8w=
X-Google-Smtp-Source: AK7set9BNIjDEiwmUM4SEBC/I0ihoKqPLJPWfxNIDmb84UusYBIKGOH5OKbQuRq+pBAJMJcMcC2I7g==
X-Received: by 2002:a1f:9d08:0:b0:432:125:3784 with SMTP id g8-20020a1f9d08000000b0043201253784mr1958613vke.16.1678752164036;
        Mon, 13 Mar 2023 17:02:44 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:b967])
        by smtp.gmail.com with ESMTPSA id o24-20020a05620a229800b007441b675e81sm677797qkh.22.2023.03.13.17.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 17:02:43 -0700 (PDT)
Date:   Mon, 13 Mar 2023 19:02:41 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Fix bpf_strncmp proto.
Message-ID: <20230314000241.GA202344@maniforge>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
 <20230313235845.61029-2-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313235845.61029-2-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:58:43PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_strncmp() doesn't write into its first argument.
> Make sure that the verifier knows about it.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>

> ---
>  kernel/bpf/helpers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 77d64b6951b9..f753676ef652 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -571,7 +571,7 @@ static const struct bpf_func_proto bpf_strncmp_proto = {
>  	.func		= bpf_strncmp,
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
> -	.arg1_type	= ARG_PTR_TO_MEM,
> +	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
>  	.arg2_type	= ARG_CONST_SIZE,
>  	.arg3_type	= ARG_PTR_TO_CONST_STR,
>  };
> -- 
> 2.34.1
> 
