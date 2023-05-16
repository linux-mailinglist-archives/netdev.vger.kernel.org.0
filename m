Return-Path: <netdev+bounces-3026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B324870517C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B3D71C20E61
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B80128C15;
	Tue, 16 May 2023 15:04:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E29A34CEC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:04:43 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA35B80;
	Tue, 16 May 2023 08:04:40 -0700 (PDT)
Received: from fpc.. (unknown [46.242.14.200])
	by mail.ispras.ru (Postfix) with ESMTPSA id 120DC40737D7;
	Tue, 16 May 2023 15:04:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 120DC40737D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1684249477;
	bh=sZ8kkT2TGWjUcst/Jgp8zQv5admnxY/XlfH+0rjhVWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZW38xBv9YAKyWUNlJmGaX05OwbSKR+p9YK4imq8ULOPNbmusdvStSlQcMMaSgtoB
	 V9NsgMKaJyiAsyZX2d43eIs0ZzsdGjAPeLeQXiWb32r68tRCbwyTs/cAuukSD0Dm71
	 4C9zKY5MKF8FMSuY86+egeIDyCdQVn9Xw451cvo8=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Takeshi Misawa <jeliantsurux@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org,
	syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: ath9k: don't allow to overwrite ENDPOINT0 attributes
Date: Tue, 16 May 2023 18:04:27 +0300
Message-Id: <20230516150427.79469-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <87r0rhdc46.fsf@toke.dk>
References: 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A bad USB device is able to construct a service connection response
message with target endpoint being ENDPOINT0 which is reserved for
HTC_CTRL_RSVD_SVC and should not be modified to be used for any other
services.

Reject such service connection responses.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: per Toke's remark, use ENDPOINT0 macro and give a comment explaining
why it should be checked.

 drivers/net/wireless/ath/ath9k/htc_hst.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index fe62ff668f75..99667aba289d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -114,7 +114,13 @@ static void htc_process_conn_rsp(struct htc_target *target,
 
 	if (svc_rspmsg->status == HTC_SERVICE_SUCCESS) {
 		epid = svc_rspmsg->endpoint_id;
-		if (epid < 0 || epid >= ENDPOINT_MAX)
+
+		/* Check that the received epid for the endpoint to attach
+		 * a new service is valid. ENDPOINT0 can't be used here as it
+		 * is already reserved for HTC_CTRL_RSVD_SVC service and thus
+		 * should not be modified.
+		 */
+		if (epid <= ENDPOINT0 || epid >= ENDPOINT_MAX)
 			return;
 
 		service_id = be16_to_cpu(svc_rspmsg->service_id);
-- 
2.34.1


