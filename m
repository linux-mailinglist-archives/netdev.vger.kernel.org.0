Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D581761CF
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgCBSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:04:13 -0500
Received: from mout-u-204.mailbox.org ([91.198.250.253]:65440 "EHLO
        mout-u-204.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgCBSEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:04:13 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 13:04:13 EST
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 48WSXZ0LGZzQlFm;
        Mon,  2 Mar 2020 18:57:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1583171852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gsM2JDR0/ipFVoiT0YeWl2IsNHIZLZXIv1ndATcIGmE=;
        b=o6xtyhOzZcI7S5AvBHzXOmXvt7oDqpXMvwGyx21kAbVaDSBOQASDrUDZDY2Vkkcs2iGGhR
        3bd0hrCOUVlWvjzLK/2UHIWvLrM979yiq4tgNbKUMvVEA3IoDyCXAoADZrM0rCNmfSuGQ9
        isNKfVFfVxZ+DFwLUrUm+MVBFiHSTdtKdN6WHWFSplEfE+naB9hN9LTihvLT5vUh8oDygw
        qodJiI3ZFpXYc0KzObaHFCXhHTchudAW1cuk8st8qXTiRTXRGPwkxi0y9ad78eMxM7fLD2
        7hE5a9c7/Pl5+bLoME0qrqEW5Dhp87TJXBh7ZWUPba1Ks9gmwBIVRDyRJnRBaA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id qIo7RDY_wgjy; Mon,  2 Mar 2020 18:57:31 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next 4/4] selftests: mlxsw: qos_defprio: Use until_counter_is
Date:   Mon,  2 Mar 2020 19:56:05 +0200
Message-Id: <b090beef61645cda58889a32ea9c1d0be60beb63.1583170249.git.petrm@mellanox.com>
In-Reply-To: <cover.1583170249.git.petrm@mellanox.com>
References: <cover.1583170249.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Instead of hand-coding the busywait() predicate, use the until_counter_is()
introduced recently.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Amit Cohen <amitc@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/qos_defprio.sh | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
index eff6393ce974..71066bc4b886 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
@@ -114,23 +114,12 @@ ping_ipv4()
 	ping_test $h1 192.0.2.2
 }
 
-wait_for_packets()
-{
-	local t0=$1; shift
-	local prio_observe=$1; shift
-
-	local t1=$(ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
-	local delta=$((t1 - t0))
-	echo $delta
-	((delta >= 10))
-}
-
 __test_defprio()
 {
 	local prio_install=$1; shift
 	local prio_observe=$1; shift
-	local delta
 	local key
+	local t1
 	local i
 
 	RET=0
@@ -139,9 +128,10 @@ __test_defprio()
 
 	local t0=$(ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
 	mausezahn -q $h1 -d 100m -c 10 -t arp reply
-	delta=$(busywait "$HIT_TIMEOUT" wait_for_packets $t0 $prio_observe)
+	t1=$(busywait "$HIT_TIMEOUT" until_counter_is ">= $((t0 + 10))" \
+		ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
 
-	check_err $? "Default priority $prio_install/$prio_observe: Expected to capture 10 packets, got $delta."
+	check_err $? "Default priority $prio_install/$prio_observe: Expected to capture 10 packets, got $((t1 - t0))."
 	log_test "Default priority $prio_install/$prio_observe"
 
 	defprio_uninstall $swp1 $prio_install
-- 
2.20.1

