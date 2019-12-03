Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477CE110186
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLCPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:47:06 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52816 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfLCPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 10:47:06 -0500
Received: by mail-pf1-f202.google.com with SMTP id f20so2497624pfn.19
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 07:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kRouJ8RTqEgeOWOKZnXkXMRduTDj4jmtaojGXNiKbM0=;
        b=bCpnDgbs02ulSZ+iYJ+c1fRLiFYO6ymrrR0Ci99XIMO/l9kn+1yejEYV0aNMlZq23h
         Eoy7KEYSch6NUg/nOKo8CAhCMwwCfNHjBM85ONegRAxrCmH3ZENb3l5fEvR4+gPXINpK
         QFB5SqAZHjfY2P9bo+ASA4coU7wRrYgFXyLLBweCLfR5zgmWbNm/Wueq2Bcc/169G0Vb
         j5sKclTmAuUrS5jWRMWGhja/vODC72zS7amFtr5sKick9grsKuXy21sOE5QCQROmucm+
         us0GgjGOcijQkDJsFb0kd93KmHxEwNWYNXFtCNb31Kfax8OSi7qyq9WWEFqh+lhlTP7A
         GOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kRouJ8RTqEgeOWOKZnXkXMRduTDj4jmtaojGXNiKbM0=;
        b=tl8PJ2iRQqmMII6t47nsrDsj53H4odS1FT8GVkLURbEOgE3VYYloXsHJY2bzy3hYoQ
         EJzitGp+Hp4Krmh9t9t9jijaGLKc5fVEDD6rWNGuwlB8XRiKISNkPeoHe4/sbOhkpOkt
         Z7tKLKqTOj5Sq8KDvnsSYFHSrBZ3tiNMEzrVNBO26Lr25ktPylBpWz4c3m30zDbOPOhY
         Z95va8u54VHEF3EUa90V1FY7fQenkoAQ2FerVXfIb+6wwrw9AsxDjItANjcsc5wMKvDJ
         t7iETpDkI4jNxep4mKJLZmttlYv9eYQV/Dsg+rqbkeUUZIS7Ok3YGXsepOX4n+POhWy1
         /PWg==
X-Gm-Message-State: APjAAAWW0ZmsMMD77ugL0LuXjA3rCB1qC0o8ppMIASPB83I8vWbAlk3r
        DXhJ4EuJ3cqAoTHzPLsbd4DARFma/pfEjg==
X-Google-Smtp-Source: APXvYqxzLWH8KVRDbcLNfIc8bX9Xrhx6DaomOrPeXgmq1/2MjPSf9qG/XVqcYig0jPglpM26uwshHQotUvwTcg==
X-Received: by 2002:a65:6249:: with SMTP id q9mr6270504pgv.340.1575388025676;
 Tue, 03 Dec 2019 07:47:05 -0800 (PST)
Date:   Tue,  3 Dec 2019 07:47:01 -0800
Message-Id: <20191203154701.187275-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH iproute2] tc_util: support TCA_STATS_PKT64 attribute
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel exports 64bit packet counters for qdisc/class stats in linux-5.5

Tested:

$ tc -s -d qd sh dev eth1 | grep pkt
 Sent 4041158922097 bytes 46393862190 pkt (dropped 0, overlimits 0 requeues 2072)
 Sent 501362903764 bytes 5762621697 pkt (dropped 0, overlimits 0 requeues 247)
 Sent 533282357858 bytes 6128246542 pkt (dropped 0, overlimits 0 requeues 329)
 Sent 515878280709 bytes 5875638916 pkt (dropped 0, overlimits 0 requeues 267)
 Sent 516221011694 bytes 5933395197 pkt (dropped 0, overlimits 0 requeues 258)
 Sent 513175109761 bytes 5898402114 pkt (dropped 0, overlimits 0 requeues 231)
 Sent 480207942964 bytes 5519535407 pkt (dropped 0, overlimits 0 requeues 229)
 Sent 483111196765 bytes 5552917950 pkt (dropped 0, overlimits 0 requeues 240)
 Sent 497920120322 bytes 5723104387 pkt (dropped 0, overlimits 0 requeues 271)
$ tc -s -d cl sh dev eth1 | grep pkt
 Sent 513196316238 bytes 5898645862 pkt (dropped 0, overlimits 0 requeues 231)
 Sent 533304444981 bytes 6128500406 pkt (dropped 0, overlimits 0 requeues 329)
 Sent 480227709687 bytes 5519762597 pkt (dropped 0, overlimits 0 requeues 229)
 Sent 501383660279 bytes 5762860276 pkt (dropped 0, overlimits 0 requeues 247)
 Sent 483131168192 bytes 5553147506 pkt (dropped 0, overlimits 0 requeues 240)
 Sent 515899485505 bytes 5875882649 pkt (dropped 0, overlimits 0 requeues 267)
 Sent 497940747031 bytes 5723341475 pkt (dropped 0, overlimits 0 requeues 271)
 Sent 516242376893 bytes 5933640774 pkt (dropped 0, overlimits 0 requeues 258)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tc/tc_util.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index afdfc78f2e5b11af178bdf1db540d917b1f457f3..23115f9b950a8786453fad25be4244ff7c3bdd76 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -809,11 +809,18 @@ void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtat
 
 	if (tbs[TCA_STATS_BASIC]) {
 		struct gnet_stats_basic bs = {0};
+		__u64 packets64 = 0;
+
+		if (tbs[TCA_STATS_PKT64])
+			packets64 = rta_getattr_u64(tbs[TCA_STATS_PKT64]);
 
 		memcpy(&bs, RTA_DATA(tbs[TCA_STATS_BASIC]), MIN(RTA_PAYLOAD(tbs[TCA_STATS_BASIC]), sizeof(bs)));
 		print_string(PRINT_FP, NULL, "%s", prefix);
 		print_lluint(PRINT_ANY, "bytes", "Sent %llu bytes", bs.bytes);
-		print_uint(PRINT_ANY, "packets", " %u pkt", bs.packets);
+		if (packets64)
+			print_lluint(PRINT_ANY, "packets", " %llu pkt", packets64);
+		else
+			print_uint(PRINT_ANY, "packets", " %u pkt", bs.packets);
 	}
 
 	if (tbs[TCA_STATS_QUEUE]) {
-- 
2.24.0.393.g34dc348eaf-goog

