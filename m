Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02469226F2B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbgGTTo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:44:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45440 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgGTTo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 15:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595274268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HC5UAjDRVsdfTpsMCh9Zw/Ckp6Oa7vCzS7C7bc7mamo=;
        b=hxuNYDe5j4NKkeRN5k15Y2fTnM9cwcLm1o0K36j1PzD/Bw2oscokkRgTBxff+zgBCxNi3D
        5/ajqKNyXQbOPEZnkmby8/kvERYScaufST1KCHalm8CsuMwJSvRFLyRD0PVVCsnkkQTNvA
        lH64Yn122favFUQx3nZ1LAwc5cVW0JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-aSK-ujNXNsi0ygle9tP34Q-1; Mon, 20 Jul 2020 15:44:24 -0400
X-MC-Unique: aSK-ujNXNsi0ygle9tP34Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0744951;
        Mon, 20 Jul 2020 19:44:22 +0000 (UTC)
Received: from krava (unknown [10.40.194.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id E992C2DE9F;
        Mon, 20 Jul 2020 19:44:19 +0000 (UTC)
Date:   Mon, 20 Jul 2020 21:44:18 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 2/5] tools/bpf: sync btf_ids.h to tools
Message-ID: <20200720194418.GN760733@krava>
References: <20200720163358.1392964-1-yhs@fb.com>
 <20200720163359.1393079-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720163359.1393079-1-yhs@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:33:59AM -0700, Yonghong Song wrote:
> Sync kernel header btf_ids.h to tools directory.
> Also define macro CONFIG_DEBUG_INFO_BTF before
> including btf_ids.h in prog_tests/resolve_btfids.c
> since non-stub definitions for BTF_ID_LIST etc. macros
> are defined under CONFIG_DEBUG_INFO_BTF. This
> prevented test_progs from failing.

I was going to send this with the d_path change ;-)

thanks,
jirka

> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/include/linux/btf_ids.h                         | 11 ++++++++++-
>  .../testing/selftests/bpf/prog_tests/resolve_btfids.c |  1 +
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> index fe019774f8a7..1cdb56950ffe 100644
> --- a/tools/include/linux/btf_ids.h
> +++ b/tools/include/linux/btf_ids.h
> @@ -3,6 +3,8 @@
>  #ifndef _LINUX_BTF_IDS_H
>  #define _LINUX_BTF_IDS_H
>  
> +#ifdef CONFIG_DEBUG_INFO_BTF
> +
>  #include <linux/compiler.h> /* for __PASTE */
>  
>  /*
> @@ -21,7 +23,7 @@
>  asm(							\
>  ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
>  ".local " #symbol " ;                          \n"	\
> -".type  " #symbol ", @object;                  \n"	\
> +".type  " #symbol ", STT_OBJECT;               \n"	\
>  ".size  " #symbol ", 4;                        \n"	\
>  #symbol ":                                     \n"	\
>  ".zero 4                                       \n"	\
> @@ -83,5 +85,12 @@ asm(							\
>  ".zero 4                                       \n"	\
>  ".popsection;                                  \n");
>  
> +#else
> +
> +#define BTF_ID_LIST(name) static u32 name[5];
> +#define BTF_ID(prefix, name)
> +#define BTF_ID_UNUSED
> +
> +#endif /* CONFIG_DEBUG_INFO_BTF */
>  
>  #endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> index 403be6f36cba..22d83bba4e91 100644
> --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> @@ -6,6 +6,7 @@
>  #include <bpf/libbpf.h>
>  #include <linux/btf.h>
>  #include <linux/kernel.h>
> +#define CONFIG_DEBUG_INFO_BTF
>  #include <linux/btf_ids.h>
>  #include "test_progs.h"
>  
> -- 
> 2.24.1
> 

