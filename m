Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F81C046B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD3SMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726318AbgD3SMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:12:46 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77343C035494;
        Thu, 30 Apr 2020 11:12:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o10so5832366qtr.6;
        Thu, 30 Apr 2020 11:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgeA7MEUkqk2Es2dDo4XvU2axQ9S49ISzTxAK386n2M=;
        b=Dh5EkvBeYPTkAWxgXDeWIUHLJ9KshJBiAjfgLJQCBrgkhYOD4MTWmIDLVmoINcNERQ
         OgBI1jOEzRKj+hFjOzHMp1jHwHQSjHPwY5FfvJWVZFbqlWR1qY9O+RdYl+AZ/cwhNmWw
         1uz/PTon3Djt4z6wXVakMGENmC9pog38ktYVA0DNriHRDS+NRp2IROeHpAP4ggNwbnF/
         bwXqPGyqVqBHOPKcO5CZrgbmeZ6EOGenedDOEBa3F0jP58f/3gxib9s0Cc79IQiqzB7m
         iSA3jtuJ4hEqEdXUeyBkqtHEyJgbOCJlS0TOhwG26R+AR9d2k2c5zs6wIBDzWSZ4ZkKF
         kIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgeA7MEUkqk2Es2dDo4XvU2axQ9S49ISzTxAK386n2M=;
        b=i3+1lVMSx0/kqi3dfb2yxVQ6G9O+6tPwEnB4xyNMYDpx30YNbPAdXpleAI2yBLYue/
         EcoDA3KfW9OUqLV9N0sveiQ1lku3q3YbCBoepgV+Id7rAGRWuu5MWpOPXKTXiC0YnHWr
         Gecu70A5McHpEvrSULA7wpGPGtw4c0MlmMsXT2WJNfufvQ31ODWUeDLffpp1jEZSGa4o
         BBhv+gsq/xzbwmVLto+UW/lOMNXdd60pCqJSI+MiBRtd92gAToF0a3h2tPMRB9+APeNd
         h5RPX0LEvBRaVZDT+PeZ+FwrHQlQU73NUmhJ43GaMaetA4WJg/HSyT3KTytphlMnNiCl
         hLow==
X-Gm-Message-State: AGi0PuZm+kKTmk/8ugLsotp5MH0m0N3AOV4/RKyufkMUCX17KSFnc4oj
        k4CTPYJVwxY8PKO0enixV/Kd1Mq7k7dD+1q0uOE=
X-Google-Smtp-Source: APiQypIrdKokXP3ByzYLD6DOa8n4uCJ1eajRL4E9ovCVZctzkEc9xI0lCETvmyCkNukTHwG7TnHhuGzeEQmFqQhvx+M=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr4724442qtj.93.1588270363413;
 Thu, 30 Apr 2020 11:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <158824221003.2338.9700507405752328930.stgit@ebuild>
In-Reply-To: <158824221003.2338.9700507405752328930.stgit@ebuild>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Apr 2020 11:12:32 -0700
Message-ID: <CAEf4BzYeJxGuPC8rbsY5yvED8KNaq=7NULFPnwPdeEs==Srd1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix probe code to return EPERM if encountered
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 3:24 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> When the probe code was failing for any reason ENOTSUP was returned, even
> if this was due to no having enough lock space. This patch fixes this by
> returning EPERM to the user application, so it can respond and increase
> the RLIMIT_MEMLOCK size.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f480e29a6b0..a62388a151d4 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3381,8 +3381,13 @@ bpf_object__probe_caps(struct bpf_object *obj)
>
>         for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
>                 ret = probe_fn[i](obj);
> -               if (ret < 0)
> +               if (ret < 0) {
>                         pr_debug("Probe #%d failed with %d.\n", i, ret);
> +                       if (ret == -EPERM) {
> +                               pr_perm_msg(ret);
> +                               return ret;

I think this is dangerous to do. This detection loop is not supposed
to return error to user if any of the features are missing. I'd feel
more comfortable if we split bpf_object__probe_name() into two tests:
one testing trivial program and another testing same program with
name. If the first one fails with EPERM -- then we can return error to
user. If anything else fails -- that's ok. Thoughts?

> +                       }
> +               }
>         }
>
>         return 0;
>
