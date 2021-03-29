Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DAF34C9A4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhC2Iak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:30:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50433 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233823AbhC2IaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:30:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B45165C0062;
        Mon, 29 Mar 2021 04:30:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 04:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=39bOTHCsHkTsjTjF/
        4cbZvZiqE+P5oDGG4AXfZOyWxM=; b=T24UeO+sbvVrAjfvp0dbs5kqQcm87mvpd
        VcOCcMTcM/ZsWfPFrMYJXY95orvGie62ARaD4A61/rf0RZOnrgWsR6LskcJSD8HV
        4xqCusOde3ukmMjbZoP5A7nUzMulTfA87oGi2NJ0+BPMFi2vM9b9XYWpWuKpi85C
        1UuyqKoLplhuUb+T0nRqb29FMQpcwkSmLsOcyl9Lwe3cfiHRSa8yH8Cn6+5ZKDdg
        a9UX2ZNMH8O7faF+ojZJLRKBn+Up184hkmCj2lGc3VcBaU7e/s0clUQl+HbCi1r4
        H3z8DGKpNqiysRJbZBt0qiFeOoeVRpzA5PWudVwzpEwNKBIHto6vg==
X-ME-Sender: <xms:CJBhYIV6W_L_EF3FW1_rbrcTsZiiNTKAbmEZQuO6xp3jtjT_0Dr0JQ>
    <xme:CJBhYMnEmPG_r3eENQTX8mxcGZbwua0Syl1m8VKqDIah7pSdgS6_7GFXGlTbToNrA
    t3yhLmrfHeUnK0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CJBhYMa3hM3CtOhJ85t75BhueP42jum1wBoazxszap5nRle2J5widg>
    <xmx:CJBhYHWPCSKh0oZYzVO8qVZyV2oV0TOXWs1DQuMIvtfccfy4jyBWjg>
    <xmx:CJBhYCn3FAfhi0jSYzU1RN0Ur1EF4lBiJ6ekrsc_is1Uu_ubd2WhiA>
    <xmx:CJBhYJv2kju3hmPZxZHPamdqAs-08BT8mtAe5RCZSnLRugGhlitN1g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A69924005D;
        Mon, 29 Mar 2021 04:29:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, toke@redhat.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
Date:   Mon, 29 Mar 2021 11:29:22 +0300
Message-Id: <20210329082927.347631-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes a discrepancy between the software and hardware data
paths with regards to ECN marking after decapsulation. See the changelog
for a detailed description.

Patch #2 extends the ECN decap test to cover all possible combinations
of inner and outer ECN markings. The test passes over both data paths.

Ido Schimmel (2):
  mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
  selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases

 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
 .../selftests/net/forwarding/vxlan_bridge_1d.sh   | 13 ++++++++++++-
 4 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.30.2

