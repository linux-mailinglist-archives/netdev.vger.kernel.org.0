Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A932C164853
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBSPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:18:32 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33552 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgBSPSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:18:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so228744pfn.0;
        Wed, 19 Feb 2020 07:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ukKkOw2CD1p6V3m08F/J1FLQ/Kv80Rkqm5DlFEyeEwo=;
        b=Ah7uoNUV021eb0uXbGTT4n8DSdPnmntOsRtdO0sIaVGmDz6Mx9DRCWkzlQUZdixw+q
         EWquftTkt68WCGlW/aA5nVyhgl+UHA3gsnBdG89IY8cpIjgmPUkSlbSABOsRoUQRQiP2
         tRiY/eEHI2tZExjQkFe8laVxjuRMHuzuVK45dlKZio/IG/07TcGQVIzIxWHJfXrtvd1a
         HtRVxwNVVRPt42qadehr7FMIyLth4UrIOnrhkVj5fNTULu6IlHaSMd/bRTPytPu9Y5vU
         PaRSz9bSbBntBZ+Ij+W79CdwpGDWwZ003hXlhvFCJlR5NffYtNcMGNj1KyqapsoM5/VY
         K/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ukKkOw2CD1p6V3m08F/J1FLQ/Kv80Rkqm5DlFEyeEwo=;
        b=lp61iyh1zc9+XuR16wO9L+CRo/wsjKV5c2VmAfsLsVYB/XPX8D662XCIsKesq+mG2f
         bS3OHlLRTTpQB2wp3peqr5M/bj/ayqZpN73jP/MgMoUWpF2P2CUUwtS7R2e7sxeDuryF
         BDI4vvrTN6hLiy4mKKEC9dMq1kvccvt+SHlYFs7cgO3I8pb+bdVx68flweZjP3WdmVAP
         ASswROxxTmU2MZm2LKjlEjbDR0fsvW7mVcdsFeckNC2KQZd8pxYyf4KgM6ndFhS7P3wH
         FiZE05Lrx/pkRafZ+dO3JBsTop7ktYmCWyoD6meR4a+jqMfA7f6oqbiT45kOK2olApzt
         r0Sw==
X-Gm-Message-State: APjAAAWbCO7Jtf9B049j4yp8cR1wg+NOziKzPE+DcoYPajZ777Fw7TIF
        CEXNH1zX80qLYSQmM8ZKvg==
X-Google-Smtp-Source: APXvYqz7z38VUX56nB4cpmN4ssPqGh9I7Dl7gnU0/yRnff1inv5wjyvzdV1rumvg9fOMEZuF/4bZng==
X-Received: by 2002:a62:78c1:: with SMTP id t184mr26533069pfc.222.1582125511796;
        Wed, 19 Feb 2020 07:18:31 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee1:f898:fdeb:e0c7:deeb:a606])
        by smtp.gmail.com with ESMTPSA id v5sm45906pgc.11.2020.02.19.07.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:18:30 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] bridge: br_stp: Use built-in RCU list checking
Date:   Wed, 19 Feb 2020 20:47:46 +0530
Message-Id: <20200219151746.1050-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/bridge/br_stp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1f1410f8d312..8be12452071b 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -52,7 +52,8 @@ struct net_bridge_port *br_get_port(struct net_bridge *br, u16 port_no)
 {
 	struct net_bridge_port *p;
 
-	list_for_each_entry_rcu(p, &br->port_list, list) {
+	list_for_each_entry_rcu(p, &br->port_list, list,
+				lockdep_is_held(&br->lock)) {
 		if (p->port_no == port_no)
 			return p;
 	}
-- 
2.17.1

