Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3815BB28
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgBMJHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:07:24 -0500
Received: from smtp1.axis.com ([195.60.68.17]:50964 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgBMJHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=776; q=dns/txt; s=axis-central1;
  t=1581584844; x=1613120844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=75y8Ks7TwYURKYkJ4E8vNU86aVP+xnphUde+RTxWJZg=;
  b=oZko75TYRmX+9VI77znl1JJfFfrpHK1jKU74bguih69I9/wij8w+TkCD
   tZErjGtZ+Yp/MWcqjAD+wNudB233uBO4WJkvwJjwqMvCfNwRfygj5rQAi
   ojCSyHzop8AQKcRk+c5AMZ5EHmRonb3vbcdOKpIO2rB97clIJcpP4J3Ox
   RaBUlbUvh8eJ28uKxvo679y1DDrotu7h1dBhUOX3zkeHmbUk2YdvDszR6
   5vMpG59004vcPzXZMbRVR5d4dvDKzyk3oOB3887l8DA2pRnhQY7dQiA60
   94A5kz/8N/feQze+tkQYG0RZuOeItREo2AV87H1Y9aK1OBucDyOvrNM4j
   A==;
IronPort-SDR: 93kBofHemON/Cy+I+huCdypOtTjHuPUUM7HJjOHFs/BqchPGVbX7Gs4iqKyNCDBw/SGDe3SQY0
 Qeuc/mESav9VqPZCDo8X13TADT7hhKuiHtCxIet1WTj5WNmf1hoyow0nmftHPGWAU5PeyXYi6S
 XEbfOAbkRkjs3pzMj1IjwgelebwBs/hGeIq/Fh/TNlqrXMQhIAKH1Kzx3KwgMNWLxx5jLJA+O0
 JsrMOwWQ3W4X8BsVU6y4eXsWvrpOw86e/2UwT4XUb6x/3wOEO5s+Pq6EThVsZpcfou8GPDCOCT
 93I=
X-IronPort-AV: E=Sophos;i="5.70,436,1574118000"; 
   d="scan'208";a="5377320"
From:   <Per@axis.com>, <"Forlin <per.forlin"@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH 2/2] net: dsa: tag_ar9331: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 10:07:07 +0100
Message-ID: <20200213090707.27937-2-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200213090707.27937-1-per.forlin@axis.com>
References: <20200213090707.27937-1-per.forlin@axis.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Per Forlin <per.forlin@axis.com>

Passing tag size to skb_cow_head will make sure
there is enough headroom for the tag data.
This change does not introduce any overhead in case there
is already available headroom for tag.

Signed-off-by: Per Forlin <perfn@axis.com>
---
 net/dsa/tag_ar9331.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 466ffa92a474..55b00694cdba 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -31,7 +31,7 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 	__le16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, 0) < 0)
+	if (skb_cow_head(skb, AR9331_HDR_LEN) < 0)
 		return NULL;
 
 	phdr = skb_push(skb, AR9331_HDR_LEN);
-- 
2.11.0

