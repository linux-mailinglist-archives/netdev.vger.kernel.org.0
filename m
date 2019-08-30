Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27A3A365D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfH3MId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:33 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:10067
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfH3MIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT1UfJe9RQdF5rN4IdEwqnn5LGvpL0fB65NLqvD8kdDzVTN3VSriy/QGTFCxhp6MafD87jDoVJcOEb1giElJ7B8aPasVJiN8Nw0ChB1iCQPonX/eR3M00Pi9geaQuVkdz314M3pEqzPTXQs/kk5REhabuiCkLGad956f913RAhV9sAvliRCfVpip4CdfouDFa7gjqirRYYHq64sSUb+0I1Aaj2pJyJ3V1rZDD6pVssFMgHMjRCss/W0D9xpkz5vftPa4ikEP9TzJMwX7HZad3hETa+W26pWPwjYqG3AAGxHK36L+NeBcqgr6h9+qwtdH7NqPwYGxR+mPYphYXB3FBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axEqO9nGMP2IUGAFZOaxpWlDn9ahsU5A+kbMicIdusU=;
 b=izp13u7CZSeaCNC9fuSVIfYz10fkBPhJ5wPMQPRDECNmovIDJqvnCZNmzuBMeVoHvZzVLU2+jKSQ/t6YLpfl0erpbeqKTZnIkBjLmjKMTOEF9B1O9UaXG60hIhal45igON5scs5jFpZQ+JuC0p6pr9uI3COCG5rlKknF07ThUglx1wqj0lFNnqFjRqGfZKpT6ceQLKNtAq+8pfL5rmkXVHhI6JDNG5zUGxsvvGDCAkTac7FYS55EV18VmtQsFc7FJHkNBlrZ6ttxe5h5R+1yfpistmuZE3hIozFByrWtyT7Zm6H6/G4MI6PKHgV0c4ISU/maNFgvTUspNu4vr6I2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axEqO9nGMP2IUGAFZOaxpWlDn9ahsU5A+kbMicIdusU=;
 b=ymUJMiFSxL7WCS/ZW1xX9GNElACTZ/WEVP8W1EYNR6ONYVce45jo9JKzwo/TmQVKV52tXbKfIDOGi0wxekddikQ1hlZpuRjmWPdJvFyFGdadhcGHbw7zrhiqh5/HTfTMbkzl2hlBzSZHc7xRB73rzMHgcXjfFofUBDY3EC+ezkc=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:30 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:30 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 1/5] net: aquantia: fix removal of vlan 0
Thread-Topic: [PATCH net 1/5] net: aquantia: fix removal of vlan 0
Thread-Index: AQHVXyuj2WVSVBlVtkSv4N8mjQmEyw==
Date:   Fri, 30 Aug 2019 12:08:30 +0000
Message-ID: <584b48ae099a7074200037cf66058eaa872023da.1567163402.git.igor.russkikh@aquantia.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1567163402.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0012.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::22)
 To BN6PR11MB4081.namprd11.prod.outlook.com (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fd944e3-5757-41f6-a4d9-08d72d42c586
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB168419B44779D84DD5E5DA0698BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(76176011)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(11346002)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(446003)(118296001)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0nzPIVMZLseVIbRiM7bf0VFgpI20noNKXsyKeOUjqDViORyMEC9AINC+OwN/4DAQHjNw/JKYkdfYy05ToQedJXPrSJfEp+kd5xNQek+lw4XMEDxzrn3XmzM7HaL2LDWrpBHntn6PNQyiK+Gh6NyoTqorkzlPPWdCrPaAq054nG75oldTjdWkT6YqY8axQ7YhkibTpDCdGKTxbrG5zYXuNvaECfK6DrPsBNs0Fg5jvnxTWQ9206xdJdTlfxb7RiLieDxMjFLI2XDpzPXjXs/9QHVKt+Sk6fD4g6bgvEzWYgtq1EquOTlkLLABczD+1xRXguPETQthmqn6y0VWWZVTPrL+zm5vx6C9kSOmNGAM23jillFupoADzq83dmUTfU5w40FpsTOiMEdnSfwhPzZTMJS/Fx+Xc6gRV5L5ly6tkbkYnMNWR9tUVU1SioZBysD8Jn0aMOwFifsoKkHrX8RY7A==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd944e3-5757-41f6-a4d9-08d72d42c586
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:30.5639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WR23esUNdQV8lnLvIRvGdK2FmamAOXNHo+EfU27USxCAK5nJLGDv3Hzu96zoHOX22MqRPv1Xn02vBSYtKk+3Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

Due to absence of checking against the rx flow rule when vlan 0 is being
removed, the other rule could be removed instead of the rule with vlan 0

Fixes: 7975d2aff5afb ("net: aquantia: add support of rx-vlan-filter offload=
")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_filters.c
index 440690b18734..b13704544a23 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -431,7 +431,8 @@ int aq_del_fvlan_by_vlan(struct aq_nic_s *aq_nic, u16 v=
lan_id)
 		if (be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) =3D=3D vlan_id)
 			break;
 	}
-	if (rule && be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) =3D=3D vlan_id) {
+	if (rule && rule->type =3D=3D aq_rx_filter_vlan &&
+	    be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) =3D=3D vlan_id) {
 		struct ethtool_rxnfc cmd;
=20
 		cmd.fs.location =3D rule->aq_fsp.location;
--=20
2.17.1

