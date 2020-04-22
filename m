Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C171B37AE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgDVGmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:42:32 -0400
Received: from nautica.notk.org ([91.121.71.147]:38194 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgDVGmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 02:42:32 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 493BBC009; Wed, 22 Apr 2020 08:42:30 +0200 (CEST)
Date:   Wed, 22 Apr 2020 08:42:15 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, aclaudi@redhat.com, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is
 used
Message-ID: <20200422064215.GA17201@nautica>
References: <20200421180426.6945-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200421180426.6945-1-jhs@emojatatu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(random review)

Jamal Hadi Salim wrote on Tue, Apr 21, 2020:
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 10cf9bf4..cf636c9e 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1509,12 +1509,12 @@ out:
>  static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>  				const char *todo)
>  {
> -	char *tmp = NULL;
> +	char tmp[PATH_MAX] = {};
>  	char *rem = NULL;
>  	char *sub;
>  	int ret;
>  
> -	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> +	ret = sprintf(tmp, "%s/../", bpf_get_work_dir(ctx->type));
>  	if (ret < 0) {
>  		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));

error check needs to be reworded, and it probably needs to use snprintf
instead of sprintf: bpf_get_work_dir() can be up to PATH_MAX long and as
pointed out there are strcat() afterwards so it's still possible to
overflow this one

-- 
Dominique
