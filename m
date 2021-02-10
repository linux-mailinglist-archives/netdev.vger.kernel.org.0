Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A95316537
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhBJL2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:28:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13274 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhBJLZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:25:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023c2960001>; Wed, 10 Feb 2021 03:25:10 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 11:25:09 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 11:25:07 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ygnho8gtgw2l.fsf@nvidia.com>
 <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ygnhlfbxgifc.fsf@nvidia.com>
 <20210209115012.049ee898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
In-Reply-To: <20210209115012.049ee898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 10 Feb 2021 13:25:05 +0200
Message-ID: <ygnhim70go6m.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612956310; bh=pu3dDGQzKHr86LYVx5iwq+7SCKGOv9eIK4KKdlbb2tQ=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=foZpcFysAo26E9AEVysi+//qSXDlECr8Tsy32PAgjvnMh2l+7+kTyX8QDb+TojdJl
         PVgT6IzcaypYlmu1nai1Siq6LuMiH83a2/DJTLxS9UQiJZDk3TexJKH14Gj28rVoGi
         7TNjCKPpz5w6n+v9iaF13Bvs3kNDTD9DaRbVBSjtjR4koZLlffBtuGAyvw7jaPRrzR
         /0hvJn3kphsQWs9+ReMeGzEJj7noadVMD/ANElI/dmUygBwEy1WVXn5RCaPpcPgiNm
         051T8ORxAdQ8vl6Vd4jnbL/9UFoCCUjXeq7hWJnBfPDElvIxuY/CIlMpNrlu4Wh9KZ
         2HcRGVLmJ1wog==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 09 Feb 2021 at 21:50, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 9 Feb 2021 21:17:11 +0200 Vlad Buslov wrote:
>> 4. Decapsulated payload appears on namespaced VF with IP address
>> 5.5.5.5:
>> 
>> $ sudo ip  netns exec ns0 tcpdump -ni enp8s0f0v1 -vvv -c 3
>
> So there are two VFs? Hm, completely missed that. Could you *please*
> provide an ascii diagram for the entire flow? None of those dumps
> you're showing gives us the high level picture, and it's quite hard 
> to follow which enpsfyxz interface is what.

Sure. Here it is:

+-------------------------------------------------------------------------------------+
|                                                                                     |
| OVS br      TC ingress                                TC ingress                    |
|          +---------------------+                   +---------------------+          |
|          |    TC ingress       |                   |    TC ingress       |          |
|          |   +-------------+   |                   |   +-------------+   |          |
|          |   |             |   |                   |   |             |   |          |
|   +------v---+---+     +---v---+------+     +------v---+---+     +---v---+------+   |
+---+              +-----+              +-----+              +-----+              +---+
    | UL rep       |     | VF0 rep      |     | vxlan        |     | VF1 rep      |
+---+              +-----+              +-----+              +-----+              +---+
|   +-------^------+     +-^------------+     +-----^--------+     +-------------^+   |
|           |              |                        |                            |    |
| Kernel    |              |                        |                            |    |
|           |              |        +---------------+     +--------------------+ |    |
|           |              |        |                     |namespace           | |    |
|           |              |        |                     |                    | |    |
|           |              | +------v-------+             |   +--------------+ | |    |
+----------------------------+              +-----------------+              +--------+
            |              | | VF0          |             |   | VF1          | | |
            |              | |              |             |   |              | | |
            |              | +----^---------+             |   +----------^---+ | |
            |              |      |                       |              |     | |
            |              |      |                       +--------------------+ |
            |              |      |                                      |       |
            |              |      |                                      |       |
            |              |      |                                      |       |
            |              |      |                                      |       |
            |              |      |                                      |       |
+-------------------------------------------------------------------------------------+
|           |              |      |                                      |       |    |
| Hardware  |              +------+                                      +-------+    |
|           |                                                                         |
|        +-----+                                                                      |
+--------+  |  +----------------------------------------------------------------------+
         |  v  |
         |     |
         +-----+

