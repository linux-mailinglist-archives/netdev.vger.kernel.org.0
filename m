Return-Path: <netdev+bounces-4165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E6670B6F6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7A21C209F9
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D42BBA4B;
	Mon, 22 May 2023 07:44:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9EBA40
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:44:59 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060F2B0;
	Mon, 22 May 2023 00:44:58 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id AD5295FD57;
	Mon, 22 May 2023 10:44:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684741495;
	bh=Lcii1bQY+QJwpWB+RMSKu82Ek54JP6VHZpwuHhErzzg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=i4G+Rrrt8FjyGOQCUGkcbP/uLAllSTwiqRcxvCBd+AEUplaO/lK78vVC+rYo2n2dg
	 6CrJTQTnWmiBC2R5qp9XHHLBF+66RXNEtTJ+WpChSoU8ZgqL16OD0QCWv6ZKlxIePt
	 moh9Dglj70wLhzMyeUKIhY1loWO0U2fhzJBFjkP4JhMl3rPqMuXJJS37WPyYlE1EzK
	 P+RcV8M9PyZaFgqhMPwV2PQFBOI6tThFm819ly79cLBn3kQ6SsVUcoUqMihPtCR1V3
	 2v6/YdVS+bStijZuOPRP3+7zzCtyMNO1WtUH/5LdZdn9BZIYJnooy1wtYip/wJRbr1
	 dRbf559Dj2Qbw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 10:44:55 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v3 13/17] net/sock: enable setting SO_ZEROCOPY for PF_VSOCK
Date: Mon, 22 May 2023 10:39:46 +0300
Message-ID: <20230522073950.3574171-14-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PF_VSOCK supports MSG_ZEROCOPY transmission, so SO_ZEROCOPY could
be enabled. PF_VSOCK implementation is a little bit special comparing to
PF_INET - MSG_ZEROCOPY support depends on transport layer of PF_VSOCK,
but here we can't "ask" its transport, so setting of this option is
always allowed, but if some transport doesn't support zerocopy tx, send
callback of PF_VSOCK will return -EOPNOTSUPP.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/core/sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..d558e541e6d7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1452,9 +1452,11 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
 				ret = -EOPNOTSUPP;
-		} else if (sk->sk_family != PF_RDS) {
+		} else if (sk->sk_family != PF_RDS &&
+			   sk->sk_family != PF_VSOCK) {
 			ret = -EOPNOTSUPP;
 		}
+
 		if (!ret) {
 			if (val < 0 || val > 1)
 				ret = -EINVAL;
-- 
2.25.1


