Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C8116738
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 07:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfLIG5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 01:57:05 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47531 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfLIG5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 01:57:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CA5A02236D;
        Mon,  9 Dec 2019 01:57:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 09 Dec 2019 01:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=btHcwHj1r71CM4Npr
        ekTpsT3iXZKUAaqASxedWWK4Yc=; b=RbMDv2YbvgQJRmPKnS7/ngW6Hg0tL4QlH
        Epn4nLKZFmYR7d0pLRKwdN93ksBxV3KKywPo3Q+p0bobLD2Txx3gEYbXWakMRUOX
        8dfYo40H7zJqaYZOjUeVgkjLKP3K7STlwZ+nFWyZwraDKImV0ydKmIoOg4iB0Hxe
        Ayrc/wqq/nfk0+UhKC/hFId/SKi6ypHWY2Kgrb9BHjZub8L2YpuW96Gl61yUJtUo
        /5Wr0pYFkd+Dt+GCDvfTgf/2tyNqodRJGlFR3s3tcICdbDj35ZM+AOIqA1FQFX0F
        7QsXf/RrJWGBXQyDOdzcoXjLIRxknQ196ZPYGlUmju3LtMpHVAxFg==
X-ME-Sender: <xms:P_DtXQHM66wUNPDvFGt4VNE305AQnAjxo_EKUqm58Wj3FaDLL0rl8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekledgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedu
X-ME-Proxy: <xmx:P_DtXZCXIp822F-oCfP3rl9f8V5HYISG1GmYVGk9Bai_hEx_Nw-_OQ>
    <xmx:P_DtXU8ugMHgqGzILWpdUogOB4E0bEvjCNFaQqZoxDczdm2J4UsoDw>
    <xmx:P_DtXUhtU94efjVfTANZbSoXPTbqvxdLLfVecS5MC0K08PqbuP5Wjg>
    <xmx:P_DtXRWB2-EEAlzadAV5DY4r2HVX8q2RblBjHmDS1vKeIbCBxxyyKA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B455B30600A8;
        Mon,  9 Dec 2019 01:57:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] selftests: forwarding: Delete IPv6 address at the end
Date:   Mon,  9 Dec 2019 08:56:34 +0200
Message-Id: <20191209065634.337316-1-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When creating the second host in h2_create(), two addresses are assigned
to the interface, but only one is deleted. When running the test twice
in a row the following error is observed:

$ ./router_bridge_vlan.sh
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
TEST: vlan                                                          [ OK ]
$ ./router_bridge_vlan.sh
RTNETLINK answers: File exists
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
TEST: vlan                                                          [ OK ]

Fix this by deleting the address during cleanup.

Fixes: 5b1e7f9ebd56 ("selftests: forwarding: Test routed bridge interface")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
index fef88eb4b873..fa6a88c50750 100755
--- a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
@@ -36,7 +36,7 @@ h2_destroy()
 {
 	ip -6 route del 2001:db8:1::/64 vrf v$h2
 	ip -4 route del 192.0.2.0/28 vrf v$h2
-	simple_if_fini $h2 192.0.2.130/28
+	simple_if_fini $h2 192.0.2.130/28 2001:db8:2::2/64
 }
 
 router_create()
-- 
2.23.0

