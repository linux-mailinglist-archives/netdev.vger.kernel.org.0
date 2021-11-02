Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778C0442C19
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKBLGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:06:31 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:21472
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhKBLGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 07:06:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIhhOsCN1rwK4jIMzW3w/Tjr6TAlfw7TxJfRtgDdBYPj+wosCbZ+6ekc2C5VMQWBqCAFwKCm8Qkd6ZeG4D6hsKFUGao+JjQ6jYz1n04bj1QtSVEiUNAo2P4x3oRMPWGdxg1nXpia/2ypUG9L2CTGoltszfjmqrPuBO4Ew/V6mw1FMkSaxXNnJHUw+rVM4C/srZx3t6n+6HiVXvR2jyrdV/RwZVvSFU2Iylgkut2hd1CnBIp8lP9UzeQc/epDjC3aVEWqJeBmFP041TcG3+aSQCGaCwlvDhJT7tRy4OJFZP2ebxMRdhGj3O+99NPfYKYimbDGii3wnXA58d8pqmzBgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZbJXYghKJSaVxGFOO6KR1P66fn81DyqNMrjR7pqh8Q=;
 b=eLAjwz3wq5HShxb0bs4l9bpR8Fc6co6s+e0seqzFr8RxQQjgIHlCkgtyaNtIPYcV0rGPsVcYyzaB2bNcPC3VStL4OyKZoNncPG5Wg9kyBJBOdZ3bfaPHJo80bVJAKXvBQsh6ISUlKe5L5XkdRNbOEGK8VpwtWzq1Fb0DS2HUwsPiVrtOgNh3VlR6UgjyA2OPJL7QhKOUBZxZJbgFGv0UJCU+UXnJo8NcLzaa4b5ivatTaWMdgMXBJubvlfyhnZIwyqY7jGre7O183yNURqpPUr52MgKIpNtxXsou8VnsUajMzkmNt9N5ikmXe9q0cwPwAa4l4TVtcetZjgiKJqkYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZbJXYghKJSaVxGFOO6KR1P66fn81DyqNMrjR7pqh8Q=;
 b=XvSctPE38TnlrfWM4qVBDTlMbCgkQuJiAgmtVyhE2QF045WTglHH+HDL5kvYMQtP7zql6GlI4u5k7ax/kmOT4tRkMrkL3oxukSBQ4W3MUKC4QExongV+9pZosBEzt+WFYsuQYGa7R3eVATUU36C6BVaL/Xw9qlF7WMZMHcvcKQI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6703.eurprd04.prod.outlook.com (2603:10a6:803:129::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 11:03:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 11:03:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Topic: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Index: AQHXz9lSx2h62F19RUufp+eb+7u3yQ==
Date:   Tue, 2 Nov 2021 11:03:53 +0000
Message-ID: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b87019f0-4276-475a-04c3-08d99df0754e
x-ms-traffictypediagnostic: VE1PR04MB6703:
x-microsoft-antispam-prvs: <VE1PR04MB67033B4000456BA9817CE0B6E08B9@VE1PR04MB6703.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r3cW/NWs6ZqPG7YQd4riSrafDjWH3tpTEm7i2XR/xbkguVA25fnVZwIPwXVzdKBx25kxtsWI1dW8UuS86MTfA0HaIMB/NrAMowbxLACOBsaYP9dENSa03uVUzbvx1hDWrJ3aSRPLeOcjS+n6HYHsLxGMeY+bYHhTbZS99FvQDmUdj/egwSiH6WwkWeQlmAa5BVXJzx7jZaZg8oOKKc+D/rmspCYxjqDEB9XOl4k9JWKeDp7i0Fy20kBF21N5GLj0igOcFVtTNnQbH3OHYKl+sC7Ykhv0rRl5QkwCWFOnNMSG9xTawFWL5p2MMf9HLNKyOqpB0cWkHrkZHWlEbRuaP1WOV2311jsLrjwU5RQ6tel0t9xwqvX+gECTetLVI0iw/VzWXde9VM9fMXM/4G9nIdRS1LGyTTieq3aFanFv3gfLGDz8ux5LVvI+d3c5MR1/5I7OAkB1dOcFAw43ho1vKlc320rdOHPnIl0D2xqqERDIJ2Fn5bcFJB2FAGrDqyOjeo8QWiHLpTKuP1T2gwzB3ZgIU5azWOvrW91YFwI6zFm8nvzl7yyGpoZVK120TFDgrwC5ybbey+gLia1qOsZn+LGbN/blRmBBAAkBLqmJiBNpOKjC/jtVsh6UoLl4ELszvxlU3EKkDvQwTSKuq8I/TCofUXPJcNy3pIV0kqAXflaaCpmoq/khgr2O14aXyWFNqV7s9IrBaoFA5zgunmHxBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6916009)(1076003)(44832011)(86362001)(26005)(186003)(2906002)(6512007)(9686003)(66946007)(91956017)(66556008)(83380400001)(66446008)(64756008)(508600001)(316002)(5660300002)(8936002)(33716001)(38070700005)(54906003)(71200400001)(122000001)(6486002)(8676002)(38100700002)(6506007)(4326008)(76116006)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ke7trWmta3pdHZpLnc95JM/d2wUa2wkzRpJi4UKVag8P4lE5NnrmOQNDseMU?=
 =?us-ascii?Q?EY+fOShcVxTI8ExLbG1IoTsFyRsJmzIO6aLyOcRWDSaKdis3BMV9Qiaw3ojJ?=
 =?us-ascii?Q?AyyEVNmENrPq0F2XOP8RhA9jfzVQl5iB+tjgEsryPpqW6jqVMAK7TPLjM04e?=
 =?us-ascii?Q?ziIBOHMKvUaBtYBzI1JqNsF4HtqNW+08sI0t6QVNaGtSmfGf6h53GPoDf3H1?=
 =?us-ascii?Q?kBRw173jnEyhqvFUrla7qxKC6kC0e+v47YprGElUHk2bF7+oDtvp47sObOXD?=
 =?us-ascii?Q?fcqamLltTaOTK48xVGfk5M+ekdXWFIuoAJykP4A9QUcOZ0C9lOLmGeFD9AC9?=
 =?us-ascii?Q?jYUbDpasYFtReFLw8vpvrxqmwwyBsFYfjHfvyaIhzf44hcxSSQLAQB+FliW4?=
 =?us-ascii?Q?nUwGSBulZXxEQzycAZeH3g5w2V7S+2alJmFTAuu4Pmjtb1llk266Q8n2lps6?=
 =?us-ascii?Q?G/NzhyyVoYa9Ri2UhM1lsJyUYEPtsWD3UuA5tRcfxUiNbzLfQGOCd97AIzOB?=
 =?us-ascii?Q?I6RjOSGTADSG3N7d4MqmRZn6gDm4cKihDvw3Kb08NZIi4HAf2AwNbyrX/N4I?=
 =?us-ascii?Q?z+hhvyVgpAp0ZkQB5q4ahDd6KvN9R92v1cny6zuC6qn/L29g8LNsnZzP0620?=
 =?us-ascii?Q?s3jyVSyLVrGwguVXf3tjG61VXQDtpqoQtgDMdmAV5OP+h0Sn2QQVcLoMyRCx?=
 =?us-ascii?Q?4X7ioVjDnXbJuNwxeL8kWtFYWmC4M8Js68446GbCEAWsrAerFbsmYGc+DsN2?=
 =?us-ascii?Q?cmSz9qufpCAQVf2CiZeCqpW+5Qp/RP1LTK1YQxOlxVf6g/7AiZrOOb6MXvqi?=
 =?us-ascii?Q?lK3LqWRrIFD5OukhWRV1xR+oBqOpd86DrZwJVhLGrBpHOhw2cC0MlIaWj6ws?=
 =?us-ascii?Q?ulB0cqVJAF4OyEFjmOSaDAzvSD13qPPuO1j6vblqKNY6WTazkMcPsmMWCnif?=
 =?us-ascii?Q?CH/tXIqOoWY698VfyfyZknyjoeIYJvf+AtY4eLSiqr73rkEvMHKeZEqO1Rqd?=
 =?us-ascii?Q?3kSSr/uayFPfegPydeKV5KxJpYqnAWw7omnpzKJheRirYbE2SUJUDJtmb4nn?=
 =?us-ascii?Q?fdYHwhM9bzx/UoVFHpuCBSo7q1+c3nZScooL3a9xv+jSFWWjUb8k9yYlpTS9?=
 =?us-ascii?Q?VVjHdq6Sy/H7o/KQZgkLMJAHnO+j5qyeey1lrTnnQ8u3FC8njNCEOBX/BRFe?=
 =?us-ascii?Q?QjcJqFoLR+/x3GbD/jVavoGKKHBeTqcqUrK62NvHVnza09KiM5Qn+udEdACZ?=
 =?us-ascii?Q?r039MKkkqY3B4DHMyyCzE2+CdzzSOqxvRdHarUL5tcQFwJ5Dz871pepQpSLk?=
 =?us-ascii?Q?tn2PNx+MWmL1pwCngmc/0kXFrUPi5mBCqYA/7I5Jazkczd9cJoFX8YmHAKoB?=
 =?us-ascii?Q?yV1YzWS95eKu4Q6AamQEMBnQYCpUVEQEqoXfeGDcu2XuGuusuS8ov67F4XS8?=
 =?us-ascii?Q?NmUURnI0+lR0kwQIkEofjKhq/8UQWAyYRUxvXwq5tffyy3+WrRqhujH+L+oW?=
 =?us-ascii?Q?F9YuCjCZ5klEHOvcqVkYZ4/sxv5qOx0/Lx2ygJJCpkpqTzEnh+CepMuDMMyr?=
 =?us-ascii?Q?jp5HMLqxEfoSx5ziNkVjwqIpE5taXQO0xiAO9oieY46G3xuQenTxDw7p2Hcv?=
 =?us-ascii?Q?iZiTEsvcaGDnvdCXrIeE79w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4BC5D5E6044D6148BA4DABAD49479385@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87019f0-4276-475a-04c3-08d99df0754e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 11:03:53.4475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5URvOnFMygaEkH7P9jUDg6P9G1wuHoqjII7eCD+uRyZw7lgyhJ2wMcJSl6mf2G/gcpkGRL1aURXe5yHeBaJ5nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been reviewing a patch set which offloads to hardware some
tc-flower filters with some TSN-specific actions (ingress policing).
The keys of those offloaded tc-flower filters are not arbitrary, they
are the destination MAC address and VLAN ID of the frames, which is
relevant because these TSN policers are actually coupled with the
bridging service in hardware. So the premise of that patch set was that
the user would first need to add static FDB entries to the bridge with
the same key as the tc-flower key, before the tc-flower filters would be
accepted for offloading.

Naturally, with the current bridge/switchdev design where drivers cannot
actually NACK the removal of a bridge FDB entry, that is quite fragile,
because if the user would then proceed to delete the FDB entry, the
tc-flower filter would stop working and the user would wonder why.
So that patch set has stalled, currently.

But I was thinking, the above case is not the only one where features
offloaded through tc-flower might depend on the state of the bridging
service (and therefore on stuff configured in the Linux bridge and
offloaded through switchdev). Another example I can find is where there
are some tc-flower filters that involve VLANs (either in the key or in
the action portion). Generally, switches have the notion of a classified
VLAN, aka the VID used for internal processing of a packet. This may or
may not be equal to the VID from the 802.1Q header. For example, if a
port is VLAN-unaware or standalone, the classified VLAN is pretty much
guaranteed to not be equal to the VID from the 802.1Q header, if that
exists at all.

Also, I don't know whether this is the case in general or not, but the
hardware I'm working with has TCAM actions that operate on the
classified VLAN, not on the VID from the 802.1Q header. Therefore, this
again is tightly coupled with the bridging service.

What is currently done to support things like VLAN rewriting using the
tc-vlan action is to require vlan_filtering to be set to 1 at the time
when the tc-flower rule is added, and then dynamic changes to the
vlan_filtering property are denied.

But the driver still cannot veto the removal of the port from the
bridge, or the deletion of the bridge itself. So this is still very
fragile, and there are cases where we could end up with broken
offloading for non-obvious reasons.

I don't have a clear picture in my mind about what is wrong. An airplane
viewer might argue that the TCAM should be completely separate from the
bridging service, but I'm not completely sure that this can be achieved
in the aforementioned case with VLAN rewriting on ingress and on egress,
it would seem more natural for these features to operate on the
classified VLAN (which again, depends on VLAN awareness being turned on).
Alternatively, one might argue that the deletion of a bridge interface
should be vetoed, and so should the removal of a port from a bridge.
But that is quite complicated, and doesn't answer questions such as
"what should you do when you reboot".
Alternatively, one might say that letting the user remove TCAM
dependencies from the bridging service is fine, but the driver should
have a way to also unoffload the tc-flower keys as long as the
requirements are not satisfied. I think this is also difficult to
implement.

I haven't copied any of the directly interested parties because I would
like to hear some neutral opinions first. Thanks for reading.=
