Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3121DB7E6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETPQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:16:17 -0400
Received: from mail-eopbgr130124.outbound.protection.outlook.com ([40.107.13.124]:62869
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbgETPQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:16:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCHvAwqlDu1e6OmiRYXUC9gBx9h2IVmgBZRig6ztfU3OVmFFCSsp5mcVuP9vJ9D4+8Pm7XPaiXRodLJZeqQMt6ZR5sy8jtH3PnfRsR/lWyqielRIYGX/mwkTrLk4TPYM7gNt72RG/5LRlP5XJmeSIUBgwWa+U0cttIoadwIVq7aMUIp0sebLJ3gjc/AmxXOCG/7j4wt4lgzBHwyScw0yLj9ihBlLZD3i2ZDC+nksJh9HosQxOvqEhf7/dnjaLPK65if1xG2Hhx3Nd8MzK14oLO8M2r11MsI/tcOpwRLTBRDuFHyhp5S81aLMyUTN1PyVQXQoz6r48RV0MWhEuribvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTMD0v90qI8kCO/P10kk/BYnv0+Vfyc5msL36SW+emQ=;
 b=Ny+nJh6HOya52csRcKyjCR4l9iUKFKSUzrhdKKepI5FRX6BQTq7idv15uiyiY0/9aTQwYq+LOMEFCG8GHeCjKzHfqihHUIDMWLtM6SiSWii16tQ5X+08GO6D9bHwdcYGAkuYusFKzRMPaJ5MHP/J7zV9ptMFBp6F59lWYIQXReeX/ry1dWYEMGW7IQtXOhLrcjfWTClyihQXPvOEf7VwI5WW7J0v5r0ExzAQzAE8rTq2xW1SeCVlMU2Fjs3uiAsUbUwXc11MtlE+BX3qTMAe6xqXs7Cl0TaJ2+//gZ4+nhUa8hv++yb3UDHv8sXWJoPsjG0SChfGF0YyQytzQyYXFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTMD0v90qI8kCO/P10kk/BYnv0+Vfyc5msL36SW+emQ=;
 b=aOi5vVDEF2lmA5dkEd41e9l0NUPNfyj00489gwlH4+9RdxHGTEelCpL9yUL7xmpaVHUpeYroOv/1+Zk2Wd/W1cq2D0mpajUQ1dgvWEluG+RmTcAcPiJZkXLQ3jHE+EarxyUWRVPG+P/ZxM5GXsvNLp+TDaaymzPUu3ET1Mhxv90=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3577.eurprd07.prod.outlook.com (2603:10a6:7:7f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.13; Wed, 20 May
 2020 15:16:13 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526%6]) with mapi id 15.20.3021.019; Wed, 20 May 2020
 15:16:13 +0000
From:   =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     David Laight <David.Laight@aculab.com>
Subject: [PATCH net 1/1] sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed
Date:   Wed, 20 May 2020 18:15:31 +0300
Message-Id: <20200520151531.787414-1-jere.leppanen@nokia.com>
X-Mailer: git-send-email 2.25.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: HE1PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:7:28::16) To HE1PR0702MB3818.eurprd07.prod.outlook.com
 (2603:10a6:7:8c::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by HE1PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:7:28::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 15:16:12 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1de3b3c2-1569-4bc9-280e-08d7fcd0bba7
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3577:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3577A0CA76CB7F2367526143ECB60@HE1PR0702MB3577.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTuEzR35wclnuR2X+AaXcrVuj188FIquYu7dM3rtO0xsyltUrkcGB4XiQC457LJkPuDdq9v4yIvXGVOpFbJcSvxQFOlcQ3u4upQ5uXxKkCMSB6bzyTELH9PmanOINWM1KHloigP4TqvrCupUrybs+y2loU2d38aiqBYsfKI/1NXl8ixbewJk1eWAGJmE2pWV5OpgHbquFYDgiMAmXzOXIvUv9PoAxT/xF/xsL4ViQ9YJvjSL5K1QEQP38Mn+6bkAYVhPf+mRjigIL+3CxlYbr2T5bamq14Bl9LeYfXhRFP44yG47zaeyPT7u8Z2Lmtx/ijYx49XlhNeyeAzZ1VGiGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(8676002)(1076003)(66574014)(8936002)(4326008)(478600001)(52116002)(26005)(186003)(6506007)(16526019)(6486002)(2616005)(66946007)(36756003)(6666004)(110136005)(2906002)(6512007)(316002)(86362001)(956004)(66556008)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 96gy29sPC0wQRODIpAs6i0rjJUFD/8ETzjjdFFvYT6fLiU/ejvEn+W+rc+TG+K0DwVqP9YXpJom61IhhSm/+f9bP8tuzGI8gMIlcnETksmHZHPJ8oM667btsGRBEfNy78o7UAVl5j1iSHJ4KH1IWvCZ0lE1/JubIBP5dXhLuJasWSAqsOJVgsSLYv4o26X8B+7eosnpQrrDsx96/WE+PsywSbCS3+vwU/xgLW433pikglHnl6QiVq1Cb7yeec1zu1yTJsuljQR1Lj1405/L+isq3QgyGlOxTs5RwgH+r8Yv/x4ayv/S0JKnxDsdy5CAQ7WHEW/rYx9JVOn4nXTPuZeyc30Oo5JxwUn4WVwMt1xT98ZfaOqI0HpzfHgtrXGsY46WK3MW+rCw7OeTxXkqAxSsd/moZ2hotbyp1nLuvIiDnkWBwDNAZCFO9ytRVzstzP6mPvA7baKBz0Zm2T5HGGwP7QEC8pZO+LtI/w/QsYwQ=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de3b3c2-1569-4bc9-280e-08d7fcd0bba7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 15:16:12.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nl5oq1BHNQIstsb6cYfD5HqmPIBQM9jSgwVtSnQ1kFWxn4Wh6IlNB40QZvwM/9a8gvrW56x/WYflE68VRSWvjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3577
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tbWl0IGJkZjZmYTUyZjAxYiAoInNjdHA6IGhhbmRsZSBhc3NvY2lhdGlvbiByZXN0YXJ0cyB3
aGVuIHRoZQpzb2NrZXQgaXMgY2xvc2VkLiIpIHN0YXJ0cyBzaHV0ZG93biB3aGVuIGFuIGFzc29j
aWF0aW9uIGlzIHJlc3RhcnRlZCwKaWYgaW4gU0hVVERPV04tUEVORElORyBzdGF0ZSBhbmQgdGhl
IHNvY2tldCBpcyBjbG9zZWQuIEhvd2V2ZXIsIHRoZQpyYXRpb25hbGUgc3RhdGVkIGluIHRoYXQg
Y29tbWl0IGFwcGxpZXMgYWxzbyB3aGVuIGluIFNIVVRET1dOLVNFTlQKc3RhdGUgLSB3ZSBkb24n
dCB3YW50IHRvIG1vdmUgYW4gYXNzb2NpYXRpb24gdG8gRVNUQUJMSVNIRUQgc3RhdGUgd2hlbgp0
aGUgc29ja2V0IGhhcyBiZWVuIGNsb3NlZCwgYmVjYXVzZSB0aGF0IHJlc3VsdHMgaW4gYW4gYXNz
b2NpYXRpb24KdGhhdCBpcyB1bnJlYWNoYWJsZSBmcm9tIHVzZXIgc3BhY2UuCgpUaGUgcHJvYmxl
bSBzY2VuYXJpbzoKCjEuICBDbGllbnQgY3Jhc2hlcyBhbmQvb3IgcmVzdGFydHMuCgoyLiAgU2Vy
dmVyICh1c2luZyBvbmUtdG8tb25lIHNvY2tldCkgY2FsbHMgY2xvc2UoKS4gU0hVVERPV04gaXMg
bG9zdC4KCjMuICBDbGllbnQgcmVjb25uZWN0cyB1c2luZyB0aGUgc2FtZSBhZGRyZXNzZXMgYW5k
IHBvcnRzLgoKNC4gIFNlcnZlcidzIGFzc29jaWF0aW9uIGlzIHJlc3RhcnRlZC4gVGhlIGFzc29j
aWF0aW9uIGFuZCB0aGUgc29ja2V0CiAgICBtb3ZlIHRvIEVTVEFCTElTSEVEIHN0YXRlLCBldmVu
IHRob3VnaCB0aGUgc2VydmVyIHByb2Nlc3MgaGFzCiAgICBjbG9zZWQgaXRzIGRlc2NyaXB0b3Iu
CgpBbHNvLCBhZnRlciBzdGVwIDQgd2hlbiB0aGUgc2VydmVyIHByb2Nlc3MgZXhpdHMsIHNvbWUg
cmVzb3VyY2VzIGFyZQpsZWFrZWQgaW4gYW4gYXR0ZW1wdCB0byByZWxlYXNlIHRoZSB1bmRlcmx5
aW5nIGluZXQgc29jayBzdHJ1Y3R1cmUgaW4KRVNUQUJMSVNIRUQgc3RhdGU6CgogICAgSVB2NDog
QXR0ZW1wdCB0byByZWxlYXNlIFRDUCBzb2NrZXQgaW4gc3RhdGUgMSAwMDAwMDAwMDM3NzI4OGM3
CgpGaXggYnkgYWN0aW5nIHRoZSBzYW1lIHdheSBhcyBpbiBTSFVURE9XTi1QRU5ESU5HIHN0YXRl
LiBUaGF0IGlzLCBpZgphbiBhc3NvY2lhdGlvbiBpcyByZXN0YXJ0ZWQgaW4gU0hVVERPV04tU0VO
VCBzdGF0ZSBhbmQgdGhlIHNvY2tldCBpcwpjbG9zZWQsIHRoZW4gc3RhcnQgc2h1dGRvd24gYW5k
IGRvbid0IG1vdmUgdGhlIGFzc29jaWF0aW9uIG9yIHRoZQpzb2NrZXQgdG8gRVNUQUJMSVNIRUQg
c3RhdGUuCgpGaXhlczogYmRmNmZhNTJmMDFiICgic2N0cDogaGFuZGxlIGFzc29jaWF0aW9uIHJl
c3RhcnRzIHdoZW4gdGhlIHNvY2tldCBpcyBjbG9zZWQuIikKU2lnbmVkLW9mZi1ieTogSmVyZSBM
ZXBww6RuZW4gPGplcmUubGVwcGFuZW5Abm9raWEuY29tPgotLS0KIG5ldC9zY3RwL3NtX3N0YXRl
ZnVucy5jIHwgOSArKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMgYi9uZXQv
c2N0cC9zbV9zdGF0ZWZ1bnMuYwppbmRleCAyNjc4OGY0YTNiOWUuLmU4NjYyMGZiZDkwZiAxMDA2
NDQKLS0tIGEvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMKKysrIGIvbmV0L3NjdHAvc21fc3RhdGVm
dW5zLmMKQEAgLTE4NTYsMTIgKzE4NTYsMTMgQEAgc3RhdGljIGVudW0gc2N0cF9kaXNwb3NpdGlv
biBzY3RwX3NmX2RvX2R1cGNvb2tfYSgKIAkvKiBVcGRhdGUgdGhlIGNvbnRlbnQgb2YgY3VycmVu
dCBhc3NvY2lhdGlvbi4gKi8KIAlzY3RwX2FkZF9jbWRfc2YoY29tbWFuZHMsIFNDVFBfQ01EX1VQ
REFURV9BU1NPQywgU0NUUF9BU09DKG5ld19hc29jKSk7CiAJc2N0cF9hZGRfY21kX3NmKGNvbW1h
bmRzLCBTQ1RQX0NNRF9FVkVOVF9VTFAsIFNDVFBfVUxQRVZFTlQoZXYpKTsKLQlpZiAoc2N0cF9z
dGF0ZShhc29jLCBTSFVURE9XTl9QRU5ESU5HKSAmJgorCWlmICgoc2N0cF9zdGF0ZShhc29jLCBT
SFVURE9XTl9QRU5ESU5HKSB8fAorCSAgICAgc2N0cF9zdGF0ZShhc29jLCBTSFVURE9XTl9TRU5U
KSkgJiYKIAkgICAgKHNjdHBfc3N0YXRlKGFzb2MtPmJhc2Uuc2ssIENMT1NJTkcpIHx8CiAJICAg
ICBzb2NrX2ZsYWcoYXNvYy0+YmFzZS5zaywgU09DS19ERUFEKSkpIHsKLQkJLyogaWYgd2VyZSBj
dXJyZW50bHkgaW4gU0hVVERPV05fUEVORElORywgYnV0IHRoZSBzb2NrZXQKLQkJICogaGFzIGJl
ZW4gY2xvc2VkIGJ5IHVzZXIsIGRvbid0IHRyYW5zaXRpb24gdG8gRVNUQUJMSVNIRUQuCi0JCSAq
IEluc3RlYWQgdHJpZ2dlciBTSFVURE9XTiBidW5kbGVkIHdpdGggQ09PS0lFX0FDSy4KKwkJLyog
SWYgdGhlIHNvY2tldCBoYXMgYmVlbiBjbG9zZWQgYnkgdXNlciwgZG9uJ3QKKwkJICogdHJhbnNp
dGlvbiB0byBFU1RBQkxJU0hFRC4gSW5zdGVhZCB0cmlnZ2VyIFNIVVRET1dOCisJCSAqIGJ1bmRs
ZWQgd2l0aCBDT09LSUVfQUNLLgogCQkgKi8KIAkJc2N0cF9hZGRfY21kX3NmKGNvbW1hbmRzLCBT
Q1RQX0NNRF9SRVBMWSwgU0NUUF9DSFVOSyhyZXBsKSk7CiAJCXJldHVybiBzY3RwX3NmX2RvXzlf
Ml9zdGFydF9zaHV0ZG93bihuZXQsIGVwLCBhc29jLAoKYmFzZS1jb21taXQ6IDIwYTc4NWFhNTJj
ODIyNDYwNTVhMDg5ZTU1ZGY5ZGFjNDdkNjdkYTEKLS0gCjIuMjUuMgoK
