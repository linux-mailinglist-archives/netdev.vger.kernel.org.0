Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC03E175C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241031AbhHEO4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:56:16 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32980 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhHEO4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:56:15 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175EtwXZ056394;
        Thu, 5 Aug 2021 09:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628175358;
        bh=Y9s9Dxf07rGEfmpOV135yFoMO3k/L0SryHWgyobHw5M=;
        h=From:To:CC:Subject:Date;
        b=kwZG7KsT2ZRP+iWLonx/+QXZYCgSl7jgkAkVCpCAGRiO5t8ZVQ65fm/EL058765g+
         FvP/WaNxUuMRW1TMhPejFjkD6kc5GO+T7f0whckTR/OntBvL3L/RUieLzu8iV3g3Gm
         cN7GXFTL6GMQnBgFL3l76dXzXJ1yMHE7TYRsdF5Q=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175Etw5T100857
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 09:55:58 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 09:55:58 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 09:55:58 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175Etvvq006718;
        Thu, 5 Aug 2021 09:55:57 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@essensium.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/3] net: ethernet: ti: cpsw/emac: switch to use skb_put_padto()
Date:   Thu, 5 Aug 2021 17:55:52 +0300
Message-ID: <20210805145555.12182-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi 

Now frame padding in TI TI CPSW/EMAC is implemented in a bit of entangled way as
frame SKB padded in drivers (without skb->len) while frame length fixed in CPDMA.
Things became even more confusing hence CPSW switcdev driver need to perform min
TX frame length correction in switch mode [1].

To avoid further confusion, make xmit path more clear and linear, and avoid
updating CPDMA configuration interface for min TX frame length correction
(which is not CPDMA job in general) this series switches TI CPSW/EMAC
drivers to skb_put_padto() instead of skb_padto() in their xmit path, so 
skb->len also got updated properly and then removes TX frame length
fixup from CPDMA code.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210611132732.10690-1-grygorii.strashko@ti.com/

Grygorii Strashko (3):
  net: ethernet: ti: cpsw: switch to use skb_put_padto()
  net: ethernet: ti: davinci_emac: switch to use skb_put_padto()
  net: ethernet: ti: davinci_cpdma: drop frame padding

 drivers/net/ethernet/ti/cpsw.c          | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c     | 1 -
 drivers/net/ethernet/ti/davinci_cpdma.c | 5 -----
 drivers/net/ethernet/ti/davinci_cpdma.h | 1 -
 drivers/net/ethernet/ti/davinci_emac.c  | 3 +--
 5 files changed, 2 insertions(+), 10 deletions(-)

-- 
2.17.1

