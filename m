Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40041DF547
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387622AbgEWGsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:48:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387671AbgEWGsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:48:50 -0400
IronPort-SDR: BEK+APJcdAdyCq6MnSQnS3WubLANcEGhaauk5lxEBd4Sy3RTz0t8Y+uAHJtoSekZnCkb5Qv4Xt
 imXlfUuDlH1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:48 -0700
IronPort-SDR: MbsUYCqeBzR97YlNqIwwQe8dOV7Ku+GV6cWX0FFTI6UW0h4i7wqOPn+0VkLHuwjSMnSjH7GWua
 FTUPPKHDmFfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966873"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, noreply@ellerman.id.au,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/16] virtchnl: Add missing explicit padding to structures
Date:   Fri, 22 May 2020 23:48:32 -0700
Message-Id: <20200523064847.3972158-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

On e.g. m68k, the alignment of 32-bit values is only 2 bytes, leading
to the following:

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

Reported-by: <noreply@ellerman.id.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/avf/virtchnl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index ca956b672ac0..40bad71865ea 100644
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
2.26.2

