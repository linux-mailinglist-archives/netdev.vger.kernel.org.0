Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563FC4D512B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 19:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbiCJSIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbiCJSIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:08:05 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020024.outbound.protection.outlook.com [52.101.61.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28861903F2;
        Thu, 10 Mar 2022 10:07:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSiB0UXSo64OkiPZCA6G1q9XEhbD7dq8wpmeydm/RyKY9RgNkqYj1SfDvtktAnJ8ad3GqJJr++R7llnSpch3QrDLDazvAGxAQz97xa4f8EwahVk4KMCEqnzY5PRu0umUJCbA9VLf1IiWJUKLY021H8pp6D0mquGbBi736a5+AOmN5thOf1okkr1Z4GRVBXQuAdFk1j04PfQPKFxSGm32yzuq0v9YdRWPCq+5Z43osn1YUujGkLHLMKVVpcTncP4RbqCKiwzDVxgzQn8flXXu2ehdqJHAwcqYDkijWHOuQZlBae7JJoq3wTPK58dlAMCkLvNsO9DKkBnGsDCMhi8gBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEjAA1MAJAW3I0N3JXpYMAoXY3O6gKzw5ZXtZHitods=;
 b=UyRZ7m0eEPkbMHbA0S4G5lwMfir8IKG8GMcCGLNtB4SI3oC2xwawZ2qvcDaZtv+vcdGlNm6b2z757fQP/iClv1IGEa9Wbes8mg3f+Lgry7/HBRZfMesaVpWs/Es5hRkcKaNxFxqHO3qyiFlghloZ+51MYROwhz+tZwUPCsCgBeQwp5pfNljSwXV0t3j83fSWemxUmpqcuPi/3VhbFcajXNGdHMsYx9q1sGIEFc7dTX180QvAPU9LiVXITBUAGL5xEI0HctN2NyFIrIlpwpO9D9YhfoMDt8pQQLa4/DZqFtKu4ZCrKMhLvGCLKEOoM0AYWdnWQFXpKIo0NzZjk1x12Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEjAA1MAJAW3I0N3JXpYMAoXY3O6gKzw5ZXtZHitods=;
 b=NolLzZ4+Z3O/kQwoutDJHNUMeIew9z4d7n/4ri3H6JZ6kEEda7wOwkZR2PYZ0oIOqSVoXEWMSRNzYoVQEPI8B0BnhmTPwHtw8OlWbW58wBg9N6nXk8qLTx1B+H6I/33ewpliqbcNBKWY+hp39srCgNY7FYY6mujYEqePhS+Fet4=
Received: from LV2PR21MB3181.namprd21.prod.outlook.com (2603:10b6:408:175::9)
 by BN6PR21MB1268.namprd21.prod.outlook.com (2603:10b6:405:8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Thu, 10 Mar
 2022 18:06:59 +0000
Received: from LV2PR21MB3181.namprd21.prod.outlook.com
 ([fe80::e8b6:2566:2c71:755b]) by LV2PR21MB3181.namprd21.prod.outlook.com
 ([fe80::e8b6:2566:2c71:755b%4]) with mapi id 15.20.5081.009; Thu, 10 Mar 2022
 18:06:59 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Saurabh Sengar <ssengar@linux.microsoft.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: netvsc: remove break after return
Thread-Topic: [PATCH] net: netvsc: remove break after return
Thread-Index: AQHYNKTNGNGUVzp3xEutglpO6xfq+6y46Y0A
Date:   Thu, 10 Mar 2022 18:06:58 +0000
Message-ID: <LV2PR21MB31819EEE2F0710BC390110A0CA0B9@LV2PR21MB3181.namprd21.prod.outlook.com>
References: <1646933534-29493-1-git-send-email-ssengar@linux.microsoft.com>
In-Reply-To: <1646933534-29493-1-git-send-email-ssengar@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3f8d6cbf-5f7e-4966-9e21-6065687b3890;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-03-10T18:05:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e24148c-1d38-4c65-884f-08da02c0c522
x-ms-traffictypediagnostic: BN6PR21MB1268:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BN6PR21MB1268023BC3A27622F02C9AF8CA0B9@BN6PR21MB1268.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: enwfc2NOnQwqFcnw/NFCzh/1+6f2H008fDnnp3w3F3fzxfHLqxwtDBn4rFVeA3jj7Z32diKanfcI25JIq6vqwNQzZRXikC2bAQ50nBIalsxn0MNQqrqB9Xz65seOn25zl12L9G63lXwHzWypXnKePzF1Zn/7MU+tiqoM+g72ZZkqsKMjcwFpuFP29ej0se+dNNGGe2JldQfHiHlUiWlkiW2wA0bYl3/4WsghXb8BQu3Kq+dcFQjXF7Mx7lE4/Y6U5yCFjWLVB+tM+ybRzfwzLofnZwtUNf9ibxjMKKw1OW0EJG61AYkkrSgBUadkvtPeOxrgqNs56SBTq6bFaTiG7g+Tm8W5swRJYiPD4OHKtXRy8FOR6Cm0I71lEjINNacJGAcqCIMATyyoyn0BHwyMitex8+L8qxiusXf90+O1xAYeFOprnveRBzLb39wcgkVt35kyUse/VvgJ7tOn/AYFifC/RxzVxv2W9IPEw7JjKKOZJh0xrCdjRoN78jvA/DOJzMzS9bSdpVGuRtCANQKFxsKBrEshpENrSq/tWHi9DC7Cet5rFZf+a0+1QmtAdmxKecKiU+Dwvuc1K28zF/MacN9ieJsq3NOiUA/0ZRI/W9tC++yvwVQw/ZL8oia5GhazYqj3CV9CDW54Oj0MpnsJI+LYWv/D4kJPyo9gChSbKqOWGeTyarbcMkMycfyPhAV1SjW33cmKZSy2yRdgqdyQvBMJCxqGRbi8a3R8kky7AofuwUmqVLGrkU8gY6hA2x/kU1UfXCekEq+UglS/ot99yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR21MB3181.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(83380400001)(10290500003)(508600001)(316002)(66476007)(76116006)(8990500004)(9686003)(66556008)(26005)(186003)(66946007)(8936002)(2906002)(38100700002)(86362001)(33656002)(55016003)(6506007)(38070700005)(110136005)(7696005)(5660300002)(82950400001)(921005)(53546011)(66446008)(64756008)(82960400001)(8676002)(71200400001)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5zV+x5h/i74t2Mp1MJkKYe9hnEHxYIH+SCyq8RU+TG7190iAAW3EbtvwULr6?=
 =?us-ascii?Q?dNBA22vUZqv2aZ1PR1lJNr/XqXDCU9VeWBzk4ebirR8agWMv9xZTeoJmtJdw?=
 =?us-ascii?Q?FsbGtOiQZz3DQlAUWMpPdNbgU8MJiT9npoC0D5hoMMOj9u74KT3vS/ZTxLUQ?=
 =?us-ascii?Q?h0z3mN1J9LTs2UrNu0qgrdleUiAg0Bf7SQF5g5fv0R6y543TNCe4+8FFO5y8?=
 =?us-ascii?Q?buFFKDGQRxpPSLn90mAJM4gm0NeCErobJp4YJavJMxl0uLfnnQOnRg24DlSk?=
 =?us-ascii?Q?1kfUka1QE6m0gIVvPrzOo7L3DOa3I28KRLDDfJJy2JudjpbTK1TEEhWDJjU+?=
 =?us-ascii?Q?2pQ3HAXsMj/V/WKGX4pjk+1rYGEFyrhSufsIfuzsH4k06uYiZ4gj+2Vpr/mg?=
 =?us-ascii?Q?imWyD5tBPeZsSIWlo2H3nzGcSHRezu4Kj6dK9e9SjLzCVIg7Kpb/Nn/ekB0M?=
 =?us-ascii?Q?YgpEQi+Fd15iMMUYZNPyhtaKNySiDZfL/TU1VwhwYg8g0uQUlA9O04i2+k3B?=
 =?us-ascii?Q?wDV8at0WMTIuVap2y3P7WFz1ePS5qDVM/+1f+/XDyhK2IomLp1Va9qDRPDMA?=
 =?us-ascii?Q?aHMK4ueNk1tQvEEgEgBjBplbWOrNpTjQtOGoyVaAzbPXZ5cutnofx9GrFDPD?=
 =?us-ascii?Q?NU5es40E/lZlGbnPKTECBsugcLI1bp9QQkXcl1w6xoZ5osPuBHCrFHRhmd3X?=
 =?us-ascii?Q?/GtAtmV64regpWPS82dsOpPtBNTaIk/cUrLQHvHdtyEePyaPen/HHBYkD1J+?=
 =?us-ascii?Q?gmE7g272MMXuhE5pvsTxWOB7CMA5Rk0BP3z2k9puPtvd11hKRDYSOhz8tyvD?=
 =?us-ascii?Q?2SfA/kPtD2SPQYD7uVLlgGMFJ4AuUS8HxBI6sU+iv6bHe3sdArbvPBEWL+9J?=
 =?us-ascii?Q?efUK42HeROHWSfRz4p+DnqFUcsHdruD81WKYsFEynetFvVQ/fZOoH5NUyWIQ?=
 =?us-ascii?Q?GMyRjooPD2XSULMInrNjxB58Oms40hcEGDMj62s2OJFP4278vRGH+apqHItS?=
 =?us-ascii?Q?K8fWZnDYzyYk1JECEpyFe/ubfbSBzJjcoz/RkRA3saj3XZgs3ushUfKKNyAo?=
 =?us-ascii?Q?7e0H0cXtugzZSDqhrwgd7YHtsIIKtmFu2Xj21bOkLaFrwhJVJQRQ1ApiVxWe?=
 =?us-ascii?Q?5w0G/4chbgr5lYZGMw8VlU22dNJaURsSGWg4d5dZfdhnwcNWil0EeRvGXe1E?=
 =?us-ascii?Q?Hp5h7D1BbLG/fRXO6PuA0+cSNAdytI+nU0D/n3+Ym9c4MQzbZuJVCoIC/aPY?=
 =?us-ascii?Q?GSOxpDnVnjrazwbdQZlyeYx0n8YjpC1rEAFnujFCHq7U+QgHJa3fPL+22h/V?=
 =?us-ascii?Q?TX9BsmyKWS9RAW5QcjZ7SnUlaKnwMw1ZP+jbrijdm8V628mU4q3A+egridID?=
 =?us-ascii?Q?M0j58SADQ9XcGMzbDPPiIURUE3VkJ6bWueWwUMrT1BIC/uF5ghEYdNSYURzm?=
 =?us-ascii?Q?f2+MocAedkiQkQmausia73q6lD1yov9Y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR21MB3181.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e24148c-1d38-4c65-884f-08da02c0c522
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 18:06:58.8948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzSxYlD7W9vTT4iKWnwAlzoUhpsKVSnQ39ajs4CbB1v/ihZm0b4GwEuNOxoH0G6v2ec0naxEqOIYLeYI77cnGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB1268
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Saurabh Sengar <ssengar@linux.microsoft.com>
> Sent: Thursday, March 10, 2022 12:32 PM
> To: Saurabh Singh Sengar <ssengar@microsoft.com>; Haiyang Zhang <haiyangz=
@microsoft.com>;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.=
com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>; davem@davemloft.net=
; kuba@kernel.org;
> linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.k=
ernel.org
> Subject: [PATCH] net: netvsc: remove break after return
>=20
> In function netvsc_process_raw_pkt for VM_PKT_DATA_USING_XFER_PAGES
> case there is already a 'return' statement which results 'break'
> as dead code
>=20
> Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> ---
>  drivers/net/hyperv/netvsc.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index e675d10..9442f75 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -1630,7 +1630,6 @@ static int netvsc_process_raw_pkt(struct hv_device =
*device,
>=20
>  	case VM_PKT_DATA_USING_XFER_PAGES:
>  		return netvsc_receive(ndev, net_device, nvchan, desc);
> -		break;
>=20
>  	case VM_PKT_DATA_INBAND:

Thanks.
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>



