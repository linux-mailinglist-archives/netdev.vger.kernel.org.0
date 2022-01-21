Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D34958D0
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiAUEL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiAUELW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:11:22 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B73C061574;
        Thu, 20 Jan 2022 20:11:21 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 128so7734580pfe.12;
        Thu, 20 Jan 2022 20:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HziZxNV+Yg2upBujmAjZKh5ywVi0eUQ5hp+WB+K2RfM=;
        b=PVfKZMOuiPEAf33583XwiNp53DIKSyizFEZDUije4bCtwRvLd/GHoOYRC4u/sWakZJ
         ufyeKlaPTLIQa7aAFtEAVTn/DJ7M+blv/OKfnwaX23qgZ8HNaIxbzUnfPF4Q7Rmks4ff
         YKpSqx3B/Pa5OptDrJuhUF/dP1zuaHZQVI7+/Pgb7Y+DLlJ/C/IDiv8jc18USrDCGIKU
         AbhiF16jFsz7Rm+HbD73A3MTvUYtiWQJgmPHWuQ1rvjbltr+mifW87TYZWEtppmPbGo8
         tFCDzYkgcBCAHR0a3jqC8o7iBi7qE3nGKt3hYQHNfK9Z6ZJXYSVFnc6g0nQoZ8myHOG6
         VnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HziZxNV+Yg2upBujmAjZKh5ywVi0eUQ5hp+WB+K2RfM=;
        b=Hd+f7UsFtFIM2MxnKKUyzD7dIWfHHBqvT9g/HhTuoIaLla22n4L9v9U0nGZBvBG8cl
         2U3dLP4sMdNkrCCEC9TcEDN46RXKgWNsUCi5h/HYhuWVNQ7O2EScOH+Y5ksM9svOCi/Y
         jw4vmV7xZXeJ+lYAOao4IpVyNn7LASiVMfHNW9aCHGuonecgnt1b+QqzhZSEyu3IhAGi
         Ik0ePkDa16uGTLo0Wqd97oVcgDhkX/YwhgKsoj8ooGXefo/rEdJAEddww6bcFwhNWX9u
         CS+pwcVee8V3To2qSiCyMBxIjrSxJuwnPtdvQUlhmCtBFTyDawpUX/fxC+iXy2RVgm7H
         R6UQ==
X-Gm-Message-State: AOAM531mUBcLa9RZPxzt3iSX1UVNtoOIkqMXFnX8RKPCO1SjzaWrrdvL
        gg3+/fa0qUTXfEEZR3XbWBGBPP34fDRQEsaz9HUoOjKr
X-Google-Smtp-Source: ABdhPJzEl2C9ekMs62SzulgA7ti48Yjxwbu/nug/T4f62oP6p3e5asRIA2ehVT6d+u3f7jR4xTGBm274r+W78r8VQ80=
X-Received: by 2002:a62:e30c:0:b0:4bd:776e:a41c with SMTP id
 g12-20020a62e30c000000b004bd776ea41cmr1959073pfh.59.1642738281269; Thu, 20
 Jan 2022 20:11:21 -0800 (PST)
MIME-Version: 1.0
References: <20220121031108.4813-1-ycaibb@gmail.com> <20220120194733.6a8b13e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <BDEF9CF1-016A-48F2-A4F3-8B39CC219B4F@gmail.com>
In-Reply-To: <BDEF9CF1-016A-48F2-A4F3-8B39CC219B4F@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Jan 2022 20:11:10 -0800
Message-ID: <CAADnVQJkCQthJ7OAByNBTMuKEY7mynvuMDR6y_L7cBwB6iyc9g@mail.gmail.com>
Subject: Re: [PATCH] ipv4: fix lock leaks
To:     Ryan Cai <ycaibb@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:06 PM Ryan Cai <ycaibb@gmail.com> wrote:
>
> Sorry for reporting this false positive. Would be more careful next time. Thank you for your checking.

In the past 3 weeks you've sent 4 subtly broken patches.
Not a single valid one.
Are you trying to test the maintainer's review skills?
Is this another "lets hack the kernel" research project?
