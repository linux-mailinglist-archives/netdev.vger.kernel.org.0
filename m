Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6C86134C2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiJaLoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiJaLoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:44:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F176CEE0D;
        Mon, 31 Oct 2022 04:44:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF72B815F3;
        Mon, 31 Oct 2022 11:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A8BC433D6;
        Mon, 31 Oct 2022 11:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216638;
        bh=ZKQMpX4qGKyQLBywqky+QWUckJGF7SXW7qUOTP5qfrs=;
        h=From:To:Cc:Subject:Date:From;
        b=in52tpEP7HlAbsUsm/FUBDmublUfP6UNxCimfAFIQtbBMo/aXKnzby5aC2qgVck8w
         +QcV2jPFnn5eivH2VvbOPHRTDvz854SAqDwKMy1WEAoZudHrkiGJh+9DiZnZfccUyk
         Rnvv5eziSyFNzZj9rBBnCGc/LelaQ8wiIwSZEuHCBQfB4v0cy2CLQ8kT3NDTiiFVcn
         QxU8VBqaAJBApB5TiB+rpY3m+b0omSCfntGtcHMIPEYuWfhZeV7f5PmZl6b/NLPx9W
         oBl42H+8kGM4s7CGVkKWrlYRGhlnttUgp433fPDJ7YPhMgpyLD01pBCzk8V7kjsyPo
         72P2ACbchICpw==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     aelior@marvell.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] qed (gcc13): use u16 for fid to be big enough
Date:   Mon, 31 Oct 2022 12:43:54 +0100
Message-Id: <20221031114354.10398-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc 13 correctly reports overflow in qed_grc_dump_addr_range():
In file included from drivers/net/ethernet/qlogic/qed/qed.h:23,
                 from drivers/net/ethernet/qlogic/qed/qed_debug.c:10:
drivers/net/ethernet/qlogic/qed/qed_debug.c: In function 'qed_grc_dump_addr_range':
include/linux/qed/qed_if.h:1217:9: error: overflow in conversion from 'int' to 'u8' {aka 'unsigned char'} changes value from '(int)vf_id << 8 | 128' to '128' [-Werror=overflow]

We do:
  u8 fid;
  ...
  fid = vf_id << 8 | 128;

Since fid is 16bit (and the stored value above too), fid should be u16,
not u8. Fix that.

Cc: Martin Liska <mliska@suse.cz>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 5250d1d1e49c..86ecb080b153 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1972,9 +1972,10 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 				   u8 split_id)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u8 port_id = 0, pf_id = 0, vf_id = 0, fid = 0;
+	u8 port_id = 0, pf_id = 0, vf_id = 0;
 	bool read_using_dmae = false;
 	u32 thresh;
+	u16 fid;
 
 	if (!dump)
 		return len;
-- 
2.38.1

