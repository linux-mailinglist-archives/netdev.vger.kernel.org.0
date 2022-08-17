Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437D859729F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiHQPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbiHQPMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:12:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044969E2EF
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660749154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhQQY8fryRybgeg3ZutuVnauqnq4LD66LqnRCuZNZuw=;
        b=OvHswICSXJH21sxY61GohN2nlAAwaP7w+kw/wesdfUn+hKNTtDIG2MMZCJ0qoc66oQT/N/
        UWibgYUMuKlLJzI73w3d2pxfeNTzsYsrjN+6JEMY4dbufFsCeHqqPgtwQ7ueWpLBOb2Z7L
        LuN/ofj9Y13IevGsTp9olvbVN0xH20M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-VlelGG9TONKZLLJ1VgQ7Lw-1; Wed, 17 Aug 2022 11:12:23 -0400
X-MC-Unique: VlelGG9TONKZLLJ1VgQ7Lw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8441985A585;
        Wed, 17 Aug 2022 15:12:22 +0000 (UTC)
Received: from mpattric.remote.csb (unknown [10.22.17.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0DD514152E1;
        Wed, 17 Aug 2022 15:12:21 +0000 (UTC)
From:   Mike Pattrick <mkp@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mkp@redhat.com, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] openvswitch: Fix overreporting of drops in dropwatch
Date:   Wed, 17 Aug 2022 11:06:35 -0400
Message-Id: <20220817150635.1725530-2-mkp@redhat.com>
In-Reply-To: <20220817150635.1725530-1-mkp@redhat.com>
References: <20220817150635.1725530-1-mkp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently queue_userspace_packet will call kfree_skb for all frames,
whether or not an error occurred. This can result in a single dropped
frame being reported as multiple drops in dropwatch. This functions
caller may also call kfree_skb in case of an error. This patch will
consume the skbs instead and allow caller's to use kfree_skb.

Signed-off-by: Mike Pattrick <mkp@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2109957
---
Changes in v2:
 - Corrected bugzilla link
---
 net/openvswitch/datapath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index ca22aa73c6e0..45f9a7b3410e 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -558,8 +558,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 out:
 	if (err)
 		skb_tx_error(skb);
-	kfree_skb(user_skb);
-	kfree_skb(nskb);
+	consume_skb(user_skb);
+	consume_skb(nskb);
+
 	return err;
 }
 
-- 
2.31.1

