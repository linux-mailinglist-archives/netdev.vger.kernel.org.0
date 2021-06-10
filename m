Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272ED3A31ED
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFJRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:20:14 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:1473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229823AbhFJRUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 13:20:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fmb/+i/7LbPC/fFCOXN+OaUZZxi9g0MiBxr9PKBI+QtBWvFuqUHPjgrGr7wcIFE+X6r6r9xefM43/6XiOY1DVULbaGerNrcMxRrbhROtcNlN0LMtpRv/B7nkRlF+hJrMiadhgSedNGL52xwhAk7j7V6O4RvRSftBU6mFbHIyg+zJlkv8vCyXkRcT2zbixLPvpDJn65DWlP2jubPQHqzw0hKzI+ygfdpFFyDgNmDIdBa452M+QAqiiC5kDyueviVl5mGMopwxorsSwRW0oOCCN/734CUipq4JVUF5xyXeQb9BEONSorlrhcpIn6lbOJp5+wUbJPQK+oIz7RGJqGx9Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qrbfcvl9gnfBJIyUTDldWFOR316xXQhhHuQbNkAOMr0=;
 b=Jm/LKqHgl24zhP2CVspc/CohWVkvMf6RhLQ9Fv1i4rD+1qZGCiZMtDlHM9VbuMvtM3opJN7wWBj5Ja9381Sq9FY9xxv2cQXQ43I2ybU7qPlscTuBr0RRvCU3fGd1QfbY7F1RXwYawT2Hk6rFgPHc/NFU3/RPveewrElqzC0ksNlvtNByTETIP8AoxGoJ2bmMjlJ2EeljTL2JvKO/YEPXSUxZRpBjX6H5Px1gM59LJ7puuIbp5W8LzUQGpBfGj6qI7uiBUJ5w5PO3wO0sv6sezRZB1nhHccdPZIIifVrHq4bHe71BL4qYSPMEREq96NYSMdRcoDwq5Okd7M2V50rVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qrbfcvl9gnfBJIyUTDldWFOR316xXQhhHuQbNkAOMr0=;
 b=RPxB+zSzCDC10HyUg6hOP7dX2fZHP9zhZqWJQ+bc1AuuJa3fSWfENuloDHqk378wf5k1lvZW60cPhtiYf+ptSvpeYVeIoDKwZZ3uIbk6ea0uSGSixD3GonyME0C708OWs3pAWDyi6qFUnN+5b+dNy0jLR+naKSoqLcCZR0bPU+g=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BY5PR21MB1395.namprd21.prod.outlook.com (2603:10b6:a03:238::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.5; Thu, 10 Jun
 2021 17:18:15 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce%3]) with mapi id 15.20.4242.012; Thu, 10 Jun 2021
 17:18:15 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Dhiraj Shah <find.dhiraj@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Topic: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Index: AQHXXg1ojJMEZe7SE0uvKv3Tzsr7JasNfBjA
Date:   Thu, 10 Jun 2021 17:18:14 +0000
Message-ID: <BYAPR21MB1270FC995760BE925179F353BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20210610152925.18145-1-find.dhiraj@gmail.com>
In-Reply-To: <20210610152925.18145-1-find.dhiraj@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aa31c948-516e-4a40-bcc8-6b4f69306577;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-10T17:14:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce89036a-07b3-44c1-53e2-08d92c33bb8b
x-ms-traffictypediagnostic: BY5PR21MB1395:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB13959C6AD0421727878F776BBF359@BY5PR21MB1395.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3DozVUQ9U4iyXlXnPNeRB/BKeJuTL0IWH2rtkHX+qAPO1wEcwkZZu7Fefnpw/pw5S30yA43zI5hV2A3HbPFg+vNQmxBybpSsFrXeQ/ahn4x6kWx0vLpFDrImvlm8AOPgTPMfzkO9q3yqNc1ArH7ACzdsHDwGoTW2ujewqM+qisao/bIOp3lJqBdwaCHODUSYtd+D2JnJVf1O9AjuH5/8tyEbTAuxOSKVZnsGOGc3FaLEyohE0dv0/StsPoGrWCM4yFimBm49fFH7zNuFuDBO5EfLFurQypP69wC2ctZXyvPRPrp78PtMtVjMPnnQ5w9D0w4VC/NRDXrkl8CEKnuVhx1905At7LX/Eaphe3UqWkbnS6hfm4SUY8g36jWIKve9Cet1q596WGRUhoVHFmxANshE/KgAmkniKZXxwDB9QTrOglKPpMMj6Oe57nU0nxgw2uDG2hXkT2k3okUEGBjWVzJ1waQ/qjpJG7crb+tIhFxXuj20ex672+KcAnRyuv2kHxGixwu2GuoXl4wExtpX6pa7/AxRV9AZW5dcGVkVhM+Q3eJ1Ah0mwkEU3SOyNX4buB7BqZUkjdbQXbtyHt3SAVOzvJyeWDQxJ6tzwN65C/V5cjn9vFdeQQzFdoALyor8WGUXln0G+K3IZKu1G4fatQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(4326008)(83380400001)(122000001)(5660300002)(55016002)(4744005)(8936002)(71200400001)(54906003)(66946007)(316002)(6916009)(66556008)(82960400001)(2906002)(64756008)(7696005)(66446008)(82950400001)(10290500003)(8676002)(38100700002)(9686003)(186003)(66476007)(86362001)(33656002)(76116006)(478600001)(8990500004)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sE8yTC/mj2ha2HHGjGCSWpO9tsdNhGFhXC99+AVmGqQh1RwMN0iLX4Ow6HoZ?=
 =?us-ascii?Q?5wQHyfkt3agrSw0b3FS6stNaxGmkDtZ2340XUR1l6sSM7gbpqHbF7M70owYt?=
 =?us-ascii?Q?SaUbBIyk2kexFYrlCnd/iO2oLDvcA8uCWLQzq3WFok8lEbimjsMeqkw9myux?=
 =?us-ascii?Q?FrumKDVwtSj1BtRTAczzsG5m9lE3ELENWzPp0lpZ9+e3bMJE6P61o5qxAcxp?=
 =?us-ascii?Q?mHxC4ne45a/cd4ge/W8xAQApI+h2A7oV8NIDllZ9z03lqdrN3B4SL/llR2V/?=
 =?us-ascii?Q?UJ5LCdygGy5mXVJbKRwNjPNWq09v6V2hMWGXmVn5iZ6dQnIUv2yBWNwQfVuD?=
 =?us-ascii?Q?IXoRiSloTR6G12vf3w1yGqvIiMxh1t4HokFuWdTBuCGJy809cnqLCdgwQSAN?=
 =?us-ascii?Q?xkGSlfKf1Ip1YAq4xX9tF0DeFzU5Q8dH8E985ty9FyKJ7Ry0bIaQHFPgY116?=
 =?us-ascii?Q?e5BJfczfrt9ef0Uk0j2xhdBwaqcvm3yyt4XKnlUX9iy7ZzTCm3bfZNwQWnPS?=
 =?us-ascii?Q?wM2D70taE+Xf/aogd+lvvThAGt9pQ63BJUJrUf5b3H7JW00jiJTPoO70JwHb?=
 =?us-ascii?Q?sxaBY8PKeSeZh4hscSvl2VdZZTnfc9c7IxYsfsuM3RKib94vSDEd8rtyC8/1?=
 =?us-ascii?Q?/93BYo5mhja03xcOLxMexHOQuhUH2nG/fgIWEfDNRxuLy+0Z+xheskGZsRDz?=
 =?us-ascii?Q?bSLWFivhPXliNCAvFq5IM3MWTWtPWpLWmnvGjxG0TVYrPlEGRH7n73nfqnFU?=
 =?us-ascii?Q?Gxy8ZTKiyOoz812f+oKbUyQvY41PwFwRG8VvixxKCIl9YOah16DrbgU1zcr6?=
 =?us-ascii?Q?S6BnsFlmbPGVV4qKDJNoTtYxeF3pVWdgSyeLw/+nXDR84ITLfeC7HnuCj5PC?=
 =?us-ascii?Q?1tfnPqH+dLmuF7DA0u3G3rdEcBRIbjr5cNsZcWKfblihIplJ4x026rj/LOUj?=
 =?us-ascii?Q?48g4mwnNBcsE8N9mfOSgaqvWZeB0Ni/9NJnXy6GS1LfcZ18Y2dByl+K8AkFC?=
 =?us-ascii?Q?PI2VToCeaFglnU3wSiwyzIWbxVdv+54T1ZXf2Ci+7H9Rgiq7HUuzIUZRIHCN?=
 =?us-ascii?Q?5j/x9lR3eVy9KTYRQgR1mBhBflWuoOUmM1U9kPnRyUA93h04jAWKYpqVpuGi?=
 =?us-ascii?Q?KyIG+xhgjBfCLiu4vZOaHPRmcOw6Go6Z5yV+34eysbQntRsMq5y5dSHI0ndR?=
 =?us-ascii?Q?Rhc0jIRTCQ4EXSasir9BAggkvvemdm21R2KjEaGYFpr6BuOuJ2p+qAjw0IOm?=
 =?us-ascii?Q?NsiZRIRmgCMLh6vORznDGdqVWDHnVKxbgIE0gD5iSIfRXnts+1nMW1h/NIen?=
 =?us-ascii?Q?S7HuljBAsafnliFx69ifCXWqaMJoSNgLjWj5TEDtnB0JF19tRLkQnPK7gZES?=
 =?us-ascii?Q?oBTDX6dXuIoma/2YexGu9C2JPvOY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce89036a-07b3-44c1-53e2-08d92c33bb8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 17:18:14.9001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzFh8WbTK3PqfCucwjCdlP/px4CSRf75AsNAmYaYozBVPds5kwh8cSD+EPeXKRzWJVr3sTwg3mG9BvBg86QfrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1395
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dhiraj Shah <find.dhiraj@gmail.com>
> Sent: Thursday, June 10, 2021 8:29 AM
>  ...
> memory space allocated for the queue in function
> mana_gd_create_hwc_queue is not freed during error condition.
>=20
> Signed-off-by: Dhiraj Shah <find.dhiraj@gmail.com>
> ---
>  drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 1a923fd99990..4aa4bda518fb 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -501,8 +501,10 @@ static int mana_hwc_create_wq(struct
> hw_channel_context *hwc,
>  	*hwc_wq_ptr =3D hwc_wq;
>  	return 0;
>  out:
> -	if (err)
> +	if (err) {

Here the 'err' must be non-zero. Can you please remove this 'if'?

> +		kfree(queue);
>  		mana_hwc_destroy_wq(hwc, hwc_wq);
> +	}
>  	return err;
>  }

Reviewed-by: Dexuan Cui <decui@microsoft.com>

