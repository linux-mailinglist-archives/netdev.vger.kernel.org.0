Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062662EF43D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbhAHOyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:54:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36999 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727256AbhAHOyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:54:00 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E8A5B5C02FA;
        Fri,  8 Jan 2021 09:52:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 08 Jan 2021 09:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qKhNnu8Vlv9Gu9K5T
        fqEAWeQ4VDZDtzj02izJBGNlzU=; b=J2VlQ4IG4hyGy4f7uc2sjAIcKrD1433Tv
        BMeje+BGz4KU52S03pTxsWWoejf/NjfrTGiNPKP9oxTBPaiLMjNBuj9TH3oq62Jd
        jIy2ZQSI8X4AP8D8vwKx20yhEILuVzxlhHWWeIRm8p6dXbJNkjzdU2ocIOoKkPLF
        oyp0A/UteyCulNfv1wEkuDPPuugBHMaEt/UEZ38+KthYbDhFveyZ0N5nbbekiry0
        2u47/drDruHHXyHkhUBsJilEXHFSGgmAYzNx0snDP2AIHDpaXnGJ4hhsBh8OW2eE
        x63xwuVFreqPd+ExVngumeyyJKenXH7vaKPdM2vv6HvbDzj4vDgxQ==
X-ME-Sender: <xms:xXH4X-ZupiDKvrcnrH5d-i4NSwgaEcTGkIdFAG4vKnFYwwyjjxKbkA>
    <xme:xXH4Xw8bprwsWlgV_8bvhT4-87HiugxLFX87B-bBAIWCZrkheQ190xOd2Oqpqa_DQ
    YRwJXvyjPDSNZ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xXH4X9SSWGUznWHDdbq62sWR1iOq86EabYhL5hqQQRcKpFWcNiH_0Q>
    <xmx:xXH4XzJ88S4G-8jI4su88VfGOGDbWrgGR0ucEphfS4bOSxFkKn9Bvw>
    <xmx:xXH4X3ReOg8S0_FOdPdByDGwisUZjELWXXdcExd7MB3dVOc280L35A>
    <xmx:xXH4Xz4Cl5ZMceCj4WJWKsc27LrqqB7y4wl2TdcdIjDWK_db7sNlVQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EAAE24005D;
        Fri,  8 Jan 2021 09:52:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, vadimp@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: core: Thermal control fixes
Date:   Fri,  8 Jan 2021 16:52:08 +0200
Message-Id: <20210108145210.1229820-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This series includes two fixes for thermal control in mlxsw.

Patch #1 validates that the alarm temperature threshold read from a
transceiver is above the warning temperature threshold. If not, the
current thresholds are maintained. It was observed that some transceiver
might be unreliable and sometimes report a too low alarm temperature
threshold which would result in thermal shutdown of the system.

Patch #2 increases the temperature threshold above which thermal
shutdown is triggered for the ASIC thermal zone. It is currently too low
and might result in thermal shutdown under perfectly fine operational
conditions.

Please consider both patches for stable.

Vadim Pasternak (2):
  mlxsw: core: Add validation of transceiver temperature thresholds
  mlxsw: core: Increase critical threshold for ASIC thermal zone

 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.29.2

