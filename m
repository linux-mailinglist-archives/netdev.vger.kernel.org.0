Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D371F4086EB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhIMIfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:35:42 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:21169
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238018AbhIMIey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4oyzP7BkRRnwOLrQ7PyDDbhaDinniZMBd/d0n4/fp8yAbIaBzemsh0wS3akjcY1L9cxxY7VV54oYwPgIyO/0cGwoMKAwPcl8yCg41PxDq0+8clJap1h1cRfhjKfclq121rGR4H9XgQY4ZNWu3aYnAxM9mF8jDQB9X5AcZUcwujCSKhCbnYv3JLdKjtmd+Nypok4VAsiB66W8sI34Ymf1lPHh/i89ZTCM2aKvPEiWoj9Gbb6J0K/DEOHAZ4xJtrKRvpkcrXjra6KJSFGsVooe9yzPLnBVuFaf5qi2T0Sb1ghHnMuVTOIvQbrgqVDwPU9TsoarpJNQs04pWqFahcGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CL6kGT2QHAhGRM20d/8PBao0Aj6Hch0u2ifyJUm8i/c=;
 b=IP0zQYJ5RTjoHzT3Cdv0EQGoZJchn6V7p7dSJwMchAoCUzkUbjFW7kUS+sRmc/4BjvCetQ1CWQ/soEDn8ZZh9ANFvtA0x+JYe4YwN4lBMGTtEhZ4wcVLR1PTDmeH/ghscS3UK/wn/aT5NM27Yp3+QIUtDB0XGk1uv/Gtm56Nf6lxWKlQNkg3vafI5kSYOVi+zbS2eNR+slnB/l4jwAqYqPc6ZbzLG9J66/b1VVbwF4q0Br9PQPmogbZnBei0ehjlKFueD0UYXABxxAxsZCp0OyRpJJaSHDcYILSvyYHuVjTK8bKy8nvkVCGqCNkuUR3HGjGPvQ3OVBTa6PttT5TctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL6kGT2QHAhGRM20d/8PBao0Aj6Hch0u2ifyJUm8i/c=;
 b=T3XFEgoebgOCSvCdREtw3bn6pIl78J2CSHXotwf9ZCpTOOugtJ9XjpsZV8eTHbbnzBZcVGXCnmmtDThNDtKK4+wsppVadg3/vGHIaSCzTF2NPa27nb7U0EehY0QQuvRtNNuw1GLlIt7yHF3PwzAvaoFMOsdYd1rayBW1/+dI9p0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:32:32 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:32:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 33/33] staging: wfx: early exit of PDS is not correct
Date:   Mon, 13 Sep 2021 10:30:45 +0200
Message-Id: <20210913083045.1881321-34-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:32:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5341d9ea-297c-4e04-f3d6-08d97690f6e3
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27173DC86BA7A861AAAEC0DA93D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xL50k952gihxJ+N3Av/1sgEHCkg5ssi34qgGJ/4/LwSSM53yPtt6/uhu/ajbmFEGGJIoYFjCr3DUu1qMZLuf9nz3xza9ij6IezV9yCYfGYwNHodMkz4/vXAC6g60ME/UQdsHjzcPkkFsRXlLRJOq7W3k3A2owqS5DJHyHxKzC1Ae4xamdFYH79cV8AVuB/a3/4BHrh8CCu0Xtxj3NhGIAArTKdpHGtNmDweRVou/vtrBqqeAdqNRshDPlVXx5cXijycoQPNkpP2aczEbrR5fNh3RTgs93tbpAZEEEIhcakTuuSo9A+MCjhvNINI1huH8jqjrDL6+isAF0gaZmfo6H+SwFRmM/Ooh+vxyfU17ZvQMQSV/rgoCwwGY0lKyDStOEr/jBkhEMECbNQ21bT0P6+8kmHXfFiEo7EhBrhH6ddyV+6X6Wf1bF9YhHVtTodSr9YrGVOxMJT5zRQGpHYJgy1F1nsB6n/Kb8k6MDvtZZe4D1VVtN/yvP9F99Y27yRKjn+Mag7GWlNpElk/GcSROupqCbKSow1rOUnmrKu2WGhi6wRGynx8jelriqHDEF76nYSLzeBp0PpJcFiQq7Cw5eK/e67GC/1LEyV7EyyiW41DPIQBkNM7B8QHsW+ILVNGq24wD5zYT7nISqLhZQ9W4KELXzcU2inJGsENYKJC/yxYbod1k/usgJHiyyJJHcErJYmJh2wCarWiyrj8yfaUU1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(4744005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cklSRS8zUys3L0lRR0RVYkhLcU5lL1R6UEI4UTJLZGVRTUdZL3RURTgvcUNL?=
 =?utf-8?B?SjhqbjR4MCt5blpuOEJzejNyaEhqSmN2eE9QaXdlYVJnYjVnRjBvaC9YZnNw?=
 =?utf-8?B?eGRuTXFKNlltL2E4dXRuNlpWZ2FGbkZybCtoWVVBREduVHIzZmYwTlhGeGJa?=
 =?utf-8?B?Q0ZkZll1a2tvTTNIWGNYSTRyd1R6eEJLVnY5aFhDeEhEN0duUyt2TXA2NXY0?=
 =?utf-8?B?YnVKd25HYWN3MjJ5WWNJL1pqYzdFK0R2UGhaeWcyeXYvUTV2dlVqTVI5ZVdJ?=
 =?utf-8?B?V2JaeURKRDRKYUR3YUN1MjYzeFNqNFZjV0E4NDN1NWgvVGRjZncweVBWN3hx?=
 =?utf-8?B?WE9PcHJBTUxIYVlvV2t3MnJ0RHBHa3g1TStldHlkQzBNNjBuUWxYWEdVdk1v?=
 =?utf-8?B?eVVmK1RSQW00YWdlbzRneUV1YjhXZzJvSUR1MWs5K1BtOVdPT0tzWEQvc0ZN?=
 =?utf-8?B?N3AwellSMVVDZHc1bEd2UXBYQ2x3QkhpdG1lOFp0V2hnTWFUdUF2Rm1JRjJr?=
 =?utf-8?B?dzBZdjdRSGdYNGFWL21CNUdtRXVVY1N6ZmxOZjVNUm1OV0pja3JhUXc4VGhO?=
 =?utf-8?B?QTVMeE1pNVZzUGRxT21YOVpJSzVnTkIzWlY2TWtxa1ZRUXIrZU55YnU0U1FI?=
 =?utf-8?B?b2FLclFHbXZEUXpyUnEzZEdkTFBiTy84YkdJY254dEFYV3FrUlNvT3NsZGI4?=
 =?utf-8?B?OHI1enpLai9ndzZaTmdTZzVPNWFQcE1hZWFJczNNNGpId3JQblFJSW5vZEFC?=
 =?utf-8?B?RG83Tld2L0RoR1V2WnlqdDcxY3dObkNraFRQdFE1RlFCVGtvU2NuL2hpWFRh?=
 =?utf-8?B?cWlYbDRSL3FtaW5pWkt3SDZ3RkU1UTAvVzJBeVZ6STBudklmS2RaQWpSbnJu?=
 =?utf-8?B?ZHIxeGE5MTVqM1VqRmlIT1Mwd1BVSmx0SmIwbUduSUVlSjh2aWlaZFFTNXV3?=
 =?utf-8?B?WkxpZlVzV1JPaW1DWGlQVDBNSG5qNDBrZ2d6NXcxVndObTFwR1hhdkJNTi83?=
 =?utf-8?B?RUJrWENpQXpEbXk5RW1ZK3NyZWJNS0hTN29lUnpvaHFLdEZCN3ZicEpNcFo2?=
 =?utf-8?B?akxTak5Kbm9JT2JaOGovR0xoaWtBejNUM3ExSm1IclB5K3NRR2dqQy9Cd2FX?=
 =?utf-8?B?QThIc2s0Yy9yR1hrTThDTW9ubmVEQXJGS3JEb2xlSWxJbHVjYkR3cmhjcjRp?=
 =?utf-8?B?VE94YWw2RkQvWkNqNjBRQk5sV1p2RTBCc0VqSWdoYzdqU3FpK2NTSUR4ZXVQ?=
 =?utf-8?B?aEd6dEJ1QlRud1FndTMyTW1NVVVTaDVkUXFtdlQ2MHA2MWgvTGxzRWl5MnR4?=
 =?utf-8?B?NkxDeEQxTE83N0M4NG9ha3g1dHAzREtLVUVkejUwcmp6aGZ1U2Q2WHVxWktT?=
 =?utf-8?B?R2VTdk9FSkwrNkZTakI0V1R2eTlKTDFCQWNac05IMXNJdkh6ckg5cHVwbTJp?=
 =?utf-8?B?V2lPL05Rck5hei8xa1RJNllnN2dDV0M3QzR1ajhIZWZybWdhbUNOVDd0N3JG?=
 =?utf-8?B?eVRPcC9Ha3VTUkRzTDhEdHY0Mnd5cXRQbHlhbS84MTRHTFJXeS9jeTBLS29i?=
 =?utf-8?B?SVZXYTZ1QTVHTk1CbE5ZWmMzQ2xNS21XcHRkMFZkaVg4R09DWDVOODBNVHlT?=
 =?utf-8?B?NWhOdWQ1bjVsZ0pnVmJzb2w4aXpGVEVUVlhvZXd6UVZFMUk0dDlSWWgzam11?=
 =?utf-8?B?WW5MU0pRUENqR1RUNWFzZGk2L0VFVEpjMjhucXFWMys5ZXlOZEtUSFZ0ZjVU?=
 =?utf-8?Q?OKYWjpEKlScqRfWiuVsn9V7Mz5sLeHNMFcYFfjz?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5341d9ea-297c-4e04-f3d6-08d97690f6e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:32:04.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpRq9wrVS7JpegK6ahcklzLb/Te8UgoGExhnsnjXZ/QDYFE5mr/VJskAyncZrwKEFtKMmYdzQi4BA6t77OyXgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSWYg
UERTIGRhdGEgaXMgbm90IGNvcnJlY3QsIHRoZSBkZXZpY2UgaXMgdW5saWtlbHkgdG8gd29yay4g
V29yc2UsIHRoZQpwaW5tdXggbWF5YmUgaXQgbWlzY29uZmlndXJlZCBhbmQgaXQgY2FuIGdlbmVy
YXRlIElSUS1zdG9ybXMuIFRoZXJlZm9yZSwKZG8gbm90IHRyeSB0byBzdGFydC11cCB0aGUgZGV2
aWNlIGlmIFBEUyBpcyBpbnZhbGlkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFp
bi5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L21haW4uYwppbmRleCA0Mzg2ZTk5NTdlZTYuLmIyNGZmNGIzMWI3MiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMKQEAgLTQwOSw3ICs0MDksOSBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2KQogCiAJZGV2X2RiZyh3ZGV2LT5kZXYsICJzZW5kaW5nIGNvbmZpZ3VyYXRpb24gZmls
ZSAlc1xuIiwKIAkJd2Rldi0+cGRhdGEuZmlsZV9wZHMpOwotCXdmeF9zZW5kX3BkYXRhX3Bkcyh3
ZGV2KTsKKwllcnIgPSB3Znhfc2VuZF9wZGF0YV9wZHMod2Rldik7CisJaWYgKGVycikKKwkJZ290
byBlcnIwOwogCiAJd2Rldi0+cG9sbF9pcnEgPSBmYWxzZTsKIAllcnIgPSB3ZGV2LT5od2J1c19v
cHMtPmlycV9zdWJzY3JpYmUod2Rldi0+aHdidXNfcHJpdik7Ci0tIAoyLjMzLjAKCg==
