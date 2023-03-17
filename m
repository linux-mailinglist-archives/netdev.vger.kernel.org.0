Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4138E6BEFE4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCQRj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCQRjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B733CC4;
        Fri, 17 Mar 2023 10:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F05CF60B35;
        Fri, 17 Mar 2023 17:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16824C4339C;
        Fri, 17 Mar 2023 17:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679074747;
        bh=d2dbiKmY5zdyizSPGR6FY41MGap7MSDENVLqaS/yv7A=;
        h=Date:From:To:Cc:Subject:From;
        b=Tnoc0wbFnYcI8PTEOW4setBX+PUqyFAClZo4S/KpN5fAdd461DOke0bIfLY0H+lwR
         8H/6AEX3fYWWAK+91sB1j6HCKJASKKYDcuHDqdVLvUqtNPYVhFumLcp2NHNavfL0Jx
         KlRKScg4cCHoEc/82rgagqqyssu/zEZZ3pdBrwL2jmhuVjmorl30IgeIa2KLjKFviR
         t7p8SkMLSaX4G2tGhWwJ5+IeaMghtFZUqn3lM93+oibAaqBOkCHXKz9I1ebnnAKRgX
         qUzJaRKSRfKqkFC7q3i7dnj6Aa7ZoPukq052Fv+wr9krAlWcDQP+M75Fnrm7dvHeYm
         XUPM4vTcqr9Vg==
Date:   Fri, 17 Mar 2023 11:39:36 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: carl9170: Replace fake flex-array with
 flexible-array member
Message-ID: <ZBSl2M+aGIO1fnuG@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Address the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
drivers/net/wireless/ath/carl9170/tx.c:702:61: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/tx.c:701:65: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/267
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index ff4b3b50250c..e5bcc364f088 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -320,9 +320,9 @@ struct carl9170_rsp {
 		struct carl9170_u32_list	rreg_res;
 		struct carl9170_u32_list	echo;
 #ifdef __CARL9170FW__
-		struct carl9170_tx_status	tx_status[0];
+		DECLARE_FLEX_ARRAY(struct carl9170_tx_status, tx_status);
 #endif /* __CARL9170FW__ */
-		struct _carl9170_tx_status	_tx_status[0];
+		DECLARE_FLEX_ARRAY(struct _carl9170_tx_status, _tx_status);
 		struct carl9170_gpio		gpio;
 		struct carl9170_tsf_rsp		tsf;
 		struct carl9170_psm		psm;
-- 
2.34.1

