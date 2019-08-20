Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5386795444
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfHTCUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:20:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36017 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbfHTCUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 22:20:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so2275826pgm.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 19:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGFHVFfqdjGvqvsJZm72nVYPzJ29ucM+upS8YZoYSG4=;
        b=XjY6h5tVYdD8Tp804uqied5jOGt/T+WfLThJoThVcvc74DNlRc59p5qDYiqPTdxV4g
         RXptxprBxEWUK8hJ0zrdAU/MJ3qQ72kpydj6YQzBSv6VYef6nVHKu0JCBGdTCfnhQihE
         XO9xzG4DZ1esWlOkkfpjs6lBHKJ06oBMKoQXeNwcijp6OeLHuaC4RF2OPpLRBnAMIWjM
         Sr7IkNwMUxoMvqDeOKujwRu+LzqnyGoyJVDnm+DFR2MR1ryzIrxAAiBA6tZkQVAkb7Jq
         HZIqROLrRlwm6R968Uk1cd0+nVPGEQg2lbmrGwBuUa4M1AETSUYOn56ELJsr0542wX+M
         2Z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGFHVFfqdjGvqvsJZm72nVYPzJ29ucM+upS8YZoYSG4=;
        b=V8HabFwgHAKRM1NCdjB/hmGNHbSVKLETSrQ8dtbZNbZeoft+g9RjcPBCeDQWqI59pT
         8+ZIowfr/cfnqneWjWSjLb39j3pLllwAFoexP7bkT1vsK6Wu7887QiRZaKwdt0D6ppuu
         2ctmrQLUaxhTHh1poMmSHeVUXP5gxk6O9meMGiyw2fgxAeUi49cu5NPafJ8GNGFeoOGS
         9P9KykSfRuiJENDxni3xRsJVgPlUv5PJZhN97+djou4MG9cZkjkpWmJ/ITl1lCmx7Ecd
         IzMuq3UDMux+JMq7mWz2anUDo5EaVylg8tyjreitkyrsVZ9Q7EwKuw6zrMU0nee2L4E+
         2/FQ==
X-Gm-Message-State: APjAAAVX9U2TQLaRbdSMX+5JY0jaMReU1UXyAYR+CEfDoOJjLylRryZU
        Kuketoqr1XR5m+fydQZTwqjo2LVG3Rg=
X-Google-Smtp-Source: APXvYqxjvpadQBJCHjMEeYuhow6sh4oNuWk2CfK8PH1XSTbMKANd9R8XAxT2YW0lYKuQLNNElzuW8g==
X-Received: by 2002:a17:90a:a46:: with SMTP id o64mr23718158pjo.90.1566267613847;
        Mon, 19 Aug 2019 19:20:13 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k8sm15589003pgm.14.2019.08.19.19.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 19:20:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Madhu Challa <challa@noironetworks.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set
Date:   Tue, 20 Aug 2019 10:19:47 +0800
Message-Id: <20190820021947.22718-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190813135232.27146-1-liuhangbin@gmail.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 93a714d6b53d ("multicast: Extend ip address command to enable
multicast group join/leave on") we added a new flag IFA_F_MCAUTOJOIN
to make user able to add multicast address on ethernet interface.

This works for IPv4, but not for IPv6. See the inet6_addr_add code.

static int inet6_addr_add()
{
	...
	if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
		ipv6_mc_config(net->ipv6.mc_autojoin_sk, true...)
	}

	ifp = ipv6_add_addr(idev, cfg, true, extack); <- always fail with maddr
	if (!IS_ERR(ifp)) {
		...
	} else if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
		ipv6_mc_config(net->ipv6.mc_autojoin_sk, false...)
	}
}

But in ipv6_add_addr() it will check the address type and reject multicast
address directly. So this feature is never worked for IPv6.

We should not remove the multicast address check totally in ipv6_add_addr(),
but could accept multicast address only when IFA_F_MCAUTOJOIN flag supplied.

v2: update commit description

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dc73888c7859..ced995f3fec4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1045,7 +1045,8 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	int err = 0;
 
 	if (addr_type == IPV6_ADDR_ANY ||
-	    addr_type & IPV6_ADDR_MULTICAST ||
+	    (addr_type & IPV6_ADDR_MULTICAST &&
+	     !(cfg->ifa_flags & IFA_F_MCAUTOJOIN)) ||
 	    (!(idev->dev->flags & IFF_LOOPBACK) &&
 	     !netif_is_l3_master(idev->dev) &&
 	     addr_type & IPV6_ADDR_LOOPBACK))
-- 
2.19.2

