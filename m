Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7F4F124
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfFUX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 19:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfFUX1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 19:27:10 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC923206B7;
        Fri, 21 Jun 2019 23:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561159629;
        bh=xnRd7i81N+JljCMp51ldXoOM80OaFuf3YHqkHx1mfmM=;
        h=From:To:Cc:Subject:Date:From;
        b=ERxdyNe5dFlMF/7uWmfjBWMABW08jPPqbbeniTxgL/gBqLd5PH+l422WfzdCXUois
         S9L1OZ5GXpQxKXXfYDCVDd/cHLlfxuZuUujEtRsfmVSu61RSDWFhXaS6MxSCnFS5Z2
         xlt2pdaSY2le1D/L7WQrhQ900m4KNPr0cmvpjE/o=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] rtnetlink: skip metrics loop for dst_default_metrics
Date:   Fri, 21 Jun 2019 16:27:16 -0700
Message-Id: <20190621232716.26755-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

dst_default_metrics has all of the metrics initialized to 0, so nothing
will be added to the skb in rtnetlink_put_metrics. Avoid the loop if
metrics is from dst_default_metrics.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/core/rtnetlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8ac81630ab5c..1ee6460f8275 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -751,6 +751,10 @@ int rtnetlink_put_metrics(struct sk_buff *skb, u32 *metrics)
 	struct nlattr *mx;
 	int i, valid = 0;
 
+	/* nothing is dumped for dst_default_metrics, so just skip the loop */
+	if (metrics == dst_default_metrics.metrics)
+		return 0;
+
 	mx = nla_nest_start_noflag(skb, RTA_METRICS);
 	if (mx == NULL)
 		return -ENOBUFS;
-- 
2.11.0

