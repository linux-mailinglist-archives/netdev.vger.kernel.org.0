Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1063544652
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404371AbfFMQut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:50:49 -0400
Received: from mail-eopbgr720109.outbound.protection.outlook.com ([40.107.72.109]:60366
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730169AbfFMDwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 23:52:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=ZxtNbcauMWzBTXAV+6qA34f6owTL0BDTbjxXiK1vam30cu1xYi1+q/CR1i3SxoPxPECOTAJ4/5E+RVrgSKk43nzBKWR2MwzZ3z2shVUfDJBECq8/uAnntMNiFpGsFEnEbKeooNTxDhCRVkMscsSd7l5LpRUU6ZJs+C4yC1J8V5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq+cdw9l6d9VnSoac3CHgw+jrQd6XPnt0ZaNval5z60=;
 b=B9mHQrGzzPno4U7XgxVIrRkNUY4wWEY6x8A30A5rg21vogQsCTYMN7AXEbkV8WeLM/oXF3/rux1KF0ilNakYAFHbsSW6HNkxLBGodz0Owt7V3IxKSJ9ohdoDCV+VtpEVJ4zofRSWCbPrh10r4fpQ23z0TPMT52LCdxGKm01Z05c=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq+cdw9l6d9VnSoac3CHgw+jrQd6XPnt0ZaNval5z60=;
 b=h5uY+iPU+G17t9UnyYDDcYuApORtJ3TeORWg5/sxNMaqbrjpOB88OGpljAJFgC8IFcz7TGsFPp2/bs9jUPYQP/agA+Hz+myAoNixF05w/+7dc2JxWTuue86xYWWvpNpUaglz+6oZ9AbGeNl5v3id+mTIqgd78JB2iA8f+a06NVA=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB1049.namprd21.prod.outlook.com (2603:10b6:302:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.2; Thu, 13 Jun
 2019 03:52:27 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.002; Thu, 13 Jun 2019
 03:52:27 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next] vsock: correct removal of socket from the list
Thread-Topic: [PATCH net-next] vsock: correct removal of socket from the list
Thread-Index: AdUhmo8Nxo5lupZASBWL+cOgCNqu2w==
Date:   Thu, 13 Jun 2019 03:52:27 +0000
Message-ID: <MW2PR2101MB11162BBAEC52B232A7B1EFAFC0EF0@MW2PR2101MB1116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:2:b9f7:3762:5546:eb5f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fbcdf1a-3318-478c-a2f7-08d6efb28d7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR2101MB1049;
x-ms-traffictypediagnostic: MW2PR2101MB1049:
x-microsoft-antispam-prvs: <MW2PR2101MB10492DF9904E03832B3F21D5C0EF0@MW2PR2101MB1049.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(366004)(396003)(376002)(189003)(199004)(64756008)(66556008)(66446008)(6116002)(73956011)(66476007)(55016002)(76116006)(68736007)(86362001)(6506007)(7696005)(66946007)(52396003)(22452003)(305945005)(478600001)(14454004)(7736002)(316002)(9686003)(2501003)(8990500004)(10290500003)(46003)(186003)(486006)(6436002)(102836004)(476003)(99286004)(81156014)(81166006)(2906002)(8936002)(110136005)(33656002)(8676002)(54906003)(53936002)(4326008)(2201001)(5660300002)(107886003)(71200400001)(74316002)(256004)(10090500001)(52536014)(71190400001)(25786009)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1049;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FGzPrZhBkmbS8y2++Y+1asXnvrrx3+a1iKnMGRBHK1qBxdgpZ/cDn5tA5KdwIUDSN5gTBOYryUdf2RsOZOgxrzaw3cuITYGroiSvgmBxpshq56LGeFqPumVQINyBhv1R9hU6u3nRWbm1WR0OZnCL58XISYBwy41A28iZvtxJDstApt6EUHenT6TTVD0TAaht1sR6E/6Dily54fjtP/AHHvVgGVAlbuCSprQdf/9s7ZCPUXfwbre4HAaphbAMshfL5v7fpu+rItUEbApoaDZpCbNxehfxl+LEujYRpKaOtPheV8sJHp69RUWvFeApYg1PkAHZgm+27rqAoR0F3QWZ8csAAk2lfA30KGS9UrGeQ5DlblZCYbn2I8D7qwlgEJEeYWJoCnzhPS0WeAgmA952rJTjjA4Bozms+0C8C4Mx7Ac=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbcdf1a-3318-478c-a2f7-08d6efb28d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 03:52:27.4602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current vsock code for removal of socket from the list is both
subject to race and inefficient. It takes the lock, checks whether
the socket is in the list, drops the lock and if the socket was on the
list, deletes it from the list. This is subject to race because as soon
as the lock is dropped once it is checked for presence, that condition
cannot be relied upon for any decision. It is also inefficient because
if the socket is present in the list, it takes the lock twice.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
 net/vmw_vsock/af_vsock.c | 38 +++++++-------------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d892000..6f063ed 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -282,7 +282,8 @@ EXPORT_SYMBOL_GPL(vsock_insert_connected);
 void vsock_remove_bound(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_bound(vsk);
+	if (__vsock_in_bound_table(vsk))
+		__vsock_remove_bound(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_bound);
@@ -290,7 +291,8 @@ EXPORT_SYMBOL_GPL(vsock_remove_bound);
 void vsock_remove_connected(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_connected(vsk);
+	if (__vsock_in_connected_table(vsk))
+		__vsock_remove_connected(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
@@ -326,35 +328,10 @@ struct sock *vsock_find_connected_socket(struct socka=
ddr_vm *src,
 }
 EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
=20
-static bool vsock_in_bound_table(struct vsock_sock *vsk)
-{
-	bool ret;
-
-	spin_lock_bh(&vsock_table_lock);
-	ret =3D __vsock_in_bound_table(vsk);
-	spin_unlock_bh(&vsock_table_lock);
-
-	return ret;
-}
-
-static bool vsock_in_connected_table(struct vsock_sock *vsk)
-{
-	bool ret;
-
-	spin_lock_bh(&vsock_table_lock);
-	ret =3D __vsock_in_connected_table(vsk);
-	spin_unlock_bh(&vsock_table_lock);
-
-	return ret;
-}
-
 void vsock_remove_sock(struct vsock_sock *vsk)
 {
-	if (vsock_in_bound_table(vsk))
-		vsock_remove_bound(vsk);
-
-	if (vsock_in_connected_table(vsk))
-		vsock_remove_connected(vsk);
+	vsock_remove_bound(vsk);
+	vsock_remove_connected(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
=20
@@ -485,8 +462,7 @@ static void vsock_pending_work(struct work_struct *work=
)
 	 * incoming packets can't find this socket, and to reduce the reference
 	 * count.
 	 */
-	if (vsock_in_connected_table(vsk))
-		vsock_remove_connected(vsk);
+	vsock_remove_connected(vsk);
=20
 	sk->sk_state =3D TCP_CLOSE;
=20
--=20
2.7.4

