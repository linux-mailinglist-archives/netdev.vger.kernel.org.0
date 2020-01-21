Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D776B143CF7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgAUMgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:36:55 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54795 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgAUMgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:36:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so2781807wmj.4
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 04:36:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p/15I04DCs7xI/8lTCUPFnQAvADXgd+irA7p/+ckj7Y=;
        b=rQFzPDcP36boSYqzZgFPW501Dos/q/7aJO9dCxHFBzgxxFax5uLn9gYNYEmebwmzjo
         e98DEHK4kVFySfkDMfWUNPvUnwmiLQ9XutzWT+TMe7ZqJiYk9D7LJ/MaNwAxO82/izdL
         NB7044ZX8/FUKYoqbO9SXMzXT1TfuavQBGaiWTYsTq80+iiTvM1T6HuB3gWN6eoC5e18
         4X7zBIk/R4XnWk/41SZwIYahLTlIVWSY6O/ArB/MZmLWYc+HCLGdGgC9NKufmIxDjvO8
         m2RYvF1++RmFdLFqkpP+he0vCPDeTJKToM4hzchpa5mVNpM5FPCZtTHqOaQALsWKcViH
         D1iA==
X-Gm-Message-State: APjAAAXhkxRnc3gADQyCOKy+JzJX61ExbWdWJLzeivZL5R03NnLSRDzC
        dEieb/Hauga7FGbVedARAvjCkRTRYt+nBw==
X-Google-Smtp-Source: APXvYqzdSXP3GUDOuByR+NsuFc3UYGM2gfELdgcrzWfSKMfL7RijCdM3h/H6sq803zzDhMHmE+2c6A==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr4225714wmb.41.1579610212359;
        Tue, 21 Jan 2020 04:36:52 -0800 (PST)
Received: from dontpanic.criteo.prod ([91.199.242.231])
        by smtp.gmail.com with ESMTPSA id 4sm3629267wmg.22.2020.01.21.04.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 04:36:51 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH] net, ip_tunnel: fix namespaces move
Date:   Tue, 21 Jan 2020 13:36:26 +0100
Message-Id: <20200121123626.35884-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.24.1
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

