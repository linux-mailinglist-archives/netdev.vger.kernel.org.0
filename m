Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524B8406ED0
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhIJQId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:33 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:59105
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230020AbhIJQHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3vHf3ut3eefhxr7ydv28Z7S9jQ8FeLXfinXVIxGg2Og1x5bbW/gth/dl9qAyHh9uzAx/eTM3a7zowDqjEHkxKdh4VL5H97tDdpuDAdR7HXbIBMNNaDGCZJ/hWILn6KbQfYcAhita7qm7YHseuT+IodGMC5rngGQfvpK6h3jldqt//yQ5C2E0m9NywDAI2vc21CqViZAD47UET6G/PiG4BhS9kSb91+k4CKw26WZzT1PbzbfEWfNggIEV066aoVL8s6hzYXic1m4L93d7/tmcqVkJrL84UM7FGqimuCEHO4QBAzutcZzcSlsZe6NE4nRCTpZSQVmrtNl6fVZ3i1cZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=f5BaNKkAiTZ5UJUGdreFlvsi0zKbOk+4L5A3HgvwSG56xJ7whJYjg1wwIvUWX/KEJdDLGcDvTeT/0xCjad0/tfsrQqyjh61ItYPU7yv90omZKwrk7XprQRyz7dXx0eTzVMexsHlujbilLfP/DC46cwGChyroJxGnWpPl61zAbB4jDxBowcSccvRotNq9O3daYNVAfpcF4H+UNWyyPwuHhPSznmyAocyzPSulw84+A+ppD5o08c5k5JQyLNcen/My0o4XiwWqUWkNzsEN3YddYSNUEg9nlJz6kJNdOoHylVbbME//a+S8PDAWMQrgtyUl7EN6HZ7NlpbMRvcE8pD5nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=pmpmIs51LvxFh2xlhLXsBZ+WyB5j7pRXtFvuDhj5l34G4vvGHxsdkaUheCnj3yvZa1K0ajNXUOUESWybm2oRMdSkbycbNKv6BYy0f4hivZsxGKk+k61a2vFN+/CdHejtQ15FtYm95cHp5+kBLYb6tkSywOLw9MQs8TBkEE+0oZw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:48 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/31] staging: wfx: take advantage of wfx_tx_queue_empty()
Date:   Fri, 10 Sep 2021 18:04:41 +0200
Message-Id: <20210910160504.1794332-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c446094d-4ac6-466f-f288-08d97474da9d
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3118DE8C9DA073E471520E9093D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/ImssbpQMfV3VhWVOggxqv3oglZRa72FhtAh0gaCunjWYn90uT+JHzrTGC/IQOoSgOK8fW9CWclZDkSzJIj+DXk5Gf8g5L5tiVEcP/T46pNfWI6uz8xaXirmqkyi93zGsuiUaGfKsou3cdvUBO+C/CRWoAF5TuZGNmg4oYse6X0XIt/by4bn+0/DksjmsOIvXSQLDoTzqzwr+U0sY8r9U/EmgsSy56CDW+T4bGIv2S1PBX68Sth4sKOcgIdD9r+FISHxLF55UlHUXq1OSkXDmaMA8akcr0Q8I4o5sqb/mSFnE+Bor/cB34bDU3AlkWwk29rPI55hbnQgO5a/ustkkeK25jdbEnwaA9CEz873j+jLPu+z96oXicmnHLFWAzUSvbb4pL3rHgHySXhJBFyxchYOZF8NdCfV7WUZt7M0SEXGxHVSXZRuKRGdR8Vorzm48s0HTQXtIsyYASRZDSULP5c7L47CpfU2US1sMEoq/dEAAbmWGEvrI17NEU6pme88Tp7JKyZ78SXSSX504KffdRGXZIOu/ETJwDYECQkmjsrbiRo1MiMghRrOROfkhMze90U21kv3t/L3SmAF2MGA6CQpQvcFWb00jJ6cK2gwIo8fue6Qweq5FYcgJAieAEh0ia05QhDmWuOYtZujwmtAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHZ5TzRQcUF4MnpNNWFmS3VWYmF6QS9HU0x0UGttWXQ3K0hVQ1IrczZwWTE4?=
 =?utf-8?B?Q09XeXhlbTA3T3hqRHhlWjh6Nko5eVB6dFhBdXBNSkVuOStQRGxtbWduODhm?=
 =?utf-8?B?MjYrNk5la3pPSWJMeXRtVEozQlhUa01HSTdGS3phWWJYOEw1V2N6NGZVN2Q5?=
 =?utf-8?B?cTFwUlpvQS9FMXlmL1hCNk5Wc2JWQkpwUDVWRm1idUpqWlVoVXVOaWpnZ1FX?=
 =?utf-8?B?d2FwUUNKeUQrckVNTEZWdnJYM0hqTXp5bVNpWmlrbWRiK0x2T2xBTWxKSVd5?=
 =?utf-8?B?ZUFzNExoTVhnTHRkM2lmM1c5dUFEUUttVkhvcEpzQVkvNUpzdjA3bUU4TC9U?=
 =?utf-8?B?TXA0T2ErZDVhL05oVGRBYXAvTGlmWHFRM0NuM2QrZG8wcEdET0ZDNXRFNVBp?=
 =?utf-8?B?L1R0SHk4T1phRDVOR2hQMUVhcWNLRk1yenFnc09xRlZTTytPNmdsa2dkMjlR?=
 =?utf-8?B?MDRQVjJ4WlFIUEh4UmFLeHJQeDRTS01FV1hZQ095djR2dERzTjl3dkdaSXlX?=
 =?utf-8?B?eU5ucVFTZDhSNEhEa0RIRVJvMFpsL0pEZlEzTWdaakYzdVJyS3lOa2FYM2Jj?=
 =?utf-8?B?NngwUE15ZkVJaTgvc0NoSWhlaUYwVVdqVFdYQUxScm5lWXRQUmxtK3p4OU9w?=
 =?utf-8?B?RDRVYTdaMDEvTEtlTURBYm84SFJwWEc3YklFbGtBcTVycGlOdnRDMmgyOUFM?=
 =?utf-8?B?SzBHc3JxRWJGMzBBUjdVWklrUU1NTG5ad2dpY3B6aU5hZS8xcnRwRy9xcEtJ?=
 =?utf-8?B?Vk00S2dQSEliUUJxbldYamc1eWlVaGdweFpRQVJ3Ni9MS25RUEQ1VFNURzg5?=
 =?utf-8?B?ZlBwME01SGNtZjhveUg2dnRuTUdyNTZaOUpkdzl5QTQzSENyRHQ0dEZXRmti?=
 =?utf-8?B?NjIxMjBVWHU2NzVzdzc4amhNRG1vbkRCMlJSaEhORThVMTA2aFpIc1ZhLys5?=
 =?utf-8?B?Q3dhOGtCeE53cWlYemc2Mzd2WjBhd0ZkdnlRU2Q5dnN2NWZpQ1R6VFY1R3BT?=
 =?utf-8?B?dnBYbUZWRy9wYmllK1hhQ0pJby8rQmduQWM2UEM4S3U4YmdxQ21CNWxCUFRn?=
 =?utf-8?B?UHdTNHVpdDNjWW02SHhVSTc3Sldabmw0K01kZi9FQlBJK29HWXBFT0hFdjZE?=
 =?utf-8?B?YXFaSU5oUnpta2RIK3hGZ0Q1QkJNR2RndWN5QkMzSW40NXpzVlB2NUJ4NkQ4?=
 =?utf-8?B?Q1R2VGV4U3E0RGhUSGdCLyt3dlBRYW9OaGZqTnJUZGJxYTRpUmNVVXRUejJu?=
 =?utf-8?B?cFhnWlBoSDE0c3duaFh6MVh4YVlHWmhoMk4rNzdTaHFPTFNldGxyL240Qk5X?=
 =?utf-8?B?SlBTODd4dlN6aHdOTW4rREpYVWVVT1dMb1g1c2FwSDIvRitiSW9wSXRtUlQr?=
 =?utf-8?B?VGpvRllBaERNZDh6NFlKNUJFVWxIdUFCY3MzSFNiY2V3T0JrQXp6M1JJdlFq?=
 =?utf-8?B?MU9FT0dqNkgwQlg0KzZmUlVLcmR3bjBVTkhYSWdHbjhRcEhtQTRMcEUwWCtp?=
 =?utf-8?B?TWdLK0NRejFPQU1abnE4WCtubThtUzhMRUxGenRkbHlrU3I0NlNWalYrUkJa?=
 =?utf-8?B?QmhnbFZ4U2Q4N2NJSzZmbjRjT1B2eE13emNuNWtLaGVjbzRwenM4dythcmhh?=
 =?utf-8?B?MFQ1VkVHdzNpZDJ6VkVlSlUvVExrWHdPUzZFOVhMS2pmS3EzNmF4bUE4cVhR?=
 =?utf-8?B?Ym1EbGY1ZmhtTlRHTCtlQUlObU9GSE4rbGM3d1VkbnN6bmFKTmZkSE9HMWxZ?=
 =?utf-8?B?VGZ4NEw0ZllVMytFaVRLNDIxOGJrb0w1TnRRZUdkTXloMDZDT25QQmsvRGtt?=
 =?utf-8?B?Qk4reGpmZlZrbEdOZE5rNDdMRjE5YzY0dlhQMXJrSnowaEhDUHgwMmxyUkVG?=
 =?utf-8?Q?citClm5H0nPml?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c446094d-4ac6-466f-f288-08d97474da9d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:48.4887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4rGFY64e8izhFBGnmiWYdqkmmgkAh3c/CWpnImrecEfBJsehxOpsGnc3F+/zsVpVWSSemGEM/zn5kKi9qZc9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlc19jaGVja19lbXB0eSgpIGNhbiBiZSBzbGlnaHRseSBzaW1wbGlmaWVkIGJ5IGNh
bGxpbmcKd2Z4X3R4X3F1ZXVlX2VtcHR5KCkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jIHwgMjEgKysrKysrKysrKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAg
aW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGZhMjcy
YzEyMGYxYy4uMGFiMjA3MjM3ZDlmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC03MywyMyArNzMsMjIg
QEAgdm9pZCB3ZnhfdHhfcXVldWVzX2luaXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJfQogfQog
Ci12b2lkIHdmeF90eF9xdWV1ZXNfY2hlY2tfZW1wdHkoc3RydWN0IHdmeF92aWYgKnd2aWYpCi17
Ci0JaW50IGk7Ci0KLQlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7ICsraSkgewot
CQlXQVJOX09OKGF0b21pY19yZWFkKCZ3dmlmLT50eF9xdWV1ZVtpXS5wZW5kaW5nX2ZyYW1lcykp
OwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4X3F1ZXVlW2ld
Lm5vcm1hbCkpOwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4
X3F1ZXVlW2ldLmNhYikpOwotCX0KLX0KLQogYm9vbCB3ZnhfdHhfcXVldWVfZW1wdHkoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlKQogewogCXJldHVybiBza2Jf
cXVldWVfZW1wdHlfbG9ja2xlc3MoJnF1ZXVlLT5ub3JtYWwpICYmCiAJICAgICAgIHNrYl9xdWV1
ZV9lbXB0eV9sb2NrbGVzcygmcXVldWUtPmNhYik7CiB9CiAKK3ZvaWQgd2Z4X3R4X3F1ZXVlc19j
aGVja19lbXB0eShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlpbnQgaTsKKworCWZvciAoaSA9
IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgKytpKSB7CisJCVdBUk5fT04oYXRvbWljX3JlYWQo
Jnd2aWYtPnR4X3F1ZXVlW2ldLnBlbmRpbmdfZnJhbWVzKSk7CisJCVdBUk5fT04oIXdmeF90eF9x
dWV1ZV9lbXB0eSh3dmlmLCAmd3ZpZi0+dHhfcXVldWVbaV0pKTsKKwl9Cit9CisKIHN0YXRpYyB2
b2lkIF9fd2Z4X3R4X3F1ZXVlX2Ryb3Aoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJc3RydWN0
IHNrX2J1ZmZfaGVhZCAqc2tiX3F1ZXVlLAogCQkJCXN0cnVjdCBza19idWZmX2hlYWQgKmRyb3Bw
ZWQpCi0tIAoyLjMzLjAKCg==
