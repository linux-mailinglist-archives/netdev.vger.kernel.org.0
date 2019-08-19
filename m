Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3FA9520B
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfHTAAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45761 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbfHTAAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so10427002wrj.12
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=62PX0PDKqU8d/Li3LrAFJmGpOhx/Rduh8g4LGkje5q8=;
        b=i2+LYizGsnK8M4fZNkfzcuel+STLDmtnbpyyrxKPKdHnPf9roOLgccoBKiZOTjjDQA
         m5yNzkoDkm/3dWbLRDXjYEIIFEKU43YAEtslF2sHuNY/VY+VE53/ttT+8Oob/JJx4KeH
         1kz20F9A0Hpl4ziasmlKHr+v8R0IzVO1Jfu6jwaWLKi9aDm4D67ahtfH4jbKEz19UbFZ
         VAKfS9U2nyJMrGlehcu4D6ICiCOsY5pqzZkjyfU4sSuZvXa5qYJUdwRVotQ9Rflmt3YT
         ZuEwA2P47CLaMNK/YYrt7hCyV0udEjjPEgyirQgeTli5S+kjDvTie6kw2N3FfKVEzuPe
         XxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=62PX0PDKqU8d/Li3LrAFJmGpOhx/Rduh8g4LGkje5q8=;
        b=F4phyOHI0/mmmVaYxDEJYcICdj9eCVSlhlhg7SZntxIRkHEkvth2QcLNzL6v12Doa6
         n26fYCXwszcJo/KPhDokwYIKPwvqsQP4yDpCKVi5K8Au4pxAbKtYrMb4WyI/vYpZYOZ4
         Jxz7FEMQ31f1mNteedzjAui1qcoSWnNaNSJ4qqdUHHKqabFSXA28yI4c6ESyr1UzjF/T
         m0j9vy6Xj3xje4hFQJ7OPJVMPtzhuQ+eC+TzX7qX74QEWyGK9KsoO/mQluKA+IKWz9mu
         SQrMncSxSmJXAaIBqBN/76bHeghPIQoASXGJY4dMUQybsj53OkKofWJG7aWCXT0Dz63x
         7ONg==
X-Gm-Message-State: APjAAAUPSC8TbxF7yKSelBf2JQ03cof3hWWq5lK0ErnfBNWHTzCNpoV9
        NziP8D7V3DZOjSlBqmykGMA=
X-Google-Smtp-Source: APXvYqx6vdS03N8YClY3nQl/fVRxgSRoNIS0pn40KmHzWSyn/HaSUwDLjt9bvdyIgQWQVGcH/MP3ZQ==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr8454983wrj.232.1566259209312;
        Mon, 19 Aug 2019 17:00:09 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/6] net: bridge: Populate the pvid flag in br_vlan_get_info
Date:   Tue, 20 Aug 2019 02:59:58 +0300
Message-Id: <20190820000002.9776-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
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

