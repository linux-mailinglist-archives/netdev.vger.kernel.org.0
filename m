Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766DF1B2FC3
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDUTF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:05:29 -0400
Received: from mail-eopbgr70113.outbound.protection.outlook.com ([40.107.7.113]:49070
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbgDUTF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:05:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEz4pxXe+1CgL1ov6ak5ZDQuQTLwH44PM2Olkrayks0TB0rKPpkRQE25S4kN1viUQi2qaEQKK9hCGFsPMvyI31Iv7H5cZ8eq6O2Y3Cz6YJk+t6wjUnpzJhSLd18favywRQCDPe2MsmIvt7cK1RypozGdSpqZeIu3tubvqAhWFIUtKdTi17iTAw97g0f/Pf5nJfZj2F3UYda2SAl1NYeaAiIaI9b1WHYWUqlcn13rztZXrjQN7NHwY4PaDwvO/GhBwnD+u6yJGgmwtb6Pr7AuVh6e/Iu5X1iK5IwGpvQy5oFphFsqzPQx508K/5kZ08U9PAehmBY98L8JVjqSOB8o5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DO3PvynUqnachKn/1Ug4qa5nGEgPoC/yrHRLag/G26s=;
 b=DvrQ4a1OPkouZ9yhNyJ1l6c2xnv5GeAksNZgJ67/G31DPOh4R0yGZVDZFRJ2zFffXVC3eCRaDJID97qm02jXUKOf6yolYip5EdQkrFbOpP7HyjYYF47mMZ1sdUBw6+sbJw2p5KHjcgv08XkdFXS9JJe2qJCh6x3tM4bwJ8SJ3zdd4KjXzhJ+eV2uzndofSm6XmgedUxKtQWnDCV91LV9TmI3SlfJ6VXeA9QKFbzqtlipAl0pEOx26ij2JuAQ8MXoi3sFDRdfbA9I2sW8YgPIaiEny0hvMLz1RJhuN1nksF5K0p8tV3suASzuen/k4sIxiBsF/opCulxWHyI7Oz61qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DO3PvynUqnachKn/1Ug4qa5nGEgPoC/yrHRLag/G26s=;
 b=JN2uKl/5MEt7gmJ3h5QrwaPl1ZM2PSup8wpx9qh7+mEBDXhbDO5J372yWix6oXpnp/kqBp3mLc3A7YyzDx4jhLzSusvZnQ1DtH9222BTKTBfZ34336yoDI6rMh7nAD9zSa+Vku+puiLF4sf++8Z+4wFO8pGG9wahEm11xpxyGgE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3548.eurprd07.prod.outlook.com (2603:10a6:7:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.11; Tue, 21 Apr
 2020 19:05:20 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526%6]) with mapi id 15.20.2937.011; Tue, 21 Apr 2020
 19:05:20 +0000
From:   =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 2/2] sctp: Fix SHUTDOWN CTSN Ack in the peer restart case
Date:   Tue, 21 Apr 2020 22:03:42 +0300
Message-Id: <20200421190342.548226-3-jere.leppanen@nokia.com>
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
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by HK2PR02CA0139.apcprd02.prod.outlook.com (2603:1096:202:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 21 Apr 2020 19:05:14 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9e9de27-e385-4b96-9cab-08d7e626eeb6
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3548:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB35481F753EA0E2C60342F055ECD50@HE1PR0702MB3548.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:78;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(2906002)(26005)(8676002)(186003)(6666004)(1076003)(4326008)(66574012)(16526019)(6486002)(6506007)(478600001)(36756003)(316002)(66476007)(66556008)(52116002)(86362001)(66946007)(8936002)(2616005)(956004)(81156014)(110136005)(6512007)(5660300002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SUSVi7Mrx2Zf/HYkWMvRvWt/tZbxCKMtoFUwa6MLihJgqxxZWWYfmIgfW12bed94p16B0c2kBHF3U7vZs81PqB6/84RE5V6R5MPkbE9KmrzeEPhM9xbyRj8CSaDX/oVc3KnzIcLYwvx79kIM13k7C+taXz5BVmF4vgRM/xHL3XlulpPyPGeZD0b6+ion7SAPpQQMwK0e+AD5xtvgwlv0aDGjz0bimi/lI1XM+YfwbFeTKxm6XPaghtAd6zFEZTcefpE6D1cgidQZ90qAbXs6D5VK76juvm4YQvgVyTZpWrvhgRzUTwihVQXC0pNY6Yb8Hha3IyZOdtI0FZ7ttBBMW57aYnaT6JcLMhDu0p+gPoNKJKP5mSOoYgf4w/vpZ4Lbp2g3PKwOmyN3rA4iaIrCbXaBJDGTbg+P3mtHPEa7ShSX2FHH9RhyFTf3LVhVbUo
X-MS-Exchange-AntiSpam-MessageData: +vzS30qofr/ohOAeDcnXboB7wrh2MKK0NSCMO2O1lacZICr7QTdYN9qLoAnFYJfwcOukrfEBkl0+wb2O52I7PGtcp6gi8NZJNx4cYTY+Kgw73rqGh1Hos8K5FEia2cp6ZHVFhtN0y1nnz58gWMkvpfHH5SUzIURWIdsvqqlAoIgAERAs4hyjLu9GUhDTOMBU/R4RSkqeTJMCpRA1cQkLzzzegOFWWuWNfNFZ4x76W5jc1SY8Lp/AGGiXzSdb8AqnfT+jGWMevXJ8ytMp4DYK+ouFNXdKNIdgbCRepR6+SrH1Fg4BpmeEuq3jLUUccMDij6VJDMxa5UkFN1ZxHCtmV2iFEPbxacX5apVss4UpugKjUlB+qkFQj3bEAOY3YpMRY+9XE0YnjAnaavVFblNxCIBK3x/lJRRyF+BkQxJu3gzpLr3eP+k7+zEnNz63Q2PEmh/95ofoNG8HT7ZUgxLFEII/DGEScVCMSHKESNvC/gSkousZvERYJ7ewJ2cjP9p9raXuFuiV74FFjNlFG26ys0xX4JY04+qhff+RDfD3SydD8WH/r0usL7F+uMxB4RLXuATyQn56nxTK+mjNYFi7Cu5mEinolRqMLwJ9HTtCxo8fIlxOwq/8aSRm8tHoV4nxz7pOoURkFYN7M3IvebhPvnGpUfpLkUKwm6EUFKKejXzw4kUQ/e5fsIB7lrw1rfIQRpDHf/CXiRmY8pGdFEaL9AMUNxWmqc5jn2WttSedkQ5hxI/GsMT7OXOqq83mvqmXLX5v15GYG13O8NFfePCltzV/dfne0XgFTxuBsnUycTk=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e9de27-e385-4b96-9cab-08d7e626eeb6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 19:05:18.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSBHQEPRJt6y40ul1hU8uH1FJkS157itnn838io4b2X6FllRnK86lIQ8PFGHDo+AkUdpQcukcsws8ra8lR07lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3548
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiBzdGFydGluZyBzaHV0ZG93biBpbiBzY3RwX3NmX2RvX2R1cGNvb2tfYSgpLCBnZXQgdGhl
IHZhbHVlIGZvcgpTSFVURE9XTiBDdW11bGF0aXZlIFRTTiBBY2sgZnJvbSB0aGUgbmV3IGFzc29j
aWF0aW9uLCB3aGljaCBpcwpyZWNvbnN0cnVjdGVkIGZyb20gdGhlIGNvb2tpZSwgaW5zdGVhZCBv
ZiB0aGUgb2xkIGFzc29jaWF0aW9uLCB3aGljaAp0aGUgcGVlciBkb2Vzbid0IGhhdmUgYW55bW9y
ZS4KCk90aGVyd2lzZSB0aGUgU0hVVERPV04gaXMgZWl0aGVyIGlnbm9yZWQgb3IgcmVwbGllZCB0
byB3aXRoIGFuIEFCT1JUCmJ5IHRoZSBwZWVyIGJlY2F1c2UgQ1RTTiBBY2sgZG9lc24ndCBtYXRj
aCB0aGUgcGVlcidzIEluaXRpYWwgVFNOLgoKRml4ZXM6IGJkZjZmYTUyZjAxYiAoInNjdHA6IGhh
bmRsZSBhc3NvY2lhdGlvbiByZXN0YXJ0cyB3aGVuIHRoZSBzb2NrZXQgaXMgY2xvc2VkLiIpClNp
Z25lZC1vZmYtYnk6IEplcmUgTGVwcMOkbmVuIDxqZXJlLmxlcHBhbmVuQG5va2lhLmNvbT4KLS0t
CiBuZXQvc2N0cC9zbV9tYWtlX2NodW5rLmMgfCA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NtX21h
a2VfY2h1bmsuYyBiL25ldC9zY3RwL3NtX21ha2VfY2h1bmsuYwppbmRleCAwOTA1MGMxZDU1MTcu
LmY3Y2IwYjdmYWVjMiAxMDA2NDQKLS0tIGEvbmV0L3NjdHAvc21fbWFrZV9jaHVuay5jCisrKyBi
L25ldC9zY3RwL3NtX21ha2VfY2h1bmsuYwpAQCAtODU4LDcgKzg1OCwxMSBAQCBzdHJ1Y3Qgc2N0
cF9jaHVuayAqc2N0cF9tYWtlX3NodXRkb3duKGNvbnN0IHN0cnVjdCBzY3RwX2Fzc29jaWF0aW9u
ICphc29jLAogCXN0cnVjdCBzY3RwX2NodW5rICpyZXR2YWw7CiAJX191MzIgY3RzbjsKIAotCWN0
c24gPSBzY3RwX3Rzbm1hcF9nZXRfY3RzbigmYXNvYy0+cGVlci50c25fbWFwKTsKKwlpZiAoY2h1
bmsgJiYgY2h1bmstPmFzb2MpCisJCWN0c24gPSBzY3RwX3Rzbm1hcF9nZXRfY3RzbigmY2h1bmst
PmFzb2MtPnBlZXIudHNuX21hcCk7CisJZWxzZQorCQljdHNuID0gc2N0cF90c25tYXBfZ2V0X2N0
c24oJmFzb2MtPnBlZXIudHNuX21hcCk7CisKIAlzaHV0LmN1bV90c25fYWNrID0gaHRvbmwoY3Rz
bik7CiAKIAlyZXR2YWwgPSBzY3RwX21ha2VfY29udHJvbChhc29jLCBTQ1RQX0NJRF9TSFVURE9X
TiwgMCwKLS0gCjIuMjUuMgoK
