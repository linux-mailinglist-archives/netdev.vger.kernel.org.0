Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AE222D7D2
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgGYNGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 09:06:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726728AbgGYNGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 09:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595682413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4pJbqZWSejQWvYCC7h5jrZjGML7KH6eK2719Qrg8M7o=;
        b=ZPBhOYf0XH31TNxM8yTIkmJHx/lDZGZHF/juMS5pcUWNhB7nVsOGJDmA7t8M9fpHONxATE
        Tr38qbJp/+D8jeHtFTVtuK5ZN+QG2y6hS3GWE7kGwKu8QKLF9WKZTZ2jxBADoFMTrtHzTE
        mCYmHLvYhLACP8dh5HITB2jINjO75To=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-lb2AASFfMUGt4dWGFRPhzA-1; Sat, 25 Jul 2020 09:06:51 -0400
X-MC-Unique: lb2AASFfMUGt4dWGFRPhzA-1
Received: by mail-wr1-f70.google.com with SMTP id c6so2618946wru.7
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4pJbqZWSejQWvYCC7h5jrZjGML7KH6eK2719Qrg8M7o=;
        b=gA8qSJtqt/iPVRyv6FhW9hjx0qlK5sD5BCiCy4ZjoiBrh3BtPKbUdgLJFWxP/RvYc8
         8+tkneF5h6BUCE6Iw5KBU0HCW38QZQ1Qlaz4Zfbm6by+svUmAkc2o+bRqftReuDyJ1DM
         vfPkPWwF8rheAHeUDYkMHTKDlWV+A6iaiP4N0wJCaCsbgRvjxiZ8s0IjxjyuVP6vb/4B
         Fz+BWncpbhFlqwVEsw0B54ALb6pacJDhdKLr66hH8BcVwp7UOP5A/PbVItjm0fWWDTOz
         f0z5Mnj6ihD8fc03Qcb/hI5Rx+q8wfBjRJtZRpFv+Ys1t2h8WIesK8bIM/tKsfiKl6wN
         /Tgw==
X-Gm-Message-State: AOAM531kybb9fCJ5OrA6UR6x0rjKN57DPrKa3kac4eiZMYHCMdPUn79R
        DDPcdA9crJaQDIu3VjgYeFAoUCMGx3D0UmJD+U9t9isKT0Gel1a6GDwHx5v1Qwwsr9EQT79nXhV
        VE2xA2IIqSAQ6S9ee
X-Received: by 2002:adf:ef8a:: with SMTP id d10mr12385111wro.126.1595682410104;
        Sat, 25 Jul 2020 06:06:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDKLn/+vLuj6FuM/+DHTWhXQsQeytepoPGVZylNxUSMFpG5IyxOBw+AHr4GTYxgkX1Ef38NQ==
X-Received: by 2002:adf:ef8a:: with SMTP id d10mr12385079wro.126.1595682409636;
        Sat, 25 Jul 2020 06:06:49 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id c136sm10926645wmd.10.2020.07.25.06.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 06:06:48 -0700 (PDT)
Date:   Sat, 25 Jul 2020 15:06:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v2 net] bareudp: forbid mixing IP and MPLS in multiproto mode
Message-ID: <04eafa5bd1f05f7e569a047ecd2d65bc78cd75a1.1595682311.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
IPv6 packets regardless of the bareudp ethertype. In practice, this
let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
IPv6 packets.

We need to restrict the test further, so that the multiproto mode only
enables
  * IPv6 for IPv4 tunnels,
  * or multicast MPLS for unicast MPLS tunnels.

To improve clarity, the protocol validation is moved to its own
function, where each logical test has its own condition.

v2: s/ntohs/htons/

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3dd46cd55114..88e7900853db 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -407,19 +407,34 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
+static bool bareudp_proto_valid(struct bareudp_dev *bareudp, __be16 proto)
+{
+	if (bareudp->ethertype == proto)
+		return true;
+
+	if (!bareudp->multi_proto_mode)
+		return false;
+
+	if (bareudp->ethertype == htons(ETH_P_MPLS_UC) &&
+	    proto == htons(ETH_P_MPLS_MC))
+		return true;
+
+	if (bareudp->ethertype == htons(ETH_P_IP) &&
+	    proto == htons(ETH_P_IPV6))
+		return true;
+
+	return false;
+}
+
 static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bareudp_dev *bareudp = netdev_priv(dev);
 	struct ip_tunnel_info *info = NULL;
 	int err;
 
-	if (skb->protocol != bareudp->ethertype) {
-		if (!bareudp->multi_proto_mode ||
-		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
-		     skb->protocol !=  htons(ETH_P_IPV6))) {
-			err = -EINVAL;
-			goto tx_error;
-		}
+	if (!bareudp_proto_valid(bareudp, skb->protocol)) {
+		err = -EINVAL;
+		goto tx_error;
 	}
 
 	info = skb_tunnel_info(skb);
-- 
2.21.3

