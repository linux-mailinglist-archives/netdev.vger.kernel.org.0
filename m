Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B135450CE4A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 03:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbiDXCAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiDXCAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:00:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CE1A36E00
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 18:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650765432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mF6O9lh/P4rVHPLQSeYSJTiFD0hXfhYv4TWQuI6B0pM=;
        b=Go6YroW0xg7Ie8yZFtbcqDDpOUtk7fNRZYzilXxyF248kAJTjD/YReQxc/93dgXm7O7yuk
        fblpVaAjypGI26cWNf9HJzEpApwFFCcTeeSYJas4+Bio+C+CYxzuMwFLx68rxbdDn3RCfR
        HJBKkVWblPUjo68mKbGoNgMSt6I5yxM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-8Can3zfPOPGvCtm9cG69wg-1; Sat, 23 Apr 2022 21:57:11 -0400
X-MC-Unique: 8Can3zfPOPGvCtm9cG69wg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C9582A682;
        Sun, 24 Apr 2022 01:57:11 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-51.pek2.redhat.com [10.72.13.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28125111E3FD;
        Sun, 24 Apr 2022 01:57:01 +0000 (UTC)
Date:   Sun, 24 Apr 2022 09:56:57 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        toke@redhat.com, Paul Chaignon <paul@isovalent.com>
Subject: Re: [PATCH iproute2-next 1/3] libbpf: Use bpf_object__load instead
 of bpf_object__load_xattr
Message-ID: <YmSuaX7MUIqoNbC3@Laptop-X1>
References: <20220423152300.16201-1-dsahern@kernel.org>
 <20220423152300.16201-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423152300.16201-2-dsahern@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch revert c04e45d0 lib/bpf: fix verbose flag when using libbpf,
Should we set prog->log_level directly before it loaded, like
bpf_program__set_log_level() does?

Thanks
Hangbin
On Sat, Apr 23, 2022 at 09:22:58AM -0600, David Ahern wrote:
> bpf_object__load_xattr is deprecated as of v0.8+; remove it
> in favor of bpf_object__load.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  lib/bpf_libbpf.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> index f4f98caa1e58..f723f6310c28 100644
> --- a/lib/bpf_libbpf.c
> +++ b/lib/bpf_libbpf.c
> @@ -248,7 +248,6 @@ static int handle_legacy_maps(struct bpf_object *obj)
>  
>  static int load_bpf_object(struct bpf_cfg_in *cfg)
>  {
> -	struct bpf_object_load_attr attr = {};
>  	struct bpf_program *p, *prog = NULL;
>  	struct bpf_object *obj;
>  	char root_path[PATH_MAX];
> @@ -305,11 +304,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>  	if (ret)
>  		goto unload_obj;
>  
> -	attr.obj = obj;
> -	if (cfg->verbose)
> -		attr.log_level = 2;
> -
> -	ret = bpf_object__load_xattr(&attr);
> +	ret = bpf_object__load(obj);
>  	if (ret)
>  		goto unload_obj;
>  
> -- 
> 2.24.3 (Apple Git-128)
> 

