Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D473B7B9B8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfGaGeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:34:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40873 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbfGaGeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:34:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A29622171;
        Wed, 31 Jul 2019 02:34:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Jul 2019 02:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=tdNL4N5JoBiOvaSTza4aK0qWpHEA89RL5nUe2UmbMQ8=; b=Jft/p/Xm
        3KkIN1Je7DZZ5ewCCKtP9MgG79imESY6abYfq9MpnGHQQ32DZi0D0rnHUF3TsGVD
        NXLbtl3axWSg6eC1qnsCu6la8L3WbOQbyRCAsCjdLJbn9M/vAyOi2B4EviIBlgDK
        Va9cpE2lGcCeNQCuKAXbrrILdc2eHl+hIbcBntCGX9H6NEv4t5ftmgUZpOaAPfLR
        R9Fa/dnU9fGTVAL+XjZzhAMFNPL+bZWEttdBstvTK2hHrSMWx0CnXtyR5ZRXV2Dv
        MVXQiQxYMU4PFztTTQ4MNirraaI2hqCXYOf5xxo7W+MsPTpRNBz2U4IiUBJVS/hp
        AymY1WX9Hw4I+A==
X-ME-Sender: <xms:YzZBXeSzfzgUZwmJ_1ukqKsI4CgcqZGapNxiRgAOqVmBgPaGPAHNvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:YzZBXbkrf3Z4efnlGP7WFD0NmT2YJSYJd8H_fa0HzU7YTStm9rmcaQ>
    <xmx:YzZBXXNsPtzSZ7RBDIMmKoryF7N82moFSK9TallEOj-l2yW2G8iFAg>
    <xmx:YzZBXT3Xy7pruJmGzmzCl4qkLJT98vICRdTnBmdkkqJbs7gJF_3Y8w>
    <xmx:YzZBXTf0NxXGehaCNYVIqc6d6mZ8YfKVC7kYyYRfKI0nV-jgKW5oAA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FF84380083;
        Wed, 31 Jul 2019 02:34:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()
Date:   Wed, 31 Jul 2019 09:33:14 +0300
Message-Id: <20190731063315.9381-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731063315.9381-1-idosch@idosch.org>
References: <20190731063315.9381-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In case of sp2 pci driver registration fail, fix the error path to
start with sp1 pci driver unregister.

Fixes: c3ab435466d5 ("mlxsw: spectrum: Extend to support Spectrum-2 ASIC")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 650638152bbc..eda9c23e87b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -6330,7 +6330,7 @@ static int __init mlxsw_sp_module_init(void)
 	return 0;
 
 err_sp2_pci_driver_register:
-	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
+	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
 err_sp1_pci_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 err_sp2_core_driver_register:
-- 
2.21.0

