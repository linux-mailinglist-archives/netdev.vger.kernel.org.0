Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8AC309BFE
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhAaKeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 05:34:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32578 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230209AbhAaJyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 04:54:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10V9bFEW020268;
        Sun, 31 Jan 2021 01:53:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=HsN08aiuCfa89+wCqKapJWNqAs4B3L6/r33d9UcpO28=;
 b=X9srqgEgS6XoZvRIUz0n81odLfpGKJg4RTM7uOxxWYmJwYbqJgmjudYhvPNaPbnigSEe
 yu5l2Fyc7K+/mTHcUl4gpXuvq+YjaeAgYtXUQdqHVbhgm9EzSslSXR1qp2asBmqw9/rt
 t3kKk9Q+fgiyalSm9Tnn2lp4vhe26vjhwZ1uvVV933mtE1PoCXUM2n1MdIAnV5lWc9WC
 SDcLw3mKBLHP5nkLBktY5B3K8XHjmPzWP68oWUiqVE8M+rgWbKs2YASacTK7p690t1Py
 m64W8r5WYIUoJ64kjYbgjTDNGpbB4YfnB2t+YyvpN/TnT44WMOWIZ4kBAb6eMuSYF4sx IA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psshm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 01:53:22 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 01:53:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 01:53:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 31 Jan 2021 01:53:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0fnMIfvJEy+pBuzcJRuRYsieKRm+J5XmKrH8mNRKWvKfxpHwJvNDJ3saCbqV3jUVi9oeod3mFPXU/jwxTffdkciwUajB0TbICmI535c5x3iuqDFG6JUFZZlKnOJ8ctnhiKcfjiRovIGbScnPnRKYe/FHYqWB/CJe34YQeOxECNalHbKQ19ztBEF3Lwfbdh4KCKl5/SUQs6Lwv0wtx5ZnZH5kunheMu8+NUjkLhrSxxSzWMfzPgSF1HIK62arvDNikKIAmq32SEM/W6E+VXmG5MnQEACXuA5JvbW+Cfep5UFCqJaDoLOUbo0f9ibYR/sjuOi2Xajrzj4gzBSeHsL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsN08aiuCfa89+wCqKapJWNqAs4B3L6/r33d9UcpO28=;
 b=V4tnqTQNXzx7NPa/RtZn6HZs5p3CMCMknbriMu3AV8Ysxrq/LmIYRttmCQ0w5+5IWPkqKep5cen7WKq8r7y3PdqVjlXkLQ4hROLdR2UfD3sBbDRPe9A46BzhIbkWLggzsCcJYF3O9PtJX5by8xxWMfUT17e5TDQRSX5X3gOYYxaBbIYLI78Q6aiRw/vt/JiMtCyp0JHAlpnIyg34grHn6jg2Wz9bdQLE/q+3LoaPBGnSa48odNlQ64cD+65AvcQ7Q8vGN5GmYH1HhxMbr9sXoOrcClWLnkwHrVtosxYOSTBBPQn7b2wAuNbRDWAvBlL8Y8DI9esg458n+b4Eou3Vdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsN08aiuCfa89+wCqKapJWNqAs4B3L6/r33d9UcpO28=;
 b=DJ5NnkPVoKNWvcqGKyIzCk1ks/LhNAIBjn3UH0UXcFM1X/MDaJuh7ICYTfFokk/I5sxgqf0nCAgsCwHU2An03lx43eRFsNOsEoahnATqyxvqz5ZtnIEcMq2dW6nANvbYeCnER9YUGHfBS7x0SlHpMthyVxI8721AC8RccIRNS5k=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3641.namprd18.prod.outlook.com (2603:10b6:303:2e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sun, 31 Jan
 2021 09:53:18 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 09:53:18 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW9aPOiPqZIMA/y0u3Xuo4/7naLqo932+AgAOi7iA=
Date:   Sun, 31 Jan 2021 09:53:18 +0000
Message-ID: <CO6PR18MB38736602343EEDFB934ACE3EB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
 <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 143c6560-940d-4a5d-80a0-08d8c5ce099a
x-ms-traffictypediagnostic: MW3PR18MB3641:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3641B46FD7A8EABCCD1E5DE3B0B79@MW3PR18MB3641.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fzjKwp6KGJjFoyHRaUThTXuwwx1L6hNBgL0x1ba/zCgiau5uLH1jOdR1p9XY+Uu9YLMQmdYetSDFufZt6nC86LBVR2enbZdx4XcezaSraCAX3gY3R/YTgeZ5SuMGAA4ZOMNurF1+glm8XbD4kOVmvWjtlBWXG1U2A/GoCM777aqcMW4rI5ESu1I7r5Ulp2CvZSSXZQaAgiV4ic9fipBPBZqHk7dKXx/TbAxgWKkdqxGVB2RwHGFPLsc/BSPsy6PRqwPAXLBfghnx3zA6qNb7c3lXg7Lszv4mQ3kY85FpMTv3sc8MFTtMequM/4NC1cChlWuk8Xo7VQ3n464CmlTbWBoIhKpznTmoCWsBOytVc2Fi6spElKyjejyLn69gsbJvhS0SlPRZXvZ2U1OA/Z0XpRAam6fgbBcqviHK6SsOUemDchh+LYx6DjnZ8Ez9c+SpVadKQsELYkLzzGYxwuE4w1SYax+DAHB2bjyWBshVz65GX6G23P/ZXGk0gW2mWbqvB5JVabKfXDxw219xv8AZo+/G0QhRjJSY8vCdrvYtCF9s7sAhmIszwK9duDTLw6GIx0O2BUbn3tyKXg8rzIQdTz/9WvdlosuJiIIn6NbcMu4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39850400004)(8936002)(66946007)(5660300002)(54906003)(64756008)(66476007)(9686003)(71200400001)(55016002)(478600001)(76116006)(33656002)(7696005)(66556008)(52536014)(966005)(66446008)(4744005)(26005)(4326008)(6916009)(7416002)(316002)(2906002)(6506007)(186003)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YSjibkWSbOUt8CKeoXrC3qIoTeEt48gEOkxdtK2cZY8N0i0Z7xAG7LMmqeoW?=
 =?us-ascii?Q?YieF7bFMqBIYCpxOo4Ka9Jw0+y8SP8EjfE308y/24NhhJWRPCLlf54NR2xfP?=
 =?us-ascii?Q?9hf1/o48OgXd9U05NqbPbpK/I3qcN9DQxZsG2+GlBSd/MuzIM9oDxC/L6VZ6?=
 =?us-ascii?Q?JiA6n0BQqnHCEPVli1Yu9DqmkRZWg09cYcAviHj2biC7nY2YRBRiBxyRlqNd?=
 =?us-ascii?Q?YW+WUKbsah3FMg2dAwLYAOB/IWFbFjQwLGgK3cJOwsmYkTybAOgq4JOdnb5V?=
 =?us-ascii?Q?WF5Lg4wGHrYmHgeWrZcOw+bhn+7OtYpRg3eS7AwgmXZnJHg0fEkRGrKWZEWQ?=
 =?us-ascii?Q?zYwkoKMPH+OX6sxF8zjqIrASTJsfge64z/Et+cs1bPR5ZhXXEEGPxLCF2822?=
 =?us-ascii?Q?wImtK8+9hrZLvKp2AbEam8pzXxRgSGk4njyCsq9E3Mf0T2kFu9O+wg+9KwxB?=
 =?us-ascii?Q?ljN53rYBb/QDh61F5Z+Lf00kltuIoZ14OmV6K0xvG5+O6L2PeDcElmk1pCM/?=
 =?us-ascii?Q?FPO31kJqRR1NJNAFSPYOZyChXdXjPsn5WkhRE/ChBUlj75EMhEWY03cUJ3QU?=
 =?us-ascii?Q?gxxVukG/AqhWj3C4tlXQvVMDWby+H0aFQ2KvwsMTtKR7EOcWfGpQiCqtknIt?=
 =?us-ascii?Q?8f/VRlNRkHFGN3bwTjwIL2pHDguvfyXR+UPQn83LFCBrvQWLnpAfA6vY9EqH?=
 =?us-ascii?Q?AuNMfzx8yLPA9PDQUKh/616/nAGh7/5yx/75XT1zDtwb7LD4Lm253VfjJK0X?=
 =?us-ascii?Q?hrua88AGrREwGznNX/10ypAgDReL+fp9XGaP1wiS5Ds+S4uDqDjYClUhPJkl?=
 =?us-ascii?Q?p/8lG2lryeELvLRDxP7fRqjv5FfxqEZZxQwAgGlbBQVF/2SMV5essMYtSeJv?=
 =?us-ascii?Q?yMZbSMway5OGJzV0YoJDwF4YXZEqCNfazgPEx2XsnFfvYBZbYEg6hLSBH7rO?=
 =?us-ascii?Q?0d/L+Skdy7eB2fudXNPzU2NkHvihW1AntD4xJ2lfe21IOjtA1wb4y+coo0Au?=
 =?us-ascii?Q?YVdeIQ/hOs6B7tkDY9A2YPbSZduI3y+H40RWHmhx1MUtw+jNCEW7xmWJH4wg?=
 =?us-ascii?Q?CLIQj4sX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143c6560-940d-4a5d-80a0-08d8c5ce099a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 09:53:18.6925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /VsD2glpPR3cGX09iRVduC5GL5sTrcGkgYyecMeEIK302BAp/+MfW9VBBQ85NRWj/q3w6wZWOwiLHOx3WpY6lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3641
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_03:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Hi Stefan, looks like patchwork and lore didn't get all the emails:
>=20
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_r_1611858682-2D9845-2D1-2Dgit-2Dsend-2Demail-
> 2Dstefanc-
> 40marvell.com&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIx
> KAl6_Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3DAFp2yfjV7t2l3c7dCM9lllj7Mz1V
> -
> 57354rTjjMB9_o&s=3DTK5AoswsdBLZNKNMI_rMiQQFtoLZf9UqEGQ40u7OHGI&
> e=3D
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__patchwork.kernel.org_project_netdevbpf_list_-3Fseries-
> 3D423983&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIxKAl6_
> Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3DAFp2yfjV7t2l3c7dCM9lllj7Mz1V-
> 57354rTjjMB9_o&s=3DBC2VcCRP0O0r4wywUHOgkqvleArWUsCGaT3Ue1-
> O6VE&e=3D
>=20
> Unless it fixes itself soon - please repost.

Reposted.

Best Regards,
Stefan.
