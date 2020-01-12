Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8991386FA
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbgALQHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 11:07:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59717 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733064AbgALQHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 11:07:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 993AC21111;
        Sun, 12 Jan 2020 11:07:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 Jan 2020 11:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NkzVWBsZVbdDXqpnA
        2xLqcUwl34l+L97SHocWNRNCcg=; b=Feh8CM+XT5O85hOenoH8+OlicRDPnOreV
        CPpkTnS4eIkoZmlYvuwELW4Nm/C0L44OHwTQ2jJZtXoqR/qrvuxnDtpn5E68ibTP
        UzkIKopQwBY5PNL+Sysg4pNFdk1lHQchtAT/ieOoj9H8mXAxTGuwm9GnpjWDdnAq
        ZjJpBowwUtjXraOdY7/Fwvfhx6UBYjnTI3R6+Efgb8EttYk0o8TuK+Cq7Pji+Rin
        FXpEpmgT1KuZRSM9lWMs8ZOCIX4M2/JibsCsjfvLrRNiidrmnX5JnGtHWVxjR9tE
        4wz41lV/45L0AX5EhasU5MxW0BFpxVUzXEerOsywmj3+5SAibsQew==
X-ME-Sender: <xms:KEQbXqoM72YkfNfvjFowRbDcYDH9lfliGju2P3mSsN3vtV-gcLXq2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeikedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:KEQbXgEYs2NS2Hyy43MgL3AIJHh4rTz8U3G4joeLWMNOT60R2nsAhA>
    <xmx:KEQbXskmPI7b-X4QEYG-Gwt9ktHB6SpcEJoFmAC3roVaO8XaUf1bVg>
    <xmx:KEQbXjmdi5JQOdOZK867nL4R8Wu8vXE_JD0x2Rvd2J2EEV6SY2I9Wg>
    <xmx:KEQbXkyoPTPXrf3lspyr8Xq2PnmiToCQjGVrfJoz1AVOVjzzZBR0ag>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 254EC80059;
        Sun, 12 Jan 2020 11:07:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/4] mlxsw: Various fixes
Date:   Sun, 12 Jan 2020 18:06:37 +0200
Message-Id: <20200112160641.282108-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various fixes for mlxsw.

Patch #1 splits the init() callback between Spectrum-2 and Spectrum-3 in
order to avoid enforcing the same firmware version for both ASICs, as
this can't possibly work. Without this patch the driver cannot boot with
the Spectrum-3 ASIC.

Patches #2-#3 from Shalom fix a long standing race condition that was
recently exposed while testing the driver on an emulator, which is very
slow compared to the actual hardware. The problem is explained in detail
in the commit message.

Patch #4 from Petr fixes a selftest.

Ido Schimmel (1):
  mlxsw: spectrum: Do not enforce same firmware version for multiple
    ASICs

Petr Machata (1):
  selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation

Shalom Toledo (2):
  mlxsw: switchx2: Do not modify cloned SKBs during xmit
  mlxsw: spectrum: Do not modify cloned SKBs during xmit

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 27 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  4 +++
 .../drivers/net/mlxsw/qos_mc_aware.sh         |  8 ++++--
 3 files changed, 36 insertions(+), 3 deletions(-)

-- 
2.24.1

