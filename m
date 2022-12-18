Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307B2650119
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiLRQYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiLRQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:23:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72C0D2D0;
        Sun, 18 Dec 2022 08:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15426B80BD1;
        Sun, 18 Dec 2022 16:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87307C433D2;
        Sun, 18 Dec 2022 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379731;
        bh=wTFOpvF46W6o1tUTIAw7yQ3AlLHJSauNTSP6pvEe3tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t83U7MNShPVcKPkv0JPqqMyFuHPLI/4rYMn5YpC4/eA6OlG9rzxSGCy4YTrrvp5KF
         8Cvy8EYZUrmgNZACOZcPWePs2Jii9XbWebHk2kF793/tc5iYgGotKhcxZlVGR4N9hb
         F/TdvbxP+YAn12Vz3wRH19SwZJJGzGbgNn8nTP1H5+/9x96yML3sFm0ZchHOPxGfmw
         X2sjBqjjMFfRAH/56H+pYT9XFPoxCkxTjE7AVg545c+fXx85l+8nf1SSPSIdeamlX4
         K43azZka+CemIvtegTNdZGXtYPZ5HBAhUcSj/MOuxJwmN/geSNMdVaEP85fQKcszA+
         DOFEj7RGkqOLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 18/73] qed (gcc13): use u16 for fid to be big enough
Date:   Sun, 18 Dec 2022 11:06:46 -0500
Message-Id: <20221218160741.927862-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

[ Upstream commit 7d84118229bf7f7290438c85caa8e49de52d50c1 ]

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
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114354.10398-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

