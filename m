Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82F419AA35
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbgDALFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:04 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732336AbgDALE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXpNqxVZ36DKGXSO4zUy6HJII2UTmqpgYtmHHc5vF2vzycgIxxIG84xLs+Y7r00fn/ttXekr/HZEsnRo4S0xALBpdqxrMZeLGcldpT+iO/JBhXSjuEnWkVZsOmKUWBaORAmAox3Kh4j7scLPXjsAXHBTLGFdAI5rPMV1rY7XUkIx44OtKHtxKEwUVsalYjcEOpN97DiNUXmwVMYiUrCmyS9rlRg5FQnA7eMtcJTrDZYryulAx3o+s1g9d9HLiZDkbwVwlfm4dgoU7Sx8D3JdZQ5BcssuRSp6r+sVG1PaBhiWVC3ok5W2sPnsKLI5FLWrtkn36m4vlbA2CPU4JLqWvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+eX5nf2XUfm/gzl2JO527/3MkvsW0eUhq6lGEQMTLQ=;
 b=EOWq9n8zYJ0n/2PtF7llRg38kqrDT8fDWto1smtC8JCdDWBjL6nvkIrl5iIjBcsjqPswyBj+QNv/UNcDq4Pn8R4XGEkzLAMmTQV6JxerbkBEPuo78I6T7jg6r+nAvS2IOiPHTaDEh91yUDXqzArCLWO/vM/k3t3x9WYMRxwXvsa3HKTHqaqxhlpKlROV1QGeBE+xSSUMfGEorJTLpMO4s6M68lL4c5X/zefUUFyfLHtcyYvUFO4TYl6cfo+HjGEvEOUXWOB/lBbldklpZwFQKAvSOaO+JqvcT+A0nW4t7/UTwLao194IJMfxwYSrZMgo4xgMX42yyJRdpVPP0kdUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+eX5nf2XUfm/gzl2JO527/3MkvsW0eUhq6lGEQMTLQ=;
 b=JkRezrZFi0T8U20gHfu3OTHCwWTrS4U5vU34154jj/XLcdpl7iUw0MlPnwXyuDGnKsHvGYRiHhh6dCkR2jUXTc5tR8xEOCVSg64aoT77p0qtsWhaeAHBAfz7Xz05O8wnCLg4ldL6sigZCGSsw2JCRNEXSYQlJ1Wx1WxWSmczPi4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:38 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/32] staging: wfx: simplify wfx_tx_queues_empty()
Date:   Wed,  1 Apr 2020 13:03:42 +0200
Message-Id: <20200401110405.80282-10-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:36 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89ec6921-7e35-4b4b-8487-08d7d62c7857
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285809382028245B59AC4DB93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iN0tFBjk/Ff/Imcr0m8ioARP9oqpF6JFePGGsJw137nnI1zrjx/QZXKbBToEQVUTYlbTplRnGiAoS3eimYyo8VHEQmnan7z6jcP3NLhdSXBWZKNUBqpzBgjq407Ig2NVwY6yU5PJklidHvZj3T3UrK5SwrKwHLnG8uxXO+ZySBykEzh7DdqZTfLu8p271TvTrlnF4E+dlbGyirFG15b6i0WZfBvJA+oUeK0fxnYREZ7hmz6ZTDrVVH/8R/i69+HBzxBS3QDcMk06yK9hKeM112AVH/G06Hq3VCGCRCQgyKlsaHDvxC/0DTNGFLVt6zoNplXmel3E4nfq7OVv3oeSzq3PeSJuHCZ6EqUyVNVGRUPXlpikagxJB65MMxdpqKQPByyHy6zmuRkNFi3e6AyY8MVxit460ulNyP4d1a1vwtcB4ZXvfhoY43XxD3LuiwMK
X-MS-Exchange-AntiSpam-MessageData: 0tl48AQxG9HbRamJmOO/lLtYySxapJK/1fijyp7SPfELAmCbtWzansTV+lE9fuTO+iopeaRQuXYVnr8weWz0T087TgFhsuSz5a6qIaLcdUpJT1BMevKa4VKl+w0RJN5E/JK5WHJ/Bsk5o2vf5vyid6nnRVGyH9TMEerLuOA+ZIrRWK0uTo9gtvY39emfFtfGFXa8Gxx2KDfssFDLmIEbXg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ec6921-7e35-4b4b-8487-08d7d62c7857
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:38.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRa6XDyMQlaqq1PJxZMRF1c43d6kAHeNYaneluqMTnLz+IKj2Bq03MKJ5VRQ2g1+UDg9JCXezqw0ADHXMiWxQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhh
bmtzIHRvIHNrYl9xdWV1ZV9lbXB0eV9sb2NrbGVzcygpLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRv
IGFjcXVpcmUgdGhlCnNwaW5fbG9jayBiZWZvcmUgdG8gY2hlY2sgaWYgdGhlIHF1ZXVlIGlzIGVt
cHR5LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyB8IDE2ICsrKysrLS0t
LS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCB8ICAyICstCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jICAgfCAgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMTQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9x
dWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IDg2NDc3MzFlMDJjMC4u
MDlmODIzOTI5ZmI2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zMDMsMjAgKzMwMywxNCBAQCB1bnNp
Z25lZCBpbnQgd2Z4X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheShzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
diwKIAlyZXR1cm4ga3RpbWVfdXNfZGVsdGEobm93LCB0eF9wcml2LT54bWl0X3RpbWVzdGFtcCk7
CiB9CiAKLWJvb2wgd2Z4X3R4X3F1ZXVlc19pc19lbXB0eShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikK
K2Jvb2wgd2Z4X3R4X3F1ZXVlc19lbXB0eShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsKIAlpbnQg
aTsKLQlzdHJ1Y3Qgc2tfYnVmZl9oZWFkICpxdWV1ZTsKLQlib29sIHJldCA9IHRydWU7CiAKLQlm
b3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7IGkrKykgewotCQlxdWV1ZSA9ICZ3ZGV2
LT50eF9xdWV1ZVtpXS5xdWV1ZTsKLQkJc3Bpbl9sb2NrX2JoKCZxdWV1ZS0+bG9jayk7Ci0JCWlm
ICghc2tiX3F1ZXVlX2VtcHR5KHF1ZXVlKSkKLQkJCXJldCA9IGZhbHNlOwotCQlzcGluX3VubG9j
a19iaCgmcXVldWUtPmxvY2spOwotCX0KLQlyZXR1cm4gcmV0OworCWZvciAoaSA9IDA7IGkgPCBJ
RUVFODAyMTFfTlVNX0FDUzsgaSsrKQorCQlpZiAoIXNrYl9xdWV1ZV9lbXB0eV9sb2NrbGVzcygm
d2Rldi0+dHhfcXVldWVbaV0ucXVldWUpKQorCQkJcmV0dXJuIGZhbHNlOworCXJldHVybiB0cnVl
OwogfQogCiBzdGF0aWMgYm9vbCB3ZnhfaGFuZGxlX3R4X2RhdGEoc3RydWN0IHdmeF9kZXYgKndk
ZXYsIHN0cnVjdCBza19idWZmICpza2IpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3F1ZXVlLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKaW5kZXggMjI4NGZhNjRiNjI1
Li41YTVhYTM4ZGJiMmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaAor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKQEAgLTQwLDcgKzQwLDcgQEAgdm9pZCB3
ZnhfdHhfbG9ja19mbHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF90eF9xdWV1
ZXNfaW5pdChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF90eF9xdWV1ZXNfZGVpbml0
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIHZvaWQgd2Z4X3R4X3F1ZXVlc19jbGVhcihzdHJ1Y3Qg
d2Z4X2RldiAqd2Rldik7Ci1ib29sIHdmeF90eF9xdWV1ZXNfaXNfZW1wdHkoc3RydWN0IHdmeF9k
ZXYgKndkZXYpOworYm9vbCB3ZnhfdHhfcXVldWVzX2VtcHR5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2
KTsKIHZvaWQgd2Z4X3R4X3F1ZXVlc193YWl0X2VtcHR5X3ZpZihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
Zik7CiBzdHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdmeF9kZXYgKndk
ZXYpOwogc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0X2FmdGVyX2R0aW0oc3RydWN0
IHdmeF92aWYgKnd2aWYpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYTI3NTMzMGY1NTE4Li5iZTQ5M2I1ZjJi
NWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtMzI1LDExICszMjUsMTEgQEAgc3RhdGljIGludCBfX3dmeF9m
bHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgYm9vbCBkcm9wKQogCQlpZiAoZHJvcCkKIAkJCXdm
eF90eF9xdWV1ZXNfY2xlYXIod2Rldik7CiAJCWlmICh3YWl0X2V2ZW50X3RpbWVvdXQod2Rldi0+
dHhfcXVldWVfc3RhdHMud2FpdF9saW5rX2lkX2VtcHR5LAotCQkJCSAgICAgICB3ZnhfdHhfcXVl
dWVzX2lzX2VtcHR5KHdkZXYpLAorCQkJCSAgICAgICB3ZnhfdHhfcXVldWVzX2VtcHR5KHdkZXYp
LAogCQkJCSAgICAgICAyICogSFopIDw9IDApCiAJCQlyZXR1cm4gLUVUSU1FRE9VVDsKIAkJd2Z4
X3R4X2ZsdXNoKHdkZXYpOwotCQlpZiAod2Z4X3R4X3F1ZXVlc19pc19lbXB0eSh3ZGV2KSkKKwkJ
aWYgKHdmeF90eF9xdWV1ZXNfZW1wdHkod2RldikpCiAJCQlyZXR1cm4gMDsKIAkJZGV2X3dhcm4o
d2Rldi0+ZGV2LCAiZnJhbWVzIHF1ZXVlZCB3aGlsZSBmbHVzaGluZyB0eCBxdWV1ZXMiKTsKIAl9
Ci0tIAoyLjI1LjEKCg==
