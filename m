Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6587E11D912
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbfLLWKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:10:52 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:53177 "EHLO
        8.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731142AbfLLWKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:10:52 -0500
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2019 17:10:51 EST
Received: from player692.ha.ovh.net (unknown [10.108.57.95])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 679E0216A17
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 22:54:21 +0100 (CET)
Received: from jwilk.net (user-5-173-48-157.play-internet.pl [5.173.48.157])
        (Authenticated sender: jwilk@jwilk.net)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 8807AD1C74E2;
        Thu, 12 Dec 2019 21:54:17 +0000 (UTC)
From:   Jakub Wilk <jwilk@jwilk.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] ip: fix spelling of "Ki" IEC prefix
Date:   Thu, 12 Dec 2019 22:54:14 +0100
Message-Id: <20191212215414.3655-1-jwilk@jwilk.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13190198884696512494
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudeljedgudehgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheplfgrkhhusgcuhghilhhkuceojhifihhlkhesjhifihhlkhdrnhgvtheqnecukfhppedtrddtrddtrddtpdehrddujeefrdegkedrudehjeenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrieelvddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehjfihilhhksehjfihilhhkrdhnvghtpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The symbol for binary prefix kibi is "Ki", with uppercase K.
In contrast, the symbol for decimal kilo is lowercase "k".

Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
---
 ip/ipaddress.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 964f14df..511ca6a8 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -551,7 +551,8 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 
 void print_num(FILE *fp, unsigned int width, uint64_t count)
 {
-	const char *prefix = "kMGTPE";
+	const char *prefixes = "kMGTPE";
+	char prefix;
 	const unsigned int base = use_iec ? 1024 : 1000;
 	uint64_t powi = 1;
 	uint16_t powj = 1;
@@ -571,9 +572,9 @@ void print_num(FILE *fp, unsigned int width, uint64_t count)
 		if (count / base < powi)
 			break;
 
-		if (!prefix[1])
+		if (!prefixes[1])
 			break;
-		++prefix;
+		++prefixes;
 	}
 
 	/* try to guess a good number of digits for precision */
@@ -583,8 +584,11 @@ void print_num(FILE *fp, unsigned int width, uint64_t count)
 			break;
 	}
 
+	prefix = *prefixes;
+	if (use_iec && prefix == 'k')
+		prefix = 'K';
 	snprintf(buf, sizeof(buf), "%.*f%c%s", precision,
-		 (double) count / powi, *prefix, use_iec ? "i" : "");
+		 (double) count / powi, prefix, use_iec ? "i" : "");
 
 	fprintf(fp, "%-*s ", width, buf);
 }
-- 
2.24.0

