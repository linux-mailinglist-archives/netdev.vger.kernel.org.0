Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E815C079
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBMOhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:37:36 -0500
Received: from smtp1.axis.com ([195.60.68.17]:13346 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgBMOhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 09:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=766; q=dns/txt; s=axis-central1;
  t=1581604656; x=1613140656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gQ4PcXBuTs3nA7VnAfRNzRtBuwZ3e0TfEkfi5EkIwhQ=;
  b=AE1XFg/fbm8C4DefIwaQuGF93RZ0mOg3kYPVnGdPAQyZroUktyEZvEpc
   MhylXt7OuFXq28viwQ9etXvNgfRYLma02taUIJFKXHJTH17I8SIqr1+UY
   TO7BjZbk+KmvJdJ7DUpsuJ9ermb48TWE12t+ADPCTPYgK40IJDV/8L1XT
   GXkB8SQWt5OuvM0L0Y5eGjy794jGeviz8cgHsaKEVmwB2YcJgP2wlZWrY
   FFpQoShLx3dZrpMwb5gj5luHk6s9lqxTZE1hsr1ckuQvpx8D5aTYgvqjg
   FTOzWrMZ9uCTGp3ilYdwUBVfa4f0l4DP/tT4lcNkZGEqeJBWz/0XQHdzI
   Q==;
IronPort-SDR: GelEka6EyC3QqU++DUA/rrDoXu+IArIkA3pJJAf0EuGSwxb/LSnf0DMOUVcAzm4jvPVlC+6Mey
 5pIfZHQ+/v9KkbUu17E7S4S1IPPxNRmIeNJRuW0S0AuPt4idTP5xbjCMst/swAQbnn/AlDgZj7
 x5v78dc69lu7WrjVtpd5+bhQNnn8KnFLqSk5TNNYB4pmqDE7ozQHvTUan+5ATR3gVh/CeQdxFb
 K+EucxcUFcdF5SIwjh8xY+MpuEDzMBDvjpYEneW5xlKp7qTeEX9RWxkAmH7mgYpFU8/aJ1Uiur
 oEo=
X-IronPort-AV: E=Sophos;i="5.70,437,1574118000"; 
   d="scan'208";a="5391023"
From:   Per Forlin <per.forlin@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH net 1/2] net: dsa: tag_qca: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 15:37:09 +0100
Message-ID: <20200213143710.22811-2-per.forlin@axis.com>
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
 net/dsa/tag_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c8a128c9e5e0..70db7c909f74 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -33,7 +33,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u16 *phdr, hdr;
 
-	if (skb_cow_head(skb, 0) < 0)
+	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
 		return NULL;
 
 	skb_push(skb, QCA_HDR_LEN);
-- 
2.11.0

