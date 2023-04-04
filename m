Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31716D65B5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjDDOrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjDDOq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:46:58 -0400
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE83E42;
        Tue,  4 Apr 2023 07:46:57 -0700 (PDT)
Received: by mail-qv1-f53.google.com with SMTP id m16so23523978qvi.12;
        Tue, 04 Apr 2023 07:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680619616; x=1683211616;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50IlSuqIBvdmyNXD4PyZ5L4D0RtsaJ6wD6o1J+jAgKo=;
        b=nagjYsilTLZcZ6a5N2IauoLESH3vii4U3LcW0/9ANubz3aKI8IvBufC5jGGpxOVtSv
         TZxousBeDJl4/NAkqHeuGKNy5djkJgUhewihTaPz9K66trJfUQ1BDW+DaBAyY+kp1RSC
         S12ED/zPCIVlvHtc9EP/2BGw6NmQNiwmq9TPTJD49SZd+qtEsbJeDme+GATK90WN9XQ/
         gPLEQ3SZSYulfjyr0WsY1tmklhxK5XnuDCuLz359ZI8g2XpBXuTpYiS3sn9ZlJL5muI5
         o2vSSNaLbbalklV9novFSF8qHrJ6vohHrpmryrU9oyOWuaj/0EhHSzzl5/RDUV9eMU0X
         IFXQ==
X-Gm-Message-State: AAQBX9d0aYKptMCArpr+eyHpg13BPY2H32TRwlYitlpygLV02XB6970E
        WG3EcQ0wLz0EDxrKMRYhdt8=
X-Google-Smtp-Source: AKy350Y57lkhGNKGusZTe1Ccjks7RAhfQWTFjJNaeggniN6HY1iRwt0FJlP6A1elPket790ozAS67g==
X-Received: by 2002:ad4:5dcb:0:b0:56e:b91f:aec4 with SMTP id m11-20020ad45dcb000000b0056eb91faec4mr3578035qvh.11.1680619615815;
        Tue, 04 Apr 2023 07:46:55 -0700 (PDT)
Received: from maniforge ([24.1.27.177])
        by smtp.gmail.com with ESMTPSA id mh10-20020a056214564a00b005dd8b9345d7sm3438042qvb.111.2023.04.04.07.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:46:55 -0700 (PDT)
Date:   Tue, 4 Apr 2023 09:46:52 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers
 accept NULL pointer.
Message-ID: <20230404144652.GA3896@maniforge>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404045029.82870-5-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404045029.82870-5-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:50:25PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_[sk|inode|task|cgrp]_storage_[get|delete]() and bpf_get_socket_cookie() helpers
> perform run-time check that sk|inode|task|cgrp pointer != NULL.
> Teach verifier about this fact and allow bpf programs to pass
> PTR_TO_BTF_ID | PTR_MAYBE_NULL into such helpers.
> It will be used in the subsequent patch that will do
> bpf_sk_storage_get(.., skb->sk, ...);
> Even when 'skb' pointer is trusted the 'sk' pointer may be NULL.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/bpf_cgrp_storage.c  | 4 ++--
>  kernel/bpf/bpf_inode_storage.c | 4 ++--
>  kernel/bpf/bpf_task_storage.c  | 8 ++++----
>  net/core/bpf_sk_storage.c      | 4 ++--
>  net/core/filter.c              | 2 +-
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
> index d17d5b694668..d44fe8dd9732 100644
> --- a/kernel/bpf/bpf_cgrp_storage.c
> +++ b/kernel/bpf/bpf_cgrp_storage.c
> @@ -224,7 +224,7 @@ const struct bpf_func_proto bpf_cgrp_storage_get_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &bpf_cgroup_btf_id[0],
>  	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg4_type	= ARG_ANYTHING,
> @@ -235,6 +235,6 @@ const struct bpf_func_proto bpf_cgrp_storage_delete_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &bpf_cgroup_btf_id[0],
>  };
> diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
> index e17ad581b9be..a4d93df78c75 100644
> --- a/kernel/bpf/bpf_inode_storage.c
> +++ b/kernel/bpf/bpf_inode_storage.c
> @@ -229,7 +229,7 @@ const struct bpf_func_proto bpf_inode_storage_get_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
>  	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg4_type	= ARG_ANYTHING,
> @@ -240,6 +240,6 @@ const struct bpf_func_proto bpf_inode_storage_delete_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
>  };
> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> index d1af0c8f9ce4..adf6dfe0ba68 100644
> --- a/kernel/bpf/bpf_task_storage.c
> +++ b/kernel/bpf/bpf_task_storage.c
> @@ -338,7 +338,7 @@ const struct bpf_func_proto bpf_task_storage_get_recur_proto = {
>  	.gpl_only = false,
>  	.ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg1_type = ARG_CONST_MAP_PTR,
> -	.arg2_type = ARG_PTR_TO_BTF_ID,
> +	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
>  	.arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg4_type = ARG_ANYTHING,
> @@ -349,7 +349,7 @@ const struct bpf_func_proto bpf_task_storage_get_proto = {
>  	.gpl_only = false,
>  	.ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg1_type = ARG_CONST_MAP_PTR,
> -	.arg2_type = ARG_PTR_TO_BTF_ID,
> +	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
>  	.arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg4_type = ARG_ANYTHING,
> @@ -360,7 +360,7 @@ const struct bpf_func_proto bpf_task_storage_delete_recur_proto = {
>  	.gpl_only = false,
>  	.ret_type = RET_INTEGER,
>  	.arg1_type = ARG_CONST_MAP_PTR,
> -	.arg2_type = ARG_PTR_TO_BTF_ID,
> +	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
>  };
>  
> @@ -369,6 +369,6 @@ const struct bpf_func_proto bpf_task_storage_delete_proto = {
>  	.gpl_only = false,
>  	.ret_type = RET_INTEGER,
>  	.arg1_type = ARG_CONST_MAP_PTR,
> -	.arg2_type = ARG_PTR_TO_BTF_ID,
> +	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
>  };
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 085025c7130a..d4172534dfa8 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -412,7 +412,7 @@ const struct bpf_func_proto bpf_sk_storage_get_tracing_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
>  	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
>  	.arg4_type	= ARG_ANYTHING,
> @@ -424,7 +424,7 @@ const struct bpf_func_proto bpf_sk_storage_delete_tracing_proto = {
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
>  	.arg1_type	= ARG_CONST_MAP_PTR,
> -	.arg2_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
>  	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
>  	.allowed	= bpf_sk_storage_tracing_allowed,
>  };

Should we also add PTR_MAYBE_NULL to the ARG_PTR_TO_BTF_ID_SOCK_COMMON
arg in bpf_sk_storage_get_proto and bpf_sk_storage_delete_proto?

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1f2abf0f60e6..727c5269867d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4998,7 +4998,7 @@ const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto = {
>  	.func		= bpf_get_socket_ptr_cookie,
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
> -	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON | PTR_MAYBE_NULL,
>  };
>  
>  BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
> -- 
> 2.34.1
> 
