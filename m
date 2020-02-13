Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766F515BB27
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgBMJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:07:20 -0500
Received: from smtp2.axis.com ([195.60.68.18]:43606 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgBMJHU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=808; q=dns/txt; s=axis-central1;
  t=1581584840; x=1613120840;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=neit+G2QPCYogCkw7kRFA35h8RIT00UOwrrcZ8NKeJ8=;
  b=oxzlo9mYrJIyM9cEz1rMLuR4UsMa1g4Hq8RYN7n5lRNDiCeQC8c2lZ4y
   7qn047ZU+ELsXRMZXJ+jIIFAcY8v6oj56CIE0YFRgmwslq/rjOUSW+wt0
   sI4eRfr8nyqb72rtYvh0EXaeKrd7+DCxLpu1LCagXyjt8XpBvh11V+6dJ
   8ku5X2qp9FiSuSyBGN0Agd8nSEtbiCep0ByFXgnIydxJrwWd6CmRGe+eO
   0XoRpKT7Rq8k1SdOOmNXgbjzdmzy08DSwUbd7Ya1lB5sZinxFD+PJwIsU
   +U9aidXMXEieX4oWtl0/AH6mm65YNeRmGUrfBv0PYnbid3h2qeoSlZH+L
   w==;
IronPort-SDR: WFI5lTpzgaW8v0GcKX6WnnPMWhhUhUeR82fBLLfJuxXkl/yoKXZ7FEIQkqqUACbloVr9K9ZIba
 qSl6/eeJ8beBkhdF6RBlDU5RiQF20M49rBn96G1eXHlzaOuk1F6GMgfLPU3Kioiz7sg6drvntO
 26j+om1GsEF1342TluYzPRaFCeTQBoQaH1xEWw9vwL2Q7ZOGZ4JZXRHJQzwCcnHRESK3bUf1Q4
 J+ML+maTAfNdJirYgyLb2dA/0KbXM1PPJ8Rc70MdaUf9uuOvgiEWoDAvYzeLQrZmBDFBFb+9O1
 EC4=
X-IronPort-AV: E=Sophos;i="5.70,436,1574118000"; 
   d="scan'208";a="5231234"
From:   <Per@axis.com>, <"Forlin <per.forlin"@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>, Per Forlin <perfn@axis.com>
Subject: [PATCH 1/2] net: dsa: tag_qca: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 10:07:06 +0100
Message-ID: <20200213090707.27937-1-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
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

