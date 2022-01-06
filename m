Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596EB486392
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238349AbiAFLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:16:10 -0500
Received: from 1.mo552.mail-out.ovh.net ([178.32.96.117]:53983 "EHLO
        1.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiAFLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:16:10 -0500
Received: from mxplan1.mail.ovh.net (unknown [10.108.4.132])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 5620521F9C;
        Thu,  6 Jan 2022 11:16:08 +0000 (UTC)
Received: from bracey.fi (37.59.142.105) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 12:16:07 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-105G00658623213-be34-4282-a5db-53221f20f083,
                    983A4165C0DE8D18A60C99794E4AA4D91BE67B4B) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     <netdev@vger.kernel.org>
CC:     <toke@toke.dk>, Kevin Bracey <kevin@bracey.fi>
Subject: [PATCH iproute2] q_cake: allow changing to diffserv3
Date:   Thu, 6 Jan 2022 13:16:04 +0200
Message-ID: <20220106111604.2919263-1-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.105]
X-ClientProxiedBy: DAG8EX1.mxp1.local (172.16.2.15) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 59780f10-d871-4cd7-8bc6-034d74b6747e
X-Ovh-Tracer-Id: 14949698966201274589
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudefledgvdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffufffkofgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepueektdeiuefhueevheejudetleehudffheekffdtteegheefueeggfetudejgedunecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdprhgtphhtthhopehkvghvihhnsegsrhgrtggvhidrfhhi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A diffserv3 option (enum value 0) was never sent to the kernel, so it
was not possible to use "tc qdisc change" to select it.

This also meant that were also relying on the kernel's default being
diffserv3 when adding. If the default were to change, we wouldn't have
been able to request diffserv3 explicitly.

Signed-off-by: Kevin Bracey <kevin@bracey.fi>
---
 tc/q_cake.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/q_cake.c b/tc/q_cake.c
index 4cfc1c00..c438b765 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -95,7 +95,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	bool overhead_override = false;
 	bool overhead_set = false;
 	unsigned int interval = 0;
-	unsigned int diffserv = 0;
+	int diffserv = -1;
 	unsigned int memlimit = 0;
 	unsigned int fwmark = 0;
 	unsigned int target = 0;
@@ -356,7 +356,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (bandwidth || unlimited)
 		addattr_l(n, 1024, TCA_CAKE_BASE_RATE64, &bandwidth,
 			  sizeof(bandwidth));
-	if (diffserv)
+	if (diffserv != -1)
 		addattr_l(n, 1024, TCA_CAKE_DIFFSERV_MODE, &diffserv,
 			  sizeof(diffserv));
 	if (atm != -1)
-- 
2.25.1

