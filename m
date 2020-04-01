Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A1019AA21
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732551AbgDALFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:31 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732441AbgDALFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD9YXgC8s5iH17VD0Q+uPsF+Za1tE0ewPMu3aL2PLMfc78Y3IDZdh2QBzIM0fEXRpupbKRyOsSdCBLeUM7VFVIVNBrydg8OSJeBiD3CWPQHryQSLmyP1TQPz2zjR8SRMTXuQJmQH2hrBSxtIB1Zffn9z5uAX0cnpMO/bqx16FqWTs5Hxq6zVn+qHrHG19DahzMPvLGTeXHtp1ShTlucIDiCBSI6kej+MOAthWovsUHTkUZES2c29JkMJkv3dYHohtpYjEdIZ1vs9LC4MIWs5OwHQOUdY7jSi6a0BDRX/iEeCCR3L5RnqMaXQHQ1Njf89R6/ospMk6gMROO1KDfp9/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4Swx1XSBETPQKAOKPk7/O84WzGRDzaHNgSGjmQRB2Y=;
 b=h8k/we5CAX42VywcNT5NdlKOEYBtD2sbgB0nmz9Qv2RjktXcZXLCsNdiUKDYGK2goU09Uuw3oyHlG5rcd3o6/AyFDnCBX/c3p8LG+CyQ5/x6gCISd66Ed1ceHrXRVpYh/BRvH673u9lgthtOzwb/AX2dpSgYUKZs7UhwNkZba05JzWIVAboJ6TSivIw2jt7/ngTCKWoX2vddZBp2DQIrkT1tklsiIom4SuusIo13Rb/toFODgevMmSyKGbhQYD4ouTuZi2VqeSv1WqcLDjXg3rrSDWv60wPtHqc4lQ8SBh+JJPtWLlS0bX4kj2sIR4tN3PlfeAcDoOwvrZuOQMs+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4Swx1XSBETPQKAOKPk7/O84WzGRDzaHNgSGjmQRB2Y=;
 b=m7Irli7CkR97oNAQZh/DZ3oXmLqZii4X+YdCbDhp4SQHQ/usbkzhf7UebtNwtzVuwlk/7Vklcen4wj2KcPOH6yHaOuZQipd64agKNnaVJQoCI42F/EpQAc6XhG97meWut/rlJslFK94+TxyR0UBzShLXtlm//KqW8HHLWS5Gfzg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:23 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:23 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 30/32] staging: wfx: fix potential deadlock in wfx_tx_flush()
Date:   Wed,  1 Apr 2020 13:04:03 +0200
Message-Id: <20200401110405.80282-31-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21259e16-d60b-421d-f41f-08d7d62c92cc
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285A2F0A16A182D4C6D4A7093C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrvUj0WhhGGbgWj9L+qOC0YI/4aZA5jS73cqPAIapUJBANq4XMKIPuZbPqs3hytE374kesWvY2VcFwAZF3RpM58T6C3fqy0Uo8kIBuoSygBT068F+DONbiFWUZX0I65LtNxqtJePwhv6n2pC+Vet9LfPKozh2ZzZNAsnWmkq0kGrqBfknWQs82jFQ+U9veyroOe/zdA+ywPWNQaZlyaF6bwUZfWoQ7BwWeh/glKnaCgn2p9zESUKMUZwQHivvTNeVp4PYdL2T0/bZyw7l4RVeYIByFZfzZO7TiLbTcTaMKJU3vk6FfvmHZjLYr9e6LEQn3kNglKmLXpC4T2TH8lLKvrPp32tqhhVND2KGwriz3uqKvO2wFV75qxBXkjzGgyDuKt8SvzCicGsobg2TvAuyKLMfl1H6hu4+7O2Sp5BDWYxTqZS+yqmyzQnqFDu0rhF
X-MS-Exchange-AntiSpam-MessageData: JPfaJduqfOThZ8IKitOMLEuh6VmypmkJmJpdygtTfx4UfJxE8LeGraXmHMjiMCr9jJQURpwjt61g5ymqEppuZb3JfULkgJq2/borOT/gKvDkFWbQiT3jTTw/C43am2cfP5LFC1+Jkbg07XSdJGF+aT5KIchUEBr/LYNQ6Eok7MuzNZ8SRcFOWpMlCLQ85n1m04hS5wSudfrUAkO9RNeQ2g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21259e16-d60b-421d-f41f-08d7d62c92cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:22.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqlkUbdxfXe6RJNbl44aSHkI77Jx4oghD83D8tJzUFxzIrhccYJI+ySsZTMMVO/E81Ugf/n2vRyfwM3w+FIKig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X2ZsdXNoKCkgd2FpdCB0aGVyZSBhcmUgbm8gbW9yZSBmcmFtZSBpbiBkZXZpY2UgYnVmZmVy
LiBIb3dldmVyLAp0aGlzIGV2ZW50IG1heSBuZXZlciBoYXBwZW5zIHNpbmNlIHdmeF90eF9mbHVz
aCgpIGRvbid0IGZvcmJpZCB0bwplbnF1ZXVlIG5ldyBmcmFtZXMuCgpOb3RlIHRoYXQgd2Z4X3R4
X2ZsdXNoKCkgc2hvdWxkIG9ubHkgZW5zdXJlIHRoYXQgYWxsIGZyYW1lcyBjdXJyZW50bHkgaW4K
aGFyZHdhcmUgcXVldWVzIGFyZSBzZW50LiBTbyB0aGUgY3VycmVudCBjb2RlIGlzIG1vcmUgcmVz
dHJpY3RpdmUgdGhhdAppdCBzaG91bGQuCgpOb3RlIHRoYXQgd2Z4X3R4X2ZsdXNoKCkgcmVsZWFz
ZSB0aGUgbG9jayBiZWZvcmUgdG8gcmV0dXJuIHdoaWxlCndmeF90eF9sb2NrX2ZsdXNoKCkga2Vl
cCB0aGUgbG9jay4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91
aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAyICsr
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGQ0
MzAyYTMwZGM0MS4uZTZkN2QwZTQ1MTU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zNiw2ICszNiw3
IEBAIHZvaWQgd2Z4X3R4X2ZsdXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWlmICh3ZGV2LT5j
aGlwX2Zyb3plbikKIAkJcmV0dXJuOwogCisJd2Z4X3R4X2xvY2sod2Rldik7CiAJbXV0ZXhfbG9j
aygmd2Rldi0+aGlmX2NtZC5sb2NrKTsKIAlyZXQgPSB3YWl0X2V2ZW50X3RpbWVvdXQod2Rldi0+
aGlmLnR4X2J1ZmZlcnNfZW1wdHksCiAJCQkJICF3ZGV2LT5oaWYudHhfYnVmZmVyc191c2VkLApA
QCAtNTQsNiArNTUsNyBAQCB2b2lkIHdmeF90eF9mbHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikK
IAkJd2Rldi0+Y2hpcF9mcm96ZW4gPSAxOwogCX0KIAltdXRleF91bmxvY2soJndkZXYtPmhpZl9j
bWQubG9jayk7CisJd2Z4X3R4X3VubG9jayh3ZGV2KTsKIH0KIAogdm9pZCB3ZnhfdHhfbG9ja19m
bHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKLS0gCjIuMjUuMQoK
