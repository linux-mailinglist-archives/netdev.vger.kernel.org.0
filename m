Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D71337B4A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhCKRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:44:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53328 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230173AbhCKRoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:44:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BHdiAq017831;
        Thu, 11 Mar 2021 09:44:03 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 377gn9hkga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 09:44:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxCqQa1T6SJst8FnGuWIIP5k//21Wwgk5wimevpKoRSAFRcrmcKDOegXoPcE84PPBqk1ZpLAxIiCFEsGb/Qg9dcmLkoHfduNcEwJzDoDOgoohF6lY61V+s9ZF2BMwi9/S8I1SQAvu9HcagRYPMtKETueeh7r4wbAOoOJJFbUucjvMnAGpIU9WCd35b4jTdEIwFlDxG8T9F+ONcfhk8f6CHLGQihRmzK48uCjDfEi0mdcCI6pnFyLWAgEUmm2QZQTRPnjnDBm15obbTq7GB0/Qdd0aozFoRcjI2Jq25pkulLBjM9lRmt49R7PCG53mFL4rXuBkz3EIyu1sUXgoI7RtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xG6Vba2CKyMgJjs02rThLsd2bm57yASnhx/1PEYbFMo=;
 b=SjC2nIT696ltbZoHOHAbqDlPDCEsu7ESGAInX6m+wFZq6RabdBdn6IezwC9IZm1ql4yOvMPq4RzhXoyKdObTS+EIQzbovf9H2cA3X6rAOp8vIFXXvvAIN/lJb7OoTw8zKBAq7d548q6tt7598fZby0HqaoDxQtLOlEvSUokiZfKXMjYRD6sNLLncdwDyC3zhW1b4wnMYeGg/ks0/I4giX3qZe17wnBAHqoqJuHXG5qaGo4xvYNL+uqCOhoedDo6h0cgRjfRLkil8qZeKZUznlhATknHhblN5p322tOMWFBZawzOpQ9iv3fBfkbPvakOSUFvy+zH6Y7thU2cYjkrPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xG6Vba2CKyMgJjs02rThLsd2bm57yASnhx/1PEYbFMo=;
 b=t8S7Xs+5YX8iPLKk8CpbpG0ycgXAzy1j6flk3byDT5tpw2ZrnjJ4sou1cMvS9UZjiuTHPNhB9CD2E+7p1vMbXItiEGToRQGpCB75Vvr5vAq3AAg+U90TrFwwZb/CJzv0E68j59RkOwJuKuQrZSUaBxAthEMsyOJAB+lC3br5q7Y=
Received: from DM6PR18MB3065.namprd18.prod.outlook.com (2603:10b6:5:171::14)
 by DM5PR18MB1450.namprd18.prod.outlook.com (2603:10b6:3:b9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Thu, 11 Mar 2021 17:43:59 +0000
Received: from DM6PR18MB3065.namprd18.prod.outlook.com
 ([fe80::7411:39d:9a90:faa7]) by DM6PR18MB3065.namprd18.prod.outlook.com
 ([fe80::7411:39d:9a90:faa7%3]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 17:43:59 +0000
From:   Felix Manlunas <fmanlunas@marvell.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Derek Chickles <dchickles@marvell.com>,
        Satananda Burla <sburla@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] module refcount issues in the liquidio driver
Thread-Topic: [EXT] module refcount issues in the liquidio driver
Thread-Index: AQHXFklvx9i/gRlQO0K4Wf6sBClIg6p/DuEw
Date:   Thu, 11 Mar 2021 17:43:59 +0000
Message-ID: <DM6PR18MB306560B6FA9700B884065FF9B9909@DM6PR18MB3065.namprd18.prod.outlook.com>
References: <YEnIvMOComLaaVa5@infradead.org>
In-Reply-To: <YEnIvMOComLaaVa5@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [67.180.122.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa4db7c9-f5d9-44e0-00de-08d8e4b540ba
x-ms-traffictypediagnostic: DM5PR18MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1450253C36A54357B6CD8D88B9909@DM5PR18MB1450.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6KXZoI864MGI32vHncvlDarhqJ2RsQp+MDl3OxO7XhOse88blM58CZtgkkc1Ef9x2d3/MP8JO9c3dktrezsSTYnQgrhA/TnxBg0ylDZAEgI58Yn3G6+0ob/bqtq75W1D23rG1AumuwSebCbORloRQlxOttn3C68i2zFh1b3iAcs1n6lBVt7gZ5iYwsqOJvoLSmCvNXjybV1vCChGpOQjLVGiMJFp/XNwts5cHC7pxj1ZjZA6P9fEOFAc+6re7vvXGysHjBK7Y4OhAAXV7BZTaG02jyNtSxyBd8mHiM6s3oQACUP3ayu6NuUxIgAEf+RLLNUyQFqlaYNNQ6KMU5ImjJBcXzzJt4d/5VQRYBBdzmtZE8S7IMPtQykMP58gEog9kdOi6nb7U0T/LMeQ2jSLGCXZ7clU31SZkB6N5Z7QSNhY52rnCnMrDorzMOtpJvkHyH014nktDn8BuRH6qwMgbPBvkxhSDSuhF9vGhBPT6vUKSZf1Y1PyKYB2LWbIZMRG5kiArBqYxd7umP+i10acD42ov801qJuyaDJuC+vJz5Bj39jVx0hjYQMsk4o3cCxB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3065.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(6636002)(86362001)(71200400001)(26005)(2906002)(55016002)(316002)(33656002)(9686003)(83380400001)(478600001)(76116006)(54906003)(110136005)(8936002)(66946007)(7696005)(6506007)(5660300002)(4326008)(186003)(52536014)(66476007)(66446008)(66556008)(64756008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EaRYGpcSibhiF7n6ugxYUWPO7abRt9esjh2jR+TW23JTswJAsA3E4IsJuS0R?=
 =?us-ascii?Q?Q1/hXZ0KeNlL/B1onqDHIF9UVRQHWcL1BQa0k2cURKrGr725ZnIjHO4UwFjn?=
 =?us-ascii?Q?7DK4G0gHx5T1jOfeJaVs8cXicQUF/o7E8ma9UN7gz8w1rSUFmKRfjdC4V6Gx?=
 =?us-ascii?Q?Je0QK4rFSMNBiMbcescIPW746TpwBjcEFozr9cYeayguy5A+uoUPDxg85M+w?=
 =?us-ascii?Q?i9jBv+dHYK+mg4SZDjmeCMsz5xlz1By23Xvd/lV4pCSzj3Bab+B0MCioq/lE?=
 =?us-ascii?Q?bP0NcxMLKtqcwXZb9MDMJnTPghDotcFkDdVzpoXxOe2WPRc665Q1OH5IC66c?=
 =?us-ascii?Q?PSp8s0E87cPa0pcr5WCnRBFQ3L0yoyWkenTHturcrrsdOF5KMendb0rMKyZV?=
 =?us-ascii?Q?WONiUsyNZDR7TmSPNkqMAeq2setOmYeAqBo0lyJ9/qZZATikfsbUwcgxpgqR?=
 =?us-ascii?Q?jQi6w31CA8ebI0ZCzQsceb8s5Grrd3sZ/Uq8hKMfaXUAx+SUShHm1x6FVkXv?=
 =?us-ascii?Q?9W6sBAyEpsNFGm/SCgtakogijr7qnvPbxwVCThs4o8X50Wwxeus6alaOZ0wu?=
 =?us-ascii?Q?TuzVj4YZX8pGtiF/cmjo2Bt2f0G6SoyCMEg3ymyU/Md3FEm85nLx6QitK7cz?=
 =?us-ascii?Q?8UexG0VOQw1UZhvmO95HV5fnmqnMRk9HofdoAPSH3Q8gbol+AzSGHXZMX4uU?=
 =?us-ascii?Q?354yIZXdl5/nd/UmOTz89OhA2u6DeicBbpoME5uqdtlRibmaGPqjtmG35Gnb?=
 =?us-ascii?Q?egN9bbARbtrtLoyebvvc20ux5wB3s5p5WF0v4QZczZXOw98QktSg/nFsK0Ia?=
 =?us-ascii?Q?wyh1c/QrdSc17aWNEdJ+9GVePFGZYETyxOb+6DPsEqsgKzD2AC50fYO8Vxp4?=
 =?us-ascii?Q?IBATnP2XpKZR4hzgo1suAT1HIRVWEjRgdlB3zylTMGLoeOXrwFfTkEsPwHIx?=
 =?us-ascii?Q?NHLQaDppT5jQjyjBud/Tux/VV+JRDi2dklM1AKzAZsIrGgSgmzffLCg4lpux?=
 =?us-ascii?Q?xB/XOKN+/Nu2bjyqxTcQMFsedontqVkd9Upp5jmiveRuQBIPDro9/GsTjfI4?=
 =?us-ascii?Q?8PJvos2exKPx8zEnV7b3yl1LysbcF88a1cEjndGpGrWDs8OVauvIKOYSH88o?=
 =?us-ascii?Q?YLtLYnZ3+o9pPzAS2gB9EWBgHtzb7BJQm35xznZ1rT3FaW8+r1Jt9tJLVn+q?=
 =?us-ascii?Q?deJT87QP14gVFrnIu3Pa5HhcX1h84TeDdq8ygL4h993CwwdEElT3bK/xmnaC?=
 =?us-ascii?Q?OoNsHfxfxDQaxBPoTNZ2NWkKbLTnHwW1ZCWc06U0qHnARKJvddKsGPCsZaMi?=
 =?us-ascii?Q?yDYR4xX/LMkrRPZLqNeqwOTD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3065.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4db7c9-f5d9-44e0-00de-08d8e4b540ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 17:43:59.8110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fYla2wiP6JZoQyncbdkJ6dCdrjJl0UfrOeDEliYeVfREqmRZ31RdCkXa2kSLKYfDhfovJ1OoZj5Fe47IEfGzuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1450
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_06:2021-03-10,2021-03-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed 3/10/2021 11:38 PM -0800

> Hi all,
>=20
> I just stumbled over the odd handling of module refcounts in the liquidio
> driver.  The big red flag is the call to module_refcount in
> liquidio_watchdog, which will do the wrong thing for any external module
> refcount, like a userspace open.
>
> But more importantly the whole concept of acquiring module refcounts from
> inside the driver is pretty bogus.  What problem does this try to solve?

The problem is described in the commit log below, in "(2) Decrement the
module refcount ...".

commit bb54be589c7a8451a0504924703abdffeb06b79f
Author: Felix Manlunas <felix.manlunas@cavium.com>
Date:   Tue Apr 4 19:26:57 2017 -0700

    liquidio: fix Octeon core watchdog timeout false alarm
   =20
    Detection of watchdog timeout of Octeon cores is flawed and susceptible=
 to
    false alarms.  Refactor by removing the detection code, and in its plac=
e,
    leverage existing code that monitors for an indication from the NIC
    firmware that an Octeon core crashed; expand the meaning of the indicat=
ion
    to "an Octeon core crashed or its watchdog timer expired".  Detection o=
f
    watchdog timeout is now delegated to an exception handler in the NIC
    firmware; this is free of false alarms.
   =20
    Also if there's an Octeon core crash or watchdog timeout:
    (1) Disable VF Ethernet links.
    (2) Decrement the module refcount by an amount equal to the number of
        active VFs of the NIC whose Octeon core crashed or had a watchdog
        timeout.  The refcount will continue to reflect the active VFs of
        other liquidio NIC(s) (if present) whose Octeon cores are faultless=
.
   =20
    Item (2) is needed to avoid the case of not being able to unload the dr=
iver
    because the module refcount is stuck at some non-zero number.  There is
    code that, in normal cases, decrements the refcount upon receiving a
    message from the firmware that a VF driver was unloaded.  But in
    exceptional cases like an Octeon core crash or watchdog timeout, arriva=
l of
    that particular message from the firmware might be unreliable.  That no=
rmal
    case code is changed to not touch the refcount in the exceptional case =
to
    avoid contention (over the refcount) with the liquidio_watchdog kernel
    thread who will carry out item (2).
   =20
    Signed-off-by: Felix Manlunas <felix.manlunas@cavium.com>
    Signed-off-by: Derek Chickles <derek.chickles@cavium.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

