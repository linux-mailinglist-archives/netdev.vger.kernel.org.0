Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8E6230E46
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgG1Poh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbgG1Pog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:44:36 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1142C061794;
        Tue, 28 Jul 2020 08:44:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l17so6362652ilq.13;
        Tue, 28 Jul 2020 08:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zy5eAPM5UhzN9Zo5Jyp3qYsdKoOpl9ipB8pdLyvvc7A=;
        b=uiGRBiqL3yxZeGs+Q7BCAKlx1YAJwirZCftGG9OLRDjbyhreivPZqiLXpLgIQH1fel
         eq5Sp7mCpqAEZI85AAT5aCww5OQNKY88ckY/0zAQ1qCzv90CCx3wXzu0jXjKe7TQUZ0A
         vn6zNWw7RSjskR24DYcex8jDFFsRwyx+WWfX4vKAcMvSthzqutpUYuHo3PnMcxGM2t9f
         XuaxUDGkJ5IyWlv9DSN0TFJUMzm7CueEMEqAOAZyQnIW1uqFopec1Jo6wCuFRh0qw7mA
         w6hy9H5/YZqdj/NwonVa1edxZVwS0nqXaD0xWASCeTiwsIJM4YU71Yl1+WuaHdcOoWQf
         iOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zy5eAPM5UhzN9Zo5Jyp3qYsdKoOpl9ipB8pdLyvvc7A=;
        b=LmXqk0T1THk0L2cnJ+5+s0P96U8L93MMjSEA1iHFpB4aTg7FpbFHwj7rQOWIwV5MID
         EGo9qMXSKiNh1NrabZjw+2Tb5SZLq2AgSNkPL3/bXSh73o/X6Fzzzu3uqoUciG8nwnIK
         6YRB9ye2FCIJtV0AaGN5LqQyshaJVhsp6Kj/wwMYjdlOZAFntYlb9EIvKcdmEvNQTzv/
         N9djTpgZxGfjw18cKl+S9IXAenBUU+IbljbA6AyFP+qtbVTzaL0KtteL9/bdaQJM5oK2
         i1OWqUquMrYteFJthXD9g7nbSVUW2Aa+B4fDQtDcGmIV3jG6BSee+n4pUvzvdLW6pUBg
         kI0w==
X-Gm-Message-State: AOAM531rHWtKISC7KsyhBU9BTVK4GENkltHhnYT0WCPKadMyBFDYRmSB
        hTuR4cYQT8VXEFTmjJTgSjEszhPL
X-Google-Smtp-Source: ABdhPJw+k3mida/FS8L6V+XUxzA3hxKQUwBSv2ZCenTZsAAXLPc9JCE4tLTCRyea1dx0FnP3bgZpmg==
X-Received: by 2002:a92:5e9c:: with SMTP id f28mr2342290ilg.167.1595951076230;
        Tue, 28 Jul 2020 08:44:36 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g68sm8355750ilh.66.2020.07.28.08.44.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 08:44:35 -0700 (PDT)
Subject: [bpf PATCH 3/3] bpf, selftests: Add tests for sock_ops load with r9,
 r8.r7 registers
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 28 Jul 2020 08:44:23 -0700
Message-ID: <159595106312.30613.13837748007814593001.stgit@john-Precision-5820-Tower>
In-Reply-To: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loads in sock_ops case when using high registers requires extra logic to
ensure the correct temporary value is used. Lets add an asm test to force
the logic is triggered.

The xlated code for the load,

  30: (7b) *(u64 *)(r9 +32) = r7
  31: (61) r7 = *(u32 *)(r9 +28)
  32: (15) if r7 == 0x0 goto pc+2
  33: (79) r7 = *(u64 *)(r9 +0)
  34: (63) *(u32 *)(r7 +916) = r8
  35: (79) r7 = *(u64 *)(r9 +32)

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index f8b13682..6420b61 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -75,6 +75,13 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		: [skops] "r"(skops)
 		:);
 
+	asm volatile (
+		"r9 = %[skops];\n"
+		"r8 = *(u32 *)(r9 +164);\n"
+		"*(u32 *)(r9 +164) = r8;\n"
+		:: [skops] "r"(skops)
+		: "r9", "r8");
+
 	op = (int) skops->op;
 
 	update_event_map(op);

