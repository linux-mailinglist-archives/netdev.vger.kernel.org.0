Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB646F9B1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfD3NOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:14:39 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50035 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfD3NOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:14:39 -0400
X-Originating-IP: 90.88.149.145
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2F8581BF20C;
        Tue, 30 Apr 2019 13:14:34 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/4] net: mvpp2: cls: Add classification
Date:   Tue, 30 Apr 2019 15:14:25 +0200
Message-Id: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

This series is a rework of the previously standalone patch adding
classification support for mvpp2 :

https://lore.kernel.org/netdev/20190423075031.26074-1-maxime.chevallier@bootlin.com/

This patch has been reworked according to Saeed's review, to make sure
that the location of the rule is always respected and serves as a way to
prioritize rules between each other. This the 3rd iteration of this
submission, but since it's now a series, I reset the revision numbering.

This series implements that in a limited configuration for now, since we
limit the total number of rules per port to 4.

The main factors for this limitation are that :
 - We share the classification tables between all ports (4 max, although
   one is only used for internal loopback), hence we have to perform a
   logical separation between rules, which is done today by dedicated
   ranges for each port in each table

 - The "Flow table", which dictates which lookups operations are
   performed for an ingress packet, in subdivided into 22 "sub flows",
   each corresponding to a traffic type based on the L3 proto, L4
   proto, the presence or not of a VLAN tag and the L3 fragmentation.

   This makes so that when adding a rule, it has to be added into each
   of these subflows, introducing duplications of entries and limiting
   our max number of entries.

These limitations can be overcomed in several ways, but for readability
sake, I'd rather submit basic classification offload support for now,
and improve it gradually.

This series also adds a small cosmetic cleanup patch (1), and also adds
support for the "Drop" action compared to the first submission of this
feature. It is simple enough to be added with this basic support.

Compared to the first submissions, the NETIF_F_NTUPLE flag was also
removed, following Saeed's comment.

Thanks,

Maxime

Maxime Chevallier (4):
  net: mvpp2: cls: Remove extra whitespace in mvpp2_cls_flow_write
  net: mvpp2: cls: Use a bitfield to represent the flow_type
  net: mvpp2: cls: Add Classification offload support
  net: mvpp2: cls: Allow dropping packets with classification offload

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  42 ++
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 497 +++++++++++++++---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  70 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  20 +-
 4 files changed, 545 insertions(+), 84 deletions(-)

-- 
2.20.1

