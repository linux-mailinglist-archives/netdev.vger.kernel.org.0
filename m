Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA665CA50
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbjACXcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbjACXb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:31:59 -0500
Received: from mail-il1-x164.google.com (mail-il1-x164.google.com [IPv6:2607:f8b0:4864:20::164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6F13E3C
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:31:57 -0800 (PST)
Received: by mail-il1-x164.google.com with SMTP id h26so4574868ila.11
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 15:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJeRQe8CVf5j9/EEF5CDkRUhzoSsNWEdjtVzXHLXdNE=;
        b=PyejDJodxg94TSlapMix/uZs7fezN1w3AA2KHIme/PONTwfCekRYylTeKPv45rpzIr
         oAg8ZPCiy69cLkRgVBMe9lZyj9XYSWtNqwjhjn8Oc+Qj6qB8sZoZLbC+1U7wU0I1KRgP
         1kaBCBdfhLQNROIACccATcUJUhF7R3uqmHhnVwpSsHeWQGiAnXQm4qaXdoG+CeBb6x0N
         vm64ALEKVqnWY+CulJ/vKsNSz5EriV2LXUyuZjvChsXHDc/vfsTSki7388LVWu4m2Ak+
         rjOpM+4Wud7JdunDx+SmgC1UXyqezkT1pKpg9U8w6uqLGmpcGzgkTcQd8EBSK49UAL7g
         LvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VJeRQe8CVf5j9/EEF5CDkRUhzoSsNWEdjtVzXHLXdNE=;
        b=ymXujyXLSE9nHb849zmmrHoAUgNe5A6A2J6oApkZl4nDLi38R0NJw/Cn9Qo+YhOCPt
         xnipLhuJ3gDe0v+pG4uSYf2aw3B2i/2hOtcm9Yq1cgHeS7KUf3iCRWyPyKemtgpjmOBi
         UHUHwZmcZ24RDL8hcYDuaVdYm3rgLtjYg2svO/Ogy4S1A6v4z/5GOEBybPRXNk4mS4aO
         S0WdbW78a0Awr5PS5sOc+SLMcYqOVpleMK2fCvDso1A8gIc1yKJ8k0dBwiB7lBlUKuBE
         SmWo37KSuHy9QjDqCgrCdSslKxTzrXUcOUyqscyLid/9Kd0RkPJTAsHLQWBFmSCOxyV6
         N1DA==
X-Gm-Message-State: AFqh2kqGjvFG3QT7MTfw5rh1rQQwXfAmpZQ8+zHRRBfuEVcTPfOnQ6Bm
        fS4QKNyCIB+ZU3m9xjnQuB0nbNg6hAYqL9O3RK0A5rVbMEEm6pj5bBTlHV7eE2RPNA==
X-Google-Smtp-Source: AMrXdXvMOeOwGvtfptE3fN9uKL6gpTv4fvEyNhkucu9xI3ddMBnP0cbSGbJ3sbIwc+2u+yqOuYtztJATxSYu
X-Received: by 2002:a92:c98e:0:b0:304:c91b:4a5c with SMTP id y14-20020a92c98e000000b00304c91b4a5cmr27520937iln.24.1672788717015;
        Tue, 03 Jan 2023 15:31:57 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
        by smtp-relay.gmail.com with ESMTPS id x3-20020a023403000000b0038acbf4c0c6sm2272399jae.60.2023.01.03.15.31.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Jan 2023 15:31:57 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 69299220EF;
        Tue,  3 Jan 2023 16:31:55 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
        id 58336E40433; Tue,  3 Jan 2023 16:31:25 -0700 (MST)
From:   Caleb Sander <csander@purestorage.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc:     Joern Engel <joern@purestorage.com>,
        Caleb Sander <csander@purestorage.com>,
        Alok Prasad <palok@marvell.com>
Subject: [PATCH net v3] qed: allow sleep in qed_mcp_trace_dump()
Date:   Tue,  3 Jan 2023 16:30:21 -0700
Message-Id: <20230103233021.1457646-1-csander@purestorage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221228220045.101647-1-csander@purestorage.com>
References: <20221228220045.101647-1-csander@purestorage.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, qed_mcp_cmd_and_union() delays 10us at a time in a loop
that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
may block the current thread for over 5s.
We observed thread scheduling delays over 700ms in production,
with stacktraces pointing to this code as the culprit.

qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
Add a "can sleep" parameter to qed_find_nvram_image() and
qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
called only by qed_mcp_trace_dump(), allow these functions to sleep.
I can't tell if the other caller (qed_grc_dump_mcp_hw_dump()) can sleep,
so keep b_can_sleep set to false when it calls these functions.

An example stacktrace from a custom warning we added to the kernel
showing a thread that has not scheduled despite long needing resched:
[ 2745.362925,17] ------------[ cut here ]------------
[ 2745.362941,17] WARNING: CPU: 23 PID: 5640 at arch/x86/kernel/irq.c:233 do_IRQ+0x15e/0x1a0()
[ 2745.362946,17] Thread not rescheduled for 744 ms after irq 99
[ 2745.362956,17] Modules linked in: ...
[ 2745.363339,17] CPU: 23 PID: 5640 Comm: lldpd Tainted: P           O    4.4.182+ #202104120910+6d1da174272d.61x
[ 2745.363343,17] Hardware name: FOXCONN MercuryB/Quicksilver Controller, BIOS H11P1N09 07/08/2020
[ 2745.363346,17]  0000000000000000 ffff885ec07c3ed8 ffffffff8131eb2f ffff885ec07c3f20
[ 2745.363358,17]  ffffffff81d14f64 ffff885ec07c3f10 ffffffff81072ac2 ffff88be98ed0000
[ 2745.363369,17]  0000000000000063 0000000000000174 0000000000000074 0000000000000000
[ 2745.363379,17] Call Trace:
[ 2745.363382,17]  <IRQ>  [<ffffffff8131eb2f>] dump_stack+0x8e/0xcf
[ 2745.363393,17]  [<ffffffff81072ac2>] warn_slowpath_common+0x82/0xc0
[ 2745.363398,17]  [<ffffffff81072b4c>] warn_slowpath_fmt+0x4c/0x50
[ 2745.363404,17]  [<ffffffff810d5a8e>] ? rcu_irq_exit+0xae/0xc0
[ 2745.363408,17]  [<ffffffff817c99fe>] do_IRQ+0x15e/0x1a0
[ 2745.363413,17]  [<ffffffff817c7ac9>] common_interrupt+0x89/0x89
[ 2745.363416,17]  <EOI>  [<ffffffff8132aa74>] ? delay_tsc+0x24/0x50
[ 2745.363425,17]  [<ffffffff8132aa04>] __udelay+0x34/0x40
[ 2745.363457,17]  [<ffffffffa04d45ff>] qed_mcp_cmd_and_union+0x36f/0x7d0 [qed]
[ 2745.363473,17]  [<ffffffffa04d5ced>] qed_mcp_nvm_rd_cmd+0x4d/0x90 [qed]
[ 2745.363490,17]  [<ffffffffa04e1dc7>] qed_mcp_trace_dump+0x4a7/0x630 [qed]
[ 2745.363504,17]  [<ffffffffa04e2556>] ? qed_fw_asserts_dump+0x1d6/0x1f0 [qed]
[ 2745.363520,17]  [<ffffffffa04e4ea7>] qed_dbg_mcp_trace_get_dump_buf_size+0x37/0x80 [qed]
[ 2745.363536,17]  [<ffffffffa04ea881>] qed_dbg_feature_size+0x61/0xa0 [qed]
[ 2745.363551,17]  [<ffffffffa04eb427>] qed_dbg_all_data_size+0x247/0x260 [qed]
[ 2745.363560,17]  [<ffffffffa0482c10>] qede_get_regs_len+0x30/0x40 [qede]
[ 2745.363566,17]  [<ffffffff816c9783>] ethtool_get_drvinfo+0xe3/0x190
[ 2745.363570,17]  [<ffffffff816cc152>] dev_ethtool+0x1362/0x2140
[ 2745.363575,17]  [<ffffffff8109bcc6>] ? finish_task_switch+0x76/0x260
[ 2745.363580,17]  [<ffffffff817c2116>] ? __schedule+0x3c6/0x9d0
[ 2745.363585,17]  [<ffffffff810dbd50>] ? hrtimer_start_range_ns+0x1d0/0x370
[ 2745.363589,17]  [<ffffffff816c1e5b>] ? dev_get_by_name_rcu+0x6b/0x90
[ 2745.363594,17]  [<ffffffff816de6a8>] dev_ioctl+0xe8/0x710
[ 2745.363599,17]  [<ffffffff816a58a8>] sock_do_ioctl+0x48/0x60
[ 2745.363603,17]  [<ffffffff816a5d87>] sock_ioctl+0x1c7/0x280
[ 2745.363608,17]  [<ffffffff8111f393>] ? seccomp_phase1+0x83/0x220
[ 2745.363612,17]  [<ffffffff811e3503>] do_vfs_ioctl+0x2b3/0x4e0
[ 2745.363616,17]  [<ffffffff811e3771>] SyS_ioctl+0x41/0x70
[ 2745.363619,17]  [<ffffffff817c6ffe>] entry_SYSCALL_64_fastpath+0x1e/0x79
[ 2745.363622,17] ---[ end trace f6954aa440266421 ]---

Fixes: c965db4446291 ("qed: Add support for debug data collection")
Signed-off-by: Caleb Sander <csander@purestorage.com>
Acked-by: Alok Prasad <palok@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 28 +++++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

---
v3: add stacktrace to commit message and put Fixes tag first
v2: add Acked-by and Fixes tags to commit message

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 86ecb080b153..cdcead614e9f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1830,11 +1830,12 @@ static void qed_grc_clear_all_prty(struct qed_hwfn *p_hwfn,
 /* Finds the meta data image in NVRAM */
 static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 					    struct qed_ptt *p_ptt,
 					    u32 image_type,
 					    u32 *nvram_offset_bytes,
-					    u32 *nvram_size_bytes)
+					    u32 *nvram_size_bytes,
+					    bool b_can_sleep)
 {
 	u32 ret_mcp_resp, ret_mcp_param, ret_txn_size;
 	struct mcp_file_att file_att;
 	int nvm_result;
 
@@ -1844,11 +1845,12 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 					DRV_MSG_CODE_NVM_GET_FILE_ATT,
 					image_type,
 					&ret_mcp_resp,
 					&ret_mcp_param,
 					&ret_txn_size,
-					(u32 *)&file_att, false);
+					(u32 *)&file_att,
+					b_can_sleep);
 
 	/* Check response */
 	if (nvm_result || (ret_mcp_resp & FW_MSG_CODE_MASK) !=
 	    FW_MSG_CODE_NVM_OK)
 		return DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
@@ -1871,11 +1873,13 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 
 /* Reads data from NVRAM */
 static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 				      struct qed_ptt *p_ptt,
 				      u32 nvram_offset_bytes,
-				      u32 nvram_size_bytes, u32 *ret_buf)
+				      u32 nvram_size_bytes,
+				      u32 *ret_buf,
+				      bool b_can_sleep)
 {
 	u32 ret_mcp_resp, ret_mcp_param, ret_read_size, bytes_to_copy;
 	s32 bytes_left = nvram_size_bytes;
 	u32 read_offset = 0, param = 0;
 
@@ -1897,11 +1901,11 @@ static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 		if (qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
 				       DRV_MSG_CODE_NVM_READ_NVRAM, param,
 				       &ret_mcp_resp,
 				       &ret_mcp_param, &ret_read_size,
 				       (u32 *)((u8 *)ret_buf + read_offset),
-				       false))
+				       b_can_sleep))
 			return DBG_STATUS_NVRAM_READ_FAILED;
 
 		/* Check response */
 		if ((ret_mcp_resp & FW_MSG_CODE_MASK) != FW_MSG_CODE_NVM_OK)
 			return DBG_STATUS_NVRAM_READ_FAILED;
@@ -3378,11 +3382,12 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
 	/* Read HW dump image from NVRAM */
 	status = qed_find_nvram_image(p_hwfn,
 				      p_ptt,
 				      NVM_TYPE_HW_DUMP_OUT,
 				      &hw_dump_offset_bytes,
-				      &hw_dump_size_bytes);
+				      &hw_dump_size_bytes,
+				      false);
 	if (status != DBG_STATUS_OK)
 		return 0;
 
 	hw_dump_size_dwords = BYTES_TO_DWORDS(hw_dump_size_bytes);
 
@@ -3395,11 +3400,13 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
 	/* Read MCP HW dump image into dump buffer */
 	if (dump && hw_dump_size_dwords) {
 		status = qed_nvram_read(p_hwfn,
 					p_ptt,
 					hw_dump_offset_bytes,
-					hw_dump_size_bytes, dump_buf + offset);
+					hw_dump_size_bytes,
+					dump_buf + offset,
+					false);
 		if (status != DBG_STATUS_OK) {
 			DP_NOTICE(p_hwfn,
 				  "Failed to read MCP HW Dump image from NVRAM\n");
 			return 0;
 		}
@@ -4121,11 +4128,13 @@ static enum dbg_status qed_mcp_trace_get_meta_info(struct qed_hwfn *p_hwfn,
 	    (*running_bundle_id ==
 	     DIR_ID_1) ? NVM_TYPE_MFW_TRACE1 : NVM_TYPE_MFW_TRACE2;
 	return qed_find_nvram_image(p_hwfn,
 				    p_ptt,
 				    nvram_image_type,
-				    trace_meta_offset, trace_meta_size);
+				    trace_meta_offset,
+				    trace_meta_size,
+				    true);
 }
 
 /* Reads the MCP Trace meta data from NVRAM into the specified buffer */
 static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
 					       struct qed_ptt *p_ptt,
@@ -4137,11 +4146,14 @@ static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
 	u32 signature;
 
 	/* Read meta data from NVRAM */
 	status = qed_nvram_read(p_hwfn,
 				p_ptt,
-				nvram_offset_in_bytes, size_in_bytes, buf);
+				nvram_offset_in_bytes,
+				size_in_bytes,
+				buf,
+				true);
 	if (status != DBG_STATUS_OK)
 		return status;
 
 	/* Extract and check first signature */
 	signature = qed_read_unaligned_dword(byte_buf);
-- 
2.25.1

