Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B5A3660
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfH3MIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:08:39 -0400
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:8016
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728358AbfH3MIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:08:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EC4MLqivFABHzkXE9keHdAQ+bKTRajiwArFRSJhup/sGtnObMd57bYWzwz9wWrIRYCD4LHQbizsCkfo2dBaT9Gs/6zXw7YGuI6jyFyO+saE5gNFtAR6XyNKx2jU5BNY8gubOFQC/2xApVdfJ2cH/5B5ShA5ccJWEqY9TeQ1pxr54zdprAvGUQ+TUgognHayv+mSJw6bC5k4GIDtPOP0AB5K+lcHFxe2uG/typ6C1Fuwq3UuVSijyFe0iDTdmXkfG2rOty8JUr++fyde5KmESGUTtAiV9xgpspqWuxYlgUA1lBzFio7TKPMFYnXR7Aq/idpzUBvQV5qCBX2SUHMcK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZlD/jxk97xLl+dh9UgnTwavabl59yOPvesBZK5i5Tc=;
 b=kQ/wo4+p/6V+civ71zplNA0LfrPlwaI+qkVksSRvIwuYbK7N1NuiEkH4R97x/ViIX9KiWsMHkbsDb1ZDel53JqOZYzLLDiFo617VVI6i1oXv1MSAZePvDS2G+5HBogX2swiqWxG1VAjJSS+dRHMFDTseEdEGccz+YSU4NtpCt3SJE3w2jkdSBr3L1RyAp697mBQXgawf2/ggMB/Wtb4+RivWSWhIsG9/KgluNT7WYHkd2Dq4XHrkIznQ4rz+TgNAxAi5/GskNB+b4tifltO6cWdLc7ukszRU+JIOQVXcYAxCdRzHSwBPXrpl9pfIq5YvQHRyoV5JHISTJiLtAtireA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZlD/jxk97xLl+dh9UgnTwavabl59yOPvesBZK5i5Tc=;
 b=qwpg8wvnIJ3g8tSBX2tLX/m9YSxm7+JNQ1z2sL0/CsUx2XugG7kM6KSDWk76artTrQ0SmsROuIHYDDbUzx+NiNgb/kLjwctJEG2VBoRcZwsbvKzAjdvA+modXTpgxXk4khbq3mRytLfBMY6zytCjUPkNa04Or8yNiPcfgk2d3NQ=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1684.namprd11.prod.outlook.com (10.173.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 30 Aug 2019 12:08:37 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 12:08:37 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 4/5] net: aquantia: linkstate irq should be oneshot
Thread-Topic: [PATCH net 4/5] net: aquantia: linkstate irq should be oneshot
Thread-Index: AQHVXyun+nL0lKBZ4UCl4Da8VwuFFA==
Date:   Fri, 30 Aug 2019 12:08:36 +0000
Message-ID: <626398de82535631a867c3e1a75815b6cbffc417.1567163402.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 9d537127-4cb8-495b-9651-08d72d42c95c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1684;
x-ms-traffictypediagnostic: BN6PR11MB1684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1684F7B380DE85560665D35098BD0@BN6PR11MB1684.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(2906002)(476003)(6916009)(76176011)(4326008)(50226002)(99286004)(6436002)(305945005)(186003)(26005)(36756003)(478600001)(316002)(6486002)(6506007)(54906003)(25786009)(8936002)(107886003)(44832011)(52116002)(2616005)(3846002)(14454004)(102836004)(386003)(86362001)(53936002)(81156014)(6116002)(5660300002)(8676002)(81166006)(7736002)(6512007)(11346002)(64756008)(66446008)(14444005)(256004)(66556008)(66476007)(66946007)(71190400001)(71200400001)(66066001)(486006)(446003)(118296001)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1684;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kxvg7RuMWwQ/whROIMQQqVBHcaKGAzM8qYbVThLgLfk73iDp8nBsvN33yb0BHyiv1lZeizfm5M8vu/yExx+0Tvm3Esmi/ECvO3FeIhTBq0YHEneDPmB1KpUGegeah2PQdZAmn7sK7qb0QkzPR5Tf23p8yAADsmQe1GDQ9539nqkrjak0HeoaKI6hgEYx/8uJd4gasFHa2mJPkl6A/I/2xOWclc/rm5V+sIIZ93Z1BaWD7Pzcjvy323kgRuNzE7tjMCDAijuO97oDyDJdBuEQTKXc64LeOMpBt0C+JFeeVqK8MlJ1wc5Ovez4FygzLCLeIaCiHnPeM/k0EdVZOzt0KgswCJbF6L/n0FqL4h5AXkQBt1dV5HncCUaCKQouWSkxVmeYWZKDHWRQvlQR1zdRJvtJ7FmfpYJBdeHGKNMpHYpnGRbMc0IfsMCF5658LhVhIIh3mJvHK2A7Z9+rOo6phQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d537127-4cb8-495b-9651-08d72d42c95c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:08:36.9342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WP0pCIsyVgwNqVNNcGTszELqcFpeNtwlYWlzKQRjDYfk0CcGEYqO/oJcNIYNVs1U5yw7Y9k6K9FiaEjTB3sUgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declaring threaded irq handler should also indicate the irq is
oneshot. It is oneshot indeed, because HW implements irq automasking
on trigger.

Not declaring this causes some kernel configurations to fail
on interface up, because request_threaded_irq returned an err code.

The issue was originally hidden on normal x86_64 configuration with
latest kernel, because depending on interrupt controller, irq driver
added ONESHOT flag on its own.

Issue was observed on older kernels (4.14) where no such logic exists.

Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Reported-by: Michael Symolkin <Michael.Symolkin@aquantia.com>
Fixes: 4c83f170b3ac ("net: aquantia: link status irq handling")
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index e1392766e21e..8f66e7817811 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -393,7 +393,7 @@ int aq_nic_start(struct aq_nic_s *self)
 						   self->aq_nic_cfg.link_irq_vec);
 			err =3D request_threaded_irq(irqvec, NULL,
 						   aq_linkstate_threaded_isr,
-						   IRQF_SHARED,
+						   IRQF_SHARED | IRQF_ONESHOT,
 						   self->ndev->name, self);
 			if (err < 0)
 				goto err_exit;
--=20
2.17.1

