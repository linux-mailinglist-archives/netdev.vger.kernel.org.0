Return-Path: <netdev+bounces-6363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F4227715F36
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AEF81C20BCA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127D319921;
	Tue, 30 May 2023 12:26:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08619174DF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:26:58 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37054E42;
	Tue, 30 May 2023 05:26:38 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 2D0D985F52;
	Tue, 30 May 2023 14:26:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685449595;
	bh=HCxUDLptga1ZY26RbeXABUOOkjpCerVJLwimbWQwyU8=;
	h=From:To:Cc:Subject:Date:From;
	b=JpfxQZ2G7jg0wSVBi2cOntG4yyCH1s2egcZzvVd5FjNL+SKgIAGoDMt0Q/redNUL9
	 +/Fc42ob9MGrQzAU71wrEuICXBHNgX0Yt7jAPXV2I99x5rJ1ZM5emKP2qmXiZIf/Jb
	 6rtL8sTbCheZglPY3ImO/bQ87hAfGA2vHG5SB7SagMAbykeTxGyGU/Gn74AW7gfc5E
	 0lMlC0S9GwXsAL5o+pj0WRXh/ocBstfHhKxjDJ/t2Mqyh0iqXsR3i2/C7nwD1mHRwx
	 nFdGwh65F37hd/qaysI15AaY9mZpW2KBCWsy8uM56uz0SbqtoI8zLVUY4myA4/mDlj
	 2ho0LTsD2R9SQ==
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>,
	Russell King <linux@armlinux.org.uk>
Cc: Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukasz Majewski <lukma@denx.de>
Subject: [RFC] net: dsa: slave: Advertise correct EEE capabilities at slave PHY setup
Date: Tue, 30 May 2023 14:26:21 +0200
Message-Id: <20230530122621.2142192-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

One can disable in device tree advertising of EEE capabilities of PHY
when 'eee-broken-100tx' property is present in DTS.

With DSA switch it also may happen that one would need to disable EEE due
to some network issues.

Corresponding switch DTS description:

 switch@0 {
	 ports {
		port@0 {
		reg = <0>;
		label = "lan1";
		phy-handle = <&switchphy0>;
		};
	}
	mdio {
		switchphy0: switchphy@0 {
		reg = <0>;
		eee-broken-100tx;
	};
	};

This patch adjusts the content of MDIO_AN_EEE_ADV in MDIO_MMD_AN "device"
so the phydev->eee_broken_modes are taken into account from the start of
the slave PHYs.

As a result the 'ethtool --show-eee lan1' shows that EEE is not supported
from the outset.

Questions:

- Is the genphy_config_eee_advert() appropriate to be used here?
  As I found this issue on 5.15 kernel, it looks like mainline now uses
  PHY features for handle EEE (but the aforementioned function is still
  present in newest mainline - v6.4-rc1).

- I've also observed strange behaviour for EEE capability register:
  Why the value in MDIO_MMD_PCS device; reg MDIO_PCS_EEE_ABLE is somewhat
  "volatile" - in a sense that when I use:
  ethtool --set-eee lan2 eee off

  It is cleared by PHY itself to 0x0 (from 0x2) and turning it on again is
  not working.

  Is this expected? Or am I missing something?



Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 net/dsa/slave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 353d8fff3166..712923c7d4e2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2247,6 +2247,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		phylink_destroy(dp->pl);
 	}
 
+	genphy_config_eee_advert(slave_dev->phydev);
 	return ret;
 }
 
-- 
2.37.3


