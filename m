Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3B3FBEE9
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfKNFDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:03:35 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:48927 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfKNFDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:03:35 -0500
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7A60D200002
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:03:33 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id m6so3004038vsn.13
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:03:33 -0800 (PST)
X-Gm-Message-State: APjAAAVk+ZCU6YS/VqEmsLfr6asoxLUFT1L9qPAg2VUr9k2jX0dmLftp
        pWPe+T7lklVpWsFKUIAeLfRKKIhk6/PLBzekcZM=
X-Google-Smtp-Source: APXvYqxTzPkK5Dsfu325XMD6wodZCIhukd8E0JtZ08U2a039WKMjPj/q/Aa0wAMXDYH3p7j1an8aMicP8Ybv1fmvIlI=
X-Received: by 2002:a67:6e05:: with SMTP id j5mr4712767vsc.66.1573707811617;
 Wed, 13 Nov 2019 21:03:31 -0800 (PST)
MIME-Version: 1.0
References: <1573657489-16067-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1573657489-16067-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 13 Nov 2019 21:03:22 -0800
X-Gmail-Original-Message-ID: <CAOrHB_Ci+iSL=Ctt_TjNuFc3=+gRTdWwdGH4hgpUVS1Thc8nGA@mail.gmail.com>
Message-ID: <CAOrHB_Ci+iSL=Ctt_TjNuFc3=+gRTdWwdGH4hgpUVS1Thc8nGA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: openvswitch: add hash info to upcall
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, Ben Pfaff <blp@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 7:05 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When using the kernel datapath, the upcall don't
> include skb hash info relatived. That will introduce
> some problem, because the hash of skb is important
> in kernel stack. For example, VXLAN module uses
> it to select UDP src port. The tx queue selection
> may also use the hash in stack.
>
> Hash is computed in different ways. Hash is random
> for a TCP socket, and hash may be computed in hardware,
> or software stack. Recalculation hash is not easy.
>
> Hash of TCP socket is computed:
> tcp_v4_connect
>     -> sk_set_txhash (is random)
>
> __tcp_transmit_skb
>     -> skb_set_hash_from_sk
>
> There will be one upcall, without information of skb
> hash, to ovs-vswitchd, for the first packet of a TCP
> session. The rest packets will be processed in Open vSwitch
> modules, hash kept. If this tcp session is forward to
> VXLAN module, then the UDP src port of first tcp packet
> is different from rest packets.
>
> TCP packets may come from the host or dockers, to Open vSwitch.
> To fix it, we store the hash info to upcall, and restore hash
> when packets sent back.
>
> +---------------+          +-------------------------+
> |   Docker/VMs  |          |     ovs-vswitchd        |
> +----+----------+          +-+--------------------+--+
>      |                       ^                    |
>      |                       |                    |
>      |                       |  upcall            v restore packet hash (not recalculate)
>      |                     +-+--------------------+--+
>      |  tap netdev         |                         |   vxlan module
>      +--------------->     +-->  Open vSwitch ko     +-->
>        or internal type    |                         |
>                            +-------------------------+
>
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
