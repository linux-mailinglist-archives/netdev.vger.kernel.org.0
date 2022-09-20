Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E08B5BEFB3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiITWHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiITWGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:06:51 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751847820F;
        Tue, 20 Sep 2022 15:06:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7R23xjGPhjbcGXleScsVvmOTGfgTdfjgLxkdLy7KwoBWS08U52/U1talwfMmnNXE2nYIVcryVTXLHOIGJVl+QfBr43/xuqDiK/JFaOGFlsh3bAJ5R3eQvv3bmLFHnLaxkK3/RGrYvAbqb8uBkFsuod5IgF8+fwpQb9BVBvGk0DFxImPjuca70AA3EPLc+ayMqNKqLc8gr3y3ZvQoiUDXQRmsdv1npG6sTtrQz8nA4kh2w3+NvmUPef7nz4ArdMwdzuIWAKsXJSt/f2l7tXV1FGIfvmh46PHqS+884PWGW2uM/bBW/e7QnxUwFKCb/+keZ4iXMrsF9xgyTfZA9Hw9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QaAxNSlTiKBwwQ/4LJEYtxRMXykVYuDVb11YsWzfgvE=;
 b=UgvitBNd8zbe19XcJ56DFAqHwIQlhTF5tigCeyNGncFLVr9559lj1sGRyq4qnIZaAjp8am4Dxf2LAwiF4eCyjq0oQ5Rkosls/alW4lITBx8kRjozML5AyPGacVeG/w5rM2pcQj/Jv02HSasKXvEuGUDxAd/lIEN+PDHeIkpEFNET1KsDY4H4MgLyMA9N92mvK4O5KiIknuTJM41WspLQBBDzKUXi717CVA0YTJJgf41WHC3+6kBNKTgXd9rt+gA1Y+BGsyr3P5i+Y/IQLUzPUk1eqhm3cZ8/b41Pm10UnpNeSDeBW+IRQMb6y1uP4sqpytHKgIsAsmnRfIlFPdV6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaAxNSlTiKBwwQ/4LJEYtxRMXykVYuDVb11YsWzfgvE=;
 b=DrJLckdSo1zvg6nNs0Hwx7nwUdxM/yR2E2Us68fuX2MZMlUnHjaGp6D8UHTfXTwdBtJUsZS7Nm2WvSlwtXaYpUX2WW1ukxVc4qgapUlBYB2OdEhZe3F7VCwLGFPLsBP4AC0opYsX6uIeVzMFIlwHxWz05zp4o8OEIiBQALA3v6Q=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 22:06:46 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:06:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 07/12] net: mana: Record port number in netdev
Thread-Topic: [Patch v5 07/12] net: mana: Record port number in netdev
Thread-Index: AQHYvNF58aPa63wHPEiDdKzgGmtINa3pANAg
Date:   Tue, 20 Sep 2022 22:06:46 +0000
Message-ID: <PH7PR21MB311617423EAF055B8BD4F574CA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-8-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-8-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=683ec7d5-564f-4a10-ad3e-69798cb7c102;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:06:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: 004a7506-a8a7-4c40-7930-08da9b5468c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B5FDpoN0NGd9mfcC3XwfFn6unF/pwRqT5EyPMXi1KhmvRDc1Hybg3cqekBOZMQUrfcpy7x8hJpnZtXQyJzdjO9i+D8WtMlkC90ZB0iSplhRQ6u5jQKu5vNfs61rqrQoi5q3OTGqP5+g+k2Y20FpNKK2AfhUEq4/c2DrdXSprZWzEJkbvgeddc9ZhVLNlogx9OjxZt6QBRe1u7KxPBNaiNm0AIdMrliuRvPUelS5Jp15JuOXFFH3mAVqIhl6HpvBtfvHWtL5JR87snElUTApNtcs32Ht96xPNXN43j4BgpyAcZ8npb3sBUEbTW1Db4UBB2pNQj6RNydHTSikRm3b6ZO1vZtN8fp8Pv6bqQPyXRUrozK5Q/JXiyv1cL9XZZ7p36LXctWTydlCrl0deNryKrl7XA4dg8O+OKQt13uhlWlRzWlIc8cnCUFOJMYeufseWx0jOVFF1noyL+KxQGqgkzrQOJGOYgupsoFTWSqXFBdpMfnghbIbiiRyplrqzc2/bMTZCBh+SYv8/8Z2do0bOR0AaZyP9YFvqvbQKlyjdmQUN9JhlfLDwv1R42TJSFn2zKXBcYEMav7F8ANGsbrx+fqWCoIfd+LXHteTlI2cEhPbe1hcNh2R07p/1jkSuqfx/sUZPjHHRrk4t/yAOY82UQv0/YjGwFgyLzB9/zcaUZAwetGup5hOYCSru0A2Swf6SyMTJvSwJSGDO2gXwzeZu4EE0NI2J8gYpJkpn/3gyBGKAE4wcIOGxgHiIQ67izpIvSgKgcDfjTkVtSvyU08EyWr2YC+yj97CkpU82nroQZi2uOgTwZDwIqV7qioF3BibUQfpRCpFgjfCDPtVmjOAYRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(8990500004)(921005)(38070700005)(86362001)(122000001)(186003)(83380400001)(38100700002)(76116006)(82950400001)(82960400001)(6506007)(2906002)(7696005)(53546011)(9686003)(26005)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(7416002)(4744005)(8936002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8y2YBTLuEFGjlOWnb6fMkFfHrTGn2FnIGzGuYS5Qp7zZ1SAHF8x64oOcvXw+?=
 =?us-ascii?Q?QZmB2D91Mfl275vBqfP17tPvRISrcNz8QDOLfOU0P6FemtAVkgGnqZ4EuH+x?=
 =?us-ascii?Q?1tQ7+2b11uGt98drWTro7nsGkAn6SzVDTr5wGHKm3WnvAzYw3NYiC3oh9YTi?=
 =?us-ascii?Q?MPcz1PZjIsXhii1u38lcnuuA9zMbbFobz3lF/hlVMTPEXrdbEPPOPjV/USRQ?=
 =?us-ascii?Q?wj774IGHwvk2cBA21N74WAkyC91Z5mo9S6f9btv3ryxBWSYqn8OcCPAVtlQd?=
 =?us-ascii?Q?K//NGb2TnAoQcSE1HYs+R+pSC1uiQfvG1Y5zX+EBYzwBcjOBfQZpqfifEpw2?=
 =?us-ascii?Q?pXiToQ9eXHaaJcmxLlaYhRhfBeaYDIM9MRMUx+NdyEvZAC5+u5e0mgSDls7k?=
 =?us-ascii?Q?oQEtKKajWo1tGyIogXFVnpfqa7t3Bhzp4mzR/21tYyCWX9vOeUcFG+XUGoA8?=
 =?us-ascii?Q?YiMIkuNMr72ZZzvFA/YNI8q9pBbH8xhQLnbjYLat1/uiuZJ10B/rUrBFZN33?=
 =?us-ascii?Q?Txa97TlRaFolsAUk3VHyE0T9dHDmeQFHMBx+SLXVa2mbeVQJ47RuVPzF5cIo?=
 =?us-ascii?Q?M4vJ+hYIqmHKt7rUBxssSAdy3F/nPoXZa2vDnpBk71uTzNvui0KlleTA587K?=
 =?us-ascii?Q?oRfkdj2j2g1n0bkL3nlafqtIwpfm+qiFDaV+77m3zrIzQloRuJs0phtkzFIz?=
 =?us-ascii?Q?rpR1zow7CxGOfbSgaVuWInFkzclJktO3tmB5QuNVcYxxhkentrb0U0ZPbbx/?=
 =?us-ascii?Q?fsXqN6zddV2PsByoZsC+F11TICrCxfhgSo2VDiVGAcY5OkOvJ4l/ePPWPgTN?=
 =?us-ascii?Q?pVKoKhgkWWQUiJg2/EN3PrsVGGdsX88u3fy1YupN0gDF/18d0Fh2A7c9Aen8?=
 =?us-ascii?Q?dQBknaLc7jmP/QpLKbhIDyWZ+RVvoYsU+i01wvqy1eQj6x6vKNXxwaFDWZ+f?=
 =?us-ascii?Q?bU3G5l0gVJQVLxJTu1sPOGbXXBVCdGr7IgBdm4GDdAliPVpkp/mlNCDMCrK6?=
 =?us-ascii?Q?eW0HWJXADNy38bO210jNz69Kv/SISrWWXbHcluxj/TRhQcTS6IzXEehYc7Ou?=
 =?us-ascii?Q?T/JWGwF/yskpDMjrJJZIWL0C/lkfMggbxEY8T44MeysHqOZixaHsabLrHw2Z?=
 =?us-ascii?Q?HXB7omK/Xl0tB0BH6RuY5M7DX37Ubls0MUup3HyGLlxL6eiAhT/qwmWtUhFW?=
 =?us-ascii?Q?JCl3iQcOKUXHluJJq3HJJu79FS4Fymdb7D+ZuKskFFTMr+LzNlLAeQNekTKq?=
 =?us-ascii?Q?2agCTODMp0qqE+rsHf5Dss1H9TCNVnGjpvBAwJXwOzDCpM6fLA5WgNe+aPY1?=
 =?us-ascii?Q?YZYOFzhFIH08feYmB9gg5k6soxGwpQgYBmqBI85H47p2wZYvIElHBXwSCnDz?=
 =?us-ascii?Q?Qak1+ssxF/UvMS3a8CcG7RRt6BROmsi0TTMgEGfCVzEWLirRmP0YdxsI7dTM?=
 =?us-ascii?Q?UE8Q63JSr3LetykDRtYBZOWMkCZmm+ePjWD368CNT+yp+PFBoGC7Oz3INju+?=
 =?us-ascii?Q?HNybPzbAOLFzizJgnR8QT30/QwyveQ4X7QWfKDMmHK/DqmGuP5N8rMmBW9b2?=
 =?us-ascii?Q?fLjgQALMY5X+if9qwmqNNLufkzAd+YHxjKaJTUI8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004a7506-a8a7-4c40-7930-08da9b5468c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:06:46.3143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkfhEACEu/+yImmByjaPRQYPe1KzsuTUcwY8UbqNaGxmGFy/pfSivKJsJDyHswZ9MPI6B3S0T2E5Yu19ZbLbcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 07/12] net: mana: Record port number in netdev
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The port number is useful for user-mode application to identify this
> net device based on port index. Set to the correct value in ndev.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
