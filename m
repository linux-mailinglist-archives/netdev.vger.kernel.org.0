Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75995843E4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiG1QNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiG1QN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76D6E6FA18
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659024794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MRkkBYKQp9oZk2da5EZBbCrPfbUp3tpj2MKHxygzUhg=;
        b=Cz7pWuNPsk9m/Ae7JoWKJpwHjYN578rLj8pv8hbmpG5PY3dvTeJfnpx+m7INk0ey0mt0lj
        QYAXFFVxuSGuMT7k5TwqLkmseR3G1Dc1vDkKlF/YRIsY6QViHNJjkebHllJfDzrIYd2FHw
        W3aWdE7svQUaCp/xoUyhN92SHti2yws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-NvNJMH7cM-aUgzJnPGvSSA-1; Thu, 28 Jul 2022 12:13:08 -0400
X-MC-Unique: NvNJMH7cM-aUgzJnPGvSSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66DF58037AA;
        Thu, 28 Jul 2022 16:13:07 +0000 (UTC)
Received: from mpattric.remote.csb (unknown [10.22.33.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4836A2166B26;
        Thu, 28 Jul 2022 16:13:06 +0000 (UTC)
From:   Mike Pattrick <mkp@redhat.com>
To:     netdev@vger.kernel.org
Cc:     pvalerio@redhat.com, Mike Pattrick <mkp@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] openvswitch: Fix double reporting of drops in dropwatch
Date:   Thu, 28 Jul 2022 12:12:58 -0400
Message-Id: <20220728161259.1088662-1-mkp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frames sent to userspace can be reported as dropped in
ovs_dp_process_packet, however, if they are dropped in the netlink code
then netlink_attachskb will report the same frame as dropped.

This patch checks for error codes which indicate that the frame has
already been freed.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2109946
Signed-off-by: Mike Pattrick <mkp@redhat.com>
---
 net/openvswitch/datapath.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7e8a39a35627..029f9c3e1c28 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -252,10 +252,20 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 
 		upcall.mru = OVS_CB(skb)->mru;
 		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
-		if (unlikely(error))
-			kfree_skb(skb);
-		else
+		switch (error) {
+		case 0:
+			fallthrough;
+		case -EAGAIN:
+			fallthrough;
+		case -ERESTARTSYS:
+			fallthrough;
+		case -EINTR:
 			consume_skb(skb);
+			break;
+		default:
+			kfree_skb(skb);
+			break;
+		}
 		stats_counter = &stats->n_missed;
 		goto out;
 	}
-- 
2.31.1

