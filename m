Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195154EA69F
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 06:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiC2Efk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 00:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiC2Efj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 00:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA08164F9;
        Mon, 28 Mar 2022 21:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F70F613EF;
        Tue, 29 Mar 2022 04:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7621C2BBE4;
        Tue, 29 Mar 2022 04:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648528435;
        bh=5dIB0sxX2lYZvf6q2/JasfE5c9SjoX2u6XVBPnKxdEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tTUVZy56vvtMa/80ckzceNeLXsipjdpOiYLG5fITqgQ3K11etN6s4by/QIvF9syPp
         FOW/sA3pq9+VoOfdXnlpx/+d5brcX4a4z4xmk0RQ4Sm2Hnon0ns61vCT/gD30jqZsE
         KMpeM4EdAf/WMXC6oOI+r9Ij5P+hbKv+kKUCloyoYS4Embeb5qJCDzY06woXIuPZdD
         DWSRmY6207Gpegb2jdRBex4HVqJcbgY4k4o30SHIi3849cJ2OvfVROguiO+owU3r5U
         2BQwPcjnOk+ITrZ8ku/sp2rUH6s6+fSdaf3LgTgOQUX8pRGyVx93VwZQ6voKzatxrU
         HoqRTrUXlMn+g==
Date:   Mon, 28 Mar 2022 21:33:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220328213353.4aca75bd@kernel.org>
In-Reply-To: <20220329104806.00000126@tom.com>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
        <20220325201123.00002f28@tom.com>
        <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
        <20220329104806.00000126@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 10:48:06 +0800 Mingbao Sun wrote:
> A server in a data-center with the following 2 NICs:
>=20
>     - NIC_fron-end, for interacting with clients through WAN
>       (high latency, ms-level)
>=20
>     - NIC_back-end, for interacting with NVMe/TCP target through LAN
>       (low latency, ECN-enabled, ideal for dctcp)
>=20
> This server interacts with clients (handling requests) via the fron-end
> network and accesses the NVMe/TCP storage via the back-end network.
> This is a normal use case, right?

Well, if you have clearly separated networks you can set the congestion
control algorithm per route, right? man ip-route, search congctl.

> For the client devices, we can=E2=80=99t determine their congestion-contr=
ol.
> But normally it=E2=80=99s cubic by default (per the CONFIG_DEFAULT_TCP_CO=
NG).
> So if we change the default congestion control on the server to dctcp
> on behalf of the NVMe/TCP traffic of the LAN side, it could at the
> same time change the congestion-control of the front-end sockets
> to dctcp while the congestion-control of the client-side is cubic.
> So this is an unexpected scenario.
>=20
> In addition, distributed storage products like the following also have
> the above problem:
>=20
>     - The product consists of a cluster of servers.
>=20
>     - Each server serves clients via its front-end NIC
>      (WAN, high latency).
>=20
>     - All servers interact with each other via NVMe/TCP via back-end NIC
>      (LAN, low latency, ECN-enabled, ideal for dctcp).

