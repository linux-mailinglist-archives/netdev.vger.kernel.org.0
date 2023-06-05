Return-Path: <netdev+bounces-8136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F280722DE2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7E3A281370
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420D32108D;
	Mon,  5 Jun 2023 17:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3167AAD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:50:22 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47896D3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:50:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fa457686eso3404396a12.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 10:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685987421; x=1688579421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAyEU5PWgb7lLVlWz8+HVW9lHiqiJz7UJIxUfhkLCOM=;
        b=ISE/8qZVLnVLXkzdrz6ZIuHd9FBM//etguaf2WtwjVcQg7U4UZ0ZkRd15OHplXc6Vu
         fSZSLXu+vquwJUg5mzoBUULQXmrwFMrZVl+SVTN47YCRH1Da8g+KxYGd/6t+grGt0SI0
         ms47JavRD8qKwLvGdCR6a+TPwBCbgvbaPSt44IC/yzi25g9b8TKccTR5gvdGAo7HWSo3
         GSiaHlg4Aogy+bVQsqmT1e65KNc1ZNaMeek0Fp3V61Fl3AgcEs2tJLyaQLeNBlKKmRnE
         SgibzEAtNz6Bf9NWVZ7PUtwxvOZ82/QOlJAkvFS+MHWxyGkl2060EnQxuToscH90UYzI
         ZrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987421; x=1688579421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAyEU5PWgb7lLVlWz8+HVW9lHiqiJz7UJIxUfhkLCOM=;
        b=YbRyT7YxsBlZFHhFHQN5Elx0MRSisqi4yjzppA/EO/CcPPl7Sey6OYFPusnkdk/ZZh
         R5t2q2SIvfJ7x9Ajbj1yZcvHLyAPldb8BXCapAMa6pksOrRvxOpDZqdhSJkdtfedAw1V
         uE72DlcfJ6HN3fUHz6JBSKDdNmOm53LxM3DOxWHSGfFd3zT5re8oM62y6fCf2UM/51Wg
         +BL7XrDRWMxK4qdDrlL14ffusfWMQ8SFQlRk4mt+ZwI+4/zT6pkgG6+fn94B63RJYLp9
         k8CHnh91QrtydxKKtibNP/5k0tpilqF0l+L6AfQg/DwwtsbJnW/KZvEJDKWCQCAZ+M7t
         EeSA==
X-Gm-Message-State: AC+VfDxWrApTMHww6AiShlyaJEgnRlQCRIcWB8FU9Y16g7tQlqxcGluS
	QdP7wBEJ1fy2eWpD7mzQOiwYWoM=
X-Google-Smtp-Source: ACHHUZ6H8YSe8eyPE6eVvMter0ObhjOOeQRmHBnIDEdX7pA6OqKKfSLFBSw1URCk+uxz1f4ADap+z7g=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ea82:b0:1ab:19db:f57 with SMTP id
 x2-20020a170902ea8200b001ab19db0f57mr1940631plb.2.1685987420765; Mon, 05 Jun
 2023 10:50:20 -0700 (PDT)
Date: Mon, 5 Jun 2023 10:50:19 -0700
In-Reply-To: <20230604175843.662084-3-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230604175843.662084-1-kuba@kernel.org> <20230604175843.662084-3-kuba@kernel.org>
Message-ID: <ZH4gW5WIzMZe4oF5@google.com>
Subject: Re: [PATCH net-next v2 2/4] tools: ynl: user space helpers
From: Stanislav Fomichev <sdf@google.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/04, Jakub Kicinski wrote:
> Add "fixed" part of the user space Netlink Spec-based library.
> This will get linked with the protocol implementations to form
> a full API.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: fix up kdoc
> ---
>  .../userspace-api/netlink/intro-specs.rst     |  79 ++
>  tools/net/ynl/Makefile                        |  19 +
>  tools/net/ynl/generated/Makefile              |  45 +
>  tools/net/ynl/lib/Makefile                    |  28 +
>  tools/net/ynl/lib/ynl.c                       | 901 ++++++++++++++++++
>  tools/net/ynl/lib/ynl.h                       | 237 +++++
>  tools/net/ynl/ynl-regen.sh                    |   2 +-
>  7 files changed, 1310 insertions(+), 1 deletion(-)
>  create mode 100644 tools/net/ynl/Makefile
>  create mode 100644 tools/net/ynl/generated/Makefile
>  create mode 100644 tools/net/ynl/lib/Makefile
>  create mode 100644 tools/net/ynl/lib/ynl.c
>  create mode 100644 tools/net/ynl/lib/ynl.h
> 
> diff --git a/Documentation/userspace-api/netlink/intro-specs.rst b/Documentation/userspace-api/netlink/intro-specs.rst
> index a3b847eafff7..bada89699455 100644
> --- a/Documentation/userspace-api/netlink/intro-specs.rst
> +++ b/Documentation/userspace-api/netlink/intro-specs.rst
> @@ -78,3 +78,82 @@ to see other examples.
>  The code generation itself is performed by ``tools/net/ynl/ynl-gen-c.py``
>  but it takes a few arguments so calling it directly for each file
>  quickly becomes tedious.
> +
> +YNL lib
> +=======
> +
> +``tools/net/ynl/lib/`` contains an implementation of a C library
> +(based on libmnl) which integrates with code generated by
> +``tools/net/ynl/ynl-gen-c.py`` to create easy to use netlink wrappers.
> +
> +YNL basics
> +----------
> +
> +The YNL library consists of two parts - the generic code (functions
> +prefix by ``ynl_``) and per-family auto-generated code (prefixed
> +with the name of the family).
> +
> +To create a YNL socket call ynl_sock_create() passing the family
> +struct (family structs are exported by the auto-generated code).
> +ynl_sock_destroy() closes the socket.
> +
> +YNL requests
> +------------
> +
> +Steps for issuing YNL requests are best explained on an example.
> +All the functions and types in this example come from the auto-generated
> +code (for the netdev family in this case):
> +
> +.. code-block:: c
> +
> +   // 0. Request and response pointers
> +   struct netdev_dev_get_req *req;
> +   struct netdev_dev_get_rsp *d;
> +
> +   // 1. Allocate a request
> +   req = netdev_dev_get_req_alloc();
> +   // 2. Set request parameters (as needed)
> +   netdev_dev_get_req_set_ifindex(req, ifindex);
> +
> +   // 3. Issues the request
> +   d = netdev_dev_get(ys, req);
> +   // 4. Free the request arguments
> +   netdev_dev_get_req_free(req);
> +   // 5. Error check (the return value from step 3)
> +   if (!d) {
> +	// 6. Print the YNL-generated error
> +	fprintf(stderr, "YNL: %s\n", ys->err.msg);
> +        return -1;
> +   }
> +
> +   // ... do stuff with the response @d
> +
> +   // 7. Free response
> +   netdev_dev_get_rsp_free(d);

General API question: do we have to have all those alloc/free calls?
Why not have the following instead?

	struct netdev_dev_get_req req;
	struct netdev_dev_get_rsp rsp;
	
	netdev_dev_get_req_set_ifindex(&req, ifindex);
	netdev_dev_get(ys, &req, &rsp);

You seem to be doing malloc(*rsp) anyway in netdev_dev_get, so
why not push that choice (heap/stack) on the users?

(haven't looked too closely at the series, so maybe a stupid question)

