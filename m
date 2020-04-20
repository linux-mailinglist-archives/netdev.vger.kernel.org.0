Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12E91B10FC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgDTQEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:04:24 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:58834
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729710AbgDTQEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MExWu/qY9IvU5qoSY25HcYgSBGny0vDk0w0QadxJxCEQMbasC4PcB23PTfUbmsmDEZ9XGQHB6S7agulGNJA1zxPkzXTn7xh85Edz0HkMmxjvjKD3g60lRJ5NAZXy8t4uzAPKSTUbI6qKURrUlrVDxqx3Apu72EYhx4NUdQoLiCBGDNQnt/5kwo2A98dTygUF+dLgT7xiy8GndZAsXwEXOO0SqYkHGIR2edbnv5II/JZZM8WCDORUBC7vhxBoFy73/O/8wCsJDQnppXGYbsPQ0sfvxJtSU8cVLQzc7Kea8/4rWlHXh3ZxApRgkcSYfbOyKkylw6L53hptDZznr9O9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DURtoK7Eo/KOt2TOBS3HLim3hNZQVHhh43H5x2GAUvo=;
 b=exbhzELWKN7hhBPh4Rz7AjxHWIJMF+U1pKcyHz0Glw2HKDTjMZxjtdY9lVNrFwaoj64x33lm8ztAdG+iSilr2ypeBa++aYBgAxIsGbBega45lnhJ8HDLqDkPnTcrfAbUftVNqbyGUZAgTdP7v0/ok5UOplWpJM5McIb7C3PDT905vy/fcXVTpuXtf1iBrZVOLsq+ifcn8u3YZ8D5zzhC+p4LNDH+re8+3MO3pd+55OgPfPLKgr7FRu7rGLIGMvRIYnxiR6hjJ2wmAOniJyoFdLxSHQ44NoQtq0lTnfHZ2i6rUA3h6syoy2pFjjm8OYfaH5YHq8T0oWoaXxYR4W7/IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DURtoK7Eo/KOt2TOBS3HLim3hNZQVHhh43H5x2GAUvo=;
 b=g8eUQ3z5xYOm92twCWDkWwNDxgrygID4zrYbJULAArgEHOCbbis0Mct8LrDJsklko0j+HjKONr2vEHSibp0Ss0YvUt3szo1c7OZeb62alQe7j4Fub3IYwgXZZ5HXXxbGWhxFYlcQ03dnNeCF0vvuVZgMo3QsT4go/9DOogQPuPU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:03:57 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:57 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/16] staging: wfx: drop useless checks in wfx_do_unjoin()
Date:   Mon, 20 Apr 2020 18:03:08 +0200
Message-Id: <20200420160311.57323-14-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:55 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0046ccdc-f3a6-41c9-99a9-08d7e5446e90
X-MS-TrafficTypeDiagnostic: MWHPR11MB1792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1792B1F0C21060A351A47DD493D40@MWHPR11MB1792.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(346002)(376002)(366004)(396003)(136003)(66476007)(66556008)(186003)(66946007)(4326008)(86362001)(4744005)(16526019)(107886003)(6666004)(81156014)(7696005)(478600001)(52116002)(8676002)(66574012)(54906003)(316002)(6486002)(1076003)(2616005)(36756003)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MCXO44sGTc7ItFqXhccfQ5FLRj0q8yOg4QtBxxTOXlMAG6Td8bQAAasXdsznPZXWxfh52cMaZpP+cEiMBu4oElWhK1ZeZH61W0YOufUm6/j0tU9j4gC4Gk2H6PVN8GoICbjFwV0Ayt80yHlRsSo+fz9O+2rCjOlgOnDgp+TDh9KozLAZRI5QV4H9c2sTPXjbrCstzOQpzXwjw7raO+odJDW8uMxVtbTuEUGtxD219VZxR9ILFC5lVCVZFseFBFbFo4HnFEUpVY0TVQEuStjeFdjn9Uq4hQ1rJEGWXNRGaxeUytGOc9uuqdL/sXyb59UDzawgmjAqUWGqZgQLK4cqP788JssRxj8XDBMTCfRdgu36W4TJ/UIwm8jMDPF3GRM60+21OJMgUUbtv4P3WDCeglGc4j+VoO4vqmiQ8X+YzVM4TcK8RR/9fmjKNZNvXDsy
X-MS-Exchange-AntiSpam-MessageData: 2L65xFSs9gGcpRE87XR7DFRt7htDr8UWSwRIvZYC/eUeJ4VXchld1EypyngKnbN1YtCyV3qEqgrYepm6huTAY/q41tu5CmoIyIUuOg2+VcSOEwLpZe20kP4H0dMcOlnxD3gBPsBgbOw9TpfBv7fyXda4jm+3KVjLJ1BzL2np7ZpRu8q2G/GJoRBfZJhXKJHPW4Z2DjDPjiDYBi6774c8Ii/jmi/BYNZw5h6Rds+7uadQzoQH/sTZMjLURblSIXgNrIrqQ7tBiQ67G7RL3KMI3bKmu8Z2Soum3d+4luYJyD2B7yVaT54K7zw555Ba4UVJR+RAXAIGn+Yb2DbI3ZE0G/wnlWMWdHeK+f81GATuBEhJkoQ1N1S0V/+vIzJTw5NIYiH2HPrt6j8V8z+8A1JS5ehHg0JtLliiST3K4lhP1iKp93aDh3dV+ly1IqwW5HQE5zAcBzWLDzAXefmxFgjoYqscoIFiF0GHFBjWohyxX/XU62lnuG7EBg9efkQefBz0CrFHyA6GfmUhzd26lEtJwIkxShGbxaE+GxKx2EQh+9AlUTn6OQBcehbdGWEmYr5yyD647tdb+fjfbHjo78HHymQ/npzIOpLFtGsE13gLSoTabn34tgYl70qRwHrAHF+69EKtN+XwzY88smIWfJswyruTqrnZzuY9M2+nNgetq0dXKe4y5CBE8gsunqc2LRLgEBP6htZT/jiQnbnUIufz3KAgVaZwvMoql8PKMd1fCryioasOr2P9i0GgAb8gbH8XvHQJ3enLUBZhIHG+uuDeOClovmSPaubbvSoHDhlSqotpE1OidJngmCJNEznNnkInQxVxScMkIBpGsCnubthxSUb7Jn30R5Wo6wNZBlaFKZ4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0046ccdc-f3a6-41c9-99a9-08d7e5446e90
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:57.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yz7mZRQeVWsGF6FpiessTpCAjKx+uV6IyNokODaP6Z/yrv49l3Cdwwsvkt5tG3dbhM83qPm15lqLC5mpmv9IRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGNhbGxlcnMgb2Ygd2Z4X2RvX3Vuam9pbigpIGFscmVhZHkgdGFrZSBjYXJlIG9mIHZpZiBzdGF0
ZS4KVGhlcmVmb3JlLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRvIHRha2UgY2FyZSBvZiB0aGUgc3Rh
dHVzIG9mIHRoZQppbnRlcmZhY2UuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YyB8IDYgLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpp
bmRleCA1NmNiNmZmZjRhMDYuLmJjODkxYjZlNDM5MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0yODYsMTIg
KzI4Niw2IEBAIHZvaWQgd2Z4X3NldF9kZWZhdWx0X3VuaWNhc3Rfa2V5KHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LAogLy8gQ2FsbCBpdCB3aXRoIHdkZXYtPmNvbmZfbXV0ZXggbG9ja2VkCiBzdGF0
aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogewotCWlmICghd3Zp
Zi0+c3RhdGUpCi0JCXJldHVybjsKLQotCWlmICh3dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVfQVAp
Ci0JCXJldHVybjsKLQogCXd2aWYtPnN0YXRlID0gV0ZYX1NUQVRFX1BBU1NJVkU7CiAKIAkvKiBV
bmpvaW4gaXMgYSByZXNldC4gKi8KLS0gCjIuMjYuMQoK
