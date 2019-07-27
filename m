Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBDD77AC7
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbfG0Rdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:33:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53753 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725263AbfG0Rdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:33:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C679F210A8;
        Sat, 27 Jul 2019 13:33:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 27 Jul 2019 13:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MpLIXhWJeDFRjA+th
        T8fBzeCifmJaGOKSnJA/6Fa/5c=; b=ws3Her+Fz05ZxKdkwEwM1QqjAW5zHCGwH
        nba8w8UcfUpBDIMI9MQJ2NXlzXWEBae1ZqOSaG1GXKGSpJFImuVnJae1Nc/2QH9g
        QdmQICED5wcHgzA9dRpuGfSgdh65jWdTL6ZAmoj0E6ms7xwluUPW3Epp675PuXHW
        Cy0hEf7Nek+9Wct3DXGxAvnQYc5d5HsNbC8zYmjCTyD5fqW9GE8iX8/t5Sd6rpA2
        1o4XyrOJcpwx3mfn+0On2gVUy3ZzrgU/E4sznUKAOYSB1L5ecbipsgMI4tNF0ukF
        /S/mp7mmcCE/Mr/Bf/fur41SWP2QOZ1PZHo2nXjs5HdtF8QvGjGTg==
X-ME-Sender: <xms:_Io8XWaCZDcAoZVhiZ7scdQI2RrEvq51C4PxRQfgzowCJ1Q_QzAz8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeigdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:_Io8XVhCavDN8eHZRH63qIf_d2TfKu46vBVff2X7grZ4TxVmX1RtvA>
    <xmx:_Io8XWYuDR9MfNdoKqgnZFb7trmS_MonmSAJh3E6wzoZi2In6PmLqA>
    <xmx:_Io8XX5SPoquHcD3ZDdqq5b2yNpdOXbYBAK3SvYj3602g9JjrnInzA>
    <xmx:_Io8XVQwmZHQZLsIX1UmOpQ36qzmrhJjIF87NbBhny3kTNQ-VByshQ>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3622380074;
        Sat, 27 Jul 2019 13:33:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: spectrum_acl: Forbid unsupported filters
Date:   Sat, 27 Jul 2019 20:32:54 +0300
Message-Id: <20190727173257.6848-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patches #1-#2 make mlxsw reject unsupported egress filters. These
include filters that match on VLAN and filters associated with a
redirect action. Patch #1 rejects such filters when they are configured
on egress and patch #2 rejects such filters when they are configured in
a shared block that user tries to bind to egress.

Patch #3 forbids matching on reserved TCP flags as this is not supported
by the current keys that mlxsw uses.

Jiri Pirko (3):
  mlxsw: spectrum_flower: Forbid to offload mirred redirect on egress
  mlxsw: spectrum_acl: Track rules that forbid egress block bind
  mlxsw: spectrum_flower: Forbid to offload match on reserved TCP flags
    bits

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  7 ++++--
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 17 ++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 22 +++++++++++++++++++
 4 files changed, 41 insertions(+), 7 deletions(-)

-- 
2.21.0

