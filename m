Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC001CDF8F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgEKPuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:10 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730453AbgEKPuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyeSRCv/BxtjZdl8n2oGYESWojbHHQJzgFsdSJQe5Tg7pXtx0QBY2nzUOTkyF1DlF7tnAlfBQJg9XOIGRy4K82MZWAGRZukqBfeiytXjh4bWyuTTaCYVxDGTISuF/S3zL64Z/cNSHgyqmwTspp6rA/H3Ig46oBzEYrvFSLuAMwWB5wSEBDhRjf+zFsrdpAhbTxxvCwVDMEuYZNGpyWr7vy+N0b0EZ1AiK+Jtpr+z+AUlI5aodbmecc7FGsZ6ZfwGYtwD1vPaeEc5wM01pphpcHN9xdu04mfN9qgXQKXiorJEL2UyMKf182v2Oa63D6MaN8fob5eY1vteJyHWd8ALqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLoy7SPr/nnlx+NwszrJ2bm7GNP4HsvqH3meQhmDzEc=;
 b=kjkjFiCFdFgqdTadjIhenCxaH8sIIVAaQNwPPOCKSRPEcUulEb6YUViiuHDV6clmCcP37Mo0/C0tztgKh6MSnhF1/3iYW7mK2o2iZiJeZDK8PIWTbjve5FccrWaNW2JEldErDhB0TMWiOZVm7cxcj2cOOjS+DbCfeC16WZRtybryYZcycwCTVDrde91MdKqVY+zSDew8DrxLkDraRTDhpgpALlpsjNorVot/eHhhBH7qWTBAdMFmEMWj0k+atFyMhWBQoUfYCj68c5IrKC+OPuwjsiTtOKlHQga9PpggM2U26k7DXuvaFnjS/bu0TF3pG2hBi4LDlnX1vOYE6VGErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLoy7SPr/nnlx+NwszrJ2bm7GNP4HsvqH3meQhmDzEc=;
 b=lAIm6WhuaZJh/wXKdXpt+ct3f9stDQ6oeT0aHQyKP6T5cxCew7fRePB2KrkPD6DI8qHhKjw3kUj3plNqyXNX0/5rPOSxoTMAmBGYTxMP/uKn9A9c2QPVctE5zHvZLHPyFmS8W1Zb4KpWkQLdAO4R0I5AeSmjJI+KEEokvEvKHtk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:01 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/17] staging: wfx: fix access to le32 attribute 'ps_mode_error'
Date:   Mon, 11 May 2020 17:49:21 +0200
Message-Id: <20200511154930.190212-9-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:49:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e984a72f-4a32-4c1a-d931-08d7f5c2f709
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB196853DC7F0E2756BF205FAE93A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GG8Z55QadB3kX4eop5bMiYVTjW6ZbxfKHgbHdcHx+Y5JbhVPElMDpMr0vvPc8Onwqu21hylYc+g/WiLtT8GZeGqcCCUbQiN8I0JXx2tFhI7yJRHROwzgwxJwInSDpeE/8NLKl8LzBiUiRQyMBGDouAPA0/xt156u9ZG0gWLGVpSR0BIAELbd3bMwmM08eBHp7i+m8RskYhujHUD/Qo6I8mIiMx2wlapl3dtFeIIumUod70MTfx4tIW8uWmT90BJwcYVFz/XqpQe9KFA+78wQlH6bwjjWPtMhlA6vWk5PnQKUb+rl9840MpW6c/XJ6w3VldD/fF1s7/DHdyUSXM1eQw7o8l3owfQSo5NcePjHy2sV1SiJErIo2HjBWzPXV76WrV0mAFmZrNwuvyrwGU5L2IfqqIodYJko3BYn5SN3vKUHIA6zwK6UKUFJEO5RW4yYrWsqdpr/6AA6N6w9WDnarYhlCwPqS+RtoKwk89Iq3Bj2Q7HG0uZqmDkyHfOAjB74lzwfrc6H0qv1TSYQQklBjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fP3Z3b7lIcmBLXkAvNE92b714BS72FrPaH0kX2wGbbVT/+Nau7/yV1lt3klwOeQcl1Qr40CZZ1M7frF6H/JRJdU+r09ewqEiPIeGk3/CbOtwV7lwMcKqwe29dDXJW2RJRg5Srvf1fgMaQ9BZRciS0FlPoAlLW3Hwbv9p24/9eVbM8fNBtC8rjCn+wtN+5x9N8DevtKy+GXdMxQVeh52UCZUhMLuqrXnlfuYpiXRo4gEmWb2xpswh6CWqw0VX/sz8qZ53FcQJvQSL6c7K2J4u/a1TPuWGEft/nRv4+1YZEejpYLfsCIXpOnZHtEKzcugcMtroNh3Ny+CrsfIL+zIQ9fhbrkHwA0rlxB8VC6YzzIN7Wiu4/MwztZXoWuIzgtrQ3flaloI1sMgeX7bWu1BNRYotm9FhnDMjR5UD8pdUjNaWjqWTIDaEmA7kCGurQ+jlCIzvnWC5IfM22o9n6U+flEIVcQTu7ThWl24eDzEiaqI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e984a72f-4a32-4c1a-d931-08d7f5c2f709
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:01.6301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tBH3fs6Xyn2kRYy2W+LgiMuf3hpmKGtR4gNUwV0Jm0945WjZQ7G+8mMA8iE/g8vaxc6U+rHKAb50c2Cm7qF0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGF0dHJpYnV0ZSBwc19tb2RlX2Vycm9yIGlzIGxpdHRsZS1lbmRpYW4uIFdlIGhhdmUgdG8gdGFr
ZSB0byB0aGUKZW5kaWFubmVzcyB3aGVuIHdlIGFjY2VzcyBpdC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgNyArKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDgzYzNmZGJi
MTBmYS4uODdkNTEwN2E3NzU3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTE1OCw2ICsxNTgsNyBA
QCBzdGF0aWMgaW50IGhpZl9ldmVudF9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAog
ewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGhpZi0+aW50ZXJm
YWNlKTsKIAljb25zdCBzdHJ1Y3QgaGlmX2luZF9ldmVudCAqYm9keSA9IGJ1ZjsKKwlpbnQgY2F1
c2U7CiAKIAlpZiAoIXd2aWYpIHsKIAkJZGV2X3dhcm4od2Rldi0+ZGV2LCAicmVjZWl2ZWQgZXZl
bnQgZm9yIG5vbi1leGlzdGVudCB2aWZcbiIpOwpAQCAtMTc2LDEwICsxNzcsMTAgQEAgc3RhdGlj
IGludCBoaWZfZXZlbnRfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJZGV2X2Ri
Zyh3ZGV2LT5kZXYsICJpZ25vcmUgQlNTUkVHQUlORUQgaW5kaWNhdGlvblxuIik7CiAJCWJyZWFr
OwogCWNhc2UgSElGX0VWRU5UX0lORF9QU19NT0RFX0VSUk9SOgorCQljYXVzZSA9IGxlMzJfdG9f
Y3B1KGJvZHktPmV2ZW50X2RhdGEucHNfbW9kZV9lcnJvcik7CiAJCWRldl93YXJuKHdkZXYtPmRl
diwgImVycm9yIHdoaWxlIHByb2Nlc3NpbmcgcG93ZXIgc2F2ZSByZXF1ZXN0OiAlZFxuIiwKLQkJ
CSBib2R5LT5ldmVudF9kYXRhLnBzX21vZGVfZXJyb3IpOwotCQlpZiAoYm9keS0+ZXZlbnRfZGF0
YS5wc19tb2RlX2Vycm9yID09Ci0JCSAgICBISUZfUFNfRVJST1JfQVBfTk9UX1JFU1BfVE9fUE9M
TCkgeworCQkJIGNhdXNlKTsKKwkJaWYgKGNhdXNlID09IEhJRl9QU19FUlJPUl9BUF9OT1RfUkVT
UF9UT19QT0xMKSB7CiAJCQl3dmlmLT5ic3Nfbm90X3N1cHBvcnRfcHNfcG9sbCA9IHRydWU7CiAJ
CQlzY2hlZHVsZV93b3JrKCZ3dmlmLT51cGRhdGVfcG1fd29yayk7CiAJCX0KLS0gCjIuMjYuMgoK
