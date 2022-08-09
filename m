Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB81858E02F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344027AbiHIT2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343962AbiHIT2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:28:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9878818384
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7C77LmWC/TWfT8mRnSV8c0ymVEjilNEtODfnw2zfbFZcW61JEclt7P4PL60ubz6A88dq+28TYeBKBjDWXMtPL68r+UM/2Kk9b3bTde4RhnHZdltbR52B6pwYtSC7upRxdPETcgEyjza01MOPOAR8mMMqn9cAmuxB2vRXj+/HSdOloExpshOVcOVFnH00WEPg2XZP1M1YKg0kG0cJ1deInFRskcmUwOz348lBfO0ioyNwlv+RkPzNfsJ/JD8B+zx4oILVVK7o2fRRuXgLzRZIydcxlinKVKaPhXSWcEiCR1dRLfiR4zLzXOet39GetczdvgAUZETng7It4vsk5vPoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aPW8GNAM1kKizZHOkaseD6tOT4hcsaYZgOAG1MLXUU=;
 b=lR30iaUDxGrBgc/096DRon66KC+86uA8h68euD2lSEUznwcpyQIx/zFG7J2FAJr22ReTJ7PPEqEkDCJQIguP3+yBXlMSAqUybZASuE3CZAt6Cr+VCAgNQ+ZwOFjo+5X27YZ8Oa7hoUPakDsnsIFadEBUYF4CV0qMmGppI98sp4AWPK3jADHtueGvlZpcRqNODsWAN2DdiYOeoWNqgvYgORnXPD613oXsoXrbY/QTJLtm9nsKY/GfMH4UzVFIr6fmwLe4v7vSi90mnBr8yV27DHD2Ss9LdOxhSgAwwTRMl/0HIgSgLPfCrH8ov10bKEwCpAl2xgefPiL0gej7vmaH4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aPW8GNAM1kKizZHOkaseD6tOT4hcsaYZgOAG1MLXUU=;
 b=ENoMebPO+JFyvoKJkddJT9LUOG5WQYYwxOHRQB3+mY6QXydYvt+tccSbn+NBhtyJ4njBHp3w636WVAwE4r6iCVgFX0/Ng98KZ9LCGV9CEZFcm+lZjCdNCF4elJqxOosR9Dt4lpLRPSexlL9Lf6ewXs0apE9J2QoK/wDaH2Fw+1nXwp6DyJitnnX/E0+cSmWoe7c2CAp70/XO/6z/fJOxKlR71fG8QW8v/zvhwobz6xMAuYB/A9kO3scQm0oPga+Bqjp3jbYNqsbWL0agtz8pESsHu48fm3RAoT2e9GSKdKZH/3C7Ykuhkx6ryO+LoHMMFE000k8ZPNKnWq36JxQDyA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 19:28:44 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%5]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 19:28:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYncLBTkGC7Q3QJk+hIdvX3SqZ2q2nD7kAgAAA6ZA=
Date:   Tue, 9 Aug 2022 19:28:44 +0000
Message-ID: <PH0PR12MB5481690730F8C0E892E843ABDC629@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <20220809152259-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220809152259-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cb609c8-78a0-4143-e430-08da7a3d5fa5
x-ms-traffictypediagnostic: PH0PR12MB7080:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6KJDtxMI6Ysnv/0opxz3IdweQlFNyDNX5np4oYG+vs2R1Sfuyuu+d2tWiAiUJHvd71qfltHKKCzL5OL53ONdZFzbiW8mUWWHbTVB7Xu7DrhjJkxvbYXmULeIXA6tUrp7DHN3GycMcyI4upSEyXNZQySNZYjFHO//5EZ+ln3gOl7YeixtjSy5ZRqvYT7YyW8ZDMTj3YCa1o4t/9OxmzmQrjyLTkOk/bOpaWYezeqrM/JdtCd4FCPcNUty6kqAyxsgvZVW9+EbmLkPz8uy+tlbEaf0lMva7HqbArmPzhDssEjPhcQYIqT23OWqPl5gQ3E+2aOD4PPx1/knae5vNVDWR/dKqEy6pOj1OgQ0pFide8I6YB1Z8gDaJJABOdC4ZwDbmTF+vQ9ZEQlVrIza9boOEG5/fk/oHmZQeQUtv4kwvgoQ2ZrQc+FpbZ8LlsMQ9cblRTpDnx+cnP932xxFtLGE8i1pq9alI0S2s1xuBnqYAUrRGbf0QCQdcIv0XUvQhVdgOp2wspy2i5JX9u3Z06YiJ5M5DXjNqTwziOoA+1+WrJBdblQrOMkH+ddn402RDreI+K9Xt0ZasOWTTPGI9lIdszRy+Y5ugCSljWrhsuMNBLnbOXq4q54FFlbHfAVe2P7xKD2ZdNNH5up65OTwS/LjmrIFMDfSaJeNSW4LJ+5g0EVy3B/i1kD5M1p6qOR6z8fy2HytKXFTHUKjwNDX0eTWuc4pUIODP25I2gh3GmGBtnuZqcIo3LEphmiFCOaeLGfKhPoby8jFpIXjWThXdRxbLq3kq1mfzrFhPd3crqLckgBGX83Hp30rUA04rzqPjem7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(33656002)(86362001)(122000001)(7696005)(26005)(9686003)(6506007)(38070700005)(186003)(71200400001)(54906003)(316002)(478600001)(41300700001)(110136005)(64756008)(8676002)(76116006)(4326008)(66476007)(66556008)(66446008)(66946007)(8936002)(38100700002)(52536014)(4744005)(5660300002)(2906002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bZBzkpWKHVWaenbVdo7gIHIpSMriS3lgf2lJuPPnNIS15UCQ7RGdM9wClw1m?=
 =?us-ascii?Q?KgF4+ovycJ4n2vNhX4ZvyJIsOtXQl9HWZ1UrzQdGQSitQStOM4nAgTwiwlRq?=
 =?us-ascii?Q?/aR0wavbYUKofGzx4VIBW3PhKcwQM7xMxH4UqS0qhPyvUT5FPZW1lBFKp59f?=
 =?us-ascii?Q?SBNh4ty44eKf5Ix7n3Hh72SmcL+BB83sUYOMBW7MLrWiGZBsuhv+X69RFyMu?=
 =?us-ascii?Q?q8S73cj+darWOdltcHJ2TEBHB0WOEKK+EdGg/nkGOFQM1kVEcaRSKO9YDlEZ?=
 =?us-ascii?Q?xv9nMxJoMqjL26DLXyRDAOSwKJNmXdtvr+in1SJpn2AKRIF624yXywpTZj0n?=
 =?us-ascii?Q?GeOAnslS10cCQRx4dJ35EaWAlMsRYoTSbIT2CKmHUrWz/4EvJ9xCL0YzF53B?=
 =?us-ascii?Q?QN5DUrNS/bFhp/l9W3r8BLZXvMD5OF+wOSRWrcCLwva7S7CRn2xFlanl1z8T?=
 =?us-ascii?Q?5MftNu+z1ZDzt8/PpcIq2nlj8U4ArORCg+y47YOyEFnKUPLc5bT6o25kCV7R?=
 =?us-ascii?Q?0iqxTzVK8xgmvwOdHWwZ6jonSb7jkvVJfDlq3ho3zUUXSJBNRZ1V7ND+gRpd?=
 =?us-ascii?Q?9lLCn4soYqdxurw5mulGqK2r2TR/A61mE8T+dubtNKgaM/iyKN+vEqEwL3Ja?=
 =?us-ascii?Q?QllLtGgkc0LNAssrnOnevmWLAQYpKBNeRvLpOiZA8Iw1TPmGbQBSr3YpN3X0?=
 =?us-ascii?Q?dK6tyusmZ7OY1I18WkOKrFZGeS2sEQ1JDfc9Bp3WVOlXuC2r6eOe7daE5+Ya?=
 =?us-ascii?Q?HDbsqEXBjrI7DoktthyAd6RRzDgYsyki+ua7le3c6DRfkUi1NE5Yas5h3+jA?=
 =?us-ascii?Q?0Y/masCYu4wa1PnQPvfVtnd1ZpxBEFN34v2hGwIT33VgVx3eGG/k9w0hpyEp?=
 =?us-ascii?Q?i7IIb/rKVFtti/m1i0fAkbrkJebLYlCzSM/C12Vr1hLYNSsrPOUssKFOvMrL?=
 =?us-ascii?Q?h6FZWIX0CF9KIyyEqazoRhQyVXQkQmqktSP7MlFBVA3DRgHfE5+gVHEo24eb?=
 =?us-ascii?Q?4cYAgpp4/BoSYNfKc9kjYBo1DuwyiRMlbB7npjBfu/3t7sTKIuMnfYBXRoQL?=
 =?us-ascii?Q?6hojzxd4GjSzoZwoRDOedc7gICtD9gIiTEaXNFhtlN8lzFpqAhogbHNjQVU1?=
 =?us-ascii?Q?MTBvWh8nXCyxnUomDKlyRnpV4AoUBj8M6a5iwjl7oqdwWPYBJgnSN3y7yZNt?=
 =?us-ascii?Q?+rOJQiZWASf+Ep7eMIqXT0q+hJAndyvDIhW4z6scP1LtQQUJhkMdbJwtQOCm?=
 =?us-ascii?Q?uSJKXXHbjtwjdQ0rBEcn/OVEqVJmd6Vtpwm1zBqcVjIYeGeaSmvbMRllqTJ+?=
 =?us-ascii?Q?hp17+Lha4lVijSaV8jRCz3Gg096YfiMtYJ45rtzDLQNRPi+VgiTiZGnfmA/+?=
 =?us-ascii?Q?Dmf/38yvc7DX7quozcTNca6+D7nNVBEXl+BmuOjVXbmtGCTMCCTa3k35aTap?=
 =?us-ascii?Q?BSa/LMroDMk0Y+YP8zTeKw9hSSG5NMg+Gzcq4s7cu8D27Rc+YvptmFPxIuAC?=
 =?us-ascii?Q?kpCPfafFYD45nQl+8bLUn8rNOmKOTCTbTZrE7WtBZSiH3Z5lkiIlo4182Hi1?=
 =?us-ascii?Q?6vFuYCNnfASzk4Qqsuc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb609c8-78a0-4143-e430-08da7a3d5fa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 19:28:44.2178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCCFdSwWSbjIXphHmAmZG41d2GQjpPQEehTMvCrML35Q98bOBxKVlu2SlPUMEqgG+yQxwo43B8Tdxn8x+iIYtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Tuesday, August 9, 2022 3:24 PM
>=20
> On Fri, Jul 22, 2022 at 07:53:06PM +0800, Zhu Lingshan wrote:
> > This commit adds a new vDPA netlink attribution
> > VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of
> > vDPA devices through this new attr.
> >
> > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>=20
>=20
> I think at least some discussion and documentation of this attribute vers=
us
> VDPA_ATTR_DEV_SUPPORTED_FEATURES is called for.
>=20
> Otherwise how do people know which one to use?
>=20
> We can't send everyone to go read the lkml thread.

There is no race here. Commit log is missing example anyway.
I explained multiple times that this patch and/or its previous version cann=
ot proceed in same state.
