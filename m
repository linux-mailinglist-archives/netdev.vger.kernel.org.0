Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F9A36A334
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhDXVfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXVfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:35:12 -0400
Received: from daxilon.jbeekman.nl (jbeekman.nl [IPv6:2a01:7c8:aab4:5fb::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AE4C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 14:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jbeekman.nl
        ; s=main; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/+MThYSnFaQnrmuHlBZscVyuQwyH8k0TXXHYTbgmJFg=; b=TrU+a5yZ+m/p3Dfu1nStBCAuPJ
        nCuVOYSkwyiF6fHyjXMmxnGlebOXZxbyhXs9Mp5IBi+N8je4w7R2MK2l1uKZPP9c2tH7rVwgXMp0W
        dpaRb+Q1BsAMVUT/cic82bDfQdBMGxfwQeWtL3HyKUxHjVfu9xYyyIhbWQTv8teSSrYI/z1EHhhP3
        QGzfz/1D24Ew4cM1wDiO5Ms1ljDoVlMBbLF7mkqrRicXDNKIKyJFprFXBmUjcRXV8YJLEHIpYDtvY
        9NAVE6Kk4xZRzGfU4HFh31qwqWqCNRWDT/xHak4QlsnbuLC0i+UELLGfNoiPzFP42Th8pP2QHfJcq
        mjApAwNg==;
Received: from ip-213-127-124-30.ip.prioritytelecom.net ([213.127.124.30] helo=[192.168.3.100])
        by daxilon.jbeekman.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <kernel@jbeekman.nl>)
        id 1laPpj-0006gQ-J0
        for netdev@vger.kernel.org; Sat, 24 Apr 2021 23:29:00 +0200
From:   Jethro Beekman <kernel@jbeekman.nl>
To:     netdev@vger.kernel.org
Message-ID: <702c692e-c45a-8daa-50e1-e17564f8b787@jbeekman.nl>
Date:   Sat, 24 Apr 2021 23:28:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 213.127.124.30
X-SA-Exim-Mail-From: kernel@jbeekman.nl
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on daxilon.jbeekman.nl
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: Content analysis details:   (-2.9 points, 5.0 required)
        pts rule name              description
        --- ---------------------- --------------------------------------------------
        0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was
        blocked.  See
        http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        for more information.
        [URIs: jbeekman.nl]
        -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
        -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
        [score: 0.0000]
Subject: [PATCH iproute2-next] ip: Add nodst option to macvlan type source
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default behavior for source MACVLAN is to duplicate packets to
appropriate type source devices, and then do the normal destination MACVLAN
flow. This patch adds an option to skip destination MACVLAN processing if
any matching source MACVLAN device has the option set.

This allows setting up a "catch all" device for source MACVLAN: create one
or more devices with type source nodst, and one device with e.g. type vepa,
and incoming traffic will be received on exactly one device.

Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
---
 ip/iplink_macvlan.c   | 12 ++++++++++--
 man/man8/ip-link.8.in |  9 ++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
index 302a3748..9c109ef6 100644
--- a/ip/iplink_macvlan.c
+++ b/ip/iplink_macvlan.c
@@ -33,7 +33,7 @@ static void print_explain(struct link_util *lu, FILE *f)
 		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN]\n"
 		"\n"
 		"MODE: private | vepa | bridge | passthru | source\n"
-		"MODE_FLAG: null | nopromisc\n"
+		"MODE_FLAG: null | nopromisc | nodst\n"
 		"MODE_OPTS: for mode \"source\":\n"
 		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n"
 		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n",
@@ -58,7 +58,7 @@ static int mode_arg(const char *arg)
 static int flag_arg(const char *arg)
 {
 	fprintf(stderr,
-		"Error: argument of \"flag\" must be \"nopromisc\" or \"null\", not \"%s\"\n",
+		"Error: argument of \"flag\" must be \"nopromisc\", \"nodst\" or \"null\", not \"%s\"\n",
 		arg);
 	return -1;
 }
@@ -102,6 +102,8 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 
 			if (strcmp(*argv, "nopromisc") == 0)
 				flags |= MACVLAN_FLAG_NOPROMISC;
+			else if (strcmp(*argv, "nodst") == 0)
+				flags |= MACVLAN_FLAG_NODST;
 			else if (strcmp(*argv, "null") == 0)
 				flags |= 0;
 			else
@@ -159,6 +161,9 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (matches(*argv, "nopromisc") == 0) {
 			flags |= MACVLAN_FLAG_NOPROMISC;
 			has_flags = 1;
+		} else if (matches(*argv, "nodst") == 0) {
+			flags |= MACVLAN_FLAG_NODST;
+			has_flags = 1;
 		} else if (matches(*argv, "bcqueuelen") == 0) {
 			__u32 bc_queue_len;
 			NEXT_ARG();
@@ -229,6 +234,9 @@ static void macvlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[]
 	if (flags & MACVLAN_FLAG_NOPROMISC)
 		print_bool(PRINT_ANY, "nopromisc", "nopromisc ", true);
 
+	if (flags & MACVLAN_FLAG_NODST)
+		print_bool(PRINT_ANY, "nodst", "nodst ", true);
+
 	if (tb[IFLA_MACVLAN_BC_QUEUE_LEN] &&
 		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_QUEUE_LEN]) >= sizeof(__u32)) {
 		__u32 bc_queue_len = rta_getattr_u32(tb[IFLA_MACVLAN_BC_QUEUE_LEN]);
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a4abae5f..ce828999 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1354,7 +1354,7 @@ the following additional arguments are supported:
 .BI "ip link add link " DEVICE " name " NAME
 .BR type " { " macvlan " | " macvtap " } "
 .BR mode " { " private " | " vepa " | " bridge " | " passthru
-.RB " [ " nopromisc " ] | " source " } "
+.RB " [ " nopromisc " ] | " source " [ " nodst " ] } "
 .RB " [ " bcqueuelen " { " LENGTH " } ] "
 
 .in +8
@@ -1395,12 +1395,15 @@ forces the underlying interface into promiscuous mode. Passing the
 .BR nopromisc " flag prevents this, so the promisc flag may be controlled "
 using standard tools.
 
-.B mode source
+.BR mode " " source " [ " nodst " ] "
 - allows one to set a list of allowed mac address, which is used to match
 against source mac address from received frames on underlying interface. This
 allows creating mac based VLAN associations, instead of standard port or tag
 based. The feature is useful to deploy 802.1x mac based behavior,
-where drivers of underlying interfaces doesn't allows that.
+where drivers of underlying interfaces doesn't allows that. By default, packets
+are also considered (duplicated) for destination-based MACVLAN. Passing the
+.BR nodst " flag stops matching packets from also going through the "
+destination-based flow.
 
 .BR bcqueuelen " { " LENGTH " } "
 - Set the length of the RX queue used to process broadcast and multicast packets.
-- 
2.31.1

