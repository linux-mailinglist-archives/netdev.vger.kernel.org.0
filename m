Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335124F6743
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbiDFRbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbiDFRbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:23 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDCE2963CB;
        Wed,  6 Apr 2022 08:34:49 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B442320000F;
        Wed,  6 Apr 2022 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzRFgzM4CKz3QS8PYg7wgueEZihoX1rywNOkCigJb0c=;
        b=j3kVvNgBsnOepOcYERnnLS7Hkon6kUP0ezruksFVRaO8O/VUoB/oVfW2XpG6fz27NWOIP1
        awK1g1o45XaA6U+NNvkYzu1qJEIxm9D6y2UXqYzz6kWIQe6/67YPbLQnuuMVB6y+r+U8BF
        7rZEM+tpaJ45JDUn1ExT31hghG29+BfOOzULuGsoVDyZGg5o0l3kMG+kmsCrNEJfOIkkAK
        9egGF4m4oOb5KOS0doTuUQYGeI8FgxzdaiFeZ1mt9HRibtH6RqUG1OrfaaFyyqrxHq2nYv
        so8asnQVD/Iiz9Cfhl9Q+1QUawI6277zxt4S9SqxIvgitw2N8MzvuXE4oxBCsA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v5 02/11] net: ieee802154: Fill the list of MLME return codes
Date:   Wed,  6 Apr 2022 17:34:32 +0200
Message-Id: <20220406153441.1667375-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are more codes than already listed, let's be a bit more
exhaustive. This will allow to drop device drivers local definitions of
these codes.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h | 67 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 01d945c8b2e1..f1f9412b6ac6 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -134,7 +134,35 @@ enum {
 	 * a successful transmission.
 	 */
 	IEEE802154_SUCCESS = 0x0,
-
+	/* The requested operation failed. */
+	IEEE802154_MAC_ERROR = 0x1,
+	/* The requested operation has been cancelled. */
+	IEEE802154_CANCELLED = 0x2,
+	/*
+	 * Device is ready to poll the coordinator for data in a non beacon
+	 * enabled PAN.
+	 */
+	IEEE802154_READY_FOR_POLL = 0x3,
+	/* Wrong frame counter. */
+	IEEE802154_COUNTER_ERROR = 0xdb,
+	/*
+	 * The frame does not conforms to the incoming key usage policy checking
+	 * procedure.
+	 */
+	IEEE802154_IMPROPER_KEY_TYPE = 0xdc,
+	/*
+	 * The frame does not conforms to the incoming security level usage
+	 * policy checking procedure.
+	 */
+	IEEE802154_IMPROPER_SECURITY_LEVEL = 0xdd,
+	/* Secured frame received with an empty Frame Version field. */
+	IEEE802154_UNSUPPORTED_LEGACY = 0xde,
+	/*
+	 * A secured frame is received or must be sent but security is not
+	 * enabled in the device. Or, the Auxiliary Security Header has security
+	 * level of zero in it.
+	 */
+	IEEE802154_UNSUPPORTED_SECURITY = 0xdf,
 	/* The beacon was lost following a synchronization request. */
 	IEEE802154_BEACON_LOST = 0xe0,
 	/*
@@ -204,11 +232,48 @@ enum {
 	 * that is not supported.
 	 */
 	IEEE802154_UNSUPPORTED_ATTRIBUTE = 0xf4,
+	/* Missing source or destination address or address mode. */
+	IEEE802154_INVALID_ADDRESS = 0xf5,
+	/*
+	 * MLME asked to turn the receiver on, but the on time duration is too
+	 * big compared to the macBeaconOrder.
+	 */
+	IEEE802154_ON_TIME_TOO_LONG = 0xf6,
+	/*
+	 * MLME asaked to turn the receiver on, but the request was delayed for
+	 * too long before getting processed.
+	 */
+	IEEE802154_PAST_TIME = 0xf7,
+	/*
+	 * The StartTime parameter is nonzero, and the MLME is not currently
+	 * tracking the beacon of the coordinator through which it is
+	 * associated.
+	 */
+	IEEE802154_TRACKING_OFF = 0xf8,
+	/*
+	 * The index inside the hierarchical values in PIBAttribute is out of
+	 * range.
+	 */
+	IEEE802154_INVALID_INDEX = 0xf9,
+	/*
+	 * The number of PAN descriptors discovered during a scan has been
+	 * reached.
+	 */
+	IEEE802154_LIMIT_REACHED = 0xfa,
+	/*
+	 * The PIBAttribute parameter specifies an attribute that is a read-only
+	 * attribute.
+	 */
+	IEEE802154_READ_ONLY = 0xfb,
 	/*
 	 * A request to perform a scan operation failed because the MLME was
 	 * in the process of performing a previously initiated scan operation.
 	 */
 	IEEE802154_SCAN_IN_PROGRESS = 0xfc,
+	/* The outgoing superframe overlaps the incoming superframe. */
+	IEEE802154_SUPERFRAME_OVERLAP = 0xfd,
+	/* Any other error situation. */
+	IEEE802154_SYSTEM_ERROR = 0xff,
 };
 
 /* frame control handling */
-- 
2.27.0

