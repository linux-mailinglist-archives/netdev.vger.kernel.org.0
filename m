Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB46615BFBE
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgBMNvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:51:14 -0500
Received: from smtp1.axis.com ([195.60.68.17]:9096 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730146AbgBMNvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=808; q=dns/txt; s=axis-central1;
  t=1581601874; x=1613137874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=neit+G2QPCYogCkw7kRFA35h8RIT00UOwrrcZ8NKeJ8=;
  b=A+anSbskQPmHJIfKpnWdpgCtDqK2GPU1frNH5DFNb/IlTZngP/dqLubB
   gKCytVXQ56jSiy+gC8Fe+O1dqpid3sPCXCE5udiTyVMCPTBPFMD0a4QRE
   XD2k0Y+dZUYHgLMfY4cB+GhhIBebwp2bdIU49oZbDII1fzj7lwQu1OaiR
   kiKdfG5cSGREDz16c49lbdijLndX9FSgxWMyVP+ZhDCDxXPkggdsr5Pfb
   ZpNtZ9Zd8A4uIB2tYV939mHMg/TTaMlHu7ZVksFx/oO309AD9nkmBU8bo
   rqQtkaPu7ZaJqdItiwRHHGEeAjluWDc0c6rtjV2MoTw+Pognfd8/t0Vnr
   A==;
IronPort-SDR: Ks8OVVgl/0nAL774bAsD0igivS8yQv00wUqEGS1IeyRrfLrF56WInH3aUlp2cKxaRpTpkBQrA9
 gHbvKS/F+CHlzsaa4Y4E9L9fUBocrApykGt2Xg4+MZ3WAsX48YTxnEXajKkb5nuUtGHfWEGAv4
 rEHbeIHNbri0vBtoEhRpdBjseHxmRLAO40C7nG8lPPSEAk28+tyVTd1IAO2LL4/KHKPreOJuiu
 nF96mjx6TOirrOIaxtXLtKOHu1JOeH8ZAj63YQwj1RRFwQh9aUugPTA8t4HVQx/b+6iwFnEUcP
 zsQ=
X-IronPort-AV: E=Sophos;i="5.70,436,1574118000"; 
   d="scan'208";a="5388428"
From:   <Per@axis.com>, <"Forlin <per.forlin"@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH net 1/2] net: dsa: tag_qca: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 14:50:59 +0100
Message-ID: <20200213135100.2963-2-per.forlin@axis.com>
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

