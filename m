Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75421F3CC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgGNOWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:22:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55065 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728478AbgGNOV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 884925C011D;
        Tue, 14 Jul 2020 10:21:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AoSVRjIY7zYCWziYCxM4YXlm/LG4FyGII58b2dss2n0=; b=j59KgbU8
        342AMp1DsHjML3W9HUUqpqykchTfTUxjT95XDmoSGGoE/OXmLGFjFaTeFL3j0O6M
        nrt8V047YmFVQ6Q0j8yGH0GAcC9qNfgbnXMrFc9GYTvtq976TuV3IeRqCZHY2xhc
        IyqnsqB1zU0YVmvbMfIN3XdMH7kzke6r344iv/W25YhUYoqhuvv85aICaiuFQohq
        eAwZ0JspG9JS4PjHSPAFcTG2uaEZBFmS6CQOKIsEZdHyJRYpbDH5UTtgZN1Fxqtx
        IV7xfggfCcB7Q3pyR2PmFWj+h4jTl+t2LBvPRO6vuAApy/r38hGvQTtdHlvBOFyh
        JRcaxhxAkhjdvQ==
X-ME-Sender: <xms:hb8NX3JsB5-GZ_xtHzUjXVRb4XMPTnyh0by3bZbmFAmrtlCpzK9M7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hb8NX7K0pX5_W8DrDrr9GmZNI29fB5zFbjWc7OgD57BjY_uqTfQhNg>
    <xmx:hb8NX_szXrQ3-CbLSpS5mPdqs-s7ThDFWxG-WPN6t-_1kpAsrSwdHA>
    <xmx:hb8NXwYQF0k3m-2Vc85XHzUtVTfiojE3OwXgH0TPMuIkpeH3eBCOhA>
    <xmx:hb8NX-HB3E16tC1WpRTf1M27ojvyafe7C1D18B6LbsKyEzyjqq3ZGw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B6BB30600B4;
        Tue, 14 Jul 2020 10:21:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/13] mlxsw: pci: Add mirror reason field to CQEv2
Date:   Tue, 14 Jul 2020 17:21:04 +0300
Message-Id: <20200714142106.386354-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The Completion Queue Element version 2 (CQEv2) includes a field called
'mirror_reason' which indicates why the packet was mirrored to the CPU.

Add the field so that it can be used by a later patch.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 697593e44f8a..a2c1fbd3e0d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -213,6 +213,11 @@ mlxsw_pci_cqe_item_helpers(dqn, 0, 12, 12);
  */
 MLXSW_ITEM32(pci, cqe2, user_def_val_orig_pkt_len, 0x14, 0, 20);
 
+/* pci_cqe_mirror_reason
+ * Mirror reason.
+ */
+MLXSW_ITEM32(pci, cqe2, mirror_reason, 0x18, 24, 8);
+
 /* pci_cqe_owner
  * Ownership bit.
  */
-- 
2.26.2

