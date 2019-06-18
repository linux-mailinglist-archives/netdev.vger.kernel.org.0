Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C24A490
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfFROz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:55:28 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:47215 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbfFROz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:55:28 -0400
X-Originating-IP: 90.88.23.150
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 08E8F40002;
        Tue, 18 Jun 2019 14:55:10 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 0/4] net: mvpp2: cls: Allow steering based on vlan tag
Date:   Tue, 18 Jun 2019 16:55:15 +0200
Message-Id: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPv2 classifier can perform flow steering based on keys extracted
from the VLAN tag. This series adds support for using the vlan id and
the vlan prio as keys, using the ethtool interface.

Patch 1 is a preparatory patch that prevent false-positive matches,
using a dedicated lookup id for the RSS C2 lookup.

Patch 2 allows to separate the flows based on the header fields they
contain. The main goal is to be able to separate tagged traffic from
untagged traffic for flow steering, just as we already do for RSS.

Patch 3 solves an issue we have when extracting fields that aren't full
bytes, such as the vlan tag which is 12 bits wide, or the priority which
is 3 bits wide.

Finally, patch 4 adds support for steering based on both vlan id and
priority, extracted from the outermost tag.

Maxime Chevallier (4):
  net: mvpp2: cls: Use a dedicated lu_type for the RSS lookup
  net: mvpp2: cls: Only select applicable flows of classification
    offload
  net: mvpp2: cls: right-justify the C2 TCAM keys
  net: mvpp2: cls: Add steering based on vlan Id and priority.

 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 118 +++++++++++++-----
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  28 +++--
 2 files changed, 103 insertions(+), 43 deletions(-)

-- 
2.20.1

