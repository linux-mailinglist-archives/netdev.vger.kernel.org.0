Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC52D8F19
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 18:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406802AbgLMR07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 12:26:59 -0500
Received: from smtp-outgoing.laposte.net ([160.92.124.97]:41553 "EHLO
        smtp-outgoing.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406700AbgLMR06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 12:26:58 -0500
X-mail-filterd: {"version":"1.2.0","queueID":"4CvBBH6yKkz14K0g","contextId":"d8c35fa9-7994-4969-ac99-49cd97c6b334"}
Received: from outgoing-mail.laposte.net (localhost.localdomain [127.0.0.1])
        by mlpnf0109.laposte.net (SMTP Server) with ESMTP id 4CvBBH6yKkz14K0g;
        Sun, 13 Dec 2020 18:20:55 +0100 (CET)
X-mail-filterd: {"version":"1.2.0","queueID":"4CvBBH5GLBz14K0Z","contextId":"ee49e5c1-82bd-4bce-b53c-f214c10225ad"}
X-lpn-mailing: LEGIT
X-lpn-spamrating: 36
X-lpn-spamlevel: not-spam
X-lpn-spamcause: OK, (-100)(0000)gggruggvucftvghtrhhoucdtuddrgedujedrudekiedguddtudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfntefrqffuvffgpdfqfgfvpdggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeggihhntggvnhhtucfuthgvhhhlrocuoehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvtheqnecuggftrfgrthhtvghrnhepteeivdehieejtdfgledvgffhvedtveejhefftdeukeeuieduudetjeektdeuffetnecukfhppeekkedruddvuddrudegledrgeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheprhhomhhurghlugdrsggvrhhgvghrihgvpdhinhgvthepkeekrdduvddurddugeelrdegledpmhgrihhlfhhrohhmpehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvthdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvthdprhgtphhtthhopehflhhorhhirghnrdhfrghinhgvlhhlihesthgvlhgvtghomhhinhhtrdgvuhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvl
 hesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Received: from romuald.bergerie (unknown [88.121.149.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mlpnf0109.laposte.net (SMTP Server) with ESMTPSA id 4CvBBH5GLBz14K0Z;
        Sun, 13 Dec 2020 18:20:55 +0100 (CET)
Received: from radicelle.bergerie (radicelle.bergerie [192.168.124.12])
        by romuald.bergerie (Postfix) with ESMTPS id 2BBFE3DF2E7F;
        Sun, 13 Dec 2020 18:20:55 +0100 (CET)
Received: from vincent by radicelle.bergerie with local (Exim 4.94)
        (envelope-from <vincent@radicelle.bergerie>)
        id 1koV3G-0003FI-Qy; Sun, 13 Dec 2020 18:20:54 +0100
From:   =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: [PATCH] net: korina: remove busy skb free
Date:   Sun, 13 Dec 2020 18:20:52 +0100
Message-Id: <20201213172052.12433-1-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=laposte.net; s=lpn-wlmd; t=1607880058; bh=eESBoQCQ/+i1fn8FcsomlkAC++n3qYXQW+Ij9COXTmM=; h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding; b=imZcMUU05QsRJHDQAX7rB0DQ//5sx3/eS2v6smytE1Casc7nLD+Av6fZAZO4bzpMlSJqzrXiIBzj5y4+6WZ8C1t4HLtvvGtRjWEk522xQsJm8AtTGBvQfSa6Ept1aJoNGn9T8H3AFtVoi5Jk7HKQtmjTpXQBUMLnsyoosIbDvdqs/O0gZGSYI6KswF4it8ftQVco51QwUMkS+ubB8wpbbmf4SOMDKEWoKId6xXyncXBJY4DlTJ//hKWf8AXuV0cCA+cGfjAdqEfuuzMjS6wR5egP6yiugWEvoRhhkZnAjra5kba4UjqpIjVzaKaKZhBC+L2lSDaRE+dl5yd1quDeUw==;
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit() method must not attempt to free the skb to transmit
when returning NETDEV_TX_BUSY. Fix the korina_send_packet() function
accordingly.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 drivers/net/ethernet/korina.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.=
c
index bf48f0ded9c7d..9d84191de6824 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -216,7 +216,6 @@ static int korina_send_packet(struct sk_buff *skb, st=
ruct net_device *dev)
 			netif_stop_queue(dev);
 		else {
 			dev->stats.tx_dropped++;
-			dev_kfree_skb_any(skb);
 			spin_unlock_irqrestore(&lp->lock, flags);
=20
 			return NETDEV_TX_BUSY;
--=20
2.29.2

