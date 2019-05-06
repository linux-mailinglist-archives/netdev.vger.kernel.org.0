Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E948914579
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 09:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEFHmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 03:42:04 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:51185 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfEFHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 03:42:04 -0400
X-Originating-IP: 90.88.149.145
Received: from bootlin.com (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2A5101BF215;
        Mon,  6 May 2019 07:42:01 +0000 (UTC)
Date:   Mon, 6 May 2019 09:42:00 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: mvpp2: cls: fix less than zero check on a
 u32 variable
Message-ID: <20190506094200.580ddaf2@bootlin.com>
In-Reply-To: <20190505213814.4220-1-colin.king@canonical.com>
References: <20190505213814.4220-1-colin.king@canonical.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Sun,  5 May 2019 22:38:14 +0100
Colin King <colin.king@canonical.com> wrote:

>From: Colin Ian King <colin.king@canonical.com>
>
>The signed return from the call to mvpp2_cls_c2_port_flow_index is being
>assigned to the u32 variable c2.index and then checked for a negative
>error condition which is always going to be false. Fix this by assigning
>the return to the int variable index and checking this instead.
>
>Addresses-Coverity: ("Unsigned compared against 0")
>Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
>index 4989fb13244f..c10bc257f571 100644
>--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
>+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
>@@ -1029,12 +1029,14 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
> 	struct flow_action_entry *act;
> 	struct mvpp2_cls_c2_entry c2;
> 	u8 qh, ql, pmap;
>+	int index;
> 
> 	memset(&c2, 0, sizeof(c2));
> 
>-	c2.index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
>-	if (c2.index < 0)
>+	index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
>+	if (index < 0)
> 		return -EINVAL;
>+	c2.index = index;
> 
> 	act = &rule->flow->action.entries[0];
> 

Thanks for the fix, my bad.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Maxime
