Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BB455A6D6
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 06:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiFYEU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 00:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiFYEU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 00:20:27 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B8F52505;
        Fri, 24 Jun 2022 21:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOcY6E4IDYzmVdd1zVBwDytu9PnqFfzzgfsrnDgOmJC6mDXJMwy4RrPXsWKS+XHWW4pO7bibVoQp9xFF5qNcAl1ger6vEvOepR1a6EGMpAu+EU8r3tgZK4shKtWHZW9AGV7/5yNzVWtItrtq3ojI3dsWpyJOvRlKVA4u3KAgctPOVB35/s4b/pOXUuW/W0VbVaABj/kGWxW3NsaurggzaP9uTOrCDFoHup88EXBDG7i5WnjhytsBlX1bInSVeRRk+9Y6B3kjW8mSnQu7ifEIyqFxHuly+MHqsmrfo3M+gMv2VfwADpuhVTjfaoMOxAnqGzWKZt/+c/N5kexwxGVWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhmQJB2ITwhrBfVV8uI0nWD0UgGqTpNjjWHvi42dt7w=;
 b=SthOzkO8zO9rGyFyKPuiAA0rCFIavS9FoeFe2wdCaoWbUDrgewf8zUZ2nitpyfvjT+OD8oyvCHcPkOGjMJdGCQHM24uDs1287cpAi4V+FzvDMfHHXl9Pikmw5ttehdMclDvaiCbTwZCMUIJScacbYbNn2fUULynGNtKk0wwHEEdInZTAMR2Fsr85JHv68I1RKRFvZ+JK3PnlL4kjsi3Tgsss8Y3njG8E71rnPoViAOyFuYckix87HcbaU5vpKR53C+9tiMBhOadkEGr73u7/wNCIHWu0NSjnNpoqMw9ZJr4HkF5Ju1e44eVHerKvmbBP3IAxIURI/4VX0b6wHvjCnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhmQJB2ITwhrBfVV8uI0nWD0UgGqTpNjjWHvi42dt7w=;
 b=VRgz5rtQBVHRngN94lVs2SMGk0IJ94NeKY2W4hYRWg2xvfpH6+ISDueaekSmOT3XMe1Dp/+tsttJYfkql9Luf++/GRRrczl3hsntbenrHjDAOpK7pSySSWBgk0oeHDB6Ml2czTb9NrQnFy0Xoyeii/0q3lbsLXdjaDPdxYX7oxo=
Received: from DM4PR21MB3296.namprd21.prod.outlook.com (2603:10b6:8:68::17) by
 DS7PR21MB3078.namprd21.prod.outlook.com (2603:10b6:8:72::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Sat, 25 Jun 2022 04:20:20 +0000
Received: from DM4PR21MB3296.namprd21.prod.outlook.com
 ([fe80::700c:f00d:3d7a:dc28]) by DM4PR21MB3296.namprd21.prod.outlook.com
 ([fe80::700c:f00d:3d7a:dc28%8]) with mapi id 15.20.5373.018; Sat, 25 Jun 2022
 04:20:19 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
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
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [EXTERNAL] [Patch v4 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Thread-Topic: [EXTERNAL] [Patch v4 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Thread-Index: AQHYgSXbCk9QyYgyEUGtYdxv0K4eFa1fkyOA
Date:   Sat, 25 Jun 2022 04:20:19 +0000
Message-ID: <DM4PR21MB32967BB85B7B022671ECADD1D6B79@DM4PR21MB3296.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c3587175-83ec-4f2c-a35f-c394ff7b4b9a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-25T04:19:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97ad2eb2-df15-4d52-59ae-08da566203f0
x-ms-traffictypediagnostic: DS7PR21MB3078:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CIRvUwNKbILesBAiqWHkY9CVzGOr7XRhTDM8b+sRbSW1u8/ugfu/iHJZ0O5n97O6UodbsrLgWSV5i6jwgiOYIsuaCbO0sWaQZgkZyb+A6a00PO7n425EFAdlcFty4fKszAWjFFyT5xj6foQ7ZXY5lRVup1MmOmmfXZyONqGhy9qEUc7VyVHXfQzq7Y+XcmrCXImQIzijhOSGvc8G1qDErOenMOFn5kBcCOJkRpa4Xfri/BgtegdinJQGU8SZeBloeCSWWBDiUM23nefDkbxZLzauvU1hspgrEmxH5cV8k2ZyOfQVXnpVcXmQLNU+7qxLJo8lTcoaq4ndRJUI85tv7b0xuht5PCvP8KVpIoyC727z331DttibJnlVSm89LO/bTzCEUgp+hqjBHRhS10/8ILc7lD6inoYA1M+o6lYB9va6wiZHjywMXrEGE7jsY3eJw4YSxLKO8SCwUGfvuSkWPofkXdtXvT0bJZvMR024fNmqeGGWxjNInsQWmoiVxTcgj+buukO8lgk2gPzVLnT/oivwuGl1S3slWdJN6YasrkvEuIOQXYrL5Y9fVm22u8NR+M60Hpd7Ph0qPUJGtIv8wi5jP3FCVcOLTdJzm7jCP2Wl7N3hbkZe+NvrdvFWF8H0q78oZhFcowF7tcA9L1cLIUkp9cl8x5cu8/tFtW4Qjwr/ur9E8ClKmH2XzluD5DlKuujNk2lFJbw1XwIxVK8VQt756I7mr5K1xihQtPWLY5QrENgzznEiyiHNgPZxOj8VtMFOb2sqJJlFTHifIBYwgYiQYACvckJzRt8Kn/ieeWX5jXicY0mcrs3eWNpm4GUpWLVqJGrGaHK4DxLKe1A+q6PhCtMgnVBVm+LEBGKsFfLlBBx4Ofvs9n0/0Y+HHrb1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR21MB3296.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(47530400004)(451199009)(110136005)(71200400001)(55016003)(33656002)(66946007)(66556008)(76116006)(54906003)(86362001)(8936002)(186003)(30864003)(66476007)(66446008)(8676002)(107886003)(5660300002)(7416002)(52536014)(4326008)(478600001)(38070700005)(2906002)(316002)(82960400001)(122000001)(10290500003)(8990500004)(921005)(82950400001)(83380400001)(38100700002)(64756008)(41300700001)(9686003)(7696005)(53546011)(6506007)(21314003)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y8vccL1kPsZE01mG051K5Opu3iVDOtwkN/7v1M4nMy/kYNHQlAs2cYw0GkF6?=
 =?us-ascii?Q?Oa4sKcdy592xWjRgJ/nUh0l3KkFnVzGefzyD6AKXr0hv2VH3TYT9mr+JKeQe?=
 =?us-ascii?Q?JiZKJfhPrpYjG9K/XTwN3JaZQjqpT3fqGW/uYsQc2rNxPd56J/109UVotdQk?=
 =?us-ascii?Q?Zr57PCbK0eWZlo14K6yjnEobRmgNOJLCmOd6in04eAjypX4S3AgkPVlElNBf?=
 =?us-ascii?Q?Nl8uxe/dnPMSqGabYfVgnHCnjYJ71cEzPDTZzZQX4vw+topjss8cSab6F4jX?=
 =?us-ascii?Q?pnmXas6KTNkl0MqqN0XZc7ns1GMGLajH4uXeuWenG784/sXqao4q4UcTiKpw?=
 =?us-ascii?Q?tGg8e1BpDvwJFzptslmp6LRvJ9w4WwvYwT/MRb9/Q8l++9M0TyIEDQWJjEQN?=
 =?us-ascii?Q?tzn6Jasb/kmtnyj6k3/dXTKBymMM8o3HjTAErkRKhOHMAcJDHPU7xhDduobu?=
 =?us-ascii?Q?yCXIm4evva3Coks1ISboZQlBlasJOta8U3x7cZQuwri4FrGt6T+jOlC6tjup?=
 =?us-ascii?Q?YHLgcJdQypZhFoJWGAddP25Q/GKovgQijsyFk1hDJqb3vWatHRNEaN8wTP4E?=
 =?us-ascii?Q?jvgKHDyCtbGt5f75IQXZ9H+lgVLnCFA8DfMSJI/O9B5M5PO8kgGsluuluJuR?=
 =?us-ascii?Q?Ue4ZFkkPHoX/A+qUb0sUvanRpHCKM7r8j07EMZiPwbEWpVhScgC+/aOew8PW?=
 =?us-ascii?Q?AjKcI34H1zmSas97wW+51b/FKEnRmE8sQGNz5wQlO0QZD5ve5NhH6Uca/Fq4?=
 =?us-ascii?Q?ml6RwMfJZrtZet1cbS9dxyQj3CA6n1mmPfmCmyJc08e0ke6DP1C/UIliyza1?=
 =?us-ascii?Q?/qB1iTV1bsXapHv15Cl3wZIXXKn8Hx4k6kWRBNyLu69t5efa5rVerV9+uV/2?=
 =?us-ascii?Q?Up9bfi75ND5Nuebz1EunFKxv2SVjnHBh99KlAmTo45V72yF1+dauoAQOm7zn?=
 =?us-ascii?Q?3m4NUGG3mtE2CFMTeHLYOeoCkHWj1KvEkyDIY3e+WlggmczBLthKJPZ/0toT?=
 =?us-ascii?Q?HxnOJGVAQNafiNvrassVlMTBjMOCrQ51tlRkORxFEPP7x1LFF+bNVwaQQNwg?=
 =?us-ascii?Q?xvxJFCYL4eupSPKWrsFILeXcGYVAk6/ScAYy1t9eKuLtGg1wV+k/pRKj2tKv?=
 =?us-ascii?Q?OJSTncW+H/o6qF2lSBmBjmjdGJTVk+QVl+eVsTjXvA9cBOJQ//mOAObIH46b?=
 =?us-ascii?Q?Pjl91sWUuCLVh8kUj415H5jFeKbtPOukfPM/4EM0Z60necfgQQ/Uxg8iDO2u?=
 =?us-ascii?Q?519+suzkKWSi2Ygekvz/9M7/CRIEc6aAlKMsLA9KlmsHO3GyzumG5/9rkNiP?=
 =?us-ascii?Q?QpoGmQTRlQDl3JhDUsDkFatl0s7ky8KUKIzOo2DN+oeZmbbk5bmQeg1IalHn?=
 =?us-ascii?Q?3eQMKg65pKsqDU8s2f9IKSb23+9wx7WBxRHsJh7gTlG/JtyJtMkAlQWGgkuB?=
 =?us-ascii?Q?RZYVMHNVxsTq1cpDR6zYX/v7C6U1n8hvhpSVhdHq13cd1NM511hDC8ZdTt4D?=
 =?us-ascii?Q?W9C1u2u6iUflpi9ndNBe5e2HW182xfxAZ8dh1CxRmS88UfDMFuZ94duJ7lpe?=
 =?us-ascii?Q?praZcaNI6soc3RTeOUz9KwSWY4LNOxGGgubB3J+x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR21MB3296.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ad2eb2-df15-4d52-59ae-08da566203f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2022 04:20:19.8589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DsB+/dLXzxqnSbkcQ9bZ7bM2x/XccE8QDHx4uW1h70X6p10Kiahj0EsamArBi7TKuYlvDxhGanV8COkbFC+AlxEbqK33ojBE4EaUCm5Xek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3078
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maintainers,
 Any idea when these patches would make it into the next kernel release ?

Ajay

-----Original Message-----
From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>=20
Sent: Wednesday, June 15, 2022 9:07 PM
To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.co=
m>; Stephen Hemminger <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org=
>; Dexuan Cui <decui@microsoft.com>; David S. Miller <davem@davemloft.net>;=
 Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason G=
unthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>; edumazet@google=
.com; shiraz.saleem@intel.com; Ajay Sharma <sharmaajay@microsoft.com>
Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger=
.kernel.org; linux-rdma@vger.kernel.org; Long Li <longli@microsoft.com>
Subject: [EXTERNAL] [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microso=
ft Azure Network Adapter

From: Long Li <longli@microsoft.com>

Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).

Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v2:
Changed coding sytles/formats
Checked undersize for udata length
Changed all logging to use ibdev_xxx()
Avoided page array copy when doing MR
Sorted driver ops
Fixed warnings reported by kernel test robot <lkp@intel.com>

v3:
More coding sytle/format changes

v4:
Process error on hardware vport configuration

 MAINTAINERS                             |   3 +
 drivers/infiniband/Kconfig              |   1 +
 drivers/infiniband/hw/Makefile          |   1 +
 drivers/infiniband/hw/mana/Kconfig      |   7 +
 drivers/infiniband/hw/mana/Makefile     |   4 +
 drivers/infiniband/hw/mana/cq.c         |  80 +++
 drivers/infiniband/hw/mana/main.c       | 681 ++++++++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h    | 145 +++++
 drivers/infiniband/hw/mana/mr.c         | 133 +++++
 drivers/infiniband/hw/mana/qp.c         | 501 +++++++++++++++++
 drivers/infiniband/hw/mana/wq.c         | 114 ++++
 include/net/mana/mana.h                 |   3 +
 include/uapi/rdma/ib_user_ioctl_verbs.h |   1 +
 include/uapi/rdma/mana-abi.h            |  66 +++
 14 files changed, 1740 insertions(+)
 create mode 100644 drivers/infiniband/hw/mana/Kconfig
 create mode 100644 drivers/infiniband/hw/mana/Makefile
 create mode 100644 drivers/infiniband/hw/mana/cq.c
 create mode 100644 drivers/infiniband/hw/mana/main.c
 create mode 100644 drivers/infiniband/hw/mana/mana_ib.h
 create mode 100644 drivers/infiniband/hw/mana/mr.c
 create mode 100644 drivers/infiniband/hw/mana/qp.c
 create mode 100644 drivers/infiniband/hw/mana/wq.c
 create mode 100644 include/uapi/rdma/mana-abi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 51bec6d5076d..1bed8444786d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9078,6 +9078,7 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
 M:	Stephen Hemminger <sthemmin@microsoft.com>
 M:	Wei Liu <wei.liu@kernel.org>
 M:	Dexuan Cui <decui@microsoft.com>
+M:	Long Li <longli@microsoft.com>
 L:	linux-hyperv@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
@@ -9095,6 +9096,7 @@ F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/clocksource/hyperv_timer.c
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
+F:	drivers/infiniband/hw/mana/
 F:	drivers/input/serio/hyperv-keyboard.c
 F:	drivers/iommu/hyperv-iommu.c
 F:	drivers/net/ethernet/microsoft/
@@ -9110,6 +9112,7 @@ F:	include/clocksource/hyperv_timer.h
 F:	include/linux/hyperv.h
 F:	include/net/mana
 F:	include/uapi/linux/hyperv.h
+F:	include/uapi/rdma/mana-abi.h
 F:	net/vmw_vsock/hyperv_transport.c
 F:	tools/hv/
=20
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 33d3ce9c888e..a062c662ecff 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -83,6 +83,7 @@ source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
 source "drivers/infiniband/hw/irdma/Kconfig"
+source "drivers/infiniband/hw/mana/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefil=
e
index fba0b3be903e..f62e9e00c780 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_INFINIBAND_QIB)		+=3D qib/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+=3D cxgb4/
 obj-$(CONFIG_INFINIBAND_EFA)		+=3D efa/
 obj-$(CONFIG_INFINIBAND_IRDMA)		+=3D irdma/
+obj-$(CONFIG_MANA_INFINIBAND)		+=3D mana/
 obj-$(CONFIG_MLX4_INFINIBAND)		+=3D mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+=3D mlx5/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+=3D ocrdma/
diff --git a/drivers/infiniband/hw/mana/Kconfig b/drivers/infiniband/hw/man=
a/Kconfig
new file mode 100644
index 000000000000..b3ff03a23257
--- /dev/null
+++ b/drivers/infiniband/hw/mana/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config MANA_INFINIBAND
+	tristate "Microsoft Azure Network Adapter support"
+	depends on NETDEVICES && ETHERNET && PCI && MICROSOFT_MANA
+	help
+	  This driver provides low-level RDMA support for
+	  Microsoft Azure Network Adapter (MANA).
diff --git a/drivers/infiniband/hw/mana/Makefile b/drivers/infiniband/hw/ma=
na/Makefile
new file mode 100644
index 000000000000..a799fe264c5a
--- /dev/null
+++ b/drivers/infiniband/hw/mana/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_MANA_INFINIBAND) +=3D mana_ib.o
+
+mana_ib-y :=3D main.o wq.o qp.o cq.o mr.o
diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/c=
q.c
new file mode 100644
index 000000000000..046fd290073d
--- /dev/null
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#include "mana_ib.h"
+
+int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *at=
tr,
+		      struct ib_udata *udata)
+{
+	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq);
+	struct ib_device *ibdev =3D ibcq->device;
+	struct mana_ib_create_cq ucmd =3D {};
+	struct mana_ib_dev *mdev;
+	int err;
+
+	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+
+	if (udata->inlen < sizeof(ucmd))
+		return -EINVAL;
+
+	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen))=
;
+	if (err) {
+		ibdev_dbg(ibdev,
+			  "Failed to copy from udata for create cq, %d\n", err);
+		return -EFAULT;
+	}
+
+	if (attr->cqe > MAX_SEND_BUFFERS_PER_QUEUE) {
+		ibdev_dbg(ibdev, "CQE %d exceeding limit\n", attr->cqe);
+		return -EINVAL;
+	}
+
+	cq->cqe =3D attr->cqe;
+	cq->umem =3D ib_umem_get(ibdev, ucmd.buf_addr, cq->cqe * COMP_ENTRY_SIZE,
+			       IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(cq->umem)) {
+		err =3D PTR_ERR(cq->umem);
+		ibdev_dbg(ibdev, "Failed to get umem for create cq, err %d\n",
+			  err);
+		return err;
+	}
+
+	err =3D mana_ib_gd_create_dma_region(mdev, cq->umem, &cq->gdma_region,
+					   PAGE_SIZE);
+	if (err) {
+		ibdev_err(ibdev,
+			  "Failed to create dma region for create cq, %d\n",
+			  err);
+		goto err_release_umem;
+	}
+
+	ibdev_dbg(ibdev,
+		  "mana_ib_gd_create_dma_region ret %d gdma_region 0x%llx\n",
+		  err, cq->gdma_region);
+
+	/* The CQ ID is not known at this time
+	 * The ID is generated at create_qp
+	 */
+
+	return 0;
+
+err_release_umem:
+	ib_umem_release(cq->umem);
+	return err;
+}
+
+int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+{
+	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq);
+	struct ib_device *ibdev =3D ibcq->device;
+	struct mana_ib_dev *mdev;
+
+	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+
+	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
+	ib_umem_release(cq->umem);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana=
/main.c
new file mode 100644
index 000000000000..58254a0cf581
--- /dev/null
+++ b/drivers/infiniband/hw/mana/main.c
@@ -0,0 +1,681 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#include "mana_ib.h"
+
+MODULE_DESCRIPTION("Microsoft Azure Network Adapter IB driver");
+MODULE_LICENSE("Dual BSD/GPL");
+
+void mana_ib_uncfg_vport(struct mana_ib_dev *dev, struct mana_ib_pd *pd,
+			 u32 port)
+{
+	struct gdma_dev *gd =3D dev->gdma_dev;
+	struct mana_port_context *mpc;
+	struct net_device *ndev;
+	struct mana_context *mc;
+
+	mc =3D gd->driver_data;
+	ndev =3D mc->ports[port];
+	mpc =3D netdev_priv(ndev);
+
+	mutex_lock(&pd->vport_mutex);
+
+	pd->vport_use_count--;
+	WARN_ON(pd->vport_use_count < 0);
+
+	if (!pd->vport_use_count)
+		mana_uncfg_vport(mpc);
+
+	mutex_unlock(&pd->vport_mutex);
+}
+
+int mana_ib_cfg_vport(struct mana_ib_dev *dev, u32 port, struct mana_ib_pd=
 *pd,
+		      u32 doorbell_id)
+{
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct mana_port_context *mpc;
+	struct mana_context *mc;
+	struct net_device *ndev;
+	int err;
+
+	mc =3D mdev->driver_data;
+	ndev =3D mc->ports[port];
+	mpc =3D netdev_priv(ndev);
+
+	mutex_lock(&pd->vport_mutex);
+
+	pd->vport_use_count++;
+	if (pd->vport_use_count > 1) {
+		ibdev_dbg(&dev->ib_dev,
+			  "Skip as this PD is already configured vport\n");
+		mutex_unlock(&pd->vport_mutex);
+		return 0;
+	}
+	mutex_unlock(&pd->vport_mutex);
+
+	err =3D mana_cfg_vport(mpc, pd->pdn, doorbell_id);
+	if (err) {
+		mutex_lock(&pd->vport_mutex);
+		pd->vport_use_count--;
+		mutex_unlock(&pd->vport_mutex);
+
+		ibdev_err(&dev->ib_dev, "Failed to configure vPort %d\n", err);
+		return err;
+	}
+
+	pd->tx_shortform_allowed =3D mpc->tx_shortform_allowed;
+	pd->tx_vp_offset =3D mpc->tx_vp_offset;
+
+	ibdev_dbg(&dev->ib_dev,
+		  "vport handle %llx pdid %x doorbell_id %x "
+		  "tx_shortform_allowed %d tx_vp_offset %u\n",
+		  mpc->port_handle, pd->pdn, doorbell_id,
+		  pd->tx_shortform_allowed, pd->tx_vp_offset);
+
+	return 0;
+}
+
+static int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct ib_device *ibdev =3D ibpd->device;
+	enum gdma_pd_flags flags =3D 0;
+	struct mana_ib_dev *dev;
+	int ret;
+
+	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+
+	/* Set flags if this is a kernel request */
+	if (!ibpd->uobject)
+		flags =3D GDMA_PD_FLAG_ALLOW_GPA_MR | GDMA_PD_FLAG_ALLOW_FMR_MR;
+
+	ret =3D mana_ib_gd_create_pd(dev, &pd->pd_handle, &pd->pdn, flags);
+	if (ret) {
+		ibdev_err(ibdev, "Failed to get pd id, err %d\n", ret);
+		return ret;
+	}
+
+	mutex_init(&pd->vport_mutex);
+	pd->vport_use_count =3D 0;
+	return 0;
+}
+
+static int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct ib_device *ibdev =3D ibpd->device;
+	struct mana_ib_dev *dev;
+
+	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+	return mana_ib_gd_destroy_pd(dev, pd->pd_handle);
+}
+
+static int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
+				  struct ib_udata *udata)
+{
+	struct mana_ib_ucontext *ucontext =3D
+		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
+	struct ib_device *ibdev =3D ibcontext->device;
+	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	struct gdma_dev *dev;
+	int doorbell_page;
+	int ret;
+
+	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+	dev =3D mdev->gdma_dev;
+	gc =3D dev->gdma_context;
+
+	/* Allocate a doorbell page index */
+	ret =3D mana_gd_allocate_doorbell_page(gc, &doorbell_page);
+	if (ret) {
+		ibdev_err(ibdev, "Failed to allocate doorbell page %d\n", ret);
+		return -ENOMEM;
+	}
+
+	ibdev_dbg(ibdev, "Doorbell page allocated %d\n", doorbell_page);
+
+	ucontext->doorbell =3D doorbell_page;
+
+	return 0;
+}
+
+static void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct mana_ib_ucontext *mana_ucontext =3D
+		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
+	struct ib_device *ibdev =3D ibcontext->device;
+	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	int ret;
+
+	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gc =3D mdev->gdma_dev->gdma_context;
+
+	ret =3D mana_gd_destroy_doorbell_page(gc, mana_ucontext->doorbell);
+	if (ret)
+		ibdev_err(ibdev, "Failed to destroy doorbell page %d\n", ret);
+}
+
+int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *=
umem,
+				 mana_handle_t *gdma_region, u64 page_sz)
+{
+	size_t num_pages_total =3D ib_umem_num_dma_blocks(umem, page_sz);
+	struct gdma_dma_region_add_pages_req *add_req =3D NULL;
+	struct gdma_create_dma_region_resp create_resp =3D {};
+	struct gdma_create_dma_region_req *create_req;
+	size_t num_pages_cur, num_pages_to_handle;
+	unsigned int create_req_msg_size;
+	struct hw_channel_context *hwc;
+	struct ib_block_iter biter;
+	size_t max_pgs_create_cmd;
+	struct gdma_context *gc;
+	struct gdma_dev *mdev;
+	unsigned int i;
+	int err;
+
+	mdev =3D dev->gdma_dev;
+	gc =3D mdev->gdma_context;
+	hwc =3D gc->hwc.driver_data;
+	max_pgs_create_cmd =3D
+		(hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
+
+	num_pages_to_handle =3D
+		min_t(size_t, num_pages_total, max_pgs_create_cmd);
+	create_req_msg_size =3D
+		struct_size(create_req, page_addr_list, num_pages_to_handle);
+
+	create_req =3D kzalloc(create_req_msg_size, GFP_KERNEL);
+	if (!create_req)
+		return -ENOMEM;
+
+	mana_gd_init_req_hdr(&create_req->hdr, GDMA_CREATE_DMA_REGION,
+			     create_req_msg_size, sizeof(create_resp));
+
+	create_req->length =3D umem->length;
+	create_req->offset_in_page =3D umem->address & (page_sz - 1);
+	create_req->gdma_page_type =3D order_base_2(page_sz) - PAGE_SHIFT;
+	create_req->page_count =3D num_pages_total;
+	create_req->page_addr_list_len =3D num_pages_to_handle;
+
+	ibdev_dbg(&dev->ib_dev,
+		  "size_dma_region %lu num_pages_total %lu, "
+		  "page_sz 0x%llx offset_in_page %u\n",
+		  umem->length, num_pages_total, page_sz,
+		  create_req->offset_in_page);
+
+	ibdev_dbg(&dev->ib_dev, "num_pages_to_handle %lu, gdma_page_type %u",
+		  num_pages_to_handle, create_req->gdma_page_type);
+
+	__rdma_umem_block_iter_start(&biter, umem, page_sz);
+
+	for (i =3D 0; i < num_pages_to_handle; ++i) {
+		dma_addr_t cur_addr;
+
+		__rdma_block_iter_next(&biter);
+		cur_addr =3D rdma_block_iter_dma_address(&biter);
+
+		create_req->page_addr_list[i] =3D cur_addr;
+
+		ibdev_dbg(&dev->ib_dev, "page num %u cur_addr 0x%llx\n", i,
+			  cur_addr);
+	}
+
+	err =3D mana_gd_send_request(gc, create_req_msg_size, create_req,
+				   sizeof(create_resp), &create_resp);
+	kfree(create_req);
+
+	if (err || create_resp.hdr.status) {
+		ibdev_err(&dev->ib_dev,
+			  "Failed to create DMA region: %d, 0x%x\n", err,
+			  create_resp.hdr.status);
+		goto error;
+	}
+
+	*gdma_region =3D create_resp.dma_region_handle;
+	ibdev_dbg(&dev->ib_dev, "Created DMA region with handle 0x%llx\n",
+		  *gdma_region);
+
+	num_pages_cur =3D num_pages_to_handle;
+
+	if (num_pages_cur < num_pages_total) {
+		unsigned int add_req_msg_size;
+		size_t max_pgs_add_cmd =3D
+			(hwc->max_req_msg_size - sizeof(*add_req)) /
+			sizeof(u64);
+
+		num_pages_to_handle =3D
+			min_t(size_t, num_pages_total - num_pages_cur,
+			      max_pgs_add_cmd);
+
+		/* Calculate the max num of pages that will be handled */
+		add_req_msg_size =3D struct_size(add_req, page_addr_list,
+					       num_pages_to_handle);
+
+		add_req =3D kmalloc(add_req_msg_size, GFP_KERNEL);
+		if (!add_req) {
+			err =3D -ENOMEM;
+			goto error;
+		}
+
+		while (num_pages_cur < num_pages_total) {
+			struct gdma_general_resp add_resp =3D {};
+			u32 expected_status =3D 0;
+
+			if (num_pages_cur + num_pages_to_handle <
+			    num_pages_total) {
+				/* Status indicating more pages are needed */
+				expected_status =3D GDMA_STATUS_MORE_ENTRIES;
+			}
+
+			memset(add_req, 0, add_req_msg_size);
+
+			mana_gd_init_req_hdr(&add_req->hdr,
+					     GDMA_DMA_REGION_ADD_PAGES,
+					     add_req_msg_size,
+					     sizeof(add_resp));
+			add_req->dma_region_handle =3D *gdma_region;
+			add_req->page_addr_list_len =3D num_pages_to_handle;
+
+			for (i =3D 0; i < num_pages_to_handle; ++i) {
+				dma_addr_t cur_addr =3D
+					rdma_block_iter_dma_address(&biter);
+				add_req->page_addr_list[i] =3D cur_addr;
+				__rdma_block_iter_next(&biter);
+
+				ibdev_dbg(&dev->ib_dev,
+					  "page_addr_list %lu addr 0x%llx\n",
+					  num_pages_cur + i, cur_addr);
+			}
+
+			err =3D mana_gd_send_request(gc, add_req_msg_size,
+						   add_req, sizeof(add_resp),
+						   &add_resp);
+			if (!err || add_resp.hdr.status !=3D expected_status) {
+				ibdev_err(&dev->ib_dev,
+					  "Failed put DMA pages %u: %d,0x%x\n",
+					  i, err, add_resp.hdr.status);
+				err =3D -EPROTO;
+				goto free_req;
+			}
+
+			num_pages_cur +=3D num_pages_to_handle;
+			num_pages_to_handle =3D
+				min_t(size_t, num_pages_total - num_pages_cur,
+				      max_pgs_add_cmd);
+			add_req_msg_size =3D sizeof(*add_req) +
+					   num_pages_to_handle * sizeof(u64);
+		}
+free_req:
+		kfree(add_req);
+	}
+
+error:
+	return err;
+}
+
+int mana_ib_gd_destroy_dma_region(struct mana_ib_dev *dev, u64 gdma_region=
)
+{
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct gdma_context *gc;
+
+	gc =3D mdev->gdma_context;
+	ibdev_dbg(&dev->ib_dev, "destroy dma region 0x%llx\n", gdma_region);
+
+	return mana_gd_destroy_dma_region(gc, gdma_region);
+}
+
+int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle, u32 *pd_=
id,
+			 enum gdma_pd_flags flags)
+{
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct gdma_create_pd_resp resp =3D {};
+	struct gdma_create_pd_req req =3D {};
+	struct gdma_context *gc;
+	int err;
+
+	gc =3D mdev->gdma_context;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_PD, sizeof(req),
+			     sizeof(resp));
+
+	req.flags =3D flags;
+	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+
+	if (err || resp.hdr.status) {
+		ibdev_err(&dev->ib_dev,
+			  "Failed to get pd_id err %d status %u\n", err,
+			  resp.hdr.status);
+		if (!err)
+			err =3D -EPROTO;
+
+		return err;
+	}
+
+	*pd_handle =3D resp.pd_handle;
+	*pd_id =3D resp.pd_id;
+	ibdev_dbg(&dev->ib_dev, "pd_handle 0x%llx pd_id %d\n", *pd_handle,
+		  *pd_id);
+
+	return 0;
+}
+
+int mana_ib_gd_destroy_pd(struct mana_ib_dev *dev, u64 pd_handle)
+{
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct gdma_destory_pd_resp resp =3D {};
+	struct gdma_destroy_pd_req req =3D {};
+	struct gdma_context *gc;
+	int err;
+
+	gc =3D mdev->gdma_context;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_PD, sizeof(req),
+			     sizeof(resp));
+
+	req.pd_handle =3D pd_handle;
+	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+
+	if (err || resp.hdr.status) {
+		ibdev_err(&dev->ib_dev,
+			  "Failed to destroy pd_handle 0x%llx err %d status %u",
+			  pd_handle, err, resp.hdr.status);
+		if (!err)
+			err =3D -EPROTO;
+	}
+
+	return err;
+}
+
+int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr *mr,
+			 struct gdma_create_mr_params *mr_params)
+{
+	struct gdma_create_mr_response resp =3D {};
+	struct gdma_create_mr_request req =3D {};
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct gdma_context *gc;
+	int err;
+
+	gc =3D mdev->gdma_context;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_MR, sizeof(req),
+			     sizeof(resp));
+	req.pd_handle =3D mr_params->pd_handle;
+
+	switch (mr_params->mr_type) {
+	case GDMA_MR_TYPE_GVA:
+		req.mr_type =3D GDMA_MR_TYPE_GVA;
+		req.gva.dma_region_handle =3D mr_params->gva.dma_region_handle;
+		req.gva.virtual_address =3D mr_params->gva.virtual_address;
+		req.gva.access_flags =3D mr_params->gva.access_flags;
+		break;
+
+	case GDMA_MR_TYPE_GPA:
+		req.mr_type =3D GDMA_MR_TYPE_GPA;
+		req.gpa.access_flags =3D mr_params->gpa.access_flags;
+		break;
+
+	case GDMA_MR_TYPE_FMR:
+		req.mr_type =3D GDMA_MR_TYPE_FMR;
+		req.fmr.page_size =3D mr_params->fmr.page_size;
+		req.fmr.reserved_pte_count =3D mr_params->fmr.reserved_pte_count;
+		break;
+
+	default:
+		ibdev_dbg(&dev->ib_dev,
+			  "invalid param (GDMA_MR_TYPE) passed, type %d\n",
+			  req.mr_type);
+		err =3D -EINVAL;
+		goto error;
+	}
+
+	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+
+	if (err || resp.hdr.status) {
+		ibdev_err(&dev->ib_dev, "Failed to create mr %d, %u", err,
+			  resp.hdr.status);
+		goto error;
+	}
+
+	mr->ibmr.lkey =3D resp.lkey;
+	mr->ibmr.rkey =3D resp.rkey;
+	mr->mr_handle =3D resp.mr_handle;
+
+	return 0;
+error:
+	return err;
+}
+
+int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, gdma_obj_handle_t mr_ha=
ndle)
+{
+	struct gdma_destroy_mr_response resp =3D {};
+	struct gdma_destroy_mr_request req =3D {};
+	struct gdma_dev *mdev =3D dev->gdma_dev;
+	struct gdma_context *gc;
+	int err;
+
+	gc =3D mdev->gdma_context;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_MR, sizeof(req),
+			     sizeof(resp));
+
+	req.mr_handle =3D mr_handle;
+
+	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to destroy MR: %d, 0x%x\n", err,
+			resp.hdr.status);
+		if (!err)
+			err =3D -EPROTO;
+		return err;
+	}
+
+	return 0;
+}
+
+static int mana_ib_mmap(struct ib_ucontext *ibcontext,
+			struct vm_area_struct *vma)
+{
+	struct mana_ib_ucontext *mana_ucontext =3D
+		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
+	struct ib_device *ibdev =3D ibcontext->device;
+	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	phys_addr_t pfn;
+	pgprot_t prot;
+	int ret;
+
+	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gc =3D mdev->gdma_dev->gdma_context;
+
+	if (vma->vm_pgoff !=3D 0) {
+		ibdev_err(ibdev, "Unexpected vm_pgoff %lu\n", vma->vm_pgoff);
+		return -EINVAL;
+	}
+
+	/* Map to the page indexed by ucontext->doorbell */
+	pfn =3D (gc->phys_db_page_base +
+	       gc->db_page_size * mana_ucontext->doorbell) >>
+	      PAGE_SHIFT;
+	prot =3D pgprot_writecombine(vma->vm_page_prot);
+
+	ret =3D rdma_user_mmap_io(ibcontext, vma, pfn, gc->db_page_size, prot,
+				NULL);
+	if (ret)
+		ibdev_err(ibdev, "can't rdma_user_mmap_io ret %d\n", ret);
+	else
+		ibdev_dbg(ibdev, "mapped I/O pfn 0x%llx page_size %u, ret %d\n",
+			  pfn, gc->db_page_size, ret);
+
+	return ret;
+}
+
+static int mana_ib_get_port_immutable(struct ib_device *ibdev, u32 port_nu=
m,
+				      struct ib_port_immutable *immutable)
+{
+	/* This version only support RAW_PACKET
+	 * other values need to be filled for other types
+	 */
+	immutable->core_cap_flags =3D RDMA_CORE_PORT_RAW_PACKET;
+
+	return 0;
+}
+
+static int mana_ib_query_device(struct ib_device *ibdev,
+				struct ib_device_attr *props,
+				struct ib_udata *uhw)
+{
+	props->max_qp =3D MANA_MAX_NUM_QUEUES;
+	props->max_qp_wr =3D MAX_SEND_BUFFERS_PER_QUEUE;
+
+	/* max_cqe could be potentially much bigger.
+	 * As this version of driver only support RAW QP, set it to the same
+	 * value as max_qp_wr
+	 */
+	props->max_cqe =3D MAX_SEND_BUFFERS_PER_QUEUE;
+
+	props->max_mr_size =3D MANA_IB_MAX_MR_SIZE;
+	props->max_mr =3D INT_MAX;
+	props->max_send_sge =3D MAX_TX_WQE_SGL_ENTRIES;
+	props->max_recv_sge =3D MAX_RX_WQE_SGL_ENTRIES;
+
+	return 0;
+}
+
+static int mana_ib_query_port(struct ib_device *ibdev, u32 port,
+			      struct ib_port_attr *props)
+{
+	/* This version doesn't return port properties */
+	return 0;
+}
+
+static int mana_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
+			     union ib_gid *gid)
+{
+	/* This version doesn't return GID properties */
+	return 0;
+}
+
+static void mana_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
+{
+}
+
+static const struct ib_device_ops mana_ib_dev_ops =3D {
+	.owner =3D THIS_MODULE,
+	.driver_id =3D RDMA_DRIVER_MANA,
+	.uverbs_abi_ver =3D MANA_IB_UVERBS_ABI_VERSION,
+
+	.alloc_pd =3D mana_ib_alloc_pd,
+	.alloc_ucontext =3D mana_ib_alloc_ucontext,
+	.create_cq =3D mana_ib_create_cq,
+	.create_qp =3D mana_ib_create_qp,
+	.create_rwq_ind_table =3D mana_ib_create_rwq_ind_table,
+	.create_wq =3D mana_ib_create_wq,
+	.dealloc_pd =3D mana_ib_dealloc_pd,
+	.dealloc_ucontext =3D mana_ib_dealloc_ucontext,
+	.dereg_mr =3D mana_ib_dereg_mr,
+	.destroy_cq =3D mana_ib_destroy_cq,
+	.destroy_qp =3D mana_ib_destroy_qp,
+	.destroy_rwq_ind_table =3D mana_ib_destroy_rwq_ind_table,
+	.destroy_wq =3D mana_ib_destroy_wq,
+	.disassociate_ucontext =3D mana_ib_disassociate_ucontext,
+	.get_port_immutable =3D mana_ib_get_port_immutable,
+	.mmap =3D mana_ib_mmap,
+	.modify_qp =3D mana_ib_modify_qp,
+	.modify_wq =3D mana_ib_modify_wq,
+	.query_device =3D mana_ib_query_device,
+	.query_gid =3D mana_ib_query_gid,
+	.query_port =3D mana_ib_query_port,
+	.reg_user_mr =3D mana_ib_reg_user_mr,
+
+	INIT_RDMA_OBJ_SIZE(ib_cq, mana_ib_cq, ibcq),
+	INIT_RDMA_OBJ_SIZE(ib_pd, mana_ib_pd, ibpd),
+	INIT_RDMA_OBJ_SIZE(ib_qp, mana_ib_qp, ibqp),
+	INIT_RDMA_OBJ_SIZE(ib_ucontext, mana_ib_ucontext, ibucontext),
+	INIT_RDMA_OBJ_SIZE(ib_rwq_ind_table, mana_ib_rwq_ind_table,
+			   ib_ind_table),
+};
+
+static int mana_ib_probe(struct auxiliary_device *adev,
+			 const struct auxiliary_device_id *id)
+{
+	struct mana_adev *madev =3D container_of(adev, struct mana_adev, adev);
+	struct gdma_dev *mdev =3D madev->mdev;
+	struct mana_context *mc;
+	struct mana_ib_dev *dev;
+	int ret =3D 0;
+
+	mc =3D mdev->driver_data;
+
+	dev =3D ib_alloc_device(mana_ib_dev, ib_dev);
+	if (!dev)
+		return -ENOMEM;
+
+	ib_set_device_ops(&dev->ib_dev, &mana_ib_dev_ops);
+
+	dev->ib_dev.phys_port_cnt =3D mc->num_ports;
+
+	ibdev_dbg(&dev->ib_dev, "mdev=3D%p id=3D%d num_ports=3D%d\n", mdev,
+		  mdev->dev_id.as_uint32, dev->ib_dev.phys_port_cnt);
+
+	dev->gdma_dev =3D mdev;
+	dev->ib_dev.node_type =3D RDMA_NODE_IB_CA;
+
+	/* num_comp_vectors needs to set to the max MSIX index
+	 * when interrupts and event queues are implemented
+	 */
+	dev->ib_dev.num_comp_vectors =3D 1;
+	dev->ib_dev.dev.parent =3D mdev->gdma_context->dev;
+
+	ret =3D ib_register_device(&dev->ib_dev, "mana_%d",
+				 mdev->gdma_context->dev);
+	if (ret) {
+		ib_dealloc_device(&dev->ib_dev);
+		return ret;
+	}
+
+	dev_set_drvdata(&adev->dev, dev);
+
+	return 0;
+}
+
+static void mana_ib_remove(struct auxiliary_device *adev)
+{
+	struct mana_ib_dev *dev =3D dev_get_drvdata(&adev->dev);
+
+	ib_unregister_device(&dev->ib_dev);
+	ib_dealloc_device(&dev->ib_dev);
+}
+
+static const struct auxiliary_device_id mana_id_table[] =3D {
+	{
+		.name =3D "mana.rdma",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mana_id_table);
+
+static struct auxiliary_driver mana_driver =3D {
+	.name =3D "rdma",
+	.probe =3D mana_ib_probe,
+	.remove =3D mana_ib_remove,
+	.id_table =3D mana_id_table,
+};
+
+static int __init mana_ib_init(void)
+{
+	auxiliary_driver_register(&mana_driver);
+
+	return 0;
+}
+
+static void __exit mana_ib_cleanup(void)
+{
+	auxiliary_driver_unregister(&mana_driver);
+}
+
+module_init(mana_ib_init);
+module_exit(mana_ib_cleanup);
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/m=
ana/mana_ib.h
new file mode 100644
index 000000000000..d3d42b11e95f
--- /dev/null
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2022 Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _MANA_IB_H_
+#define _MANA_IB_H_
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_mad.h>
+#include <rdma/ib_umem.h>
+#include <linux/auxiliary_bus.h>
+#include <rdma/mana-abi.h>
+
+#include <net/mana/mana.h>
+
+#define PAGE_SZ_BM                                                        =
     \
+	(SZ_4K | SZ_8K | SZ_16K | SZ_32K | SZ_64K | SZ_128K | SZ_256K |        \
+	 SZ_512K | SZ_1M | SZ_2M)
+
+/* MANA doesn't have any limit for MR size */
+#define MANA_IB_MAX_MR_SIZE ((u64)(~(0ULL)))
+
+struct mana_ib_dev {
+	struct ib_device ib_dev;
+	struct gdma_dev *gdma_dev;
+};
+
+struct mana_ib_wq {
+	struct ib_wq ibwq;
+	struct ib_umem *umem;
+	int wqe;
+	u32 wq_buf_size;
+	u64 gdma_region;
+	u64 id;
+	mana_handle_t rx_object;
+};
+
+struct mana_ib_pd {
+	struct ib_pd ibpd;
+	u32 pdn;
+	mana_handle_t pd_handle;
+
+	/* Mutex for sharing access to vport_use_count */
+	struct mutex vport_mutex;
+	int vport_use_count;
+
+	bool tx_shortform_allowed;
+	u32 tx_vp_offset;
+};
+
+struct mana_ib_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+	mana_handle_t mr_handle;
+};
+
+struct mana_ib_cq {
+	struct ib_cq ibcq;
+	struct ib_umem *umem;
+	int cqe;
+	u64 gdma_region;
+	u64 id;
+};
+
+struct mana_ib_qp {
+	struct ib_qp ibqp;
+
+	/* Work queue info */
+	struct ib_umem *sq_umem;
+	int sqe;
+	u64 sq_gdma_region;
+	u64 sq_id;
+	mana_handle_t tx_object;
+
+	/* The port on the IB device, starting with 1 */
+	u32 port;
+};
+
+struct mana_ib_ucontext {
+	struct ib_ucontext ibucontext;
+	u32 doorbell;
+};
+
+struct mana_ib_rwq_ind_table {
+	struct ib_rwq_ind_table ib_ind_table;
+};
+
+int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *=
umem,
+				 mana_handle_t *gdma_region, u64 page_sz);
+
+int mana_ib_gd_destroy_dma_region(struct mana_ib_dev *dev,
+				  mana_handle_t gdma_region);
+
+struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata);
+
+int mana_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata);
+
+int mana_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata);
+
+int mana_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table=
,
+				 struct ib_rwq_ind_table_init_attr *init_attr,
+				 struct ib_udata *udata);
+
+int mana_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)=
;
+
+struct ib_mr *mana_ib_get_dma_mr(struct ib_pd *ibpd, int access_flags);
+
+struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				  u64 iova, int access_flags,
+				  struct ib_udata *udata);
+
+int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
+
+int mana_ib_create_qp(struct ib_qp *qp, struct ib_qp_init_attr *qp_init_at=
tr,
+		      struct ib_udata *udata);
+
+int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata);
+
+int mana_ib_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
+
+int mana_ib_cfg_vport(struct mana_ib_dev *dev, u32 port_id,
+		      struct mana_ib_pd *pd, u32 doorbell_id);
+void mana_ib_uncfg_vport(struct mana_ib_dev *dev, struct mana_ib_pd *pd,
+			 u32 port);
+
+int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *at=
tr,
+		      struct ib_udata *udata);
+
+int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+
+int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle, u32 *pd_=
id,
+			 enum gdma_pd_flags flags);
+
+int mana_ib_gd_destroy_pd(struct mana_ib_dev *dev, u64 pd_handle);
+
+int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr *mr,
+			 struct gdma_create_mr_params *mr_params);
+
+int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, mana_handle_t mr_handle=
);
+#endif
diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/m=
r.c
new file mode 100644
index 000000000000..962e40f2de53
--- /dev/null
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#include "mana_ib.h"
+
+#define VALID_MR_FLAGS                                                    =
     \
+	(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_READ)
+
+static enum gdma_mr_access_flags
+mana_ib_verbs_to_gdma_access_flags(int access_flags)
+{
+	enum gdma_mr_access_flags flags =3D GDMA_ACCESS_FLAG_LOCAL_READ;
+
+	if (access_flags & IB_ACCESS_LOCAL_WRITE)
+		flags |=3D GDMA_ACCESS_FLAG_LOCAL_WRITE;
+
+	if (access_flags & IB_ACCESS_REMOTE_WRITE)
+		flags |=3D GDMA_ACCESS_FLAG_REMOTE_WRITE;
+
+	if (access_flags & IB_ACCESS_REMOTE_READ)
+		flags |=3D GDMA_ACCESS_FLAG_REMOTE_READ;
+
+	return flags;
+}
+
+struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 lengt=
h,
+				  u64 iova, int access_flags,
+				  struct ib_udata *udata)
+{
+	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct gdma_create_mr_params mr_params =3D {};
+	struct ib_device *ibdev =3D ibpd->device;
+	gdma_obj_handle_t dma_region_handle;
+	struct mana_ib_dev *dev;
+	struct mana_ib_mr *mr;
+	u64 page_sz;
+	int err;
+
+	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+
+	ibdev_dbg(ibdev,
+		  "start 0x%llx, iova 0x%llx length 0x%llx access_flags 0x%x",
+		  start, iova, length, access_flags);
+
+	if (access_flags & ~VALID_MR_FLAGS)
+		return ERR_PTR(-EINVAL);
+
+	mr =3D kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->umem =3D ib_umem_get(ibdev, start, length, access_flags);
+	if (IS_ERR(mr->umem)) {
+		err =3D PTR_ERR(mr->umem);
+		ibdev_dbg(ibdev,
+			  "Failed to get umem for register user-mr, %d\n", err);
+		goto err_free;
+	}
+
+	page_sz =3D ib_umem_find_best_pgsz(mr->umem, PAGE_SZ_BM, iova);
+	if (unlikely(!page_sz)) {
+		ibdev_err(ibdev, "Failed to get best page size\n");
+		err =3D -EOPNOTSUPP;
+		goto err_umem;
+	}
+	ibdev_dbg(ibdev, "Page size chosen %llu\n", page_sz);
+
+	err =3D mana_ib_gd_create_dma_region(dev, mr->umem, &dma_region_handle,
+					   page_sz);
+	if (err) {
+		ibdev_err(ibdev, "Failed create dma region for user-mr, %d\n",
+			  err);
+		goto err_umem;
+	}
+
+	ibdev_dbg(ibdev,
+		  "mana_ib_gd_create_dma_region ret %d gdma_region %llx\n", err,
+		  dma_region_handle);
+
+	mr_params.pd_handle =3D pd->pd_handle;
+	mr_params.mr_type =3D GDMA_MR_TYPE_GVA;
+	mr_params.gva.dma_region_handle =3D dma_region_handle;
+	mr_params.gva.virtual_address =3D iova;
+	mr_params.gva.access_flags =3D
+		mana_ib_verbs_to_gdma_access_flags(access_flags);
+
+	err =3D mana_ib_gd_create_mr(dev, mr, &mr_params);
+	if (err)
+		goto err_dma_region;
+
+	/* There is no need to keep track of dma_region_handle after MR is
+	 * successfully created. The dma_region_handle is tracked in the PF
+	 * as part of the lifecycle of this MR.
+	 */
+
+	mr->ibmr.length =3D length;
+	mr->ibmr.page_size =3D page_sz;
+	return &mr->ibmr;
+
+err_dma_region:
+	mana_gd_destroy_dma_region(dev->gdma_dev->gdma_context,
+				   dma_region_handle);
+
+err_umem:
+	ib_umem_release(mr->umem);
+
+err_free:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
+int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
+{
+	struct mana_ib_mr *mr =3D container_of(ibmr, struct mana_ib_mr, ibmr);
+	struct ib_device *ibdev =3D ibmr->device;
+	struct mana_ib_dev *dev;
+	int err;
+
+	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
+
+	err =3D mana_ib_gd_destroy_mr(dev, mr->mr_handle);
+	if (err)
+		return err;
+
+	if (mr->umem)
+		ib_umem_release(mr->umem);
+
+	kfree(mr);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/q=
p.c
new file mode 100644
index 000000000000..75100674f1cf
--- /dev/null
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#include "mana_ib.h"
+
+static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
+				      struct net_device *ndev,
+				      mana_handle_t default_rxobj,
+				      mana_handle_t ind_table[],
+				      u32 log_ind_tbl_size, u32 rx_hash_key_len,
+				      u8 *rx_hash_key)
+{
+	struct mana_port_context *mpc =3D netdev_priv(ndev);
+	struct mana_cfg_rx_steer_req *req =3D NULL;
+	struct mana_cfg_rx_steer_resp resp =3D {};
+	mana_handle_t *req_indir_tab;
+	struct gdma_context *gc;
+	struct gdma_dev *mdev;
+	u32 req_buf_size;
+	int i, err;
+
+	mdev =3D dev->gdma_dev;
+	gc =3D mdev->gdma_context;
+
+	req_buf_size =3D
+		sizeof(*req) + sizeof(mana_handle_t) * MANA_INDIRECT_TABLE_SIZE;
+	req =3D kzalloc(req_buf_size, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
+			     sizeof(resp));
+
+	req->vport =3D mpc->port_handle;
+	req->rx_enable =3D 1;
+	req->update_default_rxobj =3D 1;
+	req->default_rxobj =3D default_rxobj;
+	req->hdr.dev_id =3D mdev->dev_id;
+
+	/* If there are more than 1 entries in indirection table, enable RSS */
+	if (log_ind_tbl_size)
+		req->rss_enable =3D true;
+
+	req->num_indir_entries =3D MANA_INDIRECT_TABLE_SIZE;
+	req->indir_tab_offset =3D sizeof(*req);
+	req->update_indir_tab =3D true;
+
+	req_indir_tab =3D (mana_handle_t *)(req + 1);
+	/* The ind table passed to the hardware must have
+	 * MANA_INDIRECT_TABLE_SIZE entries. Adjust the verb
+	 * ind_table to MANA_INDIRECT_TABLE_SIZE if required
+	 */
+	ibdev_dbg(&dev->ib_dev, "ind table size %u\n", 1 << log_ind_tbl_size);
+	for (i =3D 0; i < MANA_INDIRECT_TABLE_SIZE; i++) {
+		req_indir_tab[i] =3D ind_table[i % (1 << log_ind_tbl_size)];
+		ibdev_dbg(&dev->ib_dev, "index %u handle 0x%llx\n", i,
+			  req_indir_tab[i]);
+	}
+
+	req->update_hashkey =3D true;
+	if (rx_hash_key_len)
+		memcpy(req->hashkey, rx_hash_key, rx_hash_key_len);
+	else
+		netdev_rss_key_fill(req->hashkey, MANA_HASH_KEY_SIZE);
+
+	ibdev_dbg(&dev->ib_dev, "vport handle %llu default_rxobj 0x%llx\n",
+		  req->vport, default_rxobj);
+
+	err =3D mana_gd_send_request(gc, req_buf_size, req, sizeof(resp), &resp);
+	if (err) {
+		netdev_err(ndev, "Failed to configure vPort RX: %d\n", err);
+		goto out;
+	}
+
+	if (resp.hdr.status) {
+		netdev_err(ndev, "vPort RX configuration failed: 0x%x\n",
+			   resp.hdr.status);
+		err =3D -EPROTO;
+	}
+
+	netdev_info(ndev, "Configured steering vPort %llu log_entries %u\n",
+		    mpc->port_handle, log_ind_tbl_size);
+
+out:
+	kfree(req);
+	return err;
+}
+
+static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
+				 struct ib_qp_init_attr *attr,
+				 struct ib_udata *udata)
+{
+	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
+	struct mana_ib_dev *mdev =3D
+		container_of(pd->device, struct mana_ib_dev, ib_dev);
+	struct ib_rwq_ind_table *ind_tbl =3D attr->rwq_ind_tbl;
+	struct mana_ib_create_qp_rss_resp resp =3D {};
+	struct mana_ib_create_qp_rss ucmd =3D {};
+	struct gdma_dev *gd =3D mdev->gdma_dev;
+	mana_handle_t *mana_ind_table;
+	struct mana_port_context *mpc;
+	struct mana_context *mc;
+	struct net_device *ndev;
+	struct mana_ib_cq *cq;
+	struct mana_ib_wq *wq;
+	struct ib_cq *ibcq;
+	struct ib_wq *ibwq;
+	int i =3D 0, ret;
+	u32 port;
+
+	mc =3D gd->driver_data;
+
+	if (udata->inlen < sizeof(ucmd))
+		return -EINVAL;
+
+	ret =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen))=
;
+	if (ret) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Failed copy from udata for create rss-qp, err %d\n",
+			  ret);
+		return -EFAULT;
+	}
+
+	if (attr->cap.max_recv_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Requested max_recv_wr %d exceeding limit.\n",
+			  attr->cap.max_recv_wr);
+		return -EINVAL;
+	}
+
+	if (attr->cap.max_recv_sge > MAX_RX_WQE_SGL_ENTRIES) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Requested max_recv_sge %d exceeding limit.\n",
+			  attr->cap.max_recv_sge);
+		return -EINVAL;
+	}
+
+	if (ucmd.rx_hash_function !=3D MANA_IB_RX_HASH_FUNC_TOEPLITZ) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "RX Hash function is not supported, %d\n",
+			  ucmd.rx_hash_function);
+		return -EINVAL;
+	}
+
+	/* IB ports start with 1, MANA start with 0 */
+	port =3D ucmd.port;
+	if (port < 1 || port > mc->num_ports) {
+		ibdev_dbg(&mdev->ib_dev, "Invalid port %u in creating qp\n",
+			  port);
+		return -EINVAL;
+	}
+	ndev =3D mc->ports[port - 1];
+	mpc =3D netdev_priv(ndev);
+
+	ibdev_dbg(&mdev->ib_dev, "rx_hash_function %d port %d\n",
+		  ucmd.rx_hash_function, port);
+
+	mana_ind_table =3D kzalloc(sizeof(mana_handle_t) *
+					 (1 << ind_tbl->log_ind_tbl_size),
+				 GFP_KERNEL);
+	if (!mana_ind_table) {
+		ret =3D -ENOMEM;
+		goto fail;
+	}
+
+	qp->port =3D port;
+
+	for (i =3D 0; i < (1 << ind_tbl->log_ind_tbl_size); i++) {
+		struct mana_obj_spec wq_spec =3D {};
+		struct mana_obj_spec cq_spec =3D {};
+
+		ibwq =3D ind_tbl->ind_tbl[i];
+		wq =3D container_of(ibwq, struct mana_ib_wq, ibwq);
+
+		ibcq =3D ibwq->cq;
+		cq =3D container_of(ibcq, struct mana_ib_cq, ibcq);
+
+		wq_spec.gdma_region =3D wq->gdma_region;
+		wq_spec.queue_size =3D wq->wq_buf_size;
+
+		cq_spec.gdma_region =3D cq->gdma_region;
+		cq_spec.queue_size =3D cq->cqe * COMP_ENTRY_SIZE;
+		cq_spec.modr_ctx_id =3D 0;
+		cq_spec.attached_eq =3D GDMA_CQ_NO_EQ;
+
+		ret =3D mana_create_wq_obj(mpc, mpc->port_handle, GDMA_RQ,
+					 &wq_spec, &cq_spec, &wq->rx_object);
+		if (ret)
+			goto fail;
+
+		/* The GDMA regions are now owned by the WQ object */
+		wq->gdma_region =3D GDMA_INVALID_DMA_REGION;
+		cq->gdma_region =3D GDMA_INVALID_DMA_REGION;
+
+		wq->id =3D wq_spec.queue_index;
+		cq->id =3D cq_spec.queue_index;
+
+		ibdev_dbg(&mdev->ib_dev,
+			  "ret %d rx_object 0x%llx wq id %llu cq id %llu\n",
+			  ret, wq->rx_object, wq->id, cq->id);
+
+		resp.entries[i].cqid =3D cq->id;
+		resp.entries[i].wqid =3D wq->id;
+
+		mana_ind_table[i] =3D wq->rx_object;
+	}
+	resp.num_entries =3D i;
+
+	ret =3D mana_ib_cfg_vport_steering(mdev, ndev, wq->rx_object,
+					 mana_ind_table,
+					 ind_tbl->log_ind_tbl_size,
+					 ucmd.rx_hash_key_len,
+					 ucmd.rx_hash_key);
+	if (ret)
+		goto fail;
+
+	kfree(mana_ind_table);
+
+	if (udata) {
+		ret =3D ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (ret) {
+			ibdev_dbg(&mdev->ib_dev,
+				  "Failed to copy to udata create rss-qp, %d\n",
+				  ret);
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	while (i-- > 0) {
+		ibwq =3D ind_tbl->ind_tbl[i];
+		wq =3D container_of(ibwq, struct mana_ib_wq, ibwq);
+		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+	}
+
+	kfree(mana_ind_table);
+
+	return ret;
+}
+
+static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
+				 struct ib_qp_init_attr *attr,
+				 struct ib_udata *udata)
+{
+	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
+	struct mana_ib_dev *mdev =3D
+		container_of(ibpd->device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_cq *send_cq =3D
+		container_of(attr->send_cq, struct mana_ib_cq, ibcq);
+	struct ib_ucontext *ib_ucontext =3D ibpd->uobject->context;
+	struct mana_ib_create_qp_resp resp =3D {};
+	struct mana_ib_ucontext *mana_ucontext;
+	struct gdma_dev *gd =3D mdev->gdma_dev;
+	struct mana_ib_create_qp ucmd =3D {};
+	struct mana_obj_spec wq_spec =3D {};
+	struct mana_obj_spec cq_spec =3D {};
+	struct mana_port_context *mpc;
+	struct mana_context *mc;
+	struct net_device *ndev;
+	struct ib_umem *umem;
+	int err;
+	u32 port;
+
+	mana_ucontext =3D
+		container_of(ib_ucontext, struct mana_ib_ucontext, ibucontext);
+	mc =3D gd->driver_data;
+
+	if (udata->inlen < sizeof(ucmd))
+		return -EINVAL;
+
+	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen))=
;
+	if (err) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Failed to copy from udata create qp-raw, %d\n", err);
+		return -EFAULT;
+	}
+
+	/* IB ports start with 1, MANA Ethernet ports start with 0 */
+	port =3D ucmd.port;
+	if (ucmd.port > mc->num_ports)
+		return -EINVAL;
+
+	if (attr->cap.max_send_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Requested max_send_wr %d exceeding limit\n",
+			  attr->cap.max_send_wr);
+		return -EINVAL;
+	}
+
+	if (attr->cap.max_send_sge > MAX_TX_WQE_SGL_ENTRIES) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Requested max_send_sge %d exceeding limit\n",
+			  attr->cap.max_send_sge);
+		return -EINVAL;
+	}
+
+	ndev =3D mc->ports[port - 1];
+	mpc =3D netdev_priv(ndev);
+	ibdev_dbg(&mdev->ib_dev, "port %u ndev %p mpc %p\n", port, ndev, mpc);
+
+	err =3D mana_ib_cfg_vport(mdev, port - 1, pd, mana_ucontext->doorbell);
+	if (err)
+		return -ENODEV;
+
+	qp->port =3D port;
+
+	ibdev_dbg(&mdev->ib_dev, "ucmd sq_buf_addr 0x%llx port %u\n",
+		  ucmd.sq_buf_addr, ucmd.port);
+
+	umem =3D ib_umem_get(ibpd->device, ucmd.sq_buf_addr, ucmd.sq_buf_size,
+			   IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem)) {
+		err =3D PTR_ERR(umem);
+		ibdev_dbg(&mdev->ib_dev,
+			  "Failed to get umem for create qp-raw, err %d\n",
+			  err);
+		goto err_free_vport;
+	}
+	qp->sq_umem =3D umem;
+
+	err =3D mana_ib_gd_create_dma_region(mdev, qp->sq_umem,
+					   &qp->sq_gdma_region, PAGE_SIZE);
+	if (err) {
+		ibdev_err(&mdev->ib_dev,
+			  "Failed to create dma region for create qp-raw, %d\n",
+			  err);
+		goto err_release_umem;
+	}
+
+	ibdev_dbg(&mdev->ib_dev,
+		  "mana_ib_gd_create_dma_region ret %d gdma_region 0x%llx\n",
+		  err, qp->sq_gdma_region);
+
+	/* Create a WQ on the same port handle used by the Ethernet */
+	wq_spec.gdma_region =3D qp->sq_gdma_region;
+	wq_spec.queue_size =3D ucmd.sq_buf_size;
+
+	cq_spec.gdma_region =3D send_cq->gdma_region;
+	cq_spec.queue_size =3D send_cq->cqe * COMP_ENTRY_SIZE;
+	cq_spec.modr_ctx_id =3D 0;
+	cq_spec.attached_eq =3D GDMA_CQ_NO_EQ;
+
+	err =3D mana_create_wq_obj(mpc, mpc->port_handle, GDMA_SQ, &wq_spec,
+				 &cq_spec, &qp->tx_object);
+	if (err) {
+		ibdev_err(&mdev->ib_dev,
+			  "Failed to create wq for create raw-qp, err %d\n",
+			  err);
+		goto err_destroy_dma_region;
+	}
+
+	/* The GDMA regions are now owned by the WQ object */
+	qp->sq_gdma_region =3D GDMA_INVALID_DMA_REGION;
+	send_cq->gdma_region =3D GDMA_INVALID_DMA_REGION;
+
+	qp->sq_id =3D wq_spec.queue_index;
+	send_cq->id =3D cq_spec.queue_index;
+
+	ibdev_dbg(&mdev->ib_dev,
+		  "ret %d qp->tx_object 0x%llx sq id %llu cq id %llu\n", err,
+		  qp->tx_object, qp->sq_id, send_cq->id);
+
+	resp.sqid =3D qp->sq_id;
+	resp.cqid =3D send_cq->id;
+	resp.tx_vp_offset =3D pd->tx_vp_offset;
+
+	if (udata) {
+		err =3D ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (err) {
+			ibdev_dbg(&mdev->ib_dev,
+				  "Failed copy udata for create qp-raw, %d\n",
+				  err);
+			goto err_destroy_wq_obj;
+		}
+	}
+
+	return 0;
+
+err_destroy_wq_obj:
+	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->tx_object);
+
+err_destroy_dma_region:
+	mana_ib_gd_destroy_dma_region(mdev, qp->sq_gdma_region);
+
+err_release_umem:
+	ib_umem_release(umem);
+
+err_free_vport:
+	mana_ib_uncfg_vport(mdev, pd, port - 1);
+
+	return err;
+}
+
+int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
+		      struct ib_udata *udata)
+{
+	switch (attr->qp_type) {
+	case IB_QPT_RAW_PACKET:
+		/* When rwq_ind_tbl is used, it's for creating WQs for RSS */
+		if (attr->rwq_ind_tbl)
+			return mana_ib_create_qp_rss(ibqp, ibqp->pd, attr,
+						     udata);
+
+		return mana_ib_create_qp_raw(ibqp, ibqp->pd, attr, udata);
+	default:
+		/* Creating QP other than IB_QPT_RAW_PACKET is not supported */
+		ibdev_dbg(ibqp->device, "Creating QP type %u not supported\n",
+			  attr->qp_type);
+	}
+
+	return -EINVAL;
+}
+
+int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata)
+{
+	/* modify_qp is not supported by this version of the driver */
+	return -EOPNOTSUPP;
+}
+
+static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
+				  struct ib_rwq_ind_table *ind_tbl,
+				  struct ib_udata *udata)
+{
+	struct mana_ib_dev *mdev =3D
+		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct gdma_dev *gd =3D mdev->gdma_dev;
+	struct mana_port_context *mpc;
+	struct mana_context *mc;
+	struct net_device *ndev;
+	struct mana_ib_wq *wq;
+	struct ib_wq *ibwq;
+	int i;
+
+	mc =3D gd->driver_data;
+	ndev =3D mc->ports[qp->port - 1];
+	mpc =3D netdev_priv(ndev);
+
+	for (i =3D 0; i < (1 << ind_tbl->log_ind_tbl_size); i++) {
+		ibwq =3D ind_tbl->ind_tbl[i];
+		wq =3D container_of(ibwq, struct mana_ib_wq, ibwq);
+		ibdev_dbg(&mdev->ib_dev, "destroying wq->rx_object %llu\n",
+			  wq->rx_object);
+		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
+	}
+
+	return 0;
+}
+
+static int mana_ib_destroy_qp_raw(struct mana_ib_qp *qp, struct ib_udata *=
udata)
+{
+	struct mana_ib_dev *mdev =3D
+		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct gdma_dev *gd =3D mdev->gdma_dev;
+	struct ib_pd *ibpd =3D qp->ibqp.pd;
+	struct mana_port_context *mpc;
+	struct mana_context *mc;
+	struct net_device *ndev;
+	struct mana_ib_pd *pd;
+
+	mc =3D gd->driver_data;
+	ndev =3D mc->ports[qp->port - 1];
+	mpc =3D netdev_priv(ndev);
+	pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
+
+	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->tx_object);
+
+	if (qp->sq_umem) {
+		mana_ib_gd_destroy_dma_region(mdev, qp->sq_gdma_region);
+		ib_umem_release(qp->sq_umem);
+	}
+
+	mana_ib_uncfg_vport(mdev, pd, qp->port - 1);
+
+	return 0;
+}
+
+int mana_ib_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
+{
+	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp, ibqp);
+
+	switch (ibqp->qp_type) {
+	case IB_QPT_RAW_PACKET:
+		if (ibqp->rwq_ind_tbl)
+			return mana_ib_destroy_qp_rss(qp, ibqp->rwq_ind_tbl,
+						      udata);
+
+		return mana_ib_destroy_qp_raw(qp, udata);
+
+	default:
+		ibdev_dbg(ibqp->device, "Unexpected QP type %u\n",
+			  ibqp->qp_type);
+	}
+
+	return -ENOENT;
+}
diff --git a/drivers/infiniband/hw/mana/wq.c b/drivers/infiniband/hw/mana/w=
q.c
new file mode 100644
index 000000000000..a11d0ae35ff7
--- /dev/null
+++ b/drivers/infiniband/hw/mana/wq.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#include "mana_ib.h"
+
+struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
+				struct ib_wq_init_attr *init_attr,
+				struct ib_udata *udata)
+{
+	struct mana_ib_dev *mdev =3D
+		container_of(pd->device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_create_wq ucmd =3D {};
+	struct mana_ib_wq *wq;
+	struct ib_umem *umem;
+	int err;
+
+	if (udata->inlen < sizeof(ucmd))
+		return ERR_PTR(-EINVAL);
+
+	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen))=
;
+	if (err) {
+		ibdev_dbg(&mdev->ib_dev,
+			  "Failed to copy from udata for create wq, %d\n", err);
+		return ERR_PTR(-EFAULT);
+	}
+
+	wq =3D kzalloc(sizeof(*wq), GFP_KERNEL);
+	if (!wq)
+		return ERR_PTR(-ENOMEM);
+
+	ibdev_dbg(&mdev->ib_dev, "ucmd wq_buf_addr 0x%llx\n", ucmd.wq_buf_addr);
+
+	umem =3D ib_umem_get(pd->device, ucmd.wq_buf_addr, ucmd.wq_buf_size,
+			   IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem)) {
+		err =3D PTR_ERR(umem);
+		ibdev_dbg(&mdev->ib_dev,
+			  "Failed to get umem for create wq, err %d\n", err);
+		goto err_free_wq;
+	}
+
+	wq->umem =3D umem;
+	wq->wqe =3D init_attr->max_wr;
+	wq->wq_buf_size =3D ucmd.wq_buf_size;
+	wq->rx_object =3D INVALID_MANA_HANDLE;
+
+	err =3D mana_ib_gd_create_dma_region(mdev, wq->umem, &wq->gdma_region,
+					   PAGE_SIZE);
+	if (err) {
+		ibdev_err(&mdev->ib_dev,
+			  "Failed to create dma region for create wq, %d\n",
+			  err);
+		goto err_release_umem;
+	}
+
+	ibdev_dbg(&mdev->ib_dev,
+		  "mana_ib_gd_create_dma_region ret %d gdma_region 0x%llx\n",
+		  err, wq->gdma_region);
+
+	/* WQ ID is returned at wq_create time, doesn't know the value yet */
+
+	return &wq->ibwq;
+
+err_release_umem:
+	ib_umem_release(umem);
+
+err_free_wq:
+	kfree(wq);
+
+	return ERR_PTR(err);
+}
+
+int mana_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		      u32 wq_attr_mask, struct ib_udata *udata)
+{
+	/* modify_wq is not supported by this version of the driver */
+	return -EOPNOTSUPP;
+}
+
+int mana_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
+{
+	struct mana_ib_wq *wq =3D container_of(ibwq, struct mana_ib_wq, ibwq);
+	struct ib_device *ib_dev =3D ibwq->device;
+	struct mana_ib_dev *mdev;
+
+	mdev =3D container_of(ib_dev, struct mana_ib_dev, ib_dev);
+
+	mana_ib_gd_destroy_dma_region(mdev, wq->gdma_region);
+	ib_umem_release(wq->umem);
+
+	kfree(wq);
+
+	return 0;
+}
+
+int mana_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table=
,
+				 struct ib_rwq_ind_table_init_attr *init_attr,
+				 struct ib_udata *udata)
+{
+	/* There is no additional data in ind_table to be maintained by this
+	 * driver, do nothing
+	 */
+	return 0;
+}
+
+int mana_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
+{
+	/* There is no additional data in ind_table to be maintained by this
+	 * driver, do nothing
+	 */
+	return 0;
+}
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 3a0bc6e0b730..1ff6e0d07cfd 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -406,6 +406,9 @@ int mana_bpf(struct net_device *ndev, struct netdev_bpf=
 *bpf);
=20
 extern const struct ethtool_ops mana_ethtool_ops;
=20
+/* A CQ can be created not associated with any EQ */
+#define GDMA_CQ_NO_EQ  0xffff
+
 struct mana_obj_spec {
 	u32 queue_index;
 	u64 gdma_region;
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib=
_user_ioctl_verbs.h
index 3072e5d6b692..081aabf536dc 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -250,6 +250,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_QIB,
 	RDMA_DRIVER_EFA,
 	RDMA_DRIVER_SIW,
+	RDMA_DRIVER_MANA,
 };
=20
 enum ib_uverbs_gid_type {
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
new file mode 100644
index 000000000000..559c49b72e0d
--- /dev/null
+++ b/include/uapi/rdma/mana-abi.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-Op=
enIB) */
+/*
+ * Copyright (c) 2022, Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef MANA_ABI_USER_H
+#define MANA_ABI_USER_H
+
+#include <linux/types.h>
+#include <rdma/ib_user_ioctl_verbs.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+
+#define MANA_IB_UVERBS_ABI_VERSION 1
+
+struct mana_ib_create_cq {
+	__aligned_u64 buf_addr;
+};
+
+struct mana_ib_create_qp {
+	__aligned_u64 sq_buf_addr;
+	__u32 sq_buf_size;
+	__u32 port;
+};
+
+struct mana_ib_create_qp_resp {
+	__u32 sqid;
+	__u32 cqid;
+	__u32 tx_vp_offset;
+	__u32 reserved;
+};
+
+struct mana_ib_create_wq {
+	__aligned_u64 wq_buf_addr;
+	__u32 wq_buf_size;
+	__u32 reserved;
+};
+
+/* RX Hash function flags */
+enum mana_ib_rx_hash_function_flags {
+	MANA_IB_RX_HASH_FUNC_TOEPLITZ =3D 1 << 0,
+};
+
+struct mana_ib_create_qp_rss {
+	__aligned_u64 rx_hash_fields_mask;
+	__u8 rx_hash_function;
+	__u8 reserved[7];
+	__u32 rx_hash_key_len;
+	__u8 rx_hash_key[40];
+	__u32 port;
+};
+
+struct rss_resp_entry {
+	__u32 cqid;
+	__u32 wqid;
+};
+
+struct mana_ib_create_qp_rss_resp {
+	__aligned_u64 num_entries;
+	struct rss_resp_entry entries[64];
+};
+
+#endif
--=20
2.17.1

