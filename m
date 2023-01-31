Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987456838C6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjAaVhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjAaVhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1255421E
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201035; x=1706737035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fcwEFNzIqNcPIzbO/KyAbeedklVcBoBL5cIGeCJ42ls=;
  b=neG9vwPFjA9YcfSO6EGk2mDtNGyvsZs48aqyUvsUZwxf6E4DSgIuTNDz
   z5kWtpl/0MbTymnelTiZWluI8+xWxLVGWZA8WFRFSI9WBk7YU3K3EBflF
   oiPsKpmmtsNIajiqmrbABZAwKF4jua7IPwRm8xnl1O7WAQjEB1pj+RN2R
   fVgrUOjPCDE1CD1w3CHznFQDPst+L6Cbu5mJRUGtpRzSzTre8gE8Szfv4
   WjStzq6gLxjeyyDkLmPI8spdfaAuDpF9RPKSiC+8lHPIKuqb5z507qqy7
   UeuIlWz6XKcDF/t49IVR17QxwzNna92VXkjxYm+38sjH9FmnjiZcJngIW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980293"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980293"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063013"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063013"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/6] ice: fix out-of-bounds KASAN warning in virtchnl
Date:   Tue, 31 Jan 2023 13:37:00 -0800
Message-Id: <20230131213703.1347761-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

KASAN reported:
[ 9793.708867] BUG: KASAN: global-out-of-bounds in ice_get_link_speed+0x16/0x30 [ice]
[ 9793.709205] Read of size 4 at addr ffffffffc1271b1c by task kworker/6:1/402

[ 9793.709222] CPU: 6 PID: 402 Comm: kworker/6:1 Kdump: loaded Tainted: G    B      OE      6.1.0+ #3
[ 9793.709235] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.00.01.0014.070920180847 07/09/2018
[ 9793.709245] Workqueue: ice ice_service_task [ice]
[ 9793.709575] Call Trace:
[ 9793.709582]  <TASK>
[ 9793.709588]  dump_stack_lvl+0x44/0x5c
[ 9793.709613]  print_report+0x17f/0x47b
[ 9793.709632]  ? __cpuidle_text_end+0x5/0x5
[ 9793.709653]  ? ice_get_link_speed+0x16/0x30 [ice]
[ 9793.709986]  ? ice_get_link_speed+0x16/0x30 [ice]
[ 9793.710317]  kasan_report+0xb7/0x140
[ 9793.710335]  ? ice_get_link_speed+0x16/0x30 [ice]
[ 9793.710673]  ice_get_link_speed+0x16/0x30 [ice]
[ 9793.711006]  ice_vc_notify_vf_link_state+0x14c/0x160 [ice]
[ 9793.711351]  ? ice_vc_repr_cfg_promiscuous_mode+0x120/0x120 [ice]
[ 9793.711698]  ice_vc_process_vf_msg+0x7a7/0xc00 [ice]
[ 9793.712074]  __ice_clean_ctrlq+0x98f/0xd20 [ice]
[ 9793.712534]  ? ice_bridge_setlink+0x410/0x410 [ice]
[ 9793.712979]  ? __request_module+0x320/0x520
[ 9793.713014]  ? ice_process_vflr_event+0x27/0x130 [ice]
[ 9793.713489]  ice_service_task+0x11cf/0x1950 [ice]
[ 9793.713948]  ? io_schedule_timeout+0xb0/0xb0
[ 9793.713972]  process_one_work+0x3d0/0x6a0
[ 9793.714003]  worker_thread+0x8a/0x610
[ 9793.714031]  ? process_one_work+0x6a0/0x6a0
[ 9793.714049]  kthread+0x164/0x1a0
[ 9793.714071]  ? kthread_complete_and_exit+0x20/0x20
[ 9793.714100]  ret_from_fork+0x1f/0x30
[ 9793.714137]  </TASK>

[ 9793.714151] The buggy address belongs to the variable:
[ 9793.714158]  ice_aq_to_link_speed+0x3c/0xffffffffffff3520 [ice]

[ 9793.714632] Memory state around the buggy address:
[ 9793.714642]  ffffffffc1271a00: f9 f9 f9 f9 00 00 05 f9 f9 f9 f9 f9 00 00 02 f9
[ 9793.714656]  ffffffffc1271a80: f9 f9 f9 f9 00 00 04 f9 f9 f9 f9 f9 00 00 00 00
[ 9793.714670] >ffffffffc1271b00: 00 00 00 04 f9 f9 f9 f9 04 f9 f9 f9 f9 f9 f9 f9
[ 9793.714680]                             ^
[ 9793.714690]  ffffffffc1271b80: 00 00 00 00 00 04 f9 f9 f9 f9 f9 f9 00 00 00 00
[ 9793.714704]  ffffffffc1271c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

The ICE_AQ_LINK_SPEED_UNKNOWN define is BIT(15). The value is bigger
than both legacy and normal link speed tables. Add one element (0 -
unknown) to both tables. There is no need to explicitly set table size,
leave it empty.

Fixes: 1d0e28a9be1f ("ice: Remove and replace ice speed defines with ethtool.h versions")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  9 ++++-----
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 21 ++++++++-------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d02b55b6aa9c..3e08847505ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5524,7 +5524,7 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
  * returned by the firmware is a 16 bit * value, but is indexed
  * by [fls(speed) - 1]
  */
-static const u32 ice_aq_to_link_speed[15] = {
+static const u32 ice_aq_to_link_speed[] = {
 	SPEED_10,	/* BIT(0) */
 	SPEED_100,
 	SPEED_1000,
@@ -5536,10 +5536,6 @@ static const u32 ice_aq_to_link_speed[15] = {
 	SPEED_40000,
 	SPEED_50000,
 	SPEED_100000,	/* BIT(10) */
-	0,
-	0,
-	0,
-	0		/* BIT(14) */
 };
 
 /**
@@ -5550,5 +5546,8 @@ static const u32 ice_aq_to_link_speed[15] = {
  */
 u32 ice_get_link_speed(u16 index)
 {
+	if (index >= ARRAY_SIZE(ice_aq_to_link_speed))
+		return 0;
+
 	return ice_aq_to_link_speed[index];
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index d4a4001b6e5d..f56fa94ff3d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -39,7 +39,7 @@ ice_aq_send_msg_to_vf(struct ice_hw *hw, u16 vfid, u32 v_opcode, u32 v_retval,
 	return ice_sq_send_cmd(hw, &hw->mailboxq, &desc, msg, msglen, cd);
 }
 
-static const u32 ice_legacy_aq_to_vc_speed[15] = {
+static const u32 ice_legacy_aq_to_vc_speed[] = {
 	VIRTCHNL_LINK_SPEED_100MB,	/* BIT(0) */
 	VIRTCHNL_LINK_SPEED_100MB,
 	VIRTCHNL_LINK_SPEED_1GB,
@@ -51,10 +51,6 @@ static const u32 ice_legacy_aq_to_vc_speed[15] = {
 	VIRTCHNL_LINK_SPEED_40GB,
 	VIRTCHNL_LINK_SPEED_40GB,
 	VIRTCHNL_LINK_SPEED_40GB,
-	VIRTCHNL_LINK_SPEED_UNKNOWN,
-	VIRTCHNL_LINK_SPEED_UNKNOWN,
-	VIRTCHNL_LINK_SPEED_UNKNOWN,
-	VIRTCHNL_LINK_SPEED_UNKNOWN	/* BIT(14) */
 };
 
 /**
@@ -71,21 +67,20 @@ static const u32 ice_legacy_aq_to_vc_speed[15] = {
  */
 u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed)
 {
-	u32 speed;
+	/* convert a BIT() value into an array index */
+	u32 index = fls(link_speed) - 1;
 
-	if (adv_link_support) {
-		/* convert a BIT() value into an array index */
-		speed = ice_get_link_speed(fls(link_speed) - 1);
-	} else {
+	if (adv_link_support)
+		return ice_get_link_speed(index);
+	else if (index < ARRAY_SIZE(ice_legacy_aq_to_vc_speed))
 		/* Virtchnl speeds are not defined for every speed supported in
 		 * the hardware. To maintain compatibility with older AVF
 		 * drivers, while reporting the speed the new speed values are
 		 * resolved to the closest known virtchnl speeds
 		 */
-		speed = ice_legacy_aq_to_vc_speed[fls(link_speed) - 1];
-	}
+		return ice_legacy_aq_to_vc_speed[index];
 
-	return speed;
+	return VIRTCHNL_LINK_SPEED_UNKNOWN;
 }
 
 /* The mailbox overflow detection algorithm helps to check if there
-- 
2.38.1

