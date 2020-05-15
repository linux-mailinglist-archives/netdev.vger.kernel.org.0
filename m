Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583141D484E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEOId5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:33:57 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727111AbgEOIdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:33:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCEcVZYspVBIRYQmskx6yxL12+L9X4daI+vR6vKZ4HviR/9gZWw3SlWeQbEHJw5yoTgWgCCl/0J/jyG+j7oTaBTREg6ZhPayGo5j0GVqDxpXrEip2lobir70R6L7fpXxUX//bl4gCsXHkvFy4ZtNniPYxNgzZQzmwposlgEk+GzxCjE4OzO6+Xz/xpWrxzY09N7DJE196W6O710sptSrYNobaQ/OYjVvZmba48qJqMaXJcoLgZXBVllo2tbBgM2BckiZZTOHV8K5LYM5o+O7nh5WsaMzv9IxyoWHCUvfekHiN4LJwTBGAiYpsT6RZ1h5RarHdZ2nVF+0Lrbj06WnLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPHeT3iF5URE4a5rzKNup6vkQuIqCgzIbDR7ClMOUBA=;
 b=oNaNvgogRU6YBC09OowPdjqIqbZgc9n9G3knYSpGZ094P6V/xmpclWHyniJJI3LZanpLKqOlJQEm0iA6KvWEu/dLYgM+DyMNqSyRjdPVtRTeyowjUQvvcilJtfQcPFmSGlpzl9LUh4tInY48bfasVcNcXXbbE19DtyIne6KPLAVP9ztzKdkJ257QH6fEA1emgTKxdLMRMbNjJr9922oTpWZkf3U93M1bYKzYHTpAjdxB+YTU9DKOelUDrB48T2vy0v38J3LbCPN9TFddzZcH9/4TkELU19FT1pBCYRz7i7ncLBvG1Meb52ok9Zv0GU1L5DgOEGh+vYcckT7fYDr0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPHeT3iF5URE4a5rzKNup6vkQuIqCgzIbDR7ClMOUBA=;
 b=kggP9jr25qPMcdXFZG4gbzal+QkaYnl04Fz90lC8i92BGeFySUR3VjcWV/Qgh/Hp4dxj4lRNKlc6g+7LRGitsTxoN/8+QlbTVGJljqY3aTrb8Lr3cAf/xNia0yG1duwJtzgh/7URs0t/RxSbvpBtF7ghGSWOiVWXWNulPFXZQJE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:33:50 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:33:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/19] staging: wfx: fix warning when unregister a frozen device
Date:   Fri, 15 May 2020 10:33:07 +0200
Message-Id: <20200515083325.378539-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:33:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9643eb0a-ba91-4af7-0cb6-08d7f8aab16b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1310CC84C0E13C7C0FAE210593BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:84;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awRHL4g7Xo1o4WChvmfJCMWNaZdZE0B51JsmDsH7zxhgAGkYbuW/0N7wFZ3GQh0W2afwAW+lpKzLcATcTFyVKBuDmb4hCjDYxiUl51UJI74xuQL10/waALG1GiiaCTnA5OlA7pHfF0JoO2Ki6aHPse2Cyc8x3Y4XKeiGbgR7gtj7MD/qkquTu4DcFOZ2cKUz9f1TAsSp4JNBHQwYrZ9fzVTjGuhNXZnhcBGgX3Y6yvSHBU/adpYyHKfuk0fDdph5wmyF0nectG7dG8KzL31i+4+hu9pnUWDZjsbYUcItWWsJ1akOOvRAXrvW4fSmQ1o6N81t/7hqOd5Pv8bn+G/0sCdQQPD8LbsK80N91kIiKaF2MWtj7WScYV1R1Abl87JKlGdUTZA1jqoLMXhE0BUCrMuNZzVGf56Ko/L1W+c5Qcwk/6sGwj4aieKQLtuPWeCL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ilmVstfWeOgvHRJBI7+MukrZReU5ubfpk0aDooN1sWCVY8O67TlzNHg1udZgIbmSnM3rxXHk0wCsKqY7kdZEWF6fSMMHBM9Zm++4vVEhM+xKTlTdd9bq+tQGC8rTwBKIJtSSgnlL2FLAd6pKsB3HNI5n2aiNhjnuCGZRV7xhWG1y/wa0m3kbC1KXqs2Zlx/YlVJdLaMd2gM+EOmrQ+IhCOiAzps6W+jqOMj8Q7AteTWXxtzn9/AYYTY8B/tJTRUFTDs4eENtVdxVg5ijSN2g5egp8XPmfQhb171RtvxkDNeZt4CVOiuwIGbX44mc2ZAfU1MXKFyZvYoL4XwYgTpFp3Ke/fV8IbpkgTYRAPYaX67RO6K+oMQP9nj0O+eHiRSLrYB905a+GBbqBhFZHGz6GjvrafGK954Szck58sxIU+AuwC1uxzdPeEd1DKpn1x5Qvh7pdd59Nyo3IHeVmT6HTbAWyNyyGuB1A2JAOZ08mA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9643eb0a-ba91-4af7-0cb6-08d7f8aab16b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:33:50.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHL7nNbfCOy6ES8ITUtt+rqkWg00JmXKZ+hyzI7F22R2LNThvPFhOe4B891aykJ1ILJuV7+PeVi7aKAa8iG4jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBkb2VzIG5vdCBhbnN3ZXIgdG8gdGhlIGNvbW1hbmQgaGlmX3NodXRkb3duLiBUaGVy
ZWZvcmUsCmhpZl9zaHV0ZG93bigpIGlzIGEgYml0IHNwZWNpYWwuIEl0IGJ5cGFzc2VzIHNvbWUg
b2Ygd29yayBub3JtYWxseSBtYWRlCmJ5IHdmeF9jbWRfc2VuZCgpLiBJbiBwYXJ0aWN1bGFybHks
IGl0IHVubG9jayBoaWZfY21kLmxvY2sgYW5kCmhpZl9jbWQua2V5X3JlbmV3X2xvY2suCgpIb3dl
dmVyLCBpZiB0aGUgZHJpdmVyIG5vdGljZSB0aGF0IHRoZSBkZXZpY2UgaXMgZnJvemVuLCB3Znhf
Y21kX3NlbmQoKQpzdG9wcyB0byBzZW5kIGRhdGEgYW5kIGRvZXNuJ3QgbG9jayB0aGUgbXV0ZXhl
cy4gVGhlbiwgaXQgcHJvZHVjZWQgYQp3YXJuaW5nIHdoZW4gaGlmX3NodXRkb3duKCkgdHJpZWQg
dG8gdW5sb2NrIHRoZXNlIG11dGV4ZXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYyB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYwppbmRleCA3ZjQ1OTcxOWU3YjQuLjNlNWQ5MTExZTg1NSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCkBAIC0xMzEsNiArMTMxLDggQEAgaW50IGhpZl9zaHV0ZG93bihzdHJ1Y3Qgd2Z4X2RldiAq
d2RldikKIAlpbnQgcmV0OwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CiAKKwlpZiAod2Rldi0+Y2hp
cF9mcm96ZW4pCisJCXJldHVybiAwOwogCXdmeF9hbGxvY19oaWYoMCwgJmhpZik7CiAJd2Z4X2Zp
bGxfaGVhZGVyKGhpZiwgLTEsIEhJRl9SRVFfSURfU0hVVF9ET1dOLCAwKTsKIAlyZXQgPSB3Znhf
Y21kX3NlbmQod2RldiwgaGlmLCBOVUxMLCAwLCB0cnVlKTsKLS0gCjIuMjYuMgoK
