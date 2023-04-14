Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9539D6E276B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjDNPvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDNPvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:51:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AD4BBAE;
        Fri, 14 Apr 2023 08:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681487460; x=1713023460;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+es8XQvduTZictHBoRTR0IW2Z+9WnoX89NAdi6iQf5A=;
  b=HrBFY09MW+/yD0kBpnD8uMkI9LXksloOqf2KWV/+zb445ug5WPxYMaip
   F79az3r8d3S+k7PW6MA0Emm8T0M/ZgQC/jGyDPJrm37ew/mvC01EotAI4
   29GD1UBTCJ4N9Tv9zO8D/ZNzILmYViTgJYulir7GNCS17DXfQMGReODTR
   thQJL1jrB1JJFEvYzWdKSewolw4vCTuKqdGc5EkG4PqHU0vfY4WORmAbK
   4fsxZcqs9aE7JbrjevQzGvbduk62Ex6ngT2xeknNzp6Cqf19ZT8KKbOBr
   ZPmOWW+z4hhTq12CQXEhnC342G9PmUKmaxfqHhpMp/EMy8zS63SczIeoe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="407369166"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="407369166"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 08:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="833581607"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="833581607"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga001.fm.intel.com with ESMTP; 14 Apr 2023 08:49:35 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-hints@xdp-project.net, stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Date:   Fri, 14 Apr 2023 23:49:02 +0800
Message-Id: <20230414154902.2950535-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

igc_configure_rx_ring() function will be called as part of XDP program
setup. If Rx hardware timestamp is enabled prio to XDP program setup,
this timestamp enablement will be overwritten when buffer size is
written into SRRCTL register.

Thus, this commit read the register value before write to SRRCTL
register. This commit is tested by using xdp_hw_metadata bpf selftest
tool. The tool enables Rx hardware timestamp and then attach XDP program
to igc driver. It will display hardware timestamp of UDP packet with
port number 9092. Below are detail of test steps and results.

Command on DUT:
  sudo ./xdp_hw_metadata <interface name>

Command on Link Partner:
  echo -n skb | nc -u -q1 <destination IPv4 addr> 9092

Result before this patch:
  skb hwtstamp is not found!

Result after this patch:
  found skb hwtstamp = 1677800973.642836757

Optionally, read PHC to confirm the values obtained are almost the same:
Command:
  sudo ./testptp -d /dev/ptp0 -g
Result:
  clock time: 1677800973.913598978 or Fri Mar  3 07:49:33 2023

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
v2 -> v3: Refactor SRRCTL definitions to more human readable definitions
v1 -> v2: Fix indention
---
 drivers/net/ethernet/intel/igc/igc_base.h | 11 ++++++++---
 drivers/net/ethernet/intel/igc/igc_main.c |  7 +++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index 7a992befca24..9f3827eda157 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -87,8 +87,13 @@ union igc_adv_rx_desc {
 #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
 
 /* SRRCTL bit definitions */
-#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
-#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
-#define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000
+#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
+#define IGC_SRRCTL_BSIZEPKT(x)		FIELD_PREP(IGC_SRRCTL_BSIZEPKT_MASK, \
+					(x) / 1024) /* in 1 KB resolution */
+#define IGC_SRRCTL_BSIZEHDR_MASK	GENMASK(13, 8)
+#define IGC_SRRCTL_BSIZEHDR(x)		FIELD_PREP(IGC_SRRCTL_BSIZEHDR_MASK, \
+					(x) / 64) /* in 64 bytes resolution */
+#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
+#define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	FIELD_PREP(IGC_SRRCTL_DESCTYPE_MASK, 1)
 
 #endif /* _IGC_BASE_H */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 25fc6c65209b..a2d823e64609 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -641,8 +641,11 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
 	else
 		buf_size = IGC_RXBUFFER_2048;
 
-	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
-	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
+	srrctl = rd32(IGC_SRRCTL(reg_idx));
+	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDR_MASK |
+		    IGC_SRRCTL_DESCTYPE_MASK);
+	srrctl |= IGC_SRRCTL_BSIZEHDR(IGC_RX_HDR_LEN);
+	srrctl |= IGC_SRRCTL_BSIZEPKT(buf_size);
 	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
 
 	wr32(IGC_SRRCTL(reg_idx), srrctl);
-- 
2.34.1

