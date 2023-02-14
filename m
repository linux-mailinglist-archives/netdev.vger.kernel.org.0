Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32408696472
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjBNNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjBNNUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:20:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C972959F7;
        Tue, 14 Feb 2023 05:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B6BB61601;
        Tue, 14 Feb 2023 13:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0A9C4339B;
        Tue, 14 Feb 2023 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676380806;
        bh=2CeITdNxri0c/lH27oKamdXHaU07x4TU7pa3d7pB2zw=;
        h=From:To:Cc:Subject:Date:From;
        b=cjl6nC5FFH9cK6UD23bBAsMGjP3Umg+fOif8ex7YQ0EInIBIJv1YzaLqdbnXeJoME
         gcCeOantwDKND29WlmSAXiNcy8fNgYgxJk7nClMrzzUISHMu0nI6ha4NYwqalfZrsR
         /k8Tp+em9sbHyfz3Z7eaL32VMEYX+RZPutl1K6Au1wUI70URXybc3sTvVTAxjE/a+k
         vfGimFa63dYfIV1Gb14zgF6jZFfRZ7gPx6GJxlGFVBzTJd5YatrRUwt1fjEf94gLnT
         gV63s0i6km+SvAJcJxKTv0MFdiy2SbUb+mnTN+F7N2zllQkb+YNBe7b8Z8m8m25fZo
         EHQxAHFuaz5QA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: ice: avoid gcc-9 integer overflow warning
Date:   Tue, 14 Feb 2023 14:19:49 +0100
Message-Id: <20230214132002.1498163-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With older compilers like gcc-9, the calculation of the vlan
priority field causes a warning from the byteswap:

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

The code looks correct to me, so just avoid the warning by replacing
the macro expansion with an intermediate variable.

Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 6b48cbc049c6..e9932446185c 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1453,10 +1453,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		}
 
 		if (match.mask->vlan_priority) {
+			u16 prio = (match.key->vlan_priority << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
 			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
-			headers->vlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+			headers->vlan_hdr.vlan_prio = cpu_to_be16(prio);
 		}
 
 		if (match.mask->vlan_tpid)
@@ -1487,10 +1486,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		}
 
 		if (match.mask->vlan_priority) {
+			u16 prio = (match.key->vlan_priority << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
 			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
-			headers->cvlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+			headers->cvlan_hdr.vlan_prio = cpu_to_be16(prio);
 		}
 	}
 
-- 
2.39.1

