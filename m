Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46426ACF4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgIOTFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgIOTEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 15:04:10 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F810C06178A;
        Tue, 15 Sep 2020 12:04:09 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a22so3748374ljp.13;
        Tue, 15 Sep 2020 12:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ry2ka2feDSNnj4w0OPi1lBAxRKQ1If9rOytHry/skfU=;
        b=cXET9d6r/rJW35xLOmSbGJaGBiYb81AMf52U+tADfDhg5Vg1n8jdEMcQogJZfS0uhb
         9UbiSSUFyabXunfKJaXVe9PxFh81Zym3Wr749tuxLYc22wG2M3Aezgi+w5g6BbsiiN+W
         1CYWQiTJQ9G+GxWj5x6RkxwPTdzMba2UrijmW0RGC2vMTaEkfblgJO0i4XLNpi1GFwc7
         yF3sjFLeCtAgy/NgXLtQeb1qw2VR+2dhNn+b6Fy9fASzA7njIZeCYKHILuTrM/nhAI6n
         mmeia85NbuD9YUCbfE2HWYp59YDg6c1qHrORQ3YSTWgc/obYflsIl2aKovKJ5dS9ix2L
         7dXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ry2ka2feDSNnj4w0OPi1lBAxRKQ1If9rOytHry/skfU=;
        b=pHnygWVn5Oo662IkNJsau8qcCUeGqSM1CZycc2b7icEWPSL9XPl5NlvE7D+VIDUl/K
         JjPmEu9YrmthBRJNQY+Bx5RfxbmE3CdfEglLaiZq9IPQuy6TkglwLUSK+fAuADUNUlde
         BTjyh1kZntZ/81Bbvaa+QRT9G7AgNwODR9hXkUc6IdmPLS+2FtT4W5jqx3LZvofpPA4a
         a/DEozDmuK+rMSlSmupDhXmKz+0FiTvGEnjIEEkMCygAq4cbFNZ1kj1oBZdEwmN60mGN
         QAI5EVSJU/sC2Lk3o/u/gNhAHAYFqT7L5HbYuFqEy9qzwOleFiQ2kmsBvUTgbX9CP9i3
         qpaA==
X-Gm-Message-State: AOAM533n77qZB1vH9JR2yhHJ+6D5vke57Z2IBybsfbBPTgTH27SXWDYi
        sMvZxkjCW8OS25iG6Sz4+UH+GmaMdJmwktXXJANF3yV2
X-Google-Smtp-Source: ABdhPJztd1Xvq0HQLx7b+yVy/EH4dVyR77szdf+769t9JsCGhy4ikWrrij/TbYITuhQaN+587Q8jXor4dvm0f8zecCc=
X-Received: by 2002:a2e:9782:: with SMTP id y2mr7583410lji.91.1600196647637;
 Tue, 15 Sep 2020 12:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200914184630.1048718-1-yhs@fb.com> <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bc24e2da-33e5-e13c-8fe0-1e24c2a5a579@fb.com> <20200915104001.0182ae73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <837b7690-247a-083d-65f5-ea9dc48b972a@fb.com>
In-Reply-To: <837b7690-247a-083d-65f5-ea9dc48b972a@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Sep 2020 12:03:55 -0700
Message-ID: <CAADnVQ+nNPOJux1_DgC6Ze8bP8mS1yBMZOAqsknuyEbnSTeCgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:56 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/15/20 10:40 AM, Jakub Kicinski wrote:
> > On Tue, 15 Sep 2020 10:35:50 -0700 Yonghong Song wrote:
> >> On 9/15/20 8:33 AM, Jakub Kicinski wrote:
> >>> On Mon, 14 Sep 2020 11:46:30 -0700 Yonghong Song wrote:
> >>>> Currently, we use bucket_lock when traversing bpf_sk_storage_map
> >>>> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
> >>>> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
> >>>> we do not have a deadlock issue which exists for hashmap when
> >>>> using bucket_lock ([1]).
> >>>>
> >>>> If a bucket contains a lot of sockets, during bpf_iter traversing
> >>>> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
> >>>> some undesirable delays. Using rcu_read_lock() is a reasonable
> >>>> compromise here. Although it may lose some precision, e.g.,
> >>>> access stale sockets, but it will not hurt performance of other
> >>>> bpf programs.
> >>>>
> >>>> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
> >>>>
> >>>> Cc: Martin KaFai Lau <kafai@fb.com>
> >>>> Signed-off-by: Yonghong Song <yhs@fb.com>
> >>>
> >>> Sparse is not happy about it. Could you add some annotations, perhaps?
> >>>
> >>> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_find_next' - unexpected unlock
> >>> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_stop' - unexpected unlock
> >>
> >> Okay, I will try.
> >>
> >> On my system, sparse is unhappy and core dumped....
> >>
> >> /data/users/yhs/work/net-next/include/linux/string.h:12:38: error: too
> >> many errors
> >> /bin/sh: line 1: 2710132 Segmentation fault      (core dumped) sparse
> >> -D__linux__ -Dlinux -D__STDC__ -Dunix
> >> -D__unix__ -Wbitwise -Wno-return-void -Wno-unknown-attribute
> >> -D__x86_64__ --arch=x86 -mlittle-endian -m64 -W
> >> p,-MMD,net/core/.bpf_sk_storage.o.d -nostdinc -isystem
> >> ...
> >> /data/users/yhs/work/net-next/net/core/bpf_sk_storage.c
> >> make[3]: *** [net/core/bpf_sk_storage.o] Error 139
> >> make[3]: *** Deleting file `net/core/bpf_sk_storage.o'
> >>
> >> -bash-4.4$ rpm -qf /bin/sparse
> >> sparse-0.5.2-1.el7.x86_64
> >> -bash-4.4$
> >
> > I think you need to build from source, sadly :(
> >
> > https://git.kernel.org/pub/scm//devel/sparse/sparse.git
>
> Indeed, building sparse from source works. After adding some
> __releases(RCU) and __acquires(RCU), I now have:
>    context imbalance in 'bpf_sk_storage_map_seq_find_next' - different
> lock contexts for basic block
> I may need to restructure code to please sparse...

I don't think sparse can handle such things even with all annotations.
I would spend too much time on it.
