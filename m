Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF112C254
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfL2LlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:41:21 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57127 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2LlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:41:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 52E5D21DC1;
        Sun, 29 Dec 2019 06:41:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CB8kgG60pgIN1UL/S
        3OrWKXr3MohmiD2FJlTfT4Bpr4=; b=LPDIGEjghv7YAN6K3EeJyL+dufTEBDbN9
        zzZmuBPONv7AyA52pwQq3LLgvUqgzGXqV0QppuJPIHkvd77r+7h9s8LN5GDaW9iZ
        zM96Qr3VyZ0JsmsVTtMFYvqm3ERFEz/MmhUZdNQ8srEu1xOz1heLiD8VbX9LFymN
        TUGyCAmHdIa3bszL0b50W8BONoYvtdUCMWY4F073Sw2L8vkgZqjh7hWq70jlWGzC
        j1dpLG645pJpUMZ8K0ewQngbLDTlucuOeAfLOUzzzM/Bbf7ufM3kQC6tKQxlmgYP
        SxnVcOGkCUEEnBKFqY9IENLtVT2rsSufudkoYPw4yw9nDNKX8ymZg==
X-ME-Sender: <xms:35AIXiLpeYzvjSPuparCNRpJNsb4HVhLv5PqWLO6JGWxMJKjWUGFcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:35AIXubE2V-Jibo-SyKmhJ01prsfBzLs0fIza-UKfR7XvW9Q-lWU7Q>
    <xmx:35AIXttmUjBDJp2vvSbT_g94XEcdbbvlhu0jFPrlDe05ioHOqBmUwg>
    <xmx:35AIXruWYWZLoeY0_V7Sz_kX3R7TlWtc1VPPR2-fsxFrS6Gw8TkRbw>
    <xmx:35AIXvZ40NIvFM8BEFrPG8_E_jI4D0xY98t0xOzJsml5iGkT7etKeg>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7FC93060AA8;
        Sun, 29 Dec 2019 06:41:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Couple of fixes
Date:   Sun, 29 Dec 2019 13:40:21 +0200
Message-Id: <20191229114023.60873-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains two fixes for mlxsw. Please consider both for
stable.

Patch #1 from Amit fixes a wrong check during MAC validation when
creating router interfaces (RIFs). Given a particular order of
configuration this can result in the driver refusing to create new RIFs.

Patch #2 fixes a wrong trap configuration in which VRRP packets and
routing exceptions were policed by the same policer towards the CPU. In
certain situations this can prevent VRRP packets from reaching the CPU.

Amit Cohen (1):
  mlxsw: spectrum_router: Skip loopback RIFs during MAC validation

Ido Schimmel (1):
  mlxsw: spectrum: Use dedicated policer for VRRP packets

 drivers/net/ethernet/mellanox/mlxsw/reg.h             | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        | 9 +++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.24.1

