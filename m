Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F273F6E10BB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjDMPNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDMPNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:13:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E01184;
        Thu, 13 Apr 2023 08:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681398785; x=1712934785;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f6ND7RnB4gbPxv8sBeifXq2wwq96IRhvnSOplOcfMXw=;
  b=lL4BSuEGRYub3csp0mOy1sWkpkJDByqRWM8DhoVvP6huCeD3a4pBHd0m
   114HjJTR8p23zHuoQV/zjCkPB0hP4j35euLlKuFt644czfL05qzoNc/mt
   Ffc/TMnN2NpZ0WDspGO1fAiW2w1n8xmsjQ0LlxwFZcei2ptu0G98+2MqC
   qW1cvebfxhe0NexzC+CorSooGfVGwuYBY/caMzJBZlCZb+W6dCTZbujwV
   q0FiPAP3vGKv5aoD8joew1ZXMwko2kfrGxsKTYWvADF+wihO0n/HjjdiD
   +TfvZhxzTZfdSiLijfDJ8jSNZpJjw3uZUl9amlVHcPsEKUKsCygr8BhPQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344203265"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="344203265"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 08:13:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="666808531"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="666808531"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2023 08:12:57 -0700
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
        Stanislav Fomichev <sdf@google.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-hints@xdp-project.net, stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net 1/1] igc: read before write to SRRCTL register
Date:   Thu, 13 Apr 2023 23:12:22 +0800
Message-Id: <20230413151222.1864307-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
  found skb hwtstamp = 1677762212.590696226

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.h | 7 +++++--
 drivers/net/ethernet/intel/igc/igc_main.c | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index 7a992befca24..b95007d51d13 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -87,8 +87,11 @@ union igc_adv_rx_desc {
 #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
 
 /* SRRCTL bit definitions */
-#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
-#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
+#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
+#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */
+#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
+#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */
+#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
 #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000
 
 #endif /* _IGC_BASE_H */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 25fc6c65209b..de7b21c2ccd6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -641,7 +641,10 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
 	else
 		buf_size = IGC_RXBUFFER_2048;
 
-	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
+	srrctl = rd32(IGC_SRRCTL(reg_idx));
+	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDRSIZE_MASK |
+		  IGC_SRRCTL_DESCTYPE_MASK);
+	srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
 	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
 	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
 
-- 
2.34.1

