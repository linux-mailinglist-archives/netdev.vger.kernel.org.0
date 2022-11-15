Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7084062AF80
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiKOXiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiKOXiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:38:03 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2125.outbound.protection.outlook.com [40.107.114.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD452A27C;
        Tue, 15 Nov 2022 15:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmM71mr1WqBYTq+RwdWEYrEShyEZfNO57dLQ8Uj/1ZXkDgmKfEzoiHQ1QaVLjdtM/WM147XCv8vZvr+Hj5RdAgJLuQKqQWXMFdLDlMi77+PQodK0VECQ2+RHWwl1CZVVfpVPO9YCoFDp6kw0tmKOX1wZ+NbyRZ2RaQLzQUyGWFOc62Ff5S/ODo8jzprJ/7tj4zfIO8dREaLJsMfhss3/QUTGB0Vi72hU3SFV6hVc/Csxh/s16wrinp4QUvmZjUi7zo++kNujSDpUVP/6bbKcnPGS/Oa0+k9XUe0RvaY5x79I/6GecoyiUeWtFueJnpIZm+mbxWNBoLDL3XZz0qwOMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeINqwveHGAbRRt+hFZTVjobusqYaud3BE+kS2G9coo=;
 b=DXINmqtNV9dGkhejDjMtG18HpE6dfQdcuA5Uov1Hc+l//trq+deLZjuZ49oBQmWcPPihSfXgXkKzcbC5OOQpaSIb9lTJUUXWMypXHlAaZDro9QppmCd8/L6jHUqUoONduzsDTfJxukqLh5vS8Z9jo+a3oQj3BAL5XyzgTVPyBA9tfTT5ja6xh1hQTf0B9iAkmfW7ZPo70V8JUmvy+xOchCqWv1HHiUCXsXVs2qzuyNlns9/NdyQa7Mv5m0QSal+wh5w3OTJ4kaDR300l3HJMO6wTBp9tY5zbC7qqXnsVuHHc8U4QQuwT3QRahnkFIw42gwxCuc3xVqrsyiUMBxveSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeINqwveHGAbRRt+hFZTVjobusqYaud3BE+kS2G9coo=;
 b=Sn/zvGAdp5eY95CcLTxHY/o82ub5a8JXtBP1aoyP4x5x5Lb6aVRzyxh+cEotuLLZkNOcKlkYZfB7K8eqSEnCvq8YkktKdCzNQUsVKvYwUS/xNmIBbjot2qtPjxpZssw+D/WEbtEW6MPS939TIXSmQiJodTNKW17qqA/GVFHflJM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB9386.jpnprd01.prod.outlook.com
 (2603:1096:400:196::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 23:37:59 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%9]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 23:37:59 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Dan Carpenter <error27@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ethernet: renesas: Fix return type in
 rswitch_etha_wait_link_verification()
Thread-Topic: [PATCH net-next] net: ethernet: renesas: Fix return type in
 rswitch_etha_wait_link_verification()
Thread-Index: AQHY+POVNLfovYqvYUSZM0oa3sYmQa5ApGSw
Date:   Tue, 15 Nov 2022 23:37:59 +0000
Message-ID: <TYBPR01MB5341B3E1D3FBE3E3587BB2C7D8049@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <Y3OPo6AOL6PTvXFU@kili>
In-Reply-To: <Y3OPo6AOL6PTvXFU@kili>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB9386:EE_
x-ms-office365-filtering-correlation-id: 87102805-d127-4a7f-b3fe-08dac7626e39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FunfoatX8VpuW4VUPTbFHubo2tHKET5/21PesSQ2RIhjbxkN1wYn5+JZYFp6Yq9z4ywQubtGHw9LvweDOd6Y9XmrZHSxwNogZvjcSXy90iZStmnCyBySpf6obg/GjG7jGb3DJO2FUFOjHBA4FCAnQD0w0EzWpShc50shzp9HcZ54c6uWEO5VnIhqJLfLUnWw3r5ruiIC+FYGUyTqGonrKEgBIvP77+ZjV19yiwzUr03C0zeVNVkBtK7OfwzrKObQ3m4pFj9QfcrExNUpmqr0YSPSROCYuMpWFI19JM1vq7JIu1g1RsmzYAmQtAPQM+dpcVqYxqaIJmO/GqavKJtbZYezkA3ad1bNqy7jcg/NNL/cVyV5hjiqjrXXXMJ0MFkHx0OnDrSsmFOD/GLA0o1fQruqgdaOM3iR9UOhVM9yEwgT3gPkDEqLXaYTisr2diiALHWs/oy2ZdKMnsGw2cNRNpzr5vO8uZsulK3C6cCqJEteFXlR8IRUT086zc1TVN/FvfHuxz4t/Xrwi1o8uzydLr0Izo6TWHNkc2T410nIT107rGZZlvtRFJmePgDQH7GC5TZZgNSjap3uUyRd3+sDhhyfM9aqAQ9WKHYKYGoUI20XTDYWsmvmel5XM3QAY4jwUtb/KYQ724iQosPbZ4hUjSURTUl2GVwjM9ZaT35On5DhTqEoI0sjfKXkOcfk/NRv0ERBT+1g9EudZ+bbuYJDMqyTMpPhSaQiTOJySSwiFy82vN2eus2tWy7kbQbZfon0/4sD7byyAagYxX25j64+Jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199015)(7696005)(33656002)(6506007)(38100700002)(8936002)(7416002)(52536014)(38070700005)(5660300002)(478600001)(71200400001)(2906002)(83380400001)(9686003)(122000001)(86362001)(186003)(55016003)(110136005)(66946007)(64756008)(54906003)(8676002)(41300700001)(66446008)(4326008)(66476007)(66556008)(76116006)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TFXViuzCVGv22qNGT/Vho5A8GKUo5wm2VHoWMa7RuID3u2rOrp7eDYG9mhDH?=
 =?us-ascii?Q?Ld0knKwU7pgFawK+BQOfyOYY70lPrm97+qCsGjDFZRL3uMdCaHeAx1tgDOhJ?=
 =?us-ascii?Q?OfafFhr5ZW0kwNEbUjhtGM+3bM/TTKMqDckKjbn+8S5Py5UKmpVtSlwOHadl?=
 =?us-ascii?Q?JE9aSCh4RMUgcZ9DufCT3eVq5RcCuYpQmNhgqJTc9ViljUwiuvSRUsNPR9X3?=
 =?us-ascii?Q?Gjeeqq5C1s3YVORK14KtwqSu5rRtjoc2q4x5GMaizen/oEbdEQLei2q3WLqm?=
 =?us-ascii?Q?8xAQaOlSdDSmptCSn1mas29MlI1EOzC0vGis6QRLots5PpbKKbotEtk9p5gv?=
 =?us-ascii?Q?bIPe6FC5dJihXPnyCscwgDVCwr2ipoQZ8yG8tAjpilLZYzJNqc+QHGrDaIUJ?=
 =?us-ascii?Q?Nuz3PBoD6cR3hL/rvxCvBAX8Wg87C1bdk4T5+OVEAbdZXzfG3Tz4CA3PnyS5?=
 =?us-ascii?Q?3g1NyJqrTFD7TcgdJ+bzqwkBaXqrzJd2HT6SgAA2kyH/YOAv2f1mpQOwcapG?=
 =?us-ascii?Q?tYCbWp07WXS4yEghTIYN28ft04xR5oHcb53e8nGJcem0i6cO2qozw+nwVeOp?=
 =?us-ascii?Q?f7jmbuCGmn5cZlDbqiXrkxfATXD3s6jQiPVgz3ZorfLcEnynjkBHdNrZ0TpT?=
 =?us-ascii?Q?B7JhPAu0/tNIyPZqYvg2HlhFOLk0qjzGh9Ea3A9KUHglU0anhJDVGF/SP57X?=
 =?us-ascii?Q?UcvDTcuYNOKCe/COQPKGdwvZAhyrOoO+pvwOsygWk2n8WaKbhrBYzq2VLaB5?=
 =?us-ascii?Q?A1YNnO0GS05v+0qncgYxQuAhVnT6EpDQj3SWIiTL/4UkVmwLz4bBRsGYscLR?=
 =?us-ascii?Q?2SuZeKOfIz2NjJYCwJJ95wyB8KQ//LjiL5oc1ILZs1tzd0SY6Cf2Ck0+MuJF?=
 =?us-ascii?Q?yWGzomN7EwoGD8E89dsXDB45v9L69HYX/LhBIb/CtFSmWPHKiKN7/3t8AUKR?=
 =?us-ascii?Q?KQ2Y7xSRmq1WU1U1zK/OZjhMcpFrYs+S0eQcR5Iy3Er75dX/F5Z4PNzzv32P?=
 =?us-ascii?Q?oe2lxJzZ3nuzL17LGCYaHuCPv/1cgRvDmgFYunXpaL5CNB+r58F3PBwCNAuN?=
 =?us-ascii?Q?BxqpZSYDLmDGtjyt8LirTJuP2YBIrDDbp325ABpw9ofDouGLmrMXceuAFlZn?=
 =?us-ascii?Q?vicjYt0N/hR4wMgPo7Y+gvfYmXhmMBLQQCpuzy03LyZKrQllAttGGuaHj57U?=
 =?us-ascii?Q?gkjzdAIq4F+SAY2SpLuRf6mOwhnx0WKhwznSVXw8HWKO8+utNjJAmiAQXsoL?=
 =?us-ascii?Q?PD7ESiUrCp/Y9ofqfasR7iH57zgj1qLjjiZlESSo8xTH8yEsfD778TEIEQC/?=
 =?us-ascii?Q?hJ8xzyUmMaxSgKSmV5AGhmdPK6NyZ3/qxBdcqBSMLuLW02O6lSUpc2UOhLA6?=
 =?us-ascii?Q?SuvBOm7dli2HCZRh0OmRob/QE8NhHCqQ0vYn2akPkZUq6gWN86CM0jKcgPGL?=
 =?us-ascii?Q?k8kOuHGM8jr2PiafwslbuJTY+PXsvZLierWQo2eQcsHA1/wsTY3BNgX4PKr2?=
 =?us-ascii?Q?DYCqVf7Guk3oosQmcJzBAmTDYQehAHiEHvQ75NxidKP1RLKEToIh+/DX8BGq?=
 =?us-ascii?Q?WpfiwM2GyqmaS1kcPxmx2lQ7xzJQBK9/RE8No/aMDNno9oyiSImtK+8SWqkm?=
 =?us-ascii?Q?FwIS8jfoWWQXLz4RNHg3NuDrYh0DxPW5agSFT0XP2SW0ZeSno1sqVwcIhcs9?=
 =?us-ascii?Q?GdYffQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87102805-d127-4a7f-b3fe-08dac7626e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 23:37:59.5875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3cLhzATEX4zrcKV5P68zl4zwllmS0fFp6Pijiujz8lwDN2QjqnP4/J5sbcFEF1kxZsqWu254H1ekstiASu83VtupMmDy0/EwsvxIT2g+ILMcMqmcB9Nd90ZOEWjXDuP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9386
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> From: Dan Carpenter, Sent: Tuesday, November 15, 2022 10:10 PM
>=20
> The rswitch_etha_wait_link_verification() is supposed to return zero
> on success or negative error codes.  Unfortunately it is declared as a
> bool so the caller treats everything as success.
>=20
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet S=
witch"")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thank you for the patch!

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

> ---
>  drivers/net/ethernet/renesas/rswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/etherne=
t/renesas/rswitch.c
> index f0168fedfef9..231e8c688b89 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -920,7 +920,7 @@ static void rswitch_etha_write_mac_address(struct rsw=
itch_etha *etha, const u8 *
>  		  etha->addr + MRMAC1);
>  }
>=20
> -static bool rswitch_etha_wait_link_verification(struct rswitch_etha *eth=
a)
> +static int rswitch_etha_wait_link_verification(struct rswitch_etha *etha=
)
>  {
>  	iowrite32(MLVC_PLV, etha->addr + MLVC);
>=20
> --
> 2.35.1

