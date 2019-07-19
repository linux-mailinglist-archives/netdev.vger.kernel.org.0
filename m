Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5108C6EA2E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbfGSRbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34889 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731515AbfGSRbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so31849035qto.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fV4ph13BVFW/+1nr5Bj/fvQhIU+OIFSNkY2BpnkSbfA=;
        b=lueMyQB5z0oY8OSQ7RFnZ9OnzjSD6kJS1yc62Y6ZUmlgZskJrtxfv3ldWrejhxDJcZ
         Sx3VXfozsEOLhwQMzO57uBHc0awqfPbJxUJdEVfTPCKOkbtmxCL+6Xss8TlByHc4j7gt
         rY6IGcfV39DthB+KB3juzMnNKZ04913opqrUCJMEZv1ehmq1lrcxVcDwgAH1TLzUY4Zr
         UxG6+8E/DGCgsOG6dBP+qyni6uPIdgux45+4+IaJwSD2PGBn/0SU32cqwsltVnsMPm3g
         Lb3BX3xwQM5y24NSqMc4I+x4AHQdGlMRf9Ti5+F+Ruv5fMECpxBfHKRbP1ttmEQSQecj
         j9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fV4ph13BVFW/+1nr5Bj/fvQhIU+OIFSNkY2BpnkSbfA=;
        b=RWp0wRyfOP7bJMi1tUpDWcyoLOGqkAfM2KUSNIEc3xifmf5lNTBoODHHww0kHGTEb3
         PDyv0r6WZQuo5VsiS39LEmGSCNscmwG5KnYtsEGriB9FXU7RCIM0+gRa+fo3z7xLRzd8
         cFKSNHcle4K6VwDgYsCpT6povqiTZIEhqEd8dVtj8qN3AKE6OVZ30s4HBFsZM8tnYNVV
         XLE6cKapPtFwyQjXwigV3uJ60XqqhBTVzBGWuQyK+KQ/GDWvq+Ju+B+9yoham0BIYE2o
         6LNSbqMipLmrFFhF1D0D++OLEN4YDPdavB4I5S/KL16DRXIWnpWtiJ9+94+thrFOWBus
         gVww==
X-Gm-Message-State: APjAAAWnHWr4mD7nmxL/ODdAtQ8DF+6vqGF0vAnN/Ux+WYDlV8xaA7eP
        PfSPyEzKBOkfzRGlaybYWDVOIQ==
X-Google-Smtp-Source: APXvYqxaqJ/Lly6yEscJToMESM9ucwo+FS/i1kkn71ENSDhCL7vPQLgV1ApmLDHtp3ym3thqpLX3Ew==
X-Received: by 2002:a0c:e001:: with SMTP id j1mr39415835qvk.110.1563557476569;
        Fri, 19 Jul 2019 10:31:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 11/14] selftests/tls: test error codes around TLS ULP installation
Date:   Fri, 19 Jul 2019 10:29:24 -0700
Message-Id: <20190719172927.18181-12-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test the error codes returned when TCP connection is not
in ESTABLISHED state.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 52 +++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 194826fee4f7..10df77326d34 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -911,6 +911,58 @@ TEST_F(tls, control_msg)
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
+TEST(non_established) {
+	struct tls12_crypto_info_aes_gcm_256 tls12;
+	struct sockaddr_in addr;
+	int sfd, ret, fd;
+	socklen_t len;
+
+	len = sizeof(addr);
+
+	memset(&tls12, 0, sizeof(tls12));
+	tls12.info.version = TLS_1_2_VERSION;
+	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_256;
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	addr.sin_port = 0;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	sfd = socket(AF_INET, SOCK_STREAM, 0);
+
+	ret = bind(sfd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+	ret = listen(sfd, 10);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	EXPECT_EQ(ret, -1);
+	/* TLS ULP not supported */
+	if (errno == ENOENT)
+		return;
+	EXPECT_EQ(errno, ENOTSUPP);
+
+	ret = setsockopt(sfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, ENOTSUPP);
+
+	ret = getsockname(sfd, &addr, &len);
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EEXIST);
+
+	close(fd);
+	close(sfd);
+}
+
 TEST(keysizes) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.21.0

