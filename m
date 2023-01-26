Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E667D41A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjAZSZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjAZSZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:25:39 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B1261869;
        Thu, 26 Jan 2023 10:25:26 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id C55AB44C1003;
        Thu, 26 Jan 2023 18:25:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru C55AB44C1003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1674757521;
        bh=Afq4b2X8eBtK6SxOlqW9d62Bwf0KZ0SsOAymNkS7amw=;
        h=From:To:Cc:Subject:Date:From;
        b=kdpTNvL3PZpEagtlTlMTtFOwQbQ5HB+uXPkNZ5x+X29xL9t2yZpBXyJSIlJ7imTca
         gIO7l0btapr9pXKIe6Bi5HwqU60PseWBqrXsPbKwq5MAUbNRpIaxN5RUDaQZ4ptbzp
         TQZxFaGLQZr0s21HG4q4IUfLgwwgsVbTeEOf5VKg=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oliver Neukum <oneukum@suse.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
Subject: [PATCH] wifi: ath6kl: reduce WARN to dev_dbg() in callback
Date:   Thu, 26 Jan 2023 21:24:31 +0300
Message-Id: <20230126182431.867984-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
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

The warn is triggered on a known race condition that is correctly handled.
Using WARN() hinders automated testing. Reducing severity.

Fixes: de2070fc4aa7 ("ath6kl: Fix kernel panic on continuous driver load/unload")
Reported-and-tested-by: syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index c68848819a52..9b88d96bfe96 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -960,8 +960,8 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 	 * Thus the possibility of ar->htc_target being NULL
 	 * via ath6kl_recv_complete -> ath6kl_usb_io_comp_work.
 	 */
-	if (WARN_ON_ONCE(!target)) {
-		ath6kl_err("Target not yet initialized\n");
+	if (!target) {
+		ath6kl_dbg(ATH6KL_DBG_HTC, "Target not yet initialized\n");
 		status = -EINVAL;
 		goto free_skb;
 	}
-- 
2.34.1

