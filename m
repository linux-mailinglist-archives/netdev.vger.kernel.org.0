Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF331CF862
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgELPE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:57 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgELPEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLXZVWAgIXLIdYRRDDSUMKIhVAWX+zRn50sqmTf9SdEQ2I23ncEGf1+XbPU+G5jWEy1XZz7IoHeeVRfa2sQSre2FYwsDAvleI4Cg+PnxuS9bKthTZ9qNLjfWsoTr6y6rRbEn7dtvlq8iODxJg6GlFtfwXElqwZLX3Tta+48NSgQHaGG4WauldnCROHVKchAUdimvdCjfe094Pr0MhmD7oOwlO9L6CxW/lcODqGG94ivi0tRR/cEDS43/kAxtEwqewv1Po4ZM9g81G/3pk9gNBagVaAcszNzkmnJe36qPI8el4VCHt369oJNlGGhEysCHFve0jXUjijstHpoA1mM56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5n0cjqebCL4J+gINvDozGWmeH0y5pJkM7iroi6BcrY=;
 b=IhlCiF1XE9V+4Nm4TchjKd7aHlGrsZDyCHe00h5/zy2nDFIzbtJL8QW+Wfhb6+9ZW/lakL5WMbjk6QybwtBvh3jUaCWWI9Hu+V0EtBBWITcVAqjV7SZaJTwBx+TYVV5wQWCGzelS5xtK3D6UU+r/TzaLdhRQ9ZdytV9ne8l6RG1JRTpriEfiAZDdh1RYWrG5Q16hH10eLCP9sCZctEpQHlbEtLfVbJsjosgJP6pTb6GbFk91tjEDSFXuY5t8bM9jSV06GP0IRGjtKbseTeBz6ggMaIqpR9RGHFTxUtsmKvdwPZelUoX5E2LU5Y2VOF0moWKLBCTgNoACZVLhNqy1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5n0cjqebCL4J+gINvDozGWmeH0y5pJkM7iroi6BcrY=;
 b=k1IHDT2UPNe7u19ZRU1iqFM7Wk0by92nSWOkZLCRVKQIEhe9K2fsb8dcjiMP1LTCJaTfB2qaMzHAEJkhmBxlkYFAYR8FFYas1Y4skF8df1wX2CTXOemDrpy58zaix6GACisX5bPGhVxpgESpcS68pwQMqs+nnHRBu2bBlJXzayA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:43 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:43 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 07/17] staging: wfx: fix endianness of hif_req_read_mib fields
Date:   Tue, 12 May 2020 17:04:04 +0200
Message-Id: <20200512150414.267198-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d3471dd-e5cb-423a-9340-08d7f685cd90
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17413CFEFA05A15E249635FE93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:163;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 23JM8cFZsATlTyH0a7gl9NTvH+KmJBWJ3LEBlcrhBKnLarEDmLfuJ4XrwOZ3UdD8dHF1xz5wGjng68YMfl1CuCwEG4cpekMFb2A4QfwU7zO9yhG7Pr0jELmwB1cEa3pTT9P/MwVuWo10rkL5+lEFmsJzwom6EOYOJMBSIFJ1ktqWUEDlzHlMZjPt7egWdzE65rrBkXHpttryoWkQIhXANu81JGSdKiwBL+VZXZ//vzDVbJK72+V92ECGKdECL/FcYaj/bPvQuqXL5upHtfNCSY61FUD4HZTxzJ06qwWQD8XQWtN86YLWNcUuZjIdQpjimc9PQwQJHLBHkMG38fqGuq7Nx+Uw8WeL0oslDh6vjVbdt36djjHOX8O9iPnz+MQmBJrelGhb0c6DkoNoQWDlYblIoRW8JlWxUdP8fH9RElg/PUtRORXYUmpyD3ySlc/oImW8WGZVopSbPXKtprkq0XmLn2LBrdWFf5+9brS6VV3cLx4vQ6EMdJR3WHXNBq5SJrXt9mz7NaXr6C0890O2DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LxoeSfxujjD3IgI2MFuj3skBJMDta5MIIBDKXLOFMfV4qzNx9fICtCwoKL6jl/OmWaMirj+CxQW3ZgzLeiAtLMOTQhy/dOxdu01Fc4TOqVvHsv21f5n2cNZcBDg0PIfJHOi/8SycdxboJJZIW9WkErECt/RBYNGc3OZ3gbocWkPeHvC1zNjC607XCtCvt+Ozmc6Y18dHaan+r7qYfiGjUU6H1FUw7cQ+Xfr356/Nc9s9fdExw9dRe3p178VNmjZqaCyr3P+YDeRwm1oGGn2R5JyABF/ynnGsiAVC7VkLFKIeBqcL2W4ESDxIbrn2B3RZnLAgMSrKdGndsCODAkKmU1eMP2XkRIh/CLDZr4naKISOagIitzm70VgqhVEPFAVRgP3+6MeeHausgtV0yCfA0djToO5+5tS/2m1q9OLy1bP1K+sThAwoFK06dxk2cDXD6wBlVMkqUTCqeKGZ4RT5Wwl0qFLLglSVH7ETl8kNIR0=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3471dd-e5cb-423a-9340-08d7f685cd90
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:43.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5a1w6Mo3T/XtcexDj+oY6OlZ0sNwU8iu5yVcNcylgof7gsefr20cln+eYFwgsstWscL58FCTzE2sm3MLkG0qlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
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
