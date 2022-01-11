Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F259948B5A8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344706AbiAKS0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:26:19 -0500
Received: from mail-sn1anam02on2045.outbound.protection.outlook.com ([40.107.96.45]:31168
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241941AbiAKS0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 13:26:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esy5NsUjvRp7zciztg7giC7VFTHyIH8ONExOg1IQgUQqTV9SNaS81xfUXbfXkoU9iNg+rLg3Z27BuJsXSpjpG9d4zOxluGjHmY7XYkxjGu+Vg5WncgLnsmYpjEr7WksV/vGuF89q05yDcczXdPqwWdAiWfbxbL1qcpQmBjKqz8a4le34XeIRZOgLm0PzpG/7pZrDLySpNSqpwYJXLd2u5Kb6m6E8U954/J33o3+doyIcA654bStouP9gae1ORDF0BfVkrywAlYwizz8FdmasRL3l2Y9xKZhoW0eONki+60kT740mYhX6VaZ5iHIowmnwZuNrcz2d1o/pR1lFLq8EiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl2sSAMDdPmHq/QKpInXY3Wn888jBqWZVX9kP3X8gqc=;
 b=dGhBHjitrwWhF8drDTSq4IDqDRRABQAS1scOISwGFqOOoQGMV8ZzTw6KtjNCeWYDpZwi/5lgpzqMnaYtn68XRekoHUgQi5iIC6NM7afUne3w3gh8Fe5eUONypHKfUpYQkog9rDLOgCtKxddnS9Tz9u71na1vMokwYyzxpGi8RXyMFv6CjNFaCStyLl6jk3c8TxRKUiWLjX0gdlcu59gz5CUPZSl3QJDTTMxKaqrIEfHdUMx6oBmrSCQUY5nu2IzFwmpJ0wLih7S0RNSPz0jq2K3DnHZrvRdDFZoDb00djgwqF9+LDkdvQIA4CNRQRqEmX/czg6SvdcJ8WfHvyYuMCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl2sSAMDdPmHq/QKpInXY3Wn888jBqWZVX9kP3X8gqc=;
 b=skTxk2Ly80L5y1wbblQ6PTd/3Gx8ETzIHCgexFM6IEfGKvxM7hEyvOOd3A5lY1hwTmE9jaTASbdM42M43DMhYGEL+p2RHnVoAt54wUNec3cjTidH8t/MubhJ7bkzDUrywWDCQ45l1guT8yFEb1CEjoeAldFlQ9oGRbZayQaidjfNUgPVm0yw9+tt/s0XC9hRXlATaaT6/Ts4JPuUSAyU5ipGu0SFAX59QMNuD5XgfyY+oBfT6HJn1PlNA8Ej50DBCPMgg/ocagvwkoUkUcTGLkTAsDW6CxbDOmN93yKIEK2UaC30TA7tZu3x5CrqM/ABoTueA+lvHrRaJhPoc+nHXA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 18:26:17 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 18:26:16 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2A=
Date:   Tue, 11 Jan 2022 18:26:16 +0000
Message-ID: <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a992732-9789-4d54-cc1f-08d9d52fdb4c
x-ms-traffictypediagnostic: PH0PR12MB5433:EE_
x-microsoft-antispam-prvs: <PH0PR12MB5433421B4B7F7A6548E8EC9DDC519@PH0PR12MB5433.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hM//ypLdfyvuVRhG3Nn38WT7Ug1jLMtiYRJ8pnIkvcdSx7nHSXQB6Kwso8gQLYJ67uOKfGrlD31VBFNiTR5lLAZQhzAXSiNsigwyitUNpblma+T+EE6KsNScyV8mo8GcGwHMYvbsO5P96taqDkqn2VPz+bDHfeHMupS+rprhollJj0nyoucXslkfzMQAVur08amH0qth+uB1ZDwr1SiFIoxI6AtmzUm86kwGad+7ZS09c5x3eqPmzUkqFZMHJbbu22HtXxPnIE3ExDigJA3kbPcrAzcW5hfAp2vGI2Bj9g/E+3TFX4mqBkvfOklvUOneaudkY5Iiwxkf2YifoXkmXHMO3dqiZuU3v05t0E9sOpD8yC6L9VAnued8poQkbVySH6yhjn38zkD7zqnNTmWgMH/Hj7RD4cFdXqIuLKGdK/g0ACNtzHkfWhSpXZY6/yi60IFfVdyBElavyVNMg7kM0KVu6bUpGOFIb47P/tooR/RY/qfaxkQMoTMlemZp8YblEY5t/Sx3YTDK5o09XCdddIPeyCCbbNi+nz7czF27s7JdHelSpcvW8AV0+/bZP3+qwqmtHzcHUaCIdobBBNx757Bz2PZ0LSrMVuT3Xm2oO6iN1245ngGuvcM8XLxItFxhAifzocm2MOeR2LKR1oV0lGsbhiJ+RwAhpXmnhrIcwfzIO7Z1pukwE/eXkz/WV6UPbSFInilbG1rCJCFLfH2deg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(508600001)(26005)(107886003)(83380400001)(6916009)(86362001)(7696005)(5660300002)(55016003)(186003)(316002)(52536014)(33656002)(8936002)(54906003)(122000001)(9686003)(8676002)(4326008)(38070700005)(76116006)(66476007)(66946007)(2906002)(66556008)(71200400001)(64756008)(38100700002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RTODvKQK93hCFJhfe07SJadUw9/M4lcqyaxwrixNtuYUKMDTXKrjXgRyp8Ci?=
 =?us-ascii?Q?weCVxlpDrCUQkN5qbs57otu7toutxXItkcwt3ouXkUh/J9r/7/4jn5VYDMnD?=
 =?us-ascii?Q?/hOXmtC7CWziZVZBHIHmYcWW6N7X/xflYMb6TfF8441HgJZkMy8BCicFg02N?=
 =?us-ascii?Q?U4dQ7ZLOhUAdK5BJnAUCXefhQUeV6IXol4PgnboAMP5w+flZqlVEjFbJY/XA?=
 =?us-ascii?Q?SDwp+a28FanFZcgOf8rUEu4TjI+X+KIpAWUuNJdVRDkh1YxyI/YXV6HyRy6E?=
 =?us-ascii?Q?5Yi1wPLX8x3ijQM9fk6+eayYb53AUGYPIulQHNbPxmq45c/OFzj/Pml7Cbyx?=
 =?us-ascii?Q?jQx3GO6sunPERXD3Y2S4dhTiC2M63LtlXE+J4qYNA5+EesyxL/ZE2tocOC6G?=
 =?us-ascii?Q?sYZRXwSB7nRLNB/65Q7cqD/dhoG3zaS6A6Lp3D5lfSfAjYKNenw0S5KmdlpJ?=
 =?us-ascii?Q?ASs9uOLy3JCWBVlFS0vJnyEFDGESBRZoJURIx9o/oLyrwhvyFCCDE1AbteIO?=
 =?us-ascii?Q?nQdZ8epQeJ6CtOEsWw+ldFZP99rd/W016vkagnxLtrHY/M0afnjFjV9IMHfk?=
 =?us-ascii?Q?ik1FuaDRVxIPYSaAoFKivfIMy1fqVnxgPbqa8Fq7SpbDK/XSWjFgdgQP3kVo?=
 =?us-ascii?Q?BWXb8iR7CtDqkS9Bbn6MRKDOCxMUSXPi05aJrPbIJ6UjL+8FlnlfRcThrt8s?=
 =?us-ascii?Q?NrmeCl7Y2EkCQuYpBTr+w65t1zRG26x4HsAcpMZTk/bqXxDje/V/8zy0UpFE?=
 =?us-ascii?Q?9KtGqnDHoSXACUnmu0XtBzDTEA/FvsU2Bty2fyweVn0J1bNA3hNYcapitw1I?=
 =?us-ascii?Q?FIrQt5VZEJpe6pqUIS17FBFDGnJQjgTh3OQX+3f0uvNbpsE4S30kAu7IDeZ9?=
 =?us-ascii?Q?zcxIKwyMkx7IWP96K5ncKWYjllFweayef1hLN/ogN07N/MRlHJYyppXQf/NF?=
 =?us-ascii?Q?WuHZOGJAGZjca3uFO4apD1ZL17sJ69hoCS1lelmx0dZkqPb5KzLNS3OgDgN8?=
 =?us-ascii?Q?zB7mUdyIC6257YElmcPVHCW4EnQIYJMibschOn93PWtEaDVmBuFVB6+qLsm/?=
 =?us-ascii?Q?UlB8++s73WWtUyHvjLxGZfcAb5Ow3eNe3nvWYdsACMs6cskDzuAi4cZIMWEB?=
 =?us-ascii?Q?xOiWdN4bcdFrt3z0K03S55AvHJ5gchWuBlKxjF7GrBx0uz4DUuzliQUNXVrY?=
 =?us-ascii?Q?fOs/r97nU/jx5YvUjjcyxR6ueAMEQGrYKR7EIz9Yf+Uk9nOBxLn94Q1Yb6Dh?=
 =?us-ascii?Q?JM/WeG4kbBnzp1t4xLs0mfitHS6Pq48wXA1wxOR8qMnoUr8uQr85x07jazya?=
 =?us-ascii?Q?CSshBnb/03abUoFPl5lAmi+8QH/DZHlh7Of4/itxVX6qQH0DZkXBnNmUp9ne?=
 =?us-ascii?Q?mRivojVtvS6AezaRTzH3dI2fIqEWbsr29XPjyLpfYup437wCl++fkP201Jfk?=
 =?us-ascii?Q?fjxQboEkaJJoa8+8agozcXpunMVOTjWbtnia0D1vE1bOWoc/0pwt7r4Gv508?=
 =?us-ascii?Q?0yVfMkvNBTkv30wMNQXQAHwzevVuVIQmwC0KtR8Ga0R3v15e/ZH8nTtkGNW1?=
 =?us-ascii?Q?BD2yeE86Hqw7sspcbg+TV8TqwIlsi/Mk0Bu86lkpb3WTuQojFzXK22s3M/NU?=
 =?us-ascii?Q?ZsYce3pevTiK5gsSe4LBNbY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a992732-9789-4d54-cc1f-08d9d52fdb4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 18:26:16.8121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3U8IsAvyixjVmX5kdctcSLQ440Je7QGK3SKcVslP2QAvtWVxDjpYDOA19wTTX+5tYIEQf3I0KLdotf2n/z07iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, January 11, 2022 11:50 PM
>=20
> On Tue, 11 Jan 2022 16:57:54 +0000 Parav Pandit wrote:
> > > > What shortcomings do you see in the finer granular approach we
> > > > want to go to enable/disable On a per feature basis instead of glob=
al
> knob?
> > >
> > > I was replying to Saeed so I assumed some context which you probably
> lack.
> > > Granular approach is indeed better, what I was referring to when I
> > > said "prefer an API as created by this patch" was having an
> > > dedicated devlink op, instead of the use of devlink params.
> >
> > This discussed got paused in yet another year-end holidays. :)
> > Resuming now and refreshing everyone's cache.
> >
> > We need to set/clear the capabilities of the function before deploying =
such
> function.
> > As you suggested we discussed the granular approach and at present we
> have following features to on/off.
> >
> > Generic features:
> > 1. ipsec offload
>=20
> Why is ipsec offload a trusted feature?
>
It isn't trusted feature. The scope in few weeks got expanded from trusted =
to more granular at controlling capabilities.
One that came up was ipsec or other offloads that consumes more device reso=
urces.
=20
> > 2. ptp device
>=20
> Makes sense.
>=20
> > Device specific:
> > 1. sw steering
>=20
> No idea what that is/entails.
>=20
:) it the device specific knob.

> > 2. physical port counters query
>=20
> Still don't know why VF needs to know phy counters.
>
A prometheous kind of monitoring software wants to monitor the physical por=
t counters, running in a container.
Such container doesn't have direct access to the PF or physical representor=
.
Just for sake of monitoring counters, user doesn't want to run the monitori=
ng container in root net ns.
=20
> > It was implicit that a driver API callback addition for both types of f=
eatures is
> not good.
> > Devlink port function params enables to achieve both generic and device
> specific features.
> > Shall we proceed with port function params? What do you think?
>=20
> I already addressed this. I don't like devlink params. They muddy the wat=
er
> between vendor specific gunk and bona fide Linux uAPI. Build a normal
> dedicated API.
For sure we prefer the bona fide Linux uAPI for standard features.
But internal knobs of how to do steering etc, is something not generic enou=
gh.
May be only those quirks live in the port function params and rest in stand=
ard uAPIs?
