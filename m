Return-Path: <netdev+bounces-9235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF767281EE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ADC42816CC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0CE13AC8;
	Thu,  8 Jun 2023 13:58:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CF212B92
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:58:40 +0000 (UTC)
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD62736;
	Thu,  8 Jun 2023 06:58:38 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.astralinux.ru (Postfix) with ESMTP id 0D0EA186917A;
	Thu,  8 Jun 2023 16:58:35 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
	by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wPWuzr6m1Cyn; Thu,  8 Jun 2023 16:58:34 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.astralinux.ru (Postfix) with ESMTP id B2C4318684B8;
	Thu,  8 Jun 2023 16:58:34 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
	by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1GAq5gwtRosd; Thu,  8 Jun 2023 16:58:34 +0300 (MSK)
Received: from localhost.localdomain (unknown [192.168.32.67])
	by mail.astralinux.ru (Postfix) with ESMTPSA id 46CE81866D57;
	Thu,  8 Jun 2023 16:58:34 +0300 (MSK)
From: Dmitry Mastykin <dmastykin@astralinux.ru>
To: paul@paul-moore.com,
	netdev@vger.kernel.org,
	linux-security-module@vger.kernel.org
Cc: Dmitry Mastykin <dmastykin@astralinux.ru>
Subject: [PATCH] netlabel: fix shift wrapping bug in netlbl_catmap_setlong()
Date: Thu,  8 Jun 2023 16:57:54 +0300
Message-Id: <20230608135754.25044-1-dmastykin@astralinux.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is a shift wrapping bug in this code on 32-bit architectures.
NETLBL_CATMAP_MAPTYPE is u64, bitmap is unsigned long.
Every second 32-bit word of catmap becomes corrupted.

Signed-off-by: Dmitry Mastykin <dmastykin@astralinux.ru>
---
 net/netlabel/netlabel_kapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 54c083003947..27511c90a26f 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -857,7 +857,8 @@ int netlbl_catmap_setlong(struct netlbl_lsm_catmap **=
catmap,
=20
 	offset -=3D iter->startbit;
 	idx =3D offset / NETLBL_CATMAP_MAPSIZE;
-	iter->bitmap[idx] |=3D bitmap << (offset % NETLBL_CATMAP_MAPSIZE);
+	iter->bitmap[idx] |=3D (NETLBL_CATMAP_MAPTYPE)bitmap
+			     << (offset % NETLBL_CATMAP_MAPSIZE);
=20
 	return 0;
 }
--=20
2.30.2


