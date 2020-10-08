Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792F62875C7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgJHOMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730319AbgJHOMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:12:41 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24020C061755;
        Thu,  8 Oct 2020 07:12:41 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w21so68690plq.3;
        Thu, 08 Oct 2020 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Mg0NsaEQzdvSh0ImH0acDVC5DgUluqcOLV+Kh6DIKuc=;
        b=ArvgXq0qpQFqB4D3ihquKaJx9DRs0tUKf7t0+6kkbKVGXsBXgsZemb6gF8F+1kWD7K
         1MnzZJfchRIcdz3C6T0sR/SrbcotU2FFWQntS1waiM1aSu53QojRwleA84pfafCllkt+
         Avhmz6ohcV7+VIH3Pg9/X/tg0YcOY2ieiZ5KjCiBrWRZpr+lsh0gjLnFGtjOufjX6tu5
         6NMLMDB2q+sUJVNRTrBx5CcGKc6Itt9vXkohDCEdgbFURknEQpMc32Z6cw5vwyQUVQVA
         ARPskEzMj4b1xCMNZY4Ahj8xYPWOr6AaYKr6sYIBIxR3u64lKv5u5yz1mRZqTDKO+7F3
         D4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mg0NsaEQzdvSh0ImH0acDVC5DgUluqcOLV+Kh6DIKuc=;
        b=R7WorBXG+GPWkX6KB1mJDdu9NkkbUVukkJjEDtdrVkzPrSDhbJw05OHt2wnOyxEz2k
         rwPwjCMmBnMin0m/2u1yCgDXhcHuDwZAryL1IIWh9Ul1K9U7V0227UmVAbqgl1cLNPXV
         3gFaJGpkwY/FhjUGJTCsGIA0OUp33/W8DQAQNxZW46QE8sZqZcnimwR0aP9+fZ0UgrJG
         k7Xznc6twKYtOqJUdHpi17jcwIueFqBL45MAxPyoxe7P7ZHEaybZZzEBvDmo2niPto8V
         cBfvtL6LJeCWkNeFHWUrhuBV8zyPXPkLN2nwBIf1YqqxpdnJLnYC17LVLtKAgygcrY/k
         X4kQ==
X-Gm-Message-State: AOAM533jwXSVkAtI+J4aSDvCwqgrSYDbaEufQ++7xplF3PsG51Vc/Qi1
        kJNMPc8dJjhZiU7FqFCTP7Q=
X-Google-Smtp-Source: ABdhPJy8zdWPheddoSx3e5JMrSy6LFT9TD9IXXIi1Rn+QmGUfUFb/VeXa/GSWywHILZThV3U9xOYvw==
X-Received: by 2002:a17:902:46b:b029:d2:aa9a:847f with SMTP id 98-20020a170902046bb02900d2aa9a847fmr7631753ple.24.1602166360747;
        Thu, 08 Oct 2020 07:12:40 -0700 (PDT)
Received: from localhost.localdomain (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id ne16sm7356811pjb.11.2020.10.08.07.12.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:12:40 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: introduce padding between ring pointers
Date:   Thu,  8 Oct 2020 16:12:18 +0200
Message-Id: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce one cache line worth of padding between the producer and
consumer pointers in all the lockless rings. This so that the HW
adjacency prefetcher will not prefetch the consumer pointer when the
producer pointer is used and vice versa. This improves throughput
performance for the l2fwd sample app with 2% on my machine with HW
prefetching turned on.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index dc1dd5e..3c235d2 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -15,6 +15,10 @@
 
 struct xdp_ring {
 	u32 producer ____cacheline_aligned_in_smp;
+	/* Hinder the adjacent cache prefetcher to prefetch the consumer pointer if the producer
+	 * pointer is touched and vice versa.
+	 */
+	u32 pad ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
 	u32 flags;
 };
-- 
2.7.4

