Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB35C29C167
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775564AbgJ0Owv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:52:51 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:43572 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1763848AbgJ0OpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:45:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 58DB441322;
        Tue, 27 Oct 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1603809904; x=
        1605624305; bh=1m8uarmjdRkDWcGuUdyHdL9iYHTwqt293cUSaWiTucs=; b=k
        RZXp/RaEK34u/S36mAglM9hDAtwB4ABCo5C4NzG3etQjLHNS2TCeBoVKxJn0KCTQ
        kZg8Gw3rYOKpIN0SnUxXeZqyfV8+rB1Z+pI6UAVSpnXN2kjxgLrJd/RxY6FRzHxv
        pp0l7AaqgIgEcSRJEN6Pns5csOXxruVdDgAKbbCS9c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rtHMC_wE91VR; Tue, 27 Oct 2020 17:45:04 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9F8DA412DF;
        Tue, 27 Oct 2020 17:45:03 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.0.215) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 27 Oct 2020 17:45:02 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH v2 0/2] add ast2400/2500 phy-handle support
Date:   Tue, 27 Oct 2020 17:49:22 +0300
Message-ID: <20201027144924.22183-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.215]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces ast2400/2500 phy-handle support with an embedded
MDIO controller. At the current moment it is not possible to set options
with this format on ast2400/2500:

mac {
	phy-handle = <&phy>;
	phy-mode = "rgmii";

	mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		phy: ethernet-phy@0 {
			compatible = "ethernet-phy-idxxxx.yyyy";
			reg = <0>;
		};
	};
};

The patch fixes it and gets possible PHYs and register them with
of_mdiobus_register.

Changes from v2:
   1. change manual phy interface type check on phy_interface_mode_is_rgmii
      function.
   2. add err_phy_connect label.
   3. split ftgmac100_destroy_mdio into ftgmac100_phy_disconnect and
      ftgmac100_destroy_mdio.
   4. remove unneeded mdio_np checks.

Changes from v1:
   1. split one patch into two.


Ivan Mikhaylov (2):
  net: ftgmac100: move phy connect out from ftgmac100_setup_mdio
  net: ftgmac100: add handling of mdio/phy nodes for ast2400/2500

 drivers/net/ethernet/faraday/ftgmac100.c | 122 +++++++++++++----------
 1 file changed, 71 insertions(+), 51 deletions(-)

-- 
2.21.1

