Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F76B2E61
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCIUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCIUQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:16:10 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCC6FAF9C;
        Thu,  9 Mar 2023 12:16:08 -0800 (PST)
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2905:0:640:e5fe:0])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 1F3EE5FD5C;
        Thu,  9 Mar 2023 23:16:06 +0300 (MSK)
Received: from d-tatianin-nix.HomeLAN (unknown [2a02:6b8:b081:1322::1:30])
        by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 1Gk9Q60Ok4Y0-ZjrGU6vb;
        Thu, 09 Mar 2023 23:16:05 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1678392965; bh=kwm3/X3e/zWeKdKBLPGDNnyCb1VfhAK7ntUrxenp6P0=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=hJtkKJBxWwOy79QHSGuNpg5Nmx/GIb9rqJylKLPR5svqeaZJi1HuKivDJYNKBxsMF
         r4c19f6gugLNmtMd1UXu6GBbEuDmdE3kJ7LdJG6kEOj2supg9TeRL8WuB8YkyvXf9r
         t4acKwFSt61J17RENlJ0OASaVVd/mH8kTh3r311c=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2] qed/qed_dev: guard against a possible division by zero
Date:   Thu,  9 Mar 2023 23:15:56 +0300
Message-Id: <20230309201556.191392-1-d-tatianin@yandex-team.ru>
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
num_vports - req_count. Guard against this by validating num_vports at
the beginning and returning an error otherwise.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Changes since v1:
- Don't break DP_NOTICE into multiple lines
- Add a reviewed-by tag
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d61cd32ec3b6..86a93cac2647 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5083,6 +5083,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
-- 
2.25.1

