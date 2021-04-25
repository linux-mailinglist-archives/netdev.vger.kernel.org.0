Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D59436A821
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhDYP6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:58:48 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:40258 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhDYP6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:58:48 -0400
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2021 11:58:47 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3B5813EBF7;
        Sun, 25 Apr 2021 17:58:03 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: bridge: split IPv4/v6 mc router state and export for batman-adv
Date:   Sun, 25 Apr 2021 17:57:31 +0200
Message-Id: <20210425155732.8561-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following are two patches for the Linux bridge regarding multicast
routers. They are rebased on top of the following fix:
"net: bridge: mcast: fix broken length + header check for MRDv6 Adv." [0]
And should be applied afterwards.

The first one splits the so far combined multicast router state into two
ones, one for IPv4 and one for IPv6, for a more fine-grained detection of
multicast routers. This avoids sending IPv4 multicast packets to an
IPv6-only multicast router and avoids sending IPv6 multicast packets to
an IPv4-only multicast router. This is also in preparation for the
second patch:

The second patch exports this now per protocol family multicast router
state so that batman-adv can then later make full use of the
Multicast Router Discovery (MRD) support in the Linux bridge. The
batman-adv protocol format currently expects separate multicast router
states for IPv4 and IPv6, therefore it depends on the first patch.
batman-adv will then make use of this newly exported functions like
this[1].

Regards, Linus

[0]: https://patchwork.kernel.org/project/netdevbpf/patch/20210425152736.8421-1-linus.luessing@c0d3.blue/
[1]: https://git.open-mesh.org/batman-adv.git/shortlog/refs/heads/linus/multicast-routeable-mrd
     -> https://git.open-mesh.org/batman-adv.git/commit/d4bed3a92427445708baeb1f2d1841c5fb816fd4

