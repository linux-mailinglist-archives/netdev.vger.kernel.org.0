Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A7F596EE6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbiHQMy5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Aug 2022 08:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbiHQMy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:54:56 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC64491DB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:54:55 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-M58k8-pMNRSctunLMlI4Og-1; Wed, 17 Aug 2022 08:54:48 -0400
X-MC-Unique: M58k8-pMNRSctunLMlI4Og-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDFB185A584;
        Wed, 17 Aug 2022 12:54:47 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.193.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70817492C3B;
        Wed, 17 Aug 2022 12:54:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net] Revert "net: macsec: update SCI upon MAC address change."
Date:   Wed, 17 Aug 2022 14:54:36 +0200
Message-Id: <9b1a9d28327e7eb54550a92eebda45d25e54dd0d.1660667033.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6fc498bc82929ee23aa2f35a828c6178dfd3f823.

Commit 6fc498bc8292 states:

    SCI should be updated, because it contains MAC in its first 6
    octets.

That's not entirely correct. The SCI can be based on the MAC address,
but doesn't have to be. We can also use any 64-bit number as the
SCI. When the SCI based on the MAC address, it uses a 16-bit "port
number" provided by userspace, which commit 6fc498bc8292 overwrites
with 1.

In addition, changing the SCI after macsec has been setup can just
confuse the receiver. If we configure the RXSC on the peer based on
the original SCI, we should keep the same SCI on TX.

When the macsec device is being managed by a userspace key negotiation
daemon such as wpa_supplicant, commit 6fc498bc8292 would also
overwrite the SCI defined by userspace.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ee6087e7b2bf..c6d271e5687e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -462,11 +462,6 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
 	return (struct macsec_eth_header *)skb_mac_header(skb);
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static void __macsec_pn_wrapped(struct macsec_secy *secy,
 				struct macsec_tx_sa *tx_sa)
 {
@@ -3661,7 +3656,6 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 
 out:
 	eth_hw_addr_set(dev, addr->sa_data);
-	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
@@ -4000,6 +3994,11 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
 	return false;
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-- 
2.37.2

