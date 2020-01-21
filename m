Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42354143F7E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAUO1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:27:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36497 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgAUO1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:27:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so3450178wru.3
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:27:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Djrct5FowT2eMvh0UeYAXAaG8ISuKAqkosy/cwUkB0o=;
        b=sS3y4VR0a5iqsFu/T1cucxEBZtLk/eC4vG2Ld5qeesnPUoKLTWiejIOFCscg/HR4k/
         Mr7QlwKAppRSVfTlug/eClKAGCTrOlmkxfbOMthZaLkLzo0WotrRavdutYwhPKvucgP/
         XrFOs/byOZtf1/bHfVjVQNy5jLYaPmPMnwEHyzXFBqS6H71fO8eGhf+vwh1PU+/twmC4
         nrHjhysbfW13kC3T7rofx8ioGltSlry3xqIf4aiWJsSKzqjQu6rPNRd7mmus6Bt4ySq6
         wRqRBLdISRPEurz0ZFH9eHv/WcDSY5FYfBHUGdTXPsJGXm/MddRgFUn3QYN3B9/SWLp+
         IOyQ==
X-Gm-Message-State: APjAAAVtZeMUGHJFVfwsJvwctIQNkWfOTr08s04vVdGUn6Q+Erlz3OJD
        1IbMlQZBK2m9RMNWVbsSCPoT1pjmDKppUw==
X-Google-Smtp-Source: APXvYqxb4GfU0Vt8b7qPtNjm+4PZY6W2v4hJ9t8oPDQtQirwhRyqGlbMuPE+hQGNzDnCMPOmDzJA1Q==
X-Received: by 2002:a05:6000:f:: with SMTP id h15mr5712818wrx.90.1579616825863;
        Tue, 21 Jan 2020 06:27:05 -0800 (PST)
Received: from dontpanic.criteo.prod ([91.199.242.231])
        by smtp.gmail.com with ESMTPSA id c15sm51917160wrt.1.2020.01.21.06.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:27:05 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH v2] net, ip_tunnel: fix namespaces move
Date:   Tue, 21 Jan 2020 15:26:24 +0100
Message-Id: <20200121142624.40174-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
References: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the same manner as commit 690afc165bb3 ("net: ip6_gre: fix moving
ip6gre between namespaces"), fix namespace moving as it was broken since
commit 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.").
Indeed, the ip6_gre commit removed the local flag for collect_md
condition, so there is no reason to keep it for ip_gre/ip_tunnel.

this patch will fix both ip_tunnel and ip_gre modules.

Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv4/ip_tunnel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 0fe2a5d3e258..74e1d964a615 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -1236,10 +1236,8 @@ int ip_tunnel_init(struct net_device *dev)
 	iph->version		= 4;
 	iph->ihl		= 5;
 
-	if (tunnel->collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
+	if (tunnel->collect_md)
 		netif_keep_dst(dev);
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_init);
-- 
2.24.1

