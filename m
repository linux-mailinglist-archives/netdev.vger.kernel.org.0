Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76934F2C4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhC3VGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbhC3VGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:06:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC027C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:06:18 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q10so1418784pgj.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tDKj/krluxfAi36Z+u6+Pj/6gV+NVGWFS0IiIiGmZrQ=;
        b=KHuKdjckPeXs+gyV9h0P/rqsDNJDIuG+zbFVxsyvqOIRcbKhv/aHoUbHUSwhoMEazT
         MbMIZ12YYJqeQHiOA5ogvDM4tvT3SFkOdseb+660M64xMEgAJ27HvBWf5JsoXlYMtX3B
         XBb+51CGB8qUxQdQ3khmTaPMpWWQDfSCPyGzfLqctp/6r6h0toSlUwXKYuHZ7jU9Esl3
         JXyRBP82aaHGn1vNyD3sU9Ky/yfXWIQkw3dXsdPECSOAnSxBCck7Zhd0sHxPZnq70jEL
         r1GNoSRYDBDIht1pBDTOWdns0jIvc9EyOSGGgJBcysViatTTM4FtGQhAhMzEBGyibM/m
         iZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tDKj/krluxfAi36Z+u6+Pj/6gV+NVGWFS0IiIiGmZrQ=;
        b=kTEVIYKF0WnmQ6ZHmOcU9/VV3Cd3c98L4/hIyDxYaWW0CxkzBfiQ/Xu4428yLf4k87
         fa5inNtk/eyWz+LtkJgxFPv15whI2JqfkEOUVOz37wy7aia3Pyyd6cUrg4MGezyya/8A
         zbbPZ9oyFTbwN/UUgvMnL7XMtVenR7Flk8FwZUpgUIGPsPZmk4frF5/bAPSuKHtQPIlx
         72roeuczb2z0rgBKiXRLC6H8+Z0iLBzRLBE2pqw4me27wHxZjBU87azIxOLiraa6gTlm
         hxXDFJjWUjppwp4wi3iLvxDHpbcnvGyDIcmv763+yvSBju8ChXuWZJpy3wdP4JqaxwIM
         hc8w==
X-Gm-Message-State: AOAM533fGsOjQct0mdYrYJ5E21tuwGo3HYU6t3MevI1JMDxxPyZQXBP/
        J3FGGe1uLCcuJSnaWYrwYDw=
X-Google-Smtp-Source: ABdhPJydutETC0ZubmEwXoLN+sFgMcij50lVk820rsVFRsAiA8enYAANUyUzTOMrNAK9zKf2A1JXrA==
X-Received: by 2002:a63:1149:: with SMTP id 9mr52743pgr.169.1617138378603;
        Tue, 30 Mar 2021 14:06:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7943:6407:20df:4b55])
        by smtp.gmail.com with ESMTPSA id gb1sm50168pjb.21.2021.03.30.14.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 14:06:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next] net: fix icmp_echo_enable_probe sysctl
Date:   Tue, 30 Mar 2021 14:06:13 -0700
Message-Id: <20210330210613.2765853-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sysctl_icmp_echo_enable_probe is an u8.

ipv4_net_table entry should use
 .maxlen       = sizeof(u8).
 .proc_handler = proc_dou8vec_minmax,

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e3cb2d96b55e99f4322a99abb6a6da866dffcf4d..9199f507a005efc3f57ca0225d3898bfa5d01c53 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -601,9 +601,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "icmp_echo_enable_probe",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_enable_probe,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

