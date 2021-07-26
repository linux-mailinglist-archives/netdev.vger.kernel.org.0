Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EEA3D644D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhGZP4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:56:06 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:31569 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbhGZPyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:54:20 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 1580C76F83;
        Mon, 26 Jul 2021 19:34:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1627317285;
        bh=n+/jCIqxkPc+U7K95IHIZEpB480Cz8N7WMX1G4wnx/0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=T6w5oTxIDKx/VGRU6umbF/Xtv1+F+MRIe5UKZf/CqQU/F49HTPYwB0ZFz5NtpSf1y
         6ijodCps9vR6967bHFjWFFwPFD9HMLyQBttGJ2OsS13T+VmnxLOe2X3ZB8mL/ylaiX
         9hkB/WpJZpsh9kQeJjTygMPrTratDwQR8LjAQX8U9D+98RfO4vasgRYPoHe8hu3zhB
         AOJSluxn/XxEb5yurGnAdqS3Y+oRw0Jn42H+lZTsdeimbMURbUctCY7GG9l9Ia8xQm
         Q+SvDklFdY7wF89uYT8AtitJ14UpITcUgp7YUK7WGktnPEpqyCmZvQTnEDyWk1mfBs
         vgCH635chgy7Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id D1DF576F89;
        Mon, 26 Jul 2021 19:34:44 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 26
 Jul 2021 19:34:44 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 7/7] vsock_test: 'SO_RCVTIMEO' test for SEQPACKET
Date:   Mon, 26 Jul 2021 19:34:36 +0300
Message-ID: <20210726163439.2590222-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 16:13:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165254 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 16:15:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 26.07.2021 14:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/26 14:52:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/26 14:01:00 #16958312
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test for receive timeout check: connection is established,
receiver sets timeout, but sender does nothing. Receiver's
'read()' call must return EAGAIN.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 tools/testing/vsock/vsock_test.c | 49 ++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 2a3638c0a008..aa2de27d0f77 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -391,6 +391,50 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_seqpacket_timeout_client(const struct test_opts *opts)
+{
+	int fd;
+	struct timeval tv;
+	char dummy;
+
+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	tv.tv_sec = 1;
+	tv.tv_usec = 0;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(tv)) == -1) {
+		perror("setsockopt 'SO_RCVTIMEO'");
+		exit(EXIT_FAILURE);
+	}
+
+	if ((read(fd, &dummy, sizeof(dummy)) != -1) ||
+	    (errno != EAGAIN)) {
+		perror("EAGAIN expected");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("WAITDONE");
+	close(fd);
+}
+
+static void test_seqpacket_timeout_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("WAITDONE");
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -431,6 +475,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_msg_trunc_client,
 		.run_server = test_seqpacket_msg_trunc_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET timeout",
+		.run_client = test_seqpacket_timeout_client,
+		.run_server = test_seqpacket_timeout_server,
+	},
 	{},
 };
 
-- 
2.25.1

