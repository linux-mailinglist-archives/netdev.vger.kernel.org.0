Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B48615BFBF
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgBMNvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:51:15 -0500
Received: from smtp1.axis.com ([195.60.68.17]:9096 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730149AbgBMNvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:51:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=776; q=dns/txt; s=axis-central1;
  t=1581601875; x=1613137875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=75y8Ks7TwYURKYkJ4E8vNU86aVP+xnphUde+RTxWJZg=;
  b=DDStSIdj6e1nUXGqCn+CyIc6p69AHT2qX2c92O5B5eNJJoe+PtJXp6Jy
   mG8Tesg26+pewvb1tgrmNK1rZ8OPjw+TLwFL2NmhNddd7/n3hAII6SGGF
   OTx0AxszPsEGVvU7x2I45IfI2vUF9Uck748EyDoh48/Wws1CFjHWaQLp5
   b4HBufx4+9dz54wuXlhLDhXkV9YoB0AWEVacy1zEW5D1n6lbFu47YKGMJ
   flgIF9nYb2Y7SDx6hQllUHTWYEiGqLhKTz1FsgtrQlKvabkQ3C8p7HG9N
   jc7Hrsw70PBL7gLIMhBKO8vBVLJn8hxJeRfzVfnU6XgmpVoA2YDsT9eIg
   Q==;
IronPort-SDR: akQya4ioOwRYWAYyTWmXK5qlu0BID/t9qmZKBRYUL6Va2gqo8uEnOQ5aIo+YX+rEvcDWKqrsfp
 20+9aPZU87Hx4+x3jsCOah6omQCotU6r+si/kV2jMVH/YK9HEH2VfhfwZVf6YP6AdarePvIhd2
 tZQOLH7G1u2CQ6Zim2KAunCfsfzYY2hdAdp2Ml2ja54dO8WvBeBMfcYVYJ67waJTVQpkmOFYHa
 /RRYtpHRxnODY+Dy3E0KMjO4c+lHQ73ys4djexQsuantYZ+JkvcqDgLXY29VGOX6wG47jZdnI1
 HRo=
X-IronPort-AV: E=Sophos;i="5.70,436,1574118000"; 
   d="scan'208";a="5388430"
From:   <Per@axis.com>, <"Forlin <per.forlin"@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 14:51:00 +0100
Message-ID: <20200213135100.2963-3-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200213135100.2963-1-per.forlin@axis.com>
References: <20200213135100.2963-1-per.forlin@axis.com>
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

