Return-Path: <netdev+bounces-11762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3483A7345B8
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 11:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 106AD2811D9
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 09:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B1F15BB;
	Sun, 18 Jun 2023 09:34:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1860C1386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 09:34:06 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9346C10F0
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 02:34:04 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id AonGq59X5yzHXAonGqVxjA; Sun, 18 Jun 2023 11:34:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1687080842;
	bh=aVg/k7ynCstaMz721k7lr6Az8vrDxOwyA02xIprHpec=;
	h=From:To:Cc:Subject:Date;
	b=keWNbqPt6AoeSWh7bs0Pxc+aVdWPLZihbxi3uZ+XUbPzMsUNtqINXjqOgyJ8qdvuM
	 pcK9hR088E5/XTA3d6vgBqU5slH+OcbJb8az1qqaXr3Lt5xpMn0ef9OdIypuGicH+F
	 rlFL5ugkrNZFqMAesArycjeaquu1kN4m6GgaRagFZNsnaUnbvXPSFvlB6NU3p4/BL/
	 00/Zu77MKIj3V4YBLlg3RZi/JFf9Gq8SVWHxP7cP0ruyC38+Nn8s+EfyAUTFSLBfJF
	 Aj/ic/1BOodkREUsim9RHfshFBPD6RBfZElx8JX1hU9eCDVCJEIwFYPORCIZmnEI1X
	 wyty99C5Ebpqw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Jun 2023 11:34:02 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] mctp: Reorder fields in 'struct mctp_route'
Date: Sun, 18 Jun 2023 11:33:55 +0200
Message-Id: <393ad1a5aef0aa28d839eeb3d7477da0e0eeb0b0.1687080803.git.christophe.jaillet@wanadoo.fr>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Group some variables based on their sizes to reduce hole and avoid padding.
On x86_64, this shrinks the size of 'struct mctp_route'
from 72 to 64 bytes.

It saves a few bytes of memory and is more cache-line friendly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Using pahole

Before:
======
struct mctp_route {
	mctp_eid_t                 min;                  /*     0     1 */
	mctp_eid_t                 max;                  /*     1     1 */

	/* XXX 6 bytes hole, try to pack */

	struct mctp_dev *          dev;                  /*     8     8 */
	unsigned int               mtu;                  /*    16     4 */
	unsigned char              type;                 /*    20     1 */

	/* XXX 3 bytes hole, try to pack */

	int                        (*output)(struct mctp_route *, struct sk_buff *); /*    24     8 */
	struct list_head           list;                 /*    32    16 */
	refcount_t                 refs;                 /*    48     4 */

	/* XXX 4 bytes hole, try to pack */

	struct callback_head       rcu __attribute__((__aligned__(8))); /*    56    16 */

	/* size: 72, cachelines: 2, members: 9 */
	/* sum members: 59, holes: 3, sum holes: 13 */
	/* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
	/* last cacheline: 8 bytes */
} __attribute__((__aligned__(8)));


After:
=====
struct mctp_route {
	mctp_eid_t                 min;                  /*     0     1 */
	mctp_eid_t                 max;                  /*     1     1 */
	unsigned char              type;                 /*     2     1 */

	/* XXX 1 byte hole, try to pack */

	unsigned int               mtu;                  /*     4     4 */
	struct mctp_dev *          dev;                  /*     8     8 */
	int                        (*output)(struct mctp_route *, struct sk_buff *); /*    16     8 */
	struct list_head           list;                 /*    24    16 */
	refcount_t                 refs;                 /*    40     4 */

	/* XXX 4 bytes hole, try to pack */

	struct callback_head       rcu __attribute__((__aligned__(8))); /*    48    16 */

	/* size: 64, cachelines: 1, members: 9 */
	/* sum members: 59, holes: 2, sum holes: 5 */
	/* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
} __attribute__((__aligned__(8)));
---
 include/net/mctp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 82800d521c3d..da86e106c91d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -234,9 +234,9 @@ struct mctp_flow {
 struct mctp_route {
 	mctp_eid_t		min, max;
 
-	struct mctp_dev		*dev;
-	unsigned int		mtu;
 	unsigned char		type;
+	unsigned int		mtu;
+	struct mctp_dev		*dev;
 	int			(*output)(struct mctp_route *route,
 					  struct sk_buff *skb);
 
-- 
2.34.1


