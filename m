Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F146912F6
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBIWJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBIWJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:09:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2090.outbound.protection.outlook.com [40.107.237.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB966ED1;
        Thu,  9 Feb 2023 14:09:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJo/Qta7C7/Wnvi7anvcVs4ehNE02dj+xZfGTKCSN5utWPyRc7u4+kT56fSjwF+6Jo3DSetoOzNhkBQHOrrCM+4XWvLDIFH/W+B0t8kQlemSLctJXvSH5sK6ZW3FHRFttePzgnJmOlNQx94OHzfdWx637GkRS6mbDmz4l1NNN72IWG/07lQuLlfyr/dYf90Zex/9E5uNsVZo7ldzbPDIoe0yvbGj6LGmxQXFKF6JY75Nhr7JVoBstRxSZbbvNspdQ6CQ+zqw9K+2JySb1MS8zoB5TyeheRx1EA3VeYFPlPVdwI+9DrhbJ61aOaqivZ8gRkSTzdQIhZ29lAHn6GY+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viGniGPOd0Nwu88IY6ABYOSyr1UW84tkWq+XqB4P4Ec=;
 b=Qt86Hz3amlfVs4TUtkLODziGglI3mO/1Om5r+QIniniG1yeyIOZq6WL+ecyz9hYJSMWBns1Y+XgqwOqb5cDnCsRItRNxQf5aCUB4u401syvrkopCZgeRCCzCru4wD4nAMSCzOZiGae62Zw77GWA8Q6xtM/E5+DyUeO3xste57VLOTTg1QJjEyRECZRXvpkfV+BBAfNbE+ikR/pBlC4x1ccjn2aJBi7c1yB3pYBQULw17JuyE3jHHasbw9CDKvRJc0kURsoB4RPLByWVlIKZnGwMIcARa0uvCoLLskmF95+tPTQpFqL9BhAZMBDjCBl36Kpub4iEdV4WZdR/MnxB8dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viGniGPOd0Nwu88IY6ABYOSyr1UW84tkWq+XqB4P4Ec=;
 b=VpiihaMQuM0WtXZ9EnzfR/9bvGGKDGWPHBs7jBeFhmtme7NEkvv/+9wRQ3tWtcdr6cDlzt+aOKfDvxypNWoKj3EpvByJY8JU62sonC9mva7gCnKS24VHdqb7g7LBu4mBUsZ0ZYSzaytQbRAJNCmCYrSofkoPUH8HKrcB6ukZ06c=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3654.namprd21.prod.outlook.com (2603:10b6:208:3d1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.2; Thu, 9 Feb
 2023 22:09:33 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.004; Thu, 9 Feb 2023
 22:09:33 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Index: AQHZPBgbiUM1q6p2m0iMKUdTxdvJsq7GonSAgAAvmyCAACoKAIAAFAKAgAAc9tA=
Date:   Thu, 9 Feb 2023 22:09:33 +0000
Message-ID: <BYAPR21MB16883D166E521A63532EDD65D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
        <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
        <BYAPR21MB1688422E9CD742B482248E8BD7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
        <PH7PR21MB311602D700C0FD965AF792F6CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230209122153.2b02faf4@kernel.org>
In-Reply-To: <20230209122153.2b02faf4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7df5f7c5-6759-495c-904b-774ea00c59d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T22:05:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3654:EE_
x-ms-office365-filtering-correlation-id: 43bf4a53-0ef8-49ad-da57-08db0aea52d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kmqB96haaHHRL/gFm8JxZCl2lKgdJoSxMVt2jcdjj2dMsKkDDUna+PnUU4lwMe14r3cyfn2WCczlogdBcDgtC9NLcU8GX5ZqJj3aZNabAsFhS9JvGNADP7rcXwBskVBgt2zdDdzyevHyf1EruiZQOyxVSH2GbV8O4uuNxBnYkr63Oy4dQCx4Wyd1+9hqCTHsrIpJpZI3b/lghWL9PFGO9+oJ5ZUwTaWe/TTQZesD0I+Po7S4wDp2iG+jGniJt1avwWPm8PfE/MvQXaX1fkUVhpM8aoQMJZKUTk7Tr14NGhPN0gZHM74ZlGkLOfdE0r8WDJTfhSweaLpQ/fhYAA2/Fao+ybtHIb1EQ0FqQ4r3xvGsJRiqpNV/LbGwUcMTwfJkqeEeq9WhxO2HINOtn1ePDPldampCsW7vgCGkMmYFGDd2q7J19mMizDl87rsam73t+o1W/KKQ1OSKJdKRbUnfXktXa2VnDnC33fhHvS5+feAyNUrVivqegRW+me5K3z6P0IMUfaO4ZE3ddatdgtnGlM05WQ2YXXLlTNghgErzbK3ua042dd2stJdg+XNwxiXVmJLgTBU7pnliIyoRLgDdyJri9jZSZ5t4ucW4qNNDSpAXk9ZiAqMLE3nQh2NjYSP/PetNrHGNW3COK9G+/Gi/naLa6pJtrd8SiPE4f2q1Y9AoUqOVrk6D1JmJOBpFTDikCDhTlECbOPsK53EdcUUcYG/ciuBtLgw97b+e1MficxFe2lgnFwykCGjv3r1WA8Jm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(7696005)(66946007)(26005)(186003)(6506007)(66476007)(71200400001)(478600001)(9686003)(10290500003)(110136005)(52536014)(5660300002)(82960400001)(82950400001)(38100700002)(54906003)(6636002)(8990500004)(8676002)(4326008)(64756008)(66556008)(76116006)(66446008)(41300700001)(33656002)(86362001)(15650500001)(55016003)(122000001)(2906002)(83380400001)(8936002)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DyQOPWGXLmZkF2bu3B36wsbD1SaWwoDSIpaqJtYjTMTk3CMt4rola3XPw0k5?=
 =?us-ascii?Q?85Wd3/3Fm8bOlcfKxIkVE/0EQOeJLbbPMCQDQBILPAl6lxHH2vdXipY7Z8Xk?=
 =?us-ascii?Q?05zSZlQGCNRYOIxEPlosX/slceyzzVGuR0I5glTC0mF+Kpg2Xft+Re2t5ANi?=
 =?us-ascii?Q?HC9nl9XiNDZJE8VFQcBpW9KNR+f1AHeYKjVkP9+GtojMoQvlHFwxaPGombOf?=
 =?us-ascii?Q?ZUWZtRYbs+4ZevVDkQWD0rp7vQuowWVYhUlhoYRnUbnUzNZSzid7Tpjf6zub?=
 =?us-ascii?Q?2lJiZHTo8X6/MhFNLm1ShCtuEasqi1QsyVSu/GjIWRaxl+jwrpiSZArrxJs9?=
 =?us-ascii?Q?L4jrncSHEuZrH/675D4I26fZaeban+ajxlm4K24bb8++WD52WibHwfrbnsJG?=
 =?us-ascii?Q?2isGh4K1CBRXpFZ4ILJu88F2yRu1KLPSRW55WHZ90kxux8WpvqeD8+oLLjTk?=
 =?us-ascii?Q?dpM2uDo4a3htlgko8YkxGuCYdxP0gyr0J4Yt7bcMVDmctWxZYv/k43dzDBhM?=
 =?us-ascii?Q?gUQRA/aFm2ZMNr70qF1AMBDPCZyX1eCTTL318sw36v2Wvgodu3RtWxwJhwTj?=
 =?us-ascii?Q?fnC5qfBCLvboLGhCSw3MZSJmzKL+4VkA0Xe3BhyTXv9mg3CSfqRxvjE7FvF4?=
 =?us-ascii?Q?mD4Bi07I41Aoz1XBx6yBAI7J4Ki9VzZaZQmyW3xC9jCf8wOPx80njJSS0O0W?=
 =?us-ascii?Q?RgOuudsGirA6nnzpG0yXXz962nNDIVS0RNxFqwsxearRRqXuaxR40K9i0Fd+?=
 =?us-ascii?Q?MlBCUuku8z2BBdy79k+06BT5KnX6krcSRncpKsVyCvjNfhf+4Y6o4zgDpZey?=
 =?us-ascii?Q?uMYtI/Dpm45Yfh3AI2yMGlIBI1uxl1OBdqclHPNXqEo5OjdZ4J/JVOElPvyS?=
 =?us-ascii?Q?pmMkylKoK/Whyn/obletEVLB/K1HbRpc5eDDQABAvuPd1goQuS1WWCCkCkv1?=
 =?us-ascii?Q?cwtSF56mLeTZ9M6nYfSRb8Vf/k47L/75uNMZfihjux2IaSEJIGLSSK0co6To?=
 =?us-ascii?Q?C44jFd7hMIT0R9+SChUEUoPq/FsKPIHoaN9J7Fyf4KopVxwfSHrJvc/XW7nm?=
 =?us-ascii?Q?8VXRU56FIdzA5C/3+ZztWkEd3JI61/QHRCKbvpSy+QMWC/CLRQ543wZaaEQO?=
 =?us-ascii?Q?ePpr2eeCE2GOWMcQyBIOXKDI9Z0svTQgcQl0lnUYfHxTPiqik/V8xcRxL+yx?=
 =?us-ascii?Q?ApiB4GOiDEzxMogX6tmyXW9o3nSLEHzf1DO2sGiW6OGrRuo/pehlZms0KIJZ?=
 =?us-ascii?Q?aCTm7kmuvcr5AV8muBpLEWlnT7npH8Iy5tkAHLADp9Onw0Dl/ZkOuNbN5TmO?=
 =?us-ascii?Q?Pdeuj+zUvlX08Bw7BsqxT22zzylFkT4Fy4qj0z/bY6+8r7nwIMHVSBE+YYot?=
 =?us-ascii?Q?lJOikYLn5GKlH0A0aZfQLaH7xpyzVqkyEJ7ujJYalgKfEiwnHHEuCm+LDMsD?=
 =?us-ascii?Q?vPNvRDPlaPKcyco2o3NCq8IL1Owq8yZMTCXFt2+2Xgt6GLodL809UaDGiNAD?=
 =?us-ascii?Q?G1XVMrAMYpqo2aZ1rpDC3NCVilJjxKnKbELH8ljF7FCC7lUNIO94HeSfl/Py?=
 =?us-ascii?Q?hMBbBPfukdnr1XuQt886BjV+VbryjbWSxlxd/Wf+a/+DzZ4/g9xYzXZuHaGF?=
 =?us-ascii?Q?Ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bf4a53-0ef8-49ad-da57-08db0aea52d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 22:09:33.1076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hk/zf98uIPqFA7ANTVuF76XElLeIVhauh6E9Df9QXKVVkNWs0ai9fMYDLaoEQbkqRWuWxQRXbrf4VTsP3MJ/cz9HMkCFPU9eELw0mDo3Ccw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3654
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org> Sent: Thursday, February 9, 2023 12:=
22 PM
>=20
> On Thu, 9 Feb 2023 19:10:16 +0000 Haiyang Zhang wrote:
> > But I'm just worried about if a VM sending at high speed, and host side=
 is,
> > for some reason, not able to send them correctly, the log file will bec=
ome
> > really big and difficult to download and read. With rate limit, we stil=
l see
> > dozens of messages every 5 seconds or so, and it tells you how many
> > messages are skipped. And, if the rate is lower, it won't skip anything=
.
> > Isn't this info sufficient to debug?

Agreed.

> >
> > By the way, guests cannot trust the host -- probably we shouldn't allow=
 the
> > host to have a way to jam guest's log file?

Actually, preventing jamming the guest's log file is not a requirement
in Confidential VMs where the host is not trusted.  Confidential VMs
do not prevent denial-of-service attacks, or similar.  But that's another
topic. :-)

>=20
> +1 FWIW, the general guidance is to always rate limit prints
> which may be triggered from the datapath (which I'm guessing
> this is based on the names of things)

Fair enough.  I'll do a v2 with the rate limiting.

Michael
