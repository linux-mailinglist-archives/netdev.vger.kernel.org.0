Return-Path: <netdev+bounces-11765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D25E7345C9
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 478072811C2
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFDA15D4;
	Sun, 18 Jun 2023 10:16:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027B1386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:16:49 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-29.smtpout.orange.fr [80.12.242.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E9BC
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 03:16:47 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id ApScqyYPQhQKVApScqcNqL; Sun, 18 Jun 2023 12:16:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1687083404;
	bh=DSknnbdi6ETR4gXl9xkSuTonkqso7NbmO9NcHs49YUM=;
	h=From:To:Cc:Subject:Date;
	b=oUN9wnGrAcXdub/3VYK2AdRcF/0yznYc5OEJ/3kjtVQlGrOA/H1dqj7zFj7ehR5RK
	 5bg6ZqB62JhYgTEVsuSv4iUSpSD3znp7a3L8BAFHhfZ/Gai78XX4LklQRZ15pBmYct
	 XLupCOx4xWMyzxqosNKnPHmZ+bDtMtOt4+wqG3k109/31LmqYoioF+d+oRZBLULoMp
	 jD3FbBVm6WuT6zL2Mn9B1/f7rAO6vt27wMSaVc8d39w9sw4REIyiB0zFnE9UrfB2ey
	 Dx09kEEC4DeLn9MUTX2NX1gb5+o5JYLh8xo8814zzjl8qKlMJ/IFh2PUkuCjOcl2zc
	 nhfjEZYWhhXFg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Jun 2023 12:16:44 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Paul Moore <paul@paul-moore.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH net-next] netlabel: Reorder fields in 'struct netlbl_domaddr6_map'
Date: Sun, 18 Jun 2023 12:16:41 +0200
Message-Id: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Group some variables based on their sizes to reduce hole and avoid padding.
On x86_64, this shrinks the size of 'struct netlbl_domaddr6_map'
from 72 to 64 bytes.

It saves a few bytes of memory and is more cache-line friendly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Using pahole

Before:
======
struct netlbl_dom_map {
	char *                     domain;               /*     0     8 */
	u16                        family;               /*     8     2 */

	/* XXX 6 bytes hole, try to pack */

	struct netlbl_dommap_def   def;                  /*    16    16 */
	u32                        valid;                /*    32     4 */

	/* XXX 4 bytes hole, try to pack */

	struct list_head           list;                 /*    40    16 */
	struct callback_head       rcu __attribute__((__aligned__(8))); /*    56    16 */

	/* size: 72, cachelines: 2, members: 6 */
	/* sum members: 62, holes: 2, sum holes: 10 */
	/* forced alignments: 1 */
	/* last cacheline: 8 bytes */
} __attribute__((__aligned__(8)));


After:
=====
struct netlbl_dom_map {
	char *                     domain;               /*     0     8 */
	struct netlbl_dommap_def   def;                  /*     8    16 */
	u16                        family;               /*    24     2 */

	/* XXX 2 bytes hole, try to pack */

	u32                        valid;                /*    28     4 */
	struct list_head           list;                 /*    32    16 */
	struct callback_head       rcu __attribute__((__aligned__(8))); /*    48    16 */

	/* size: 64, cachelines: 1, members: 6 */
	/* sum members: 62, holes: 1, sum holes: 2 */
	/* forced alignments: 1 */
} __attribute__((__aligned__(8)));
---
 net/netlabel/netlabel_domainhash.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_domainhash.h b/net/netlabel/netlabel_domainhash.h
index 9f80972ae39b..7eaa35fdd9bd 100644
--- a/net/netlabel/netlabel_domainhash.h
+++ b/net/netlabel/netlabel_domainhash.h
@@ -57,8 +57,8 @@ struct netlbl_domaddr6_map {
 
 struct netlbl_dom_map {
 	char *domain;
-	u16 family;
 	struct netlbl_dommap_def def;
+	u16 family;
 
 	u32 valid;
 	struct list_head list;
-- 
2.34.1


