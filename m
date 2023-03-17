Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56FB6BEFB3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCQRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266CA2ED6F;
        Fri, 17 Mar 2023 10:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFFCEB82641;
        Fri, 17 Mar 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C30C433EF;
        Fri, 17 Mar 2023 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679074217;
        bh=l/oo++nd5/THbGDXNgQewvPeaT962pxyBBxTkzCqAOQ=;
        h=Date:From:To:Cc:Subject:From;
        b=FLwyozEt5oRVYycYB4oitlmYDsjagBORL5pRLaZ+bE5FH9+YFohf9QIrr+NEL4vRW
         fBYfzRBidm6cu/rRAVgBEpfz3NUEMy7Re+jIo8lGvZoZQmAiDnR1oE81bk3iid78GW
         2ZWT0Gxb13uckPWDFazaxHbeOwfcbyzPuiJh9PycqmOEnc4Nqxl2BHANRUS8tMMOkw
         Y1G9W9LTxsIcjoDGqkV2L7HNkv5NRnS6aAIhyZqmziiGjK+91im20MFRQtWT140Tc+
         3A9gj10k7B6YBpizqgs63JdlIfXk8+BRTTaMKYTBH8vtw3UtjlMoC1MDKH7uhXfIcr
         NZMSsbxKvgppA==
Date:   Fri, 17 Mar 2023 11:30:47 -0600
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
Subject: [PATCH][next] carl9170: Fix multiple -Warray-bounds warnings
Message-ID: <ZBSjx236+BTiRByf@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC (and Clang)[1] does not like having a partially allocated object,
since it cannot reason about it for bounds checking. Instead, fully
allocate struct carl9170_cmd.

Fix the following warnings Seen under GCC 13:
drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:161:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:162:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:163:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:164:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
drivers/net/wireless/ath/carl9170/cmd.c:220:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]

Link: https://github.com/KSPP/linux/issues/268
Link: godbolt.org/z/KP97sxh3T [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/carl9170/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index f2b4f537e4c1..b8ed193c0195 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -120,7 +120,7 @@ struct carl9170_cmd *carl9170_cmd_buf(struct ar9170 *ar,
 {
 	struct carl9170_cmd *tmp;
 
-	tmp = kzalloc(sizeof(struct carl9170_cmd_head) + len, GFP_ATOMIC);
+	tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
 	if (tmp) {
 		tmp->hdr.cmd = cmd;
 		tmp->hdr.len = len;
-- 
2.34.1

