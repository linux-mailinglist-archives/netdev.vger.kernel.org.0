Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C121CD6E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 04:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgGMCzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 22:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGMCzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 22:55:50 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2290BC061794;
        Sun, 12 Jul 2020 19:55:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q198so10936908qka.2;
        Sun, 12 Jul 2020 19:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bNXPF6+Om5R3sQ6XjurA2+A7JrWXO8Ws/6EvEMQiNak=;
        b=k1zPbJAzQYunqh3hpt/60sDyTPewxs8cn1cTgb+LBOV5hLQqh9BcF17XeFIzi+swrq
         YUR36iLZYKdhzbPpofJ6tnebgpFwx1iV97LKc+yjF8LgF1NQt3MgWUH8Jpz/nZmrLDeV
         T39vGvXfofOK/BZ1aXK3XxTaHk8GNNJ1k+IA51rG6cdco03nriGDsU89VkORRHoqetAf
         opVoc/Oc1ne1/nKaZjsWsqTfFVa5ZZA5KsDv3ugbSucRopzGIM66OX1+Eg+aLDqwxE80
         dMOESV71ADGgNDlsThGdTWo6xzRQ26K6ZTHmYZjDSJo8/19Q/styLObXA1jvokXfb7Zu
         azQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bNXPF6+Om5R3sQ6XjurA2+A7JrWXO8Ws/6EvEMQiNak=;
        b=IzjKUqivYvEzJh0MMw4TLPx3z7M+b7iTiUdAi2hAn2W1CT2mTJ+worsXlussABFwr7
         LzV5b8SHLkhxamEW64KN0N8/vzyeGebNRPsSnBpTf3M+p7jzDfvyuxzKHdv4s3IaeeH5
         HZ77vPFSJUDrMwTqKSjw80vjoi8jJqHaets0dYg5a7NlQ62uAkgxg3lKcwvBB1USztR2
         u9/ptWemvajlA1Jfw/OUwXEnkbm574Pn+ty4kvr8Kvy/vcvk6+NwCDXo+HMVFzYq75qL
         pyNEGE0323jMdjmLEbeoguwrRFacPBaSNYFiSMO+R4advCXWnAQZt1PPQilcAlxyMAzG
         2Dsg==
X-Gm-Message-State: AOAM532vKDGr6Z5BgatVnwO8ZYmxHQsIf3luNwUlOG6FEgqqBnq5BWcH
        QIPN4+ona8a7s0X+8ZdoCvnqZw7zQx++QKzNvf4=
X-Google-Smtp-Source: ABdhPJy8XJNQbmL4ru60bEfVwykiVPcjm1GCJHy12OlbDD2DK8UGXnsaVrGNSnOOoXWe3VMMbY0mspgwiIiBpJBfwCo=
X-Received: by 2002:ae9:f803:: with SMTP id x3mr75827914qkh.488.1594608948228;
 Sun, 12 Jul 2020 19:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <1594462239-19596-1-git-send-email-goodluckwillcomesoon@gmail.com> <20200711111421.0db76fa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200711111421.0db76fa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yahui Chen <goodluckwillcomesoon@gmail.com>
Date:   Mon, 13 Jul 2020 10:55:36 +0800
Message-ID: <CAPydje9rv2cR2YZvOcYT_w4E7cvERi0cEbs7hiwLKk4Bqhk+RA@mail.gmail.com>
Subject: Re: [PATCH] xsk: ixgbe: solve the soft interrupt 100% CPU usage when
 xdp rx traffic congestion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>, steven.zou@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp skb-mode does not have this problem because `ixgbe_alloc_rx_buffers`
always returns success and can always get the DMA address for packets. I
think drv-mode should do the same.

If the drv-mode app does not use the wakeup flag, the xdp queue's soft
interrupt handles fewer packets but may occupy 100% of the CPU,
according to the analysis of the previous email.

If the user APP uses the wakeup flag, it maybe seriously affect other
queues just because the APP is not processing the packet fast enough.
In extreme cases, the APP can no longer receive packets, and port-level
flow control will cause no packets to be received in all queues of the
network card.

As a result, the user needs to explicitly turn off flow control of network
card, which is unfriendly to users.

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2020=E5=B9=B47=E6=9C=8812=E6=97=
=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=882:14=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 11 Jul 2020 18:10:38 +0800 Yahui Chen wrote:
> > 2. If the wakeup mechanism is used, that is, use the
> > `XDP_UMEM_USES_NEED_WAKEUP` flag. This method takes advantage of the
> > interrupt delay function of ixgbe skillfully, thus solving the problem
> > that the si CPU is always 100%. However, it will cause other problems.
> > The port-level flow control will be triggered on 82599, and the pause
> > frame will be sent to the upstream sender. This will affect the other
> > packet receiving queues of the network card, resulting in the packet
> > receiving rate of all queues dropping to 10Kpps.
>
> To me the current behavior sounds correct.. if you don't want pause
> frames to be generated you have to disable them completely. The point
> of pause frames is to prevent drops.
