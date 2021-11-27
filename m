Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF5745FD28
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 07:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350289AbhK0GyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 01:54:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43982 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbhK0GwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 01:52:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52481B82947;
        Sat, 27 Nov 2021 06:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1E1C53FD1;
        Sat, 27 Nov 2021 06:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637995729;
        bh=tcXFFyBVhmMtq+HKRP4oy8XWv8Ddt0hkMkaJi+RVwrM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lLQgd5m7La3qKO+ck3osVoBLKKINXS+GbkALIkNcRT8cl+WDG4XejhDXTQ8aaYnwA
         9CF/j1zGyVHD/PWZLXtb7AM4m/80XFdthoRxd1l1QIaz4L6CJiZM9mGajHSZ44CNx9
         CvBopIdVVgwiWFZ23U+Z4J9+thZ3qAY9MA1i9TlsORS8LhMgb64aCNjcyRJ0Fs0tZA
         QK1c0X2A7m7o54DHDyKbOWqbnDOtkm3EZE4/nmqVBEPGyztNJA762J8/qZMRHDW4Cg
         zKMB40Q6xUOzAwvLs98TBzjeNh/Jg//t9bf//EbLWVlOsnM5kirobL3j5omxHSdSYK
         ioLyfjMcdwxbg==
Received: by mail-yb1-f174.google.com with SMTP id v7so25994556ybq.0;
        Fri, 26 Nov 2021 22:48:48 -0800 (PST)
X-Gm-Message-State: AOAM532bCOYPnWS4GlGNE3xVgk0jPUlAqFipwjUTDqjI9U1F8gFye6E4
        YkyhoHJInU347grR2gpvOi9E+lXO8zZA6HcwNzc=
X-Google-Smtp-Source: ABdhPJx1ZIdHplqFdPMlE9TrAWXmXqSoHnDcfiR08SGZxyv0tLsuFY/DyunzgbWC9oDhAtBVPJRhxMujUtyDaibbEGU=
X-Received: by 2002:a25:bd45:: with SMTP id p5mr22566883ybm.213.1637995728145;
 Fri, 26 Nov 2021 22:48:48 -0800 (PST)
MIME-Version: 1.0
References: <20211124091821.3916046-1-boon.leong.ong@intel.com> <20211124091821.3916046-2-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-2-boon.leong.ong@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 22:48:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4NVM5=q2igHm_HFzueSsJsoByP-wz2PfJeA1KRXVDnvA@mail.gmail.com>
Message-ID: <CAPhsuW4NVM5=q2igHm_HFzueSsJsoByP-wz2PfJeA1KRXVDnvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] samples/bpf: xdpsock: add VLAN support for
 Tx-only operation
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 1:21 AM Ong Boon Leong <boon.leong.ong@intel.com> wrote:
>
> In multi-queue environment testing, the support for VLAN-tag based
> steering is useful. So, this patch adds the capability to add
> VLAN tag (VLAN ID and Priority) to the generated Tx frame.
>
> To set the VLAN ID=10 and Priority=2 for Tx only through TxQ=3:
>  $ xdpsock -i eth0 -t -N -z -q 3 -V -J 10 -K 2
>
> If VLAN ID (-J) and Priority (-K) is set, it default to
>   VLAN ID = 1
>   VLAN Priority = 0.
>
> For example, VLAN-tagged Tx only, xdp copy mode through TxQ=1:
>  $ xdpsock -i eth0 -t -N -c -q 1 -V
>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
