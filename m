Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247C765D41F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbjADNa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbjADN2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:28:52 -0500
X-Greylist: delayed 1406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 05:23:33 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFDA178B6
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:23:33 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1pD3NE-00AkRA-9f; Wed, 04 Jan 2023 14:00:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.96)
        (envelope-from <laforge@osmocom.org>)
        id 1pD3Ks-00F39I-2M;
        Wed, 04 Jan 2023 13:57:38 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     netdev@vger.kernel.org
Cc:     khc@pm.waw.pl, Harald Welte <laforge@osmocom.org>
Subject: [PATCH] net: hdlc: Increase maximum HDLC MTU
Date:   Wed,  4 Jan 2023 13:57:24 +0100
Message-Id: <20230104125724.3587015-1-laforge@osmocom.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FRF 1.2 specification clearly states:

> A maximum frame relay information field size of 1600 octets shall be
> supported by the network and the user.

The linux kernel hdlc/fr code has so far had a maximum MTU of 1500
octets.  This may have been sufficient to transport "regular" Ethernet
frames of MTU 1500 via frame relay net-devices, but there are other
use cases than Ethernet.

One such use case is the 3GPP Gb interface (TS 48.014, 48.016, 48.018)
operated over Frame Relay.  There is open source software [2]
implementing those interfaces by means of AF_PACKET sockets over
Linux kernel hdlcX devices.

And before anyone asks: Even in 2023 there are real-world deployments of
those interfaces over Frame Relay in production use.

This patch doesn't change the default hdlcX netdev MTU, but permits
userspace to configure a higher MTU, in those cases needed.

[1] https://www.broadband-forum.org/technical/download/FRF.1.2.pdf
[2] https://osmocom.org/projects/osmo-gbproxy/wiki
[3] https://gitea.osmocom.org/osmocom/libosmocore/src/branch/master/src/gb/gprs_ns2_fr.c

Signed-off-by: Harald Welte <laforge@osmocom.org>
---
 include/uapi/linux/hdlc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/hdlc.h b/include/uapi/linux/hdlc.h
index d89cb3ee7c70..f6b01e883cb5 100644
--- a/include/uapi/linux/hdlc.h
+++ b/include/uapi/linux/hdlc.h
@@ -13,7 +13,9 @@
 #define _UAPI__HDLC_H
 
 
-#define HDLC_MAX_MTU 1500	/* Ethernet 1500 bytes */
+/* FRF 1.2 states the information field should be 1600 bytes. So in case of
+ * a 4-byte header of Q.922, this results in a MTU of 1604 bytes */
+#define HDLC_MAX_MTU 1604	/* as required for FR network (e.g. carrying GPRS-NS) */
 #if 0
 #define HDLC_MAX_MRU (HDLC_MAX_MTU + 10 + 14 + 4) /* for ETH+VLAN over FR */
 #else
-- 
2.39.0

