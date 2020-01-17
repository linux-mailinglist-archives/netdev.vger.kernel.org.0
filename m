Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264F414039C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 06:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgAQFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 00:33:16 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33403 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgAQFdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 00:33:13 -0500
Received: by mail-pj1-f67.google.com with SMTP id u63so3844394pjb.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 21:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7t56xoYLiC/yRACKWo5J7lvJyAgC4NL+KZOfaxWaKp0=;
        b=gSKPTGRjZsIajOitr93F3NhUwWtEykxQcavTwJTMS7vH18V5Lt0eh50tMlBez1K3C6
         zzFgdiBRhYeATh3N5S1bDaggbdDeNcpBIcjS26D6g4Pdu59NeN62D6VXjMOdILAbKOtV
         4x2+wdUds8zLq9tBNcp8VyUirVT1BbkhXgYTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7t56xoYLiC/yRACKWo5J7lvJyAgC4NL+KZOfaxWaKp0=;
        b=HYyegD5zvphi89M4sVGSN+u/63SOJYrSJLFWSGZBpN5nbd0qyISnXLqCU5DnOlVcHP
         Y0fwo5bBCKpE9R1AeJju5juuysFPjST34Pd0PvAtcWww96jJsHoIMO0807bNigUIlZ9A
         1XGLBj1xmAAchIsxu70ozcC0O22BM+8IXOtNV4vx2gFf9jTRxthJMvWnp4WP9Brqghoe
         g40ChoAcNSOsvyDgc9gKKdoZbftsM6fZaIXHm11B+0FG3mROIWVFiKkerforuExfcyw2
         ii4pPL4vyVCbrOgu+36uNfW/QS2s/0Odi/3DA29Ax2TwOswiZDBvn2ankfGsOMa5H1Xu
         n2xA==
X-Gm-Message-State: APjAAAWYVqbBwA6jHhu7DdXV+OJcHiib+ZcNyO2DVnnKFvVDuPCvMNPe
        IISHoSQpghkaRgYGCtw/LuDjYTLmass=
X-Google-Smtp-Source: APXvYqz6EyFd+FB10EJFOtXfwkdTuKn11vieNKw0HSLbfWUAcZxQKAP5zeaRtYkGNDlenxZ3jMdJ8A==
X-Received: by 2002:a17:902:426:: with SMTP id 35mr35936699ple.302.1579239193214;
        Thu, 16 Jan 2020 21:33:13 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c188sm1357142pga.83.2020.01.16.21.33.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jan 2020 21:33:12 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/3] bnxt_en: Fix ipv6 RFS filter matching logic.
Date:   Fri, 17 Jan 2020 00:32:46 -0500
Message-Id: <1579239167-16362-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
References: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bnxt_fltr_match() to match ipv6 source and destination addresses.
The function currently only checks ipv4 addresses and will not work
corrently on ipv6 filters.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c779f9c..b441da5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11065,11 +11065,23 @@ static bool bnxt_fltr_match(struct bnxt_ntuple_filter *f1,
 	struct flow_keys *keys1 = &f1->fkeys;
 	struct flow_keys *keys2 = &f2->fkeys;
 
-	if (keys1->addrs.v4addrs.src == keys2->addrs.v4addrs.src &&
-	    keys1->addrs.v4addrs.dst == keys2->addrs.v4addrs.dst &&
-	    keys1->ports.ports == keys2->ports.ports &&
-	    keys1->basic.ip_proto == keys2->basic.ip_proto &&
-	    keys1->basic.n_proto == keys2->basic.n_proto &&
+	if (keys1->basic.n_proto != keys2->basic.n_proto ||
+	    keys1->basic.ip_proto != keys2->basic.ip_proto)
+		return false;
+
+	if (keys1->basic.n_proto == htons(ETH_P_IP)) {
+		if (keys1->addrs.v4addrs.src != keys2->addrs.v4addrs.src ||
+		    keys1->addrs.v4addrs.dst != keys2->addrs.v4addrs.dst)
+			return false;
+	} else {
+		if (memcmp(&keys1->addrs.v6addrs.src, &keys2->addrs.v6addrs.src,
+			   sizeof(keys1->addrs.v6addrs.src)) ||
+		    memcmp(&keys1->addrs.v6addrs.dst, &keys2->addrs.v6addrs.dst,
+			   sizeof(keys1->addrs.v6addrs.dst)))
+			return false;
+	}
+
+	if (keys1->ports.ports == keys2->ports.ports &&
 	    keys1->control.flags == keys2->control.flags &&
 	    ether_addr_equal(f1->src_mac_addr, f2->src_mac_addr) &&
 	    ether_addr_equal(f1->dst_mac_addr, f2->dst_mac_addr))
-- 
2.5.1

