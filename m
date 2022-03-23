Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AF94E5BED
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 00:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345998AbiCWXjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 19:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347119AbiCWXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 19:38:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833566E781;
        Wed, 23 Mar 2022 16:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E8861857;
        Wed, 23 Mar 2022 23:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D36C36AE7;
        Wed, 23 Mar 2022 23:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648078642;
        bh=BqwLc8AIALibk9MzYkDeNDCDRUV+uYK7m2/MGj/Amds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b88/UZhL2CPvEd7A1sC1e1eEP7vpTNkyv9YFBcRltoT7PxCEpg8wBlMj3EYldHFaT
         OucwxE82UiPqlWbaZcbFohClLu6dJ0p8q02ExG4SRHzbHavYwu+0SMLBHC6J1NyeOU
         /zr5FoEIPFnuuV1uv5Jp+XyMtIA76U4lEBFdISGj/qm+Dxq78aOkKNb9TxVIFD5YmJ
         4uAxA/UGGPQp3YvDdPJ5pTnkJMAKNBYDLzquSUCNKxetlpIY81soJOuv7MxMdug7T4
         t54Nk52TMhb+ZOD5wwLMktJRb/6SWZAwXFLGYoAJUeDOjZMNQMMZyWPuK2dn+YvhoH
         IXeIGu8ocWisQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 3/3] skbuff: render the checksum comment to documentation
Date:   Wed, 23 Mar 2022 16:37:15 -0700
Message-Id: <20220323233715.2104106-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323233715.2104106-1-kuba@kernel.org>
References: <20220323233715.2104106-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Long time ago Tom added a giant comment to skbuff.h explaining
checksums. Now that we have a place in Documentation for skbuff
docs we should render it. Sprinkle some markup while at it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/skbuff.rst |   6 +
 include/linux/skbuff.h              | 219 ++++++++++++++++------------
 2 files changed, 130 insertions(+), 95 deletions(-)

diff --git a/Documentation/networking/skbuff.rst b/Documentation/networking/skbuff.rst
index 581e5561c362..f2b97b5bb0b0 100644
--- a/Documentation/networking/skbuff.rst
+++ b/Documentation/networking/skbuff.rst
@@ -29,3 +29,9 @@ dataref and headerless skbs
 
 .. kernel-doc:: include/linux/skbuff.h
    :doc: dataref and headerless skbs
+
+Checksum information
+--------------------
+
+.. kernel-doc:: include/linux/skbuff.h
+   :doc: skb checksums
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5b838350931c..a52524805919 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -43,98 +43,112 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
 
-/* The interface for checksum offload between the stack and networking drivers
+/**
+ * DOC: skb checksums
+ *
+ * The interface for checksum offload between the stack and networking drivers
  * is as follows...
  *
- * A. IP checksum related features
+ * IP checksum related features
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
  * Drivers advertise checksum offload capabilities in the features of a device.
  * From the stack's point of view these are capabilities offered by the driver.
  * A driver typically only advertises features that it is capable of offloading
  * to its device.
  *
- * The checksum related features are:
- *
- *	NETIF_F_HW_CSUM	- The driver (or its device) is able to compute one
- *			  IP (one's complement) checksum for any combination
- *			  of protocols or protocol layering. The checksum is
- *			  computed and set in a packet per the CHECKSUM_PARTIAL
- *			  interface (see below).
- *
- *	NETIF_F_IP_CSUM - Driver (device) is only able to checksum plain
- *			  TCP or UDP packets over IPv4. These are specifically
- *			  unencapsulated packets of the form IPv4|TCP or
- *			  IPv4|UDP where the Protocol field in the IPv4 header
- *			  is TCP or UDP. The IPv4 header may contain IP options.
- *			  This feature cannot be set in features for a device
- *			  with NETIF_F_HW_CSUM also set. This feature is being
- *			  DEPRECATED (see below).
- *
- *	NETIF_F_IPV6_CSUM - Driver (device) is only able to checksum plain
- *			  TCP or UDP packets over IPv6. These are specifically
- *			  unencapsulated packets of the form IPv6|TCP or
- *			  IPv6|UDP where the Next Header field in the IPv6
- *			  header is either TCP or UDP. IPv6 extension headers
- *			  are not supported with this feature. This feature
- *			  cannot be set in features for a device with
- *			  NETIF_F_HW_CSUM also set. This feature is being
- *			  DEPRECATED (see below).
- *
- *	NETIF_F_RXCSUM - Driver (device) performs receive checksum offload.
- *			 This flag is only used to disable the RX checksum
- *			 feature for a device. The stack will accept receive
- *			 checksum indication in packets received on a device
- *			 regardless of whether NETIF_F_RXCSUM is set.
- *
- * B. Checksumming of received packets by device. Indication of checksum
- *    verification is set in skb->ip_summed. Possible values are:
- *
- * CHECKSUM_NONE:
+ * .. flat-table:: Checksum related device features
+ *   :widths: 1 10
+ *
+ *   * - %NETIF_F_HW_CSUM
+ *     - The driver (or its device) is able to compute one
+ *	 IP (one's complement) checksum for any combination
+ *	 of protocols or protocol layering. The checksum is
+ *	 computed and set in a packet per the CHECKSUM_PARTIAL
+ *	 interface (see below).
+ *
+ *   * - %NETIF_F_IP_CSUM
+ *     - Driver (device) is only able to checksum plain
+ *	 TCP or UDP packets over IPv4. These are specifically
+ *	 unencapsulated packets of the form IPv4|TCP or
+ *	 IPv4|UDP where the Protocol field in the IPv4 header
+ *	 is TCP or UDP. The IPv4 header may contain IP options.
+ *	 This feature cannot be set in features for a device
+ *	 with NETIF_F_HW_CSUM also set. This feature is being
+ *	 DEPRECATED (see below).
+ *
+ *   * - %NETIF_F_IPV6_CSUM
+ *     - Driver (device) is only able to checksum plain
+ *	 TCP or UDP packets over IPv6. These are specifically
+ *	 unencapsulated packets of the form IPv6|TCP or
+ *	 IPv6|UDP where the Next Header field in the IPv6
+ *	 header is either TCP or UDP. IPv6 extension headers
+ *	 are not supported with this feature. This feature
+ *	 cannot be set in features for a device with
+ *	 NETIF_F_HW_CSUM also set. This feature is being
+ *	 DEPRECATED (see below).
+ *
+ *   * - %NETIF_F_RXCSUM
+ *     - Driver (device) performs receive checksum offload.
+ *	 This flag is only used to disable the RX checksum
+ *	 feature for a device. The stack will accept receive
+ *	 checksum indication in packets received on a device
+ *	 regardless of whether NETIF_F_RXCSUM is set.
+ *
+ * Checksumming of received packets by device
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Indication of checksum verification is set in &sk_buff.ip_summed.
+ * Possible values are:
+ *
+ * - %CHECKSUM_NONE
  *
  *   Device did not checksum this packet e.g. due to lack of capabilities.
  *   The packet contains full (though not verified) checksum in packet but
  *   not in skb->csum. Thus, skb->csum is undefined in this case.
  *
- * CHECKSUM_UNNECESSARY:
+ * - %CHECKSUM_UNNECESSARY
  *
  *   The hardware you're dealing with doesn't calculate the full checksum
- *   (as in CHECKSUM_COMPLETE), but it does parse headers and verify checksums
- *   for specific protocols. For such packets it will set CHECKSUM_UNNECESSARY
- *   if their checksums are okay. skb->csum is still undefined in this case
+ *   (as in %CHECKSUM_COMPLETE), but it does parse headers and verify checksums
+ *   for specific protocols. For such packets it will set %CHECKSUM_UNNECESSARY
+ *   if their checksums are okay. &sk_buff.csum is still undefined in this case
  *   though. A driver or device must never modify the checksum field in the
  *   packet even if checksum is verified.
  *
- *   CHECKSUM_UNNECESSARY is applicable to following protocols:
- *     TCP: IPv6 and IPv4.
- *     UDP: IPv4 and IPv6. A device may apply CHECKSUM_UNNECESSARY to a
+ *   %CHECKSUM_UNNECESSARY is applicable to following protocols:
+ *
+ *     - TCP: IPv6 and IPv4.
+ *     - UDP: IPv4 and IPv6. A device may apply CHECKSUM_UNNECESSARY to a
  *       zero UDP checksum for either IPv4 or IPv6, the networking stack
  *       may perform further validation in this case.
- *     GRE: only if the checksum is present in the header.
- *     SCTP: indicates the CRC in SCTP header has been validated.
- *     FCOE: indicates the CRC in FC frame has been validated.
+ *     - GRE: only if the checksum is present in the header.
+ *     - SCTP: indicates the CRC in SCTP header has been validated.
+ *     - FCOE: indicates the CRC in FC frame has been validated.
  *
- *   skb->csum_level indicates the number of consecutive checksums found in
- *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.
+ *   &sk_buff.csum_level indicates the number of consecutive checksums found in
+ *   the packet minus one that have been verified as %CHECKSUM_UNNECESSARY.
  *   For instance if a device receives an IPv6->UDP->GRE->IPv4->TCP packet
  *   and a device is able to verify the checksums for UDP (possibly zero),
- *   GRE (checksum flag is set) and TCP, skb->csum_level would be set to
+ *   GRE (checksum flag is set) and TCP, &sk_buff.csum_level would be set to
  *   two. If the device were only able to verify the UDP checksum and not
  *   GRE, either because it doesn't support GRE checksum or because GRE
  *   checksum is bad, skb->csum_level would be set to zero (TCP checksum is
  *   not considered in this case).
  *
- * CHECKSUM_COMPLETE:
+ * - %CHECKSUM_COMPLETE
  *
  *   This is the most generic way. The device supplied checksum of the _whole_
- *   packet as seen by netif_rx() and fills in skb->csum. This means the
+ *   packet as seen by netif_rx() and fills in &sk_buff.csum. This means the
  *   hardware doesn't need to parse L3/L4 headers to implement this.
  *
  *   Notes:
+ *
  *   - Even if device supports only some protocols, but is able to produce
  *     skb->csum, it MUST use CHECKSUM_COMPLETE, not CHECKSUM_UNNECESSARY.
  *   - CHECKSUM_COMPLETE is not applicable to SCTP and FCoE protocols.
  *
- * CHECKSUM_PARTIAL:
+ * - %CHECKSUM_PARTIAL
  *
  *   A checksum is set up to be offloaded to a device as described in the
  *   output description for CHECKSUM_PARTIAL. This may occur on a packet
@@ -146,14 +160,18 @@
  *   packet that are after the checksum being offloaded are not considered to
  *   be verified.
  *
- * C. Checksumming on transmit for non-GSO. The stack requests checksum offload
- *    in the skb->ip_summed for a packet. Values are:
+ * Checksumming on transmit for non-GSO
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * The stack requests checksum offload in the &sk_buff.ip_summed for a packet.
+ * Values are:
  *
- * CHECKSUM_PARTIAL:
+ * - %CHECKSUM_PARTIAL
  *
  *   The driver is required to checksum the packet as seen by hard_start_xmit()
- *   from skb->csum_start up to the end, and to record/write the checksum at
- *   offset skb->csum_start + skb->csum_offset. A driver may verify that the
+ *   from &sk_buff.csum_start up to the end, and to record/write the checksum at
+ *   offset &sk_buff.csum_start + &sk_buff.csum_offset.
+ *   A driver may verify that the
  *   csum_start and csum_offset values are valid values given the length and
  *   offset of the packet, but it should not attempt to validate that the
  *   checksum refers to a legitimate transport layer checksum -- it is the
@@ -165,55 +183,66 @@
  *   checksum calculation to the device, or call skb_checksum_help (in the case
  *   that the device does not support offload for a particular checksum).
  *
- *   NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are being deprecated in favor of
- *   NETIF_F_HW_CSUM. New devices should use NETIF_F_HW_CSUM to indicate
+ *   %NETIF_F_IP_CSUM and %NETIF_F_IPV6_CSUM are being deprecated in favor of
+ *   %NETIF_F_HW_CSUM. New devices should use %NETIF_F_HW_CSUM to indicate
  *   checksum offload capability.
- *   skb_csum_hwoffload_help() can be called to resolve CHECKSUM_PARTIAL based
+ *   skb_csum_hwoffload_help() can be called to resolve %CHECKSUM_PARTIAL based
  *   on network device checksumming capabilities: if a packet does not match
- *   them, skb_checksum_help or skb_crc32c_help (depending on the value of
- *   csum_not_inet, see item D.) is called to resolve the checksum.
+ *   them, skb_checksum_help() or skb_crc32c_help() (depending on the value of
+ *   &sk_buff.csum_not_inet, see :ref:`crc`)
+ *   is called to resolve the checksum.
  *
- * CHECKSUM_NONE:
+ * - %CHECKSUM_NONE
  *
  *   The skb was already checksummed by the protocol, or a checksum is not
  *   required.
  *
- * CHECKSUM_UNNECESSARY:
+ * - %CHECKSUM_UNNECESSARY
  *
  *   This has the same meaning as CHECKSUM_NONE for checksum offload on
  *   output.
  *
- * CHECKSUM_COMPLETE:
+ * - %CHECKSUM_COMPLETE
+ *
  *   Not used in checksum output. If a driver observes a packet with this value
- *   set in skbuff, it should treat the packet as if CHECKSUM_NONE were set.
- *
- * D. Non-IP checksum (CRC) offloads
- *
- *   NETIF_F_SCTP_CRC - This feature indicates that a device is capable of
- *     offloading the SCTP CRC in a packet. To perform this offload the stack
- *     will set csum_start and csum_offset accordingly, set ip_summed to
- *     CHECKSUM_PARTIAL and set csum_not_inet to 1, to provide an indication in
- *     the skbuff that the CHECKSUM_PARTIAL refers to CRC32c.
- *     A driver that supports both IP checksum offload and SCTP CRC32c offload
- *     must verify which offload is configured for a packet by testing the
- *     value of skb->csum_not_inet; skb_crc32c_csum_help is provided to resolve
- *     CHECKSUM_PARTIAL on skbs where csum_not_inet is set to 1.
- *
- *   NETIF_F_FCOE_CRC - This feature indicates that a device is capable of
- *     offloading the FCOE CRC in a packet. To perform this offload the stack
- *     will set ip_summed to CHECKSUM_PARTIAL and set csum_start and csum_offset
- *     accordingly. Note that there is no indication in the skbuff that the
- *     CHECKSUM_PARTIAL refers to an FCOE checksum, so a driver that supports
- *     both IP checksum offload and FCOE CRC offload must verify which offload
- *     is configured for a packet, presumably by inspecting packet headers.
- *
- * E. Checksumming on output with GSO.
- *
- * In the case of a GSO packet (skb_is_gso(skb) is true), checksum offload
+ *   set in skbuff, it should treat the packet as if %CHECKSUM_NONE were set.
+ *
+ * .. _crc:
+ *
+ * Non-IP checksum (CRC) offloads
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * .. flat-table::
+ *   :widths: 1 10
+ *
+ *   * - %NETIF_F_SCTP_CRC
+ *     - This feature indicates that a device is capable of
+ *	 offloading the SCTP CRC in a packet. To perform this offload the stack
+ *	 will set csum_start and csum_offset accordingly, set ip_summed to
+ *	 %CHECKSUM_PARTIAL and set csum_not_inet to 1, to provide an indication
+ *	 in the skbuff that the %CHECKSUM_PARTIAL refers to CRC32c.
+ *	 A driver that supports both IP checksum offload and SCTP CRC32c offload
+ *	 must verify which offload is configured for a packet by testing the
+ *	 value of &sk_buff.csum_not_inet; skb_crc32c_csum_help() is provided to
+ *	 resolve %CHECKSUM_PARTIAL on skbs where csum_not_inet is set to 1.
+ *
+ *   * - %NETIF_F_FCOE_CRC
+ *     - This feature indicates that a device is capable of offloading the FCOE
+ *	 CRC in a packet. To perform this offload the stack will set ip_summed
+ *	 to %CHECKSUM_PARTIAL and set csum_start and csum_offset
+ *	 accordingly. Note that there is no indication in the skbuff that the
+ *	 %CHECKSUM_PARTIAL refers to an FCOE checksum, so a driver that supports
+ *	 both IP checksum offload and FCOE CRC offload must verify which offload
+ *	 is configured for a packet, presumably by inspecting packet headers.
+ *
+ * Checksumming on output with GSO
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * In the case of a GSO packet (skb_is_gso() is true), checksum offload
  * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
- * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload as
+ * gso_type is %SKB_GSO_TCPV4 or %SKB_GSO_TCPV6, TCP checksum offload as
  * part of the GSO operation is implied. If a checksum is being offloaded
- * with GSO then ip_summed is CHECKSUM_PARTIAL, and both csum_start and
+ * with GSO then ip_summed is %CHECKSUM_PARTIAL, and both csum_start and
  * csum_offset are set to refer to the outermost checksum being offloaded
  * (two offloaded checksums are possible with UDP encapsulation).
  */
-- 
2.34.1

