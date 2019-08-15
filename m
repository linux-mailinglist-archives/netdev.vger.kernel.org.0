Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867DE8F18E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbfHORGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:06:19 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41972 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbfHORGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:06:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so2370981qkk.8;
        Thu, 15 Aug 2019 10:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4N9MtH/WdRi43/ziOEzMDfGNy3m5GNX/ZdJvM/Fbxqw=;
        b=CeSNajaHYbJHumzokzP6HZNN1rxoBs08JYStzZCWJHiYBy/rjtYBmMuLEG4s0Wr27s
         bjaNsLxm1lN3526MdAeh6fKTmAn6zrxWWlWi6lGAdFtaeVo+PxKF2e0dRf+AavqLtayj
         0eIc3k2umw6zU6Xi/+Aha+4b2SZHAC/og/bZGQCBUCv4oBdqKpnMSjqKd4fM9kC/o3wI
         j+MP105USswGKSX5Z/qzUxOqlG3eQTBcMlmxnju0/8NIZcyO/9rh9FbW8OeAR59jIZkt
         e9icjtgCJ1LfBXmULz26PvzTrupkC9gBDBkfBI0Xye+CcPe31CJztoMaIusvhOIf5hkV
         rjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4N9MtH/WdRi43/ziOEzMDfGNy3m5GNX/ZdJvM/Fbxqw=;
        b=XH36wfv3F7BjC8ESauYtd9M4XZKMskh/brW4+GGG0EfQupia/HvtliJLMoPmvsCs/t
         PHeMrCNCjfGqA7c/pm1olOaX0YkD7ns9dR9ZF6TGmd6oo9wDLSBds01MR9CIhXXFz/V9
         bvC/tWQPfwngxXuB/C9Z9PMi1Bhz6WtXGRCdP8j6thilnEkhyQL02fKdlz6k1rufWkl8
         S660rJuPTwlKUMFGRzQMJgzLykBKPkZAQrQH2knylxxSTdHe+Rvi5cMaQtk35yKraWop
         qo+oGpgiQ4veX9Q2gH76xCDNfID0qNPQWLKzbDxMwqZHeeEA6rewawqbqtt9iS+z8iUO
         K1Ng==
X-Gm-Message-State: APjAAAW8vzX7s71HBZ1zXFKiUQ6AMtsuaEg7WG5B1QPOGIyjA+QxAWC6
        G8gEeEYRmoPFCSotGzQpWK4ZKRcWy2pd83KCuMY=
X-Google-Smtp-Source: APXvYqzmtLBc/bRpSaWadCZ/ja0P8I4aHKSuJ4fE7ULSbQyfdKl9xgoD10QFKxfjiFI3dzuSA137hRS8d5tsH9MnCrg=
X-Received: by 2002:a05:620a:745:: with SMTP id i5mr4944922qki.39.1565888778036;
 Thu, 15 Aug 2019 10:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142432.101401-1-weiyongjun1@huawei.com>
In-Reply-To: <20190815142432.101401-1-weiyongjun1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 10:06:07 -0700
Message-ID: <CAEf4Bzb8JMnLXVpgF3PcZbZz8zRCX6HNWbsnfJkankjqX3rzRg@mail.gmail.com>
Subject: Re: [PATCH -next] btf: fix return value check in btf_vmlinux_init()
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 7:21 AM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> In case of error, the function kobject_create_and_add() returns NULL
> pointer not ERR_PTR(). The IS_ERR() test in the return value check
> should be replaced with NULL test.
>
> Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---


Argh... Thanks for the fix! Fix the comment below addressed:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/sysfs_btf.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 4659349fc795..be5557deb958 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -30,16 +30,13 @@ static struct kobject *btf_kobj;
>
>  static int __init btf_vmlinux_init(void)
>  {
> -       int err;
> -
>         if (!_binary__btf_vmlinux_bin_start)
>                 return 0;
>
>         btf_kobj = kobject_create_and_add("btf", kernel_kobj);
> -       if (IS_ERR(btf_kobj)) {
> -               err = PTR_ERR(btf_kobj);
> +       if (!btf_kobj) {
>                 btf_kobj = NULL;

This is now not necessary, please drop (and don't forget to remove {}
for this single-line if afterwards).

> -               return err;
> +               return -ENOMEM;
>         }
>
>         bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
>
>
>
