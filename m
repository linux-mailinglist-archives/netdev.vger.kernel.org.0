Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37C9327246
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhB1MqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 07:46:06 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:50920 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhB1MqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 07:46:05 -0500
Received: by mail-wm1-f41.google.com with SMTP id i9so10807556wml.0
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 04:45:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kRSLbhODb/XnkWXf2/NkFi0SqI8nfPA2LKM5fduKjT4=;
        b=JibkB0+MfdDjdoUh4BnTwziyXpX57OmJZ7RGupfB5Z8XUMLLqZI6G8u9sK95ni+VQ5
         FhUu4qnCv63bO7aa87Nkv8mkM6hv+GtZjD0L5Eb7//5Fit17hfqlJsUhiFN7SvvOPao3
         6RkXoMSJqTSbGCBWV9MOcT0gLiCf2mj+7hc9viSmzCaz9ep+Q5t97gWhvAe8NMEhRCqu
         MmDpendmDEW13KZ2E1UW9Z+j0SYs/OVHEb3/UnHfWLJwZLR+dn+n2IrMgeWKFxx9iBan
         QHijg3WeVvuidln139ZYarKtutk8S7mxLUVlU9heFQmJQtqLP+7KPxMEim+ewYs6eOts
         Regw==
X-Gm-Message-State: AOAM533CvojvnRmtLbTXlrRrOhgwm7iyg4S2/FEX1IuLt38pW+HFkIBM
        ahy3QIwIwFmJ9aGTmB5LccdD2KHPWZA=
X-Google-Smtp-Source: ABdhPJxmUWKKEHGCAh9lmUS0nOYEXam/eqQJmG717zdskwEkLz44S2gytIpOSYryJU6Lr5lOHmt4qQ==
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr1924607wmh.9.1614516323662;
        Sun, 28 Feb 2021 04:45:23 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id f7sm18159270wmh.39.2021.02.28.04.45.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 04:45:22 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] iproute: fix printing resolved localhost
Date:   Sun, 28 Feb 2021 12:45:20 +0000
Message-Id: <20210228124520.30005-1-bluca@debian.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

format_host_rta_r might return a cached hostname
via its return value and not use the input buffer.

Before:

$ ip -resolve -6 route
 dev lo proto kernel metric 256 pref medium

After:

$ ip/ip -resolve -6 route
localhost dev lo proto kernel metric 256 pref medium

Bug-Debian: https://bugs.debian.org/983591

Reported-by: Axel Scheepers <axel.scheepers76@gmail.com>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 ip/iproute.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 291f1a58..5853f026 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -796,9 +796,10 @@ int print_route(struct nlmsghdr *n, void *arg)
 				 "%s/%u", rt_addr_n2a_rta(family, tb[RTA_DST]),
 				 r->rtm_dst_len);
 		} else {
-			format_host_rta_r(family, tb[RTA_DST],
+			const char *hostname = format_host_rta_r(family, tb[RTA_DST],
 					  b1, sizeof(b1));
-
+			if (hostname)
+				strncpy(b1, hostname, sizeof(b1) - 1);
 		}
 	} else if (r->rtm_dst_len) {
 		snprintf(b1, sizeof(b1), "0/%d ", r->rtm_dst_len);
@@ -818,8 +819,10 @@ int print_route(struct nlmsghdr *n, void *arg)
 				 rt_addr_n2a_rta(family, tb[RTA_SRC]),
 				 r->rtm_src_len);
 		} else {
-			format_host_rta_r(family, tb[RTA_SRC],
+			const char *hostname = format_host_rta_r(family, tb[RTA_SRC],
 					  b1, sizeof(b1));
+			if (hostname)
+				strncpy(b1, hostname, sizeof(b1) - 1);
 		}
 		print_color_string(PRINT_ANY, color,
 				   "from", "from %s ", b1);
-- 
2.30.1

