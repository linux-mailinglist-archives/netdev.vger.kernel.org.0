Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB8A8D22
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbfIDQ1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 12:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbfIDQ1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:27:37 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9178919D381
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 16:27:37 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id a7so12929012edm.23
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 09:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h4oUNZ4wMsQSEwRJL6RAFeQ8Rl32XhPNb9uk7Llrzoo=;
        b=CB4d+/CTgMS88kLeet7bmfZ/uih+op5nN3DEu0i8P22JZSitpSrhvX3MYDfsVby5Lk
         YWYY0JHc4X++IekUSvczLvex+vZciRF2OQsDHq3gy5x+Yr1eOT3TbxdDI+NwRHrR2NIq
         1dTA/2Wg1di0KicGgCMejsF7bpMSuGXQIt+5aoITv6iVlO2P3NR/lwNtKirns5sjrrx9
         sw4RHJNVbiudlBjYnRsBrbqT53D4btcHEt7V0qhdyYrhiRoSzTzELLSjN6CVYH3XDJxp
         Owu+gUVvGieDFs2XELm3EbNBPWCKW4KT6cJ3tKKnyRqwaAOa7FkwGvauLRrsY52eqHUJ
         pSXQ==
X-Gm-Message-State: APjAAAWNi0Ja30/+t2TGfBNxxcwLe7JJ5LL1wEslS7XLuXXdLxwDvpHK
        7b864RwhB1H4W8UfVT+MPX7avlYynKJKQpr9Hq28iSbQXJxOYWvQ6c1wSLtIk/gSfkJrfb3gftE
        8wuoBPwJfCu0yj7o+yF0DBrLDOqS6t4eZ
X-Received: by 2002:a50:ac03:: with SMTP id v3mr23653498edc.113.1567614456188;
        Wed, 04 Sep 2019 09:27:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzz07V3rKofyk8EJM2zdapcLrR20ECkStRJLTj0UvaoYlZUvOftmQPN0m+fYnhW3+XIbrUDgGHAx52qnpGlbpc=
X-Received: by 2002:a50:ac03:: with SMTP id v3mr23653485edc.113.1567614456014;
 Wed, 04 Sep 2019 09:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
In-Reply-To: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Wed, 4 Sep 2019 18:28:53 +0200
Message-ID: <CAPpH65yZjSPZMLrq10ZwrwWwh3xBJUi+7v0VT4pVn4z=7nx+qg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] bpf: fix snprintf truncation warning
To:     linux-netdev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 5:50 PM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> gcc v9.2.1 produces the following warning compiling iproute2:
>
> bpf.c: In function ‘bpf_get_work_dir’:
> bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |                                                 ^
> bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.
>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  lib/bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 7d2a322ffbaec..95de7894a93ce 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
>  static const char *bpf_get_work_dir(enum bpf_prog_type type)
>  {
>         static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
> -       static char bpf_wrk_dir[PATH_MAX];
> +       static char bpf_wrk_dir[PATH_MAX + 1];
>         static const char *mnt;
>         static bool bpf_mnt_cached;
>         const char *mnt_env = getenv(BPF_ENV_MNT);
> --
> 2.21.0
>

Sorry, I forgot to add:

Fixes: e42256699cac ("bpf: make tc's bpf loader generic and move into lib")
