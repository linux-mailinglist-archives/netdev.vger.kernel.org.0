Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62DE514585
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356602AbiD2JmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354954AbiD2JmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:42:11 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266A18AE4D
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:38:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAnxlOcbG6owJDbnvv+C/sbW/tE1DSRaiP8wJJa6+l66y8rVmKGXIagNhmdqsSsOH8w2QEwNt56dsF3ViinawQ4mhLQZzy1rHpccUucaO92sysMQ69kgdt6k1HPOjW65qSMZWTPJW6JZUdRafClFuni1t4IKBuDVwHo/OvBXLRDMh1EAcCFIvS1vuSfE3z6LEDeUjA5R8DUujhZy0W8p1R+rRgorZjWn9zyyHL9PwpaLbm7dIJatdqBvaUuZABfS18QepSiMxcrLAclF+a3Al9TmWry++GPnk5XxHWq6xZuZHMs/aSRyO6YeURG7EJtO6po6qXfeGISBLncNg/WNqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZ04qSLF3inSABstQU7MjaLBj31ob+AOpEM8uYqLklU=;
 b=IlRvTC+ak8QKEtOuR4f2p71n+hEYUsO58Q41tiXcohDgh9UszqyAYAcEgMz6Oh5eEE7WpBiC1Zb4unrzbUqslAwHxcfZlNmBjMmRCrHx0tGHKEE7RraT7B4unnc6WOpnRsy0NEGBW+P2+dCfXOVWq0bJyW7y4uggX6/skM2DmUoPCOnsTIJEMopjAexsU12cOnY1kZsjrPzK2F55T64TYIzYqJhtO23ElKz4pC0MXqeMS068io04bsB8WhHWBLPgqfS5Hwt475uCCqGblnyV7SAleOYc8RxTcpdoVX1OXc3r3Ek11CB5yJmJnj3xVfRyTVL+krZLyKTLRIGd1tJG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZ04qSLF3inSABstQU7MjaLBj31ob+AOpEM8uYqLklU=;
 b=V3VMQ+Ta9Uy7s/NS7HOG6LgZ42eCnk0uzKtWbXJH/WdPsDw9yKEgliikIAGiJq/vpCGHLqjGsltrrR/hjAkB7mGBaZ/qyMny4bTGXMBtPcW4tmnqFJhVbXji2fQXMPTCqlJIy2XoVtDYUsQpbWiG4Eln7WEB1t9Xu22+by6pRpo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4833.eurprd04.prod.outlook.com (2603:10a6:208:c2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 09:38:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 09:38:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Topic: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Index: AQHYW0GuNYRSTEqn4026FUjTTdPmD60Gb0AAgAA0E4A=
Date:   Fri, 29 Apr 2022 09:38:46 +0000
Message-ID: <20220429093845.tyzwcwppsgbjbw2s@skbuf>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt>
In-Reply-To: <87v8usiemh.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f33436fe-4f28-4302-0e9b-08da29c40ec0
x-ms-traffictypediagnostic: AM0PR04MB4833:EE_
x-microsoft-antispam-prvs: <AM0PR04MB4833B37947DF8A7323664935E0FC9@AM0PR04MB4833.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+Rt3PFE49MxIXTcvpvJGvMdm+4dIpR6EttcC7aGCUdG67+hflGLR9h0Qb6Zu7ZesTW69p7vwfR1ClaZ6Hk0FYV1dHznvleUcNRRsC4W42JEB0b/eUxvAWICYrFfuow1UN7pHTF4Wn6TSLAHSiOoaMu8VP38nNTb7tBOWVz3U1dOGQRtoCpsnuqY7bysYAliE3Yd7wLVhhCqnUkoeUvJG+vMdqEbnmqtBfFhOb9ppObZCABm69Ot29Wbg34CG4d3oWtfAfztnqfd65ubk9JbNrohF5idZx2SwfVnMzeODz8PxCFKlcc6N1ZSphwHbncy5SmgLI6tKQ4DkTsF1Er3Hd99CmVAiR2c6j+C3qA9uf2F1MamqLsfRYAH8P4/C6fsphCChnrmStY1d0eTX+LepEySmdVhCppQiDwBoBvn6uXWhBCkZOiCA2s0CKK9zYVr/WT5RUB419efpWAXE2sGLDbshKLzxVxBCF8wX5v/sv2adDnm15aB7UUiNnVegN6XgZvApEqVpySOG38pks/a2pKY7jhSoqeCpnP7vFK2qk99V+o6jdOYwJulQSIQ2rGx7btNniHF47qrJN2eplU0LD1EIoB4Pd1w61txaeI1w1jvTmfkz5MHvLSL9Qq63ynVHrlG3h1NfRwtpZly2z7w678IkHRRYSiT81gCgFzCVGRdZrDhmOupsDwnxB4sWPMFHKkRyd1JbQxim2i/UPxmbtBfzHlEZSbTJqIc8rB56Knyy6duYmckjiR40jzLU+f4uQfQIWhlcRZJmhvs6bZzFnOrI/ivWnLHbEo9U4xCzPc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(966005)(6486002)(122000001)(71200400001)(66446008)(66476007)(66556008)(8676002)(4326008)(64756008)(54906003)(76116006)(86362001)(66946007)(91956017)(316002)(9686003)(26005)(6916009)(38070700005)(2906002)(38100700002)(6506007)(5660300002)(7416002)(6512007)(1076003)(44832011)(186003)(83380400001)(8936002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yn+Y7OPtRgqjkLS24w0S6Sr3Yhcd4f23LNRLabCJA/04nu4J/HI/H+DX9QZd?=
 =?us-ascii?Q?K4IemkKilIpxtjL++wUJJmPa7NhcxrljPHwvt8olD7oTFBO5f7SmniWf5e5M?=
 =?us-ascii?Q?mIEKi3CDEsVS0NyX0L65xOvhZcC2I6Mt1s+QBufD+GnMQwzSKRC2y+nRad/V?=
 =?us-ascii?Q?5LDQWC9mMc1abs0x8msGQY7nAZXUzDEO5b9ASvl/Oovzy3EbYSgdjelzin8t?=
 =?us-ascii?Q?MJmKgqxExPc07e18+uKmGf6JtkpDnUOGE9IeswIy8IkSMTS03UJ4Q+SBHTMe?=
 =?us-ascii?Q?rcm5DYpdLuRQBvEAitEruwgojAdHDmkklT7i47MY5y9jO/EVVRde+xzcsQnb?=
 =?us-ascii?Q?iJsJsnTXfJH/ymOhjRlYmBbA0D13ridUw4bLQ7tvKZ243w7/7hM5NHvL95Hj?=
 =?us-ascii?Q?h1xtgAGmyv+r8Hvy9brvjzV7ZWDdvOm3vo2uS2VVfFue2eCD9fRbqpHbMebo?=
 =?us-ascii?Q?HYHDyii9N+qVXAql58D7BBmnFW1b2n2v7vq1KmZuOXrSfhrz5b+Qplo8ExrA?=
 =?us-ascii?Q?Hbt+YpY8XCHXhgT4M1otqJPOe2hqbb56+U3Buh9L5MsxVsSiIN4Hc50j+cYt?=
 =?us-ascii?Q?qJ6M4sEa8tffObS6LmRMu21L/EQnfD87XO+oIunC4k3mpN4lFw/FdzMVkU1N?=
 =?us-ascii?Q?FyGt6d1sSWz6lAIouwjaJU6t7CJnBfL7f437+Fbow0T3UOMvn4dg58c1SzUg?=
 =?us-ascii?Q?zFHrxrLYUpK6tNGqe6m8xFOJlwwuRVfcNI9faGffJzzudl3E66EuQ9CfPk8S?=
 =?us-ascii?Q?EW3qsXWFjBcer1Hd5vjIczPdRi4qhx2WrguseXW7UeLGexen7AbVS3qfIruc?=
 =?us-ascii?Q?ryv9YDe7FJRuHbPxv7hBgW+5Z0tYzCnIERQJ3j6i0Ebk5FCZlxEDCmUtk+Tz?=
 =?us-ascii?Q?NA6G4+Kxoxs2yZ5oM/kiJGWT6ujRWWGQ0ThoWs2Nu103wtPFPc4Sje26ckE4?=
 =?us-ascii?Q?JbGjR4y5itXTJDleT+cBFCWxjZpkSDsUqu7C3VukGPw3Kfva1/99LuUZFYYE?=
 =?us-ascii?Q?YNbd5OsZqdWD+TcSdnGJGU8Oz8bqI5sdotMeKPd1S/veoH+/EehRd0hNcWPN?=
 =?us-ascii?Q?9//67B2ddNxZVVdHZxG5oGJIuyFy+XigAnevYsh0ij2h6T90ztAapVuI3A7b?=
 =?us-ascii?Q?GC9NT3eW2XycbSsJSk4ZDON5eowSFwNIMOQj/lp/3UunRurrOUXyocd6BTkv?=
 =?us-ascii?Q?b3D2bF0aRZlucsBweEzlg42hEoZ2T51CtXr70Dp8q92Owqh07xDTCFWfzfou?=
 =?us-ascii?Q?PbAxzmdGpdwFlr93l25CqEL413ykBUXetIThukOl+nk8qDbSxdX24ABr3vtM?=
 =?us-ascii?Q?+G89/ghPOs0qmnEm/N0HndOuuRSZNO4low3Y2uEFyd0hUA6JfVl5CwLpQxgT?=
 =?us-ascii?Q?bCuFVS3pWnoLVw+jC6ZJaYwWRZDgE1+2ZbBm0TQcdlOxsMhOtsKrsDP3FhGZ?=
 =?us-ascii?Q?8Kmn6gC1oEGFiN63gIyv5qDpSQyhfU8lcfe4DIo+p/VqPI/hOFzxhpABmSGI?=
 =?us-ascii?Q?0dGr/EbhiHxED5rIolmMITPuoJMjr9GtYFQhvgzcVGEXY6GaxzAxedBGhJMl?=
 =?us-ascii?Q?/edLYziLEF6HlGB/jh+HNR6Og2eE/BWyM0AcSpidJ13sMRD/EASuZipfK9Xz?=
 =?us-ascii?Q?4F23OPLae0sIxn3394XHM7tI8MJFm8SDGhqPKJFFyvcV8WPNO/mmOCAWWUTm?=
 =?us-ascii?Q?YlOI2/0fldL3X6TaUBwOBS6inLxUcmJ2QiutqLOFcFiu4+b+0ABnmS4keWtY?=
 =?us-ascii?Q?0O7jVzTEw/88cWj0zJTlXcddiFUr0VI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <017DF54761792D499B3B2C0002367772@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33436fe-4f28-4302-0e9b-08da29c40ec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 09:38:46.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LtShubE6/u3f/pwWRHxYGb9q8HHk0WljVdnzYdlnMu+oenM4x4BDFvCPuVk/ogE3CyBX2qyOwkdNJc9ZX6IjqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4833
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Thanks for reviewing.

On Fri, Apr 29, 2022 at 08:32:22AM +0200, Kurt Kanzenbach wrote:
> Hi Vladimir,
>=20
> On Thu Apr 28 2022, Vladimir Oltean wrote:
> > The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
> > which enforced time-based access control per stream. A stream as seen b=
y
> > this switch is identified by {MAC DA, VID}.
> >
> > We use the standard forwarding selftest topology with 2 host interfaces
> > and 2 switch interfaces. The host ports must require timestamping non-I=
P
> > packets and supporting tc-etf offload, for isochron to work. The
> > isochron program monitors network sync status (ptp4l, phc2sys) and
> > deterministically transmits packets to the switch such that the tc-gate
> > action either (a) always accepts them based on its schedule, or
> > (b) always drops them.
> >
> > I tried to keep as much of the logic that isn't specific to the NXP
> > LS1028A in a new tsn_lib.sh, for future reuse. This covers
> > synchronization using ptp4l and phc2sys, and isochron.
>=20
> For running this selftest `isochron` tool is required. That's neither
> packaged on Linux distributions or available in the kernel source. I
> guess, it has to be built from your Github account/repository?

This is slightly inconvenient, yes. But for this selftest in particular,
a more specialized setup is required anyway, as it only runs on an NXP
LS1028A based board. So I guess it's only the smaller of several
inconveniences?

A few years ago when I decided to work on isochron, I searched for an
application for detailed network latency testing and I couldn't find
one. I don't think the situation has improved a lot since then. If
isochron is useful for a larger audience, I can look into what I can do
about distribution. It's license-compatible with the kernel, but it's a
large-ish program to just toss into tools/testing/selftests/, plus I
still commit rather frequently to it, and I'd probably annoy the crap
out of everyone if I move its development to netdev@vger.kernel.org.

> >
> > The cycle-time chosen for this selftest isn't particularly impressive
> > (and the focus is the functionality of the switch), but I didn't really
> > know what to do better, considering that it will mostly be run during
> > debugging sessions, various kernel bloatware would be enabled, like
> > lockdep, KASAN, etc, and we certainly can't run any races with those on=
.
> >
> > I tried to look through the kselftest framework for other real time
> > applications and didn't really find any, so I'm not sure how better to
> > prepare the environment in case we want to go for a lower cycle time.
> > At the moment, the only thing the selftest is ensuring is that dynamic
> > frequency scaling is disabled on the CPU that isochron runs on. It woul=
d
> > probably be useful to have a blacklist of kernel config options (checke=
d
> > through zcat /proc/config.gz) and some cyclictest scripts to run
> > beforehand, but I saw none of those.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [snip]
>=20
> > diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/=
testing/selftests/net/forwarding/tsn_lib.sh
> > new file mode 100644
> > index 000000000000..efac5badd5a0
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
> > @@ -0,0 +1,219 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright 2021-2022 NXP
> > +
> > +# Tunables
> > +UTC_TAI_OFFSET=3D37
>=20
> Why do you need the UTC to TAI offset? isochron could just use CLOCK_TAI
> as clockid for the task scheduling.

isochron indeed works in CLOCK_TAI (this is done so that all timestamps
are chronologically ordered when everything is synchronized).

However, not all the input it has to work with is in CLOCK_TAI. For
example, software PTP timestamps are collected by the kernel using
__net_timestamp() -> ktime_get_real(), and that is in CLOCK_REALTIME
domain. So user space converts the CLOCK_REALTIME timestamps to
CLOCK_TAI by factoring in the UTC-to-TAI offset.

I am not in love with specifying this offset via a tunable script value
either. The isochron program has the ability to detect the kernel's TAI
offset and run with that, but sadly, phc2sys in non-automatic mode wants
the "-O" argument to be supplied externally. So regardless, I have to
come up with an offset to give to phc2sys which it will apply when
disciplining the PHC. So I figured why not just supply 37, the current
value.

I'm not sure what you're suggesting?

> > +ISOCHRON_CPU=3D1
>=20
> Seems reasonable to assume two cpus.
>=20
> > +
> > +# https://github.com/vladimiroltean/tsn-scripts
> > +# WARNING: isochron versions pre-1.0 are unstable,
> > +# always use the latest version
> > +require_command isochron
> > +require_command phc2sys
> > +require_command ptp4l
> > +
> > +phc2sys_start()
> > +{
> > +	local if_name=3D$1
> > +	local uds_address=3D$2
> > +	local extra_args=3D""
> > +
> > +	if ! [ -z "${uds_address}" ]; then
> > +		extra_args=3D"${extra_args} -z ${uds_address}"
> > +	fi
> > +
> > +	phc2sys_log=3D"$(mktemp)"
> > +
> > +	chrt -f 10 phc2sys -m \
> > +		-c ${if_name} \
> > +		-s CLOCK_REALTIME \
> > +		-O ${UTC_TAI_OFFSET} \
> > +		--step_threshold 0.00002 \
> > +		--first_step_threshold 0.00002 \
> > +		${extra_args} \
> > +		> "${phc2sys_log}" 2>&1 &
> > +	phc2sys_pid=3D$!
> > +
> > +	echo "phc2sys logs to ${phc2sys_log} and has pid ${phc2sys_pid}"
> > +
> > +	sleep 1
> > +}
> > +
> > +phc2sys_stop()
> > +{
> > +	{ kill ${phc2sys_pid} && wait ${phc2sys_pid}; } 2> /dev/null
> > +	rm "${phc2sys_log}" 2> /dev/null
> > +}
> > +
> > +ptp4l_start()
> > +{
> > +	local if_name=3D$1
> > +	local slave_only=3D$2
> > +	local uds_address=3D$3
> > +	local log=3D"ptp4l_log_${if_name}"
> > +	local pid=3D"ptp4l_pid_${if_name}"
> > +	local extra_args=3D""
> > +
> > +	if [ "${slave_only}" =3D true ]; then
> > +		extra_args=3D"${extra_args} -s"
> > +	fi
> > +
> > +	# declare dynamic variables ptp4l_log_${if_name} and ptp4l_pid_${if_n=
ame}
> > +	# as global, so that they can be referenced later
> > +	declare -g "${log}=3D$(mktemp)"
> > +
> > +	chrt -f 10 ptp4l -m -2 -P \
> > +		-i ${if_name} \
> > +		--step_threshold 0.00002 \
> > +		--first_step_threshold 0.00002 \
> > +		--tx_timestamp_timeout 100 \
> > +		--uds_address=3D"${uds_address}" \
> > +		${extra_args} \
> > +		> "${!log}" 2>&1 &
> > +	declare -g "${pid}=3D$!"
> > +
> > +	echo "ptp4l for interface ${if_name} logs to ${!log} and has pid ${!p=
id}"
> > +
> > +	sleep 1
> > +}
> > +
> > +ptp4l_stop()
> > +{
> > +	local if_name=3D$1
> > +	local log=3D"ptp4l_log_${if_name}"
> > +	local pid=3D"ptp4l_pid_${if_name}"
> > +
> > +	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
> > +	rm "${!log}" 2> /dev/null
> > +}
> > +
> > +cpufreq_max()
> > +{
> > +	local cpu=3D$1
> > +	local freq=3D"cpu${cpu}_freq"
> > +	local governor=3D"cpu${cpu}_governor"
> > +
> > +	# declare dynamic variables cpu${cpu}_freq and cpu${cpu}_governor as
> > +	# global, so they can be referenced later
> > +	declare -g "${freq}=3D$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/sc=
aling_min_freq)"
> > +	declare -g "${governor}=3D$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufre=
q/scaling_governor)"
> > +
> > +	cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_max_freq > \
> > +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq
> > +	echo -n "performance" > \
> > +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
> > +}
> > +
> > +cpufreq_restore()
> > +{
> > +	local cpu=3D$1
> > +	local freq=3D"cpu${cpu}_freq"
> > +	local governor=3D"cpu${cpu}_governor"
> > +
> > +	echo "${!freq}" > /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_=
freq
> > +	echo -n "${!governor}" > \
> > +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
> > +}
> > +
> > +isochron_recv_start()
> > +{
> > +	local if_name=3D$1
> > +	local uds=3D$2
> > +	local extra_args=3D$3
> > +
> > +	if ! [ -z "${uds}" ]; then
> > +		extra_args=3D"--unix-domain-socket ${uds}"
> > +	fi
> > +
> > +	isochron rcv \
> > +		--interface ${if_name} \
> > +		--sched-priority 98 \
> > +		--sched-rr \
>=20
> Why SCHED_RR?

Because it's not SCHED_OTHER? Why not SCHED_RR?=
