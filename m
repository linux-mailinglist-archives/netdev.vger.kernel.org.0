Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF96D1AAD77
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415344AbgDOQNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:42 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:6138
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415267AbgDOQNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:13:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIeFKwUWQrzZgt1hBWGSAdMhvg469GL0/WgQqSrx9V3NkvDOZZxxBDC7Tq3NY5zrELZZWZ+tdOgI+WHlRlRkyZQe73X5qbdLo3/zGZbKoOAUz8TeYNnPlNe95dcvakyKo7IHNqOTRR0f4DRoFFXjD/sE6OMDWk2e/O+cKDaHXYNb/BFJc9JIxHPs9KPvEetGWW1/3MEZiC9UGJ1yiU8eNvdtF7P9XwvGLgtBRzDYC2AQvhlHuZOA4aa+rUU4YrZC66RMG0a+bTSfcx3bYLQ7Iz3ZVQg42wbFhPkEGepJ1sXybk5rlWJx3L+DcQmwMtywWi5Iqe0c+biBQb6jwH3bxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcCr24adU8BKj8HLPi7q1EyV3rxYejoJm4kfH/IpBDE=;
 b=EV8BRHC5nAgVQDuoHZdYdN5mvnlfJgAcxAfJFL2bIrf+oBi20A3L07RJ71KoS3lxIFnTOO73YYedJzW8qZiXdb0MNPw3BcUYFPUJycTjps7hDZzDovYZTJqYLaT3vnZLbI/9ds0mbqNu41kz7zdzpSRSrzL45n/rpd4KUn49mNvPq+iIksgTIAsIk/RyT7fmW2237AQyJ7PFwxyECn++Nfm8iTM4IDsYZhjordi7qzix3MtNMz55vl/vJmW60+fG5Ig/usbc/PqGF+sYI3e9bqK4U7l9ND6zWtvzlFY9/pTES7CCih5s1zLgOnmxpxMRFSF81FPbN8DAM+GgL9+PvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcCr24adU8BKj8HLPi7q1EyV3rxYejoJm4kfH/IpBDE=;
 b=C2JOXtjMmYlwMW/mJ3RqnHP9AjeFNdp1zp1MR/aqzvp5dTNseZw9rGlUxTHyw3iGPdSrJbH60WKsvkbjmXpdy1ZwBiOf/FhIzmfCwFvUkrmmtBl5C+wmjcHfnNIMuD51bsfTYZs/i9eJ/1+LEJ6VN45O3ErgwgbRSHvy/SG17Xg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1327.namprd11.prod.outlook.com (2603:10b6:300:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 15 Apr
 2020 16:12:59 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 18/20] staging: wfx: drop useless filter update when starting AP
Date:   Wed, 15 Apr 2020 18:11:45 +0200
Message-Id: <20200415161147.69738-19-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:56 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8981bb6d-dc74-4ba9-cbe7-08d7e157dd1d
X-MS-TrafficTypeDiagnostic: MWHPR11MB1327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1327267771340733A91CC2D693DB0@MWHPR11MB1327.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(136003)(346002)(366004)(376002)(396003)(4326008)(81156014)(107886003)(52116002)(54906003)(8676002)(478600001)(8936002)(6506007)(5660300002)(6512007)(36756003)(8886007)(86362001)(316002)(6486002)(1076003)(2616005)(4744005)(186003)(2906002)(66574012)(6666004)(66556008)(16526019)(66946007)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dViXQkS0VuxntBvbUWkqRT4blSsR0qNqSI3IfrgG/EVLjr2+9yvHhXFslqx3YIBm2xtK88EdpT2DZuL8QCdqEsGnXTEIxgbDdHYG4tNs5DEpI6qZeXBCBtJKz0vzAjP2l8PAMEf30sJVC4CwgVho3N4gB1FinA0tuCbaNbM2TBgz5bxFckJg/pZRe4QVcWY4osKr1ExaZr0QuOC2Ax1mrkoN+oV56E7gFfvoxrf6Q/Hyh8uRRsLthwDqDveC/M5F2YvkqQhG742hkSAibn5y4hkkaTyi65/P+HxE/g+Bxm/Bce6XMBEJEobqGfSZnmDEtvnpt9P/+ZrHKk69x9GeS+MUAPeNRILYmUK3X2flZguFwndh12rfw6WMF0nNeX3UZFJwBsveXYblIWZ38sYs/jP9955PNBC0Bsm7YQ3Sl6NK8MhBwqlskDtM7cP5Fm8v
X-MS-Exchange-AntiSpam-MessageData: 5y2aEezPkh1X+OS0XKavQqDgbAJyyDvyjFO6Ee9PXd+D2n3a6GZKFK+5vUcAafn3e/Hwi4CjpjSHIFi2zm1YvOCANjxQ3ArLL325zqLbp3mq0Su/+FSBJJq3m5tmgWj+qfh+2DxFedTRohsskixTX6TWFfdEZ4PKLfLlGxOZH0jBUcfcz512Fs17daJX3d8uw0NUbK0LqBhY89uViojQ7A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8981bb6d-dc74-4ba9-cbe7-08d7e157dd1d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:58.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNb6VtJBtn/KjTBgsDnREvSEVLeqUIA70mqOgORT4Thofx/52rVL6cX2q1554WLLUwrFSgy46POKeHyeOsN/Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbWFj
ODAyMTEgZXhwbGljaXRseSBjYWxsIHdmeF9jb25maWd1cmVfZmlsdGVycygpIGJlZm9yZS9hZnRl
ciBzdGFydGluZwpBUC4gVGh1cywgaXQgaXMgbm90IG5lY2Vzc2FyeSB0byBjYWxsIHdmeF91cGRh
dGVfZmlsdGVyaW5nKCkgZnJvbQp3Znhfc3RhcnRfYXAoKS4KClNpZ25lZC1vZmYtYnk6IErDqXLD
tG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCmluZGV4IDFjY2Q0MGEzMzIyZi4uNjlhNTgyM2FmMjg0IDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAg
LTU3OSw3ICs1NzksNiBAQCBpbnQgd2Z4X3N0YXJ0X2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCiAJd2Z4X3VwbG9hZF9rZXlzKHd2aWYpOwog
CXd2aWYtPnN0YXRlID0gV0ZYX1NUQVRFX0FQOwotCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYp
OwogCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHd2aWYpOwogCWhpZl9zdGFydCh3dmlmLCAmdmlm
LT5ic3NfY29uZiwgd3ZpZi0+Y2hhbm5lbCk7CiAJcmV0dXJuIDA7Ci0tIAoyLjI1LjEKCg==
