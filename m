Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEB05A5699
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH2WBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH2WBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:01:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9E56D9C9
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661810461; x=1693346461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pjlCb6nei/JlYu7s8yaMKnoehzehScG3UaDBO2QwuZQ=;
  b=OQ5cn8efuCxfF+zl5Mp4958mAw6IWMaArhtuEtD1LkStkC+S/+Zwa6fa
   J2pZYSpu6kPxhvtqRJBmQDWf3U2Xr/y++JPMjlnbH71d8fBVr9dcB32Dh
   5QP1bIo9LvQIJgfiJc20pf7xrH8bnt0uRh6Xo0ECa65MQ4wXnz7GlQOUz
   9ISMDEzj4qYQ4PTQrjlBwlcVRCeyJrV4NSNSuGsw32QKd6uQCTrqrHqwH
   +eTCuz9fRESAKWIIs8se4HH4ApSAzh8d1X8+dfyJ5/h4RpGIZcdwjgKQS
   /rUKWgOxoJHhmTYbyKUgf+e2rDa7NlDPbtUdGkh26T759a+dsxFRdBRMz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="278026614"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="278026614"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 15:01:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="672551201"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 15:01:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 3/3] ice: Add set_termios tty operations handle to GNSS
Date:   Mon, 29 Aug 2022 15:00:49 -0700
Message-Id: <20220829220049.333434-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

Some third party tools (ex. ubxtool) try to change GNSS TTY parameters
(ex. speed). While being optional implementation, without set_termios
handle this operation fails and prevents those third party tools from
working. TTY interface in ice driver is virtual and doesn't need any change
on set_termios, so is left empty. Add this mock to support all Linux TTY
APIs.

Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index b5a7f246d230..c2dc5e5c8fa4 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -404,11 +404,26 @@ static unsigned int ice_gnss_tty_write_room(struct tty_struct *tty)
 	return ICE_GNSS_TTY_WRITE_BUF;
 }
 
+/**
+ * ice_gnss_tty_set_termios - mock for set_termios tty operations
+ * @tty: pointer to the tty_struct
+ * @new_termios: pointer to the new termios parameters
+ */
+static void
+ice_gnss_tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
+{
+	/* Some 3rd party tools (ex. ubxtool) want to change the TTY parameters.
+	 * In our virtual interface (I2C communication over FW AQ) we don't have
+	 * to change anything, but we need to implement it to unblock tools.
+	 */
+}
+
 static const struct tty_operations tty_gps_ops = {
 	.open =		ice_gnss_tty_open,
 	.close =	ice_gnss_tty_close,
 	.write =	ice_gnss_tty_write,
 	.write_room =	ice_gnss_tty_write_room,
+	.set_termios =  ice_gnss_tty_set_termios,
 };
 
 /**
-- 
2.35.1

