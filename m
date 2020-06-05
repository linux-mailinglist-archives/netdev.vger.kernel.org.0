Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADDB1EF87C
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgFENBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 09:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgFENBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 09:01:08 -0400
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Jun 2020 06:01:08 PDT
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19614C08C5C2;
        Fri,  5 Jun 2020 06:01:08 -0700 (PDT)
Received: from mxback29j.mail.yandex.net (mxback29j.mail.yandex.net [IPv6:2a02:6b8:0:1619::229])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 415BB50E1CF8;
        Fri,  5 Jun 2020 15:53:53 +0300 (MSK)
Received: from myt6-016ca1315a73.qloud-c.yandex.net (myt6-016ca1315a73.qloud-c.yandex.net [2a02:6b8:c12:4e0e:0:640:16c:a131])
        by mxback29j.mail.yandex.net (mxback/Yandex) with ESMTP id G4rje8wOp6-rqX4HNSC;
        Fri, 05 Jun 2020 15:53:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1591361633;
        bh=VJMA/iFx5qnj+SiqbTodaIRBgsoZ8cL9lhU50Jcr54A=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=da8gJKvqe1CpJ+nZoMXtJZlrOVzIL76aHmeBAuCFamEm558vlSBb7rh9nz9Hg6eHj
         XA4BXtjgt93F8FC+z24AHVayoNqV5xJB2QVLvqcUc7ukeJhTafJGp9WAqRCY37AHvh
         fFRazvzKGqdz+foc/fqK6/OM9PH5ifm2VJW3HxFs=
Authentication-Results: mxback29j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-016ca1315a73.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id Xi2KixYWAG-rpXaOZPu;
        Fri, 05 Jun 2020 15:53:52 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Alexander Lobakin <bloodyreaper@yandex.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net] net: ethernet: mvneta: fix MVNETA_SKB_HEADROOM alignment
Date:   Fri,  5 Jun 2020 15:53:24 +0300
Message-Id: <20200605125324.52474-1-bloodyreaper@yandex.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ca23cb0bc50f ("mvneta: MVNETA_SKB_HEADROOM set last 3 bits to zero")
added headroom alignment check against 8.
Hovewer (if we imagine that NET_SKB_PAD or XDP_PACKET_HEADROOM is not
aligned to cacheline size), it actually aligns headroom down, while
skb/xdp_buff headroom should be *at least* equal to one of the values
(depending on XDP prog presence).
So, fix the check to align the value up. This satisfies both
hardware/driver and network stack requirements.

Fixes: ca23cb0bc50f ("mvneta: MVNETA_SKB_HEADROOM set last 3 bits to zero")
Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 011cd26953d9..4cc9abd61c43 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -325,7 +325,7 @@
 	      cache_line_size())
 
 /* Driver assumes that the last 3 bits are 0 */
-#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) & ~0x7)
+#define MVNETA_SKB_HEADROOM	ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
-- 
2.27.0

