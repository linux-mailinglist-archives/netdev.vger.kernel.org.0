Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F47957DD8A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiGVJ3r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 05:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbiGVJ2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:28:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 756E2B8521
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:18:01 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-DlGk_39TOniSMNSbfCcSug-1; Fri, 22 Jul 2022 05:16:50 -0400
X-MC-Unique: DlGk_39TOniSMNSbfCcSug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05CC7803301;
        Fri, 22 Jul 2022 09:16:50 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AB512166B26;
        Fri, 22 Jul 2022 09:16:48 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 3/4] macsec: limit replay window size with XPN
Date:   Fri, 22 Jul 2022 11:16:29 +0200
Message-Id: <b081da2b1b2600708434ac2379527f42cd81c710.1656519221.git.sd@queasysnail.net>
In-Reply-To: <cover.1656519221.git.sd@queasysnail.net>
References: <cover.1656519221.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1AEbw-2013 (section 10.7.8) specifies that the maximum value
of the replay window is 2^30-1, to help with recovery of the upper
bits of the PN.

To avoid leaving the existing macsec device in an inconsistent state
if this test fails during changelink, reuse the cleanup mechanism
introduced for HW offload. This wasn't needed until now because
macsec_changelink_common could not fail during changelink, as
modifying the cipher suite was not allowed.

Finally, this must happen after handling IFLA_MACSEC_CIPHER_SUITE so
that secy->xpn is set.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 634452d3ecc5..b3834e353c22 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -243,6 +243,7 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
+#define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
 static bool send_sci(const struct macsec_secy *secy)
 {
@@ -3746,9 +3747,6 @@ static int macsec_changelink_common(struct net_device *dev,
 		secy->operational = tx_sa && tx_sa->active;
 	}
 
-	if (data[IFLA_MACSEC_WINDOW])
-		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
-
 	if (data[IFLA_MACSEC_ENCRYPT])
 		tx_sc->encrypt = !!nla_get_u8(data[IFLA_MACSEC_ENCRYPT]);
 
@@ -3794,6 +3792,16 @@ static int macsec_changelink_common(struct net_device *dev,
 		}
 	}
 
+	if (data[IFLA_MACSEC_WINDOW]) {
+		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
+
+		/* IEEE 802.1AEbw-2013 10.7.8 - maximum replay window
+		 * for XPN cipher suites */
+		if (secy->xpn &&
+		    secy->replay_window > MACSEC_XPN_MAX_REPLAY_WINDOW)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -3823,7 +3831,7 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	ret = macsec_changelink_common(dev, data);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
-- 
2.36.1

