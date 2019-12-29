Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0031212C255
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfL2LlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:41:23 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52303 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2LlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:41:22 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 199D021B88;
        Sun, 29 Dec 2019 06:41:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6j0z5uLswp/o/7rNLDlkyVoHY0aXgbFBX+KjD2EtGAw=; b=LZXfevzA
        smntBkB1tblKXJ8mt+nf5HLTXHiOuKeTlL20X4eHYPNlWxU86twsk8ymDCZ19Ewk
        CA+Jon5Z1/TV7vDvpCKbR6fzpx4bFhd4Uw+iLbTFRGMdx9NgPNyti1sHKV70Yzrt
        LgfPpr4TrcO4q7jTxSL6aItvBA5Cc3YujScC80RXafyhPlG3ygv/BYBpsaJBj39F
        cFJP65y23a3OR4GiONUj0EbVyyg659vBkDNqHBeOsMYv31TKgIIdX8FguxbWq0lI
        Q58OjGZ5QVECBYV1Zy0PifjI/BuqcpDaqhaTmYQv9eYT/az1M5OWcMhfj64VWg01
        v0CGxDpO61mSRw==
X-ME-Sender: <xms:4JAIXrzounfS3Cudl3G9KK9N5TYk1Wn53vYfi5Js-5LBuZ-JhQGjzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dukedurdeiuddruddujeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4ZAIXqWWWT2hbrOsPlNvwzWk5mRl9Is7XuZBHqUXqy8-W2EMP_ZyTw>
    <xmx:4ZAIXtCDY5zguKeMwMOH5f0xzgr_x011QZJYpOJj5CAVZwAjBKsGSQ>
    <xmx:4ZAIXr6zmqzoGtbQNjQlGSL-7HMn7YpYx0uYXK8A1SokFQ_RF9qSGw>
    <xmx:4ZAIXjHIX3ws5vSaMDAXZdv8TBgToYZXpx-E2gu6Rh48RZufc2Alkg>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F31E3060AAA;
        Sun, 29 Dec 2019 06:41:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_router: Skip loopback RIFs during MAC validation
Date:   Sun, 29 Dec 2019 13:40:22 +0200
Message-Id: <20191229114023.60873-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229114023.60873-1-idosch@idosch.org>
References: <20191229114023.60873-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

When a router interface (RIF) is created the MAC address of the backing
netdev is verified to have the same MSBs as existing RIFs. This is
required in order to avoid changing existing RIF MAC addresses that all
share the same MSBs.

Loopback RIFs are special in this regard as they do not have a MAC
address, given they are only used to loop packets from the overlay to
the underlay.

Without this change, an error is returned when trying to create a RIF
after the creation of a GRE tunnel that is represented by a loopback
RIF. 'rif->dev->dev_addr' points to the GRE device's local IP, which
does not share the same MSBs as physical interfaces. Adding an IP
address to any physical interface results in:

Error: mlxsw_spectrum: All router interface MAC addresses must have the
same prefix.

Fix this by skipping loopback RIFs during MAC validation.

Fixes: 74bc99397438 ("mlxsw: spectrum_router: Veto unsupported RIF MAC addresses")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 08b7e9f964da..8290e82240fc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7079,6 +7079,9 @@ static int mlxsw_sp_router_port_check_rif_addr(struct mlxsw_sp *mlxsw_sp,
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
 		rif = mlxsw_sp->router->rifs[i];
+		if (rif && rif->ops &&
+		    rif->ops->type == MLXSW_SP_RIF_TYPE_IPIP_LB)
+			continue;
 		if (rif && rif->dev && rif->dev != dev &&
 		    !ether_addr_equal_masked(rif->dev->dev_addr, dev_addr,
 					     mlxsw_sp->mac_mask)) {
-- 
2.24.1

