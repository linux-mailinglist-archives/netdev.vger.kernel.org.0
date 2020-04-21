Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA441B2FC1
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDUTFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:05:25 -0400
Received: from mail-eopbgr70094.outbound.protection.outlook.com ([40.107.7.94]:21493
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbgDUTFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:05:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKVTKv0yzWVbE82X/EyJYY8VtWJpebeH8WJbATloPcRGkB/UWUAVrZgMXxdJzWGMkTA4/MyNHEn4hnAsjZb1EgItwNOtUyG1TTpJqR56soJMV+jpq8S1nlWy14SdPKzrMCQd5+M881THc3FAW4KWQrhRcjWaLy5xBX8iiFpQr9Y+FunwESrNTylh53yHeBjsB5hIeHp9u/NOjBSIKkgjlmdeYb4tDTDhw8pQoNULgFDpSonWEmQqUQv1BbjvPOKEc4fBL6X0fZ2wfgQNvtaJd77tNo6TBFEruQcClNxc9Kpvh20LmhYxwv2OrhiXpnfZpAdJHKFklWhSEXzMsf7Vjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJRqaEzDsWsWEPjdPrrYv7DTGXYXPrCBvMCAAnKGl/k=;
 b=B7UWk8ql0kANyohx4LGnYWi6H8CvtgQYF7c4AnhYX2Hy3d/OG7/U0dgZaCa3nxAkdKTk1SBDa8pqbpSm9itmn14Ni7n0uDJb5hPFUU4JUU8DvbuivcRAV+syCHRgLvO7k6NlZb4lpo+vzfwD7JgG9DTRGwnEH8Vfmhl/GugoNPUgbGEtApywds88rKdzvidD90T8hfC0H4BWYVwoHNiIdAT7N4hS9cbkYsEYpaBC1uRLWgC8n5jxjKcC6OMC6aFLteGXYEdh5jRAK2M3+XHKh0BU8cobGF9s14fPve76b7h4mqDA0ERIifde7WQaKy0767TcFLxzn/2J7tyudVyjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJRqaEzDsWsWEPjdPrrYv7DTGXYXPrCBvMCAAnKGl/k=;
 b=X+Bc7ebhTNp6a3eOqcBTPmaiSR7BTOFCU0E94+y1wl6EeNeBhUETYdWqAjGmN93IYDGpF3Nx3hr7/htzZBgkBX+Mp3GPrn2gltwd0Y2HZcoE1tzVBVpwZG6l+szOKOOt68ro536m8bYz6U9Z3v1Wzr9plJod9niHpbVh+YdlwlU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3548.eurprd07.prod.outlook.com (2603:10a6:7:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.11; Tue, 21 Apr
 2020 19:05:02 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526%6]) with mapi id 15.20.2937.011; Tue, 21 Apr 2020
 19:05:02 +0000
From:   =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 1/2] sctp: Fix bundling of SHUTDOWN with COOKIE-ACK
Date:   Tue, 21 Apr 2020 22:03:41 +0300
Message-Id: <20200421190342.548226-2-jere.leppanen@nokia.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421190342.548226-1-jere.leppanen@nokia.com>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: HK2PR02CA0139.apcprd02.prod.outlook.com
 (2603:1096:202:16::23) To HE1PR0702MB3818.eurprd07.prod.outlook.com
 (2603:10a6:7:8c::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by HK2PR02CA0139.apcprd02.prod.outlook.com (2603:1096:202:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 21 Apr 2020 19:04:58 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c67acc41-c002-4720-4f0e-08d7e626e4dd
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3548:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3548E6F35407273ED2EDA502ECD50@HE1PR0702MB3548.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(2906002)(26005)(8676002)(186003)(6666004)(1076003)(4326008)(66574012)(16526019)(6486002)(6506007)(478600001)(36756003)(316002)(66476007)(66556008)(52116002)(86362001)(66946007)(8936002)(2616005)(956004)(81156014)(110136005)(6512007)(5660300002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yuYWTc+q9SUcXjmAxgAgTdM2YhHnsLi5L/iZ+vmlmmMHWWMUcyVr4EDrXqkD+13g2bV7tDqOy7x1N+qzmw7w+LCf/8srMxOPXJZeGRHjDG3RccU9qVQD226nMJI5YGetzMb/Tsqe86WxKMx7JdfrEKUFnbLY3Hc1dv3Cp8cQEzdjYGl7k4LkDms+yc+vP/c114ftdj+e33CX8dVy/kDQ076PicZanwFgqiJTcnzRWQ/KtVaWKAtF4kmgG76DyhMUQxLfEapz2VhD67+C5jAdP37H09gC6a4SOKAW41SvGRhd3aFXoWP5b0SCfmmy976JEvaCR9zZsZSBJ82j8WWa/YMTeNwikpbko+VTDRdAbs0mioRa1V5w5DV3Dk1pDBW7fJApli8gfCxqF27wmLv47f+Q/7wmI2/jMFU0XIjiOhXitYAS1/KepuYtCh8KSGuF
X-MS-Exchange-AntiSpam-MessageData: k90ZdVKpvrM4MVUSC+TAt/FDSv5ggVYKqTljjaaQ5vQl28g7G3jVoXEGNtpnSZBf6OuTNaAKDCNMWsn8TYIx2V1nlGxQ1XNCINoO23O23mEtNOcyjpswoYp2Aq2FIq+byaclYJNhyfxgv/o/W+JZdUQHlnsOfNf/6hCs2u0d+9TDMjS/piE4wPP94T8rLdky3K/UGb0631XM5aoS0QqGvcR0bqZfdkp8VHecDXuhgIONKLigsjiUKYa8DabBX7vR1PSdIXKd4cSgW41ld7P8T3GkMByFYmUDJk4EHw9bgYAg/K/jBB3HWryZZdRM/NudO5L9RLQhz/aqA4l5sLLsvMZtwReohvBPx9Sr8i/YjVSR+0wiT8h3ALdS3O7E/fil41TV6sePfoI2aMLaKJyJ0qyeEg/7cd5/pIy9nDSTQtrn44wTp1asomhXVT/p3eD2lQ9vWxmdFqjkrJk2PUiOyE0Zrh1OqVIQVEcguW+0UNI5Q3xrvposENnzYEfzvzeOz7p83KsaAGGNjnju1vmwXpMtE5wJjHdOSp9ClTpGyfRgjiC0lFFENLAjRDErLNk1ATquhALkv3avr8NILMOLQglutsKj9s8DndNqqZd+O4+QT3ninnOD0ZuYzQV2kO2HztjUgggbKtjBq90eL/Z1f6C/pq0iaG4ZAPxQ7moLLCV6rWCsf/Vcpg94a5hDsPklBAca7sjW4p6cL+2rnPv/tmNZpflSGY5cknvBSoa8hjXipFHoc0LSBWlMG5T7TovSzs4o8e62cg2o6Z2WAHDGsBZdFP7wGOzRf25qDq6rTXc=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67acc41-c002-4720-4f0e-08d7e626e4dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 19:05:02.2887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sUltKvSnrIA9nWhzmHLPIDbPyStVccPZNCZ/1xwkk+uPubfGPjGMDGCk+SaTj5VoaTyH+0Wpr4FYfB9rdIL+Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3548
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiB3ZSBzdGFydCBzaHV0ZG93biBpbiBzY3RwX3NmX2RvX2R1cGNvb2tfYSgpLCB3ZSB3YW50
IHRvIGJ1bmRsZQp0aGUgU0hVVERPV04gd2l0aCB0aGUgQ09PS0lFLUFDSyB0byBlbnN1cmUgdGhh
dCB0aGUgcGVlciByZWNlaXZlcyB0aGVtCmF0IHRoZSBzYW1lIHRpbWUgYW5kIGluIHRoZSBjb3Jy
ZWN0IG9yZGVyLiBUaGlzIGJ1bmRsaW5nIHdhcyBicm9rZW4gYnkKY29tbWl0IDRmZjQwYjg2MjYy
YiAoInNjdHA6IHNldCBjaHVuayB0cmFuc3BvcnQgY29ycmVjdGx5IHdoZW4gaXQncyBhCm5ldyBh
c29jIiksIHdoaWNoIGFzc2lnbnMgYSB0cmFuc3BvcnQgZm9yIHRoZSBDT09LSUUtQUNLLCBidXQg
bm90IGZvcgp0aGUgU0hVVERPV04uCgpGaXggdGhpcyBieSBwYXNzaW5nIGEgcmVmZXJlbmNlIHRv
IHRoZSBDT09LSUUtQUNLIGNodW5rIGFzIGFuIGFyZ3VtZW50CnRvIHNjdHBfc2ZfZG9fOV8yX3N0
YXJ0X3NodXRkb3duKCkgYW5kIG9ud2FyZCB0bwpzY3RwX21ha2Vfc2h1dGRvd24oKS4gVGhpcyB3
YXkgdGhlIFNIVVRET1dOIGNodW5rIGlzIGFzc2lnbmVkIHRoZSBzYW1lCnRyYW5zcG9ydCBhcyB0
aGUgQ09PS0lFLUFDSyBjaHVuaywgd2hpY2ggYWxsb3dzIHRoZW0gdG8gYmUgYnVuZGxlZC4KCklu
IHNjdHBfc2ZfZG9fOV8yX3N0YXJ0X3NodXRkb3duKCksIHRoZSB2b2lkICphcmcgcGFyYW1ldGVy
IHdhcwpwcmV2aW91c2x5IHVudXNlZC4gTm93IHRoYXQgd2UncmUgdGFraW5nIGl0IGludG8gdXNl
LCBpdCBtdXN0IGJlIGEKdmFsaWQgcG9pbnRlciB0byBhIGNodW5rLCBvciBOVUxMLiBUaGVyZSBp
cyBvbmx5IG9uZSBjYWxsIHNpdGUgd2hlcmUKaXQncyBub3QsIGluIHNjdHBfc2ZfYXV0b2Nsb3Nl
X3RpbWVyX2V4cGlyZSgpLiBGaXggdGhhdCB0b28uCgpGaXhlczogNGZmNDBiODYyNjJiICgic2N0
cDogc2V0IGNodW5rIHRyYW5zcG9ydCBjb3JyZWN0bHkgd2hlbiBpdCdzIGEgbmV3IGFzb2MiKQpT
aWduZWQtb2ZmLWJ5OiBKZXJlIExlcHDDpG5lbiA8amVyZS5sZXBwYW5lbkBub2tpYS5jb20+Ci0t
LQogbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9zbV9z
dGF0ZWZ1bnMuYyBiL25ldC9zY3RwL3NtX3N0YXRlZnVucy5jCmluZGV4IDZhMTZhZjRiMWVmNi4u
MjY3ODhmNGEzYjllIDEwMDY0NAotLS0gYS9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYworKysgYi9u
ZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYwpAQCAtMTg2NSw3ICsxODY1LDcgQEAgc3RhdGljIGVudW0g
c2N0cF9kaXNwb3NpdGlvbiBzY3RwX3NmX2RvX2R1cGNvb2tfYSgKIAkJICovCiAJCXNjdHBfYWRk
X2NtZF9zZihjb21tYW5kcywgU0NUUF9DTURfUkVQTFksIFNDVFBfQ0hVTksocmVwbCkpOwogCQly
ZXR1cm4gc2N0cF9zZl9kb185XzJfc3RhcnRfc2h1dGRvd24obmV0LCBlcCwgYXNvYywKLQkJCQkJ
CSAgICAgU0NUUF9TVF9DSFVOSygwKSwgTlVMTCwKKwkJCQkJCSAgICAgU0NUUF9TVF9DSFVOSygw
KSwgcmVwbCwKIAkJCQkJCSAgICAgY29tbWFuZHMpOwogCX0gZWxzZSB7CiAJCXNjdHBfYWRkX2Nt
ZF9zZihjb21tYW5kcywgU0NUUF9DTURfTkVXX1NUQVRFLApAQCAtNTQ3MCw3ICs1NDcwLDcgQEAg
ZW51bSBzY3RwX2Rpc3Bvc2l0aW9uIHNjdHBfc2ZfZG9fOV8yX3N0YXJ0X3NodXRkb3duKAogCSAq
IGluIHRoZSBDdW11bGF0aXZlIFRTTiBBY2sgZmllbGQgdGhlIGxhc3Qgc2VxdWVudGlhbCBUU04g
aXQKIAkgKiBoYXMgcmVjZWl2ZWQgZnJvbSB0aGUgcGVlci4KIAkgKi8KLQlyZXBseSA9IHNjdHBf
bWFrZV9zaHV0ZG93bihhc29jLCBOVUxMKTsKKwlyZXBseSA9IHNjdHBfbWFrZV9zaHV0ZG93bihh
c29jLCBhcmcpOwogCWlmICghcmVwbHkpCiAJCWdvdG8gbm9tZW07CiAKQEAgLTYwNjgsNyArNjA2
OCw3IEBAIGVudW0gc2N0cF9kaXNwb3NpdGlvbiBzY3RwX3NmX2F1dG9jbG9zZV90aW1lcl9leHBp
cmUoCiAJZGlzcG9zaXRpb24gPSBTQ1RQX0RJU1BPU0lUSU9OX0NPTlNVTUU7CiAJaWYgKHNjdHBf
b3V0cV9pc19lbXB0eSgmYXNvYy0+b3V0cXVldWUpKSB7CiAJCWRpc3Bvc2l0aW9uID0gc2N0cF9z
Zl9kb185XzJfc3RhcnRfc2h1dGRvd24obmV0LCBlcCwgYXNvYywgdHlwZSwKLQkJCQkJCQkgICAg
YXJnLCBjb21tYW5kcyk7CisJCQkJCQkJICAgIE5VTEwsIGNvbW1hbmRzKTsKIAl9CiAKIAlyZXR1
cm4gZGlzcG9zaXRpb247Ci0tIAoyLjI1LjIKCg==
