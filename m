Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6B9C59C
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfHYSqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:46:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45908 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbfHYSqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:46:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id q12so13168199wrj.12
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8ZupuQtEA8meIVUvXSGagnB6tSvh2iq4mvlO43q5GcU=;
        b=V7Neqa/5pPFrAtoOrHEU82Am0gZdrMjz8V207wyp0dONDkLXzxVHsMEp86eD5T0EOJ
         5r7keDoimE6qVEawix0c8kuXjt4tKGGanbue3icnTfEl5Dcs/SHudabqJSrpRHqpf53v
         o0wTNz5ctC1i1yU1ssADFFRz9OyQbVWbhWhiPZdIjvwznEq1J64sNKBQ60j8nT/3fGMU
         3GU+yJKZy2lpTB7BslmWmhm+DYZ/wz5UfwdRA3B+EQnAus76/4SYdK+HpYVLJx3ggphr
         JgY75bwsQdqaq0/AYSp6m97BiG6Va4edoiPYTGweZK0QH6MHfMj/s+yxWM/3IliOKHxN
         zg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8ZupuQtEA8meIVUvXSGagnB6tSvh2iq4mvlO43q5GcU=;
        b=Gb60tqLQmd7zDAVJvrbSWxyRb8epKF9NY8oZNSE79R1MrKvDGrqVqgCAnHZxf5g+aZ
         zXVxG7NMWtwEcZk/2LU2a+eHn8SJ5FDmaqvNiOCUInPSwqyT902Syq6e6zNYHFMsy2FZ
         6NCvdUAsTkUPFlxHf7Ha9D9pP+2LvwfSc1rjo4BkHcQYwYdM2OCrnQ8b68O/irjpoq8C
         noPA/JfweCPtv3xmJiTIEenPkEO9kY8CoAUfeoiwotqpirrXeBxgHiNgDBij+auTmqxG
         AH0b3rB12jR6ikQv1MOedqe77kJmJ5nzJCFIhelwbjr6JRc5nmxNd23Uk8DerOMVkPOP
         vXeA==
X-Gm-Message-State: APjAAAW40abZAMiqcPhPH+RoC4kDt7yeGwN6hkhzGWGryNGK7s9R5Sy5
        1wpk9mkpYWpGUP93Tyf+PkU=
X-Google-Smtp-Source: APXvYqxUyXPnJzd5NO3J0qozvH7P2h6Fj5MPrx+vJiOWb7TnFx4BfFT6rSKXkMuR6I3yPOmjTS+jlw==
X-Received: by 2002:adf:e74c:: with SMTP id c12mr17598575wrn.173.1566758762920;
        Sun, 25 Aug 2019 11:46:02 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b136sm25603112wme.18.2019.08.25.11.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 11:46:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/2] net: bridge: Populate the pvid flag in br_vlan_get_info
Date:   Sun, 25 Aug 2019 21:44:53 +0300
Message-Id: <20190825184454.14678-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190825184454.14678-1-olteanv@gmail.com>
References: <20190825184454.14678-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this simplified code snippet fails:

	br_vlan_get_pvid(netdev, &pvid);
	br_vlan_get_info(netdev, pvid, &vinfo);
	ASSERT(!(vinfo.flags & BRIDGE_VLAN_INFO_PVID));

It is intuitive that the pvid of a netdevice should have the
BRIDGE_VLAN_INFO_PVID flag set.

However I can't seem to pinpoint a commit where this behavior was
introduced. It seems like it's been like that since forever.

At a first glance it would make more sense to just handle the
BRIDGE_VLAN_INFO_PVID flag in __vlan_add_flags. However, as Nikolay
explains:

  There are a few reasons why we don't do it, most importantly because
  we need to have only one visible pvid at any single time, even if it's
  stale - it must be just one. Right now that rule will not be violated
  by this change, but people will try using this flag and could see two
  pvids simultaneously. You can see that the pvid code is even using
  memory barriers to propagate the new value faster and everywhere the
  pvid is read only once.  That is the reason the flag is set
  dynamically when dumping entries, too.  A second (weaker) argument
  against would be given the above we don't want another way to do the
  same thing, specifically if it can provide us with two pvids (e.g. if
  walking the vlan list) or if it can provide us with a pvid different
  from the one set in the vg. [Obviously, I'm talking about RCU
  pvid/vlan use cases similar to the dumps.  The locked cases are fine.
  I would like to avoid explaining why this shouldn't be relied upon
  without locking]

So instead of introducing the above change and making sure of the pvid
uniqueness under RCU, simply dynamically populate the pvid flag in
br_vlan_get_info().

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_vlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f5b2aeebbfe9..bb98984cd27d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1281,6 +1281,8 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 
 	p_vinfo->vid = vid;
 	p_vinfo->flags = v->flags;
+	if (vid == br_get_pvid(vg))
+		p_vinfo->flags |= BRIDGE_VLAN_INFO_PVID;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_info);
-- 
2.17.1

