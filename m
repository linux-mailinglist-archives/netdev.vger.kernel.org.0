Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13523A2BE8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfH3Axi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:53:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40067 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfH3Axg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:53:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id t9so5582912wmi.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NYiX/W0g494klq+lCJFi/ZEDs8IdKGu5TG6ydoxouW4=;
        b=QjYDs1pB41B/0RdexfwSwOte34xpyYques5VZWPQaCI5yWDljGT4X1qYTTr8+iB0pe
         /DgJcL/Y78ZkYKy4CAHPtQYjyweilzmk7N8WN3DIj0lJAdx/OrUSWxP7A+SlY6VV/REo
         1OfS3jTRhxlE+IdIXiANXRrCLgzu/nHmnskIT76rZj+2whBvQnD189/N7yk1byQWNLTp
         XOAq9sCiBlLiCFxCpd6YohUVKnn+dx6/VunhbhPy+5KdYEeGtFtOUcJgkMS97F7IKvBH
         qwT49fYd2UkbTxsF+g5xdbdoMQMm4/XggdSGmy9LPC4TkbEC9WJBQurbFao65nNB1kR4
         WtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NYiX/W0g494klq+lCJFi/ZEDs8IdKGu5TG6ydoxouW4=;
        b=d7UEYusuwaYKJTUDIhjwMuJMvplV6qgt+AlMM13smXdiHqmEn1PqYEmglrT4yW4a+9
         YvpysptocNSpHkSQc8ZjqmiVvXl1Dn/eRhPS9Oxob+G0ahw7wtxpz9+MyoifKiuaGd67
         MeTal2xxOoC2YzbJwU/0GCCBNu05vTSkGfP+3pzzsExYWVryj7vuwuLd5K6OcrsXVZ5s
         K2c43La6POmKR8x4UK7qpTS1BFBiI4GQa3eijvAnvi2LYu30FYn/fQeBlxYLANRq4Kgf
         QBkWEgaJo13KrSwHt5o2qA8YGkhGNf1JIjg6Fib8MhvzDeGdvfbXjmzKZQ2p+NUgkccU
         Y/rA==
X-Gm-Message-State: APjAAAWIPq/NycXRMHh8OgtDxEBehQKPcLGtukdK66TohQC4XPW9cKPW
        KShOY9G0VQr6Qq8SYdnV+Ptp7l1QD38=
X-Google-Smtp-Source: APXvYqwQ+LPwjAMzGEPwj5itaSOd965TzGpSlHlCa9yHnMay48TxLzwQcJZAZB2uVypRLanxN/T2Mg==
X-Received: by 2002:a1c:ca11:: with SMTP id a17mr14966814wmg.45.1567126414099;
        Thu, 29 Aug 2019 17:53:34 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id w7sm4691669wrn.11.2019.08.29.17.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:53:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 1/2] net: bridge: Populate the pvid flag in br_vlan_get_info
Date:   Fri, 30 Aug 2019 03:53:24 +0300
Message-Id: <20190830005325.26526-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005325.26526-1-olteanv@gmail.com>
References: <20190830005325.26526-1-olteanv@gmail.com>
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
Changes since v2:
None.

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

