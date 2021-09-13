Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397C2408C04
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbhIMNIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:08:11 -0400
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:27422
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239584AbhIMNFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwYuzr1zmhvN7IdWRD4ShyJ0dk+EjwT55EnLrmsrM9uoGcC173JtA9T0NFvtloWe3/B//YCzYfW1AAdZ9c+ozRo9KS1eHp98Az7aSbeXGUx3IX7daPGh8PwSAjEqN27slx8/KucNRe+/PtHS0RHngcGO9QEpiwTzJlUy36naCEHlHtchEGaa6NQK3N2gx8gNaW3poS4AH4/PKqGOr47eqZoZ+WeDNvdUsQ8PByHnC5YMR0CI1jVtPFZJ1VJXl/9EZU8Jn8EzBYmSemP9cFM/IRp09LFlbEnLCpa70z0sdwaUgBmifBE/GY5NWBqsEKnI7acD/aiDItRkcQfw3ywRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=OCKhJFCiMFYPBjASNMbn0N0Jp8eT+mDuf4LqZCK2J2bSv3cvLMcSn0uZmDm5kyDnmJY60wpuP4L2KuhSK21qVd8erK2sC/JHbQRIuUfy5jdLnD8vSfQ2PLTP4hPGOlh3/BycnTtz42307LaqF07n+/Ua8+1Ttt5SrDvL3iSuWWCqKS1jm8OFp9OxXvLBhvEbXvaefAHk+Bqw5/yc/06A/fNfbKQElnFvTSplpquLjm78ZS/rnQU/+1IsH4RP91DPP9DlfAVIn3BaYGZodelyiMtiftjMgarmTrFVTnxw/lngtfV5EkqPNjkatD8bGbKQS4Wv26/Lxc89Soi5JGh8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=K8m1NKXEZAyqqXDOGn6VGIMljRDIYqJoM+yp1KJ+PPLHc5X+zZ4LJYT8UUArs1MRKwrsJrFt/rn7+mcq31KB2Bqta9OAfvw56DdExYuUzU3tQ3s8M7DXsZbJLmLwnEDJJSQ0R0DMvPoUStOdjyF1cu5tB8xkOToC8/nA/0Xu0Eg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:45 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 15/32] staging: wfx: fix misleading 'rate_id' usage
Date:   Mon, 13 Sep 2021 15:01:46 +0200
Message-Id: <20210913130203.1903622-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97a2113f-a959-4011-a7ca-08d976b6c742
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB48604201098BAEFCB16F96CA93D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdMPTenJ7ROZ6DxZtfrlZqwMK6JMU6rBRUQvegAmMzgMV+1yT8JCT0O7NXAUk3linGL3VRL/yeiA+uTjeT7Dhg9RE+cEEg+OZlUElfhAZxdXL8Ogy2QhPcyIHNd3tGRke8sHu1eifzOxdIXBY6T1vSyUEWsH5JoDmCtRfrx33k9VSYuWa4n0vQhdTg3O+CiOO4AWz1MfQpiuxcyfhpwWWCKY0dBtfRDTtwzelQnVwytvQjPwkH+6q7aEq/uDIFDw2LAMYMaRgpQwQTuK6hIQFJnBga7vCkstnWNKV9eTTdrUZydhy4r8BwGM462mMf0ISqE7Pc58LsUWHG/tCHOQHdjp05u8+MdBgYiWy7FqdKxIjvaVc3ozImbgMs1rQMJVGmkVUB7C7KDlEwKVc+arCr21CW2Kgy8RTNQKx4I+MyALmX5mDCEltCHlgXouu4twThs2KVpteYb5Asg3zwqRPqX3JYWPW9xhFnOchxQMb5FGbpEud7Yydfuh0LMTULssI18hmDdf2fRSunuXYQ9iDfI0jyH5yoRFgTNeXFaWk68RQ5oTgI4ULp+H6Eh3GnYQ5RFatXTx02eViV3UaFBWuPoOKagVRBxGeP3RjYXZjViQIXko0FJrv7OzN27EfX7xFDEPM2e2R9RhLKV6sBvqkpex2xrE7TAiQDVRuRtF8+t0Z0kXiwSMrv/gr5ezzxXFL4tSEEeea+s3uikUe2MsQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEhicmU5MXJ6YmlyT1F1Tnk3T0o1cGVrRThteStJbkg5NDFoWmRXbFlMUERB?=
 =?utf-8?B?eXkrNXRHT1B2dzFWdkMzVmlPOEFselhxYmg2Z0hMTTlwWFN5ZjZHMHMrOXRB?=
 =?utf-8?B?MkRHejgxRWV4UnliZUdYR2dnLy85VWRUZnNvSk1JUkdTcUdPVWJPaVpsMFlF?=
 =?utf-8?B?bTJQVjcwaTk5UklibTY0MEpjaTk0K0x4b0kvRFBpVFVHbHVzcVFVZm9zeGJM?=
 =?utf-8?B?OHJiNG52T2RFZlQ5WUxaa1IvVkVNUXhiN3hETHRFdTJJZkxGMjA1ZHE1a2Ey?=
 =?utf-8?B?RkZIMURZazBoMkZPd0NOSXBXcGk5T1RBS3FjZThnRmtscGNCM2NBUGRQVG5v?=
 =?utf-8?B?MW1LaUVYL25jSHp2eDRtb2FLMEpic1k1RDVmRHVmQ2htVTJmbzJWd2NYejRm?=
 =?utf-8?B?eDNSdHF3T3publNIakdZdENlOWQrRGg1WmovN2M0RnU0QndacU5mNkR1QWxn?=
 =?utf-8?B?ZkM0YjJBaGhCRCtPR0hUUDdtTzdrbmtlVER1OWFMOVpmSHE2a21MalBpQitS?=
 =?utf-8?B?aGlnREE5cGtHSEt4Q0hMN3BLOHdoN3RDZEdnbmlPS3JwcUt3R1ZjeTIvTWI2?=
 =?utf-8?B?YjVhalZUNXpSdHRFeUhSa0Z0bVN1ME5RZHFrQVY3OStLQVkxdlBxbjJTTEJl?=
 =?utf-8?B?Yy9nNitzVlkxQ3NKenpQc29RVUlEeXY4bHkxSE9OYTN5MUllLzBzY0gwbDdW?=
 =?utf-8?B?d1lJcXA3ZWZXZ1RkQVUrR0JMRnBDRTRIREVjY1VPalRXMlNpRGpiWkNRbVNr?=
 =?utf-8?B?SndmaC9RdjVVdHROeDFURFAzUkZMUXY1Q3M4NUtFcXI3MXJnOWtsQ290ZGtS?=
 =?utf-8?B?VmxCNlFvd0dwUHEreFV1L1AyZTR3d1RLYzVscHNWUjRFb2VsVk1KdHZVL2Uw?=
 =?utf-8?B?WEdieHNkWHJ1TEF3YnJISUFzSjdhK3dnUHQvYk1Yb1BPaTlBK1QvZnJ2M09o?=
 =?utf-8?B?TkNBczJOMnVrbjNZTW9hVTJGamswT1BxNEdKZUFDZlFUZDRDdnZSemZ5UVhx?=
 =?utf-8?B?L0NNRXBRQzQyK0ZqOUNqWFNrazJqazZpNHA4QUxYVlFjL1c0NUdqSWJHcFAw?=
 =?utf-8?B?UmFwbmJLNGxaQXZoNVRxMnNIS3kwcjZMZDdzZGtEYVJXTktwWCtxb055ZGla?=
 =?utf-8?B?bmJIUkVKZEVKdkJxTGk2OEF0bmZSZDJRZnBjN1dDSy92Vlh5ckk1VTFXNmZq?=
 =?utf-8?B?YnNTUE0xK1JMb0tXQXVBeWJDWDJrSkxveTIza2hRZEROVkhQNzYxV1pNL3Uy?=
 =?utf-8?B?R0NoVTBsRzFnYmM1QllDeHg4MEJTeU1telErSFlYM0NFd2NnWWVCNUZjRDNu?=
 =?utf-8?B?OTBrcHdsQjZvWngxUmd1ZTZKOG0rUXhqRytYYTRXdW8yK1VHL1N0bVJmNW9O?=
 =?utf-8?B?VGI3WGFyTExLNGhlaHRhMXFJZ1RESThETUFuTnRwSFpNampFdXdWbmpMTVlp?=
 =?utf-8?B?SmthNGhvNUV6RWJBMFVTZm5saThWdW5EV21ZNHpVazdjNFA5NS9oaTlmdFcv?=
 =?utf-8?B?ZjFRSU1VNGl6R1Q0LzdDUnFHeVNYVVFMTkoveVJsek9GNGYweFhGMjVobUFW?=
 =?utf-8?B?TW91Ti9hSzRLV2lnVEEydktYTnhFWmlaY3RqRnJMN3Vqa2dJOTNmOVl0OXhs?=
 =?utf-8?B?ZWZ3bzMvZUk1QlVJdTB6YXpPZTB1UEcyck40ckZ1RjhXUHIya3hPbTFlNm5K?=
 =?utf-8?B?K3JNZTkyRS9wemgzeEkyOTk4SEszRHNNL3NyS3pTQXdxb25pTE51aUE5TjFq?=
 =?utf-8?Q?6PNgn0YnfqGsmISPnJztinHZYQG33pZzKFq+UdY?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a2113f-a959-4011-a7ca-08d976b6c742
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:45.0414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mafIeMLxNHRO4gI62cQW9EViLLxjLUKbDwZ0T84QI1sOGkZ2+g66eJiJNy6rwk4jyUnBVSIkvkB8PWA6TrZZ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRyaXZlciBzb21ldGltZSB1c2UgdGhlIHRlcm0gJ3JhdGVfaWQnIHRvIGlkZW50aWZ5IGEgcmV0
cnkgcG9saWN5Cih3aGljaCBpcyBpbiBmYWN0IGEgc2VyaWVzIG9mIHJhdGUgSURzKS4gVGhpcyBp
cyBtaXNsZWFkaW5nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwg
MTUgKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNzdmYjEwNGVmZGVjLi5jYWVhZjgz
NjE0N2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0yODUsMTUgKzI4NSwxNCBAQCBzdGF0aWMg
dm9pZCB3ZnhfdHhfZml4dXBfcmF0ZXMoc3RydWN0IGllZWU4MDIxMV90eF9yYXRlICpyYXRlcykK
IAkJcmF0ZXNbaV0uZmxhZ3MgJj0gfklFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSTsKIH0KIAotc3Rh
dGljIHU4IHdmeF90eF9nZXRfcmF0ZV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCSAgICAg
c3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQorc3RhdGljIHU4IHdmeF90eF9nZXRf
cmV0cnlfcG9saWN5X2lkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJCSAgICAgc3RydWN0IGll
ZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQogewogCWJvb2wgdHhfcG9saWN5X3JlbmV3ID0gZmFs
c2U7Ci0JdTggcmF0ZV9pZDsKKwl1OCByZXQ7CiAKLQlyYXRlX2lkID0gd2Z4X3R4X3BvbGljeV9n
ZXQod3ZpZiwKLQkJCQkgICAgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5X3JlbmV3
KTsKLQlpZiAocmF0ZV9pZCA9PSBISUZfVFhfUkVUUllfUE9MSUNZX0lOVkFMSUQpCisJcmV0ID0g
d2Z4X3R4X3BvbGljeV9nZXQod3ZpZiwgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5
X3JlbmV3KTsKKwlpZiAocmV0ID09IEhJRl9UWF9SRVRSWV9QT0xJQ1lfSU5WQUxJRCkKIAkJZGV2
X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIp
OwogCiAJaWYgKHR4X3BvbGljeV9yZW5ldykgewpAQCAtMzAxLDcgKzMwMCw3IEBAIHN0YXRpYyB1
OCB3ZnhfdHhfZ2V0X3JhdGVfaWQoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCWlmICghc2NoZWR1
bGVfd29yaygmd3ZpZi0+dHhfcG9saWN5X3VwbG9hZF93b3JrKSkKIAkJCXdmeF90eF91bmxvY2so
d3ZpZi0+d2Rldik7CiAJfQotCXJldHVybiByYXRlX2lkOworCXJldHVybiByZXQ7CiB9CiAKIHN0
YXRpYyBpbnQgd2Z4X3R4X2dldF9mcmFtZV9mb3JtYXQoc3RydWN0IGllZWU4MDIxMV90eF9pbmZv
ICp0eF9pbmZvKQpAQCAtMzgyLDcgKzM4MSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lubmVyKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCXJlcS0+cGVl
cl9zdGFfaWQgPSB3ZnhfdHhfZ2V0X2xpbmtfaWQod3ZpZiwgc3RhLCBoZHIpOwogCS8vIFF1ZXVl
IGluZGV4IGFyZSBpbnZlcnRlZCBiZXR3ZWVuIGZpcm13YXJlIGFuZCBMaW51eAogCXJlcS0+cXVl
dWVfaWQgPSAzIC0gcXVldWVfaWQ7Ci0JcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3ZnhfdHhf
Z2V0X3JhdGVfaWQod3ZpZiwgdHhfaW5mbyk7CisJcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3
ZnhfdHhfZ2V0X3JldHJ5X3BvbGljeV9pZCh3dmlmLCB0eF9pbmZvKTsKIAlyZXEtPmZyYW1lX2Zv
cm1hdCA9IHdmeF90eF9nZXRfZnJhbWVfZm9ybWF0KHR4X2luZm8pOwogCWlmICh0eF9pbmZvLT5k
cml2ZXJfcmF0ZXNbMF0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNfU0hPUlRfR0kpCiAJCXJlcS0+
c2hvcnRfZ2kgPSAxOwotLSAKMi4zMy4wCgo=
