Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB55F681051
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbjA3OCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbjA3OCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:02:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1664839CF0;
        Mon, 30 Jan 2023 06:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B3F61031;
        Mon, 30 Jan 2023 14:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF4DC433D2;
        Mon, 30 Jan 2023 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087321;
        bh=aUHe/ku59CJyZQYm3tJm3BPQl1OqQXpECyjv8TUP338=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIbnsMlyR/6YDlxxmjI5FfUDPNV+gmD/SfSs+li+gj+2lSfQk78RwFlyOCRNwu2Jo
         DqtSaJM4KfHdrNwBFClJnBcQBwWOZWqqra4ClYPDCjvUJBMJDdF145CkEkCfsbcz3m
         ClTvwDbxQHbHcmEsEu6mgJXDiuCvh0s9FBYKSxtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <Niklas.Cassel@wdc.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/313] bnxt: Do not read past the end of test names
Date:   Mon, 30 Jan 2023 14:49:34 +0100
Message-Id: <20230130134343.125552398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d3e599c090fc6977331150c5f0a69ab8ce87da21 ]

Test names were being concatenated based on a offset beyond the end of
the first name, which tripped the buffer overflow detection logic:

 detected buffer overflow in strnlen
 [...]
 Call Trace:
 bnxt_ethtool_init.cold+0x18/0x18

Refactor struct hwrm_selftest_qlist_output to use an actual array,
and adjust the concatenation to use snprintf() rather than a series of
strncat() calls.

Reported-by: Niklas Cassel <Niklas.Cassel@wdc.com>
Link: https://lore.kernel.org/lkml/Y8F%2F1w1AZTvLglFX@x1-carbon/
Tested-by: Niklas Cassel <Niklas.Cassel@wdc.com>
Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 13 ++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     |  9 +--------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8cad15c458b3..703fc163235f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3865,7 +3865,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		test_info->timeout = HWRM_CMD_TIMEOUT;
 	for (i = 0; i < bp->num_tests; i++) {
 		char *str = test_info->string[i];
-		char *fw_str = resp->test0_name + i * 32;
+		char *fw_str = resp->test_name[i];
 
 		if (i == BNXT_MACLPBK_TEST_IDX) {
 			strcpy(str, "Mac loopback test (offline)");
@@ -3876,14 +3876,9 @@ void bnxt_ethtool_init(struct bnxt *bp)
 		} else if (i == BNXT_IRQ_TEST_IDX) {
 			strcpy(str, "Interrupt_test (offline)");
 		} else {
-			strscpy(str, fw_str, ETH_GSTRING_LEN);
-			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
-			if (test_info->offline_mask & (1 << i))
-				strncat(str, " (offline)",
-					ETH_GSTRING_LEN - strlen(str));
-			else
-				strncat(str, " (online)",
-					ETH_GSTRING_LEN - strlen(str));
+			snprintf(str, ETH_GSTRING_LEN, "%s test (%s)",
+				 fw_str, test_info->offline_mask & (1 << i) ?
+					"offline" : "online");
 		}
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index b753032a1047..fb78fc38530d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -10099,14 +10099,7 @@ struct hwrm_selftest_qlist_output {
 	u8	unused_0;
 	__le16	test_timeout;
 	u8	unused_1[2];
-	char	test0_name[32];
-	char	test1_name[32];
-	char	test2_name[32];
-	char	test3_name[32];
-	char	test4_name[32];
-	char	test5_name[32];
-	char	test6_name[32];
-	char	test7_name[32];
+	char	test_name[8][32];
 	u8	eyescope_target_BER_support;
 	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORTED  0x0UL
 	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORTED  0x1UL
-- 
2.39.0



