Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B782231C13
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgG2J1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57737 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbgG2J1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 92C785C00EE;
        Wed, 29 Jul 2020 05:27:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=rRJmJr1rJ2gjTW2zKG44WiyGHlDoejDq3Wt8jf0qA7w=; b=dLcPW0IH
        ZnYDBXM6mDfpxX40YI3LRju/ROkh8dx81RmX223qTsV3ApgNVc6Z6y3B0vjbA6Qh
        QwFe6Rp0zSWlwA6bv1XHH0p5BC44uAvGPr+Eal7AzQJ4/6F54Z79eKSd7ItWyzki
        U0hPS8BUw63MpzvQBmc3IKcjqiLp57eZ3HuLAVrkoS053R8C14oxVk3r7Bj2e30D
        /V7K8CfCNvzWllFpZx61V5nJ9qYpIwv9xywALq3LgxoOB6fO6NMVtHVF7G2eVDMx
        BlPttDyAc3lUoIdM8b38tUZCDHcZpaoSPinthpOPn/UovqDWU6XzY1Ah7f3zJ0Az
        HJPlqCgHM0lEng==
X-ME-Sender: <xms:A0EhX-kY10nbP83cX8l43LccjoPGN0hyQWkgfgHu2IGV6ZD7_WRgAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeejrddvhedt
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:A0EhX10Nuf3_c5ucXtLFsN3YOL-OGIwV6GamV9OpeOamTJXvopq52g>
    <xmx:A0EhX8qW6DgLoco0ucxha4HVIdC7Ch3UQhVd94rkAbsZfTGwT6Zcjw>
    <xmx:A0EhXykcnaW3JpgrDhMfvKi3HdE6XPV9oSlsBK8kUhvOFP80vuLCzg>
    <xmx:A0EhX5yqAyZVcOLZ355ZETKwRqF1MUwkpugEmhFn-srt3lt4Z79hlQ>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8E303280059;
        Wed, 29 Jul 2020 05:27:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 6/6] selftests: ethtool: Fix test when only two speeds are supported
Date:   Wed, 29 Jul 2020 12:26:48 +0300
Message-Id: <20200729092648.2055488-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

The test case check_highest_speed_is_chosen() configures $h1 to
advertise a subset of its supported speeds and checks that $h2 chooses
the highest speed from the subset.

To find the common advertised speeds between $h1 and $h2,
common_speeds_get() is called.

Currently, the first speed returned from common_speeds_get() is removed
claiming "h1 does not advertise this speed". The claim is wrong because
the function is called after $h1 already advertised a subset of speeds.

In case $h1 supports only two speeds, it will advertise a single speed
which will be later removed because of previously mentioned bug. This
results in the test needlessly failing. When more than two speeds are
supported this is not an issue because the first advertised speed
is the lowest one.

Fix this by not removing any speed from the list of commonly advertised
speeds.

Fixes: 64916b57c0b1 ("selftests: forwarding: Add speed and auto-negotiation test")
Reported-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/ethtool.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool.sh b/tools/testing/selftests/net/forwarding/ethtool.sh
index eb8e2a23bbb4..43a948feed26 100755
--- a/tools/testing/selftests/net/forwarding/ethtool.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool.sh
@@ -252,8 +252,6 @@ check_highest_speed_is_chosen()
 	fi
 
 	local -a speeds_arr=($(common_speeds_get $h1 $h2 0 1))
-	# Remove the first speed, h1 does not advertise this speed.
-	unset speeds_arr[0]
 
 	max_speed=${speeds_arr[0]}
 	for current in ${speeds_arr[@]}; do
-- 
2.26.2

