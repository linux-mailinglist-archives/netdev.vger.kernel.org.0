Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FBD39BC96
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFDQL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:11:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:16626 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDQL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:11:29 -0400
IronPort-SDR: HXOLi3efNFyQNbf7eKVBUPTiOuib0sdJpTKXEGxRw4lhf47HqHgXIPEcu9C9yczGe9mZkk2seR
 oCY0A6AWZyiA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="202460188"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="202460188"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:04 -0700
IronPort-SDR: k3gvTJc9pWFuSIbsUeI3MhVao/D2ydQk1UBPwa34eiCaVXBgo3hBp28KfLILMvcip8o3VYYLVS
 z4ANvw0lZquA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511746"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        kernel test robot <lkp@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net 6/6] virtchnl: Add missing padding to virtchnl_proto_hdrs
Date:   Fri,  4 Jun 2021 09:08:16 -0700
Message-Id: <20210604160816.3391716-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

On m68k (Coldfire M547x):

      CC      drivers/net/ethernet/intel/i40e/i40e_main.o
    In file included from drivers/net/ethernet/intel/i40e/i40e_prototype.h:9,
		     from drivers/net/ethernet/intel/i40e/i40e.h:41,
		     from drivers/net/ethernet/intel/i40e/i40e_main.c:12:
    include/linux/avf/virtchnl.h:153:36: warning: division by zero [-Wdiv-by-zero]
      153 |  { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
	  |                                    ^
    include/linux/avf/virtchnl.h:844:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
      844 | VIRTCHNL_CHECK_STRUCT_LEN(2312, virtchnl_proto_hdrs);
	  | ^~~~~~~~~~~~~~~~~~~~~~~~~
    include/linux/avf/virtchnl.h:844:33: error: enumerator value for ‘virtchnl_static_assert_virtchnl_proto_hdrs’ is not an integer constant
      844 | VIRTCHNL_CHECK_STRUCT_LEN(2312, virtchnl_proto_hdrs);
	  |                                 ^~~~~~~~~~~~~~~~~~~

On m68k, integers are aligned on addresses that are multiples of two,
not four, bytes.  Hence the size of a structure containing integers may
not be divisible by 4.

Fix this by adding explicit padding.

Fixes: 1f7ea1cd6a374842 ("ice: Enable FDIR Configure for AVF")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 565deea6ffe8..8612f8fc86c1 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -830,6 +830,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(72, virtchnl_proto_hdr);
 
 struct virtchnl_proto_hdrs {
 	u8 tunnel_level;
+	u8 pad[3];
 	/**
 	 * specify where protocol header start from.
 	 * 0 - from the outer layer
-- 
2.26.2

