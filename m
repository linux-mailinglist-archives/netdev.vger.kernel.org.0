Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497825FC27
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 16:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIGOeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:34:20 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58938 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgIGOb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:31:57 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVkVB057797;
        Mon, 7 Sep 2020 09:31:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489106;
        bh=tX8DK8xZjn8fqh86L7Vc1gKvxU7j7mDqVA7MKwRMSnM=;
        h=From:To:CC:Subject:Date;
        b=KVHDvHWsseW/2QRvni5kjIwubEp/e3Rs55VtSVWkoE8GsWl7waLCt8C++GL6sXahq
         11vfKE/l6teCGpkq828m5YrInsc3/iqqB65WnPHDbwQwYYraSsZ18xSgR3EC7P+j8x
         wvmNbFymuKRx7XfeXmuoKmFabp4xfNbjUMT7fuRE=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVkwC001279;
        Mon, 7 Sep 2020 09:31:46 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:46 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:46 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVjuB048383;
        Mon, 7 Sep 2020 09:31:46 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 0/9] net: ethernet: ti: ale: add static configuration 
Date:   Mon, 7 Sep 2020 17:31:34 +0300
Message-ID: <20200907143143.13735-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

As existing, as newly introduced CPSW ALE versions have differences in 
supported features and ALE table formats. Especially it's actual for the
recent AM65x/J721E/J7200 and future AM64x SoCs, which supports more
features like: auto-aging, classifiers, Link aggregation, additional HW
filtering, etc.

The existing ALE configuration interface is not practical in terms of 
adding new features and requires consumers to program a lot static
parameters. And any attempt to add new features will case endless adding
and maintaining different combination of flags and options. Because CPSW
ALE configuration is static and fixed for SoC (or set of SoC), It is
reasonable to add support for static ALE configurations inside ALE module.

This series introduces static ALE configuration table for different ALE 
variants and provides option for consumers to select required ALE
configuration by providing ALE const char *dev_id identifier (Patch 2).
And all existing driver have been switched to use new approach (Patches 3-6).

After this ALE HW auto-ageing feature can be enabled for AM65x CPSW ALE 
variant (Patch 7).

Finally, Patches 8-9 introduces tables to describe the ALE VLAN entries 
fields as the ALE VLAN entries are too much differ between different TI
CPSW ALE versions. So, handling them using flags, defines and get/set
functions are became over-complicated.

Patch 1 - is preparation patch

Changes in v2:
- fixed sparse warnings

v1:https://lore.kernel.org/patchwork/cover/1301048/

Grygorii Strashko (9):
  net: ethernet: ti: ale: add cpsw_ale_get_num_entries api
  net: ethernet: ti: ale: add static configuration
  net: ethernet: ti: cpsw: use dev_id for ale configuration
  net: netcp: ethss: use dev_id for ale configuration
  net: ethernet: ti: am65-cpsw: use dev_id for ale configuration
  net: ethernet: ti: ale: make usage of ale dev_id mandatory
  net: ethernet: ti: am65-cpsw: enable hw auto ageing
  net: ethernet: ti: ale: switch to use tables for vlan entry
    description
  net: ethernet: ti: ale: add support for multi port k3 cpsw versions

 drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  10 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c    |  16 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   1 +
 drivers/net/ethernet/ti/cpsw.c              |   6 -
 drivers/net/ethernet/ti/cpsw_ale.c          | 421 ++++++++++++++++----
 drivers/net/ethernet/ti/cpsw_ale.h          |   7 +
 drivers/net/ethernet/ti/cpsw_ethtool.c      |   3 +-
 drivers/net/ethernet/ti/cpsw_new.c          |   1 -
 drivers/net/ethernet/ti/cpsw_priv.c         |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.h         |   2 -
 drivers/net/ethernet/ti/netcp_ethss.c       |  18 +-
 11 files changed, 388 insertions(+), 99 deletions(-)

-- 
2.17.1

