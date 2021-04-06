Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE76E354ED0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244417AbhDFImb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244404AbhDFImb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:42:31 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA05C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 01:42:22 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i143so7272998yba.10
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwsTCxAhw3dF0GAm7sPVjyGArt4+iGQXiKg3gB/niEo=;
        b=OmPt5GlYu2KEaDFgQh72FZkv2hZb2kru4agJXq7+Qr6+VLkTMsJpEySLeZRGDeFJNh
         YfSfsnnG37Clmnl5CpQojwlRdco3kpsfMnVUJeneI8+zhdD/cPtbNvEGZXZCvW/A26hU
         hQ18asRgAc2E7H6LkfKrMQh5CWTWzbX99PjVoIMQHVk7dmKZuCFViMZHoXETFq4etVvE
         lKvGRHFZEyQd4g/ibam5B4YoM36JkRuSS/y+cfLHCSdiB5lNg90FfVl4ber/+dhYvDTY
         HOtMCF/4pDGTO5VTtMleQYU/Ec53j1mfGKKf7kkPAltS346WPoiL0KRG+r/EPTmJeILx
         xqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwsTCxAhw3dF0GAm7sPVjyGArt4+iGQXiKg3gB/niEo=;
        b=prm2VUiTHojQxSLUSiPMP88Kos4nvRcefVkbLf0XqkjoSg8dFZ7IEcXAfEazZUwHut
         XGzlJ3vqNEy+pGuoQz59veISEsWWCmdR4qN00aMkwVDugOfFkntAzgNQg9eD0DSr0ypC
         zVMKzHE9iYA3O7AYie+pnXzFgMIFUYtNoagIAJUitXeTxrGKCthezbE0lL6car08icxf
         HYIVRO0gziLqn085PzKeS1Ybsy1oq4GMSRNxLO8yzD4qg2AZgoD/IWCvph5w0Hrd2TBK
         z1JNWjIrAzkJ/ZYRjWcQl/Ul3VG0nFBOgvkzZW4Ctklhewgz2bP6E0fY5MkkPuSWTSCz
         MMFw==
X-Gm-Message-State: AOAM533O7LfN5hWJB6GKTiBU0YDzc1aQ0E2EZdRGrduxaJDpuMaydAy0
        TsTVkZ3TTzcdipRoXaWVJLAPNzwxgw2BzOJ0XlM7xQ==
X-Google-Smtp-Source: ABdhPJyHynTnKquoiGNp1O+FetHdDzISEyyH9PhG7IkkKKJHyTUHirX5cCXJljsTpgFD4pIiWERAmOAKEBxiDD7VPnQ=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr42247222ybc.234.1617698541330;
 Tue, 06 Apr 2021 01:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210406073509.13734-1-kurt@linutronix.de>
In-Reply-To: <20210406073509.13734-1-kurt@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Apr 2021 10:42:09 +0200
Message-ID: <CANn89iLJA0F5WF1AK9QGHr_XeEfKvu4ueko0n1GH_viJkCax0A@mail.gmail.com>
Subject: Re: [PATCH net v3] net: hsr: Reset MAC header for Tx path
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 9:35 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> Reset MAC header in HSR Tx path. This is needed, because direct packet
> transmission, e.g. by specifying PACKET_QDISC_BYPASS does not reset the MAC
> header.
>
> This has been observed using the following setup:
>
> |$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
> |$ ifconfig hsr0 up
> |$ ./test hsr0
>
> The test binary is using mmap'ed sockets and is specifying the
> PACKET_QDISC_BYPASS socket option.
>
> This patch resolves the following warning on a non-patched kernel:
>
> |[  112.725394] ------------[ cut here ]------------
> |[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
> |[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)
>
> The warning can be safely removed, because the other call sites of
> hsr_forward_skb() make sure that the skb is prepared correctly.
>
> Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
