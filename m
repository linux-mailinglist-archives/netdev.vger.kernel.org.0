Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC334C1859
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbiBWQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242697AbiBWQSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:18:36 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD213D40;
        Wed, 23 Feb 2022 08:18:08 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id n5so15668526ilk.12;
        Wed, 23 Feb 2022 08:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LtJAUbUpEPTIb3MeGTyayGkVTmkfXxef2WQ0+4D+iPM=;
        b=QEv8p/WyhSqMmhHl+5v4FYeSbCUM7X1hKdbAWbBoz7N1ozWMydGlbsF8T+bwDmdGiM
         6NUxHOJAz7NeNznFSyp8IUVsexwKtXcnqpnjK91bfhz+V+gYGb/IApPnM62yGUyK8kPV
         ZtpoBjdhECGFdojYBURSrx15gqmPfhli5DRlLGlzuYi8G2y2Q72hgs/PlpTvBY3RCp6f
         Wcxs63g/a47RiUVTLrcc7cP3V+rAeakt8zntq0byPPaXHohmP3alKOmA7cDzPamV/N5A
         P1JlC5mKsVdJYe2GpQJuKJnrkF19e6BUGXVUL9JnDHDFtxw89ZGGKS56KrSx3nItwaDw
         8egA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LtJAUbUpEPTIb3MeGTyayGkVTmkfXxef2WQ0+4D+iPM=;
        b=UW+IVsrPuiHYI+wcWCk/UZ//YXZyaGCHfGlVPK8rcTSo5+HzgaG3gqnSkHKUww5VZK
         wqA0ma464ke6MOj0sNXbm5iCSg6CmoBK+yTotSddmRVOIYZ5+jNr6Lt2Zqt8kPS2JFmM
         TmtEQRlBHrTC1I3Az4VVQ7Qg0JQikcvhZRbAmfNGcArWkhCllbvqD7tE0bNbLcfUJg0j
         KEHkOjuzStBFOELU0vl9p3dO4yOZqwIBonuuMQQ9UwQCrkx1KspzF2ZBiLCvwdPelqhZ
         +Ssa8yUUuHu/Q6eeCF82dMVQy88ESi5Oo5OgTgxFK0n22soBbzjSPELJiPtQONxB/gVb
         a/cQ==
X-Gm-Message-State: AOAM533fcGfEizgejQdNtjqQdtkJs3rcD2ojp0m7pVv8Kak9QRMXewF6
        fkzpk6iL0qi5nX4c1MrmiEynmfKVDI8gI1WHJp4=
X-Google-Smtp-Source: ABdhPJyLfwmWYD2jxe1ymIOPMTyxwvhmDBL7P6qe7zGTAmc8VVYIi6O2+F/dD7iAHFJFCsWQ1tEjQT1p6BKahsJwDLo=
X-Received: by 2002:a05:6e02:1ca5:b0:2c2:7b9e:c309 with SMTP id
 x5-20020a056e021ca500b002c27b9ec309mr363626ill.238.1645633087757; Wed, 23 Feb
 2022 08:18:07 -0800 (PST)
MIME-Version: 1.0
References: <20220223131833.51991-1-laoar.shao@gmail.com> <7ca9637a-8df0-5400-f50e-cfa8703de55c@fb.com>
In-Reply-To: <7ca9637a-8df0-5400-f50e-cfa8703de55c@fb.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 24 Feb 2022 00:17:31 +0800
Message-ID: <CALOAHbC4DDUmje999Fizse_O_ibhJckR0kzO+qwC6eLUJhkX6g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Refuse to mount bpffs on the same mount point
 multiple times
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 11:36 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 2/23/22 5:18 AM, Yafang Shao wrote:
> > We monitored an unexpected behavoir that bpffs is mounted on a same mount
> > point lots of times on some of our production envrionments. For example,
> > $ mount -t bpf
> > bpffs /sys/fs/bpf bpf rw,relatime 0 0
> > bpffs /sys/fs/bpf bpf rw,relatime 0 0
> > bpffs /sys/fs/bpf bpf rw,relatime 0 0
> > bpffs /sys/fs/bpf bpf rw,relatime 0 0
> > ...
> >
> > That was casued by a buggy user script which didn't check the mount
> > point correctly before mounting bpffs. But it also drives us to think more
> > about if it is okay to allow mounting bpffs on the same mount point
> > multiple times. After investigation we get the conclusion that it is bad
> > to allow that behavior, because it can cause unexpected issues, for
> > example it can break bpftool, which depends on the mount point to get
> > the pinned files.
> >
> > Below is the test case wrt bpftool.
> > First, let's mount bpffs on /var/run/ltcp/bpf multiple times.
> > $ mount -t bpf
> > bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> > bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> > bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> >
> > After pinning some bpf progs on this mount point, let's check the pinned
> > files with bpftool,
> > $ bpftool prog list -f
> > 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
> >          loaded_at 2022-02-23T16:27:38+0800  uid 0
> >          xlated 16B  jited 15B  memlock 4096B
> >          pinned /run/ltcp/bpf/bpf_sockmap
> >          pinned /run/ltcp/bpf/bpf_sockmap
> >          pinned /run/ltcp/bpf/bpf_sockmap
> >          btf_id 243
> > 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
> >          loaded_at 2022-02-23T16:27:38+0800  uid 0
> >          xlated 16B  jited 18B  memlock 4096B
> >          pinned /run/ltcp/bpf/bpf_redir_proxy
> >          pinned /run/ltcp/bpf/bpf_redir_proxy
> >          pinned /run/ltcp/bpf/bpf_redir_proxy
> >          btf_id 244
> >
> > The same pinned file will be showed multiple times.
> > Finnally after mounting bpffs on the same mount point again, we can't
> > get the pinnned files via bpftool,
> > $ bpftool prog list -f
> > 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
> >          loaded_at 2022-02-23T16:27:38+0800  uid 0
> >          xlated 16B  jited 15B  memlock 4096B
> >          btf_id 243
> > 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
> >          loaded_at 2022-02-23T16:27:38+0800  uid 0
> >          xlated 16B  jited 18B  memlock 4096B
> >          btf_id 244
> >
> > We should better refuse to mount bpffs on the same mount point. Before
> > making this change, I also checked why it is allowed in the first place.
> > The related commits are commit e27f4a942a0e
> > ("bpf: Use mount_nodev not mount_ns to mount the bpf filesystem") and
> > commit b2197755b263 ("bpf: add support for persistent maps/progs").
> > Unfortunately they didn't explain why it is allowed. But there should be
> > no use case which requires to mount bpffs on a same mount point multiple
> > times, so let's just refuse it.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > ---
> >   kernel/bpf/inode.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index 4f841e16779e..58374db9376f 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -763,7 +763,7 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
> >
> >   static int bpf_get_tree(struct fs_context *fc)
> >   {
> > -     return get_tree_nodev(fc, bpf_fill_super);
> > +     return get_tree_single(fc, bpf_fill_super);
>
> This is not right. get_tree_nodev is intentional to allow bpffs could be
> mounted in different places with different contents. get_tree_single
> permits a single shared bpffs tree which is not what we want.
>

Thanks for the explanation.

> In your particular case, you probably should improve your tools.
> in my opinion, with get_tree_nodev, it is user space's responsibility
> to coordinate with different bpffs mounts.
>

Of course it is the user's responsibility to make the mount point
always correct.
But it is easy to make mistakes by allowing mounting the same bpffs on
the same mount point multiple times.
Per my understanding, as that behavior can't give us any help while it
can easily introduce bugs, we'd better disable this behavior.

Maybe there's another get_tree_XXX that can be suitable for this case,
but I am not sure yet.


> >   }
> >
> >   static void bpf_free_fc(struct fs_context *fc)



-- 
Thanks
Yafang
