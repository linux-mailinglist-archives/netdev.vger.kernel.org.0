Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D278D32542C
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhBYQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:59:21 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36235 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233644AbhBYQ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:58:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DFF96B0C;
        Thu, 25 Feb 2021 11:58:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 25 Feb 2021 11:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=x1yMfHdIO2g6cgqpobjZlt6E+rLwdD/4AQFjooM9VWA=; b=QrnCX5Ys
        4rVPwFUO9r+HzquZT21RT560eddkcgOXIlrNE1+1DdY29l+5bGEyYCMFSSvt14kO
        Q0gFBRaJYcbxqZ0r2iCyaGMrtG5rxBx/oceDiDv1i4PbUnZKQnaqX/c2czdOkIoD
        6hov279PMJdkVVcL5sKqs9gdq4U/7iti8MEVZlmSNo5YJGbYXHnnOZQQcVqUSDqz
        3OepTr75Mz9z5klQitVR8cRgvQTz4GnoeYApsVplPbz8EltnLADIXeDZG1kP0boM
        sa/ff3AtGBCUz1OsWd/2OpyStvvxt2N4mnGDYi3amWL+HJVTcB6bhJurkOvPRqnt
        khEFfmcuGCeF0A==
X-ME-Sender: <xms:Idc3YKHV4jmOxSnX8WjjoD9zOga-ZhGY29Z7cMnyusxvluXI54WCZw>
    <xme:Idc3YLW35Uc2WA5Qk4MDUjcbzAS-wuDNVUySMJtfEtlNvRydRWaaWeVn_32uM0wtx
    eWcr4loQjjSTm8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Idc3YEIuGEj66s12-2uG90kDFrKt2TkNx856STMvxidAI_5Mo5Lrzg>
    <xmx:Idc3YEFqlpF7bxyQNKJkTILzInA09_TzQY8W25x_IGQrooOyt8fwQw>
    <xmx:Idc3YAVosa4hDKFHXG4hewvCTnzTw0QooQyO-3mg5vAc5ZqJvu1GSw>
    <xmx:Idc3YOzpqNhC8CFnDsPFjL46rsiexfZ6AnPGjGq5qg74PtIY7bSKSQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1733C24005C;
        Thu, 25 Feb 2021 11:58:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/3] selftests: forwarding: Fix race condition in mirror installation
Date:   Thu, 25 Feb 2021 18:57:19 +0200
Message-Id: <20210225165721.1322424-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225165721.1322424-1-idosch@idosch.org>
References: <20210225165721.1322424-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

When mirroring to a gretap in hardware the device expects to be
programmed with the egress port and all the encapsulating headers. This
requires the driver to resolve the path the packet will take in the
software data path and program the device accordingly.

If the path cannot be resolved (in this case because of an unresolved
neighbor), then mirror installation fails until the path is resolved.
This results in a race that causes the test to sometimes fail.

Fix this by setting the neighbor's state to permanent, so that it is
always valid.

Fixes: b5b029399fa6d ("selftests: forwarding: mirror_gre_bridge_1d_vlan: Add STP test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh          | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
index 197e769c2ed1..f8cda822c1ce 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
@@ -86,11 +86,20 @@ test_ip6gretap()
 
 test_gretap_stp()
 {
+	# Sometimes after mirror installation, the neighbor's state is not valid.
+	# The reason is that there is no SW datapath activity related to the
+	# neighbor for the remote GRE address. Therefore whether the corresponding
+	# neighbor will be valid is a matter of luck, and the test is thus racy.
+	# Set the neighbor's state to permanent, so it would be always valid.
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_stp gt4 $swp3.555 "mirror to gretap"
 }
 
 test_ip6gretap_stp()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_stp gt6 $swp3.555 "mirror to ip6gretap"
 }
 
-- 
2.29.2

