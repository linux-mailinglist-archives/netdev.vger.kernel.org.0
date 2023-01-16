Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A029466BC02
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjAPKlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjAPKlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:41:10 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E1227D4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:39:33 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4a2f8ad29d5so374520407b3.8
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pT5zVdP1q7WWMgp5rWD6QoqMhX3Du9HPTA21jj3sCNg=;
        b=W3XSoMQ4KHFEP/QBsvqHy0nqH8QG4+i27wpGwbjNk2mt3NiaFiFWlbMbgy+hl4+BqS
         uuFrE7Kkd8KGuWYEGcuaE4QhSaMfNg/g49FwBfZgxuHT9ykxSleJy5dD3BvcxMMJLe8T
         EkvLiRdO8unVR+bRVwe9qmex/MU97OSnFz+E8jD9C7CgXqYyRq4h8sMiFqF4vRtyj4IW
         xsMFMCg4RSMhfc0WXmr7eW0JatxhLnIMFenyoH2AoH6M7pUiMyg6CjVbcJbNT69LT3Sy
         GIHCac6WPrTyPvKbdtp4BqzIktWwhN+vtJXPjbxBrWEqe6a3oqakkPFrGLa1XjFSAkTR
         ZmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pT5zVdP1q7WWMgp5rWD6QoqMhX3Du9HPTA21jj3sCNg=;
        b=fktDcXKM9AZebE8ckAJe28Y7V0jW0/3UgazpHO7sOUcF2Iow86DB5T472+b3cFiWcm
         nlnl1oG1ehGo6sgTKsP4FDTzT+rEvBIrrEi353n3o4TlVsvJYO4UfK0Qr/qsY3E36USl
         LA0k2CdV7fR3h0zlcYAmd/tYudTRvXffNCACaygYQHE6v+gbd8geLLJsl+HSyW40bZI+
         ikwsolEtXiwBVlAPEuM3DsNeXH0FIHOtQoxPZMQrPrDWZ3bYxjodmjNaublUiH7nz6ih
         K7Ed7moBkAZIDsMMj5KKNI9EiPXpoj6gSo9IQcoeQ9JfZpjeXDSzF/FCC+JYUaBKldW9
         3b4A==
X-Gm-Message-State: AFqh2krZVY0Z+NTfDsye2UQ835jwichUmmgmKrnY9gGPkDYcInQwtKjQ
        8j0MV+F3EHIR4BXuE3mIWhCMKMyBBBKwdDkcQKcZ1w==
X-Google-Smtp-Source: AMrXdXtx8ylqU0A+mRZflre1WrqnSvpTRLH6vRqjYxhjSjYNpUNtgjGL/a57Z+Ihe0QoePyNGXOEknpcleNMEMN6qj8=
X-Received: by 2002:a81:6ac2:0:b0:4db:1408:a90c with SMTP id
 f185-20020a816ac2000000b004db1408a90cmr1551631ywc.55.1673865572454; Mon, 16
 Jan 2023 02:39:32 -0800 (PST)
MIME-Version: 1.0
References: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
 <202301141018.w4fQc4gd-lkp@intel.com> <87sfgayeg9.fsf@cloudflare.com>
In-Reply-To: <87sfgayeg9.fsf@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 11:39:21 +0100
Message-ID: <CANn89iLanM-OJu8hThK__G_gQj0z39Rnj-5Fk=kQEmbhs2OPfA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots when
 cloning a listener
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
        netdev@vger.kernel.org, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 11:13 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Hi Dan,
>
> On Sat, Jan 14, 2023 at 11:04 AM +03, Dan Carpenter wrote:
> > Hi Jakub,
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Sitnicki/bpf-sockmap-Check-for-any-of-tcp_bpf_prots-when-cloning-a-listener/20230113-230728
> > base:   e7895f017b79410bf4591396a733b876dc1e0e9d
> > patch link:    https://lore.kernel.org/r/20230113-sockmap-fix-v1-1-d3cad092ee10%40cloudflare.com
> > patch subject: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
> > config: i386-randconfig-m021
> > compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> >
> > smatch warnings:
> > net/ipv4/tcp_bpf.c:644 tcp_bpf_clone() error: buffer overflow 'tcp_bpf_prots' 2 <= 2
> >
> > vim +/tcp_bpf_prots +644 net/ipv4/tcp_bpf.c
> >
> > 604326b41a6fb9 Daniel Borkmann 2018-10-13  634
> > e80251555f0bef Jakub Sitnicki  2020-02-18  635  /* If a child got cloned from a listening socket that had tcp_bpf
> > e80251555f0bef Jakub Sitnicki  2020-02-18  636   * protocol callbacks installed, we need to restore the callbacks to
> > e80251555f0bef Jakub Sitnicki  2020-02-18  637   * the default ones because the child does not inherit the psock state
> > e80251555f0bef Jakub Sitnicki  2020-02-18  638   * that tcp_bpf callbacks expect.
> > e80251555f0bef Jakub Sitnicki  2020-02-18  639   */
> > e80251555f0bef Jakub Sitnicki  2020-02-18  640  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> > e80251555f0bef Jakub Sitnicki  2020-02-18  641  {
> > e80251555f0bef Jakub Sitnicki  2020-02-18  642        struct proto *prot = newsk->sk_prot;
> > e80251555f0bef Jakub Sitnicki  2020-02-18  643
> > c2e74657613125 Jakub Sitnicki  2023-01-13 @644        if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
> >                                                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > What?  Also I suspect this might cause a compile error for Clang builds.
>
> Can't say I see a problem B-)
>
> tcp_bpf_prots is a 2D array:
>
> static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
>
> ... so tcp_bpf_prots[0] is the base address of the first array, while
> tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)] is the base address of the
> array one past the last one.
>
> Smatch doesn't seem to graps the 2D array concept here. We can make it
> happy by being explicit but harder on the eyes:
>
>         if (&tcp_bpf_prots[0][0] <= prot && prot < &tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)][0])
>                 newsk->sk_prot = sk->sk_prot_creator;
>
> Clang can do pointer arithmetic on 2D arrays just fine :-)

We might add a generic helper to make all this a bit more clear ?

+#define is_insidevar(PTR, VAR) (                       \
+       ((void *)(PTR) <= (void *)(VAR)) &&             \
+       ((void *)(PTR) <= (void *)(VAR) + sizeof(VAR)))
+


...

if (is_insidevar(prot, tcp_bpf_prots))
     newsk->sk_prot = sk->sk_prot_creator;
