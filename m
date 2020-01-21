Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91364144615
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAUUuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:50:21 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42890 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgAUUuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 15:50:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so4845235wro.9
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 12:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CT0s6p7QbR9i73xanPFy3vpuYjRGpFiNAnTqL9v6mYA=;
        b=F022G1RovnZTSxSOF/R2F282bCbdktmf2I65HPNgoNLfr3otk1ZUEIx6j4t9nyTMoy
         knFi6PoLmsClZREMuSZttGQ251skxStBpUHH0XaWZuQRRNDjEFvXLqIxRKX0tGCKo5rH
         /RRkwjAPc8guMPZenQs1Oeuf5y2oC+5jisXoqDwVmk3QPxVGv5eYSzgTdyxlNz6inDh2
         S1Gr3a/FrUiB4ojaAayhSkcHYGldKm0XaX/Gjnp4FgthoduoRVrK/RCDtBncLjR/ltmF
         thfp46JMKIpwPMKpGK4gBgguDl36wDhl2fTxt+ARzy0lgTssEDGxP4ZaiYDa7mjs4X2l
         R1ow==
X-Gm-Message-State: APjAAAVlpsgQFUo91vXBdQ9cuJ3YYCjHmHA2+GH1VVOmtndDdvfb8HU4
        I+ltPolLDhQgxd8O2bNCgcsFi969qR6TTw==
X-Google-Smtp-Source: APXvYqyj0WYql+9PEhHwMvx4HUsbbo3fAxieOwDBjPAWaY4PlCpcIlFJTLQuIL/Ia0EKaKUAiAj8DA==
X-Received: by 2002:adf:df90:: with SMTP id z16mr6876684wrl.273.1579639819393;
        Tue, 21 Jan 2020 12:50:19 -0800 (PST)
Received: from dontpanic.fritz.box (p5B262C34.dip0.t-ipconnect.de. [91.38.44.52])
        by smtp.gmail.com with ESMTPSA id m21sm768539wmi.27.2020.01.21.12.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 12:50:18 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH] net, ip6_tunnel: fix namespaces move
Date:   Tue, 21 Jan 2020 21:49:54 +0100
Message-Id: <20200121204954.49585-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the same manner as commit d0f418516022 ("net, ip_tunnel: fix
namespaces move"), fix namespace moving as it was broken since commit
8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel"), but for
ipv6 this time; there is no reason to keep it for ip6_tunnel.

Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv6/ip6_tunnel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2f376dbc37d5..b5dd20c4599b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1877,10 +1877,8 @@ static int ip6_tnl_dev_init(struct net_device *dev)
 	if (err)
 		return err;
 	ip6_tnl_link_config(t);
-	if (t->parms.collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
+	if (t->parms.collect_md)
 		netif_keep_dst(dev);
-	}
 	return 0;
 }
 
-- 
2.24.1

