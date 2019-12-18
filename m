Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4A123CF3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 03:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLRCMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 21:12:07 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:14438
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726296AbfLRCMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 21:12:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQLHRktkHdpYgmM6hQ+/ltqwbIeHHfPwSngBV62dsZody/R4DTxt+lN1bmlIqyDMw2rSAV/Y/fMAu0R0O5mMtUejS0GuCHiZErkz8RuAmQAy2pw3VmU2U1qDWbQ4lMP8O+t83x9qU+YLGySZaxyJ3j7Q3JOx2AJ79VvqbFjNWiwlXmaNiES44Pcnokm/bMPJF04lrahZVQbm3bxtY8vjPMHRyiqrq/F/vAhxLQZWjjJVSr6gT4OmuOpBr1o0v8sxc7NE4XYNCY5jTflE27tD4yJLptF9YlYZ1c3APS7AG+rSAXqOQ4RcxlKHY9cfuq1Pphg7r/qPXaz91KX3U0Dbag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDcAmZlKf4vLdwxBOhWnNv8xHCFuY48VgjtwAev235I=;
 b=Aejcpzxpp9BlfghzdJtmuD//rDmLpVueiZHThpipYsVn8E8aaOpA8lTHSDjbToVBxR6p8mKiVz9UMq1/szin8otK83hwZPBorpVGKUH6KNZ861NWEIuWwjkP5CDUPCrGS4M8LWHjjbhxXxXboNpsBRKQnjKnHkpGgMxNVLnvQ61ABWWU4FfMhpKb76pdK5cT4SxFchkgdpW4tff/0KBdmgGosdwfUSSXgAXBODhwDAtzwXdeKbUItnkcCjf/5lNEzjhjjYz6wvVSp5Ccr8VzwJysq0gU7ir/yn06NMl6mPtvk/n+m+bhMk+81zQSWISvurAyJtn/QYlV/fCzXlLIMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDcAmZlKf4vLdwxBOhWnNv8xHCFuY48VgjtwAev235I=;
 b=gwGA+HcVKeQLBJblDt1XHffrMYQyXg8G/uXIIVC2ozQY1OyFaxeXlCHXk1V1zgseFpEJrwoILGr87+wSvb4kXs/PM6y3nNiTeZi4grchfiq2vqaKdgzV6QYRgYpqQbtAROYPFpbGjLcardSVNtFe2LR5DEybqJjdoTokwuaYjCk=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2480.eurprd04.prod.outlook.com (10.168.61.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 18 Dec 2019 02:11:58 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b9ca:8e9c:39e6:8d5f%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 02:11:58 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Topic: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Thread-Index: AQHVtCYMQFVIeYxyLkSR+ox4Z08Prqe9mZ1ggAANmgCAAANlIIABOymAgABCHvA=
Date:   Wed, 18 Dec 2019 02:11:58 +0000
Message-ID: <VI1PR0401MB2237EAFE8E7964DE6C3DFD97F8530@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <VI1PR0401MB22378203BDAE222A6FDCCD09F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
        <20191216.191204.2265139317972153148.davem@davemloft.net>
        <VI1PR0401MB223794F3A1B1D4ED622A3419F8500@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20191217.141213.638446762932310525.davem@davemloft.net>
In-Reply-To: <20191217.141213.638446762932310525.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 982276af-412c-4ae6-1e5f-08d7835fa97d
x-ms-traffictypediagnostic: VI1PR0401MB2480:|VI1PR0401MB2480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2480928A1DAC4E6C82D96BC4F8530@VI1PR0401MB2480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(13464003)(189003)(199004)(71200400001)(2906002)(66446008)(5660300002)(86362001)(66476007)(64756008)(478600001)(54906003)(52536014)(26005)(33656002)(55016002)(81156014)(81166006)(8936002)(8676002)(186003)(7696005)(6506007)(53546011)(4326008)(76116006)(316002)(66946007)(66556008)(6916009)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2480;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LmFrVP9OylbEXCmQ3QfswXnqwfi3yr8Cd6zy98QDzgNo5k2gPTDm6TOkinkStXSrRSj3k3CX5VV3kT8UcBHKEHCMzfjY9SXD8Emfbffr3+9J2ClqkhEZxFfrefrrlbYH1eFvCsI3rSLTcDdMINDy9wy6MHB0G1pxWLAv1EOCY/3/IxwhumadffApm8yeLk2TedO65UBWJtX7lLvjgk5kTFHrcT9nb4u7UpYZKqA51bgfradyvDWLWw7uUO7VLio9KVRKTs7NOVLV4x/KHAZQ1hjd0Mirn8US6ySxrBnEq9Gfoj18bS14Ffsu03Tuid3BiJiJPrx8bEnCS643Of0fVIx36OJrMeqTTdx622vmUMVz2rvAb7+DelU1l5nYO0Jh+fR4WssraeNUBvVJvCau7AuQ81Cvz4hhncyh+FIn2o1se+1jcP0rudpKiBZ9SiE1NjflnxJlEDQer5OEDUrEGYHfKr4kZnHPYdXkgE0DqvWBSdOSbKD0YSbyn5I+GBGo
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982276af-412c-4ae6-1e5f-08d7835fa97d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 02:11:58.3186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPDqa5xFbB+sD9QdOrsGgp0LL0O7ogO+rSGY0FANnaFq+r9DT9vmjVfPl+0o7nUsrdmYRrL7XA5qIUNEHQjHXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2480
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, December 18, 2019 6:12 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq I=
RQ
>=20
> From: "Y.b. Lu" <yangbo.lu@nxp.com>
> Date: Tue, 17 Dec 2019 03:25:23 +0000
>=20
> >> -----Original Message-----
> >> From: David Miller <davem@davemloft.net>
> >> Sent: Tuesday, December 17, 2019 11:12 AM
> >> To: Y.b. Lu <yangbo.lu@nxp.com>
> >> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; netdev@vger.kernel.org
> >> Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the
> >> ptp_qoriq IRQ
> >>
> >> From: "Y.b. Lu" <yangbo.lu@nxp.com>
> >> Date: Tue, 17 Dec 2019 02:24:13 +0000
> >>
> >> >> -----Original Message-----
> >> >> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> >> >> Sent: Monday, December 16, 2019 11:33 PM
> >> >> To: davem@davemloft.net; netdev@vger.kernel.org
> >> >> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Y.b. Lu
> >> >> <yangbo.lu@nxp.com>
> >> >> Subject: [PATCH net v2] dpaa2-ptp: fix double free of the
> >> >> ptp_qoriq IRQ
> >> >
> >> > [Y.b. Lu] Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
> >>
> >> Please start your tags on the first column of the line, do not add
> >> these "[Y.b. Lu] " prefixes as it can confuse automated tools that
> >> look for the tags.
> >
> > [Y.b. Lu] Sorry, David. I will remember that :)
>=20
> How about completely not using these silly prefixes in your replies?
>=20
> Nobody else does this, and the quoting of the email says clearly what you=
 are
> saying in reply and what is the content you are replying to.

Sure. This is a habit for company internal emails, but I will drop the pref=
ixes for linux community discussion.
Thanks:)

Best regards,
Yangbo Lu

