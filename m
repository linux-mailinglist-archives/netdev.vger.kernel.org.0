Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EFD466B94
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbhLBVXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:23:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21984 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376991AbhLBVWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:22:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B2L9jdC022165;
        Thu, 2 Dec 2021 13:19:29 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cpr523s4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:19:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCGZVTQleVL5pqylqKn2CnVtdAptZHvSLje97tu3Lf1s7Gg4TJtfcJeybK8bX7Yb5btUPTWysWUwVg2gUHXvb2vWEgLiKADH+b+TbvKGHWE3Jbrqiv4GHXPYDZcWUaX+MVKKSifKE6xgYDamOZJK6xE3YRMfHOplj7kxt+7WfHv8uXty8TqmaeRPDO+kc07YKIIH/Cx4j5fNbHbxyRzMaXeybjKWAYLsxhmKUkdaR+E5EQ4L7iIUZaIO322ljTH2q9/X2JmvQEmUpmmq9bLlCoeZUj+1wAJFSxa6WmyVC8Pp7ZnH42NCXlP9tVqPXpnPk4Uwuh8WP1tJUZoJYZljsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Dsv/XR5D6YsdQ7Pt9Esw4SWjJQ8471sM/METkMwJrk=;
 b=gSB6ZNYTaytZDC/3zz7IClLd5oRhth8DxcRZHXy7DS2AjOslE9QH1y3oAbQ5mMUdm1pcMOQsiap0iRHyJg0z2G6x3LQSil/VyDHVYNuTVlGtiE+aG7AZlDve+vL00SMzXNuhhlqp1OF14zUp0RNF2mGPtjW2MmZM3dnMuVZycJe2/dMzCcYtDTcU17S1bfShP5u9WKSCNdYz+KNlMzVMMQXJ6PQzZ4wJMETo+X/R+BG0O/LnZFDh8BcMbgxN44Aoqp9S4IPkF8MCVv4u6YQkxPnjRgNyShzdC4K0laCmCCStfYPjvsDER5cyqsBQ67PAuPfi76S79d03uFPGiXtskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Dsv/XR5D6YsdQ7Pt9Esw4SWjJQ8471sM/METkMwJrk=;
 b=ieyREQJHcxPAs8kjAuZcLNsA2y6nWcRr87KUjSHh8f+iSYG5vdu9EEAT8hNRi46Bylp0gAr7zwv1QpPP8QaebPbwSx5TbP2jKRNGvW1dAC5/kYEi6HRT59TGhA2wPKB3ZEZ0mGG8xCl/nPJ/bXiCmki+7gVeShS1Onf3LfTqZeo=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BY3PR18MB4532.namprd18.prod.outlook.com (2603:10b6:a03:3b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.15; Thu, 2 Dec
 2021 21:19:27 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::dcd3:e438:9904:88ab]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::dcd3:e438:9904:88ab%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 21:19:27 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: RE: [EXT] Re: [PATCH net] qede: validate non LSO skb length
Thread-Topic: [EXT] Re: [PATCH net] qede: validate non LSO skb length
Thread-Index: AQHX4RUGm03Eyc7hF0akaJ5UMWOF4KwTVooAgAxnpEA=
Date:   Thu, 2 Dec 2021 21:19:26 +0000
Message-ID: <BY3PR18MB4612B62FDA2167BB348D4051AB699@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211124092405.28834-1-manishc@marvell.com>
 <20211124153816.124156fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124153816.124156fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b55a1d11-4196-486b-3ac7-08d9b5d96be0
x-ms-traffictypediagnostic: BY3PR18MB4532:
x-microsoft-antispam-prvs: <BY3PR18MB4532B28281673355D7B6E559AB699@BY3PR18MB4532.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:530;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D0HVQY/aIyoo6b6ita81KdSvk8uaoYXUnl8jKuR7kIiWGd//q1WyD3Sug93Nnc9i1BRoMJe7SYHudJVahTbLKJCqHQDGfdXFVo9diTctsG7pYvWbwMdhc1mD/We7cRE3IpXMDZwcu04DlKylrfmCA7STo+lzaitRlNP5WBoFCdymD4DfQyJAIQWJOc0/RDFhskt4SjjUxVdzFWv5Xk3NDu2FA+TQQHd1a/XZpM1jeK+T7gOv9QJYoDfd9lQy0NqGj6ky0RQSo0qE/pVQOLILBFZ6gikEk38FNWzxhvaC4iEHNOQdH6SHtN0iQ2j5hocosEF+vDt/fC/3S/J4RCb1lJP4h1+1FcNYIYXTvHPdtmzaWszkFlDRSNTnrWTTDM3ZVawruV/xeoD+6ChRCncUJK1OTPH9L9V7unqPaS23958JlDmjX6t7lB9bnAZdOIoZ0Yt4F/R0qfanozqjY/TtZ18vHm4AHBwN22JHjdaNBWHvfOTV7BRWXEJVwxUBO99Shw5qt0tNchdsclZ+/u70MEoaNtMFUx/fuIajWB9y9bMFq08vBgNwh1XxHqmuSolVeQ1LI18qhtZJJFn5no5KkS/Z30BWdGhbRR0GKYrlF4EnGsoESeQ07SlFgXrua/lgjaP7l9/oIm0t4XAw+FcZA/qyDY60yXDLLua50GLMH4XjHMkIHIlDGoMhAEbtyo1TxvQM4Qrse6uklRsakzOazg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(83380400001)(2906002)(122000001)(8936002)(7696005)(107886003)(38070700005)(6916009)(5660300002)(38100700002)(53546011)(26005)(15650500001)(316002)(508600001)(8676002)(52536014)(71200400001)(66556008)(9686003)(66946007)(6506007)(186003)(55016003)(4326008)(66446008)(76116006)(64756008)(66476007)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?THeI21gLwZ+8gH4OxCAATejr4/QxlXwFg5DZwYEozUO8+rZax2S8xuTwvEV0?=
 =?us-ascii?Q?ob4XdBrFjZv/mONw/ffx9fM1JbCvHGjmpcHr+8fwWcswsr1MLMfP+qMYMc37?=
 =?us-ascii?Q?39kU442GH8cyhxCfRurP3juplnQCfg1gkDdxoGTq4KdUp8GvcJDItgEtX+/S?=
 =?us-ascii?Q?izD54QtaDsThWqZZACyoYWq0s/BtIlu5V3iRJbXzgsZex88MPVzXHDn7K6qp?=
 =?us-ascii?Q?5Mf350PUZHVf9MBR8CPLLwNqt7a+lmQVsshblBeK8jaD/wIUzSP5PF70QIxL?=
 =?us-ascii?Q?WVEq9sUT/YgenP4ex4aBgtQDDUvfp/7wDuBMyV+8QEwKXekN8nEjazgWyzWw?=
 =?us-ascii?Q?RKlotERJ7NZ0HsghSWlfrlM83YKILQ/umfVZyGd3xjz9aqu8/dsRow65vXo2?=
 =?us-ascii?Q?qV7Za6qTAc5gD+CLgv/Su2mhCkJzA8dpmyX0hf1zrRIR7IkrSj5ghQeCib7Q?=
 =?us-ascii?Q?YmAGe44XUXy3gH3wdD1YGjrfCPaU6bDx8A7CU6oKxqHiqTdBYFRCD/d+SIXH?=
 =?us-ascii?Q?Eu3yB6H5798ru3DfLlyxQyc7JIFRMHqUsj2MDC9vHmwYh6SX8QI8NAjsUWeQ?=
 =?us-ascii?Q?on7jPGic10QXgkrK2Gc+vns0f52cJWbneq7lUlwyFlLdcncOARVojQlIrp/n?=
 =?us-ascii?Q?hT4o9UWyZgGTUqM0lWjWZry6U1OjqoEOW+ETpy31sZAwwOig2TMjetdNKbwk?=
 =?us-ascii?Q?sjUPYZQ7K5O0SC6rJBiIX171D4WbKLuDyYSgTQjNR0LtmEpVXIBcRB3tJCYt?=
 =?us-ascii?Q?TvXQJoQnp0eSYR/BOX22XzH0LTXvCEhlenf2j02ggjsJZYDqfImGDv5kFsxB?=
 =?us-ascii?Q?26QNdtcubwiyWThKat8VHywICFxef0k5fpKMoo/aku+627wByJvpN3Ll3v1D?=
 =?us-ascii?Q?HXWS4JVCsmUx7qYP6r9MoB9lXvnN9bLbevWOOmhY5F2MLQQXrrsz+oh/dy0W?=
 =?us-ascii?Q?TkFp3vZvInGCKRnrKn9smv+iGUKoJP3my6ghty3WIpJgKjR5rutSzW5EUTKf?=
 =?us-ascii?Q?q0Ne6rWEcvZmsOx39A1lT1xZAVS8L/D1rXZ5kMfOiy5BUHL2KrKxewA/zEFa?=
 =?us-ascii?Q?CzaUjBSW4efnFoyMJUhqDXuAZAWVABx15/Yih2DESkZRitRUOkCTknbA6G29?=
 =?us-ascii?Q?FI83SihGzUZxOIykE9fB88E8RzREaR3gx8F9rDd1NgosMpc7ocieporitWsE?=
 =?us-ascii?Q?G4pXsOMlWhknFYGyZVeYVeZ2OAT51YHP6ZFljjAlQQM3iU14kVgA96kpV00d?=
 =?us-ascii?Q?NOyXSbYzRubY9jaoBW3/+jdQ+WLBUs/mvbfgaU+xQc9En0aDl/OgdrfdA8Dq?=
 =?us-ascii?Q?Yes2SqYMt4vVVqomxIYyESLgtPMASSPUVi8VfMFRRDi51Uf+vt7J7ZI2rRE9?=
 =?us-ascii?Q?Buz8/oOVr7iYCHb1bMgouO9NPzIHaCo107+EVh1/o3XW/Ylw94c/x41EZMaT?=
 =?us-ascii?Q?mi9cNwq4D2LGeAb4wBrI33xuCazlEer1t4lsWs6c7qE4/l5eZlVwRijN+uNB?=
 =?us-ascii?Q?lwM6qqvXxgfJE/mg9M2rp1jM1K9YTSWK12A83XsrP9igpi4Hqy42eDRF5pUd?=
 =?us-ascii?Q?cvf9+FAG8ViDgGsLPl+1AF9oC9Dj5qQOs7YAa6Em0Qov1TR6D8uY5O0/4h1P?=
 =?us-ascii?Q?sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55a1d11-4196-486b-3ac7-08d9b5d96be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 21:19:27.0211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lcpq5eGTyP5OEda/EiKbYCZOQ5GZ4P/S6IVXSICq7Bv8YYvCr/dF2A1FZQ6O1eX9sKgntxqKvLkETkICV1eimw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4532
X-Proofpoint-GUID: u57twUp5OqK5pyOBOh6SjMc1rC6SgDd1
X-Proofpoint-ORIG-GUID: u57twUp5OqK5pyOBOh6SjMc1rC6SgDd1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_15,2021-12-02_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, November 25, 2021 5:08 AM
> To: Manish Chopra <manishc@marvell.com>
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
> <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> Subject: [EXT] Re: [PATCH net] qede: validate non LSO skb length
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, 24 Nov 2021 01:24:05 -0800 Manish Chopra wrote:
> > Although it is unlikely that stack could transmit a non LSO skb with
> > length > MTU, however in some cases or environment such occurrences
> > actually resulted into firmware asserts due to packet length being
> > greater than the max supported by the device (~9700B).
> >
> > This patch adds the safeguard for such odd cases to avoid firmware
> > asserts.
> >
> > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > Signed-off-by: Alok Prasad <palok@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
>=20
> Please add an appropriate Fixes tag and repost.

Hello Jakub,

I don't really know which commit has introduced this exactly. It was probab=
ly day1 (when this driver was submitted) behavior,
just that this issue was discovered recently by some customer environment.
Let me know if you want me to put one of those initial driver commit tag he=
re and repost ?=20

Thanks,
Manish =20

