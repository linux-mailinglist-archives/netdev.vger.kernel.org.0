Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629A714841D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392090AbgAXLkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:40:45 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39767 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392041AbgAXLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:40:33 -0500
Received: by mail-lj1-f193.google.com with SMTP id o11so2141414ljc.6
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtj5BWUVGyinNX7wvC73dcZuNmbbOVj5imGPpnqwC7s=;
        b=DYp8SwaR2RtLl8bAH4YtgflR2ni8IhDhhdGRpD50QqlucoswbUPkbngw/FOuoWA5u6
         klQB+ECYE54zTCpHLMNmnfv7vTigPUKItG3YEZNenCaHNCu/4x3HYaTkFyVpCmkfroJD
         JIoCb+UGy6A5aUy+bsiwt58xiyK+daw7J+eJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtj5BWUVGyinNX7wvC73dcZuNmbbOVj5imGPpnqwC7s=;
        b=OYdZecQng2fiDz87gWcZjR2XOLHMx8H8wNKnbscieriaSfP0LWXjkFQYWtKEVqp3KZ
         N9gWFQT2I4vrEzeH6HKTuZl4UK5JLm5KRID4gs/76ElAZKh2gFUifS69+uuOfdjmFgTk
         qBIZkqWoxRV7oOAGpCjxXs0/fex7LsGo5FkCTTQR13tz3afkdStVxkn/wBAdbXbNI45c
         tJbjsxgLjpbvs8XvNrurYD19bBbVjUMTKRKhNR3nfFj46rlk3lPZBjMj1/bW6NzYkE8R
         hW1Kcvu3c5pNu+Xa1YKGc4aVPTSZd9bv/wge5O0byzeLC48Ki8Fx+GhTyhUujvTK3qQs
         Uvrw==
X-Gm-Message-State: APjAAAWhkCO0JzYlWCmZbyBo4ZY2lcmBEjBcSFyLmX1tKiFc45oeYN5R
        awYVG7FS5dZGZ+pIgtnDQ0CMYq5Rc9g=
X-Google-Smtp-Source: APXvYqwlblPgJAJLYhrRZf0N0nEa2vwWnf0IBSfqztxfEWsBk25yrq1GwuN4AVK62xzXV+NxQkfWmQ==
X-Received: by 2002:a05:651c:1068:: with SMTP id y8mr2073916ljm.71.1579866030741;
        Fri, 24 Jan 2020 03:40:30 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s22sm2996185ljm.41.2020.01.24.03.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 03:40:30 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 1/4] net: bridge: check port state before br_allowed_egress
Date:   Fri, 24 Jan 2020 13:40:19 +0200
Message-Id: <20200124114022.10883-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
References: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we make sure that br_allowed_egress is called only when we have
BR_STATE_FORWARDING state then we can avoid a test later when we add
per-vlan state.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 86637000f275..7629b63f6f30 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -25,7 +25,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 	vg = nbp_vlan_group_rcu(p);
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
-		br_allowed_egress(vg, skb) && p->state == BR_STATE_FORWARDING &&
+		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
 		nbp_switchdev_allowed_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
-- 
2.21.0

