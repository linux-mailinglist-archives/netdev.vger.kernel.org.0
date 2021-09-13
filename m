Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BCC4086C8
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbhIMIeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:36 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:38689
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238219AbhIMIeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDMc7D+maD11eJLhe3g+4D4jPjf8ngCYGn1ER2BivILuiyd0KXiSPDq0zCePxN9bhv2IQLcQGYkEihxKeqU6hHPxMwrs8Xs1gRnu00G3kKoRhI0KohBHgeygcXz1eGKtTsEwtb4vlV0OkpsUklorx3cAHUK53rTqy3jMQT8wWLWHeBJfYRgIdlZMuZlYVT7yE/Z11cfYaQqNcMdamEiuCd6iAo1S/ygk49javhhvQWa+yQXDG3+PAvufuw7gt6L2YXFx+21ANe7g/0phVVxhzXYMmYx9kH/wZkq9gHRZG96YOlIz4kbCSkUJUKJ1cpCSxp9IC9jG3EsHh18SSiKLNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FwmAPHbajhF2+WsJKbgL8BGX7TdC1AgdDDz7sKWPBfE=;
 b=Z/Kubct9VVKetEwUwiMRqCvKoGx5Ufqj0bgi+gpkSFx4x9uNYnXMoaOnO5ofMh6XULXsOg6f7YKknCUKTVfU3mCsRuPKyZZeeB2j28YFta/BaX0rO+da7AzU+GDczAQr7XoVJQtP06lLvV2nDR2XUZiCkO2rkyssEN21mokK0QYs5CARbqMS0jSLsAS+nJhknw82kc8ZREuGEezX3VT/FdXtDqXwU8XYWz1t5lu2RBcDQFpmQiTb2JGaZdWEqc4G9VhApqc7VdgmgIlC3WsiVmw7ruUiDDlysAOWEqzJRJrIPpE6Q55icvXWO3mb6dP+S/HhNvoSFHzw9M0U4Vfrhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwmAPHbajhF2+WsJKbgL8BGX7TdC1AgdDDz7sKWPBfE=;
 b=g++asta1U++LetZ1aNkGT153DaMO1DNi8KVjJe/wZda2kc7DsQLHxDbJ9NNcqwyzhFAm4xkgz2SzbkW/ifxZ5yDo4Q8JIk202K4AN9purHxUk0Sx24KKvmR/YmzROfo/bRlGiaamLxZkRAWfAU5PXAT+R4ZtnflaRsAZtGPd7Iw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:51 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:51 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 12/33] staging: wfx: simplify API coherency check
Date:   Mon, 13 Sep 2021 10:30:24 +0200
Message-Id: <20210913083045.1881321-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eae71990-c9ab-471a-cd29-08d97690e00c
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263C8B559EB620C8F771BF393D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLVh9zFP96Jx92fh4K0iERFk3vb6A3snP+guyXlgBiaPOdjyDTpSrIvYWXTzi8iMnWdJKxubfV5kzd455atdd7s9yNdIrJfQpkUPMwxLFBPeVlL14AhVZdSz/Grmpfz87YD/raaSFYM0NnLrPtloKjfKgNnlAMRZu7C17JypgkdmmXKad/2fAa1SFbFdd9zzp6VB3JqiQP6kjv74rSPHbCyeJDAW3XLDSVMtjuwGybXkrjT39dlB/M5JBnuzLI1Sq5ww5PJwww745RtDzemgZ5T8+DuVO9pLQQIsSJCPP3v80KKA3Mw8Q9EpSioy7nt/thPgqJ9mjnF7Hsc94GX+1Qn1KC6HbQLGqct8BPsxzD+spEWL4SPBNWUVnW/tMu3cR3m44hSiY4Xp2bpGa7WK4kfZ+CvsXXEel67L1DKUtbLsAliA1RZQGcynEBch+fyK0w44IfZ8Zjx+8OzpVEeadyGP9k2qZs5Djlfw+bEdxtwKxrJ0zkeIto4vNxQKlpOExSW+qlaCL9MDsFyG8kbVm6AfKIEtpSNKo67/gqwcUy23AAUi+0UmFLnsdZ1Vc3vfm2lzH7W2W6NsVIRZk68uFc4MYS50W4l9hRDC3s8v+Jrm+FDrC87MqHA/oU1P3tkHv8zucCJM+VuHDTg4sMzYQ+f5uyTKrwnYsIKOisTowfWTOytxT8YjVlpYv2tiaccbmNHqvLgLFHk19TS962iy+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXo1SjBWOTRsSU0wZmlJQk5uM1I4REd1d21hRklJMTlkbUFIMi9Oa0N2NElp?=
 =?utf-8?B?ZFhnTmkzSmxZWnFPazRSTElyTUJEU2o1djZwNWVUU1I4MDNUZ256UXhXdlF4?=
 =?utf-8?B?OWVHVlNaWkV4VEZhK1pKc1QvRTEzbkJBcERzZlN5ZEpFZUF5S3lwTUVPWnNG?=
 =?utf-8?B?Umx4cHRmd3htQXBkYThueEhyRndHWlhWb3M4cStodE5zTVVqZ0xXRlg0VFN4?=
 =?utf-8?B?MGhPZm90VTM0Q0p6NjVaSHNXVEdoUzZ5cFRKcVJueXhyeXRXd1RuQkFFWTVL?=
 =?utf-8?B?MG8zRnAxb3V3YTRuNWxrOUdSVG9BM2U3cTR5VmQ0RWtRYktnVUtjTXo4V0Zx?=
 =?utf-8?B?THlUd01sZWZkb2FDRFpyRmtac0dERnV1Y0xnUnFNdS9zU0JWdnpZT0swUGdm?=
 =?utf-8?B?bXRhYXpOUDRzV0tPODJMdlpkNG90UXFYanVkVkNSdTBCcktaOTk3M1RIcHR0?=
 =?utf-8?B?a0J1a0M4RDhEWHgxVG5vZVRXck9WaXI4TUw0c2NTMUtIaU0vT1JZQm9ZM2FV?=
 =?utf-8?B?TFgvUUxHSWpQem1kNld5WE1nQ1FWVWVMTUk0RCthNEFwSjg0TTMrRjRIZEhU?=
 =?utf-8?B?M1FWZmpVV2tPam1LTlZqc2h2QjNHOU9hWWg4ZXh0NU1GM0tyRGo4OHZEOUpJ?=
 =?utf-8?B?WWRMZkl1djYyNlhOcWIraUdoUVgvMXI2WjE3TFhUY0RZMGNwMzQzbHlrYTNq?=
 =?utf-8?B?ZExhS2V3QndGYVpySTlxVG5QdGMvSnJUN2lVMVliTEpjcTJEa2VsL01zNTlW?=
 =?utf-8?B?cThTa2dFbkg1ZkIyYUNmQytVZStxTXFCQkMxTDN0Z0xsRmgxcHdIYW9DaFZz?=
 =?utf-8?B?THVZeW03a1hpWkFlTUFxcmlBRmMvRGs2RE9sOGtvS0VFT1BNZ2lpNHdDb0Nv?=
 =?utf-8?B?VzVMUzAvSjBucnhkNUhjV2VzQnR6clpkWXpaREdsc1p6WU1DRCtacFUzVWRj?=
 =?utf-8?B?VThVbnZ3WUFyR2pCa3BWUSsvckdZK2ZYV3F0QitMenRKdUI4N2RVb3VDWk9K?=
 =?utf-8?B?MnhJVFJRRENQUFFaVmhSQmdSODRPWUEwV1EwdStqeG5RZU9XVXpOaFlrb2NZ?=
 =?utf-8?B?aGlOaHl1MFI1anJqd1I5bzFKY2U5R1lrQ3BhbkQxYUJYZWNuc2Z6L1ROcFVm?=
 =?utf-8?B?eExBWEk2RitkRzJ4UUVZOHFNWnloTnhVS1RrQXhjZHRZei9ZWFE1K0FuOFhm?=
 =?utf-8?B?aW9tTk11U0VTcTJrZGI5b29WZCt6eS9wVm01bzY3SXBGZi9uV3ViZXRFK0R6?=
 =?utf-8?B?ZGZ2ZmJMalZiWWNka2NJTkNUcVdObW4ycndvUVUyc2tZMEg5Y3NiRlFUdVlJ?=
 =?utf-8?B?Mmt2MzgyTE9lbkI0eEtyNi8ra0dBWDFEUXZLZEZTdU9DYTFWUlo1Z1lWRkxx?=
 =?utf-8?B?b2txNlVIQ2VIdUdZTDltNDZJeUN2ZlI0QmkrRDZwcVc3RWZOR1pHSk9xZERB?=
 =?utf-8?B?YkRrT21aakpvUGhCY0lYTlRLOFRTd2tMYVlDUVQxMU1ESkdERXJWd3NuaEdk?=
 =?utf-8?B?MytsU2RPb0Rkb1dQZzZEYkNGY1VJcnV4VmhDK212L2l0R0p5Uk4wOHk1TzlX?=
 =?utf-8?B?WnJMUEVKN3o5VVRSR0pQdE94bnJQTUNObmR1OTZFVHhuc3VDaHVWRzVITFly?=
 =?utf-8?B?QWdSY0QyV2tRWDdzbGsvaUVjOGpkNVVTOU54U0RhcnhCRm1KS0dUc1F4SWZS?=
 =?utf-8?B?V0hnem1RZ0ExUXFZZ0tGUlpzK2RycE5QODBuWnFuMk10allMVm5yeVYzeUFV?=
 =?utf-8?Q?OC2s7WuNdbVUyl3CO3GxphgyWZLcwpl8bj93bzn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae71990-c9ab-471a-cd29-08d97690e00c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:25.7018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3QsZLkLkqe9YB4nyzcciD6I3f+8fQlHSJfmDzSw/Ylr8wPPlX4Dqqrk1jbGQwM/REl69zM4rgcZaGYhMEVCnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
ICdjaGFubmVsJyBhcmd1bWVudCBvZiBoaWZfam9pbigpIHNob3VsZCBuZXZlciBiZSBOVUxMLiBo
aWZfam9pbigpCmRvZXMgbm90IGhhdmUgdGhlIHJlc3BvbnNpYmlsaXR5IHRvIHJlY292ZXIgYnVn
IG9mIGNhbGxlci4gQSBjYWxsIHRvCldBUk4oKSBhdCB0aGUgYmVnaW5uaW5nIG9mIHRoZSBmdW5j
dGlvbiByZW1pbmRzIHRoaXMgY29uc3RyYWludCB0byB0aGUKZGV2ZWxvcGVyLgoKSW4gY3VycmVu
dCBjb2RlLCBpZiB0aGUgYXJndW1lbnQgY2hhbm5lbCBpcyBOVUxMLCBtZW1vcnkgbGVha3MuIFRo
ZSBuZXcKY29kZSBqdXN0IGVtaXQgYSB3YXJuaW5nIGFuZCBkb2VzIG5vdCBnaXZlIHRoZSBpbGx1
c2lvbiB0aGF0IGl0IGlzCnN1cHBvcnRlZCAoYW5kIGluZGVlZCBhIE9vcHMgd2lsbCBwcm9iYWJs
eSByYWlzZSBhIGZldyBsaW5lcyBiZWxvdykuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguYyB8IDMgKy0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXggMTRiN2UwNDc5MTZlLi42ZmZiYWUzMjAy
OGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYwpAQCAtMjk5LDEwICsyOTksOSBAQCBpbnQgaGlmX2pvaW4o
c3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNv
bmYsCiAKIAlXQVJOX09OKCFjb25mLT5iZWFjb25faW50KTsKIAlXQVJOX09OKCFjb25mLT5iYXNp
Y19yYXRlcyk7CisJV0FSTl9PTighY2hhbm5lbCk7CiAJV0FSTl9PTihzaXplb2YoYm9keS0+c3Np
ZCkgPCBzc2lkbGVuKTsKIAlXQVJOKCFjb25mLT5pYnNzX2pvaW5lZCAmJiAhc3NpZGxlbiwgImpv
aW5pbmcgYW4gdW5rbm93biBCU1MiKTsKLQlpZiAoV0FSTl9PTighY2hhbm5lbCkpCi0JCXJldHVy
biAtRUlOVkFMOwogCWlmICghaGlmKQogCQlyZXR1cm4gLUVOT01FTTsKIAlib2R5LT5pbmZyYXN0
cnVjdHVyZV9ic3NfbW9kZSA9ICFjb25mLT5pYnNzX2pvaW5lZDsKLS0gCjIuMzMuMAoK
