Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC348298759
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 08:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769283AbgJZHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 03:22:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38320 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769164AbgJZHWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 03:22:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id 10so5716028pfp.5;
        Mon, 26 Oct 2020 00:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CoiP1SRYFw3dRE7KHCo2Xt8qwofyEh+WF/YMDll/K+c=;
        b=GvOSPVA9pBC4VK6/qA8CKb/cm13ibcrCcuILBHK5nEodqKbfoGN6HeR/4wvn8BxuBq
         Fw3bAaYr5zwtnpzHyCeqb1kXwLsyDzV/S78MOk7qKWqRoAN7RjEW3vOwB8q4KNea4cvT
         AK3IaazTIAaY6uBLHlYlHiVehr0vZqdU2NBCXFlP/aoHHwH7VJUffc9Nw9d1t9Oh4Syq
         Czi5rlJrUAdDOZaSN0zf8RAWTDf6k1KblAvbHiZzIdiM1w59o+Asdo96oDmgvEB1y2P7
         ZSATANJ/PHTIkD4utD8Hnsj76/RZSktvOyP3LrxkcyLOCj8PfAXyx5vGhnm/cRYwLKHN
         T6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CoiP1SRYFw3dRE7KHCo2Xt8qwofyEh+WF/YMDll/K+c=;
        b=LM6F4zJ50ginhLy9Crjl6bTVnRMdgF0VW99p9cAKeeVjsXJBFBiBZn/kFsKP8lvBz9
         oLxCi8OOjcr8HOYAV9N51X427sd88LwhBjU2xV1QhwDHpyAw4tXDoPJCB8exz9fDpwmX
         3rSgxpogqlXGkIRV7nOiEvp7e0grFN0N16W1zkfeyIS8oUMqFqHTPl3cWApHNVFpDWcA
         l9BkUs5HSs/oUUyrKzcBT2lTLHCtj1tL0s6szD79EDEpdvF0HDFGCzBNTgGYpPjbONVF
         jT1EOwaYOOYnuoEDr9YB6rC3yESQS7nhMB9yfDkKCAJ8+Qb4DZiYesv7Fpe7kC/YGzGq
         gzBQ==
X-Gm-Message-State: AOAM533yEvmNcj9PRzCLue51ECDSAo+sZ3LrqdSVLOKb7FtlYdiZpHX2
        nV4ixZQr2/CLqS+WV8EkKEk=
X-Google-Smtp-Source: ABdhPJy6s966DPXokAQoPL1Ku+1MQ7hK6MwHo1Ka3bj0BWa9wdplT3Qkh8NtX6gCuj2fiKIt+8GM2Q==
X-Received: by 2002:a63:cd51:: with SMTP id a17mr15269064pgj.167.1603696973345;
        Mon, 26 Oct 2020 00:22:53 -0700 (PDT)
Received: from lte-devbox.localdomain (KD106154087157.au-net.ne.jp. [106.154.87.157])
        by smtp.googlemail.com with ESMTPSA id h2sm11502178pjv.15.2020.10.26.00.22.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Oct 2020 00:22:52 -0700 (PDT)
From:   Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>
Cc:     fujiwara.masahiro@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Schultz <aschultz@tpip.net>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] gtp: fix an use-before-init in gtp_newlink()
Date:   Mon, 26 Oct 2020 16:22:27 +0900
Message-Id: <20201026072227.7280-1-fujiwara.masahiro@gmail.com>
X-Mailer: git-send-email 2.24.3
In-Reply-To: <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*_pdp_find() from gtp_encap_recv() would trigger a crash when a peer
sends GTP packets while creating new GTP device.

RIP: 0010:gtp1_pdp_find.isra.0+0x68/0x90 [gtp]
<SNIP>
Call Trace:
 <IRQ>
 gtp_encap_recv+0xc2/0x2e0 [gtp]
 ? gtp1_pdp_find.isra.0+0x90/0x90 [gtp]
 udp_queue_rcv_one_skb+0x1fe/0x530
 udp_queue_rcv_skb+0x40/0x1b0
 udp_unicast_rcv_skb.isra.0+0x78/0x90
 __udp4_lib_rcv+0x5af/0xc70
 udp_rcv+0x1a/0x20
 ip_protocol_deliver_rcu+0xc5/0x1b0
 ip_local_deliver_finish+0x48/0x50
 ip_local_deliver+0xe5/0xf0
 ? ip_protocol_deliver_rcu+0x1b0/0x1b0

gtp_encap_enable() should be called after gtp_hastable_new() otherwise
*_pdp_find() will access the uninitialized hash table.

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
---
v2:
 - leave out_hashtable: label for clarity (Jakub).
 - fix code and comment styles.

 drivers/net/gtp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 8e47d0112e5d..07cb6d9495e8 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -663,10 +663,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 
 	gtp = netdev_priv(dev);
 
-	err = gtp_encap_enable(gtp, data);
-	if (err < 0)
-		return err;
-
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
 	} else {
@@ -676,13 +672,17 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	err = gtp_hashtable_new(gtp, hashsize);
+	if (err < 0)
+		return err;
+
+	err = gtp_encap_enable(gtp, data);
 	if (err < 0)
 		goto out_encap;
 
 	err = register_netdevice(dev);
 	if (err < 0) {
 		netdev_dbg(dev, "failed to register new netdev %d\n", err);
-		goto out_hashtable;
+		goto out_encap;
 	}
 
 	gn = net_generic(dev_net(dev), gtp_net_id);
@@ -693,11 +693,11 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 
 	return 0;
 
+out_encap:
+	gtp_encap_disable(gtp);
 out_hashtable:
 	kfree(gtp->addr_hash);
 	kfree(gtp->tid_hash);
-out_encap:
-	gtp_encap_disable(gtp);
 	return err;
 }
 
-- 
2.24.3

