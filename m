Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B089493BB9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355054AbiASOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:08:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18428 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355049AbiASOI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:08:56 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JE3dfX031218;
        Wed, 19 Jan 2022 14:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f30pugDFqmUKOzWNYjQxwNAGaetR/52T2we4bKcM0WQ=;
 b=ic+EbE5LISr9sgDHJqh+LbDvtp7YO/4HHuUNKyivxz/sHcEnHeg4Cg/QcavduODYOJcH
 cQXmL4TZvdQqXHn62K4DVK7v+VKjFLy3aZvzAhLlgN8EkULLYVAnPpM5EjVinf+Q5W6r
 6voekMo4ffTnkxpW3wNM47b7J7bZN+ESmG3c1L92/daYBr781F5MZQc14OXoU1Cm+mAQ
 hpaAs6w27+BWaSEDItYQgxyiALBzU7EsqROZNVwXPV+eAEKksfZLEfVQ7DxvMIgqq0yR
 WIY2+EnP/orWXtRIxq+LXtv+LxXODKTIHe58ZFkCJ9mwAI+CGjzXn0yvizZIS8NzPSFE FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4vn7d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:08:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JE66Il082232;
        Wed, 19 Jan 2022 14:08:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3dkqqqe7f6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:08:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gm26FvZCzG321HVSUEcMW92G0CIxNqj5ImtHi4pzJSZUfr94cW2ybi25NpkApj9O9aDt44YcpIHn9oxcLFTbiG9Zsfa6Kt0mretIqeWdqS34+gzCJMH28YtzJZpK5J7Gym8n8Qx4mppYiZejlp3p8LY/TtaPlioC58fQEIagQfpLYIWNNIxlquikA5ssYnng7c2FyYR/FV+oayH1bYpxhK0z7sA2Lt4yz6psCi7P6eGskpjkWfUY+X59bBdUPRoaMe7+tZ3WUuqIL14ExMvGFFLZ/eAKbEI3VsZWtHrD0OKPUCZNRrXINBYdI8tv7WNFp4+vAV3jDlMCG8vPORAjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f30pugDFqmUKOzWNYjQxwNAGaetR/52T2we4bKcM0WQ=;
 b=cyd5Un/JtQ/ikMt7gtnZ5yMT0i02H1xUKWraIHOfuJtiniZd+tU1gh8KJlvtgqIr2baIS/JZkoDbVZCu/zzEsG4UCfddP0auyWcCqwqLL6xKYGjbgQmf08kH1jFpwRXpikR/Be4nGBEv4L3BhYatHNwDpG7iSoggUoFDDaqP+4jTwoijzkFWKUZZ9bDrccgnVAxusDS7nXNERfKQt1CmHgZkUdQ++Kl+BhsVb/mNvPKq8YU7tVKIyzZjjsbMu/z0MUpDg67Xvsd0iuRrbUC+BLQY6xFtI/5rZml2U25AE5MCThNt44bkz84JDCeLldYerD4tMuKWdXTMl5JQWLU9QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f30pugDFqmUKOzWNYjQxwNAGaetR/52T2we4bKcM0WQ=;
 b=i6kHVyvRcku43oot4BPObuVYK+KpU/rknhe9YFGeI7ALrynEbJf8MnT4Bfrcsjnz8x9m8oGk+bYH+pd792TRhWTdmLbn/pw9eSBVC5ckPHtfKtuxFkS5atw/BwttuEsABeNbxYZRhTDWR5bI3taFl7verUb7GYZEQ5Br1/Ov59I=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by SN6PR10MB2637.namprd10.prod.outlook.com (2603:10b6:805:44::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 19 Jan
 2022 14:08:48 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 14:08:48 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDHpMX8JHvK1k8kSJh1x30qsksqxo/YyAgAAprgCAAAb9AIAAvOYAgABQL4CAABYHAIAAAX/ggAACCQCAAAwU0A==
Date:   Wed, 19 Jan 2022 14:08:48 +0000
Message-ID: <PH0PR10MB5515039926FA5F66537A6EBB8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com> <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <20220119130450.GJ8034@ziepe.ca>
 <PH0PR10MB551565CBAD2FF5CC0D3C69C48C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <20220119131728.GK8034@ziepe.ca>
In-Reply-To: <20220119131728.GK8034@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1086db53-c818-4d48-899d-08d9db5536dc
x-ms-traffictypediagnostic: SN6PR10MB2637:EE_
x-microsoft-antispam-prvs: <SN6PR10MB2637ECCA3113CA60402E04998C599@SN6PR10MB2637.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQxRA5Jei0p3/Q4Th2PDqXgyoI73WFgXnSGIqXICVn2uz06Y4baQDFLuYPVhI6hiokCn08+hS8YLpupADqEJGtz+CCVDJmrYZ37HFJ1/+yyFUYRDKjMTEUGp7esbui12KDyDQ/BxIhCaEMBYbeerXz2Jc5NB6T+piOM4WKGlyKpHrbtN0MkeiEmOBs1+6lNCL9wHdPU2cbMnR8uyTWqe8jhIVOdvDbXvmn5n1YurIc4hPKVCXzqfyn3CHJs1G6Zjd7+XK582hqJ/9LksC0E3wTVj/Z3KUkWI9O4Yb1ynHODZPU9Omu2gED2Q+TExjydOv+NCCbUZW9X8MU4fuI92+IMSDsC2hbXZyhoGSv3dvb0fbtPQIstmodf5uS+xkFScWm/znnoGOQEwqnpXdNVMs38UJPqA9zp+D2Vdl1uCtBj29o9nDnQ7L7N68/+0pE+gtFdJ+w5QPDbldeltXLPQ9ud9an1AngQPdP37dv4AZlYOZabYNW9datlwsnjdg0Kv+OdBDY6CXAaYdA8c3swMSORHprc4viO7rgCEAQ9ivRJM3D6Hnu2t6hAhRSbEyJ7nWFlzbR0XzRddX9rKf0NgfN1/NobczQwpimKB2vJ60hY3tl/lDvbSnvqwvzvlYx33VFqTAmWzHPeS6ol9DGccbw51ijaXiKVwVtuvBOV2D+n+/h9iAloTEiRUwAHhGazf6UVDrjJ0+SBmm8snqOGR8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(4326008)(26005)(83380400001)(7696005)(8676002)(8936002)(6916009)(107886003)(44832011)(66476007)(66446008)(66556008)(64756008)(66946007)(86362001)(6506007)(5660300002)(54906003)(122000001)(38100700002)(33656002)(9686003)(52536014)(38070700005)(53546011)(76116006)(71200400001)(186003)(316002)(55016003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6q2eHj35sHLHE2HOsXjwAIJAuLf4x0XeL4cp0oXn5KUHFBWuI1bEJxrqLGc2?=
 =?us-ascii?Q?AnHLga4VnZBdfffmDP/OG2uU6hADUFpzIlCDyzNY3jtHG0/EW8bFteWlgSqh?=
 =?us-ascii?Q?XtqrXOUAWlGwrQTCnwTbxH4ru02BRUbf8kZgJxZ/ZmtuZ/fEZEq2szErTx6n?=
 =?us-ascii?Q?CKkzM0NxaJ9BTIUf6743N+cmX2BV0UsP8UU1k97jTD7eloYXkMCXbcpMzbSM?=
 =?us-ascii?Q?GCbTL0gGyXH84DQ4Mg2ZsEfMoWYaWGVKGf/qwcVP16iTg6lBriIzjYM92ktl?=
 =?us-ascii?Q?cLV7QILpKbBw88I6W36qaVwbcqWr/jqLcFx9QMZJmFk5HASqfO2WndmnPh1H?=
 =?us-ascii?Q?P7Ul83wp/YUpdQ+uc6p9ZlDVE97X1yu0RgAvccUDaHRHBNipycgg5FrKO+a7?=
 =?us-ascii?Q?ZLUlR6lNBB13dZ0/kDNGIkTlHaKsWRSb4URlyxaTjzqW9Xs2SWSVKZcTqOfQ?=
 =?us-ascii?Q?DIinTfeQRj6UZpd3ixUPzIKDf+Ocof8JU3FJfLHnF5BBUSh2qrYgU2ikIR+X?=
 =?us-ascii?Q?0q3d63Mp3/lsj0N0RBRkjyqPt3360aAU/1BMA2kMxpuBfQNLNCiGpcUYK0iZ?=
 =?us-ascii?Q?RAvvix0I3FLv/MmXkIdGER8GhHKfBqaSmLmgdNdysyghdZbV+flzjZxYNmA4?=
 =?us-ascii?Q?XYD62jPEeNf0tdiX5dyygpsWbpRFL1Tl1ngd1bpUhjlPk+AtSgY6+tvUv5ZV?=
 =?us-ascii?Q?OTlGQKAdFJFAxdZWe11YD1bW6OUsGVboznBclK+NAFg/OBBmzkXVkQQxtPm5?=
 =?us-ascii?Q?hNSXPL05sj9H5WAxLoyoHA8on5azKdhCMmQc2L5SPU1e56Ph/azLvD5Qw6zW?=
 =?us-ascii?Q?1Ehny1EgujMmKTxa2Ns9ldFeSaNEqdIzHPk3oUnBI871mFw4cjHkm6sP0/55?=
 =?us-ascii?Q?lJM2xIDDjzOvNkc5AiGAId9R9L77rc8J8n5heePJrwG8vuVrgkqkE6MxW5Zo?=
 =?us-ascii?Q?75ZHn3vQsEdIbCQg9u3kLvc8Y/sIgGnll+WiZqFk3JO5HPXkw6FPD0OFGvkm?=
 =?us-ascii?Q?PetMXa+RS9gDnrdJoWZexTsD3OXKMMXyBh0xTnmqHP8PXKyefQcVkLGvAeZl?=
 =?us-ascii?Q?SaPfh53uKrs8jCcEuxDReJsAURypcoeQ5aiVuCfmF9lflNtctCZyfi1/Ok2B?=
 =?us-ascii?Q?MsiPHXcSxayuFN5GIIm6gku+RjcopekjulAV0y7dMG0guMXSH2Y44tkrNzRt?=
 =?us-ascii?Q?6ogwC9oMT+JV4VIjgxt27vS+OHawcFY9wu6HMs0qQvWCKJhG0EySIBgwzfnh?=
 =?us-ascii?Q?tzxzF+xu6a6jkuwsB4+9uOZ65x7ckjaph8eY59Vu/9zg87350S4EyqvrJvdL?=
 =?us-ascii?Q?keF3TeBlIYAf9KRHs2zzhgXL9VAQoYH+2uXPdhDa+DdbEC7s+CqxmMLUrcbS?=
 =?us-ascii?Q?uZxRyZZxIMlgcGBsSYfgNUi5nD/lmp2S4X0Qc8zy+RUTieDg3G73wewsUZAD?=
 =?us-ascii?Q?1O/sdKXfScDWUxaqC5Rb0pb2cMwBseJDpiJOMIM8LmDbAVnhC80bPbXf1Dra?=
 =?us-ascii?Q?f1oICX6uEwEzpeer6e7bQZCJZFHFHAJpC5jSKY+TvtOwzrQfwbBIWzG2+SZU?=
 =?us-ascii?Q?FhaE0xAGMLDprm6HuEnms2TA+1zjICqJhFfWKQLTkE0bcibUbyHbWE0bp2hG?=
 =?us-ascii?Q?f0vJalRc3raLlxTzO/TNFMtRlwM1AbqiljtW+5VTG6k0f7GPpNxDupr3bh6E?=
 =?us-ascii?Q?Q2Z1nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1086db53-c818-4d48-899d-08d9db5536dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 14:08:48.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXrNrraK9Fv0cTnAJpPanl3D1ibNEwK/Fw5h5xuuSZDgf4gV05hG5/lhxgtzY6sXZgdtJ9YR/saK+RsHFXLUxOMDcT99JrvQEZmaUS+mE+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2637
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190082
X-Proofpoint-GUID: Av00NNdRwnw8hB5WqER779i9bKJ9C6_v
X-Proofpoint-ORIG-GUID: Av00NNdRwnw8hB5WqER779i9bKJ9C6_v
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Jason Gunthorpe [mailto:jgg@ziepe.ca]=20
Sent: 19 January 2022 06:47 PM
To: Praveen Kannoju <praveen.kannoju@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>; Santosh Shilimkar <santosh.shilimkar=
@oracle.com>; David S . Miller <davem@davemloft.net>; kuba@kernel.org; netd=
ev@vger.kernel.org; linux-rdma@vger.kernel.org; rds-devel@oss.oracle.com; l=
inux-kernel@vger.kernel.org; Rama Nichanamatlu <rama.nichanamatlu@oracle.co=
m>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the async=
hronous workers to flush the mr pool

On Wed, Jan 19, 2022 at 01:12:29PM +0000, Praveen Kannoju wrote:

> Yes, we are using the barriers. I was justifying the usage of
> smp_rmb() and smp_wmb() over smp_load_acquire() and
> smp_store_release() in the patch.

You failed to justify it.

Jason

Apologies, if my earlier point is not clear, Jason.
Let me reframe:

1. The introduced bool variable "flush_ongoing", is being accessed only in =
the function "rds_ib_free_mr" while spawning asynchronous workers.

2. The ordering guaranteed by smp_rmb() and smp_wmb() would be sufficient f=
or such simple usage and hence we did not use smp_load_acquire() and smp_st=
ore_release().

3. In case the function "rds_ib_free_mr", misses to spawn the flush functio=
n, the same will be requested by the allocation path  "rds_ib_alloc_frmr" w=
hich in-turn calls "rds_ib_try_reuse_ibmr", which finally calls the flush f=
unction "rds_ib_flush_mr_pool" to obtain mr, during mr allocation requests.

4. If you still insist, we can modify the patch to use  smp_load_acquire() =
 and smp_store_release().

Regards,
Praveen.
