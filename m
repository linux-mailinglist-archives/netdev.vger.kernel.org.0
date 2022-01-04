Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5939048397E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 01:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiADAht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 19:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiADAht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 19:37:49 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE8C061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 16:37:49 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g2so31260395pgo.9
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 16:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r80Q7ZgzFHWqgqEmnbgyRG7xd1r89s265D9J2/l+W84=;
        b=GsNxXiYaJhjn4p4UEFLhQ4tT7/ZZ9MKMlLnUZ7GOFrYE1DuHTKPU8j+sqN6MC2ESxg
         LXe90IgBSEMfQjB2V4I4Ljo9bMnqDeqyaX6JXkXC4Gefd9vC4/ZtcZX668OzQkkdgqrM
         DRwiHzXW5HiWscBlHyvY0wuDkGmkaUpzNSmUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r80Q7ZgzFHWqgqEmnbgyRG7xd1r89s265D9J2/l+W84=;
        b=ya9M5pxElcccmHA9oUqTOubE3Nb54EkAMRFDFF0IawryFRR/6UGG2C9+uf4v+MZxNG
         med6oVbJbbCXAJE8qs1M/XiAgwzpdkVt5LzPwYR8lLysiPEYjyvs8E/NBP3smbAIzJIr
         QSFtfGXLC0jXq4ypFZh4gMAPd1in1cIRE4N7GNqo71H/CmRnmkVswSL2y1jYZTbWFG0w
         gsV18X6fhRT/XD65JflmlEO4YxbeMzyFnlnbpC7VtPml+0kJpPoQ8r/7XnEEH4eF8EvG
         p1B++PqUL8ZRfznAn2+lVRds+9jB6xjDRwn6WyIiAQUz76ZivuzPQ/+nGysljif/tAk7
         faSA==
X-Gm-Message-State: AOAM5312WPjQuaNZIPAb2eTm2leVJwOC5KZJFzZdSduxhmVOu2UHU5Rp
        UDaPVFn9/lqQGcN+TVO3P3seDwuFBuAWMw==
X-Google-Smtp-Source: ABdhPJzRpoCt0hTzb+wYxLNL+V/Tb2VP5PdT0CMDeHJvrtKmLZZj5c1FgDf7py1HmXNLhZRwC8APVA==
X-Received: by 2002:a63:4:: with SMTP id 4mr42575666pga.250.1641256667512;
        Mon, 03 Jan 2022 16:37:47 -0800 (PST)
Received: from localhost ([2600:1700:2434:285f:6424:230a:127e:6cca])
        by smtp.gmail.com with ESMTPSA id s8sm16879954pfu.190.2022.01.03.16.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 16:37:47 -0800 (PST)
From:   Ivan Babrou <ivan@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Ivan Babrou <ivan@cloudflare.com>
Subject: [PATCH net] tcp: note that tcp_rmem[1] has a limited range
Date:   Mon,  3 Jan 2022 16:37:22 -0800
Message-Id: <20220104003722.73982-1-ivan@cloudflare.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of rcv_ssthresh is limited to tcp_rwin, which is limited
to 64k at the handshake time, since window scaling is not allowed there.

Let's add a note to the docs that increasing tcp_rmem[1] does not have
any effect on raising the initial value of rcv_ssthresh past 64k.

Link: https://lkml.org/lkml/2021/12/22/652
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
---
 Documentation/networking/ip-sysctl.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2572eecc3e86..16528bc92e65 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -683,7 +683,8 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	default: initial size of receive buffer used by TCP sockets.
 	This value overrides net.core.rmem_default used by other protocols.
 	Default: 131072 bytes.
-	This value results in initial window of 65535.
+	This value results in initial window of 65535. Increasing this value
+	won't raise the initial advertised window above 65535.
 
 	max: maximal size of receive buffer allowed for automatically
 	selected receiver buffers for TCP socket. This value does not override
-- 
2.34.1

