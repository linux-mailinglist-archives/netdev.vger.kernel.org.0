Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE5F0947
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfKEWZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:25:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37947 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbfKEWZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:25:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id v8so8089091ljh.5
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9adK9sQDwPx67mGpucGakQVejsiUwv5Zy9ukMwfSOcs=;
        b=MQCUHXpor6Jhb9Pjb6A3TabsfP45DFOkfV22odIpDSYXeLKSwKrf7JDM1rtVlhta9O
         QyMkUK/ud45nA/pCCD/9EsQggZV0TNg+9w4fHhE53OMlGxNr//yqKEYZ8dxrWLiD9s87
         dr8hc8HTGdl2shVau/9lO9JJ5VNaxNftkXXms0TuVMXr+DGdBiVy5dQbvyKxKhCRnYbs
         eyQbwCb34z2z3MZlbh56JnK5xXDSZ7zlwtIovlwOeV5+FYPt4pTSRtAY0zy6T84DqyDK
         fBtYTj1PgC4KH0E7HE3k7aAb9KR8qZvqAvWKk9Ow+fyiclLjKhSGFuZcGWS7tdM2Ck3J
         x/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9adK9sQDwPx67mGpucGakQVejsiUwv5Zy9ukMwfSOcs=;
        b=t7bI9LgTHt8gLDh+sc4aRC1li0s2FLB9TTaMcfv0ZFE//dDJlg68NWPRSOn30DCaBs
         gX+SRQA4r2ie1U3luGAPwAbTNzujrPyCH65Fl0kw6KjmPkFZKTWbQp05Hxio7XHjLkCR
         wfsacdSJh8K5xmbb31Q2M/xJwk4blTfWyuueH9ufO7j7faTu8UheHZhTCkhpLKvgjjsl
         eGGznnNmPuYcB21X+m3Bq3xn44SKVNob55SSo56czoxiiwQkoelsDIkusaSAEp5W45K5
         9ZHvNC7ZYd3vni/VXtaZVIhomRb4wAGXgCVJNhgPdBUAilaIry6AnaEXC9HmswkzTnTF
         wuGw==
X-Gm-Message-State: APjAAAUMoT0f3GIzClfVMOdKFsfYDekmcynlsmEgNhSDoZ4eVptauix4
        SdhhT3HSoMOVY2zPSO3H0D1lDQ==
X-Google-Smtp-Source: APXvYqzrxpCERcVS0ntlPuTrGS9DuGt0MTcq0xcHda3+ZiPbdCz6/rVIlPk6pFxOZ3jg1gNXQAkwvg==
X-Received: by 2002:a05:651c:1b0:: with SMTP id c16mr24055499ljn.192.1572992699587;
        Tue, 05 Nov 2019 14:24:59 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s25sm4020139lji.81.2019.11.05.14.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:24:58 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 3/3] selftests/tls: add test for concurrent recv and send
Date:   Tue,  5 Nov 2019 14:24:36 -0800
Message-Id: <20191105222436.27359-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105222436.27359-1-jakub.kicinski@netronome.com>
References: <20191105222436.27359-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test which spawns 16 threads and performs concurrent
send and recv calls on the same socket.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/net/tls.c | 108 ++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 4c285b6e1db8..1c8f194d6556 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -898,6 +898,114 @@ TEST_F(tls, nonblocking)
 	}
 }
 
+static void
+test_mutliproc(struct __test_metadata *_metadata, struct _test_data_tls *self,
+	       bool sendpg, unsigned int n_readers, unsigned int n_writers)
+{
+	const unsigned int n_children = n_readers + n_writers;
+	const size_t data = 6 * 1000 * 1000;
+	const size_t file_sz = data / 100;
+	size_t read_bias, write_bias;
+	int i, fd, child_id;
+	char buf[file_sz];
+	pid_t pid;
+
+	/* Only allow multiples for simplicity */
+	ASSERT_EQ(!(n_readers % n_writers) || !(n_writers % n_readers), true);
+	read_bias = n_writers / n_readers ?: 1;
+	write_bias = n_readers / n_writers ?: 1;
+
+	/* prep a file to send */
+	fd = open("/tmp/", O_TMPFILE | O_RDWR, 0600);
+	ASSERT_GE(fd, 0);
+
+	memset(buf, 0xac, file_sz);
+	ASSERT_EQ(write(fd, buf, file_sz), file_sz);
+
+	/* spawn children */
+	for (child_id = 0; child_id < n_children; child_id++) {
+		pid = fork();
+		ASSERT_NE(pid, -1);
+		if (!pid)
+			break;
+	}
+
+	/* parent waits for all children */
+	if (pid) {
+		for (i = 0; i < n_children; i++) {
+			int status;
+
+			wait(&status);
+			EXPECT_EQ(status, 0);
+		}
+
+		return;
+	}
+
+	/* Split threads for reading and writing */
+	if (child_id < n_readers) {
+		size_t left = data * read_bias;
+		char rb[8001];
+
+		while (left) {
+			int res;
+
+			res = recv(self->cfd, rb,
+				   left > sizeof(rb) ? sizeof(rb) : left, 0);
+
+			EXPECT_GE(res, 0);
+			left -= res;
+		}
+	} else {
+		size_t left = data * write_bias;
+
+		while (left) {
+			int res;
+
+			ASSERT_EQ(lseek(fd, 0, SEEK_SET), 0);
+			if (sendpg)
+				res = sendfile(self->fd, fd, NULL,
+					       left > file_sz ? file_sz : left);
+			else
+				res = send(self->fd, buf,
+					   left > file_sz ? file_sz : left, 0);
+
+			EXPECT_GE(res, 0);
+			left -= res;
+		}
+	}
+}
+
+TEST_F(tls, mutliproc_even)
+{
+	test_mutliproc(_metadata, self, false, 6, 6);
+}
+
+TEST_F(tls, mutliproc_readers)
+{
+	test_mutliproc(_metadata, self, false, 4, 12);
+}
+
+TEST_F(tls, mutliproc_writers)
+{
+	test_mutliproc(_metadata, self, false, 10, 2);
+}
+
+TEST_F(tls, mutliproc_sendpage_even)
+{
+	test_mutliproc(_metadata, self, true, 6, 6);
+}
+
+TEST_F(tls, mutliproc_sendpage_readers)
+{
+	test_mutliproc(_metadata, self, true, 4, 12);
+}
+
+TEST_F(tls, mutliproc_sendpage_writers)
+{
+	test_mutliproc(_metadata, self, true, 10, 2);
+}
+
 TEST_F(tls, control_msg)
 {
 	if (self->notls)
-- 
2.23.0

