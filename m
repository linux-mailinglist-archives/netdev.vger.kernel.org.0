Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8011D39CE20
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFFI1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 04:27:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59247 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhFFI1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 04:27:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F1705C01AE;
        Sun,  6 Jun 2021 04:25:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 06 Jun 2021 04:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C9MWQ6GEW2/0hGWxY
        kiJUS0cRnGlEETEObr/sYQu/uk=; b=UYMZxYgo/uYQJN31HP0/uPKNjeG3lwOKT
        XmtB4El5VZMay1UP6S3Pk9ohW0wFpn4lgPWzRpK6sgKOWQSgqZ/8gh760srvpMec
        K3GVjgnq2z5WA44TzhXiJaT9rauO78CqLVuncpOuFdSfButQQLvjFuLQDg+ipSM/
        EorqjIvV9jabJGsEY/l4B3jOon1oSdCtRxQ/IwFjd7eoZoZQiPml+vKxhSwgYKjA
        59d+sgSof5RaCICdj/KIHJ0/ni6LG+dTf1mcfnH+7N/hWxM4/wwB0yEn5HAvMlBE
        9nkN2twsbidIDz93r7UoOy0CeY8LcS5uPzzrKBmuXGnWP7hNDyXlg==
X-ME-Sender: <xms:aYa8YKK3eI0LxIkT7kPJnw1147ilvAY1l26cGIc-qNkbsHoMsUcaHw>
    <xme:aYa8YCLYr77IMyKG2dqOYCpQH0d4IHvBF6Vt0WOTkpbOaMm7G1hqaXg8aO8T2t7Gs
    ONtrCV8Y-bDhDI>
X-ME-Received: <xmr:aYa8YKvqxd9G-J38MPy3szqD3IXclW3u8QmdNUKb0u8aFMCs3OEkqGYhhlPa_H3XEeCwBj1GnIL9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedthedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aYa8YPb4ofwexCl0vwsoS1gHZBBEDM0tp4UJAuDTdoFxCpSDV9Mh0g>
    <xmx:aYa8YBbJrynJipVzqZJSmtqtlEHShOb4OBAdwIILyCoS2CXI_hNvOw>
    <xmx:aYa8YLD-sKMkFjxTkJGLe8MPVwPWXhi-1ePF3FbWkOHG19IM9K9acQ>
    <xmx:aoa8YAVK9zjNQznkA0NALtHVDXgR4pj9zaw0TFvk_oagguJcgXfJFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Jun 2021 04:25:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/3] mlxsw: Thermal and qdisc fixes
Date:   Sun,  6 Jun 2021 11:24:29 +0300
Message-Id: <20210606082432.1463577-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patches #1-#2 fix wrong validation of burst size in qdisc code and a
user triggerable WARN_ON().

Patch #3 fixes a regression in thermal monitoring of transceiver modules
and gearboxes.

Mykola Kostenok (1):
  mlxsw: core: Set thermal zone polling delay argument to real value at
    init

Petr Machata (2):
  mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11
  mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()

 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c   | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h            | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 5 ++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.31.1

