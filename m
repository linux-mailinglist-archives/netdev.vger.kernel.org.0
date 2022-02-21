Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7B4BEBBD
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiBUUWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:22:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiBUUWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:22:15 -0500
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 12:21:51 PST
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com [136.143.188.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C47212AD7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:21:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645474001; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Cx3lEaPUQllZFIAOwuAhJn+geQCg0PlevS4MNtAWXBruS7QDnzYDUeGcSkmOSNwtoos1Bcl65NfM7OWHKNsCxKKNV1RUgOh/3Y4Kpve0YZF2CLo20fbTcNApSN9ejzS+OQoqudWs0yvFOC+BwoYmmocHCv6yJFEoVCvTyLRT760=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645474001; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=J9lysjZMT86r7M6lYWcI7WS8cTF+xVIJmr49y4WIluM=; 
        b=nG4gvdfHetF5ZJk3pjumvaJe95/vzOb2rfOuDFiC9aIp1A569KkE950SGoDvaGhs8Tp+lbp4Wj50rB3boMLB5LaGNMBOUS0xIPWH6Oz5apgbI3IlvDR5VfwB+DlMgD94EBEW30AY/zyMNtF17wS8amhCNAvUOqKzLCdDONXPt8s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=machnikowski.net;
        spf=pass  smtp.mailfrom=maciek@machnikowski.net;
        dmarc=pass header.from=<maciek@machnikowski.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645474001;
        s=zoho; d=machnikowski.net; i=maciek@machnikowski.net;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=J9lysjZMT86r7M6lYWcI7WS8cTF+xVIJmr49y4WIluM=;
        b=YiIXBHBY5kWqzrQDqVuZxu3gWrS9JEnwEcWWEMwvdcLSrtS8CYC8w8Soz1Dq3iHl
        cr7YOZDSedkJ2G42ihIH46yyu2Fxh6wcTtXINj5+hdLwGfYY3OrimrlRnSnMeWSvUsw
        DDODEJwN0QIOMh8r4D3jJIp3tGlk2zRTEns6PakTMk6PxK5+lcy6DZtioLQKLEZK7nW
        1jHme/fMr2RikUnr8P72oSWMvg565odBHuNuKWV5EeirHM+LNiaEnAHvNmI+ocRZtCc
        vZyz2H4Jl+cX3OLGbV/IRWNPWt8lwmx6j4k7tiVGxvbCpYmlrT6AZni7RV17vsZEgG1
        9oMX89PAfA==
Received: from fedora.. (83.8.0.95.ipv4.supernova.orange.pl [83.8.0.95]) by mx.zohomail.com
        with SMTPS id 1645474000496398.4278167924168; Mon, 21 Feb 2022 12:06:40 -0800 (PST)
From:   Maciek Machnikowski <maciek@machnikowski.net>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com
Subject: [PATCH net-next] testptp: add option to shift clock by nanoseconds
Date:   Mon, 21 Feb 2022 21:06:37 +0100
Message-Id: <20220221200637.125595-1-maciek@machnikowski.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add option to shift the clock by a specified number of nanoseconds.

The new argument -n will specify the number of nanoseconds to add to the
ptp clock. Since the API doesn't support negative shifts those needs to
be calculated by subtracting full seconds and adding a nanosecond offset.

Signed-off-by: Maciek Machnikowski <maciek@machnikowski.net>
---
 tools/testing/selftests/ptp/testptp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index c0f6a062364d..198ad5f32187 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -133,6 +133,7 @@ static void usage(char *progname)
 		"            0 - none\n"
 		"            1 - external time stamp\n"
 		"            2 - periodic output\n"
+		" -n val     shift the ptp clock time by 'val' nanoseconds\n"
 		" -p val     enable output with a period of 'val' nanoseconds\n"
 		" -H val     set output phase to 'val' nanoseconds (requires -p)\n"
 		" -w val     set output pulse width to 'val' nanoseconds (requires -p)\n"
@@ -165,6 +166,7 @@ int main(int argc, char *argv[])
 	clockid_t clkid;
 	int adjfreq = 0x7fffffff;
 	int adjtime = 0;
+	int adjns = 0;
 	int capabilities = 0;
 	int extts = 0;
 	int flagtest = 0;
@@ -186,7 +188,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -223,6 +225,9 @@ int main(int argc, char *argv[])
 				return -1;
 			}
 			break;
+		case 'n':
+			adjns = atoi(optarg);
+			break;
 		case 'p':
 			perout = atoll(optarg);
 			break;
@@ -305,11 +310,16 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (adjtime) {
+	if (adjtime || adjns) {
 		memset(&tx, 0, sizeof(tx));
-		tx.modes = ADJ_SETOFFSET;
+		tx.modes = ADJ_SETOFFSET | ADJ_NANO;
 		tx.time.tv_sec = adjtime;
-		tx.time.tv_usec = 0;
+		tx.time.tv_usec = adjns;
+		while (tx.time.tv_usec < 0) {
+			tx.time.tv_sec  -= 1;
+			tx.time.tv_usec += 1000000000;
+		}
+
 		if (clock_adjtime(clkid, &tx) < 0) {
 			perror("clock_adjtime");
 		} else {
-- 
2.35.1

