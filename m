Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8100A1E1819
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbgEYXGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43151 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388099AbgEYXGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9888D5C018E;
        Mon, 25 May 2020 19:06:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=G9tMUOBShJJSdPLRc0gRLE4F+138T6CUAsUinW/NG18=; b=obiEuCeV
        PK4rolgZ4FfmZBQynIkr0VET05Ah5lUZ+IQPqKkYR5iCxD6w4GOc2+6T1FA8ZHH1
        iQVwh6d9RVXKZFwfbQUN5VHzyviHOrAPu11AKlh+Sb/5KNjqBUKUv+0uwCo/6QKo
        L5ZpAHskpYTWPHjkdgXX6uMkZMDxuDwmlX4T+1aq8HLDr9hUV+AELgUPgpW2KWLO
        BM4gRnzgrU95fD23Cqz4yX46UZLW8A30+kQ1dX6gkHjwBpXPp1B+OctUAWoQkghQ
        bXLNKRgkgO6EiA3ZkbgZqA+7L0125SgViBiex4YLZxms/rIwpUzYtIXICIHlk4vO
        j4iN7xx6FIJ6sA==
X-ME-Sender: <xms:ek_MXjzBtWMOKyyd0ycobM1p7arzDcy5YsHnnxQTlU2c8-sBkLicVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ek_MXrRKRTMFAu0JkIFGOyHysrWDAguu3-_MnVIpeMXVD85EdqKDDw>
    <xmx:ek_MXtXe7gLO3JYdU6pHxdK19BPqQREK4Z-meB5yifdRmRPbhiB9vw>
    <xmx:ek_MXtiqJ0N8qFnX4jdSEL0Sk0KXljcdjO81Kgs2h6aO6J1XB27aiQ>
    <xmx:ek_MXi45yD-p-YRgy-uaRbTEjy0mJGiIU4g2dTME2qBUzXmI8wXKAA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6714B328005E;
        Mon, 25 May 2020 19:06:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/14] mlxsw: spectrum_router: Allow programming link-local prefix routes
Date:   Tue, 26 May 2020 02:05:56 +0300
Message-Id: <20200525230556.1455927-15-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The device has a trap for IPv6 packets that need be routed and have a
unicast link-local destination IP (i.e., fe80::/10). This allows mlxsw
to ignore link-local routes, as the packets will be trapped to the CPU
in any case.

However, since link-local routes are not programmed, it is possible for
routed packets to hit the default route which might also be programmed
to trap packets. This means that packets with a link-local destination
IP might be trapped for the wrong reason.

To overcome this, allow programming link-local prefix routes (usually
one fe80::/64 per-table), so that the packets will be forwarded until
reaching the link-local trap.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 71aee4914619..c939b3596566 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5003,9 +5003,11 @@ static bool mlxsw_sp_fib6_rt_should_ignore(const struct fib6_info *rt)
 {
 	/* Packets with link-local destination IP arriving to the router
 	 * are trapped to the CPU, so no need to program specific routes
-	 * for them.
+	 * for them. Only allow prefix routes (usually one fe80::/64) so
+	 * that packets are trapped for the right reason.
 	 */
-	if (ipv6_addr_type(&rt->fib6_dst.addr) & IPV6_ADDR_LINKLOCAL)
+	if ((ipv6_addr_type(&rt->fib6_dst.addr) & IPV6_ADDR_LINKLOCAL) &&
+	    (rt->fib6_flags & (RTF_LOCAL | RTF_ANYCAST)))
 		return true;
 
 	/* Multicast routes aren't supported, so ignore them. Neighbour
-- 
2.26.2

