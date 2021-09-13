Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF69408689
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbhIMIcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:32:25 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:33696
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237811AbhIMIcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFFufLEDhM1jEyIieyDRyZhtvi3Ont6paMn5p1p0n92/0dqZxveVfVvK0b77/kYjTfOQ7OQVkTPxZ62DfDKncpiPKvUvfdlDguADYgIUs5PLRUXZdiV4b0ULY67t2ngCkMYqpiKYc38ZhVSVQDGpHj7IEj4CvXQ2GGbU5UUenPSGoPDYytgkdOhDkHFee6y31lQjQqzgRGekGPrMB9brDo3q7bSlEMGP3notWer4Lie40C5j9R+9BazW8ue9W8m8u4atFMzj/k/xMaW0vlU3YU3DHCXahSzlilf4CveUwt2eFx7ER4vHNgD/iATI9r8vI5CHuOKz6+MxsOIc/N650w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=JL89hpNS3Ec2I4qZrddZiNvescyub5C9LzyGn5ydoyRZtl+M0beeRqDk1SVlpU2be4tA4A4pbtGqP9PfUoSVJ6cKijKg0sa9ZuImlB3N6AHDPCik4nxT4MdRFIeQ6zhtbAzt8tZQ9WA+UwWvpO1oaB0403gMLvqvEQ6eZdzj0nMT1HS/ff/SqtAu3XKBmWHQd4Z33e0qVyrixIGD8pmrkj14XUzr2Cha6V6qu5vJbsGA1oi+UTruFgdss4yGoVr6rZKnAB4dmy70zKSj+HciWU3uQqs/pBHhaAvx4fGwLBliWpJhOg5O71QCwa4d7xWjhGLQWEZ5ylPA/RWoy30KNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=mv/kQ3PPxdU5sjXvX+yrcjf4l0SLV/KTpcmijD2b0J77UarRkmy4yyWxpUY9sWrAokBJYTopj1zC1W5OI0Df9IQ6FYFiWpvoGjBe4SgpMH9jfGN0rhcPcywsxYnc3kGXBbM27Mbm0hMUwEBzhegBbcA5fD7+2a4ZPxb4chA/XwU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:05 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:05 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 01/33] staging: wfx: use abbreviated message for "incorrect sequence"
Date:   Mon, 13 Sep 2021 10:30:13 +0200
Message-Id: <20210913083045.1881321-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 420088a6-8ae9-43ee-1044-08d97690d40e
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32632F83D8EB9067FF45548093D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6p8yyxYB11XRANi3ffvpoKXGhhQW4fw3ku5I3JHabmuvrtVBsnGdDB8ivbxCWBWO4k+TJ9wARSH1+LHg4+DwzLdg6nodfSP/hzFFMF6K+npLgLbvQLLIE7oFTwtxJG4YlxckiWbWZdfqHb7VH48vUPpvZEtLCJvvTaPQuBQJrTCMla9UuMtXg3FUd/qfTcQ37bByMflM/PHVXxu+qz+oucgLAmPHR4D8bgsLuXmk/ixKv9p/YeZzaz+ZmWQ5DyRNgtxI+0M6VbHw5KgQpkQy/P5rAKkmORdx0qtkdjhXNdBQq7h7DkpfnEMMcIx7k1j+N4StQyBlPGGXp+zlCHD9drVSmYXIMtliMqNTZj2Xl9eJIwZFdOmWon8ooQZLEygXhmPxg0PMN+QlsydXDlROJW1zwmvIlJSJVNLyzBMG9kDmBqn8EkKp0VAK8nSpARFRelFn7D1lE+2ZjiLl1dADn3pxD3YmcOI+4Z8MbcuClImVDIKzojWg2LZk0xJHPZhugfh3SseRNaLjbL+SKiVE6SkjmOIFfxpTep0e9nti02/lepKk5VZV8biNovdMfESkhMhqhcSFkw7n3VlEirAfd8vK1fd3ZlQRCJ8dBSINgo0JYSV9HTOMKhR+ZVlERuiqlp+44Vohxx+wMpmB+C0fTKIZqndzyND3rg5NP7R0quF/kexp2BgBFDSL2hGOQYGBITqc5s4abw5yJ3Ac9aeow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(15650500001)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emp1akgzMmhObjJRcHZ6N2NlVGxod2FuK2k1M2xzZ0VJRmZnamtELzhFV1F0?=
 =?utf-8?B?TE5Sbyt4NFRMWnpiVGpTZGhva0VxbEUxQUhCYzlhZ25xWmV1QVZZN1BOSFNQ?=
 =?utf-8?B?dmhZUVJIWE9DR09GR05hSUxDOGJua21wcVFpNEVTd25nbHRScW5YWk1tNTVj?=
 =?utf-8?B?ZE1kenlNOXl4a09udEJrZFdjY0JURTBKblhNdFoxRGRkdWxwK0R1MW1lZjFr?=
 =?utf-8?B?WjV5ODZ0NEg1SloyaGVjRmlsd2FBSTdvZG1vRlJHbXQ5ZzZYMlA2M3VRRlow?=
 =?utf-8?B?c2pQcHdvaEhUejVVdVFMb24vSnhzWjJrNVAzYVVqekVFcEM0SjdMVnpkZ2wv?=
 =?utf-8?B?dXc5YkQwenY0TEtBdDZURm1IWjhqcjkxSWdZNmplVm4yYWZkOWJ3Y2E5eTJt?=
 =?utf-8?B?TjBkdlZhRTlZUjFaTzdqSmRmMVdHNllxZkNwdjdRR2pUTkI2aFE3WWcrK3VX?=
 =?utf-8?B?V3BHUEpja1dxYTZ6dEVTcnMrSHRnZHp2dE9xdE4wVUY0RlRqYi9QWkdlQWNn?=
 =?utf-8?B?Y3ByMnVQZi9zWUtnbGU0RFhab0pIc0hUdGRrK2c2TlUvSFF1cTJBWUQ4bEM3?=
 =?utf-8?B?djFDK3ZXaGF2a2NYQStuaVNIa0x1THJrWVVQVUZ2S3VQYUFxcW85dnY3eTZD?=
 =?utf-8?B?em1JT2VzWUs5V2w5em8rZ2dWbXBkMFZJSDdhcmdsZGcyZ0JqcFM0Q3J3WVQv?=
 =?utf-8?B?LzFVUmpGRmVwSFM3ZHI1SmkyU3JtdTZYUzZqNGxRMmZiTEtkVGg3RW85SkFw?=
 =?utf-8?B?NUplZVBSVXl6dU03c0lTVWdBNjNhcXNPdy84aFdOQjdFaFFPSXFKeTA1ZFZZ?=
 =?utf-8?B?THJicnkxcmlxSGF0dkQ3TDY3Vm5XV0E3VXFSV2kyS1BTc0d2ZmJJQ1B1WFZ0?=
 =?utf-8?B?U0k1bU9NVnpsdmdJd09ZemVWVTZLbzVpL0w2MmRydXdEWlFKME9lN2JQRytQ?=
 =?utf-8?B?MDNmZzZEQjhETXoyb0tYenhwSTlWZ0xMcDJDVUxybzVZWHJCNlM2V0lsN3pr?=
 =?utf-8?B?eDEwRkFGKzNqajF5WWFYVThvWDNWcm1uM3lDOTRvTzc1ZXVjNU9oaW5XbVNT?=
 =?utf-8?B?TWJoWmEyTnZyYnVCaUxHN2x3dFNwSkhWOWpQTVdvUEgvTUhYSkJWN0N2MXBh?=
 =?utf-8?B?MDdxTWhiS2tmejdzQWN1VWFVYWZsbmw0Zys1WWRsb0JDNjVMZ0JMU3htSDc0?=
 =?utf-8?B?T0ROTTdPSTJ5WHlpYlhZZ0l6aHArZFZYUGhwNVpkb1djNFg4WGNaYUFmRExs?=
 =?utf-8?B?SitZSk1QTUhJcnhxcGltVEwxQ252RFhDQ3pSYUpCK1Jub1lZQjdrK1lVQy9r?=
 =?utf-8?B?SmJHalp2NFFuOFNlVU8xOGNXSE55SUs1K2pjY09YZWFWL2t6ZHBJYlhDeFpj?=
 =?utf-8?B?SGNsR3RETlI2Z3pFbVdHMU5nY1luQ1FjK3FPNzlzRHBOcTJtSGsyeWMrZ2oy?=
 =?utf-8?B?Q3JDSVFzdjZPWkVSYkhkK24zZkhhc3dML2dITjVZOUE5enhLYnJUN0NveGQ3?=
 =?utf-8?B?RWdoM210Sm5yN3JieC9BWFo5THhHTEthY3JCQ3VjMDBlVXczNTRoUTdJWFQ2?=
 =?utf-8?B?TTcwTkg0UVh2ZEpKNWlPM2dLWXZIZ3ZvNVRHS3d3ajE4NnoxbW4vNTVveERm?=
 =?utf-8?B?cTlEcVQ2QUZjY2FnNTh1L3dhVUtOZkxLTU03R3VYbkdJcmczTzlXUjZyUTBH?=
 =?utf-8?B?cXYwQ2RsZmRHYmw2QkpGRHFFTGtIeGRHY1AraGtlbVVBaDZYY1UyUVlMYi94?=
 =?utf-8?Q?fqavPQE8V8ftSORsmVTkotv88OOHEf8y+dn8Jdo?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420088a6-8ae9-43ee-1044-08d97690d40e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:05.5884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxjTk537Tr12P+SuDfWHXAnUxH+03pOGTBhbok1EjO2UaZNTzM9jUoGrwxW3+WFS42cbM5Sp1KxjF5meUYTbSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgY2hlY2tzIGNhcmVmdWxseSB0aGUgY29oZXJlbmN5IG9mIG9mIHRoZSBEVElN
Cm5vdGlmaWNhdGlvbnMuIFdlIGhhdmUgbm90aWNlZCBzZXZlcmFsIHRpbWVzIHNvbWUgc21hbGwg
aW5jb25zaXN0ZW5jaWVzCmZyb20gdGhlIGZpcm13YXJlIG9uIHRoZXNlIG5vdGlmaWNhdGlvbi4g
VGhleSBoYXZlIG5ldmVyIGJlZW4gY3JpdGljYWwuCgpIb3dldmVyIG9uIHRoZSBkcml2ZXIgc2lk
ZSB0aGV5IGxlYWQgdG8gYmlnIGZhdCB3YXJuaW5ncy4gV29yc2UsIGlmCnRoZXNlIHdhcm5pbmcg
YXJlIGRpc3BsYXllZCBvbiBVQVJUIGNvbnNvbGUsIHRoZXkgY2FuIGJlIGxvbmcgdG8gZGlzcGxh
eQooc2V2ZXJhbCBodW5kcmVkcyBvZiBtaWxsaXNlY3MpLiBTaW5jZSwgdGhpcyB3YXJuaW5nIGlz
IGdlbmVyYXRlZCBmcm9tIGEKd29yayBxdWV1ZSwgaXQgY2FuIGRlbGF5IGFsbCB0aGUgd29ya3F1
ZXVlIHVzZXJzLiBFc3BlY2lhbGx5LCBpdCBjYW4KZHJhc3RpY2FsbHkgc2xvdyBkb3duIHRoZSBm
cmFtZSBtYW5hZ2VtZW50IG9mIHRoZSBkcml2ZXIgYW5kIHRoZW4KZ2VuZXJhdGUgZXJyb3JzIHRo
YXQgYXJlIHNlcmlvdXMgdGhpcyB0aW1lIChlZy4gYW4gb3ZlcmZsb3cgb2YgdGhlCmluZGljYXRp
b24gcXVldWUgb2YgdGhlIGRldmljZSkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggY2I3ZThhYmRmNDNjLi5hMjM2ZTViYjY5MTQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtNjMxLDggKzYzMSw5IEBAIHZvaWQgd2Z4X3N1c3BlbmRfcmVzdW1lX21jKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQpCiB7CiAJ
aWYgKG5vdGlmeV9jbWQgIT0gU1RBX05PVElGWV9BV0FLRSkKIAkJcmV0dXJuOwotCVdBUk4oIXdm
eF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSwgImluY29ycmVjdCBzZXF1ZW5jZSIpOwotCVdBUk4o
d3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkLCAiaW5jb3JyZWN0IHNlcXVlbmNlIik7CisJaWYg
KCF3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZikgfHwgd3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxv
d2VkKQorCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJpbmNvcnJlY3Qgc2VxdWVuY2UgKCVk
IENBQiBpbiBxdWV1ZSkiLAorCQkJIHdmeF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSk7CiAJd3Zp
Zi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkID0gdHJ1ZTsKIAl3ZnhfYmhfcmVxdWVzdF90eCh3dmlm
LT53ZGV2KTsKIH0KLS0gCjIuMzMuMAoK
