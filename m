Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43173227F4
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfESRqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:46:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43824 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfESRqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:46:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn7so1451796plb.10
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 10:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=siH0h08bo+poMfukgf+UGGSFOKy0KYXUk3xeaWxbyWE=;
        b=I4TkRwAT64red0QDk3HQlz4iknuK2VcaB3gY746KtgtKKeEIukghgr6mLLkx2yAGdq
         KiqZX7dJH3xObqbNjO0NEwfoQfSF5M9uWK5pSmpYwHm1wMt+PQOx0PAtfTlNYY5fhdRA
         vIdtrXLJcvkyAI88hfyaLPjvZw3v8gWM0qMoRnTi8+oJk7yR2c2AL7Ii4uHrRJZrFMfs
         oIWUQl8HmVA9hHIkshQSkaEr29CNKraPopZTslvZtrPdIJwGwMtzOQnwLznf5Jv4033a
         mjqVMxrqQfYR/Ob0X3R90t+6keAmUIRpT+qDkFGe5HmXqr70UZd4AT+bj43cRvbefS5+
         TjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=siH0h08bo+poMfukgf+UGGSFOKy0KYXUk3xeaWxbyWE=;
        b=mIlv9HO4OeRFCevi0DeiY/994WAUCk3XHvyH7p77U7qCE2wHKVcYtJSfTJ95TDokgB
         pHgmIsEpOklsW3sjE1EQBFUC3IVDa3nX5g4svssf+l4QPwoyobnLtk7vzYfK9RTWB5O1
         NVar0+HZCEh1lesLIofV1nc4a5bfU3KMedevsro2sX3W2QWtib2xNFGUKW535f7HcMGQ
         OnaqdscbgkfHPR+lrXua5rJt6KIQ8rKnhUyemcc7V9AAAppZd/j6i59usVMzqMIopa+h
         GOO9efdBKMYNMpC5tYroE4ZyWcfX/tbf9H48Aem7Hk2l/gKW1ipVpzn+HI5RonKJkXjE
         MGUA==
X-Gm-Message-State: APjAAAXMkt4k2YDogS1Fb/pcsnadKSYaS/VXjfVwHWJzrnl4oOHRuLTb
        97F5NiAofe0iQNcvV5fCM4soDRQ3Dmc=
X-Google-Smtp-Source: APXvYqw/xuSSVEMCdtHOfEIrw3lwtN0X44TShs9bJNA7LDieetozQN6K8S9mmoW3H9VqF3p0A1isVQ==
X-Received: by 2002:a17:902:e60a:: with SMTP id cm10mr60970246plb.316.1558256838378;
        Sun, 19 May 2019 02:07:18 -0700 (PDT)
Received: from localhost.localdomain (220-135-242-219.HINET-IP.hinet.net. [220.135.242.219])
        by smtp.googlemail.com with ESMTPSA id u134sm21544917pfc.61.2019.05.19.02.07.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 02:07:17 -0700 (PDT)
From:   Chang-Hsien Tsai <luke.tw@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, luke.tw@gmail.com
Subject: [PATCH] samples: bpf: fix: change the buffer size for read()
Date:   Sun, 19 May 2019 09:05:44 +0000
Message-Id: <20190519090544.26971-1-luke.tw@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the trace for read is larger than 4096,
the return value sz will be 4096.
This results in off-by-one error on buf.

    static char buf[4096];
    ssize_t sz;

    sz = read(trace_fd, buf, sizeof(buf));
    if (sz > 0) {
        buf[sz] = 0;
        puts(buf);
    }

Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>
---
 samples/bpf/bpf_load.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index eae7b635343d..d4da90070b58 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -678,7 +678,7 @@ void read_trace_pipe(void)
 		static char buf[4096];
 		ssize_t sz;
 
-		sz = read(trace_fd, buf, sizeof(buf));
+		sz = read(trace_fd, buf, sizeof(buf)-1);
 		if (sz > 0) {
 			buf[sz] = 0;
 			puts(buf);
-- 
2.17.1

