Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46D31A012
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBLNwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:52:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229940AbhBLNwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 08:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613137836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pgcM5pVoAqk+OJ43cIdY0aNOABGGz99ON12jih0wfng=;
        b=e/GWqyfi240hP6IKwqTIUyI7aykt7BqMt5U5gLLYwbr6UFzrqMUodBd3XxtehWlRzYNxMN
        s1/ZvBzq3HKloAFusJN76S++YChvIjmk/tU+ebiJqYji/eXhigqKwnDHEUa7OVdMBx/v3y
        roAnG5HdoNNr5SvqQonw4G+Sbg3Mv54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-4XAYY_fgPQK3KNs0N2TRww-1; Fri, 12 Feb 2021 08:50:33 -0500
X-MC-Unique: 4XAYY_fgPQK3KNs0N2TRww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87C526EE22;
        Fri, 12 Feb 2021 13:50:31 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C01810023AD;
        Fri, 12 Feb 2021 13:50:27 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 57C4330736C73;
        Fri, 12 Feb 2021 14:50:26 +0100 (CET)
Subject: [PATCH net-next V1] net: followup adjust net_device layout for
 cacheline usage
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Fri, 12 Feb 2021 14:50:26 +0100
Message-ID: <161313782625.1008639.6000589679659428869.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Eric pointed out in response to commit 28af22c6c8df ("net: adjust
net_device layout for cacheline usage") the netdev_features_t members
wanted_features and hw_features are only used in control path.

Thus, this patch reorder the netdev_features_t to let more members that
are used in fast path into the 3rd cacheline. Whether these members are
read depend on SKB properties, which are hinted as comments. The member
mpls_features could not fit in the cacheline, but it was the least
commonly used (depend on CONFIG_NET_MPLS_GSO).

In the future we should consider relocating member gso_partial_features
to be closer to member gso_max_segs. (see usage in gso_features_check()).

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bfadf3b82f9c..3898bb167579 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1890,13 +1890,16 @@ struct net_device {
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
 
+	/* Fast path features - via netif_skb_features */
 	netdev_features_t	features;
+	netdev_features_t	vlan_features;       /* if skb_vlan_tagged */
+	netdev_features_t	hw_enc_features;     /* if skb->encapsulation */
+	netdev_features_t	gso_partial_features;/* if skb_is_gso */
+	netdev_features_t	mpls_features; /* if eth_p_mpls+NET_MPLS_GSO */
+
+	/* Control path features */
 	netdev_features_t	hw_features;
 	netdev_features_t	wanted_features;
-	netdev_features_t	vlan_features;
-	netdev_features_t	hw_enc_features;
-	netdev_features_t	mpls_features;
-	netdev_features_t	gso_partial_features;
 
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;


