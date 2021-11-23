Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F30459B84
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 06:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhKWFWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:22:38 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:11425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229726AbhKWFWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:22:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEg0jQ55YY8BhVv02t6ghYEP7jFktRbpesOMKQekRAXhh80lYAUkELFQ1HFGvBTeU/eSybtNAXhSyMfwXrxzvgSB5003hzDz7Q1VRzzwz1n+qI/PlwoVsbFNisIeLsbDrveg/jzMe1aXHSFxrLocYx2IjsGgj3wKdUXUMGb+mLw5IHRn5JU3hhGU49C/JCFo9RZraK34CXxO4VyP8k8SQLLhUgBxREx0afhKcxio78hD0Pv1ZIz/OnbyADMHzhmXGByCDXFKXf+XXzHlZGfujNSiJXmAec2HURruoolhBj+9bo69oHYhMY1IHmjEJTnKv3HOuSS0PtO7Sorkf+l7yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTwsBu5o9gVfkBBK0E2UdL2wuQijWZnmS0x2HK5lCpM=;
 b=d6eDEHPaFXisxpESOhMHScoScJlgnSPEGi96kj2C5w7X93QBgHbk7TcY7YfcCYOGxrWljk/cBhJX33Q2DzgQcPm3YqONJ8G9pemxgxk2rsSL/aW+PIHJKVzA3TeXDpb+ITU9cClMeuzH2JlFrRLNsZNGOc0PXIiiyFGQ6a3Q+Iq/u0/Svd+gwMMP27Yy6+c23aTM9qIZW6AIR3ZLSxaG4oHoQR1uTU9MgygrOOZMt+ARszbAuHxZN/yTaHEuPpUFt8F2lB5P8dL07Hm2M6c3J9HhpFNyemN0rA+sAKFF3l+QArLeBSKIjbFv5lu7Liyk66vizXuKwqLPYiuuL439NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTwsBu5o9gVfkBBK0E2UdL2wuQijWZnmS0x2HK5lCpM=;
 b=rVf2siPUTviua2rv00sTgvXlyGeJxtlnxozfQbuGoQn/buao++xPzwxxdk2edZP4DtRJsH3A9BmhHwvHlQeagNXIAuIHMclZgFmY8+tnl3TBDiINXGqThklO4mnR73rREaG/VWswdVAgA9eo8cnqmvh/8V0rynmjGd0z2uP0oZxobIZjDkPZG4GVAimX5szkdXw+O+WCv6irFZ8hFKP8VJusjRNhTBWYBh7peBUKbhVy3//SbwCaAAx3c9dDCB3jXnuxtdEnGYhI1fiIyrskA7S+SO0W3yh5CtLlRoTqcLLqfVtPrWiV77MKHRY1SAF8ucf/YC8eciS4Kv9w5Dizkw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5450.namprd12.prod.outlook.com (2603:10b6:510:e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 05:19:28 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 05:19:28 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: RE: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Topic: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Index: AQHX3+WwpM2cBkHpH0m4XULVQ1XC+6wQkxDg
Date:   Tue, 23 Nov 2021 05:19:28 +0000
Message-ID: <PH0PR12MB5481F93DA9B6AA3C573E64C1DC609@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <20211122211119.279885-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20211122211119.279885-3-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7dc5e44-716c-4ced-c551-08d9ae40d2e9
x-ms-traffictypediagnostic: PH0PR12MB5450:
x-microsoft-antispam-prvs: <PH0PR12MB5450DCC65AC08882BDA839B6DC609@PH0PR12MB5450.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qQ9vsDIK9a4yWjGdp3SUZzbSmRu5t8PiQLnL1NBdG5AXdhB7Q2GOTP5h1A6dgs94TdMBs14yGiebyi3QfdRSKgHRfHG4xd/rAgETzTF9wJGA0GO9VSCW9wnuWivgaoGXRRp8m6T8maQoYQ2l0ljbXzzQ1a/wJE694oRFIXhKh7vBPwV6saVqQv3Du9brK6gNGBPFLu+3oUQmG3m5EGNgAvF6SxyySza2VlzpUwdo4M2PMTJC6R9hnLTlKTwbTTiQiJ2QoLv+sGrQQKVE0IcAb14S6jN07Fv4kOqghYi2HDY5IRKrxRiDaNBkwulUZ4OuTAZizMtxYCndaKdYabDUO8xwWnI8Y7gg35NqiaL/6dXkP/VTdIAsRcesfnbhrM93ePtkOvtc7Rk10fkw31N+n7RqDW+UPqT33rKsHAKbEqByDNXWlAXDLyyy8t9ACnA6T/hW+8i54z3PCsN7faG5NKb5m2qorEQh7n/8mbOxAgpH1FPPJLKxPuotBQtmbK2BUxUr2Z84UDZs/uppXpcId45t0/iH1vYinFZPjMqFOVQUh28yLPV4+1thfsa/A/R+cRCOYB4yxASEwWNFu3Xi0YixoAR/sSkkq27sl8PSC3xgHfVAkOi38Ue+3bJzrYr+SbM+He/73cF54oZrdcDhJ4vnNGrOB6d9RiEgiPbM3ZO32wqwH7kd0rk2KeVJoDTtf60/q1bfCmLQORgeOAC1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(8676002)(7696005)(110136005)(54906003)(5660300002)(55016003)(8936002)(33656002)(38070700005)(9686003)(316002)(2906002)(4326008)(508600001)(71200400001)(76116006)(186003)(38100700002)(52536014)(66476007)(66946007)(122000001)(4744005)(55236004)(64756008)(66556008)(26005)(86362001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yKg6QK/wqlKylod4I49JiruOlkPOmi7nb5HGFD/+6i0X5ezzL7rsj6t9r6Iy?=
 =?us-ascii?Q?ydNxpQ03vNthn7WqIaudxYDrf+FmPO+WREydOaVjrmA1cz6dCIRnIiPR8+9M?=
 =?us-ascii?Q?lP3f9BtTPtntGeQE4ZOWrw3ONQfxTp6udxpl+7zJ5GHFs4RwUlI7ZzMoeoFx?=
 =?us-ascii?Q?BYRWtK5tLPRuJ3vm9OtUEe6gdkTuWhhBFNBU3vyN2S107nn7ShCat7E/yBwu?=
 =?us-ascii?Q?hIXQIKV0SM2XTgeSL2YsL0KnUm5Mm5eCMTAUzwYlo0VEFnHBWh5vo5dAoiz4?=
 =?us-ascii?Q?Fg7mUDArVUmXtCr+DmcVealVSKsJQ+lZ1/YxLGX1EDgg3MY4NMwkGR5QCo4i?=
 =?us-ascii?Q?oq0aVf0S6yETXOqGzo4jP4abbq0nESiaHi4GQslV1mpZDlCEUJnMJzUdMzys?=
 =?us-ascii?Q?b03sd5tkgYYfCXbwO4v6bwKmaldyP+rG65EZu3onDLCkT9nAi8awI1RB92CH?=
 =?us-ascii?Q?uOkII99Dsb4Tptjj7VSdPmTDvme+/Dj0erce34JQyK3yz4Qxk/iEZnGInuRU?=
 =?us-ascii?Q?J1qvxLAoP+jn2UtblarA5CBKwLvIaUWjpO+mSHQwlJ41P7shJA2WZQuwC+tp?=
 =?us-ascii?Q?/RYuRLSjpg+KJoQDurpqWHS1iJGXWzqGDIuBPyuZ1qndVC9qrVaR7Q18ko5A?=
 =?us-ascii?Q?sbBahtVXpBqsNzZ8QFE94OQ9GLXLXjYr6V8NFLFhwUzm3xQYn00JR2oD8Zov?=
 =?us-ascii?Q?ywzMtvz33Vk/fa7rpbhY91JuD3bdnLxNKMGvzOM96pG9BgAcNK52JLE67OwQ?=
 =?us-ascii?Q?sByjlblQflLFJFJsh6yK1XvPmLdPenIfmkKXLY+er4CTizr34nAIkLF0IB8x?=
 =?us-ascii?Q?kqQFfpnxgQNJ35Tt0NmnPv3PEEz9M7Da7cTJ/DHklO/A79YxW89eAXRGQayI?=
 =?us-ascii?Q?aXm9n2VSRwNCBHatNFVbS1nXfvoVPn+uuKi5PG+mnudmPi3cYg4JpBHp9C0x?=
 =?us-ascii?Q?IcZyuNMbA5SCtMVm9Y2ymPXvMEhT8TsfaD+sXr7//zNkYeInyX26Dgwc2AZL?=
 =?us-ascii?Q?xhvqhOjet/0xWc4SW6psLBFaC8c3z3D0ANyUEk9b2OroZN1qME44DSWiEOy1?=
 =?us-ascii?Q?kCLSbMLR3uglFu1ZorPgCp/2zpS8FeicJpMjLe8NGbKPL9C1rlbollGljLF9?=
 =?us-ascii?Q?tdlJ0G609R6POoWWLbX751zmGP6dx0rYQqPb0V38Z9b1dzQQgRlDMSIy8Er9?=
 =?us-ascii?Q?/srI/LmcS3r6PXKGQXCfmPyDJQFYnHi3KzRPfKqKtgQ91f7y3AmOFvqfrlbp?=
 =?us-ascii?Q?4bygoYLrii6kR+SkLtRc3SWedFtxuqNfXziYbk9pvWdAfs3tYgvJsFk4QZuX?=
 =?us-ascii?Q?SPpjWlUsBUjAbGobSJSHenW7xpUTZz+KSCt0FEDQpo0LJk/c3gxW/dYwypk3?=
 =?us-ascii?Q?7ii63gLI05hRrvtRakjHA84XpXjw+C/nz4TRMkDwQ/lkMOjloMp7OWkoSJdd?=
 =?us-ascii?Q?j0WTYpoJnWo68RFdaEMx85Bwz3mj19cLKMQhtAW7FV5jFsyXz80aanl9E+Ef?=
 =?us-ascii?Q?dU4K5K/ax6HPfKxCBG+JwjDtEE7q5pg3w9+Gsooa7LgUyR5raZuquqQhBi+2?=
 =?us-ascii?Q?i5IuBZOrWY2KNYvOU5t1VLp1vlPZ/ST67aToyn+Ptpo7qrUubrp5wHoigVOb?=
 =?us-ascii?Q?tm5DPd1I6uGYtm9t1RV/JcA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dc5e44-716c-4ced-c551-08d9ae40d2e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 05:19:28.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yLe6+2eWVH789g21sOtWExlUkjJcsW4CMBhePh3teALLy3eVGXTrVDp39VSFR45sPnIzXXjo7JO5rD2BAbu77A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Sent: Tuesday, November 23, 2021 2:41 AM
>=20
> From: Shiraz Saleem <shiraz.saleem@intel.com>
>=20
> Allow support for 'enable_iwarp' and 'enable_roce' devlink params to turn
> on/off iWARP or RoCE protocol support for E800 devices.
It is better to split this patch to two as there are two functionalities do=
ne here.
1. enable/disable roce as first patch
2. enable/disable iwarp as 2nd patch

But I don't feel strong about it, as both has some inter dependency on chec=
king other capabilities, so either way is fine.
If you can split, it will be good.
