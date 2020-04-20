Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8992A1B10EA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgDTQDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:53 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:6055
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729034AbgDTQDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu6rmvG9FngW2RMdYdVCT1tYOsax5Tb3irHutRrpqpk65hT29ZWp9vZs5SYo1QeqmPth5eeMXaSe9Yz7fG6NZnCB6FMkOVBDZTkOCjJoWHeP9X7G1OpP3YhFWJTbwfKkwXC4R7bO+iZlC8DM3o/A0pL7CheBj7JVJxQJEuRbKIImC8NjEExTCn3MsENK9Qc59u2wPEdf2gyZ7pokYi8SOxFdad0fDFkEmpXJyoiCQJC4cTGgOkD7KK9Qo5PfdM3c9b/SjIvN9pMvKfvHQKX1GrVBB1JOU0K1Q5JCIu/IJQdrBFac5IZeUt2FK1PcGzXRE7i5J8OBBt65HLFufHNaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l70JogB9AaE6R6l9OLobf5gNGV2JilUclRV6+SgLLhM=;
 b=XPABDJ7nfioAaMokHF4JlQPBnUEiMYWO6j7XtGM9e9sjGj1Lf3gph6xRsHjWRCrhyGM4mR+Mbj+IhNDhrYrcpePg0pkJYgSoX9ekBrywLsylFCiUJLEjQGL0kcFr3JVSK4i0G2DMkiQSz44lfkxpGBnpagAPqxxwzJKjpWnqPagC0GddoOHApC+ex+IKp6fN4llIFC2ihyAXFKlazfDRMQ4unsl0qQ59pV3KgfDNHQlx8W8WmurX6ruaqVq2rMs8YdYHK6k9Jb+C93otkZ+U5wKyk1eiDXpUptz/ECs+QTrdsO3C28kAbX7TlOgofJBbogg+sRyqnjA6diS+hRx7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l70JogB9AaE6R6l9OLobf5gNGV2JilUclRV6+SgLLhM=;
 b=emiCZB7Q8NVP/ZI2ycPpiaKnzzjcOgx1Tvj71BcYUS3R77r1jTGKNlcgx93YDU4Gh3RnpAXcnca1HLnDzPrHmAbXPXxZ59YtaGgEMugGj71xOlbSaW4OsvGOsdsg0vgm62iErpM26u67wajBQUYUml7OyhdqOBbCBfw6IBV+r1Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:03:45 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/16] staging: wfx: simplify hif_set_bss_params()
Date:   Mon, 20 Apr 2020 18:03:03 +0200
Message-Id: <20200420160311.57323-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:43 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b811b26b-b4bc-4264-25d8-08d7e544676b
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB24983B793A5C7CE271D7A1193D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(66574012)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9An8SdGPqyeOGQtmpiowlgVhnWGL4VnT0YcP1Rgx83NJY8P2hGzyylxgfcNoAvyWliYygQ1XOru6/LkXYfK+VBIin25aRIXpybmdw4l5SpvQvEBS7TD4OqlkCOhbB0rAO+065WbPBXdz0ibID1t4i1vlW35ZpJneh8DW1bIW02B4AqTMNdXQtZAuCNsFeyraffffc4ql0d3pbAxggzQasgiQsgxYVJuVdYo1DSLMST77zSWPCE+Tm7GiC8IQOR0WjxtKCdoAuHbm3xY8vH7MBpmVAh1V2W6NMwj38FYXqiU0OhzKHplMiAP9KJqt5o408c5sa0MoiDXeUoEyPADZAY3qrqSe98hPBuhFm+wqRbZWH8HZHeJkiKlrxTOgbQRdjcjMR2fsF1jn32JZh7WeiV/JP+di7okbWM3RAXjXVXtpRWgUzL9hRJHmXvXnumwD
X-MS-Exchange-AntiSpam-MessageData: NK+rS6zkyaWLH2XfPf++3e3QsgruV99K+PijUrDL73l7cV79CSefjxyaJLtx9P8E6twuC32ZreEJDFI//6Sm3WJPeWcLc5KUUSJSZsT0xtmWbSSVOwxk0aoDHjwwgEIxyum+bhz0Ouo8frfj2NPrUFRW1n4fF+CZfFEgRq9rZjxRkB04HDoSWiexCRFPil52AfscxdTtdjMqbILVTp7W3UGsrG1+hUu9dG17BVY9a+pKLisoH4o+APejO+dC7twOQfk05RrjnsKehmZOJ0stc0bIz2JfvfGm6T7TiMC+iKH+cAnhe0+kppRnPx3qMD4VkfGIN8tkEQKco9yhiiD1hLaEg878faOznhIqqTeaVB6xpnbjKuB8wC6m08tBxnF3r2vjyXuKfPMIjamp8CqEY3YBfELdtNSc5dyPSqcbyFNu1FwnsZAuK8yjxQSwYKUni9+AFONj7Ve+FK1jrmV44Mwk1t/PNb1Vot4HPV6p0HWEd7m4dylm1ymByhxPhoa603lTyxvPOdo7Na7FmpgP64Rwfb2kNbtngxm3F1Y9l4TX0dliBRiV1X0pV4HdXCh8+9acgTzQaCdcLBxNTbKWJRhDQ9tbUAQAHALNI0EjJTXbc2JDTFNObeJMih5y9gO2C/2qS6pS24T9I1jxxcxI/ODiICH4d7QNWsYK8VUL5CSWK+zNHvT8MNZX3aqUNM8NJfCEZ2yYtlUTJjjjsN6O1ReMxFaLxkeKWqv6Rqdherx6cFRRG3U8X8bxrsBYQAylPIypDdv7UWncx9Iq2VxLyaKXRF166txqSU+RLwyOPVc47819YnHE8jgY5l62/Epbh6OlOFgVoLfXzjUF/wP/s4MXBnudsbjf2XqFNKB4WYY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b811b26b-b4bc-4264-25d8-08d7e544676b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:45.5464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUpqtIRDnyPAbUEQrOahzkJQrO4pdApRcsbEP3X7ARNm/gZ2cpaAIm/vTq0U7JR94DEk7TgE79f4AUR0EIracw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGNvbWUgZnJvbSBoYXJkd2FyZSBBUEku
IEl0IGlzIG5vdAppbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMgb2Yg
dGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZfcmVxX3NldF9ic3NfcGFy
YW1zKCkgaXMgdG9vIGR1bWIuIEl0IHNob3VsZApwYWNrIGRhdGEgd2l0aCBoYXJkd2FyZSByZXBy
ZXNlbnRhdGlvbiBpbnN0ZWFkIG9mIGxlYXZpbmcgYWxsIHdvcmsgdG8KdGhlIGNhbGxlci4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgMTIgKysrKystLS0tLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIHwgIDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jICAgIHwgMTEgKysrLS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCBmNDlhYjY3ZTFhNmQu
LjE3NzIxY2Y5ZTJhMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0zMjEsMTcgKzMyMSwxNSBAQCBp
bnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFf
YnNzX2NvbmYgKmNvbmYsCiAJcmV0dXJuIHJldDsKIH0KIAotaW50IGhpZl9zZXRfYnNzX3BhcmFt
cyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3Nl
dF9ic3NfcGFyYW1zICphcmcpCitpbnQgaGlmX3NldF9ic3NfcGFyYW1zKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLCBpbnQgYWlkLCBpbnQgYmVhY29uX2xvc3RfY291bnQpCiB7CiAJaW50IHJldDsKIAlz
dHJ1Y3QgaGlmX21zZyAqaGlmOwotCXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zICpib2R5
ID0gd2Z4X2FsbG9jX2hpZihzaXplb2YoKmJvZHkpLAotCQkJCQkJCSAgICAmaGlmKTsKKwlzdHJ1
Y3QgaGlmX3JlcV9zZXRfYnNzX3BhcmFtcyAqYm9keSA9CisJCXdmeF9hbGxvY19oaWYoc2l6ZW9m
KCpib2R5KSwgJmhpZik7CiAKLQltZW1jcHkoYm9keSwgYXJnLCBzaXplb2YoKmJvZHkpKTsKLQlj
cHVfdG9fbGUxNnMoJmJvZHktPmFpZCk7Ci0JY3B1X3RvX2xlMzJzKCZib2R5LT5vcGVyYXRpb25h
bF9yYXRlX3NldCk7CisJYm9keS0+YWlkID0gY3B1X3RvX2xlMTYoYWlkKTsKKwlib2R5LT5iZWFj
b25fbG9zdF9jb3VudCA9IGJlYWNvbl9sb3N0X2NvdW50OwogCXdmeF9maWxsX2hlYWRlcihoaWYs
IHd2aWYtPmlkLCBISUZfUkVRX0lEX1NFVF9CU1NfUEFSQU1TLAogCQkJc2l6ZW9mKCpib2R5KSk7
CiAJcmV0ID0gd2Z4X2NtZF9zZW5kKHd2aWYtPndkZXYsIGhpZiwgTlVMTCwgMCwgZmFsc2UpOwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmgKaW5kZXggZjg1MjBhMTRjMTRjLi4wMzhlYTU0ZTI1NzQgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguaApAQCAtNDgsOCArNDgsNyBAQCBpbnQgaGlmX3N0b3Bfc2NhbihzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZik7CiBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0
cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJICAgICBzdHJ1Y3QgaWVlZTgwMjExX2No
YW5uZWwgKmNoYW5uZWwsIGNvbnN0IHU4ICpzc2lkLCBpbnQgc3NpZGxlbik7CiBpbnQgaGlmX3Nl
dF9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBwcywgaW50IGR5bmFtaWNfcHNfdGltZW91
dCk7Ci1pbnQgaGlmX3NldF9ic3NfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkgICAg
ICAgY29uc3Qgc3RydWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgKmFyZyk7CitpbnQgaGlmX3Nl
dF9ic3NfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgYWlkLCBpbnQgYmVhY29uX2xv
c3RfY291bnQpOwogaW50IGhpZl9hZGRfa2V5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBjb25zdCBz
dHJ1Y3QgaGlmX3JlcV9hZGRfa2V5ICphcmcpOwogaW50IGhpZl9yZW1vdmVfa2V5KHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LCBpbnQgaWR4KTsKIGludCBoaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCB1MTYgcXVldWUsCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA2Y2RiNDBhMDU5
OTEuLjFjYzQzN2YwYmM4MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00NzAsMTYgKzQ3MCwxMSBAQCB2b2lk
IHdmeF9zdG9wX2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3Zp
ZiAqdmlmKQogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKQogewotCXN0cnVj
dCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJzc19wYXJhbXMgPSB7Ci0JCS8vIGJlYWNvbl9sb3Nz
X2NvdW50IGlzIGRlZmluZWQgdG8gNyBpbiBuZXQvbWFjODAyMTEvbWxtZS5jLgotCQkvLyBMZXQn
cyB1c2UgdGhlIHNhbWUgdmFsdWUuCi0JCS5iZWFjb25fbG9zdF9jb3VudCA9IDcsCi0JCS5haWQg
PSBpbmZvLT5haWQsCi0JfTsKLQogCWhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSh3dmlmLCBpbmZv
KTsKIAloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgMCk7Ci0JaGlmX3NldF9ic3NfcGFyYW1z
KHd2aWYsICZic3NfcGFyYW1zKTsKKwkvLyBiZWFjb25fbG9zc19jb3VudCBpcyBkZWZpbmVkIHRv
IDcgaW4gbmV0L21hYzgwMjExL21sbWUuYy4gTGV0J3MgdXNlCisJLy8gdGhlIHNhbWUgdmFsdWUu
CisJaGlmX3NldF9ic3NfcGFyYW1zKHd2aWYsIGluZm8tPmFpZCwgNyk7CiAJaGlmX3NldF9iZWFj
b25fd2FrZXVwX3BlcmlvZCh3dmlmLCAxLCAxKTsKIAl3ZnhfdXBkYXRlX3BtKHd2aWYpOwogCi0t
IAoyLjI2LjEKCg==
