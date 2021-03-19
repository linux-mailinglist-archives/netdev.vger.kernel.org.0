Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82FF34266D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCSTpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhCSTpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:45:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71423C06175F;
        Fri, 19 Mar 2021 12:45:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e14so3436013plj.2;
        Fri, 19 Mar 2021 12:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iG9i0hkyLebN0rrxlD9RQ2LdGYygnU0VLbpS3c4IRk=;
        b=NmnEUZh/mG38WsmKqMoGP/bFCNSRtEm07atlNjDURO9qH2FksvyTqya9HEULPbBSDP
         5tiU1iM8Offa/AAxF0dmmVdo62PdAHmqDlnRZhMokJ1HFgo50q926GyFET6E8yPtXkBo
         VRdvPxvbfUI/mFAQzV7MDnvVSSPWH2ZonsltFA9vElxbaeLABCp4hPFQfuvgzkrtYR/S
         cXFC8hX/c7eC1MyMz7egoNpKuWHvQzKMVePunhUIvrZJYI0+UEltRceXeJndlvchewO8
         C/syoOiiRP2rlgrhajw2Hix/n/EywylXWtSE1keAxGXYKTIekc/x87gIuPUMUMC/8Y+t
         g6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0iG9i0hkyLebN0rrxlD9RQ2LdGYygnU0VLbpS3c4IRk=;
        b=tELqgTtnOjm18GKF9wgB5V+fjyzTwFeVmIijVhWPFC9GD9cV0Lf7cyuxPl8+INFiT7
         vyuOBDCcGQ4jvhcCRcv8ZWr2vwlxmxEbM1eqBC/XR8VrEKsGBD9aiaANkft/xCgBpZZi
         AF7sRzHznhPFle2vA99lD/ijFsjXyOYJYVaVV/AXIadoVfzV94wXW7ru9pRieGNHvZ5x
         EZo3j1qT55dTNkaKFQ53Zc6rnbJURorKz8kp7dpd92vasE/lErpAk13ciMwEAvXvumln
         /i947P+DLHJKY1SBClSxkQair+5zZBK+EY5oI59gfz2J/fKZgxfQTBJSppVQ9UBUEALl
         fCEA==
X-Gm-Message-State: AOAM532ID/qDV5tve17yLxWwWR0J2h7LBya7CYHUAdLkaKt59URJzcYd
        dw6FW2LaxUVwmdgtMwTeqQv+yauU6jPAnpHz/LM=
X-Google-Smtp-Source: ABdhPJzBi2AY/dZ5Ts/M/JMMkgDtkUN7DQZiemjvgYyWLdVgAFMe5e1q9MkFQG0JmHIxsOdBSEVfcTswXF/I6ASnR9c=
X-Received: by 2002:a17:902:be02:b029:e6:bb0d:6c1e with SMTP id
 r2-20020a170902be02b02900e6bb0d6c1emr15754118pls.77.1616183142004; Fri, 19
 Mar 2021 12:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com> <e5c2d82c-0158-3997-80b6-4aab56c61367@huawei.com>
In-Reply-To: <e5c2d82c-0158-3997-80b6-4aab56c61367@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Mar 2021 12:45:30 -0700
Message-ID: <CAM_iQpV4HX5L1b8ofUig-bi3r_MDdsjThqaxfoRCd=02XZBprQ@mail.gmail.com>
Subject: Re: [Linuxarm] [PATCH net] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> I had done some performance test to see if there is value to
> fix the packet stuck problem and support lockless qdisc bypass,
> here is some result using pktgen in 'queue_xmit' mode on a dummy
> device as Paolo Abeni had done in [1], and using pfifo_fast qdisc:
>
> threads  vanilla    locked-qdisc    vanilla+this_patch
>    1     2.6Mpps      2.9Mpps            2.5Mpps
>    2     3.9Mpps      4.8Mpps            3.6Mpps
>    4     5.6Mpps      3.0Mpps            4.7Mpps
>    8     2.7Mpps      1.6Mpps            2.8Mpps
>    16    2.2Mpps      1.3Mpps            2.3Mpps
>
> locked-qdisc: test by removing the "TCQ_F_NOLOCK | TCQ_F_CPUSTATS".

I read this as this patch introduces somehow a performance
regression for -net, as the lockless bypass patch you submitted is
for -net-next.

Thanks.
