Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B781D4C437A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbiBYLZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbiBYLZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:20 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D1C22A254;
        Fri, 25 Feb 2022 03:24:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkqG7jIo3Yf82R5DmlVX2Mzo269UUKXefCsTMyvqp+IUfFl6OGR1DBNc88VhdIZXmu+6FcFsl91RVxggzYspZLzpvp2VhtyW+JJvcOcIJxVcK2gWbItCar+cL5XdPuSh9kg5qPX0gzJKap6vit+Ta42Gg/LX+kvnujZWx872b2jErVfsipZZI7lgBo6AEKWhr0z9VF+rNE7TkAXCR5Sy2t4gElYDEWhRviQD3r2rmGPDXvFprYoxjVZGpTalxsjT6heOVXW/2QgliDg04RDICYiB+DtZy2WCrI3Ss7VAg0nKqydZf7cd8Y0CJrWcNkJfRUx1ONadzkaDvBkG7VnjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsbao9AgFsXWr7CSUqDXFNwV0J6dnNO5APitxIFWGE4=;
 b=ATE8gS1F54hVOIl+ubvaxTalAgfQ5jXaNd9IwAQkrvPZKWRrGD0KPWbCYdzCbkVntI/umO1sAU7WMNiVrc5ErQYm2glSIvSSZL7xu+TZ8o2m+T5bfVEV8ozrUJ/Ovha2I+2LT7DT8nCfUXfuKK1zB6yrsAABrE7qfAsSOxMMEu8PW8SWRiOEQvaNtFByBPUlObOXmw0s2VyEtkcPcGIycCYUYTPZyzJHDwFjcNG6ucHfdhDlcK5Iad/OyJ6Y7ZY63yzy2DhdqF7poOds9F2KQBhxR0TOOr1nGkuv1Xd5QZV9gZMgY5kHVjQ7XKpdCMkVua6jJx3bWBdstVnp9L7zQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsbao9AgFsXWr7CSUqDXFNwV0J6dnNO5APitxIFWGE4=;
 b=Fs2RI3TlRS+eDI29bCJJF0qyp3plVkXRbILdhI0iNj1D4/2RVTcfaQa4VmIP1LmQ7TS8N9eTBFaXb45BPBhV87i4Ja5XQ7qwH8ahuG9J8nf4qjddGihyhDQFT0UAadNPnovBXcCoKsNz5/HRoVNf9agLI+RAUhtPsrcZ/uUqu38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM6PR11MB4362.namprd11.prod.outlook.com (2603:10b6:5:1dd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 11:24:36 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/10] staging: wfx: sta.o was linked twice
Date:   Fri, 25 Feb 2022 12:23:56 +0100
Message-Id: <20220225112405.355599-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5435dbe8-71fc-423e-ba65-08d9f8516798
X-MS-TrafficTypeDiagnostic: DM6PR11MB4362:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB436218A93C20117A73585424933E9@DM6PR11MB4362.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oulICj8vE813wRr2ccSFsMmgnNu6Ze5yW8lVo84u++gQqQ39CKjqSx+1NDWWxJXqtWYWXl7/Ix4f1a1bGiZF50oNocOh/0E/E+SmEZN46PYx84dSYihRyEGzwX/EEa4uS1QydP9ycAh9WwdLFIT8qdsl/kn7t6IEyspOYDXn08V9nusbLwoVpri5mbAWpz61UHKXeK5IdrNpoLfPrLmZ4KNf7uRp7mLIJMV+V2mRv0OqsoKT83msdFdoFJDHNOzC1q5efYazza/H5S8NRO72Hwe64x7e/fuHQhsg0bfhR8Iej4ubG/HCWQ5bpiiOyjyvWhCFIUMe5wLboT5Y/C9xiFj80jXEMV5TfjnHKXKohAiVdI/ZzDpXXkj9X8avu/8joy+IxpsJ6Zlb1ItaDDzAd/ORI65DtGjZdW+ZnoeZsMXrsG+2qpQLik3BpuusvBshpWtB0fbOJssA2UXwMp6dIWrg/J82BlcHZP7Z72yjR4WlJt8osfwtro2Z8LgrFvCrFTBCaMgc2EYiD4HsYg74sQIR9cHWeeJS87qtFfZyvsgc6WMFWA34lZwoPqgyIlR5MNG4MAVxAhpl4kWPmADRRTZECx+9+I6KFSNFTcGnAeAySF/Y9u6kW2x4H4a5nrb4v/g5q5ViTsk+GOJEwfpudKwqLlYvtN2jbSpAlydiHAXINKXYTlixtcrDRTB43L9L9Wq2xynWG8iKJRAfoCcQiAwYJX3lnlShyhDdYs/i5KDeT09NY0URvrcPendYwBxu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(1076003)(66946007)(52116002)(8676002)(2616005)(66574015)(26005)(66476007)(5660300002)(66556008)(508600001)(2906002)(83380400001)(54906003)(38100700002)(4326008)(86362001)(6486002)(8936002)(4744005)(186003)(6666004)(107886003)(36756003)(316002)(38350700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGR1MHNSQVBvTGhCekZjNHlBTWVwS1lwS215eUlKcVA1V0JoTDI4dFlDeFpN?=
 =?utf-8?B?VCs2TktVdWt1Wk1WNnNzT0VFckM5bUVQb0dpUUdzZ0QxZWR1bEtxMzJXanJB?=
 =?utf-8?B?clJBTU54S2M0WnBSLzRSdXFzZ1NuSGl2ZXN0N1Z3UytkK1Z3dDdCNTUrdUFj?=
 =?utf-8?B?Zk1oOUhDbTlCaWV3bFlTOG4wcVRTYkpaNHYxS2ZqQnpNb2pvQm9YMGptN25W?=
 =?utf-8?B?NDBGcExYaTZ4V0ZvMXJEbEREeFovZEx4SUdZRytadDU3cis5UlBsK2ppV3E5?=
 =?utf-8?B?N1FhZG1NazNhT3JNaXVkZlBremZDYVl0KzF0cHg5TkNzOVU3SUpJLzBTdmZX?=
 =?utf-8?B?eitId1lrTE9LYWg0Ym16byszYmZONFdkaWE1dTRvK29ZclNnNE5nL2E4dFVR?=
 =?utf-8?B?U3hxYzdzclRhZ2pnZ3JzcjJNRmQyUmZsOGdMWndmUlU5a2xJczM0VHd2UTdl?=
 =?utf-8?B?am5GaGJwNCtjMXpvVzFkaUlSRjRpZW81elNyRmxMTE5Vb3FFME5uUWRmV05P?=
 =?utf-8?B?R0ozdzF2dGtHMGJvR01hZ0pRcDVscE1vYm9vZjlBTWx5SDExbkF0VkR4TTNB?=
 =?utf-8?B?WFJxQ204Q1ZMY0puUmRnTkptNFIwVUJhSEoxVjdvdm1IalNHeUZiZG5kcXVr?=
 =?utf-8?B?Y3pkajFuQWdvMXYyYXZxQXFrM05oSVl1UmR5N2lFd242eHNmMmxOYk8xNWNK?=
 =?utf-8?B?eCtHOWRQZHl1REJiYVR4dlUzeUJxZTV0SWVrbXlxa1hITjBCNDhtYWVoZWtQ?=
 =?utf-8?B?b3JQb2hnOVkrOGVRSmNhdWhHaE1jWFgyc08zZlExa1BlbG5HUlNma21JaVZr?=
 =?utf-8?B?eUNvTHNxOUN5V2xoSjFtQnFmNmRTa2tlZno3dk4xcmF3SmhTSHdmUC9KTUdD?=
 =?utf-8?B?cWw1Vm54WVhmZm5PdVVSNjJOdDdYWnVieTFmWjN4a1hJUXhqZ3ZRaGxnb1gx?=
 =?utf-8?B?UGMwVkJFaWxqMXRCU3p6V1hnYU56aW5XRnN1Z2JvdkNuM0FPUExHRWlKdmZF?=
 =?utf-8?B?a3pPTktUOTJsL0cvcTNLUTBBUkhjNk82M1VESTF6L1hNbTFvN0M1OHZObEsy?=
 =?utf-8?B?cW5DcjF0eHJHdHEzRDVaUmlGWFZvVHR2Z1ZMZ3lpd3FHcWg1eVFDL29xaCtv?=
 =?utf-8?B?MForNG55S0h3Y2d4VlhlbDUxM2hOS1Zha0VXVHhKaDlxVTE4eWR2KzJ3U3NO?=
 =?utf-8?B?MzFGai9KTlFwb3lETDk2VlliL2ZXTmJDL1o4QjlLc2I1SHVXd1NRaDJUQzFy?=
 =?utf-8?B?ZVAxOS9ST0REQ21DNXJ1S1ZpcVA1WnpwR096anJiU3BkblNzTnNWTXZLMkFS?=
 =?utf-8?B?UjRaOVJ6elN5cjJJQytwVC9TdVNLTldwLzdQUElveTVqZ1h3UEZ1emE3NEk1?=
 =?utf-8?B?eHo1cjVtWkVUQnF2VGhUNTlvK0xIMWswbnNoY0pLOG1PNjRFQjZVREFKbVd6?=
 =?utf-8?B?TThHcEE4YU9meWFBd0hGRFhRZXRyKzhUVEtJWmphb21TanFtV0tMakpXUTIr?=
 =?utf-8?B?T3Y5YlREV1pCYkZqNjdNcndoV2VYaTVMa0hvQUNnNGJVZzh4RUVDaXREOWVD?=
 =?utf-8?B?UmhKaEtYNHJuTVNBZWJJNlRJd2JINzNUYzRibGhJOVA2MUZ6NDZKb3BIUCsv?=
 =?utf-8?B?cUZtckhKR3hHbUJlR09oL1R5YThNUnlwNE1NY01SbEM1MVpBeHFOTlVLZ2Fa?=
 =?utf-8?B?WUNDVFBJVEl6SjRUQXNqaGYwejM0bm9Hd1dFellJakZId0NQck42a0dRM2dT?=
 =?utf-8?B?U3FLNnVpdjB1bU1OREZTMmJzbXgwaElHVUhlVFphaHJvVk1GU3d4Rzhhakw4?=
 =?utf-8?B?dlVHOVVrNEJjaldTMndwL2NQazNmeWxxOUZnS3hjTlhVTkczOEhybFVBeUVD?=
 =?utf-8?B?NU1TK2RPcjFYREZrQTY3ZHpGdHRvS1NmQzNwN0hmUWVkLytTalN0UmVKdVds?=
 =?utf-8?B?RXdPdjZJd2JHSFJLT1o2MkkyRk1aelJsSWtpUWZ3bjhZbmNpS3BSUjhpOXkw?=
 =?utf-8?B?N0FnUHliWE4zL05TaHd5RjVkR3c3QzhwbFBRWmFIUUk3WGlGYzZCUThVNUJ6?=
 =?utf-8?B?bW81YXBuR09UZWVhOU0zN1VpTzFuSDJQMHdnUmkrM1FFL3QwdFk5UGZBRG95?=
 =?utf-8?B?ZFZENGNNZXZJQUZrcFV2SlNTU1kwNVErY3FubXk5c0pZdE5MQkJ5ZnZtRDdu?=
 =?utf-8?Q?UP/fJeNiAWDmZkF4N+Xi7jc=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5435dbe8-71fc-423e-ba65-08d9f8516798
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:36.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OY3jDGBRcT2H9YG0wQr5nIbsRF82zOLtgkaSmvAdTSuo7pGRWOpWtE2Kxq5F+o4VbIsTGrPPD0LcSO9GCKcdig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4362
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKc3Rh
Lm8gd2FzIGxpc3RlZCB0d2ljZSBpbiB0aGUgTWFrZWZpbGUuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9NYWtlZmlsZSB8IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L01ha2VmaWxlIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9NYWtlZmlsZQppbmRleCBhZTk0YzY1NTJkNzcuLmM4YjM1NmY3MWM5OSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L01ha2VmaWxlCkBAIC0xNyw3ICsxNyw2IEBAIHdmeC15IDo9IFwKIAlzdGEubyBcCiAJa2V5
Lm8gXAogCW1haW4ubyBcCi0Jc3RhLm8gXAogCWRlYnVnLm8KIHdmeC0kKENPTkZJR19TUEkpICs9
IGJ1c19zcGkubwogIyBXaGVuIENPTkZJR19NTUMgPT0gbSwgYXBwZW5kIHRvICd3ZngteScgKGFu
ZCBub3QgdG8gJ3dmeC1tJykKLS0gCjIuMzQuMQoK
