Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777D8696800
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBNPZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBNPZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:25:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6BB2A143;
        Tue, 14 Feb 2023 07:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7ACB81BFA;
        Tue, 14 Feb 2023 15:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE26CC433EF;
        Tue, 14 Feb 2023 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676388352;
        bh=S672kuM2oKkdizJFtUPdFijqnxwsifpqRIps1yp91iA=;
        h=From:To:Cc:Subject:Date:From;
        b=PHh5CRZ99XD1TaFZ1paqrurf/zq/FH7vYrIiq7aCOtOKbEZpaebqUKELEfOBBtaoY
         Yz/l+RRRaujZhwCH7D9zIYv5Fs8L4bzd6TYuuNIRw/c3jYwn3Lvaztpo/KjHan52ZH
         MQTRkwCglfeZwvAENIAMGnMvEgUzYO5MLPSBPQaP7pm9pEuilZrJl2a6X1zW17nPA/
         unJyFzPjE8BEVYhrq9LkCuCWAXSktDTqn1DDjZj3Em1XQBUCZ5n8gpONP1WXOqAbh0
         teS4WER/vNmOnGDU42z2SOc2ujCzKkiKJwwk62HS3Qf3x8lCMjSxbeIWihKaK1qNTo
         1ws56mDxoyINA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Lu Wei <luwei32@huawei.com>, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] ethernet: ice: avoid gcc-9 integer overflow warning
Date:   Tue, 14 Feb 2023 16:25:36 +0100
Message-Id: <20230214152548.826703-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With older compilers like gcc-9, the calculation of the vlan
priority field causes a false-positive warning from the byteswap:

In file included from drivers/net/ethernet/intel/ice/ice_tc_lib.c:4:
drivers/net/ethernet/intel/ice/ice_tc_lib.c: In function 'ice_parse_cls_flower':
include/uapi/linux/swab.h:15:15: error: integer overflow in expression '(int)(short unsigned int)((int)match.key-><U67c8>.<U6698>.vlan_priority << 13) & 57344 & 255' of type 'int' results in '0' [-Werror=overflow]
   15 |  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
      |   ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
include/uapi/linux/swab.h:106:2: note: in expansion of macro '___constant_swab16'
  106 |  ___constant_swab16(x) :   \
      |  ^~~~~~~~~~~~~~~~~~
include/uapi/linux/byteorder/little_endian.h:42:43: note: in expansion of macro '__swab16'
   42 | #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
      |                                           ^~~~~~~~
include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
   96 | #define cpu_to_be16 __cpu_to_be16
      |                     ^~~~~~~~~~~~~
drivers/net/ethernet/intel/ice/ice_tc_lib.c:1458:5: note: in expansion of macro 'cpu_to_be16'
 1458 |     cpu_to_be16((match.key->vlan_priority <<
      |     ^~~~~~~~~~~

After a change to be16_encode_bits(), the code becomes more
readable to both people and compilers, which avoids the warning.

Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use be16_encode_bits() instead of a temporary variable.
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 6b48cbc049c6..76f29a5bf8d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1455,8 +1455,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
 			headers->vlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 
 		if (match.mask->vlan_tpid)
@@ -1489,8 +1489,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
 			headers->cvlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 	}
 
-- 
2.39.1

