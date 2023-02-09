Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BB569050F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjBIKjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBIKi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:38:56 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B92712;
        Thu,  9 Feb 2023 02:38:24 -0800 (PST)
Received: from myt5-8800bd68420f.qloud-c.yandex.net (myt5-8800bd68420f.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4615:0:640:8800:bd68])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 45C3C617EC;
        Thu,  9 Feb 2023 13:38:20 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b506::1:21])
        by myt5-8800bd68420f.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Fcb1x10OXKo1-8MEQpIAN;
        Thu, 09 Feb 2023 13:38:19 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1675939099; bh=5MAby8IGd2a8tkyTVKbH79Krxxogc0EjkaQHRn2whKI=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=1OcLQ4C1QSVvOLjrAL0P/R7ObqfJIe85t52wJPiq4R3JaJQB9clK5OHnInQ2CmQPI
         qIa72Ei8XEHgC5llVJca0oF2rhZTxtgXjU4ioSL+58lynjx2hduTwloqrFYVQ3y3XD
         BCHygIPzVCxZSNStORLZrGR+SVq52uAxHeB7C1EI=
Authentication-Results: myt5-8800bd68420f.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v0] qed/qed_dev: guard against a possible division by zero
Date:   Thu,  9 Feb 2023 13:38:13 +0300
Message-Id: <20230209103813.2500486-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously we would divide total_left_rate by zero if num_vports
happened to be 1 because non_requested_count is calculated as
num_vports - req_count. Guard against this by explicitly checking for
zero when doing the division.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d61cd32ec3b6..90927f68c459 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5123,7 +5123,7 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	total_left_rate	= min_pf_rate - total_req_min_rate;
 
-	left_rate_per_vp = total_left_rate / non_requested_count;
+	left_rate_per_vp = total_left_rate / (non_requested_count ?: 1);
 	if (left_rate_per_vp <  min_pf_rate / QED_WFQ_UNIT) {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
 			   "Non WFQ configured vports rate [%d Mbps] is less than one percent of configured PF min rate[%d Mbps]\n",
-- 
2.25.1

