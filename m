Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FCC15C07A
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgBMOhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:37:38 -0500
Received: from smtp1.axis.com ([195.60.68.17]:13346 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgBMOhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 09:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=734; q=dns/txt; s=axis-central1;
  t=1581604657; x=1613140657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=P5UsYjweBuJIbchAgUmIEB7/p2uDn89NrGYV7hbXS6o=;
  b=H8nAY/KH4Dg1V97DhzwpUOFj5ftm78itgZCR/+Pb2cCNZyhZhfglqTce
   adrXHHVNZOr4lTchvBvFX8kYREF46eQPniPFYNO7h/SrtzDE9MvMZzDQi
   ZEP+AyFzsNtG4D9ZgBpozRCWVVsAGW0tgqMzBoxLgnZPHibAnifrWPBI0
   Urx7K6v3D6dsBfEh7AiSlJr5cvITaQg1FkI7/KFZW+2+NR7Z7uKBcsqOU
   15I9BxqFWwfrdvvdaeLkDenm46jW1mdVAt2U3AhLaVNdpQUM/qsGFJz//
   15tFuVItdZNipuVJM/NbV90grZlyS9Xir8IoVOSo4cw/B/afMRq+5v+j/
   Q==;
IronPort-SDR: JWagaWtcF06hh4EEM5Ljp1d9notAD6cgCxjOhd4hvy8r+pGTb5yhHudvO62qwbf/ZM1cxZrsc+
 uAEHg9HlT7tagidowRUOTlsnPxaH/Wm5jgvY70s6b3qOrBrySSNvJa9Ai3/wfQD0dXNMVjLS1v
 HeqQcY9G908i/CnxLYicNNpHxXhlJ7Nb7cD3wMCZ/5X+Ol8jLJAkSo5K7SCdSGq0l6SNjGKW7I
 CQNtFfxcsmrCtfSJQT/zatQOgpxkRhqf4ngZ6f6iTjzGOE8pp/i3Pe4q2fciDRjIRLhR3Jku85
 V/g=
X-IronPort-AV: E=Sophos;i="5.70,437,1574118000"; 
   d="scan'208";a="5391028"
From:   Per Forlin <per.forlin@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 15:37:10 +0100
Message-ID: <20200213143710.22811-3-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200213143710.22811-1-per.forlin@axis.com>
References: <20200213143710.22811-1-per.forlin@axis.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

