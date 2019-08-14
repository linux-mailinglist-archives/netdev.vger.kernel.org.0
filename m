Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3ED8DEED
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfHNUgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:36:00 -0400
Received: from mail-eopbgr720118.outbound.protection.outlook.com ([40.107.72.118]:4640
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfHNUf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 16:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCu7OG627PYInIHrXekkUFZova0+VZCW4P2QomygbSe4nj72m/6SWruse0wEJJMyLirgKYlXtajrICjS9me9jV07OoKf5Jk3rwZZmWZhXVhmVkCPmVAClqnzipNMsenhJFL2UJMT9+yb46RQ0R65wBICIhlKQQm3Cjyj7r9ZZUtcq6hx/BgXB12vZpOSalk+WfSWbegn2KdBjxuqMEO/uPUdTwC//cPxXmMUtD0FWPUUKK5lxPOnamfVV4YjEfFSA+tKAYQx+/lMcRIC9VHNM8tXOvJ/SRshb3/6LARHi+VY4qx16sxfTA8C2CjEg0s7Dk9MgV9eu5bzkIelMDHx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3AvqNPXcJg6u8W9dsTdt9d5+aTVGwnu/DmsD/yTdxI=;
 b=JpmSPT79BqpVNyGwOPT1firlVQOWZ0AxtgukyIHFsQ4/DaUz4oe36NFIRgAcej8NRfq/h+24p9uDt4dhqO7ZeIYPpxMaWuio12WksL6pJ8s6m5ZovXkSOZ0tV2CxjRpHkddFxbFImzvyTOsWXxKqh3qZKllXNRRAckkoZoPjG+eZtaW5x2G/49DyWPwKLDN801Hq9yZKQABLTPJLoCUNjjYAHeXbzlgqRPxPgpCoxl2l18q0cdyMHefVK0YMPf40KqLOcdntchyUWa5D/boUvxsBHJlfLsK0Ndxzf8k9XLcb2aHwtKKC2VaK15tg0CTMHx/gi1vjQRoWSgS9X2DQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3AvqNPXcJg6u8W9dsTdt9d5+aTVGwnu/DmsD/yTdxI=;
 b=XqjvoDlxuNJOmz0m1skVpQWl+OmliWu0r7XRLu6YU2x2A/qZ3vskyGzJkfJ+sYM6u2vUYu4Wm49dGQDbb4EDbi5W5g8WkEBpfpuYxjojNL4SnBVgyHfRt95v9ZuSRBuj9mgOMSq632+u1ivNFvPXa98IQ3vOXdeqJQzcHbuWNUY=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1244.namprd21.prod.outlook.com (20.179.50.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.8; Wed, 14 Aug 2019 20:35:17 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::257a:6f7f:1126:a61d]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::257a:6f7f:1126:a61d%6]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 20:35:17 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:Hyper-V CORE AND DRIVERS" <linux-hyperv@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Fix a memory leak bug
Thread-Topic: [PATCH] hv_netvsc: Fix a memory leak bug
Thread-Index: AQHVUt0lIPzKhtX2+0Owd7O+SbqtXqb7F/Ag
Date:   Wed, 14 Aug 2019 20:35:17 +0000
Message-ID: <DM6PR21MB13374BEBDDCFA4CE76D89E31CAAD0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1565813771-8967-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565813771-8967-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-14T20:35:15.7617970Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5db6b1dd-da7b-4a74-b1bd-404541213757;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1ec4162-71ab-40a9-4842-08d720f6eb14
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1244;
x-ms-traffictypediagnostic: DM6PR21MB1244:|DM6PR21MB1244:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB124482D75434B2F1FD9E1B18CAAD0@DM6PR21MB1244.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(13464003)(199004)(6246003)(10290500003)(7696005)(186003)(8990500004)(6116002)(76176011)(10090500001)(305945005)(14454004)(71190400001)(53936002)(7736002)(55016002)(53546011)(2171002)(66066001)(6506007)(102836004)(26005)(74316002)(9686003)(33656002)(3846002)(6436002)(11346002)(446003)(6916009)(486006)(476003)(66476007)(25786009)(86362001)(66446008)(52536014)(316002)(66946007)(256004)(64756008)(2906002)(22452003)(54906003)(5660300002)(8936002)(71200400001)(81156014)(66556008)(81166006)(76116006)(8676002)(296002)(229853002)(99286004)(4326008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1244;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ng/JhWZ875hZp0rxzSKuOL/AWU9LudOOw0WJBJ3468UnqCxhp+4OHNBYNtxX/4reMtDIjqF6DHZPjN5gU+ZSbprAm8sI7RJwc/c+2xPgiD2P8teDZoNYonGuCjfySCyhfHE/hrn5bq6jBTxgxoDc9g/EX6RxULDcGB1G7QUL8dP1dpmgz/6qumuOtlgYnOGfAT5VayA3b7N9D9xsAzNEIB8zT2pp3+y8gkfKmnm2l2v3aFmsri9dCICscm84Hb/y93elEBzWYmxvsWCpbJdsj+zwNps98LJGeTdmDBFp7QEg9LoaepgU9xNwlQ6kilo0OoEgkAGZrYdUBUyNoN7q0hC+fJMcdLJwVGtOK1DLdtVgzWPJc2Bs58etUofsv7Ltl84pbPRs8dmL+5qx6pwSHMwu8Hj8zNwC96A0BY0vCFs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ec4162-71ab-40a9-4842-08d720f6eb14
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 20:35:17.2112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sM2yKWtCL95z4FePwapN9jKQssQxNXRFrS4m02/Si0kuPhnE3ZjaL0beakvUDT4W+2mgRfkmhRtWoEFD5tyVvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1244
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Sent: Wednesday, August 14, 2019 4:16 PM
> To: Wenwen Wang <wenwen@cs.uga.edu>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Sasha Levin <sashal@kernel.org>; David S.
> Miller <davem@davemloft.net>; open list:Hyper-V CORE AND DRIVERS
> <linux-hyperv@vger.kernel.org>; open list:NETWORKING DRIVERS
> <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH] hv_netvsc: Fix a memory leak bug
>=20
> In rndis_filter_device_add(), 'rndis_device' is allocated through kzalloc=
()
> by invoking get_rndis_device(). In the following execution, if an error
> occurs, the execution will go to the 'err_dev_remv' label. However, the
> allocated 'rndis_device' is not deallocated, leading to a memory leak bug=
.
>=20
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/hyperv/rndis_filter.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c
> b/drivers/net/hyperv/rndis_filter.c
> index 317dbe9..ed35085 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1420,6 +1420,7 @@ struct netvsc_device
> *rndis_filter_device_add(struct hv_device *dev,
>=20
>  err_dev_remv:
>  	rndis_filter_device_remove(dev, net_device);
> +	kfree(rndis_device);

The kfree() is not necessary here.=20
Because it is already freed by --
rndis_filter_device_remove() --> netvsc_device_remove()=20
--> free_netvsc_device_rcu() --> free_netvsc_device()
--> kfree(nvdev->extension);  //This frees rndis_device.

Thanks,
- Haiyang
