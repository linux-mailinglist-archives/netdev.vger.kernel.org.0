Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D93896EB
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhESTpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhESTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:45:22 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9CCC06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 12:44:02 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by andre.telenet-ops.be with bizsmtp
        id 6jjt2500n31btb901jjupH; Wed, 19 May 2021 21:43:58 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljS6j-007Lx7-GM; Wed, 19 May 2021 21:43:53 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljS6i-007mWt-Pz; Wed, 19 May 2021 21:43:52 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Qi Zhang <qi.z.zhang@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yahui Cao <yahui.cao@intel.com>,
        Beilei Xing <beilei.xing@intel.com>,
        Simei Su <simei.su@intel.com>, Jeff Guo <jia.guo@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] virtchnl: Add missing padding to virtchnl_proto_hdrs
Date:   Wed, 19 May 2021 21:43:50 +0200
Message-Id: <20210519194350.1854798-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
Compile-tested only.
---
 include/linux/avf/virtchnl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 565deea6ffe88b99..8612f8fc86c1db21 100644
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
2.25.1

