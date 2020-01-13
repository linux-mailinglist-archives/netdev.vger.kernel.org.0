Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30637139A64
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 20:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgAMTzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 14:55:50 -0500
Received: from mail-bn8nam11on2115.outbound.protection.outlook.com ([40.107.236.115]:6376
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726985AbgAMTzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 14:55:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LITcxhKP41gBasn5z9amOze662wGEzSk9hio9LjhlFbOBokmmSCAL3D0TdNPqjLg2UpJNT559mRxOkV5nwOO9WNpcmMVHJlXtoWa4c6FwwQsKzMCopHGqnovQ2cm1kiag1NiGkK8ALw9/9/6kDDeyZf2kZz/HkKVlN60b3JmM/04Br/ktXjM9YvTva/HbfurKLmpISxMoIB4tfMaZFDXwFPceNvZnFikPVupSYqwNVOBp/zuTcgpl7zPFCQQFtPmAFosDOJUJq8UAL5x0uyokgtduiMtSd1gvPeOYMk0TbcGwlN/I39K0pd2X5r7iBTGuq+8srIdQpPO9a8zsLXxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QVCCQ2MIfXYaaFQHYD5acKivoTlhDrJcDzSawoBsnI=;
 b=U2TLbgDu2VdIEXbFg6xu5DnyFaD4rgEV98X6Nl4dGTSeA+pdlbBdkK6oxCPl8xeFV7xPAu/WLOaNVexmhE/pBDhDFtWPAD0Mns8vDNFHQfVf17PoG8p/lcBUHMt5DX0jxyTMvto9ooIWtwWqSjbiJkYCuT3xH+kGF5WCVSyM+O8g1AgcXFrTahJCcXfvyRb+UkZDaYZ38TzGKKDqlfwR10FGL6kwENBqNydBDw2TsxEJUROZct99a81gJ0SRQ+ns23Ni6Y/+9qba2Yy9z0jRJ4JAGIWS/sUNh7501VpQIHZeHo4/f+IsChEXh1UDLzOhTnL5FCkrgzJAiLNXB4ibjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QVCCQ2MIfXYaaFQHYD5acKivoTlhDrJcDzSawoBsnI=;
 b=HqwZ3OWcmgi/4rFLZg82zuCVjX4/whz1kfiXUophk5oR+9hDA/HQqjB33eoDP3+1nJJCgSybeMKX7eq4SyPiyKifdmoICxGltC3gofzFWYi72HqQ2PV9BghSPzs6v07vLheetNfpvdEjWaMSGHWWCnwS8d449TOJeh70hZ/J5Qo=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1470.namprd21.prod.outlook.com (20.180.27.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.3; Mon, 13 Jan 2020 19:55:46 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2644.015; Mon, 13 Jan 2020
 19:55:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Mohammed Gamal <mgamal@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        vkuznets <vkuznets@redhat.com>, cavery <cavery@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Fix memory leak when removing rndis device
Thread-Topic: [PATCH] hv_netvsc: Fix memory leak when removing rndis device
Thread-Index: AQHVykeZNk0GzNDhI0uj+RVD6t6utafo/cLA
Date:   Mon, 13 Jan 2020 19:55:45 +0000
Message-ID: <MN2PR21MB1375C1C333928779BC4978ECCA350@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <20200113192752.1266-1-mgamal@redhat.com>
In-Reply-To: <20200113192752.1266-1-mgamal@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-13T19:55:44.0455820Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e34eb14c-2151-472d-8546-ae6293bc44a1;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1db2179-f43a-470a-e7a3-08d798629465
x-ms-traffictypediagnostic: MN2PR21MB1470:|MN2PR21MB1470:|MN2PR21MB1470:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB14708BE42EBA743188639588CA350@MN2PR21MB1470.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(189003)(199004)(2906002)(53546011)(8990500004)(7696005)(498600001)(76116006)(186003)(10290500003)(6506007)(66476007)(66446008)(64756008)(71200400001)(66556008)(86362001)(9686003)(52536014)(8676002)(54906003)(5660300002)(8936002)(26005)(66946007)(55016002)(33656002)(110136005)(81166006)(81156014)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1470;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0DJpfTa5FUK8j9hpDhZXZrw5+IDT3wYjSyLXdCDhfmh9jFi2loBOcT8o/lb0KtjoMGe+ZbnM/eDkPYrqQPYPFmFlJTvz4vQriSu/FreOg86mBCh2PcyBE91XT6YjTJKdvblFh4gaYrsXP9jSn0m2W6+GzLsZcm1ba892Vlrv5F6fu7jEozfI7q8Zf2AdnCMWMBS8WvSme/BSERDK7/tN4TXCEGA0Pj1/6gJ0HrnNqaA3oWmF/L0aZQQjLlwPOR5BhmEoVBKKUqgh+3lqM1uBdQ+yddmOzmsBLnCKPqPL3pQ+6yceZhcwKOhGH5x99uQjIB75oyWe3TqmiY018BPDZd5yscgQs3FmKRaC6nIoM2AqVI6M5zXI14X1xabqi3HPy/oOcsnJPjQpVadNFxtZVOVhVtmQZQdq8GBJjYsQ3vClDws7cNRQ7aHgK1dL1lq
x-ms-exchange-antispam-messagedata: 5j9++WxZq7N6/pp2a8GKxuMaqQu93pHMf4K8YiL+ghmsSioo+ORnIC790sWkPvxvbx2kXpyEnjRmyiRt54fJFdQil5remc3Qv0+n37uWeaTSjrdOSJpsyPC4Gk3j27YIyLLl4Mu72oDi6BTRlxb4DQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1db2179-f43a-470a-e7a3-08d798629465
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 19:55:45.8178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fwi3f7a07ipSt79HYM98GT6kGxsM81rfb9aOH4uOnyH4zrgCj30MdcVOwpr3rYa/hDiZ0RBwulb/BBI/F4ETKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1470
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Mohammed Gamal <mgamal@redhat.com>
> Sent: Monday, January 13, 2020 2:28 PM
> To: linux-hyperv@vger.kernel.org; Stephen Hemminger
> <sthemmin@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; sashal@kernel.org; vkuznets
> <vkuznets@redhat.com>; cavery <cavery@redhat.com>; linux-
> kernel@vger.kernel.org; Mohammed Gamal <mgamal@redhat.com>
> Subject: [PATCH] hv_netvsc: Fix memory leak when removing rndis device
>=20
> kmemleak detects the following memory leak when hot removing a network
> device:
>=20
> unreferenced object 0xffff888083f63600 (size 256):
>   comm "kworker/0:1", pid 12, jiffies 4294831717 (age 1113.676s)
>   hex dump (first 32 bytes):
>     00 40 c7 33 80 88 ff ff 00 00 00 00 10 00 00 00  .@.3............
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>   backtrace:
>     [<00000000d4a8f5be>] rndis_filter_device_add+0x117/0x11c0 [hv_netvsc]
>     [<000000009c02d75b>] netvsc_probe+0x5e7/0xbf0 [hv_netvsc]
>     [<00000000ddafce23>] vmbus_probe+0x74/0x170 [hv_vmbus]
>     [<00000000046e64f1>] really_probe+0x22f/0xb50
>     [<000000005cc35eb7>] driver_probe_device+0x25e/0x370
>     [<0000000043c642b2>] bus_for_each_drv+0x11f/0x1b0
>     [<000000005e3d09f0>] __device_attach+0x1c6/0x2f0
>     [<00000000a72c362f>] bus_probe_device+0x1a6/0x260
>     [<0000000008478399>] device_add+0x10a3/0x18e0
>     [<00000000cf07b48c>] vmbus_device_register+0xe7/0x1e0 [hv_vmbus]
>     [<00000000d46cf032>] vmbus_add_channel_work+0x8ab/0x1770 [hv_vmbus]
>     [<000000002c94bb64>] process_one_work+0x919/0x17d0
>     [<0000000096de6781>] worker_thread+0x87/0xb40
>     [<00000000fbe7397e>] kthread+0x333/0x3f0
>     [<000000004f844269>] ret_from_fork+0x3a/0x50
>=20
> rndis_filter_device_add() allocates an instance of struct rndis_device wh=
ich
> never gets deallocated and rndis_filter_device_remove() sets net_device-
> >extension which points to the rndis_device struct to NULL without ever f=
reeing
> the structure first, leaving it dangling.
>=20
> This patch fixes this by freeing the structure before setting net_device-
> >extension to NULL
>=20
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  drivers/net/hyperv/rndis_filter.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 857c4bea451c..d2e094f521a4 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1443,6 +1443,7 @@ void rndis_filter_device_remove(struct hv_device
> *dev,
>  	/* Halt and release the rndis device */
>  	rndis_filter_halt_device(net_dev, rndis_dev);
>=20
> +	kfree(rndis_dev);
>  	net_dev->extension =3D NULL;

The struct rndis_device *should* be freed in free_netvsc_device_rcu()
=3D=3D> free_netvsc_device():

static void free_netvsc_device(struct rcu_head *head)
{
        struct netvsc_device *nvdev
                =3D container_of(head, struct netvsc_device, rcu);
        int i;

        kfree(nvdev->extension);

So we no longer free it in the rndis_filter_device_remove().

But, the commit 02400fcee2542ee334a2394e0d9f6efd969fe782 did
have a bug:
	Date: Tue, 20 Mar 2018 15:03:03 -0700
	[PATCH] hv_netvsc: use RCU to fix concurrent rx and queue changes

It should have removed the following line when moving the free() to=20
free_netvsc_device():
>  	net_dev->extension =3D NULL;
Then, the leak of rndis_dev will be fixed. I suggested you to fix it in thi=
s
way.

Thanks,
- Haiyang

