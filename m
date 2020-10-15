Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663D028F295
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgJOMpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:45:22 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:57694 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727348AbgJOMpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 08:45:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 101B241390;
        Thu, 15 Oct 2020 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1602765916; x=
        1604580317; bh=+7Dr+pURlSJhI4aulCo3AkEHIH1l+HVxkNQNAd53gtQ=; b=b
        mcqledmAarqfxoItBwNvTFiPVSodCdeOjLITkYBirTlgSovjC8SomwkirbVoXfO6
        Rvbh+0O7hBPGMIrAvSTQCYMig2g8aq2cp0jTWgC+lPjNVLsNvHdhzJ7QyuhnEwFe
        vCr0cAATttkcc9+paeQ5BOdb2RixrvO/gdCswiL5lc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dmC_QFkmc8_T; Thu, 15 Oct 2020 15:45:16 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2969A41397;
        Thu, 15 Oct 2020 15:45:11 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.2.186) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 15 Oct 2020 15:45:10 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <openbmc@lists.ozlabs.org>
Subject: [PATCH v1 0/2] add ast2400/2500 phy-handle support
Date:   Thu, 15 Oct 2020 15:49:15 +0300
Message-ID: <20201015124917.8168-1-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.2.186]
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

Ivan Mikhaylov (2):
  net: ftgmac100: move phy connect out from ftgmac100_setup_mdio
  net: ftgmac100: add handling of mdio/phy nodes for ast2400/2500

 drivers/net/ethernet/faraday/ftgmac100.c | 114 ++++++++++++++---------
 1 file changed, 69 insertions(+), 45 deletions(-)

-- 
2.21.1

