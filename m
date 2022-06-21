Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4580F552C5D
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347349AbiFUHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFUHvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:51:16 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4420A23BCB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:51:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t21so6092732pfq.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GN7zB2NYj9se7SNHdWenGk7HCJOsZUVKZL2g0+jkJw=;
        b=PoqpQkRCwLNHZsa5tCI0rhvdtvBpeQVhMGjmMaVqmWgan4E5ewmNpH0tstUWE0UAX5
         YWA4dvTSarJCd6mNTg+1peOTcpaMeXl3TRZMdDFnOKq3k4YjzRQif5DNVoLk49Rrgemz
         vl4+KLokT8YyUv21/tqQygBnW0cMl0MJxR02Y/8ZgeKak8J7ySJYfP6Ed93fFKSNTYPg
         UMaMKQBFs38ms4Il7IjhZ3EaTsesjYVQDUtqX+Y36o13yoAKz1nmzVBeuRTJkv1hGJSq
         bMgaucnrbbqukBoOGK3pWU5yflMLHASItTLmBWw/xYnEJnvzJl6BiA8Ic4T6uNcLIIvN
         1phA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GN7zB2NYj9se7SNHdWenGk7HCJOsZUVKZL2g0+jkJw=;
        b=aidh/HVoAqTlri4ZQeb6daRxpdIIxn11lHTScuhGd19z/mJ95axGK8LaDCeBZ6Pw2W
         uI4RiISaweepjTeOK5iV8hH5P+VbGMCNAyNC36USE7b90F1TBOB1dOo/Kt8aIpMop9ru
         bxFyJvD45HVl6YPb2N2mdAgz1w35rgnjyQuY5EG1GNZPob+DVix0IEa/aWjKIfv0JNxD
         st2V/hv36cE8C8gVRknuwm5n12vwQ9O+deGku7hSmZmnmXTxh12MCk8z4Vsc+Yq5ZUU0
         ZDduzHfYvUyhFoI98vpazJ1NAgaOjQenmWTnaCzXaJ8bV7542TBh7SRnIPQAJmWlBCZf
         1c0g==
X-Gm-Message-State: AJIora/bdQQWbtPVvsj6jqYrh6Yvkvm86eRliis3ha6hzIRp8GUqeDsC
        vXwPCPolkPT9Nr/vCf5esH1vfvi/S1U=
X-Google-Smtp-Source: AGRyM1uJU2zOVLxiD+IikToLKljHBi4luXEBDbs4SenHcdwQKfd55gnTlajc7gBIOFM0AKX2RctcoA==
X-Received: by 2002:a63:711e:0:b0:40c:c08d:79e0 with SMTP id m30-20020a63711e000000b0040cc08d79e0mr7790937pgc.357.1655797875571;
        Tue, 21 Jun 2022 00:51:15 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d88500b0016762bb256csm9895071plz.281.2022.06.21.00.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 00:51:15 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 iproute2-next] iplink: bond_slave: add per port prio support
Date:   Tue, 21 Jun 2022 15:51:05 +0800
Message-Id: <20220621075105.2636726-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621074919.2636622-1-liuhangbin@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per port priority support for active slave re-selection during
bonding failover. A higher number means higher priority.

This option is only valid for active-backup(1), balance-tlb (5) and
balance-alb (6) mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: no update
v2: update man page
---
 ip/iplink_bond_slave.c | 12 +++++++++++-
 man/man8/ip-link.8.in  |  8 ++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index d488aaab..8103704b 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -19,7 +19,7 @@
 
 static void print_explain(FILE *f)
 {
-	fprintf(f, "Usage: ... bond_slave [ queue_id ID ]\n");
+	fprintf(f, "Usage: ... bond_slave [ queue_id ID ] [ prio PRIORITY ]\n");
 }
 
 static void explain(void)
@@ -120,6 +120,10 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "queue_id %d ",
 			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_QUEUE_ID]));
 
+	if (tb[IFLA_BOND_SLAVE_PRIO])
+		print_int(PRINT_ANY, "prio", "prio %d ",
+			  rta_getattr_s32(tb[IFLA_BOND_SLAVE_PRIO]));
+
 	if (tb[IFLA_BOND_SLAVE_AD_AGGREGATOR_ID])
 		print_int(PRINT_ANY,
 			  "ad_aggregator_id",
@@ -151,6 +155,7 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 				struct nlmsghdr *n)
 {
 	__u16 queue_id;
+	int prio;
 
 	while (argc > 0) {
 		if (matches(*argv, "queue_id") == 0) {
@@ -158,6 +163,11 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u16(&queue_id, *argv, 0))
 				invarg("queue_id is invalid", *argv);
 			addattr16(n, 1024, IFLA_BOND_SLAVE_QUEUE_ID, queue_id);
+		} else if (strcmp(*argv, "prio") == 0) {
+			NEXT_ARG();
+			if (get_s32(&prio, *argv, 0))
+				invarg("prio is invalid", *argv);
+			addattr32(n, 1024, IFLA_BOND_SLAVE_PRIO, prio);
 		} else {
 			if (matches(*argv, "help") != 0)
 				fprintf(stderr,
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 6f332645..3dbcdbb6 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2567,6 +2567,8 @@ the following additional arguments are supported:
 .B "ip link set type bond_slave"
 [
 .BI queue_id " ID"
+] [
+.BI prio " PRIORITY"
 ]
 
 .in +8
@@ -2574,6 +2576,12 @@ the following additional arguments are supported:
 .BI queue_id " ID"
 - set the slave's queue ID (a 16bit unsigned value).
 
+.sp
+.BI prio " PRIORITY"
+- set the slave's priority for active slave re-selection during failover
+(a 32bit signed value). This option only valid for active-backup(1),
+balance-tlb (5) and balance-alb (6) mode.
+
 .in -8
 
 .TP
-- 
2.35.1

