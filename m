Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632621B54B8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgDWGah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 02:30:37 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F36C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 23:30:37 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id B4C6BC01D; Thu, 23 Apr 2020 08:30:35 +0200 (CEST)
Date:   Thu, 23 Apr 2020 08:30:20 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is
 used
Message-ID: <20200423063020.GA31520@nautica>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-2-jhs@emojatatu.com>
 <20200422093531.4d9364c9@hermes.lan>
 <5a636d8d-e287-b553-b3fb-a62afbbde4ae@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a636d8d-e287-b553-b3fb-a62afbbde4ae@mojatatu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim wrote on Wed, Apr 22, 2020:
> >>diff --git a/lib/bpf.c b/lib/bpf.c
> >>index 10cf9bf4..656cad02 100644
> >>--- a/lib/bpf.c
> >>+++ b/lib/bpf.c
> >>@@ -1509,15 +1509,15 @@ out:
> >>  static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
> >>  				const char *todo)
> >>  {
> >>-	char *tmp = NULL;
> >>+	char tmp[PATH_MAX] = {};
> >
> >Initializing the whole string to 0 is over kill here.
> 
> Why is it overkill? ;->
> Note: I just replicated other parts of the same file which
> initialize similar array to 0.

FWIW I kind of agree this is overkill, there's only one other occurence
of a char * being explicitely zeroed, the rest isn't strings so probably
have better reasons to.

snprintf will safely zero-terminate it and nothing should ever access
past the nul byte so it shouldn't be necessary.

> >>  	char *rem = NULL;
> >>  	char *sub;
> >>  	int ret;
> >>-	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> >>+	ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));
> >
> >snprintf will never return -1.
> 
> Man page says it does. Practically it may not but we have code (in
> iproute2) which assumes it will happen.
> 
> Pick your poison:
> 1) Ignore the return code
> 2) As suggested by Dominique, something along the lines of:

(I also said I don't think it can ever fail in the non-wide-char variant
we use here (failure described in man page might be bad format string?
but we use a constant string here), and that the >= check is redundant
with the later strcat boundary checking ; by the same logic the words
you put in my mouth here are overkill as well :) (and the max size
variant would need some extra andling to set errno so check cannot be
shared that easily)
Anyway rest of iproute2 doesn't check snprintf return value much, it
should be fine to ignore)

> if (ret <= 0 || ret >= MAX_PATH)
>    ...error here..
> 
> Which one do you prefer?

-- 
Dominique
