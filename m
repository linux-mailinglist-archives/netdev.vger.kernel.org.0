Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9D53A3A9C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhFKEA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:00:56 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:46641 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhFKEAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:00:55 -0400
Received: by mail-pj1-f51.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso5182484pjb.5;
        Thu, 10 Jun 2021 20:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NG4V62lrEz+hLBbPR3pPu4xwt3ug8C8t1Ulc4FgY4KA=;
        b=B0w0irCQ/PkEygfpPP5Q28vv4wXjgU19EciIFNMHJ4pI3mnbkT+8UWZalol5Ti5tKG
         F5GeB+OJRPtUqTPBi0ORIs2/JLPLL7cB0DTSuybflNjnq9jcPdIHiVYiLP0TMq57w02d
         I07ipcNWysmVagUxOkP+PXgJi10Nvj8/s6g+BUhmzx9V63VwM6ik4EDkun0MTRRvSs7a
         DwPO5IkALu27cyC0lOgEppwBnFSGmdQysQuqLBIP4TMGCgTwlDq2BHyGJGwqy5XbHB92
         syDVgSZA7mHtEb00rw63VKxzo1896EaQLRaco028BCKXmOkdFaerTY7t0qUH2NcnFJd9
         wlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NG4V62lrEz+hLBbPR3pPu4xwt3ug8C8t1Ulc4FgY4KA=;
        b=PR2NsAL+ujXksE2IBw6c0eNjNefhn0lnjt6wEHBwPciZoJ3pAXGytPjeW2mxYXXiJc
         QQKj6QPK7DfdWcX42rCY+gRWWlXifdbza9HqfFU5dJnMJVS5y9ygwjmk41AUiIoqKn2O
         rlEDBdfDNT7FtkKdP1QiDqZeOXH4i9YChekE0VN7p3LErbdfphi0ZkBCElqhLnwj1NUL
         KudDZnNUn9yIIt0k0ILrjX5UUyGdAFdEkb7JX6A7Er+FCV49fWHoJASaSOOAT6szNiDG
         2WQ8kl3pBQMi7YbOw0Nf9vMxWdkNltpJ78+OzmGkASGd27fhg1+zRw80h7LKJMyP8fwH
         W49Q==
X-Gm-Message-State: AOAM531eHGY5/bKEHxo2CoaJUk29l42aMZsyoAHt0jCsDeRhNfRdC8+Q
        HvMjSw9stcS0KAFvtUdn9k/NTJDl9vM=
X-Google-Smtp-Source: ABdhPJynsRwe3Y8AXI3o8csy/Hhhe7T3OWod8PRlkojWKD5F/o9fucIh/WkcmXkWQZtmT9InqKqtTg==
X-Received: by 2002:a17:90b:120d:: with SMTP id gl13mr2364364pjb.72.1623383864472;
        Thu, 10 Jun 2021 20:57:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r6sm8834035pjm.12.2021.06.10.20.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 20:57:43 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: Create default VLAN entry explicitly
Date:   Thu, 10 Jun 2021 20:57:32 -0700
Message-Id: <20210611035733.400713-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
b53 driver to ensure that the default PVID VLAN entry will be configured
with the appropriate untagged attribute towards the CPU port. We were
implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
instead make it explicit.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6e199454e41d..5fd9ed327c1b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -748,9 +748,20 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
 
-	b53_for_each_port(dev, i)
+	/* Create an untagged VLAN entry for the default PVID in case
+	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
+	 * dsa_slave_vlan_rx_add_vid() to create the default VLAN
+	 * entry. Do this only when the tagging protocol is not
+	 * DSA_TAG_PROTO_NONE
+	 */
+	b53_for_each_port(dev, i) {
+		v = &dev->vlans[def_vid];
+		v->members |= BIT(i);
+		if (dev->tag_protocol != DSA_TAG_PROTO_NONE)
+			v->untag = v->members;
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
+	}
 
 	/* Upon initial call we have not set-up any VLANs, but upon
 	 * system resume, we need to restore all VLAN entries.
-- 
2.25.1

