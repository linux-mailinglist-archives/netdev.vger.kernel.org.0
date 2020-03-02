Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30B61761D0
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCBSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:04:16 -0500
Received: from mout-u-204.mailbox.org ([91.198.250.253]:65458 "EHLO
        mout-u-204.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbgCBSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:04:14 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 48WSXW28c1zQlFX;
        Mon,  2 Mar 2020 18:57:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1583171849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JG7QaWRukTAq7isl3/0FjkCBfirepZvOFhcw8pqtJ9I=;
        b=hDHPpWUk3ZDbQiRZfjoPbXDMGhsNH06mI1bEr2L2dFfq8WvnR8uoN44wkY6l54MOU3Zabf
        Rs9XSBSMzNsY2Rcn7n6EMQi4Uf3vqGYfAsAxp4ZGbNQ1sn1XzxrRz6vC3rL7jPDeZPq/Cy
        Pz39x+tKKVglAhhvCsIXoOeCKRL9En2YSJheWx/g2dc6ZWBC32R/maFH6/SzFDAvhYPZcW
        U72iocm8g8fOSfHvIF8qKE8kpNIKX6Nvrr7joFFc3hdseyIe7JD9WN9HRefFTZMqm4Jni5
        FHf6y2nAN1PH8kJx9cEyPmK0KcQMGUvu3C5CFgmhIdyb44ajnizvph7S/AZ2RA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 6dZ7hKbidoA7; Mon,  2 Mar 2020 18:57:28 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next 1/4] selftests: forwarding: lib: Add tc_rule_handle_stats_get()
Date:   Mon,  2 Mar 2020 19:56:02 +0200
Message-Id: <7348df2bee9f569b8dfbdf9fcd7f2b6f7ead9310.1583170249.git.petrm@mellanox.com>
In-Reply-To: <cover.1583170249.git.petrm@mellanox.com>
References: <cover.1583170249.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The function tc_rule_stats_get() fetches a given statistic of a TC rule
given the rule preference. Another common way to reference a rule is using
its handle. Introduce a dual to the aforementioned function that gets a
statistic given rule handle.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Amit Cohen <amitc@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 83fd15e3e545..de57e8887a7c 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -626,6 +626,17 @@ tc_rule_stats_get()
 	    | jq ".[1].options.actions[].stats$selector"
 }
 
+tc_rule_handle_stats_get()
+{
+	local id=$1; shift
+	local handle=$1; shift
+	local selector=${1:-.packets}; shift
+
+	tc -j -s filter show $id \
+	    | jq ".[] | select(.options.handle == $handle) | \
+		  .options.actions[0].stats$selector"
+}
+
 ethtool_stats_get()
 {
 	local dev=$1; shift
-- 
2.20.1

