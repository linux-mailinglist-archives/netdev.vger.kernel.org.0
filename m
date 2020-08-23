Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5D24EC22
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgHWIIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:08:07 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54473 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgHWIH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4578C5C0080;
        Sun, 23 Aug 2020 04:07:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1Ql38g1X/we1gQvRTy/kxvSnf59XZFWlpTE8Aj+T48E=; b=GTIJphto
        Tlkh91y8FiCSUhlEymi5U6fTXUICqSDfePpJIw5Reg5iFTppTWgMyFXGa+/PpF7Q
        ClY2DgPtd87o5fSmiPOCnyk5Ncz2sfriRFvn8/xDegoRw85WHGv+AuP3v+Kgwfgq
        tT6QVR6Puu5B7J03Ueo1xgAxUPCfnk6jx095DzNa/ECIRDwER6Qlom5lUZLYXKSf
        mGjh7+k9U93H0Vd5SNHUgjZFxT4rtGjDpFIZidt0NMVFR7HRBquxjUPg5Mrogr2t
        cyBeNFTVeUwHNtwoUZ39fXyGFaQKfbR3rYRTXggDx04NxaKq+K3pp0gebqXN5YtX
        R43Da2sVWe1nuQ==
X-ME-Sender: <xms:3SNCX8qEUbczy01MYDnVi7NBZ3L0zpJhZO2MhkMt2Je8QG2f02qImQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhefgtd
    fftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeekrddufedurdefheenucev
    lhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3SNCXyoiMSmvfzSEsMlXaLd4z_-99KtvZJRBccTQwEO-8g8vGUhJ0g>
    <xmx:3SNCXxOgtZBnTUWK8udzRovPDuIJ9RaYlh1k1hW4H8li-6ld-yPI-w>
    <xmx:3SNCXz6mjRt7qwyfcVPKeExRRrPydLPrVKH3ZN51RaFJ9tnCs3YcwQ>
    <xmx:3SNCX1T7zyuMLZa9vcd2sg_fTxKSOFRSo5F6NyMlFqLTeIUVPeLvaQ>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DEBD3280059;
        Sun, 23 Aug 2020 04:07:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/7] selftests: mlxsw: Reduce runtime of tc-police scale test
Date:   Sun, 23 Aug 2020 11:06:27 +0300
Message-Id: <20200823080628.407637-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the test takes about 626 seconds to complete because of an
inefficient use of the device's TCAM. Reduce the runtime to 202 seconds
by inserting all the flower filters with the same preference and mask,
but with a different key.

In particular, this reduces the deletion of the qdisc (which triggers
the deletion of all the filters) from 66 seconds to 0.2 seconds. This
prevents various netlink requests from user space applications (e.g.,
systemd-networkd) from timing-out because RTNL is not held for too long
anymore.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh   | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
index 4b96561c462f..3e3e06ea5703 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
@@ -24,6 +24,13 @@ tc_police_switch_destroy()
 	simple_if_fini $swp1
 }
 
+tc_police_addr()
+{
+       local num=$1; shift
+
+       printf "2001:db8:1::%x" $num
+}
+
 tc_police_rules_create()
 {
 	local count=$1; shift
@@ -34,8 +41,9 @@ tc_police_rules_create()
 	for ((i = 0; i < count; ++i)); do
 		cat >> $TC_POLICE_BATCH_FILE <<-EOF
 			filter add dev $swp1 ingress \
-				prot ip \
-				flower skip_sw \
+				prot ipv6 \
+				pref 1000 \
+				flower skip_sw dst_ip $(tc_police_addr $i) \
 				action police rate 10mbit burst 100k \
 				conform-exceed drop/ok
 		EOF
-- 
2.26.2

