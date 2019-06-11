Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BDF3C4E1
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404313AbfFKHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52201 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404303AbfFKHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D779224A3;
        Tue, 11 Jun 2019 03:20:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wykdbhUvnrYffCcbN9frz6sR9O5+Lz/k0SCeCLaiolg=; b=ePPZ7z+t
        0yM72Pf0rPH3N8h0Pg3z0LX8g9IimHrINya3te9m6J54eN6VdmGtwW6a5Guixg24
        WGHpEQ+13CzyKdJeqQKaB+V93vvh/0jI5xw03lPnW/kH47Gz68kMnd11y0YQ3Vrf
        NeN5STAi1VaTwTO22h9A8FKdwXOwS8dV+lXwYAvzLN+rKnc+yPzGGiYNIBgrSrq6
        qidWqLxEBeJ0GWybSAY30BPOlo47h802rcs7pFI5bcE82+zvMywUkxnXUkVO8Z6c
        93QawXFUXByyzl4Uqu6favZcCJodKc7Ufb/wJX+OxQK9MFOsyn8rlnhTo+m6Z+yL
        qxvl7eZ0FVw5Cw==
X-ME-Sender: <xms:NFb_XPcQlFJenJ8V42Nh_yPGwTlB2AoDfIDGHFS4Eeqii_TX13lnMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:NFb_XLD_H4qbwG5PVt_MtNr8bVoxS-5-C_Oe_uDhgeBkJ3GcgfNHrQ>
    <xmx:NFb_XNkQreeEeOInXbcXVlMxkSbrm8YOCoRBoS6Sx7CCq9NX-nTGUA>
    <xmx:NFb_XP8ofAUn3vo3pGKNJD3bOMlnB8Wkn7q0FBOlQK9znJYcqg_5dg>
    <xmx:NFb_XAKoN1onCRBslKgWq5BdkD8asRt7_3m2SdepqucbVTLslGNY3Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F045538008A;
        Tue, 11 Jun 2019 03:20:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 6/7] mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2
Date:   Tue, 11 Jun 2019 10:19:45 +0300
Message-Id: <20190611071946.11089-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Due to an issue on Spectrum-2, in front-panel ports split four ways, 2 out
of 32 port buffers cannot be used. To work around this, the next FW release
will mark them as unused, and will report correspondingly lower total
shared buffer size. mlxsw will pick up the new value through a query to
cap_total_buffer_size resource. However the initial size for shared buffer
pool 0 is hard-coded and therefore needs to be updated.

Thus reduce the pool size by 2.7 MiB (which corresponds to 2/32 of the
total size of 42 MiB), and round down to the whole number of cells.

Fixes: fe099bf682ab ("mlxsw: spectrum_buffers: Add Spectrum-2 shared buffer configuration")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 8512dd49e420..1537f70bc26d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -437,8 +437,8 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
 			   MLXSW_SP1_SB_PR_CPU_SIZE, true, false),
 };
 
-#define MLXSW_SP2_SB_PR_INGRESS_SIZE	40960000
-#define MLXSW_SP2_SB_PR_EGRESS_SIZE	40960000
+#define MLXSW_SP2_SB_PR_INGRESS_SIZE	38128752
+#define MLXSW_SP2_SB_PR_EGRESS_SIZE	38128752
 #define MLXSW_SP2_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp2_sb_pool_dess */
-- 
2.20.1

