Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5344EA56D
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiC2Ct6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiC2Ct5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:49:57 -0400
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3F5545AD9
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:48:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 9A135440101
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:48:10 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648522090; bh=UxIN0gCQWDCPxHwAlV5GfBTdHsvgwdbGdcBxlAMphuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TItiNbo1FHWTYF+aGHjG2PeBXJVFxoU2jVRHsyUMg/kPJ2x8yB1ebm9pb6/xp86fj
         etIEqkvkNdXiMFTXAvfMwxUMwQvqNLnWnz8ZNm2b11sDMXedjU8um8sTg/GRD9It+f
         O2GIZs/I1+A3LttPkHVOsD1noHItP7I14fhjWI0Y=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -2056858277
          for <netdev@vger.kernel.org>;
          Tue, 29 Mar 2022 10:48:10 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648522090; bh=UxIN0gCQWDCPxHwAlV5GfBTdHsvgwdbGdcBxlAMphuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TItiNbo1FHWTYF+aGHjG2PeBXJVFxoU2jVRHsyUMg/kPJ2x8yB1ebm9pb6/xp86fj
         etIEqkvkNdXiMFTXAvfMwxUMwQvqNLnWnz8ZNm2b11sDMXedjU8um8sTg/GRD9It+f
         O2GIZs/I1+A3LttPkHVOsD1noHItP7I14fhjWI0Y=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id E79AA15411AE;
        Tue, 29 Mar 2022 10:48:06 +0800 (CST)
Date:   Tue, 29 Mar 2022 10:48:06 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220329104806.00000126@tom.com>
In-Reply-To: <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
        <20220325201123.00002f28@tom.com>
        <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As I said, TCP can be tuned in various ways, congestion being just one
> of them. I'm sure you can find a workload where rmem/wmem will make
> a difference.

agree.
but the difference for the knob of rmem/wmem is:
we could enlarge rmem/wmem for NVMe/TCP via sysctl,
and it would not bring downside to any other sockets whose
rmem/wmem are not explicitly specified.

> In addition, based on my knowledge, application specific TCP level
> tuning (like congestion) is not really a common thing to do. So why in
> nvme-tcp?
>=20
> So to me at least, it is not clear why we should add it to the driver.

As mentioned in the commit message, though we can specify the
congestion-control of NVMe_over_TCP via sysctl or writing
'/proc/sys/net/ipv4/tcp_congestion_control', but this also
changes the congestion-control of all the future TCP sockets on
the same host that have not been explicitly assigned the
congestion-control, thus bringing potential impaction on their
performance.

For example:

A server in a data-center with the following 2 NICs:

    - NIC_fron-end, for interacting with clients through WAN
      (high latency, ms-level)

    - NIC_back-end, for interacting with NVMe/TCP target through LAN
      (low latency, ECN-enabled, ideal for dctcp)

This server interacts with clients (handling requests) via the fron-end
network and accesses the NVMe/TCP storage via the back-end network.
This is a normal use case, right?

For the client devices, we can=E2=80=99t determine their congestion-control.
But normally it=E2=80=99s cubic by default (per the CONFIG_DEFAULT_TCP_CONG=
).
So if we change the default congestion control on the server to dctcp
on behalf of the NVMe/TCP traffic of the LAN side, it could at the
same time change the congestion-control of the front-end sockets
to dctcp while the congestion-control of the client-side is cubic.
So this is an unexpected scenario.

In addition, distributed storage products like the following also have
the above problem:

    - The product consists of a cluster of servers.

    - Each server serves clients via its front-end NIC
     (WAN, high latency).

    - All servers interact with each other via NVMe/TCP via back-end NIC
     (LAN, low latency, ECN-enabled, ideal for dctcp).
