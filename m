Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4781CDF99
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgEKPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:34 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:17760
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730648AbgEKPub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqb4b0a2psl1D3aT7R2hHB6AVCUOfdTqjqoMT4e9TXcwkQsGD2rv2oa5A0SyAr6t6w+PYzfakdWLFVdqc5up5GGjYkN6mG2M9FnosmtX82j/UDmzotY+29JJXuQPvsq9z3IkK2abqx16WgdPrfZRfYmaYQsjaXi+GBoD9FjyvgeneZqCP73J2r9gej60TSUJPIfFSSUBl3KrGMoNvBVq/oSRFE1lXRvcZE6wNyXb2PVbn/5hSKi+95QKIt6vPhnCJH3J0vEtuIUgWPuD4/m0SLeMKYVyNmc1IhrsD64Nkj8OFqZ7INlQc9RGlqz90mgPFC7CL50CquU5imcur9tjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4srQK29dX43wzsCF0du08S6OvPn/4KroWPMEV0cAqI=;
 b=GlbTfVoiRCL6U4m+ZeyoXYfgPDzMEg7vQ7MnfVxoRJcOL024vkBiyPHo7R4qdDIF49IUtCFZlCyBT+WufdRWMpCSX8/YRRNjZK+68JAk+58DnsasUmn4pwJEXfvTReR6dA6zZ8sjDSpp30AQbyqbkXodFRzUlKTkDymQiNHRqikdaO2SvUBSFCnmskj83pSlYUO5aJn9v1VgkZK/L+azFNTubJ2H6ONYWBabGN3dzuku5+3wu0tUj/khwjW7P1fXRKoZQGI0wNJxQXQeI6/1c/B222gfnjKVX7BnJOJE7yGy/k5XdeYEsNHpVIX/oPD+ljgmqGQzjzcvaBhdD+j8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4srQK29dX43wzsCF0du08S6OvPn/4KroWPMEV0cAqI=;
 b=gt4rOxA3MnZWw82fybematDgF6P0Q74dZfhELfg4yigmwRFdnFHWdCPQt/2/glOhjzOqSVBOs236s4bqQi5YInAhOV4tXIWFfC/zqwh19t+5ccW9LLoqkRZZf0AgXHTOG+FkzJM5WLByRYg8vHndjTgi3LhFXRfbbZhHmxAT0fs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:16 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/17] staging: wfx: fix endianness of the field 'num_tx_confs'
Date:   Mon, 11 May 2020 17:49:28 +0200
Message-Id: <20200511154930.190212-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e219ba86-6697-47bd-7b1b-08d7f5c2fffb
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19680D7DACFE7C64FD5CE65993A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFQr4vMjnFVJC1itz3HKfhIMZUR6jjmk8j38Cssw0umAMN/df6IgNXnQ/XDQ7e8B9si6YBSMXu8zGTGRyfHUtUe4YsvF0/Q5R19PhfnB4S2CEuKPxzLjBHZYr8odFxyzkF20fyYR5DhOTbwCVkaz+ZEu3seuly2tY8QeZou4qTljQJPNyen7SdnTeh0QReLTXUtcErqC3z5BpBPbQf9OhHUxfPPIu6/K8NzPRO5M3qGeZIiwEsCj8nw9v5hnh9hU3MkRDp98z+ng97d5sfrwXLSvmKQe2NZ6zoGIHxD3WH2ZHLF9QvHPUJ92M/AqnE6wTbXCwtqoOqbTCMkajxYIRYdoKy9SVsLA9VDALVmAQmSWhdqSd7OBiufzB11nRQ2WGnTP6jIaqB6JQ4XjxGhdyut6+H+zZ75t9/ipeNwQqyBscl4YhtuLXa+EdguLIHgt86aQy22U7+lpXpaMrGPLPNkuAogWNhNU/T9wwFysM5ckOZbWPBWAW+PBPUDuvPe6csNvaqBSh7u4O54+a4WUsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x6If8Oe++0PsdYNBs4DROztM9P5o/Al3ZDC4yF+/av2UrbfNyhnmwke5YOsY25UqG9FOQHK14sD+GXSfyWMe9DplUhQ+lJJUHUBNmWIBvbJC5YpnkHbLv9wckrxt0E1CZg4QHdL4EaoFjFqHCeZc1EAis6YbmP1vcGjvsUwn9SPXI4Vly8DyOBYprwUj+a4OUQ1TjaP56FqFnghWf5lDNA7DKv6Et86esPuMeRa/wgu5lJqQGUn/2wd/c09Q6oDGtuIfZ4QCBoE/7WLNJgk1Gsw8BUCzPlun2BTN9C8GnDJJMJ0JOQd4FQikx94JeGn43sJZrUmcCVN9UsIvyGQmVkKq54exwWkDnYVl/I4oOj4yrtpjnv5Z9jy587Khxkz7jdRyb8ZgSSbgi7S7/Mu9+YpYooLdx4ss/7QZ9w0EBbXX34Klf8EDHRry9gNSt25If4ZjgdrBdIbGw0+gfhM7YsJcl5qjKK7oZT1J+d1yB+0=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e219ba86-6697-47bd-7b1b-08d7f5c2fffb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:16.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 529S+q03yB8wAxt7H8Wrz+TAOls2GKpyBGZgrXG9U5CLmwXTzNmNTuF/OOWQgnnJPSFr5qNSd8gdyxzLSLQbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICdudW1fdHhfY29uZnMnIGZyb20gdGhlIHN0cnVjdCBoaWZfY25mX211bHRpX3RyYW5z
bWl0IGlzIGEKX19sZTMyLiBTcGFyc2UgY29tcGxhaW5zIHRoaXMgZmllbGQgaXMgbm90IGFsd2F5
cyBjb3JyZWN0bHkgYWNjZXNzZWQ6CgogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYzo4
Mjo5OiB3YXJuaW5nOiByZXN0cmljdGVkIF9fbGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyCiAgICBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jOjg3OjI5OiB3YXJuaW5nOiByZXN0cmljdGVkIF9f
bGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyCgpIb3dldmVyLCB0aGUgdmFsdWUgb2YgbnVtX3R4X2Nv
bmZzIGNhbm5vdCBiZSBncmVhdGVyIHRoYW4gMTUuIFNvLCB3ZQpvbmx5IGhhdmUgdG8gYWNjZXNz
IHRvIHRoZSBsZWFzdCBzaWduaWZpY2FudCBieXRlLiBJdCBpcyBmaW5hbGx5IGVhc2llcgp0byBk
ZWNsYXJlIGl0IGFzIGFuIGFycmF5IG9mIGJ5dGVzIGFuZCBvbmx5IGFjY2VzcyB0byB0aGUgZmly
c3Qgb25lLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgICAgICB8IDIg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCB8IDMgKystCiAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKaW5kZXggMDM1
NWIxYTFjNGJiLi41NzRiMWY1NTNhZjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
YmguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTEwMyw3ICsxMDMsNyBAQCBz
dGF0aWMgaW50IHJ4X2hlbHBlcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc2l6ZV90IHJlYWRfbGVu
LCBpbnQgKmlzX2NuZikKIAlpZiAoIShoaWYtPmlkICYgSElGX0lEX0lTX0lORElDQVRJT04pKSB7
CiAJCSgqaXNfY25mKSsrOwogCQlpZiAoaGlmLT5pZCA9PSBISUZfQ05GX0lEX01VTFRJX1RSQU5T
TUlUKQotCQkJcmVsZWFzZV9jb3VudCA9IGxlMzJfdG9fY3B1KCgoc3RydWN0IGhpZl9jbmZfbXVs
dGlfdHJhbnNtaXQgKiloaWYtPmJvZHkpLT5udW1fdHhfY29uZnMpOworCQkJcmVsZWFzZV9jb3Vu
dCA9ICgoc3RydWN0IGhpZl9jbmZfbXVsdGlfdHJhbnNtaXQgKiloaWYtPmJvZHkpLT5udW1fdHhf
Y29uZnM7CiAJCWVsc2UKIAkJCXJlbGVhc2VfY291bnQgPSAxOwogCQlXQVJOKHdkZXYtPmhpZi50
eF9idWZmZXJzX3VzZWQgPCByZWxlYXNlX2NvdW50LCAiY29ycnVwdGVkIGJ1ZmZlciBjb3VudGVy
Iik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggZDc2NzIyYmZmN2VlLi44YzQ4NDc3
ZTg3OTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTI4MCw3ICsyODAsOCBAQCBz
dHJ1Y3QgaGlmX2NuZl90eCB7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX2NuZl9tdWx0aV90
cmFuc21pdCB7Ci0JX19sZTMyIG51bV90eF9jb25mczsKKwl1OCAgICAgbnVtX3R4X2NvbmZzOwor
CXU4ICAgICByZXNlcnZlZFszXTsKIAlzdHJ1Y3QgaGlmX2NuZl90eCAgIHR4X2NvbmZfcGF5bG9h
ZFtdOwogfSBfX3BhY2tlZDsKIAotLSAKMi4yNi4yCgo=
