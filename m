Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2460235849
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 18:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgHBQLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 12:11:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726775AbgHBQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 12:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596384673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJIGpigkfv/CoGy/dCJ0fruXGjZpHuxfk/VAoIvbyqk=;
        b=KV4tXJWm5XTxDWuFQIzVmH76Az8pXQVnpukbIdNtKoDcTD7BxOosHFW8Zvsa1fu6FoATzC
        OCg4+8rM/bzDam2O5NatrCajAG+YH88pbTueReGVuLBS7HUhLydZGGq30M4/NyECbWKpnU
        tWUUSKsT0ljTfBLzmEWx2RsM+mD1THA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-zFAWStEIM8Glzp-nLyLxuA-1; Sun, 02 Aug 2020 12:11:11 -0400
X-MC-Unique: zFAWStEIM8Glzp-nLyLxuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3950106B243;
        Sun,  2 Aug 2020 16:11:09 +0000 (UTC)
Received: from krava (unknown [10.40.192.18])
        by smtp.corp.redhat.com (Postfix) with SMTP id C6FFE5D9DC;
        Sun,  2 Aug 2020 16:11:07 +0000 (UTC)
Date:   Sun, 2 Aug 2020 18:11:06 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next] tools build: propagate build failures from
 tools/build/Makefile.build
Message-ID: <20200802161106.GA127459@krava>
References: <20200731024244.872574-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731024244.872574-1-andriin@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 07:42:44PM -0700, Andrii Nakryiko wrote:
> The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
> non-zero effect: the command failure is masked (despite `set -e`) and all but
> the first command of $(dep-cmd) is executed (successfully, as they are mostly
> printfs), thus overall returning 0 in the end.

nice, thanks for digging into this,
any idea why is the failure masked?

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

> 
> This means in practice that despite compilation errors, tools's build Makefile
> will return success. We see this very reliably with libbpf's Makefile, which
> doesn't get compilation error propagated properly. This in turns causes issues
> with selftests build, as well as bpftool and other projects that rely on
> building libbpf.
> 
> The fix is simple: don't use &&. Given `set -e`, we don't need to chain
> commands with &&. The shell will exit on first failure, giving desired
> behavior and propagating error properly.
> 
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> 
> I'm sending this against bpf-next tree, given libbpf is affected enough for me
> to debug this fun problem that no one seemed to notice (or care, at least) in
> almost 5 years. If there is a better kernel tree, please let me know.
> 
>  tools/build/Build.include | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/build/Build.include b/tools/build/Build.include
> index 9ec01f4454f9..585486e40995 100644
> --- a/tools/build/Build.include
> +++ b/tools/build/Build.include
> @@ -74,7 +74,8 @@ dep-cmd = $(if $(wildcard $(fixdep)),
>  #                   dependencies in the cmd file
>  if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
>                    @set -e;                                         \
> -                  $(echo-cmd) $(cmd_$(1)) && $(dep-cmd))
> +                  $(echo-cmd) $(cmd_$(1));                         \
> +                  $(dep-cmd))
>  
>  # if_changed      - execute command if any prerequisite is newer than
>  #                   target, or command line has changed
> -- 
> 2.24.1
> 

