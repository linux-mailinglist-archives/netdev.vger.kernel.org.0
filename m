Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0B1CDF77
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgEKPuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:07 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730563AbgEKPuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFJh27cAKHZHiuwywCap2fJw7IwwNo1Y1Dsix5bPh+cs+b3w6EPlINUBcraRqv9KoEvIditJ7i/5fVGnJII5VZwrD/fjIfRWpvIp+rN6qQFqE46r6bja9iJEiFeFNm0yi064dqqUjtGviZRG8c/9m6aOEy7+2vfUmLCDqJELEmGCLNngXHnstt7oZC51HZNC3tJUiw3B7Xc8WLMyk2uBnYAWCG7p8pp/gP7cdETle2eMBR2/f8dNkHbb0WPeqdPaadiwJP8FD2gorNH2SwnvkaPTOUeuLpjYQ7md5Tnbn/ybKbiAorT9Sr/5MkNHDMaSG427WvWG/AxOy5UDFEQwQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5n0cjqebCL4J+gINvDozGWmeH0y5pJkM7iroi6BcrY=;
 b=CDKttffmkY7chrbSBq3DltTExCo/R/yA8qRkUqL6cwiqzHztxLn5oUAu5JmV4AJnrA4XcINB4L0LplPSeAWJOAN8YE7Zj3hxYfF2X6zP5JK1UYNpdmzj1E1f2KRyyZGEu96FAt74h+qhIbZmHediHjVrVdRfUUvP9CspDLMFdzGE2zrpdI9Sl0rpDrhLKD6uXqNxhTyeLeb4E8oMUIpN4BBiyc1IPqRBbUF/IwegrnJRds1O+l1JGcPeydVC/Q3MOUx3dVxovAhX5h5axWutCPaBfyFknMRewY8bEQi2kq4qE4CLvCWofBJc2pxojmrHs1gwzcnm/mgAVMf57ZDPAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5n0cjqebCL4J+gINvDozGWmeH0y5pJkM7iroi6BcrY=;
 b=gdufEXDGCmIKb1I/sXEXJnjMMEhK50z2E6V1HNlJPFsFTFTFGKnuK/F5DEelebGvr+T5/DFwdcHRetp/VjlgzbNZNMgrk07hPTmHuR9gvaVU5LtEfYw3pGfPv52UZNv4bkhrdfDj0xxicXqyAihl8lVY3H+ygjjJV8K+0MjE3G4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:49:59 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:49:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/17] staging: wfx: fix endianness of hif_req_read_mib fields
Date:   Mon, 11 May 2020 17:49:20 +0200
Message-Id: <20200511154930.190212-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:49:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e703613-7df4-4c51-b5bc-08d7f5c2f5c0
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1968F5F7B509FA951A275F4793A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:163;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I86yrXcvOI6UWTAuDFFcdXP3lGdvgs/LeG6Xt7J4d07xhK1+gZg1/TB8o3m8yVYOMzmHSbQyt9tT2Bct/Rqenk3gqM0uLr6shZD+Mdn9TJtP/R1/imhS1JFgy5izzULp3AUwPcYfyw0r3129BtvqN0pgbIAp1+6RjIiNjTg3QGZSayGoqRZB7ontoHOguYF4PSj+tnzAH/jXDJsQCg4+WFKs5A6gVOyvQRuJLZerZti4fD9UJmBZdtrSRl6ym88AwBUI+oMG1wVjhQJYr6sOzGedsyuAQFGkC2iHnzXHJzNLEpIg55Cj+0Q107DQwkFWTJLB7zqh1Sn/QMuSxjvoVhHJRFD0jVb+gHkx3fhfCO5p8w5lj8U7un10CZW87EOJ8Pi5N4z5iFmAxmO3oUYh8hdkkmZ627EOO3i/CZL/ZGLj9fCoxDQvaOY5ohZLGCieiEV9GxOa1BmELNFdVnpJZvYpbKC9ElZ4zE8urZmd3mC3sgmECBeuyrPQ0B69Wp0niL51uDTr33M5ZJMANc/Qlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /LkFsSB071M+5tohCfR2PMypGS06CAbq84axijkH1NLl/URkKEAHvHCHLoy3BlX86T999MXvUvu1o68dUfGoOi2Ip4PCyKelOuRryyHLkCBWF3GwxIOqAYUWIJLNMONJ3ZAtGM7P+MdGjrnOqHfO5rUdfu/wFQ+Kf0Gmjo68/zN/iEJYFfKzRFGejghWRudnPU2y+WoBqL/cwN/soIY+oJcxuzC1Akls1unSxkexrNMXED3Ewhao/9I/d5OtyNmHx3x5OTutb8MW6NtsjwcazQDkkZLr2qFWXyCCBfOm1ncwmMFS801O/mn3x1h8gOIlX94C7Jnr2WCHJuXRSiib1IEupeGR5iEG2c32X+I39EL56QRWEtDAZebrpjcCyxJKV06lUx81rNI4K0tq1h0RtKGObUeON/t7pcSdzTDJjPZnSOhuNf/t3qdV/RfD4mnTCB49GF/pjRGrVAZswSzZcJpFTNc9b8j9KZGRBA0xDJU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e703613-7df4-4c51-b5bc-08d7f5c2f5c0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:49:59.5000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWC3QhMVS0nPeV7Uaeqq7RYO+MBT4k00FuEMhUuvYAH8/yRDdA5m4NTcucssSwFsWiZNiSnqtcnMvDS8AXw8LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHMgaGlmX3tyZXEsY25mfV9yZWFkX21pYiBjb250YWluIG9ubHkgbGl0dGxlIGVuZGlh
biB2YWx1ZXMuClRodXMsIGl0IGlzIG5lY2Vzc2FyeSB0byBmaXggYnl0ZSBvcmRlcmluZyBiZWZv
cmUgdG8gdXNlIHRoZW0uCkVzcGVjaWFsbHksIHNwYXJzZSBkZXRlY3RlZCB3cm9uZyBhY2Nlc3Nl
cyB0byBmaWVsZHMgbWliX2lkIGFuZCBsZW5ndGguCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguYyB8IDEwICsrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXggNTgwMTNjMDE5MTky
Li40OTBhOWRlNTRmYWYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwpAQCAtMTg5LDE3ICsxODksMTcgQEAg
aW50IGhpZl9yZWFkX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwgdTE2IG1p
Yl9pZCwKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB2aWZfaWQsIEhJRl9SRVFfSURfUkVBRF9NSUIs
IHNpemVvZigqYm9keSkpOwogCXJldCA9IHdmeF9jbWRfc2VuZCh3ZGV2LCBoaWYsIHJlcGx5LCBi
dWZfbGVuLCBmYWxzZSk7CiAKLQlpZiAoIXJldCAmJiBtaWJfaWQgIT0gcmVwbHktPm1pYl9pZCkg
eworCWlmICghcmV0ICYmIG1pYl9pZCAhPSBsZTE2X3RvX2NwdShyZXBseS0+bWliX2lkKSkgewog
CQlkZXZfd2Fybih3ZGV2LT5kZXYsCiAJCQkgIiVzOiBjb25maXJtYXRpb24gbWlzbWF0Y2ggcmVx
dWVzdFxuIiwgX19mdW5jX18pOwogCQlyZXQgPSAtRUlPOwogCX0KIAlpZiAocmV0ID09IC1FTk9N
RU0pCi0JCWRldl9lcnIod2Rldi0+ZGV2LAotCQkJImJ1ZmZlciBpcyB0b28gc21hbGwgdG8gcmVj
ZWl2ZSAlcyAoJXp1IDwgJWQpXG4iLAotCQkJZ2V0X21pYl9uYW1lKG1pYl9pZCksIHZhbF9sZW4s
IHJlcGx5LT5sZW5ndGgpOworCQlkZXZfZXJyKHdkZXYtPmRldiwgImJ1ZmZlciBpcyB0b28gc21h
bGwgdG8gcmVjZWl2ZSAlcyAoJXp1IDwgJWQpXG4iLAorCQkJZ2V0X21pYl9uYW1lKG1pYl9pZCks
IHZhbF9sZW4sCisJCQlsZTE2X3RvX2NwdShyZXBseS0+bGVuZ3RoKSk7CiAJaWYgKCFyZXQpCi0J
CW1lbWNweSh2YWwsICZyZXBseS0+bWliX2RhdGEsIHJlcGx5LT5sZW5ndGgpOworCQltZW1jcHko
dmFsLCAmcmVwbHktPm1pYl9kYXRhLCBsZTE2X3RvX2NwdShyZXBseS0+bGVuZ3RoKSk7CiAJZWxz
ZQogCQltZW1zZXQodmFsLCAweEZGLCB2YWxfbGVuKTsKIAlrZnJlZShoaWYpOwotLSAKMi4yNi4y
Cgo=
