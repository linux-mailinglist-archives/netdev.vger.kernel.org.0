Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18E478579
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhLQHPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:15:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhLQHPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639725340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GR0sKV1OmyajdrC5EdKIxUmb2SIi6tOJAjcljTx1eQw=;
        b=VHXrKyMt4F5kUG+nTnfaz7SvIp6CrSUFX9ZGfKKVCY9xfRQLy/Ue7+oHG09FuIQOoA4fTW
        9aO1/oruFa12xgfhRKJsdZJkQ5+PmZG84hV2HMPn5BOMTwR8OE0T5/ENQTikytszvBT2QD
        7xYMTIFGYCdhxUj/UyphblUb5eqE4Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-e1ryPz7YPCqr5YJCcnkpmA-1; Fri, 17 Dec 2021 02:15:38 -0500
X-MC-Unique: e1ryPz7YPCqr5YJCcnkpmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A9768015CD;
        Fri, 17 Dec 2021 07:15:37 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-50.pek2.redhat.com [10.72.13.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6015827C31;
        Fri, 17 Dec 2021 07:15:35 +0000 (UTC)
Date:   Fri, 17 Dec 2021 15:15:31 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Paul Chaignon <paul@isovalent.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] lib/bpf: fix verbose flag when using libbpf
Message-ID: <Ybw5EwPCzZXeaWip@Laptop-X1>
References: <20211216153336.GA30454@Mem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216153336.GA30454@Mem>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 04:33:36PM +0100, Paul Chaignon wrote:
> Since commit 6d61a2b55799 ("lib: add libbpf support"), passing the
> verbose flag to tc filter doesn't dump the verifier logs anymore in case
> of successful loading.
> 
> This commit fixes it by setting the log_level attribute before loading.
> To that end, we need to call bpf_object__load_xattr directly instead of
> relying on bpf_object__load.
> 
> Fixes: 6d61a2b55799 ("lib: add libbpf support")
> Signed-off-by: Paul Chaignon <paul@isovalent.com>
> ---
>  lib/bpf_libbpf.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> index dbec2cb5..b992a62c 100644
> --- a/lib/bpf_libbpf.c
> +++ b/lib/bpf_libbpf.c
> @@ -246,6 +246,7 @@ static int handle_legacy_maps(struct bpf_object *obj)
>  
>  static int load_bpf_object(struct bpf_cfg_in *cfg)
>  {
> +	struct bpf_object_load_attr attr = {};
>  	struct bpf_program *p, *prog = NULL;
>  	struct bpf_object *obj;
>  	char root_path[PATH_MAX];
> @@ -302,7 +303,11 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>  	if (ret)
>  		goto unload_obj;
>  
> -	ret = bpf_object__load(obj);
> +	attr.obj = obj;
> +	if (cfg->verbose) {
> +		attr.log_level = 2;
> +	}

nit: no need the curly braces when this is only 1 line

> +	ret = bpf_object__load_xattr(&attr);
>  	if (ret)
>  		goto unload_obj;
>  

Thanks for the fixes.

Acked-by: Hangbin Liu <haliu@redhat.com>

