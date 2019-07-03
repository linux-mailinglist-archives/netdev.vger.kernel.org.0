Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A2A5E298
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfGCLIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:08:38 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44769 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGCLIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 07:08:38 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so1642814edr.11
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 04:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0rCpXWl+92YOUi6pNXYFPTelqybljgDxZflBFl9rwIg=;
        b=tjYn3Bjv7XSzN5XecfL/lpdanGLImYhI2cEL07R//48Rh4AnNrxE8XQwpY0fjuQksB
         kltVnQbIclezUoBq62pQ7WdaFZ4BF47aDze2KAsz5rrTqgjAyxYCYGBO7B9b+6Z1WtvY
         GDf0LwJUkois7ySQ/9F321QR1OYfLxnmF+5laEUUYoGlylMWoX8TMPlTNvjg/vr27CNu
         F5yJl8pE2rYsljPr/kYCrhHhLTR1t+N6CWoy/QaeTUjdP1K/dxANlpYiMll5XNpDQ5wy
         QkMmFbNiYLcaWJuXpBwYqIz5YAntZ/4rulltCvE0gpJ0E7FgLzXYunM1pdUwkoa0EX04
         LRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0rCpXWl+92YOUi6pNXYFPTelqybljgDxZflBFl9rwIg=;
        b=lhN8W3IiNJli9g94iUkecXPlP613JyjRauzESPcFtjURAKTgVn42wqYWE6fTl5FqYE
         yLUZvzSFsz5TdlOuwS2wTxsELkVMB/qR+zAuIwAwuwp5ogwZWB8E1urZl/+0I7e8Cznu
         KX+wcxscckJNogfmHmMMiU0f23gyfoIfY3yk7lzS4aOLmTH0S0mc7vrabVm1agwsvLfX
         FwH3eKlTtTdzsVg045wzmC9URzIKO6YVxVmtYCmozy+pwXbdhxSK9iMe1n1HvNrKAhOH
         DW+Y1/T0SwBFYhlEIXUKx0G90wU0eftntDIQsJ4YwgGlXPuypo2ejU+Uvn3kFDHASeSw
         mRPw==
X-Gm-Message-State: APjAAAWhaIs/0hKelQl61z1I6y+clb4vuP7k0JdZbM78P/G+XMgg6BGB
        QC2NOeAuPQe075WmrbmWqAs=
X-Google-Smtp-Source: APXvYqyyeG7LOytOjCkckK2Brv03ih8bI+S0R02bNjDFbZK6HukPST3LXj6zgYm9lB+hs4xTuDqB6Q==
X-Received: by 2002:a50:f98a:: with SMTP id q10mr41686806edn.267.1562152116541;
        Wed, 03 Jul 2019 04:08:36 -0700 (PDT)
Received: from localhost.localdomain (D96447CA.static.ziggozakelijk.nl. [217.100.71.202])
        by smtp.gmail.com with ESMTPSA id b49sm586004edc.51.2019.07.03.04.08.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 04:08:36 -0700 (PDT)
From:   Frank de Brabander <debrabander@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Cc:     netdev@vger.kernel.org, Frank de Brabander <debrabander@gmail.com>
Subject: bug: tpacket_snd can cause data corruption
Date:   Wed,  3 Jul 2019 13:07:08 +0200
Message-Id: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 5cd8d46e a fix was applied for data corruption in
tpacket_snd. A selftest was added in commit 358be656 which
validates this fix.

Unfortunately this bug still persists, although since this fix less
likely to trigger. This bug was initially observed using a PACKET_MMAP
application, but can also be seen by tweaking the kernel selftest.

By tweaking the selftest txring_overwrite.c to run
as an infinite loop, the data corruption will still trigger. It
seems to occur faster by generating interrupts (e.g. by plugging
in USB devices). Tested with kernel version 5.2-RC7.

Cause for this bug is still unclear.

Signed-off-by: Frank de Brabander <debrabander@gmail.com>
---
 tools/testing/selftests/net/txring_overwrite.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/txring_overwrite.c b/tools/testing/selftests/net/txring_overwrite.c
index fd8b1c6..3ee23e5 100644
--- a/tools/testing/selftests/net/txring_overwrite.c
+++ b/tools/testing/selftests/net/txring_overwrite.c
@@ -143,19 +143,22 @@ static int read_verify_pkt(int fdr, char payload_char)
 	int ret;
 
 	ret = read(fdr, buf, sizeof(buf));
-	if (ret != sizeof(buf))
-		error(1, errno, "read");
+	if (ret != sizeof(buf)) {
+		//error(1, errno, "read");
+		printf("read error\n");
+		return 1;
+	}
 
 	if (buf[60] != payload_char) {
 		printf("wrong pattern: 0x%x != 0x%x\n", buf[60], payload_char);
 		return 1;
 	}
 
-	printf("read: %c (0x%x)\n", buf[60], buf[60]);
+	//printf("read: %c (0x%x)\n", buf[60], buf[60]);
 	return 0;
 }
 
-int main(int argc, char **argv)
+void run_test(void)
 {
 	const char payload_patterns[] = "ab";
 	char *ring;
@@ -177,3 +180,10 @@ int main(int argc, char **argv)
 
 	return ret;
 }
+
+int main(int argc, char **argv)
+{
+	while (true) {
+		run_test();
+	}
+}
-- 
2.7.4

