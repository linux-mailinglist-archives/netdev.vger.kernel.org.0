Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8879D5843E6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiG1QNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiG1QNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:13:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F00E96E880
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659024797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmJ2+f+Z2K0SCbonE5IauSW1u7akCNc40dQ7K7wfDHA=;
        b=LcQfhq1Mh6pBzDHTuFoEcx6iwpEn0/sCvAWQ/gvRPSlUQGXeFBMevp+sfXzIlzo1syhv6a
        sCSGKzKYkqlSmZHtrqrrMj5opNRGI/EVYLmh0pyadavKknz6CTFkXJoZcMCXgaihYs1G5g
        e/ltIlLWhDlHyMQ+Ain6XAZMnGTQFNI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-4pt9ZUUYOKK0kLNFC70acw-1; Thu, 28 Jul 2022 12:13:11 -0400
X-MC-Unique: 4pt9ZUUYOKK0kLNFC70acw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E75A185A7B2;
        Thu, 28 Jul 2022 16:13:11 +0000 (UTC)
Received: from mpattric.remote.csb (unknown [10.22.33.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 722062166B26;
        Thu, 28 Jul 2022 16:13:10 +0000 (UTC)
From:   Mike Pattrick <mkp@redhat.com>
To:     netdev@vger.kernel.org
Cc:     pvalerio@redhat.com, Mike Pattrick <mkp@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] openvswitch: Fix overreporting of drops in dropwatch
Date:   Thu, 28 Jul 2022 12:12:59 -0400
Message-Id: <20220728161259.1088662-2-mkp@redhat.com>
In-Reply-To: <20220728161259.1088662-1-mkp@redhat.com>
References: <20220728161259.1088662-1-mkp@redhat.com>
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

Currently queue_userspace_packet will call kfree_skb for all frames,
whether or not an error occurred. This can result in a single dropped
frame being reported as multiple drops in dropwatch. This patch will
consume the skbs instead.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2109957
Signed-off-by: Mike Pattrick <mkp@redhat.com>
---
 net/openvswitch/datapath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 029f9c3e1c28..3eee4b0a2005 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -561,8 +561,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
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

