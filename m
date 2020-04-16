Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E611ABD45
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504136AbgDPJvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504099AbgDPJuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 05:50:54 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B44C061A10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 02:50:53 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:fd83:81bb:c1d7:433d])
        by michel.telenet-ops.be with bizsmtp
        id TMqr220064dKHqf06Mqrzy; Thu, 16 Apr 2020 11:50:51 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jP1AZ-00013K-2g; Thu, 16 Apr 2020 11:50:51 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jP1AZ-0003N5-0d; Thu, 16 Apr 2020 11:50:51 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] virtchnl: Add missing explicit padding to structures
Date:   Thu, 16 Apr 2020 11:50:49 +0200
Message-Id: <20200416095049.12917-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On e.g. m68k, the alignment of 32-bit values is only 2 bytes, leading
to:

    ./include/linux/avf/virtchnl.h:147:36: warning: division by zero [-Wdiv-by-zero]
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
					^
    ./include/linux/avf/virtchnl.h:577:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
     VIRTCHNL_CHECK_STRUCT_LEN(272, virtchnl_filter);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:577:32: error: enumerator value for ‘virtchnl_static_assert_virtchnl_filter’ is not an integer constant
     VIRTCHNL_CHECK_STRUCT_LEN(272, virtchnl_filter);
				    ^~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:147:53: note: in definition of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
							 ^
    ./include/linux/avf/virtchnl.h:147:36: warning: division by zero [-Wdiv-by-zero]
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
					^
    ./include/linux/avf/virtchnl.h:619:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
     VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_pf_event);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:619:31: error: enumerator value for ‘virtchnl_static_assert_virtchnl_pf_event’ is not an integer constant
     VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_pf_event);
				   ^~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:147:53: note: in definition of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
							 ^
    ./include/linux/avf/virtchnl.h:147:36: warning: division by zero [-Wdiv-by-zero]
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
					^
    ./include/linux/avf/virtchnl.h:640:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
     VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_iwarp_qv_info);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:640:31: error: enumerator value for ‘virtchnl_static_assert_virtchnl_iwarp_qv_info’ is not an integer constant
     VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_iwarp_qv_info);
				   ^~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:147:53: note: in definition of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
							 ^
    ./include/linux/avf/virtchnl.h:147:36: warning: division by zero [-Wdiv-by-zero]
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
					^
    ./include/linux/avf/virtchnl.h:647:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
     VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_iwarp_qvlist_info);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:647:31: error: enumerator value for ‘virtchnl_static_assert_virtchnl_iwarp_qvlist_info’ is not an integer constant
     VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_iwarp_qvlist_info);
				   ^~~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/avf/virtchnl.h:147:53: note: in definition of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
      { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
							 ^

Fix this by adding explicit padding to structures with holes.

Reported-by: noreply@ellerman.id.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Exposed by the "select PCI" in commit 4be5e8648b0c287a ("media: move CEC
platform drivers to a separate directory").
---
 include/linux/avf/virtchnl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index ca956b672ac0f759..40bad71865ea7628 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -476,6 +476,7 @@ struct virtchnl_rss_key {
 	u16 vsi_id;
 	u16 key_len;
 	u8 key[1];         /* RSS hash key, packed bytes */
+	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
@@ -484,6 +485,7 @@ struct virtchnl_rss_lut {
 	u16 vsi_id;
 	u16 lut_entries;
 	u8 lut[1];        /* RSS lookup table */
+	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_lut);
@@ -572,6 +574,7 @@ struct virtchnl_filter {
 	enum	virtchnl_action action;
 	u32	action_meta;
 	u8	field_flags;
+	u8	pad[3];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(272, virtchnl_filter);
@@ -610,6 +613,7 @@ struct virtchnl_pf_event {
 			/* link_speed provided in Mbps */
 			u32 link_speed;
 			u8 link_status;
+			u8 pad[3];
 		} link_event_adv;
 	} event_data;
 
@@ -635,6 +639,7 @@ struct virtchnl_iwarp_qv_info {
 	u16 ceq_idx;
 	u16 aeq_idx;
 	u8 itr_idx;
+	u8 pad[3];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_iwarp_qv_info);
-- 
2.17.1

