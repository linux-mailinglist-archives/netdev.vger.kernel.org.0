Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B7600DFB
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 13:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJQLnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 07:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJQLnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 07:43:45 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25054DB1F;
        Mon, 17 Oct 2022 04:43:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666007019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wkb/kg+QXjHgGkNcUci7eTkBqluLM6K1ScPZ+P60WqU=;
        b=d2zLEVXrKvBkaP6JpyRxC8cHoeofFVhAxc9NaNSVqry8NZJUn43uDjLylanf1K6KzHrFhA
        2p/QWS+eMIBvBCa+wRKz7x2/+4LK6YvTvtKe6wVt+LUUEuzuqpJEoaQRS7uwjQVXIxu1MX
        qCMq5NRZEjrasoldE3MKUZBgPTPz5gA=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luciano.coelho@intel.com, johannes.berg@intel.com,
        jtornosm@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] iwlwifi: mvm: fix shift-out-of-bounds in iwl_mvm_add_aux_sta()
Date:   Mon, 17 Oct 2022 19:43:04 +0800
Message-Id: <20221017114304.4030248-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a warning when mvm->aux_queue is equal to IWL_MVM_INVALID_QUEUE:

[    5.225765] ================================================================================
[    5.225770] UBSAN: shift-out-of-bounds in drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2096:53
[    5.225773] shift exponent 65535 is too large for 64-bit type 'long unsigned int'
[    5.225777] Call Trace:
[    5.225779]  <TASK>
[    5.225781]  dump_stack_lvl+0x4a/0x5f
[    5.225785]  dump_stack+0x10/0x12
[    5.225786]  ubsan_epilogue+0x9/0x45
[    5.225787]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0x10e
[    5.225790]  iwl_mvm_add_aux_sta.cold+0x17/0x1f [iwlmvm]
[    5.225804]  iwl_mvm_up+0x76c/0xb90 [iwlmvm]
[    5.225814]  __iwl_mvm_mac_start+0x2b/0x190 [iwlmvm]
[    5.225821]  iwl_mvm_mac_start+0x5f/0xc0 [iwlmvm]
...
[    5.225952]  ? _copy_from_user+0x2b/0x60
[    5.225979]  __x64_sys_sendmsg+0x1f/0x30
[    5.225980]  do_syscall_64+0x59/0xc0
[    5.225982]  ? syscall_exit_to_user_mode+0x27/0x50
[    5.225984]  ? __x64_sys_write+0x1a/0x20
[    5.225985]  ? do_syscall_64+0x69/0xc0
[    5.225986]  ? __x64_sys_write+0x1a/0x20
[    5.225987]  ? do_syscall_64+0x69/0xc0
[    5.225988]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    5.225990] RIP: 0033:0x7fa42e00b18d
[    5.225993] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ca ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0     8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 fe ee ff ff 48
[    5.225994] RSP: 002b:00007fffba9a21c0 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
[    5.225996] RAX: ffffffffffffffda RBX: 0000562bdc028880 RCX: 00007fa42e00b18d
[    5.225996] RDX: 0000000000000000 RSI: 00007fffba9a2210 RDI: 000000000000000c
[    5.225997] RBP: 00007fffba9a2210 R08: 0000000000000000 R09: 0000000000000000
[    5.225998] R10: 0000562bdbffa010 R11: 0000000000000293 R12: 0000562bdc028880
[    5.225998] R13: 00007fffba9a23c8 R14: 00007fffba9a23bc R15: 0000000000000000
[    5.225999]  </TASK>
[    5.226004] ================================================================================

mvm->aux_queue may be assigned IWL_MVM_INVALID_QUEUE in
iwl_op_mode_mvm_start().

Add iwl_mvm_has_new_tx_api() before iwl_mvm_allocate_int_sta() to avoid
shift-out-of-bounds.

Fixes: c6ce1c74ef29 ("iwlwifi: mvm: avoid static queue number aliasing")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index cbd8053a9e35..33e2757e6fe6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2088,12 +2088,14 @@ static int iwl_mvm_add_int_sta_with_queue(struct iwl_mvm *mvm, int macidx,
 
 int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm, u32 lmac_id)
 {
+	u32 qmask;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	qmask = iwl_mvm_has_new_tx_api(mvm) ? 0 : BIT(mvm->aux_queue);
 	/* Allocate aux station and assign to it the aux queue */
-	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
+	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, qmask,
 				       NL80211_IFTYPE_UNSPECIFIED,
 				       IWL_STA_AUX_ACTIVITY);
 	if (ret)
-- 
2.25.1

