Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0D6D00BB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjC3KLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjC3KK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:10:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7769E86B9;
        Thu, 30 Mar 2023 03:10:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U3lDsR020370;
        Thu, 30 Mar 2023 03:10:45 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pn2ty1pcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 03:10:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNSNHnTgfu6zK8kCaN9DU1kuuV6xFlxZi0o32eLuZwF2zfkkqD0aI9WbrPme+4pMJhZ4t1Lu0w7LBgZfRxLn7A7ECVuq1oB26ypHGBQiDMeW1lJns916B94qqJWZjSucCSOYaSGrpktCP934q6ergr/K4tx9ws8sJiX5n2dhBN4bhpNMlMPnhXNRyqHP0ryZ7Fb0620RbMHmq8Sa9JGovrVXDz1Lpd76FGvG+mObo0ZwLXzkbL8SFdA4sV2pP3NH13mEOVQUTMqrXy6S2QV9yXxXx6nATWHYW0bd07Iw9yQYXhcGV0tCjiynt0KsXGLyGTokoIkbVm9GcLhgVEKDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaleUDMDnAd7YvRt3xoCRg3/hMFjc71miv8ol+wPSUs=;
 b=Gwaklbp42VVV9LLFlhqlp4w9DRMaqPasgDiwRePV3vp4dFnKg+H4NNsQHT3tT0gb3GnT7ebvzyqn6yBulnP6JKtKaZh5bz41noTzhd0HglNO9sz0Xj6S2AlOw02JppJNDKZQcoreTCRkTjdMf01+W4s3ZXrDkE1/J4e4Yw3jMwVfgNdARts4CioT7oS/+lHAdtH3xpY0GyBuG6cvNLCBuSTS8M1PDAhxFQGJP6Xh8/xPdH88o7smq1aIDifr32fAUpJoDiPCE2B+0QzrEhtcxmehGbxOb6Fi7kce/iuO/3oVqMZIOu3oWmUQVBqK+jPCHgtEdxMtvRdurc6qriqCiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaleUDMDnAd7YvRt3xoCRg3/hMFjc71miv8ol+wPSUs=;
 b=icsjwf6zOE8SCyZ2KhINfEWeGAa41u+9IdCTIZlePgI4DRBxR18r6GsVNaNBrEcqW0B132NeAmsT7w4OiyaLhBEjKC2QGVIx5pUEFdCB1LQL06V6l+UTWjm+kfvIHJ03Qf+sITThl/oRA0FoBfPAu1u0A8fmtgOXQiIl1IGFdoQ=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by SN7PR18MB3919.namprd18.prod.outlook.com (2603:10b6:806:f5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 10:10:42 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251%3]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 10:10:42 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Recall: [EXT] Re: [net PATCH 3/7] octeontx2-af: Add validation for
 lmac type
Thread-Topic: [EXT] Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac
 type
Thread-Index: AQHZYu/iul2370R8Z0CVCbCqsS0RQw==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Thu, 30 Mar 2023 10:10:42 +0000
Message-ID: <BY3PR18MB47078198002500072F6494FEA08E9@BY3PR18MB4707.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|SN7PR18MB3919:EE_
x-ms-office365-filtering-correlation-id: 8752beb3-989f-4115-7f48-08db310704f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nH6+qMPGfP4lG6CwqMXBeaqc5pqnZVs0IoXmLujVu/9CBqgjtZbX25nTe6Pwzy+e0pBz6z8WoPr03Ttl1BGCvEUjNL8cIuRHXhYu5ASWr8AmFEnvTP63RLKYUfoc2KqlGagdGAy6EXAuJrPrDZ9sp+OYFIYvZ9Z586dkOWIqGpIyiVTX9iuIi5odEs1iwq2+8yokdrivrNMsmqU4pij6Rl6rOTjQFZY3yWKHcYC/h870RC/Xu8bOxoSOWhyjYnN4YIoCRx9BWCkNKm9uGj8FNIPgSaaosEN7h5u8b0/nAcfGgULnxQtnN75BegWAKTuhcevoyqXcOFBQw+a98qc5JGrvccr2kEU+utQ0joupcfAgdI7rGK33tD5KyacQKHBd4cY9tUQDLcRPvlXispnP9baDlO9xUNIeV12FOIPUABQo2PviWZ7dApJuADa3ZUCeXsb08Ua/zqLb3l1XAY6e4ouVscAQosUnCdfMlfCEsr9NN3iOwHShtd8EHfeA6e++TkNvxrBAWc3ajdC9EXKx8HD/+TfJkN7FFQV7tLi0sksRvC1NLLVSoqgot+tECc6b7/VWkMKCBxyV0gTW7+m7r27rxi8wRLXEh+b5IlTsZ2c5apLNREPUNVgZaCkgHNlr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(5660300002)(8936002)(52536014)(41300700001)(2906002)(86362001)(66476007)(76116006)(66556008)(8676002)(66946007)(6916009)(4326008)(66446008)(64756008)(316002)(478600001)(54906003)(71200400001)(7696005)(107886003)(9686003)(6506007)(26005)(186003)(122000001)(83380400001)(33656002)(38100700002)(558084003)(38070700005)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bIkLuzftRY/Lll9OmjVQMAmcSDouSt0RnGQ6IYvXXKyB3ZBLqyx4xqp4idUp?=
 =?us-ascii?Q?M6lRbRyMk+Rr60a+gyoAohrsbaXHqPmD455Ki5wxh89xrdqNRyiflZXhJrfr?=
 =?us-ascii?Q?A+pLHsjP/6c+AerGOuhXvhBDLWcJ3CTQNrTHE/G6Q6dAmpSpQvmw8dLDYnej?=
 =?us-ascii?Q?mqaK/zEGH+fVT7FfznQmISnM42VtpbAL5fdhmzwP6HXBrrxSjHX+f4jAMnq7?=
 =?us-ascii?Q?mD7k2sUqMb1EqhMn3hDSNO2mKGDUWy5PA/EzvXdxSI0YOtYzAOm9MFOevhRU?=
 =?us-ascii?Q?sfFbTg5hMiD3Nk6kvtkV0vWcsMlNvtq5jwacc8yPOgeRYrauJ2+BnPQkuvqp?=
 =?us-ascii?Q?YsyhxWC4ToBrxg334hN418GG7RQQWGNho2uIcPlvJD7AD5Y93UkoOp38WSsf?=
 =?us-ascii?Q?ycVA0BaK5k6xYO2mdouZZJVFVLDlRmIM8M4h4MUx3by/XGavEfZqUGCkT0MJ?=
 =?us-ascii?Q?IOS/46W62LXzNm/ri/OjneFRFoQHLX3sY7RKQRFnpK2iOTUPloxV+2yytpvB?=
 =?us-ascii?Q?fHiCqFHwPykGNNpyOYbMkcebwP82u8OVaOoLdYqov2U58OhtjceJfiuSN27i?=
 =?us-ascii?Q?gJDWJjk5dkndimdu7x0u/LQGFhjxiSauJHMIDALsOOJT86H0lmPKJo81U9gO?=
 =?us-ascii?Q?EUyoKu0aeyLFNSe4JOFul94Ka2DLXJ1JSpVf3GkIqYsr//6jk1jB5Bw4sSjh?=
 =?us-ascii?Q?ypXagkIO8SCqo1UcwsdPJaaOBTGt1WAFNviwF6tx1mINObCjpJ2UroNxG0d8?=
 =?us-ascii?Q?b8AIMSrGAOD0lPqTsJEPwJKvQAocq+lbX8PSpXj9gQ8na8AKEIg1Kx+1XDDa?=
 =?us-ascii?Q?8YIU8NVN2NUqZakeLAMksTecqc3zFHrpqhkYiiLEf+HyvgSj2yg+bfFe0j2P?=
 =?us-ascii?Q?DmjfbSnyvOrKZoJcDTlyWgNnH4xpQWQFqfncRwyt5kINje/YRyLW/wh1ga7f?=
 =?us-ascii?Q?OZ1ECJpd69LkEqVoxu9ob8RqVBv9P1CAb6hiGzQQPotL8ttBgv7wZZiyA5BE?=
 =?us-ascii?Q?9+6olSX4MCLHKjZECc0BsxazizQDlzOn4s/zePenRtBBvXiXXubY7TSqiee7?=
 =?us-ascii?Q?nbMoc2rwtXwUHW4X5z+PXBCr0eMk48+/qG3JiHPzx+siLXB7pYG/H8IXsn6d?=
 =?us-ascii?Q?GTPI1XW8DBIIjF4gn7ugfsy6FEmW9WSpBsNlG53Z0mJiFEPK91TZwBGHiwMf?=
 =?us-ascii?Q?fGnoHHXm+gWqWbzXutKDZO9UtYV4bPC6WqY2WCWkLVyiM8PbsrcZjFfAWlDh?=
 =?us-ascii?Q?y4HG2KaRmt5LkfZdigHvuIh7hu/4obi6vuN5g7qJwcRvjNNSZ5V6GGTOq8+D?=
 =?us-ascii?Q?MU2IQQ1NPAgG9EST968G1WbA8y7yOgaLu66ikFGj3T2sYKXzGEZh6TYFYSEj?=
 =?us-ascii?Q?scZrgL68N5HT9X4uaEMu4vxDvPmO0pwJPtPQTQO5TIQmt5M7KvmD78epJUFq?=
 =?us-ascii?Q?Q20h9kvMKUrETX70W5ormzc6v9BKNB+/O8eRsKWHqAxS8hLH7NS3hhQNar+R?=
 =?us-ascii?Q?T9Og8lGIfHJ0/pQlRE1JfK7Q/CiQ7OTnvVCg5t+PKYgVebhnxOqihvXWmTNz?=
 =?us-ascii?Q?droQFKN2j+7qvRjRLkJeAek+nD2mwwvUs05y4L3T?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8752beb3-989f-4115-7f48-08db310704f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:10:42.0706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KrWwZXS2ukC4Ukrc0Zq0WTQ2MAjXa5xf6yG6/5/RVEyVfnpVten3tzAcgwx805FpPEQAZhn7jcwHHmlxuKd8JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3919
X-Proofpoint-GUID: 6t35XJYZCGP8rpmHNDGM2r7en44Rp0NM
X-Proofpoint-ORIG-GUID: 6t35XJYZCGP8rpmHNDGM2r7en44Rp0NM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_04,2023-03-30_01,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sai Krishna Gajula would like to recall the message, "[EXT] Re: [net PATCH =
3/7] octeontx2-af: Add validation for lmac type".=
