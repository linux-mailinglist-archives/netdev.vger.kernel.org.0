Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BCEBC3A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfKADHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:07:20 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37294 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbfKADHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 23:07:19 -0400
Received: by mail-lj1-f196.google.com with SMTP id v2so8792628lji.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 20:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b1OUfOx59HZ05kbkI4SWpQfmHV+UbytCXy5YsXkUdRc=;
        b=phVXwwyG71Pn36LLKloiGWh16uXYgQ1/MZFKom0vcD+oHUbX86uyWnEcbMCP0VDQra
         MMdh434A8tKts9z/IPV61PKb4ibPd5T/0heWT+aHBgeo7B59Lwhh/nS8z9D0vD2A48nv
         xDFDytme9QI3z/t7rNM6wKCPJu/igSgaiNNuL5fPUBpuKHrqaQ/R4IQdnb5UheAoq4tj
         7ZzGKGrUMcKPKsXAV5GBdO7D323GuvCgaZTfrliCZXtmVlwNzUkHNxYc2go2Zdt/lUcU
         MHPXdtX0wjulXaHOsur1UGyVgIJL3QuAFL7nrGnBoD4CZKXCgULI6lTQrtfBlcKBA0jC
         P3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b1OUfOx59HZ05kbkI4SWpQfmHV+UbytCXy5YsXkUdRc=;
        b=U+y5t5P8LZplg7eOs1j/b1SZmrXjnTjDlFn3GqB6DGAddVDhRceAJ0frZQYFPRNbf4
         SPbI61JEa9hDvRIu6HdXXxGmpLI4d/2cy4dlQl82W11xvMHNbhMZ9KlAC67AzLrfZaxU
         u7MjKiw6VMyREc+QUUdcdHALGG5x3NaVKINg50hLiKjsIj9mYgj1XwUE2IhQGe0f31MD
         ziqyFPC+bfpMJIYgkTTHZ17+SoNJ0AWBuihZ5mm+phw+6QzZXjrk0IuqBCnz1zpDZdde
         pgGcmqLvmSGTOQikhe3NH5FCfS+cGiAwU4UnWsv+87J7f/ubelv8vcP8qRy3CLD82MgJ
         2Mlw==
X-Gm-Message-State: APjAAAU7+NuIBZyAPNBwAN80PJKncgnax5QQkxa5AVlbrpfLd1JTtPgK
        YInVNVC37xPkV4JHSbRJVfXFpw==
X-Google-Smtp-Source: APXvYqyC5pOy06k67ghn5bqVWdwBNu29xJpebi9Tm/Gv22pPtrJnx9WXdPnkXIpMbsmuafdoEuVZhg==
X-Received: by 2002:a2e:9954:: with SMTP id r20mr4076042ljj.197.1572577636941;
        Thu, 31 Oct 2019 20:07:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v6sm3926282ljd.15.2019.10.31.20.07.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 20:07:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net 2/3] net: cls_bpf: fix NULL deref on offload filter removal
Date:   Thu, 31 Oct 2019 20:06:59 -0700
Message-Id: <20191101030700.13080-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191101030700.13080-1-jakub.kicinski@netronome.com>
References: <20191101030700.13080-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 401192113730 ("net: sched: refactor block offloads counter
usage") missed the fact that either new prog or old prog may be
NULL.

Fixes: 401192113730 ("net: sched: refactor block offloads counter usage")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
CC: Vlad Buslov <vladbu@mellanox.com>

 net/sched/cls_bpf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index bf10bdaf5012..8229ed4a67be 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -162,16 +162,20 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	cls_bpf.name = obj->bpf_name;
 	cls_bpf.exts_integrated = obj->exts_integrated;
 
-	if (oldprog)
+	if (oldprog && prog)
 		err = tc_setup_cb_replace(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
 					  skip_sw, &oldprog->gen_flags,
 					  &oldprog->in_hw_count,
 					  &prog->gen_flags, &prog->in_hw_count,
 					  true);
-	else
+	else if (prog)
 		err = tc_setup_cb_add(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
 				      skip_sw, &prog->gen_flags,
 				      &prog->in_hw_count, true);
+	else
+		err = tc_setup_cb_destroy(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
+					  skip_sw, &oldprog->gen_flags,
+					  &oldprog->in_hw_count, true);
 
 	if (prog && err) {
 		cls_bpf_offload_cmd(tp, oldprog, prog, extack);
-- 
2.23.0

