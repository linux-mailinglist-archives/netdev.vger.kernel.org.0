Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8487610B754
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfK0USS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:18 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46809 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfK0USS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:18 -0500
Received: by mail-lf1-f68.google.com with SMTP id a17so18175439lfi.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GNm5U+SbQ/CB23zzHj1e0PLLCyq7ugRgikVFJWv5Sgg=;
        b=On1YKAUnFtRC7wfcMentIQgycdyVAkptl+JG+W4/hIlBjPTUxwJPRP45umifREFQfD
         dJVfTiI0PmZOfcWeurLU8LPP9FWm4lP8Eh8KYyxS/soZbaCxJL6s+UbSawrxsySn/IYO
         cLp7IAem+oOpaicno82sFEcJDSqFISZmQf3vQR2mjAMs0BFx84I8XnzTIW+N2isXOtIE
         IJ8EVJ/6aCWMvTAEoAMR6snJfP0WS0vlPqxRkHE4rcmBwXb/SosH34U8yzpgR2vEXWBS
         IcosK1kjg+s/fzUVJ7vhk4sBCKnsbpGX8uPC95+4FgFkg1hjXVW6djM4qgyxGR/2eHlC
         /sOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GNm5U+SbQ/CB23zzHj1e0PLLCyq7ugRgikVFJWv5Sgg=;
        b=eWEIPx+nIYyNnRFvuNKXNgFYbKEiZmDx8MUnr0xFcqt80qkm/u9iTTFqfmNi1abQA2
         ZjUWRID0mrZ7jeh5hAnEc8fSEskQwHMFgskM4qaUuk4AubMKWg8XruL89tKOp9pHBKr7
         LIiL6ESOFyt4uIHZkeR2mWzZU8zAs1b5P8mp487tynFZDWTmQP5j85cfuiXXBTh4jfud
         uSBbcxG0qwJjYJAXTZqqISQOfNJN1XY8/Z1Cif8UxdIdjq150KShhF+CLbfYxpr3HQX6
         9tAF1adJSXo14lOHEqm4J+nRzGCxwRAnnNIrsMRcFHdNryJ2jm4kpCSr4vMsEfYAZF3d
         PlUw==
X-Gm-Message-State: APjAAAUspBK5Tvt8DKAQM6xg6/hD0B0TEzgvIQ/I6CPHKFui4i+RdUB2
        SSRFOPJJNohVtG3rXb9tzgF96A==
X-Google-Smtp-Source: APXvYqwmjFtlRzRpoGTOW56nl55IjeOQMhzMcaZPrUBuVRCqFqFx8U6Ass0+ij7RfmSCKC9vhiuSdA==
X-Received: by 2002:a19:5f05:: with SMTP id t5mr6973608lfb.149.1574885895720;
        Wed, 27 Nov 2019 12:18:15 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:15 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 7/8] selftests: bpf: test_sockmap: handle file creation failures gracefully
Date:   Wed, 27 Nov 2019 12:16:45 -0800
Message-Id: <20191127201646.25455-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_sockmap creates a temporary file to use for sendpage.
this may fail for various reasons. Handle the error rather
than segfault.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 3845144e2c91..8b838e91cfe5 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -332,6 +332,10 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 	int i, fp;
 
 	file = fopen(".sendpage_tst.tmp", "w+");
+	if (!file) {
+		perror("create file for sendpage");
+		return 1;
+	}
 	for (i = 0; i < iov_length * cnt; i++, k++)
 		fwrite(&k, sizeof(char), 1, file);
 	fflush(file);
@@ -339,6 +343,11 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 	fclose(file);
 
 	fp = open(".sendpage_tst.tmp", O_RDONLY);
+	if (fp < 0) {
+		perror("reopen file for sendpage");
+		return 1;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &s->start);
 	for (i = 0; i < cnt; i++) {
 		int sent = sendfile(fd, fp, NULL, iov_length);
-- 
2.23.0

