Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B4424C2C8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgHTQBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:01:39 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:47585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728603AbgHTQAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGSruB/KuPLCWnDMq728ZojBRHX+vtBQglzQMtUUTlXJ5k1s7iWbXQl8GKotdaLZ2UA9tPyBopdK61BiEk9SnIwP/3R98f3KGp9+MVkAxd5qsb1M8jioaLlb8FsdfSqGUr520E7vmeaf0QtG/gZ77UI6cI+YhnNtBomAHypIVczBTl8+t4x5vdrf62NrAv/d7cr7ovZOGG+39ZDXBkJ8lR9d85dhVeW9DSwaB/m3w1Fb6FwOjqJaSteY/RWkzQewX93cFmpbxYFvSStEoblh/cKi2dMxdfec5S326VgRpzawAMtSqhBCqaMHoHD4WodJvICPTdGIRJ/G26rMdrbhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnx1LDN0uuuMoQM1TsWcaSizN1CAv69/PathJt1c3xk=;
 b=EKYPjxHqIWNHdS9xDYujBZ7d7+NAvHtlKYTK9RDpkBUXNLrFw4rnGNV3jrEv+on++ujhQ3n+RwJ6vPQbF1KkD4RlqxCYXEQ7pgqn3E02Pj+4Da6FqU3Z5/P7BSsxakOtG9sM56vOJg6qBblEDnTukjEIDh1WtknNVn4aFDMTaiABVfbwahFXbPLNr05Q6UkL0bxC76WkGOJzsbKKeM4Bgh/1QKki+kelbu/2nTAaBGQPbBUWw+BgY0AvvocZPVZpjPYgdocrI/3pd2r/hs5SNTgR5uDtq4kuBf/+fQMsbi814Y6x+Ko4/KZFgy/uVw3+Ok+u2FR2tWQYfVoiLiUhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnx1LDN0uuuMoQM1TsWcaSizN1CAv69/PathJt1c3xk=;
 b=K01bQjyvj1PJ7XAcaRVBIiFGz6xSlQc+7AcM4FxmsAnu+08X5IOkUzNH44IwIlqY2UOixPqdRwt38xU6/21b9g+mbm2QG89Ng7KEEBfradv3PkSjq14wpJ/RSEPIMDoSJWViHF0HkTm5glK28OKHoS7HMWQcp3VRmzVRd0RIZXM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:42 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:42 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/12] staging: wfx: add workaround for 'timeout while wake up chip'
Date:   Thu, 20 Aug 2020 17:58:58 +0200
Message-Id: <20200820155858.351292-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:40 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a1a4a50-e580-4d53-bed7-08d845220cbb
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB454163CE55E0C08C46410DC3935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pZtDQQBqpgNhl+ybQ6PX4Yt95mVhW9LRQqJT/O2OqrABC1DkmsC916Wi+0kW/W6sub+btkj4NRuQsSc8cV/Fcowz5YD14UOHfh1EiK/1QqPFdJJPjuidzEVnhLrns/8wUKoZ79gyOXIx3O0fbsV4fJ1zCR+RFfuypaeWXKb17MvekFeTVbK81WnwArQBQ0zm24YxoJGF0lKl8wruUdj5zxXEikXUyPeMNw+dxJN7MCXolxgm5jb3aBAmIxePdJHwZbPcyfbyZP2DrShtpK4rhBUwMk/26K15Qbc0DHAu2cImnKF/US4VDMGHzP8QCzKI1KXhzW7Y05fMxzgKF1eE5K5vVyLY+FfNk4JRNYKxRAzE6jK+PDAHO5fcG148IJyY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E9gMyB7a8DkMDl5KQCMlHWRffYV8WrWv7wmqm1VTvEDTRInKKsWw97yRsRv5MxR38Pas4oPAmIMRAHFP7JJ7/Of5KgSU8chQzEKrj7m4redUhAx9y4j+Kvu0Fl/vGO4qikZFOvEI+XetJDYFOAAkTG15EulB+KcPe7DopELLq+OCmJbRlKLQztER5DwB4T9q/Uds36LU/iz/bi9D8V+QOgz1RyG68sEBxucSDAHAVwFnFg2flTn+ZdKh4kYxsNzpgsGYxafvJ+tQXUj0OO1t2tUiBFYQHqMI5fVpR36u7dTA4smzNgHpwKIx5lj3Qvk9Hb6bEptziN5bFSGi1BF1hWDHBcrC9QlKtlrQfGjY8fRuJlftL3b270fKlyOwzpRS4N9YqTUD+FU15Ic9fLrfOw69wXW8AkS0RDKndrTDkdsN8HLUPSvJe59ziYUZe8YbqBsHKK9QvOs9O33VWZdJiEn4d/+PJ2ato6vQYf4fkAJm5SWTug1W+5mJhcIrTKkwLchPrFqoyIn7X3/KDHdoVXpBJFVXMF4A+imu9UFVT5VVbQAdvLUsMjObPmBNmyKpsRGrVkJarjG2pWW1665IzmzYQ9urVaFuNxTnf8euv9OgYed820FXvAaZyTpY4aZgtASjenhapfTIEv9yC7n30w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1a4a50-e580-4d53-bed7-08d845220cbb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:41.9309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckeZJ/7WWX2HFIlaYLiPQo8SqiNyqCTUilpsniWVQAKDc1nG58MV/0os3XSjUk/9Pts6Ncv+U0HHh0Suyy9xSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGhvc3QgYW5kIHRoZSBkZXZpY2UgY2FuIGJlIGNvbm5lY3RlZCB3aXRoIGEgY2FsbGVkIFdha2Ut
VXAgR1BJTy4KV2hlbiB0aGUgaG9zdCBmYWxsIGRvd24gdGhpcyBHUElPLCBpdCBhbGxvd3MgdGhl
IGRldmljZSB0byBlbnRlciBpbiBkZWVwCnNsZWVwIGFuZCBubyBjb21tdW5pY2F0aW9uIHdpdGgg
dGhlIGRldmljZSBpcyBubyBtb3JlIHBvc3NpYmxlICh0aGUKZGV2aWNlIHdha2VzIHVwIGF1dG9t
YXRpY2FsbHkgb24gRFRJTSBhbmQgZmV0Y2ggZGF0YSBpZiBuZWNlc3NhcnkpLgoKU28sIGJlZm9y
ZSB0byBjb21tdW5pY2F0ZSB3aXRoIHRoZSBkZXZpY2UsIHRoZSBkcml2ZXIgaGF2ZSB0byByYWlz
ZSB0aGUKV2FrZS11cCBHUElPIGFuZCB0aGVuIHdhaXQgZm9yIGFuIElSUSBmcm9tIHRoZSBkZXZp
Y2UuCgpVbmZvcnR1bmF0ZWx5LCBvbGQgZmlybXdhcmVzIGhhdmUgYSByYWNlIGluIHNsZWVwL3dh
a2UtdXAgcHJvY2VzcyBhbmQKdGhlIGRldmljZSBtYXkgbmV2ZXIgd2FrZSB1cC4gSW4gdGhpcyBj
YXNlLCB0aGUgSVJRIGlzIG5vdCBzZW50IGFuZApkcml2ZXIgY29tcGxhaW5zIHdpdGggInRpbWVv
dXQgd2hpbGUgd2FrZSB1cCBjaGlwIi4gVGhlbiwgdGhlIGRyaXZlcgp0cmllcyBhbnl3YXkgdG8g
YWNjZXNzIHRoZSBidXMgYW5kIGFuIG90aGVyIGVycm9yIGlzIHJhaXNlZCBieSB0aGUgYnVzLgoK
Rm9ydHVuYXRlbHksIHdoZW4gdGhlIGJ1ZyBvY2N1cnMsIGl0IGlzIHBvc3NpYmxlIHRvIGZhbGwg
ZG93biB0aGUgSVJRCmFuZCB0aGUgZGV2aWNlIHdpbGwgZXZlbnR1YWxseSBmaW5pc2ggdGhlIHNs
ZWVwIHByb2Nlc3MuIFRoZW4gdGhlIGRyaXZlcgpjYW4gd2FrZSBpdCB1cCBub3JtYWxseS4KClRo
ZSBwYXRjaCBpbXBsZW1lbnRzIHRoYXQgd29ya2Fyb3VuZCBhbmQgYWRkIGEgcmV0cnkgbGltaXQg
aW4gY2FzZQpzb21ldGhpbmcgZ29lcyB2ZXJ5IHdyb25nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvYmguYyB8IDIzICsrKysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKaW5kZXggMDczMDRh
ODBjMjliLi5mMDdiY2VlNTBlM2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYmgu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTE4LDI1ICsxOCw0MCBAQAogCiBz
dGF0aWMgdm9pZCBkZXZpY2Vfd2FrZXVwKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogeworCWludCBt
YXhfcmV0cnkgPSAzOworCiAJaWYgKCF3ZGV2LT5wZGF0YS5ncGlvX3dha2V1cCkKIAkJcmV0dXJu
OwogCWlmIChncGlvZF9nZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXAp
KQogCQlyZXR1cm47CiAKLQlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bp
b193YWtldXAsIDEpOwogCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od2RldiwgMSwgNCkpIHsKKwkJ
Z3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKHdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwLCAxKTsKIAkJ
aWYgKCFjb21wbGV0aW9uX2RvbmUoJndkZXYtPmhpZi5jdHJsX3JlYWR5KSkKIAkJCXVzbGVlcF9y
YW5nZSgyMDAwLCAyNTAwKTsKLQl9IGVsc2UgeworCQlyZXR1cm47CisJfQorCWZvciAoOzspIHsK
KwkJZ3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKHdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwLCAxKTsK
IAkJLy8gY29tcGxldGlvbi5oIGRvZXMgbm90IHByb3ZpZGUgYW55IGZ1bmN0aW9uIHRvIHdhaXQK
IAkJLy8gY29tcGxldGlvbiB3aXRob3V0IGNvbnN1bWUgaXQgKGEga2luZCBvZgogCQkvLyB3YWl0
X2Zvcl9jb21wbGV0aW9uX2RvbmVfdGltZW91dCgpKS4gU28gd2UgaGF2ZSB0byBlbXVsYXRlCiAJ
CS8vIGl0LgogCQlpZiAod2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCZ3ZGV2LT5oaWYuY3Ry
bF9yZWFkeSwKLQkJCQkJCW1zZWNzX3RvX2ppZmZpZXMoMikpKQorCQkJCQkJbXNlY3NfdG9famlm
ZmllcygyKSkpIHsKIAkJCWNvbXBsZXRlKCZ3ZGV2LT5oaWYuY3RybF9yZWFkeSk7Ci0JCWVsc2UK
KwkJCXJldHVybjsKKwkJfSBlbHNlIGlmIChtYXhfcmV0cnktLSA+IDApIHsKKwkJCS8vIE9sZGVy
IGZpcm13YXJlcyBoYXZlIGEgcmFjZSBpbiBzbGVlcC93YWtlLXVwIHByb2Nlc3MuCisJCQkvLyBS
ZWRvIHRoZSBwcm9jZXNzIGlzIHN1ZmZpY2llbnQgdG8gdW5mcmVlemUgdGhlCisJCQkvLyBjaGlw
LgogCQkJZGV2X2Vycih3ZGV2LT5kZXYsICJ0aW1lb3V0IHdoaWxlIHdha2UgdXAgY2hpcFxuIik7
CisJCQlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXAsIDAp
OworCQkJdXNsZWVwX3JhbmdlKDIwMDAsIDI1MDApOworCQl9IGVsc2UgeworCQkJZGV2X2Vycih3
ZGV2LT5kZXYsICJtYXggd2FrZS11cCByZXRyaWVzIHJlYWNoZWRcbiIpOworCQkJcmV0dXJuOwor
CQl9CiAJfQogfQogCi0tIAoyLjI4LjAKCg==
