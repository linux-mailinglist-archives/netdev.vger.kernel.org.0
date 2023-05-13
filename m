Return-Path: <netdev+bounces-2383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0D3701A18
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 23:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 378001C20A44
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046A279F1;
	Sat, 13 May 2023 21:42:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A222623
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 21:42:06 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807482720;
	Sat, 13 May 2023 14:42:05 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.8])
	by mail.ispras.ru (Postfix) with ESMTPSA id 9E12E44C1012;
	Sat, 13 May 2023 21:42:03 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 9E12E44C1012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1684014123;
	bh=6rJLFQzTqQuln9eGYgx3BvQDSlEIAh0h1G71nSAdqhM=;
	h=From:To:Cc:Subject:Date:From;
	b=k9KSWGlIEpOYLlMwhxUF82/VVZlhZ+BvdDYsi8ZAyB9O8IUdFKawCuVsHX/evAMBT
	 shuB4nuBRMXGU4o11FN4sppoCgMcDfm7mt553lgz2Ep0Ek6rmJnVczZtPAvQw4WcSl
	 2xp01YsVkoD7ZL6Fb+bkxHewqHBpoNKoPW9Mg9c4=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Kalle Valo <kvalo@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
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
Subject: [PATCH] wifi: ath9k: don't allow to overwrite ENDPOINT0 attributes
Date: Sun, 14 May 2023 00:41:46 +0300
Message-Id: <20230513214146.120963-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
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
 drivers/net/wireless/ath/ath9k/htc_hst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index fe62ff668f75..a15d8d80df87 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -114,7 +114,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
 
 	if (svc_rspmsg->status == HTC_SERVICE_SUCCESS) {
 		epid = svc_rspmsg->endpoint_id;
-		if (epid < 0 || epid >= ENDPOINT_MAX)
+		if (epid <= 0 || epid >= ENDPOINT_MAX)
 			return;
 
 		service_id = be16_to_cpu(svc_rspmsg->service_id);
-- 
2.34.1


