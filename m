Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9A1DB19E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgETL0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgETL0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:26:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C829C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=To4T7GJ/8dX4D5QxO1VMN/dAh/C8VrWbO7RXDx8zglM=; b=jOedwLrOqQEPG1zgV77xHoyN/+
        g5oYWCRKGfa167AFtDiz0/pvb2IL99lyQipGBzBVyFz/MjzvpyrnVZsP3j1ioL3BJb/XLDv07tig/
        z7Mv1IN07wmDBE4HjxIDGGjvvgPd0pfSYXl+Oq48XaQdhlMOwCgBdNMg0S36oS75dDsWI54oMHnLX
        K5g2DfkV9v0FIdmHY1xrvcgmZCNWH3ag+zRR3T8fLSwdIIfup1dd+LGQojlTfazEw9q9u+6uxldVp
        KpiNQtRW64Vtx1Q7x/3xxusZPfC7H7cZ3EtL9fyCDRbUiR7a5LD88UkEXAH25hljkNAW82300Tf9f
        o8IEuzQw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59902 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jbMrs-00086c-Ny; Wed, 20 May 2020 12:26:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jbMrr-0008Jc-R7; Wed, 20 May 2020 12:26:35 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net] net: mvpp2: fix RX hashing for non-10G ports
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jbMrr-0008Jc-R7@rmk-PC.armlinux.org.uk>
Date:   Wed, 20 May 2020 12:26:35 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rxhash is enabled on any ethernet port except the first in each CP
block, traffic flow is prevented.  The analysis is below:

I've been investigating this afternoon, and what I've found, comparing
a kernel without 895586d5dc32 and with 895586d5dc32 applied is:

- The table programmed into the hardware via mvpp22_rss_fill_table()
  appears to be identical with or without the commit.

- When rxhash is enabled on eth2, mvpp2_rss_port_c2_enable() reports
  that c2.attr[0] and c2.attr[2] are written back containing:

   - with 895586d5dc32, failing:    00200000 40000000
   - without 895586d5dc32, working: 04000000 40000000

- When disabling rxhash, c2.attr[0] and c2.attr[2] are written back as:

   04000000 00000000

The second value represents the MVPP22_CLS_C2_ATTR2_RSS_EN bit, the
first value is the queue number, which comprises two fields. The high
5 bits are 24:29 and the low three are 21:23 inclusive. This comes
from:

       c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
                     MVPP22_CLS_C2_ATTR0_QLOW(ql);

So, the working case gives eth2 a queue id of 4.0, or 32 as per
port->first_rxq, and the non-working case a queue id of 0.1, or 1.
The allocation of queue IDs seems to be in mvpp2_port_probe():

        if (priv->hw_version == MVPP21)
                port->first_rxq = port->id * port->nrxqs;
        else
                port->first_rxq = port->id * priv->max_port_rxqs;

Where:

        if (priv->hw_version == MVPP21)
                priv->max_port_rxqs = 8;
        else
                priv->max_port_rxqs = 32;

Making the port 0 (eth0 / eth1) have port->first_rxq = 0, and port 1
(eth2) be 32. It seems the idea is that the first 32 queues belong to
port 0, the second 32 queues belong to port 1, etc.

mvpp2_rss_port_c2_enable() gets the queue number from it's parameter,
'ctx', which comes from mvpp22_rss_ctx(port, 0). This returns
port->rss_ctx[0].

mvpp22_rss_context_create() is responsible for allocating that, which
it does by looking for an unallocated priv->rss_tables[] pointer. This
table is shared amongst all ports on the CP silicon.

When we write the tables in mvpp22_rss_fill_table(), the RSS table
entry is defined by:

                u32 sel = MVPP22_RSS_INDEX_TABLE(rss_ctx) |
                          MVPP22_RSS_INDEX_TABLE_ENTRY(i);

where rss_ctx is the context ID (queue number) and i is the index in
the table.

If we look at what is written:

- The first table to be written has "sel" values of 00000000..0000001f,
  containing values 0..3. This appears to be for eth1. This is table 0,
  RX queue number 0.
- The second table has "sel" values of 00000100..0000011f, and appears
  to be for eth2.  These contain values 0x20..0x23. This is table 1,
  RX queue number 0.
- The third table has "sel" values of 00000200..0000021f, and appears
  to be for eth3.  These contain values 0x40..0x43. This is table 2,
  RX queue number 0.

How do queue numbers translate to the RSS table?  There is another
table - the RXQ2RSS table, indexed by the MVPP22_RSS_INDEX_QUEUE field
of MVPP22_RSS_INDEX and accessed through the MVPP22_RXQ2RSS_TABLE
register. Before 895586d5dc32, it was:

       mvpp2_write(priv, MVPP22_RSS_INDEX,
                   MVPP22_RSS_INDEX_QUEUE(port->first_rxq));
       mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE,
                   MVPP22_RSS_TABLE_POINTER(port->id));

and after:

       mvpp2_write(priv, MVPP22_RSS_INDEX, MVPP22_RSS_INDEX_QUEUE(ctx));
       mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE, MVPP22_RSS_TABLE_POINTER(ctx));

Before the commit, for eth2, that would've contained '32' for the
index and '1' for the table pointer - mapping queue 32 to table 1.
Remember that this is queue-high.queue-low of 4.0.

After the commit, we appear to map queue 1 to table 1. That again
looks fine on the face of it.

Section 9.3.1 of the A8040 manual seems indicate the reason that the
queue number is separated. queue-low seems to always come from the
classifier, whereas queue-high can be from the ingress physical port
number or the classifier depending on the MVPP2_CLS_SWFWD_PCTRL_REG.

We set the port bit in MVPP2_CLS_SWFWD_PCTRL_REG, meaning that queue-high
comes from the MVPP2_CLS_SWFWD_P2HQ_REG() register... and this seems to
be where our bug comes from.

mvpp2_cls_oversize_rxq_set() sets this up as:

        mvpp2_write(port->priv, MVPP2_CLS_SWFWD_P2HQ_REG(port->id),
                    (port->first_rxq >> MVPP2_CLS_OVERSIZE_RXQ_LOW_BITS));

        val = mvpp2_read(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG);
        val |= MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
        mvpp2_write(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG, val);

Setting the MVPP2_CLS_SWFWD_PCTRL_MASK bit means that the queue-high
for eth2 is _always_ 4, so only queues 32 through 39 inclusive are
available to eth2. Yet, we're trying to tell the classifier to set
queue-high, which will be ignored, to zero. Hence, the queue-high
field (MVPP22_CLS_C2_ATTR0_QHIGH()) from the classifier will be
ignored.

This means we end up directing traffic from eth2 not to queue 1, but
to queue 33, and then we tell it to look up queue 33 in the RSS table.
However, RSS table has not been programmed for queue 33, and so it ends
up (presumably) dropping the packets.

It seems that mvpp22_rss_context_create() doesn't take account of the
fact that the upper 5 bits of the queue ID can't actually be changed
due to the settings in mvpp2_cls_oversize_rxq_set(), _or_ it seems that
mvpp2_cls_oversize_rxq_set() has been missed in this commit. Either
way, these two functions mutually disagree with what queue number
should be used.

Looking deeper into what mvpp2_cls_oversize_rxq_set() and the MTU
validation is doing, it seems that MVPP2_CLS_SWFWD_P2HQ_REG() is used
for over-sized packets attempting to egress through this port. With
the classifier having had RSS enabled and directing eth2 traffic to
queue 1, we may still have packets appearing on queue 32 for this port.

However, the only way we may end up with over-sized packets attempting
to egress through eth2 - is if the A8040 forwards frames between its
ports. From what I can see, we don't support that feature, and the
kernel restricts the egress packet size to the MTU. In any case, if we
were to attempt to transmit an oversized packet, we have no support in
the kernel to deal with that appearing in the port's receive queue.

So, this patch attempts to solve the issue by clearing the
MVPP2_CLS_SWFWD_PCTRL_MASK() bit, allowing MVPP22_CLS_C2_ATTR0_QHIGH()
from the classifier to define the queue-high field of the queue number.

My testing seems to confirm my findings above - clearing this bit
means that if I enable rxhash on eth2, the interface can then pass
traffic, as we are now directing traffic to RX queue 1 rather than
queue 33. Traffic still seems to work with rxhash off as well.

Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 7352244c5e68..d4a4e241333d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1070,7 +1070,7 @@ void mvpp2_cls_oversize_rxq_set(struct mvpp2_port *port)
 		    (port->first_rxq >> MVPP2_CLS_OVERSIZE_RXQ_LOW_BITS));
 
 	val = mvpp2_read(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG);
-	val |= MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
+	val &= ~MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
 	mvpp2_write(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG, val);
 }
 
-- 
2.20.1

