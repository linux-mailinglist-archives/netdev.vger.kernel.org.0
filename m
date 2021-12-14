Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BBD473A2F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243430AbhLNB3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:29:49 -0500
Received: from out162-62-57-49.mail.qq.com ([162.62.57.49]:57349 "EHLO
        out162-62-57-49.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239113AbhLNB3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639445380;
        bh=L0NU3uCfH6BwHi/HtxNLgfo5q5Ci+ZYIu919U2rXtPU=;
        h=From:To:Cc:Subject:Date;
        b=URAQCruKriFrD1YS2fiqIED4juGMnPyMlTboaLlHqnasqKA6IMFDwIzQj96IJBOWW
         nwpY11yEdno7KpTf55sJx0IaVHr2SUXX/BAxM9aElN3g0SSUB0UiLNgcWwl72GnamN
         jd6rI7qVRBbodmQ7xFTfo7Q78gB/p2l4Ok+FJFOI=
Received: from localhost.localdomain ([218.197.153.188])
        by newxmesmtplogicsvrszb7.qq.com (NewEsmtp) with SMTP
        id 711AB499; Tue, 14 Dec 2021 09:28:17 +0800
X-QQ-mid: xmsmtpt1639445297twp53qpk6
Message-ID: <tencent_3C2E330722056D7891D2C83F29C802734B06@qq.com>
X-QQ-XMAILINFO: N0opbxSOYLeW1Bgt/ZOlSLkbg6r/9aRaI90p7x8tr/UsyfnUnXE8sAqheuJr9g
         BVQYKowrZX/y0XJ9gEIEiLWx3hf7dIbJU90D1qrOCEaIcJNPthCcSQs4ne34x+oJWON0/TM+jyk1
         BTv5r1JUz/Zzn4zS16Bvg292TRb2vT419bgeiU4vVVtemhnBs/oQSpBBhwi2z+sPk9yDMWzF7sGq
         QoPEFqvU9fSVwONsRfnosaNr43+raXzotqw2Q23vMWe0pfNW5AiDtybxFhDpxzjWb3E3qcmcbqmG
         7giaVYs8K826TqXTABYshejhBLu1nzWmbsKujzGvLLZzt0sfLzgzVjOOqIv5zbYipmGjLESjDelX
         XcbcswadYXZNXrw1hIQ3CtBEcoC3rvvx4gMCpb74ncogtdvY1Wn6PKmZue6YYymuYguEVAN8SYsb
         YY3Oa3z2nRR3PG8JedeX79QRR/lIlibggJ6bPfrXcK4jTB4IJ5ANwFSidY2natXOtXYZe804YvNh
         EhBHBJ0VnubMJIEzG0rJEn3bVAAm5Cvv7bkH1XcUW7RkPCGP6G/OlamyAFBPN29MDYJN/sldQV3y
         P3/LwLzwTy/+pCOPuSGA/oFW1LHU7E9l/dWJ4cZW9ZFOvHMHVRK0rTV80N6naLmvBjecf8OA5ZCp
         AcRbX6Bc/CfIIdKGWDlwRsg8yI4LQbzEvRtuxA8spyIrTF1RwaG/0jNxLWppICDZt6cMuFY7t80T
         4oblMLQi7LYufizEkWtNSXia50iGBUpqNm/E+77HgKuvkBJd8meyQXgqNHttMsgZQQpzLye3qjv0
         mXETDTEujkqxkHZ3xa18BPXuLii27xBJwjKiWqquzANBMOUvAcxGQpOU7atDIdFmsPYu/EMp1pVX
         McV3x5JFq3VZPIbqqk3wciL2FgWejQr2TK8fK2VelxDFT7Y0U9ixPpoKCs2idAVJG2/eYhWe/l
From:   xkernel.wang@foxmail.com
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [PATCH v2] tracing: check the return value of kstrdup()
Date:   Tue, 14 Dec 2021 09:28:02 +0800
X-OQ-MSGID: <20211214012802.1247-1-xkernel.wang@foxmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it so to catch the memory error in
time.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
Changelogs:
Compare with the last email, this one is using my full name.
And I am sorry that I did not notice the bugs in trace_boot.c had been
already patched. So I removed the content about trace_boot.c.
---
 kernel/trace/trace_uprobe.c | 5 +++++
 1 files changed, 5 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 225ce56..173ff0f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+	if (!tu->filename) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
-- 
