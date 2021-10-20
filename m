Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8105043520F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhJTR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhJTR5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:57:53 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3374C06161C;
        Wed, 20 Oct 2021 10:55:38 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id l201so3315670ybl.9;
        Wed, 20 Oct 2021 10:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8u86eLA4+HU/aIaOe6FGTXKOIQPSQcBtCZ7dRIOqJ4=;
        b=Ymtz7D3u8DujOdY7kLaXMRY3YJFFp/myUA06VyXitafGFeU23JUimNyGSyV/9APBS7
         xRiYq2A6L9reVBhlhN8pXW6Y+owBKR8kWfiKYPSyfBceXbalzlyDOvGvLfKEwn/LMVII
         732R6+YH/jVgOrrAe7lvq+002jUjQxF4WwlJlADtizvgzKh1LpoVtfH74cqlCnrot3O9
         UrzWMqnhCb4DMZfD/g9mb5l58pL8ET5Zd5HhWo2OFkTSUCG4zxSMivklVRmDllfF3ZDE
         GSxX7HrpQBCllEJFEE+XAfWF5zPXIZLS/BUknAyw7RpZPbmsQ6W9TVEGWzI+ABtGpev8
         n8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8u86eLA4+HU/aIaOe6FGTXKOIQPSQcBtCZ7dRIOqJ4=;
        b=JUmMuPVIbuLpAcL/vmuwze8PGrR7XEaeHwX3fogesuwJhq71OscjDyQRONL5XC7aRm
         l2qnj/AwYWqXz6G4CB9MbRw96oQBi7U3ZU41jPJfgDQHJLvL80yYR9BvDSXkPmchNrxt
         juL6o52cBzCZ3i9XgKFHyKc4iSob7WfIzSLDo2ewaASStYjUvkTDp6SKUJI8TFsK18fK
         2/B8wWXk5IUJRNDJ06YFcxwXjT4grnffaZBzlcG5cWtyEV35JDcUpzdGUJAtmP605xGU
         4G9XYJweMK0pBxFbYv6F1kU7exa1SQkyV1LqKC8Vh/I1lnJJ5WkEUqdnnvkNzDsJYJXd
         DIBA==
X-Gm-Message-State: AOAM533n6UEdx2HLbv/eun9NSnExRvwE/chJ1Wx5rmI/UgoCCeQqnoho
        i+GorUTjr9LViw32NpApl+U5BY3ecuUo48VarSE=
X-Google-Smtp-Source: ABdhPJwl4dexMHx25AHVV4O1CY1kJDihzhI+4Wa5+WDaHdsrMGIiry4wfSnp7RoCOKPP2A72YHLFvT76XCiA1BBprGU=
X-Received: by 2002:a05:6902:154d:: with SMTP id r13mr671224ybu.114.1634752538215;
 Wed, 20 Oct 2021 10:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211012111649.983253-1-davidcomponentone@gmail.com>
In-Reply-To: <20211012111649.983253-1-davidcomponentone@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 10:55:27 -0700
Message-ID: <CAEf4BzYTNZ=TNqMiGNg_Nj03K9fMM_xnoc=yaEYn8zbyE1rVjg@mail.gmail.com>
Subject: Re: [PATCH] Fix application of sizeof to pointer
To:     davidcomponentone@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 4:17 AM <davidcomponentone@gmail.com> wrote:
>
> From: David Yang <davidcomponentone@gmail.com>
>
> The coccinelle check report:
> "./samples/bpf/xdp_redirect_cpu_user.c:397:32-38:
> ERROR: application of sizeof to pointer"
> Using the "strlen" to fix it.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---

For future submissions, please use [PATCH bpf-next] subject prefix.
For changes that are targeted against BPF samples, please use
samples/bpf: prefix as well. So in this case the patch subject should
have been something like:

[PATCH bpf-next] samples/bpf: Fix application of sizeof to pointer

I've fixed it up and applied to bpf-next, thanks.

>  samples/bpf/xdp_redirect_cpu_user.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> index 6e25fba64c72..d84e6949007c 100644
> --- a/samples/bpf/xdp_redirect_cpu_user.c
> +++ b/samples/bpf/xdp_redirect_cpu_user.c
> @@ -325,7 +325,6 @@ int main(int argc, char **argv)
>         int add_cpu = -1;
>         int ifindex = -1;
>         int *cpu, i, opt;
> -       char *ifname;
>         __u32 qsize;
>         int n_cpus;
>
> @@ -393,9 +392,8 @@ int main(int argc, char **argv)
>                                 fprintf(stderr, "-d/--dev name too long\n");
>                                 goto end_cpu;
>                         }
> -                       ifname = (char *)&ifname_buf;
> -                       safe_strncpy(ifname, optarg, sizeof(ifname));
> -                       ifindex = if_nametoindex(ifname);
> +                       safe_strncpy(ifname_buf, optarg, strlen(ifname_buf));
> +                       ifindex = if_nametoindex(ifname_buf);
>                         if (!ifindex)
>                                 ifindex = strtoul(optarg, NULL, 0);
>                         if (!ifindex) {
> --
> 2.30.2
>
