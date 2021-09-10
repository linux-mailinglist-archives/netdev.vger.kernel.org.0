Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF2406EBE
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhIJQIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:06 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:58752
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229702AbhIJQHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R21C4FFyUrRM7F7LuwhZcmhylN/6QrITi/bQ0E/BPU/uxRe/TR3r46WAShq5EzdoOjp9ZV66KCQW1n2/WkqaHZ3UscbDJe52JZwYe6+QjqDX6DUpWdJQPnN+K/G/6NpazWkVDg0DXpBCyK7cOWlz34fiwZwbE4LWjCb4sCoQd8n5WmEPgUL5Lt8zTGnDSwjCaM+GQXVqQzfDyKMGwO+OwGJ22gLHtzawUa0ouMw92BNCbjULSVdin351Sh0mYEQK08JoZTUlDjiQVMGY+rfUMasqZTC1g2cRKQ78/7yBh2X5s/f58ppdtICC/NB/9oz65gAiWb3qEVSX2/OkjiQVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6X5C8iiyie5c+H0xNzgV2k5OxRmd70FdYQimieF/nBc=;
 b=eOqgOiaWj7gmkxCBoSEh7HpDRHls75QKXTI3UZtjjkNdjzbfGsJxUZlB6LmzG7SDUrB5CpG3FjgRqtFelasgVWxX6SpsRBoHn2SXbjA1f/rKgaYlvAsqC0jpylIwdh7eUfJW14hi6rTb8Lvzl3S4/sVkLhgmdF8Op9iC5tAweZceDPe31v5O/WPBro+/JrzbkNbXzVf7RJbnvYrLpKv1IKUWCnBoUN5f85/XVaW/e5IJ/EtbUyZ6fS9C9jjQDORuHjJ+7EIJfbwbenYeto9EDSRzK++aLTVMICFWL5GSFbN92ToAEqqjyTsbsGPvF+1hNVZ+olXm28I+r2VkQIE8oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X5C8iiyie5c+H0xNzgV2k5OxRmd70FdYQimieF/nBc=;
 b=oaxGJrFr5Cf0H73XKt6gLirhRJ5D+ICgTyZP8KJGA/Bz5BA9c4liTKWd/fak49aRa0Zb1rH6/g8SDEaQ4yXSNyYb4UGAHN609JTM896tqJvN9WcqSv7jreWgiqSJGikNnsG8Qaocu7oaPpmQ3UJpSR43XUni0pWCwtvkU6lzcFk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:46 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:46 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/31] staging: wfx: fix atomic accesses in wfx_tx_queue_empty()
Date:   Fri, 10 Sep 2021 18:04:40 +0200
Message-Id: <20210910160504.1794332-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4869edad-414c-44b2-232e-08d97474d960
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB311893720B7019912979892A93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpAl3jaT6JaVsb4Ikaz76qFCRn2NvFzAQNXspZjW34l6WVsN+zGZco1MI9NsZu0oPpyHd8xay8I5k2N/sODq87eEc0zRk86wtAM2a2Yg+b8ZOzEiy0ecJXkYl56sgBRagQxJGX7Q3mTtoTO5DvYsSjSzalrUa/a/qQdGxkWItYKOZlQLLcNvhjGAsBpcj9alvIADfMkrRS4vTO+vfLnHirFoob2aq8/JJmGcI+12k9eKnHk1/ZZkJtxJQv9Da7nEy+8d4+/AWGEoE2FnhkBcQ0a2Pu31CkpUs9XKXcAlbeEFDrMS1eoEFxM1KZd5revWLiR78X3V4jn4kXlY/7cY5CdSpR6ZWsZvC/VFGljCFZ9Ji9VOZu286BTP/TTfjVVtS7Jal/FakIHlmQ7eHBM6Yy013k3/1XXEpUks9powoD592SVdOEyFrqM7RzhJt+F4ielKGWhvt52Lv5nwd2iGntH7C5e/tICYdnZ9B8bz4r8XS8musXCAG80dxBhbJvv/LhAjXKLYWwGrDSRufiOB9T/kEcJs5l9HFnSixUAicfpsS0vCFOnYc6uNJzx3/gS/qb2cxVUW3FplelorP7043PrqncJh2sxW1E/snNOR6r3TPDCbL+QKYTMuw2cVOmX+nstRM8Zwo6iKCxuCWl3UaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(4744005)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXRvditoZzU2bUhBaytFVDVmcndsZmFKUmo5RCtTd3JmRVlhRFZKL053dUV6?=
 =?utf-8?B?cFhwSUJRVE5mYkpjWnBGc0xGRml4YnJGOXIyVWkwTFgveVZ5MUM4c3VZZUxY?=
 =?utf-8?B?S3dHeGxkRTBvZzZ2UjE4ZHA5cWpGK0JGOEY0RHU4L000Yk15NnJnL2RHdUl4?=
 =?utf-8?B?U2ozNVVsU3k2TEUrZVpNVTJDb1Vlc2tQbHVvWXk5a1F6Q0hoRVNwcWlkTTA5?=
 =?utf-8?B?Wk5GNjJXUGV0QS9DY2plbUtPV09QeDB3UVdlZkZhY1k2eFpkQjBMVm9RK1VB?=
 =?utf-8?B?dDZZN05idWFRNWJNVUpGU3Y5VzQvcjBoMHFqYkQ5WXFyak1NVGdkelBVb2Rk?=
 =?utf-8?B?ZGhUSlZSWldvYm4zUkFHS242TEZrWnQwMTF4QWtFb0ZPc1JWMHpyQlhjUUxz?=
 =?utf-8?B?aktYU0FLcXpjeVNhWHFPdjZ5SFViVWxMaHZWNmR1TGVaUXpDSGUxa3ZheUc2?=
 =?utf-8?B?S1I5VEQ1eDgvY0N2S0pNcS9STFZ0NHpERXM2V1FDdTVkVG5oRDdaVDkzV0NJ?=
 =?utf-8?B?bVEyYkdxTytHaHFUM3dtcXRRTnZ5b2xGQUwvclYyakJhMVdSNGo5a3o0YSs1?=
 =?utf-8?B?dDIyUUJ0SkJpcE11TkdWc3hCczRlQVFTZXNrZERhNk5hUDNWeG1kNzdtL2dz?=
 =?utf-8?B?V1dkQWFTbCtYYjV6alg3ZVprakdZd0JERkJrTzd4aC9RSUNlUENHb2krWmpB?=
 =?utf-8?B?Tnlya0xpSHV4dEV4dEpwaXU3RllhdVAyWWlHc3FnY3BuUWVBOEFFU3N2aGlq?=
 =?utf-8?B?KzM1dTlFT3BCZTl3eFZ4YlhKRG8ydzlSZUU4M2ZxTkwwREFTUERadDB6cGc3?=
 =?utf-8?B?TlFvSUt4RHJ3M2l2R3R1SnNGQmFMWHJpcnFsbXBOVG8rdmZEOGdJcThmaFNX?=
 =?utf-8?B?TkZydXkwMzJHQ0tLMWhqOWRFZTluNCt2WWZaYlF5dVBsWUZzazQyUVppM2tQ?=
 =?utf-8?B?UWErOFRlR1hrVE1ZbFNrSk9nWVkycld0RjIvL0xDNWszY0lCZTh2VFhueDlt?=
 =?utf-8?B?VVlYWlRqajRyTWQvVnRiMVFTanFlVk5DajBlSkg5QTdtUlYzVGZBNm5oMDVr?=
 =?utf-8?B?bmtZTE15YnZHVEFHTG9NNlN0dmk5Qmx1OEltTTc0Nk1WaWhWK3RwZ2ZqRXRT?=
 =?utf-8?B?VXhURVVKTzFQMGFwTHFNa3JzTHR5ZEZYVjFXaFo4S01kMjNJUmdxUG1LZjNx?=
 =?utf-8?B?QXdGdUxCeVU2cTJOanJqR2JsNUk4RE8ydXlVb1l6RDZFWFJwUDRNUnR5Q2xL?=
 =?utf-8?B?ZENPeWFyVm5GaDJ2VUlSdzc0RVNzdVliSDVObk04NGZvd0pRdSt5RGp5dWUy?=
 =?utf-8?B?WndkOFNZVW5aYms5cXB3OElrVFBHM0Q0WXFRc2hEZmN0OG5Rd1N6VnI4ajhz?=
 =?utf-8?B?dml0TGNpai9wUE90ZVV6b2kvdDJzcEs4enh2aVB3bXF4aXhjU1VtWThnSU5p?=
 =?utf-8?B?dUp5MzRIWlFzMkNIekhsdDNZSkRFZ09aREwrNU1ZMFlCRU4yN09LcjVEMm5W?=
 =?utf-8?B?U2NhRnNFR2dnbDFyeDQyNDlMdmVwM0kwRUo5b0FzMEZ1MzlzYXFGMHp5TU5W?=
 =?utf-8?B?b2hHdzRYU044cnZZK1B1cEdoamo5RzJqSFF2Um9PZTJHS3Vvc2Rabms3N3BK?=
 =?utf-8?B?dm1ZbDVpWFZIdU50NVN1VVlkRGJpK1NRR01FZ3pMWTgxWndiL2I2OUtaRzdI?=
 =?utf-8?B?TGpETFp3TjlEUUFsMVY4c0F1U1IyREwwa3F0dGwxY1JhYXRRMWdyQjlvQ2U2?=
 =?utf-8?B?emFiVHp2S3FUTGJBb1VxdTdleXVGZGJ4R0pvOTIvWjdRVGpkSTFUNGQvanE3?=
 =?utf-8?B?WjBoWXBTRGd5Q05KRllzRjBxYzJhYXdsdzBqQXliZG9sNW1xS3BRRU80M01o?=
 =?utf-8?Q?PPz1IHx5i+HbF?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4869edad-414c-44b2-232e-08d97474d960
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:46.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/MeefDJBVoGTz/+KK9//duYOmUbPf9hI42bPpYynOHluLOcWAm6qlUVHfFPX04w3tkNBjmqhkVzR9sdw7IKOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ2hl
Y2tpbmcgaWYgYSBza2JfcXVldWUgaXMgZW1wdHkgaXMgbm90IGFuIGF0b21pYyBvcGVyYXRpb24u
IFdlIHNob3VsZAp0YWtlIHNvbWUgcHJlY2F1dGlvbnMgdG8gZG8gaXQuCgpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMzFjMzdmNjljMjk1
Li5mYTI3MmMxMjBmMWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTg2LDcgKzg2LDggQEAgdm9pZCB3
ZnhfdHhfcXVldWVzX2NoZWNrX2VtcHR5KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCiBib29sIHdm
eF90eF9xdWV1ZV9lbXB0eShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHdmeF9xdWV1ZSAq
cXVldWUpCiB7Ci0JcmV0dXJuIHNrYl9xdWV1ZV9lbXB0eSgmcXVldWUtPm5vcm1hbCkgJiYgc2ti
X3F1ZXVlX2VtcHR5KCZxdWV1ZS0+Y2FiKTsKKwlyZXR1cm4gc2tiX3F1ZXVlX2VtcHR5X2xvY2ts
ZXNzKCZxdWV1ZS0+bm9ybWFsKSAmJgorCSAgICAgICBza2JfcXVldWVfZW1wdHlfbG9ja2xlc3Mo
JnF1ZXVlLT5jYWIpOwogfQogCiBzdGF0aWMgdm9pZCBfX3dmeF90eF9xdWV1ZV9kcm9wKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAotLSAKMi4zMy4wCgo=
