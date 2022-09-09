Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F55B4192
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiIIVmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 17:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIIVmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 17:42:52 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020014.outbound.protection.outlook.com [52.101.61.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0AD13E4FA;
        Fri,  9 Sep 2022 14:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4+5pnUDfESoZFE/FYd9WXcvH+49U0tfcz/CZbN7Wbo5kaXgfgbS80Gb/fgIhP2GtXluBl2NK107BrU+QoFbxZMfIllpKKlfNaTeQIKqCsjTb+38tt4H2pfxaUi7RAg84K0sZWpNkEp1NAFwVI3vi06J7CL5sPG0+69NUs1ZuU6pTw54WXQ46qA/9W4n4aiiJp1zRT6zf7zDpbRHHdi390RdUYWNutKqCU2AOci2PgNN0IGmm0ZlU8wknxh7ey9hEE9Om3LzSUUNOcrLGNcod2GNHKm8zo9ZEn/WDD+fMmaVC2ifGIdTE4v5h/nLvLOazuz5lXa+pazAnBP2STzJEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/8Oat9vPDzYM8KXp1mP6m3Tl1UP9z3HtDom1q7lj5E=;
 b=RPD5cAow7DfKAVmQItezXRdbXcqRHFmj8ehNKD4ethqTM6fAiIAbeQJiqOhGUFiQH8Cn1i+oiiRg39csXQdmB6qTSEwZy6lVxD6FIe7fpDx4m/akizNKB54NYgRdLNO7s4hvu9hDkYYt/piIvLKif9LKViR64jNtOeosGiXP6Ll2JhQ3rjQb/Pz6eG+WFj6ADRep+Rs9x+lUYf3GGYT/kxP5I/hob7XLXqJXBt84bIKsdcJsUZiUtVZjwqG6ExB6aWXI8PIMKVnIDYCM0jZ277iyW0EEijAyuJiJvy1XV1GPYZnvMQ09SiDiHNtEd287d6dspayanggm966dYD7f1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/8Oat9vPDzYM8KXp1mP6m3Tl1UP9z3HtDom1q7lj5E=;
 b=KTL9GUC8zdAt/uii/U9fUyRRIH2BmaLzUNwfN7WQEbAsC9WQtnR3YdkkHdFrRiAVPGnRPIYWxefylmZwNLKIYZ6TCSqTtkYIO/4rse3NRLqjRilAkafE4YkUluSP3A4QlP7cn2HJY2iqglA6nFt1Gr1UJ3zQZnPDIlND9P0frPg=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by IA1PR21MB3448.namprd21.prod.outlook.com (2603:10b6:208:3e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.4; Fri, 9 Sep
 2022 21:41:26 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c42c:5004:23c1:bcac]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c42c:5004:23c1:bcac%8]) with mapi id 15.20.5632.002; Fri, 9 Sep 2022
 21:41:26 +0000
From:   Long Li <longli@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Subject: RE: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter (MANA)
 RDMA driver
Thread-Topic: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Thread-Index: AQHYvNF32YfFj4mQP0Kq8nuSG5RJoK3Xr6rA
Date:   Fri, 9 Sep 2022 21:41:25 +0000
Message-ID: <PH7PR21MB3263E057A08312F679F8576ACE439@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=89d760da-2b3a-4015-b67d-e8bedc90c3af;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-09T21:39:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|IA1PR21MB3448:EE_
x-ms-office365-filtering-correlation-id: d9bd8d65-a3c7-4cab-8aa7-08da92ac0c0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1uiuhWkaMtbFf3us5RpX0V13JCA1qcEFln+QZZokEgbVoZJm2a/spdeCLvCPp5LW8AcrMG33NXSoYlG/jYU3Sd3GCZytGKblIIjJpp/UVPPSDMwvq5wPgS8RTX2E/cIaoSgIFGBk9ThCSjIGZklCmcl3HUJyxgC8qPPguDA3eYlQGFBanEn4EuMsVrqjADxYx2ZbzLZhr4PjATZ9G5vfQSPi6blUT5pJBt2kb9cIgJOCmWqQxnF1l9KJRjEwh5833pHitcupYioPGaPI/7kTStEUFFak3Fqdo3M1aIUcn9ZyRyYjoGuv0IDp5WOa1z1ut6X0NUB9fCC08hYksk0fjNN1S5JxzmPTy5RrPFPktnKyJ495VHI24U+EvNEitevsztprY3/f5KnT+Fs2M7sgDtBefG9BcetwLyoj9vkTudckaQ7QLY1BO1wbJpJNkFmbi215Dd7HzjDoqyFtKmyL6fi9JRHOhK7YqKwmpkAeyo8W35GGejHR31iknoe+JOWCZo76hrV4wWwA1xybYcyymVGP/VzaBOvBty2IHjBC+BPNV0fLWQzD3600+H6sXQyyvxRTnfruRZv4TQ+CJHdPGCpvJRimw7fTSpfw4C+RZ0kc4IsHizDUTLYDf9bx95aF4mes1CFNe7cKJWFTQDqqkGCzRr1EkL7yB+L3DhUHcUKTEQ9FF20eI8ZcLs6MnHbQYO6Dv/WnsaHaI0QSeN7lJdQf3sJKa7iIRDh2y+Gi9hAOP0hC/AOjMvghd0RRQ1r6bo3D/fZ8YOo7hdYr9WYQwg6lcnYwea38jUOkJxKDAk+OcjqqRIbsCJf8bbnj3u7iuwgJ86EUJfr0FlimCemUFP06e2JwZan2hLJDcU/zDlY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(47530400004)(451199009)(966005)(5660300002)(76116006)(66476007)(4326008)(86362001)(7416002)(186003)(64756008)(8990500004)(66946007)(66556008)(478600001)(8936002)(52536014)(8676002)(66446008)(33656002)(41300700001)(6506007)(2906002)(122000001)(10290500003)(9686003)(316002)(26005)(6636002)(110136005)(71200400001)(54906003)(55016003)(38100700002)(921005)(83380400001)(82960400001)(7696005)(82950400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H2odhy45iUX0zoUw5KM2rWOnHmFNUJ6ipttscqcBEuczJxkDEDU1oXVxtJN+?=
 =?us-ascii?Q?/tPc1aeZGVy+j/j02oZsLOdpDYmerm367f4Im8jyeoUlLCd/HCZZ05k5seor?=
 =?us-ascii?Q?rxzuOxZw91A7HXABV2uQVAh7ExnnEIAUL4FIZS0QHSZHIzRpZnJEWKYyPgJj?=
 =?us-ascii?Q?2BVB64qEyOAHRcSFBtO9HV3g8a1aVf/eEBRdKDMTu7+zmaROJJ9b04iWgEF7?=
 =?us-ascii?Q?PCyg/xKpkqXiBmg8VsI9x+3CrSru7Hv2vmvtY6MyjtT42dugxWTr0B8lxhft?=
 =?us-ascii?Q?09TXYUyB6PbjqQRMIMhwfT5Se4GT428g1/1kvRlmfqSXAGGuzWKsj478szKN?=
 =?us-ascii?Q?QG9P0o0yoeXZPZ2/SNeXsWDzV6UMYODn5GrI6hBdD9NV82fBnKwhH9PZIB4B?=
 =?us-ascii?Q?8/1KtJYm7nrVdPuG1sdVQikkErYfGZF8YZTrA7LLVQcfVGWqVaHxR5Aww2x8?=
 =?us-ascii?Q?ejuItNRlfTRY+IZ1TeegVKLdU2GeI430NTsewbNrk+tRj7mdpQLpNPoHTbjk?=
 =?us-ascii?Q?plD1k+BsNHlggrb805cHXKhHf2w1rUoF5j1NmKiXonvcFDtuc/Dd611bUMeU?=
 =?us-ascii?Q?D787Bi5Z5W8KAmjgoSHd381kWhmQpzV4Mqf/oXgidhj/EOA5gDcZHlMKvXpJ?=
 =?us-ascii?Q?llbYC/z1jY8xhzRuYpQTaAJQYBRMGU+H2dX80vaAs1UMwdZbcmHvXnjSz9Dc?=
 =?us-ascii?Q?wmx6XsHms2KjvSWKiNN12u6CiCcwllBdpwAjlCy2ei1ktYDF5CWwBHhduHjj?=
 =?us-ascii?Q?mvuqcyNR2Tr3waCO3Z6yodm1oMUl2iYUT0Sqmmqf78Y/GeUO+w1Eks0PNdiG?=
 =?us-ascii?Q?0bFeM9ryR6rU4AAMTuSKYvyhqiT1bx4Vn2qCA+uu43UGREa4qhC7gUnNASd5?=
 =?us-ascii?Q?H8VyYqnEE5fppSDlmniUhFdFvsbmQU60P0UK9J9ttmD7M1L5SiUWe6XhVRdr?=
 =?us-ascii?Q?c9SyBREqot3Bh2d5oMj+VzFHLcBRsGwFiBQ7Z4ZjZ+v8Rigtfy6vaDrcc6hG?=
 =?us-ascii?Q?h7mD0EWTmz8p4H0kJBIjRyOBNZuo/fUwPKMJF3rUeVjv86LldHrd1g9o173N?=
 =?us-ascii?Q?yotvPaoRSJp6Vxop43AFXyhaOIpiJddZB+mRe52DZJB7N0Jh9XRjLoKq0Al8?=
 =?us-ascii?Q?8dR/WbuZTmSFzfjy9YSqfaZcUr0F80CcQcEPX+2BrqedeGp0hbIiNUIiE8QT?=
 =?us-ascii?Q?So+iH3wEaGKP9iMhESWMKdu2x0FZgY4OP1g5yxbA4mx7zx3MF1/QZIjUmC/t?=
 =?us-ascii?Q?qcuE5gTsiVaL/IpvRnSeJ3Z5qzr9Z67qCkKZDLuu8gbJGzJAej+u3JDZzJZu?=
 =?us-ascii?Q?bd0ffLEb8ClQOCTHSCf2Gtz96PlwGFpbYavauWrE8rp0erhmlSZ1IbZ5RyOz?=
 =?us-ascii?Q?FyJIL9iL3DvbVjtHs+yt5vZMu3bfa5q55Bs2LKWiZH6A52Y0gpsu2XyvByJv?=
 =?us-ascii?Q?iX0dqj8Ic90HT/tQkt+qewF7Voohf2EdDSrjpD/7K/JNrXDFEMsNxOz05fGQ?=
 =?us-ascii?Q?Srny9HwuNG3C9ecNN1g5JOHyOx5i9sBxhpCfqmuSAWCekW/Nv3eVGvxXn94h?=
 =?us-ascii?Q?vPSJhPNYn8FFKEs7GwwU828wfVjOnDVJeNeQsxVF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3448
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
> (MANA) RDMA driver
>=20
> From: Long Li <longli@microsoft.com>
>=20
> This patchset implements a RDMA driver for Microsoft Azure Network
> Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary
> device to the Ethernet device.
>=20
> The first 11 patches modify the MANA Ethernet driver to support RDMA
> driver.
> The last patch implementes the RDMA driver.
>=20
> The user-mode of the driver is being reviewed at:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> ub.com%2Flinux-rdma%2Frdma-
> core%2Fpull%2F1177&amp;data=3D05%7C01%7Clongli%40microsoft.com%7Cc1
> 6f986dc7c34750c1de08da8ae896d4%7C72f988bf86f141af91ab2d7cd011db47%
> 7C1%7C0%7C637975028849495970%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> 0%7C%7C%7C&amp;sdata=3DVoflZKD8KVbKxpv%2BH8w4rgsrlOlv5NAjul6K6fuD
> 9jY%3D&amp;reserved=3D0
>=20
>=20
> Ajay Sharma (3):
>   net: mana: Set the DMA device max segment size
>   net: mana: Define and process GDMA response code
>     GDMA_STATUS_MORE_ENTRIES
>   net: mana: Define data structures for protection domain and memory
>     registration
>=20
> Long Li (9):
>   net: mana: Add support for auxiliary device
>   net: mana: Record the physical address for doorbell page region
>   net: mana: Handle vport sharing between devices
>   net: mana: Add functions for allocating doorbell page from GDMA
>   net: mana: Export Work Queue functions for use by RDMA driver
>   net: mana: Record port number in netdev
>   net: mana: Move header files to a common location
>   net: mana: Define max values for SGL entries
>   RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter
>=20
>  MAINTAINERS                                   |   4 +
>  drivers/infiniband/Kconfig                    |   1 +
>  drivers/infiniband/hw/Makefile                |   1 +
>  drivers/infiniband/hw/mana/Kconfig            |   7 +
>  drivers/infiniband/hw/mana/Makefile           |   4 +
>  drivers/infiniband/hw/mana/cq.c               |  80 +++
>  drivers/infiniband/hw/mana/device.c           | 129 ++++
>  drivers/infiniband/hw/mana/main.c             | 555 ++++++++++++++++++
>  drivers/infiniband/hw/mana/mana_ib.h          | 165 ++++++
>  drivers/infiniband/hw/mana/mr.c               | 133 +++++
>  drivers/infiniband/hw/mana/qp.c               | 501 ++++++++++++++++
>  drivers/infiniband/hw/mana/wq.c               | 114 ++++
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  96 ++-
>  .../net/ethernet/microsoft/mana/hw_channel.c  |   6 +-
>  .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 177 +++++-
>  .../ethernet/microsoft/mana/mana_ethtool.c    |   2 +-
>  .../net/ethernet/microsoft/mana/shm_channel.c |   2 +-
>  .../microsoft =3D> include/net}/mana/gdma.h     | 162 ++++-
>  .../net}/mana/hw_channel.h                    |   0
>  .../microsoft =3D> include/net}/mana/mana.h     |  23 +-
>  include/net/mana/mana_auxiliary.h             |  10 +
>  .../net}/mana/shm_channel.h                   |   0
>  include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
>  include/uapi/rdma/mana-abi.h                  |  66 +++
>  25 files changed, 2196 insertions(+), 45 deletions(-)  create mode 10064=
4
> drivers/infiniband/hw/mana/Kconfig
>  create mode 100644 drivers/infiniband/hw/mana/Makefile
>  create mode 100644 drivers/infiniband/hw/mana/cq.c  create mode 100644
> drivers/infiniband/hw/mana/device.c
>  create mode 100644 drivers/infiniband/hw/mana/main.c  create mode
> 100644 drivers/infiniband/hw/mana/mana_ib.h
>  create mode 100644 drivers/infiniband/hw/mana/mr.c  create mode 100644
> drivers/infiniband/hw/mana/qp.c  create mode 100644
> drivers/infiniband/hw/mana/wq.c  rename {drivers/net/ethernet/microsoft
> =3D> include/net}/mana/gdma.h (79%)  rename
> {drivers/net/ethernet/microsoft =3D> include/net}/mana/hw_channel.h (100%=
)
> rename {drivers/net/ethernet/microsoft =3D> include/net}/mana/mana.h
> (94%)  create mode 100644 include/net/mana/mana_auxiliary.h  rename
> {drivers/net/ethernet/microsoft =3D> include/net}/mana/shm_channel.h
> (100%)  create mode 100644 include/uapi/rdma/mana-abi.h
>=20
> --
> 2.17.1

Hi Jason,

Can you take a look at this patch set. I have addressed all the comments fr=
om previous review.

Please let me know if I should make any changes.

Thanks,
Long
