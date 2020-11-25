Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6932C468E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbgKYRVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:21:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10457 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730567AbgKYRVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:21:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe92ae0002>; Wed, 25 Nov 2020 09:21:50 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 17:21:43 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 17:21:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmOHShBgqaZkqcpdmK7NZ14UmTt5qET8g1x1GPTSqFMH15paxpeDftYjoi/zTGFFdHGeJUsenQUEWUHsIIsqg117n29qHQIswOHzo5kUc7lWF46jBNdtbaQT5OcuPW5FjTIEhSpGDdoqq6Y4mAb6RdBL0loX/rW1HNOxrn4Awky/+OwkyCZgZ21jMw77lCT9GoALpZCTiBJ5TP5erxgjALjlizWfkQVRqUmouOMtzOqbIYuCF6Cz26xEucnHSFVbgIBkwYWMK8uIALYDayAJkYJhGRZdIRDkreZ+G6GLPzCBALRIt42RGFDeYJH1PuLvy8eCCtpPTV2BY0zatcUpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQZhN3o8uE0M1cgiDZX08rD1jP2MktFNUELzLRBguAw=;
 b=QWh6y1fimUxtz0IXvAB/2QwcL4qFtCRPom9L5YJlFNY7ufDHTgIjmydrTngaWMcke3q4JhRKtDD/b4tE4WyNdS6ic+1Eb3SVTNFRizfMFJwIbS16wLgHr3JKJ6O7Pibg7vz0Tn6HQaJ9l697tn/FbGxrpna8eYH+GuHZn7x/GqArzc/1deHFpd7oMP8p9elRO4TkXlvSO36VEEjqq7So65AJvuv25vXlykGufMzG3146TNexYe7mi4b8BjUEi6vThSpjSD9w+HyJFgzFTby5d2g7RhnQCuME+qFlwv44cgXJAUzJqC4xvfZPt1ULPdwKyOk7GDZInkmw1kO1YmDcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3623.namprd12.prod.outlook.com (2603:10b6:a03:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Wed, 25 Nov
 2020 17:21:42 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%5]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 17:21:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Topic: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Index: AQHWwJaWgnmE6THF8EOAVnewN97U66nX4UcAgACKclCAAKOhAIAAC3xg
Date:   Wed, 25 Nov 2020 17:21:41 +0000
Message-ID: <BY5PR12MB43224D7843C4E83D1100AC53DCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
        <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201125083020.0a26ec0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125083020.0a26ec0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7b18720-f43e-40bb-5537-08d89166937c
x-ms-traffictypediagnostic: BYAPR12MB3623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3623A4FB77C24B960D93A4DBDCFA0@BYAPR12MB3623.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vfos2TruRs6Lwyg92a09RqUsg7xyfqoWgv3qQ0J6d9WO8g7au+kV8/KVJnTAEGccMuKZtAfwB5i8D2lSqWNYB+wxxFy3fL4snYKDUKwYfPcYYMDAnG3fXqxDjvXK0HUY9RXizdCtsCmMKQ0UmSq6mQa66YojYkJhxcMIyZ33iF5iac6Ol59z3CE7BbhT4QbvveClVdTDWQ0D0C/OAgW3H8XdChBblLFasas9Cyy0K1Qluh8illveB6qmtiEMVhsc3e53zPzh+MGEV3/Nq1wan6DnVDMUdDk+EHD/vgWot6c1hol95BqzFc7y6Cocu2uz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(76116006)(66946007)(66556008)(7696005)(6916009)(66476007)(4326008)(55236004)(86362001)(6506007)(8936002)(71200400001)(478600001)(66446008)(26005)(64756008)(9686003)(8676002)(316002)(52536014)(2906002)(5660300002)(83380400001)(33656002)(54906003)(107886003)(186003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?I88PTyN1TOXl0CAZQ8jhN+8qvKhTliayvoCRH+pYNjJv2RbI1PqIhPN/QS2X?=
 =?us-ascii?Q?YAWQWMgKHMYsQJ68pThtccdpwMUzcrnwj4Zo6d8pokvZn3nz8PIE/oItBu0x?=
 =?us-ascii?Q?7eHS0yp4mfyQRM5b1AHNG7FBRa77MM7imP7TrEwYfcyfNW7ZQwF1OgLHn84Q?=
 =?us-ascii?Q?fX7Ic3gpY7pXyWpSQ0jocienQphPLX+KObSRogrk36zbKmOZ1s5YKa1gUYLv?=
 =?us-ascii?Q?D3pS3fVIl0UziEAG1sE6FjFzX5qoL9DmQhbYkKANb/XhwirED/Gsv9FF5apM?=
 =?us-ascii?Q?8RJ+YNFldNZ5ZnyKg51OiNbXlM+yC0Vza23FbdKWHb3enCqLEqXrSCf62E8i?=
 =?us-ascii?Q?B27l5qoTtx+Z9/Bb7B/zUIo8FWdw+1RFRPS9uxKBVhh/sHNYo8iM0dcDh0EU?=
 =?us-ascii?Q?XbE9bbj4B2v58UEDKsnujvS06mCRQ8jfkKmf9t/mI249yBNBtf23edzlelCP?=
 =?us-ascii?Q?WLWDImbHMZIjzKawQldS3dN2RlIXnmPmOYFJYAGzfkO6ta1T9SM36ADHM2WE?=
 =?us-ascii?Q?nJXaLMKnDUvDAtnbvx2eoNk0ezoO5Y2F1t2WSr7YipHqJjVp9HA5TcAUcVTv?=
 =?us-ascii?Q?bs+61BbeCh3r0oeK4CD2aFvoKWosAFzy9CHDby2dDzzMjUDn4ImeFNltuYNa?=
 =?us-ascii?Q?aX1D3EIKY355U22CQ2lr9mLWWaZPztf0PyJ5EbtMLWYOQpCP6mGuFrNtsuoL?=
 =?us-ascii?Q?EeY3a4LB61EEaZHpTuRhLhA5sM3JXE4aToSYMtZcQqjhalLQTihFwoC2cUVx?=
 =?us-ascii?Q?V8RbAQU16VDbMalnK2EWzZmdfqiZozcrK/jAgtLaoxbMSopeV1lVk6WYRfew?=
 =?us-ascii?Q?QtV+EcgK9buRjZty4GBKs/hq0zCpkHr9VqLfZ0TsYilzPwmRxkBqSLAsd7kp?=
 =?us-ascii?Q?BCoyIdpKhXzq7ZXGlJVKa6PnQPbbbVinGUGTey82D5sR5lr/RjPlJ3KnrezE?=
 =?us-ascii?Q?4WYpGd1/1uxTQ7lQTP1wCrB9ajKif4Ox8IQlymM4l7k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b18720-f43e-40bb-5537-08d89166937c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 17:21:41.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkCbSXC++q2brfjOleAxjFhK/P8bEpnEDofCYHNKpkL4MTDkh+cz7KnsqHVN7uGXVzMUitwK7DmBGNrQZBKa/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3623
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606324910; bh=hQZhN3o8uE0M1cgiDZX08rD1jP2MktFNUELzLRBguAw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Ocv6yO5eP1m8J27+0OO/PhamQowyHkYdqA5NavLwsf0uu2jeM3Bkh9Ar9EnGqxFwq
         8s/Z21xYk+omFi4tl0wDLBtJvMGr024q9mRCOY94MlQmibLddGpIyGfyRCSIh78R7e
         HxHjrIAv4Kc1r2M4jfWUXnLi2Ck1rp+RYBX7tye0xGioelgRxDs/LKDZ4EIirtfCNa
         VdODfBEDfUYcTevq/O2rEchzVFkh4KfgKDOnLYR8s9dkELmmcNBcUOprgGwxZNFBjp
         1+paVc7vJXyYR+xuTQxkRY1YU0IuLBAdPp2+4HcB3jqOauPR2dlJVUbEKD+bIA2kqK
         1qef4clrpavZQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 25, 2020 10:00 PM
>=20
> On Wed, 25 Nov 2020 07:13:40 +0000 Parav Pandit wrote:
> > > Maybe even add a check that drivers
> > > which support reload set namespace local on their netdevs.
> > This will break the backward compatibility as orchestration for VFs
> > are not using devlink reload, which is supported very recently. But
> > yes, for SF who doesn't have backward compatibility issue, as soon as
> > initial series is merged, I will mark it as local, so that
> > orchestration doesn't start on wrong foot.
>=20
> Ah, right, that will not work because of the shenanigans you guys play wi=
th
> the uplink port. If all reprs are NETNS_LOCAL it'd not be an issue.
I am not sure what secret are you talking about with uplink.
I am taking about the SF netdevice to have the NETNS_LOCAL not the SF rep.
SF rep anyway has NETNS_LOCAL set.

I do not follow your comment - 'that will not work'. Can you please explain=
?
Do you mean I should take care for SF's netdevice to have NETNS_LOCAL in fi=
rst patchset or you mean setting NETNS_LOCAL for VF's Netdev will not work?
If its later, sure it will break the backward compatibility, so will not do=
 as default.
But yes, SF I want to subsequently.
