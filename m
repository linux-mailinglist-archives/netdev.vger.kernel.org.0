Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0398519F45B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgDFLS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:59 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727933AbgDFLS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9aG6EOReCa8weinrwp5Kr22wZEf6bplHpGiIrTGuR/gPMAwFM1a1MdmlwVsz/CHSCgsTieeDo/M2W1otMJd7ylqbpQrRhPRzFg8HTalgb/GkgNWpSkPvrIlKER+0r9Mv6RC1kmdz+DPoUWIEuXbcXhEjo4rBLR4xj+LVQDblTqbWftjYuFyYBcoLRKxWMgOJszjKZNdqY096WDw5CWav5GRmhY0IX+3xxIBEcj37dPyI73XB7Rl0I8QY8IH/PJtLXySNjOH28UFoLBVVPXF3rdAZWZ9tzxI4Km2vx1AA2wiSNFm9iZMTu3u4FSc+qQrEHmWJjQIpDBYnKaU0EWYiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJLNYy1rUZM3cmqcCe5LvFcQmcQ1AXYnN8pNj8m62Gc=;
 b=OcQJUaKdAdAJWUMPSymBoE94A0AibyYb9JjMwH4ZSrX/1ewzujODxva2pBUpbJXV41WQFpBbe+Kbb/AMp9zAsSeZMKXO91aFkhOgaiO3WMq9fwu+EMliqTwjF9oPVX/smHaEFyiJ72ah2g8HyEMeBlwAt4ba3ek4tySTOhwEzhcKPrFBz6eCSyG4ZvRPmJiVACpwmLe2fKGCNqsMZB+fOEy2EL2GImD2DOGq4jMWGLkFOL92oFYfBACEtFrMwjfSPLdhAXMiafDv6ZTklByOoq2JnWMHVieJiXPjF1hb9PvhKnA+/7OKN1OUlKEYG5D1qfz42NKUcUjNyRQLrd8jJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJLNYy1rUZM3cmqcCe5LvFcQmcQ1AXYnN8pNj8m62Gc=;
 b=bHn5ON2GessS8mffq4VqskH7PxrgyA7xm7whpfU0Uz3cwpkGfhH7GA9QZXrDJ8T7QWIsC3hLN933YTk0jz+z/pke4tNdXQCVjx2AT+hHRXluxbkEea29V414zK19UTzbdKigSX3PvS28ZNyIALv58hM/d6tOlmDWdFGyDqirUgM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:36 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/11] staging: wfx: send just necessary bytes
Date:   Mon,  6 Apr 2020 13:17:56 +0200
Message-Id: <20200406111756.154086-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
References: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:35 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8600d4e7-2485-4403-8390-08d7da1c4009
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB38609BF8C9AFE603844DB25F93C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: twD7Sm0d81MLD46BIYHnwz1mBBoaWJ1B4HfWsL7Td3a+IwhVH+HGbNoJ1pUn2QTg8PX9QaxZandlMCUMhpmi5e5CLwdFMhW3PljnKeaqZE3rpn9qaehjY5YKH1RnStxqCflyovk0nIYeghl3cafEeTPTr09qj/7LHxZ1RdQLZCsKDd8ObkjMc61ilY2ct7xu8Tv5SqQoRcKBFK2qlbcNvoZf774unXj+euGrXM49tpNB7bjAlndWn8CL3okdPwmJp/kNKN+YrYBf4uNVCrzcbV4BAd2JNfoWWvO+RZm2Wu+bp4sPYc9rycAsdCsFRQtxJ9n1vOd5YzPWf2xZrQYY0Xi7qg44cnLebr1up8Ox9e0hJLUrwscqAc7QJN3z/IZhnSadduvkJLzdOT9BZTDFLLQiu1dBpHZccPzW4iV+N2BROihA33VGbj5UFNjBvQEM
X-MS-Exchange-AntiSpam-MessageData: jCPWiybbNhgMMcgyXQr/d0QZyjQCCLW/+9CF+YThD23GMDApfASQl+VltRuryO3jRuPz3oB8LbDZczxH8XMg6GmzJvzHVV6vXP99m/9BlJrLXliYhyILQ1vWPK0oAwOQpNkra1VT9Is9vbQzrkRzFLUkstz/kHUXEPcwcgCcjqhbjbX/tdoBw51qx9p6ktqhJKH3eIctlkBJRdn1lwsbgQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8600d4e7-2485-4403-8390-08d7da1c4009
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:36.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQdWU98AR1BjT3cIm19B47eHjgYWEVTVhb7MCIrZV3N/iWiN+jo7ZclUmuAk882Y30mu3DHJfy28QpJEbsQAWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2l6
ZSBvZiBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lIG11c3QgYmUgc3VmZmljaWVudCB0byBjb250YWlu
cyBieXRlcwpkZWNsYXJlZCBieSBmcmFtZV9sZW5ndGggYW5kIGNhbm5vdCBleGNlZWQgNzAwYnl0
ZXMuCgpDaGFuZ2UgdGhlIEFQSSB0byByZWZsZWN0IHRoYXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIHwgNCArKystCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuYyAgfCAzICsrLQogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21p
Yi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCmluZGV4IDA0OTAxNTdiNGYz
Yi4uOWYzMGNmNTAzYWQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlf
bWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCkBAIC0yNzAsMTIg
KzI3MCwxNCBAQCBlbnVtIGhpZl90bXBsdCB7CiAJSElGX1RNUExUX05BICAgICA9IDB4NwogfTsK
IAorI2RlZmluZSBISUZfQVBJX01BWF9URU1QTEFURV9GUkFNRV9TSVpFIDcwMAorCiBzdHJ1Y3Qg
aGlmX21pYl90ZW1wbGF0ZV9mcmFtZSB7CiAJdTggICAgIGZyYW1lX3R5cGU7CiAJdTggICAgIGlu
aXRfcmF0ZTo3OwogCXU4ICAgICBtb2RlOjE7CiAJX19sZTE2IGZyYW1lX2xlbmd0aDsKLQl1OCAg
ICAgZnJhbWVbNzAwXTsKKwl1OCAgICAgZnJhbWVbXTsKIH0gX19wYWNrZWQ7CiAKIHN0cnVjdCBo
aWZfbWliX2JlYWNvbl93YWtlX3VwX3BlcmlvZCB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCmlu
ZGV4IGFjNTM0NDA2MTQ0Yy4uNDFmMzA5MGQyOWJlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YwpAQCAtMTQ4LDYgKzE0OCw3IEBAIGludCBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogewogCXN0cnVjdCBoaWZfbWliX3Rl
bXBsYXRlX2ZyYW1lICphcmc7CiAKKwlXQVJOKHNrYi0+bGVuID4gSElGX0FQSV9NQVhfVEVNUExB
VEVfRlJBTUVfU0laRSwgImZyYW1lIGlzIHRvbyBiaWciKTsKIAlza2JfcHVzaChza2IsIDQpOwog
CWFyZyA9IChzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSAqKXNrYi0+ZGF0YTsKIAlza2Jf
cHVsbChza2IsIDQpOwpAQCAtMTU1LDcgKzE1Niw3IEBAIGludCBoaWZfc2V0X3RlbXBsYXRlX2Zy
YW1lKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCWFyZy0+ZnJh
bWVfdHlwZSA9IGZyYW1lX3R5cGU7CiAJYXJnLT5mcmFtZV9sZW5ndGggPSBjcHVfdG9fbGUxNihz
a2ItPmxlbik7CiAJcmV0dXJuIGhpZl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsIEhJ
Rl9NSUJfSURfVEVNUExBVEVfRlJBTUUsCi0JCQkgICAgIGFyZywgc2l6ZW9mKCphcmcpKTsKKwkJ
CSAgICAgYXJnLCBzaXplb2YoKmFyZykgKyBza2ItPmxlbik7CiB9CiAKIGludCBoaWZfc2V0X21m
cChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBjYXBhYmxlLCBib29sIHJlcXVpcmVkKQotLSAK
Mi4yNS4xCgo=
