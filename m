Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26112404C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLRH3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:29:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbfLRH3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576654161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W+koJecItxUpWBbkClvTnIgMsQAjFCgBgLdaip1sKlY=;
        b=HgEJY8wcMK3XBEFLet34nsAXKtuAIo/zIG1uAXZ/TBIsjQz0+FKq+xkK/kJuQGa23P8Bxm
        G12T/MccDar4TfUZ68LUXXo9kWfpGX3UUM/VvEWL/n80utkD3uHYwvAQK6MP2fAE+qSNCc
        8+Z7UeLyhNuvAUlxMxpM8Qe8SPJWbEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-KeCKVkgNOpu5eoSnYBoDdg-1; Wed, 18 Dec 2019 02:29:18 -0500
X-MC-Unique: KeCKVkgNOpu5eoSnYBoDdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C21B800EC0;
        Wed, 18 Dec 2019 07:29:15 +0000 (UTC)
Received: from krava (ovpn-204-177.brq.redhat.com [10.40.204.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DCF71001B00;
        Wed, 18 Dec 2019 07:29:11 +0000 (UTC)
Date:   Wed, 18 Dec 2019 08:29:08 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sergey.senozhatsky@gmail.com, pmladek@suse.com,
        wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib api fs: fix gcc9 compilation error
Message-ID: <20191218072908.GA19062@krava>
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 08:01:09AM +0000, Andrey Zhizhikin wrote:
> GCC9 introduced string hardening mechanisms, which exhibits the error
> during fs api compilation:
> 
> error: '__builtin_strncpy' specified bound 4096 equals destination size
> [-Werror=stringop-truncation]
> 
> This comes when the length of copy passed to strncpy is is equal to
> destination size, which could potentially lead to buffer overflow.
> 
> There is a need to mitigate this potential issue by limiting the size of
> destination by 1 and explicitly terminate the destination with NULL.
> 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/lib/api/fs/fs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
> index 11b3885e833e..027b18f7ed8c 100644
> --- a/tools/lib/api/fs/fs.c
> +++ b/tools/lib/api/fs/fs.c
> @@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
>  	size_t name_len = strlen(fs->name);
>  	/* name + "_PATH" + '\0' */
>  	char upper_name[name_len + 5 + 1];
> +
>  	memcpy(upper_name, fs->name, name_len);
>  	mem_toupper(upper_name, name_len);
>  	strcpy(&upper_name[name_len], "_PATH");
> @@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
>  		return false;
>  
>  	fs->found = true;
> -	strncpy(fs->path, override_path, sizeof(fs->path));
> +	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
> +	fs->path[sizeof(fs->path) - 1] = '\0';
>  	return true;
>  }
>  
> -- 
> 2.17.1
> 

