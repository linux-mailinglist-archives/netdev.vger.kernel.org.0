Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28751CF892
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbgELPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:49 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:30085
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730810AbgELPFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfPrq+eyU8R3NwI0g9r+qXB1z9ks087Moh7kZJZgoyChlHj4102ofG0s5QQxB6SE0+EkANgmO6BfvwI8yu39GJkHszMWQzYJ/xvlorMf1ZjpU4vq06/KzQXQn92f+Anr7igjTEVidMIraBIRemxoNqnheS4VpRTRvwVjjp8meNUdkAE4h9U4/ooK37zOgHErAWSHtN+3dAd7JZ7ppsxnfUBijvX+qzyn/oKcqD06OG48U4nKd7tjpuKNLxzPWnJHvpSVtDSnG9pG+TcvEkwn004iovQG56cnHUsbPVRTPCgvPr3Jw7JBoJ4MHLlY20Jg32XShQe+o80NnSzURxz4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvk01yBSZvjjbUeqrdSRgg3+2379A0GJFL5pDAE7ps8=;
 b=lZ9zgKS/sRUJEb1sUwWonV1NosmUYepX1uU6GQk+qaj12esTI4PqU7CFb+hTgU56FLe7JR2HuCwcWhRZmZ6hsZbFeTVBGd44HdBxqYGIhTlAu7E4YudWCcuE2jYrJL+PGOqFWAGHIItZLmSY6cXl9DMhxpYBcqJPzcM6ZrfZl3SMsJzjGjs47xE51salxygpD9uiXTJqzyiT0vO45v0QhlSG8a5hIpC3PH9loSN/ltLZpJ5Yx4nWq1OU/Q/m0PIGAX8VnQGv2DcTbJjPNeY14a+LTt9Kb66xkZ/Iefk/u3SsVcxiu1xu9W/N7SijByGL+6lRoZmjov622FKvXZaVxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvk01yBSZvjjbUeqrdSRgg3+2379A0GJFL5pDAE7ps8=;
 b=OXSel2DH6OA2MSSwXgLOZWasiFJ3p4b2NcP+K7p9eiQpUten9He6sEE0o0pEArU9FyPtG8oITusrUwDq/UbfYsY3qh5i1wZFfyxbIXFq4FszVvuxyejLSeYky8fIfJtJRnb+2T+xmzwQHNZJ20o90nKmxjYDwr8nqDGkGzn+LvE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:05:03 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:05:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 16/17] staging: wfx: fix endianness of the field 'channel_number'
Date:   Tue, 12 May 2020 17:04:13 +0200
Message-Id: <20200512150414.267198-17-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:05:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32b6b1da-8318-4daf-3e06-08d7f685d853
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17417510719D6E913270CD4B93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmEXj89pX0n9IlkNThvMbcaEASELwm2qDy6wRpcHclC93Eg0q/7slIt7OrlGidMQ1XZSrcyCKTYxs8BVnQSKlt/WPi9rdiFaATY3MXNhNd+McjtU8dIOwW2WKajQ/+lbOIf0E11zSHcYXOaUmPTCVX0MCbxMYEpm/d4GU2j8h4Mc95EP8a6dhxKZ3cOP8xmYhEOSD3nPGo2IPAxVYhLVgnAqOcUj4ljlxah1qMGxG2LUZnyYxjTnPr9WiXtyPhWUBT4/fGBpQt8XL2M4+Mp9D+FBV0fR0O6n+Nb8Ke00qpYIDOjn1kYfFSQMLnGEhZHNqUo+iRcwNjwMGzoamuuAa/RuxUxCH2eW/AE9Bi2p4NJTQFZo07LSOw0nQOUrrVeT1prDc9y0ISpQxcQBIGiakghpRDbRcQRz9oFGQuzRGiCW+hvljrgNHJFXfnhF4k5Tz2Lbo7pD00eTwOkmS/RLhZkSwUgXbAf5RL4R3ILu98rNg5d20oHboWzDmTaUoIYDyddzT1UHGyGjiSEoo0oq3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: h7Q7Q8a1sbzT+RGaIDJpFtl8GFD2KAg9xKDIOlHByWEcktPFuCA+z8+Ab2gXutpcLAAhNCoMHEhw4Gm0HPlgTbOlzvxIywWfwhoOVP8libpy7XE/99ni4Y4mf0ehG1xcSH17eENqEWEGcvb0QlRHhjkE9wRdRg7TYWETLICjNq9pcZM8WkZSLZ4p3qtB8EifxhiDCeAppUvr29NQujn+jLGYkcCh1GYWcUrzNO94utNGHzp+Tvnwy/qW2cr6YlXZNnP0LQs0cyyF5I1gVRKSrb1kTZHeAzW16ujI+JORyT4v6g4Up6LwzOrnRIrjAhPk6CgkfDNr2e0IM8j3dpI3s1C6RWgulbWNyLLlll5bD04AXh5nC2inx0uJZeAg1Iyn6DuESSszSmqfNCiryv6ZOwLYnd5xAMJ6DDdApgjsOMlGWyC/1w/v0tGGpT2h5NY0+NABZIa2trc2WPccV/eCzvvVqQmYOmOUtU+tzb1cke8=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b6b1da-8318-4daf-3e06-08d7f685d853
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:05:01.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6B7DrXQSeR1pV7ca6Jl1roBs//5+P2kJQfoQMcPWOoGN7h6Fib7g5JeI48H07U8IRYne5mSkKJ50AEcvw0PCxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICdjaGFubmVsX251bWJlcicgZnJvbSB0aGUgc3RydWN0cyBoaWZfaW5kX3J4IGFuZCBo
aWZfcmVxX3N0YXJ0CmlzIGEgX19sZTMyLiBTcGFyc2UgY29tcGxhaW5zIHRoaXMgZmllbGQgaXMg
bm90IGFsd2F5cyBjb3JyZWN0bHkKYWNjZXNzZWQ6CgogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3J4LmM6OTU6NTU6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFyZ3VtZW50IDEgKGRp
ZmZlcmVudCBiYXNlIHR5cGVzKQogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmM6OTU6
NTU6ICAgIGV4cGVjdGVkIGludCBjaGFuCiAgICBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcngu
Yzo5NTo1NTogICAgZ290IHJlc3RyaWN0ZWQgX19sZTE2IGNvbnN0IFt1c2VydHlwZV0gY2hhbm5l
bF9udW1iZXIKCkhvd2V2ZXIsIHRoZSB2YWx1ZSBvZiBjaGFubmVsX251bWJlciBjYW5ub3QgYmUg
Z3JlYXRlciB0aGFuIDE0ICh0aGlzCmRldmljZSBvbmx5IHN1cHBvcnQgMi40R2h6IGJhbmQpLiBT
bywgd2Ugb25seSBoYXZlIHRvIGFjY2VzcyB0byB0aGUKbGVhc3Qgc2lnbmlmaWNhbnQgYnl0ZS4g
SXQgaXMgZmluYWxseSBlYXNpZXIgdG8gZGVjbGFyZSBpdCBhcyBhbiBhcnJheQpvZiBieXRlcyBh
bmQgb25seSBhY2Nlc3MgdG8gdGhlIGZpcnN0IG9uZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9hcGlfY21kLmggfCAxNSArKysrKysrKystLS0tLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgICAgICB8ICA0ICsrLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXgg
OGM0ODQ3N2U4Nzk3Li4yMWNkZTE5Y2ZmNzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgK
QEAgLTMyMSw3ICszMjEsOCBAQCBzdHJ1Y3QgaGlmX3J4X2ZsYWdzIHsKIAogc3RydWN0IGhpZl9p
bmRfcnggewogCV9fbGUzMiBzdGF0dXM7Ci0JX19sZTE2IGNoYW5uZWxfbnVtYmVyOworCXU4ICAg
ICBjaGFubmVsX251bWJlcjsKKwl1OCAgICAgcmVzZXJ2ZWQ7CiAJdTggICAgIHJ4ZWRfcmF0ZTsK
IAl1OCAgICAgcmNwaV9yc3NpOwogCXN0cnVjdCBoaWZfcnhfZmxhZ3MgcnhfZmxhZ3M7CkBAIC0z
NTYsNyArMzU3LDggQEAgc3RydWN0IGhpZl9yZXFfam9pbiB7CiAJdTggICAgIGluZnJhc3RydWN0
dXJlX2Jzc19tb2RlOjE7CiAJdTggICAgIHJlc2VydmVkMTo3OwogCXU4ICAgICBiYW5kOwotCV9f
bGUxNiBjaGFubmVsX251bWJlcjsKKwl1OCAgICAgY2hhbm5lbF9udW1iZXI7CisJdTggICAgIHJl
c2VydmVkOwogCXU4ICAgICBic3NpZFtFVEhfQUxFTl07CiAJX19sZTE2IGF0aW1fd2luZG93Owog
CXU4ICAgICBzaG9ydF9wcmVhbWJsZToxOwpAQCAtNDIxLDEzICs0MjMsMTQgQEAgc3RydWN0IGhp
Zl9pbmRfc2V0X3BtX21vZGVfY21wbCB7CiBzdHJ1Y3QgaGlmX3JlcV9zdGFydCB7CiAJdTggICAg
IG1vZGU7CiAJdTggICAgIGJhbmQ7Ci0JX19sZTE2IGNoYW5uZWxfbnVtYmVyOwotCV9fbGUzMiBy
ZXNlcnZlZDE7CisJdTggICAgIGNoYW5uZWxfbnVtYmVyOworCXU4ICAgICByZXNlcnZlZDE7CisJ
X19sZTMyIHJlc2VydmVkMjsKIAlfX2xlMzIgYmVhY29uX2ludGVydmFsOwogCXU4ICAgICBkdGlt
X3BlcmlvZDsKIAl1OCAgICAgc2hvcnRfcHJlYW1ibGU6MTsKLQl1OCAgICAgcmVzZXJ2ZWQyOjc7
Ci0JdTggICAgIHJlc2VydmVkMzsKKwl1OCAgICAgcmVzZXJ2ZWQzOjc7CisJdTggICAgIHJlc2Vy
dmVkNDsKIAl1OCAgICAgc3NpZF9sZW5ndGg7CiAJdTggICAgIHNzaWRbSElGX0FQSV9TU0lEX1NJ
WkVdOwogCV9fbGUzMiBiYXNpY19yYXRlX3NldDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IGJiNzc2
ZWU2Njg5Yy4uN2Y0NTk3MTllN2I0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTMwOSw3ICszMDks
NyBAQCBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVl
ODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJCWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKIAllbHNl
CiAJCWJvZHktPnByb2JlX2Zvcl9qb2luID0gMTsKLQlib2R5LT5jaGFubmVsX251bWJlciA9IGNw
dV90b19sZTE2KGNoYW5uZWwtPmh3X3ZhbHVlKTsKKwlib2R5LT5jaGFubmVsX251bWJlciA9IGNo
YW5uZWwtPmh3X3ZhbHVlOwogCWJvZHktPmJlYWNvbl9pbnRlcnZhbCA9IGNwdV90b19sZTMyKGNv
bmYtPmJlYWNvbl9pbnQpOwogCWJvZHktPmJhc2ljX3JhdGVfc2V0ID0KIAkJY3B1X3RvX2xlMzIo
d2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBjb25mLT5iYXNpY19yYXRlcykpOwpAQCAt
NDM1LDcgKzQzNSw3IEBAIGludCBoaWZfc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0
IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJV0FSTl9PTighY29uZi0+YmVhY29u
X2ludCk7CiAJYm9keS0+ZHRpbV9wZXJpb2QgPSBjb25mLT5kdGltX3BlcmlvZDsKIAlib2R5LT5z
aG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZTsKLQlib2R5LT5jaGFubmVs
X251bWJlciA9IGNwdV90b19sZTE2KGNoYW5uZWwtPmh3X3ZhbHVlKTsKKwlib2R5LT5jaGFubmVs
X251bWJlciA9IGNoYW5uZWwtPmh3X3ZhbHVlOwogCWJvZHktPmJlYWNvbl9pbnRlcnZhbCA9IGNw
dV90b19sZTMyKGNvbmYtPmJlYWNvbl9pbnQpOwogCWJvZHktPmJhc2ljX3JhdGVfc2V0ID0KIAkJ
Y3B1X3RvX2xlMzIod2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBjb25mLT5iYXNpY19y
YXRlcykpOwotLSAKMi4yNi4yCgo=
