Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDD81B2FBE
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDUTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:04:53 -0400
Received: from mail-eopbgr70092.outbound.protection.outlook.com ([40.107.7.92]:23502
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbgDUTEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMdUu8Vdw5uHweSIHJvdKHutaz3SNEzG5EZYtiBKR+nVO+86bxzQc+qO6UixE1WNbIb0tBZUqIGUP2rUxK6clTSdA0kkI24+KV0zVrsD/fX9AJDwRfMSyvgjmw2Cu4jXqfJ/XKlAThBEOTaNZ7bX/OQVfl/+A+eGIQ6111MVs1BKEnw5ajQJ8gPCrp4buWbcfOTUEaeByPngHZK6H11xwU0lbpfYaNm7NE7No+En5dEvpstjs7/lspx6xJw39WFxvjONZHYoPQ7IH0rOGxj9mXjlC6sKV6eYxPiCg+0wyoSXCctfaWBBxtdH/Syo1MX7xAqGV8DCs6EtdZxjVxnrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6e2IqxMCQunJXe2g46byAPw+kcDf74KHbIbdfcRTeg=;
 b=oe0c6ykQqTfZ7H6PTScfSDHU3N30rN9Yc0qiuu2K2zvLADLgnEaLeB3pCOS+SrgmyXeiNhrZ6nMpjOcNB0EzNZSajOhf+oDlafrDJimBlBgnWX3iOd5GqMQAVN/V4mRBUDth8CKTpqgdiKqtEV75/HTxiViDojOid+E+tAHspb/wRcGxDV+i1PFI3Mlimt6s9qIEyWXzByOGREGywWmXj+ACqrWg+86Re8SFgNYQG/dmsRWENdRTHCKJ7fxCGql+FE+UkzHzlWY/5pt6LurObFiFZu8EAffKnkxiCe/hDi0gYbNE104DUajdp1SX9PSMK8wF5RvRHTQSyQ57Bob/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6e2IqxMCQunJXe2g46byAPw+kcDf74KHbIbdfcRTeg=;
 b=RNK4HDRIZYiQshUcdTtEd0URD6Ttz/joCYORjT2ejOxQeFK0fXfxyYie4CG6b/p5GwGgMN5UX3+tHMYjdX6lQiEIEbyzc/0xhWjBJen7MdLADMbWBJP/Pp/PJEzej7JtJHolXJ0mrc1/mYf9RnIpbcp+2FhIjXfj9GqujuF2uoU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3548.eurprd07.prod.outlook.com (2603:10a6:7:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.11; Tue, 21 Apr
 2020 19:04:49 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526%6]) with mapi id 15.20.2937.011; Tue, 21 Apr 2020
 19:04:49 +0000
From:   =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 0/2] sctp: Fix problems with peer restart when in SHUTDOWN-PENDING state and socket is closed
Date:   Tue, 21 Apr 2020 22:03:40 +0300
Message-Id: <20200421190342.548226-1-jere.leppanen@nokia.com>
X-Mailer: git-send-email 2.25.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: HK2PR02CA0139.apcprd02.prod.outlook.com
 (2603:1096:202:16::23) To HE1PR0702MB3818.eurprd07.prod.outlook.com
 (2603:10a6:7:8c::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by HK2PR02CA0139.apcprd02.prod.outlook.com (2603:1096:202:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 21 Apr 2020 19:04:44 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a82f2abb-eac8-4afe-b3b7-08d7e626dcf4
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3548:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3548AE1F059C743E071D8301ECD50@HE1PR0702MB3548.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(2906002)(26005)(4744005)(8676002)(186003)(6666004)(1076003)(4326008)(66574012)(16526019)(6486002)(6506007)(478600001)(36756003)(316002)(66476007)(66556008)(52116002)(86362001)(66946007)(8936002)(2616005)(956004)(81156014)(110136005)(6512007)(5660300002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULRHFKwrdl3p0ae+bOcoil4kOaYA8vmkEZGV5crgxA2mO1Os8CSL9pWHopcPmULSJVBPRggqM7bka4ztjHlrEYJEl89HywTJjAuWFsA5bf5PfyfpD8O6Gqm80aGUxLzYI6aGbVUzO14eWu185NmepcBkpcka+n9D34AWcYQemBRKdX+jQGcZDFBW4JcaPzsx2fpj0bArPN/bpRiNEFKVgGwyD9syLUvXpP1zrMNWlJpdMzZV2elLEw3AwO0AHpQioK8kGWJZEZ/x0GmhvkXMpzy8QA5SxqwCaBFlaYQq1nBlM1KTDJTVdA/viy29XxEMDjFI/7Mo5/jGTygEOEPWHe4BNXX3TY7boMVJu5Z51mNy9Qih+Vkujasy+eBLLWquf/YmAZJc2QvYiJh+8YG+R5SmlUOHqtIXzwdA54MjIsEe1uyz63+ITSwvBEWIlzKe
X-MS-Exchange-AntiSpam-MessageData: rV+4ekmaKdjpHj1/vwzqFsMAgxQc0V/V7PMN5a20jm0x7f5hePZGfFvslmT+os2dCrMG76s5HAmBxnUbpUUaziJVrRMjzecKyCKKarnzjbujLuCIk1jsoSEuq9j0AzGw7zxSVVKXD64k+5BhhruKoSWpbNOnjrhf1xYIYv/WyyPh19COU0HZFhx4zvZxjeln5IgrxeCzoENT6164TgYFhqK6etS1lbAi+6f1CWDt1Q6aK7wv+C2X7tTWebMbE7qr2Og0CohrmpL6A3umz1Bshx+wUahsxeDfR64XWIicnl5ouGoKl/BeTTpXAdy8CB8jjhc3BPHJghB5+x9uQeOXiHeGDzeyuqM1QXPsFMLATWqO9ocqMHkmlXzaLz2PqYE2ZP3FOYgjCrmFF6OAWZ5GR/V9m2pKWqch1B1tMf1fPxak3pU/qW6aaHa2SqvaZdIz1acBESxdb1taCvTkZ8LpKwNQUZVJ4LCV3wZCk5wNutEpWHz7KMetwbThLO63KaobeV/ce+RgGWwLn0dRS9m/ySWgdToD5rLnpRp5AHuBooGM6aGsvcMwO4rEWeYh+9mSJI4gmj5YKA+NL0RPdxq9Z4jBeVaNBmNJuCqq60ZJz9837GJzuB7N2lXGjpDYE74nOekImRbnAhlZ2F98TsDZRjW36/HgbzQj7BT88p7rYS7bNArLttc4MPkE1jnx4Y6ochoWnhy32l9qbd6KFHbxjR/KMZC7imHMk8GrLQJYM2iYc4AbS7epWFP5En09V/rHGgPOtWiE8s2lPvRLNG7zS2f1SLg+a5PHmIarM5LSAnQ=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82f2abb-eac8-4afe-b3b7-08d7e626dcf4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 19:04:49.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Md23NkPcOJvlyurv2aqZq70ip6GX+twlP9MVOYyOpLFE+ykOcYzP4fGtTHN0C10ZaZ9p+yRB61em38zBxHy5QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3548
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlc2UgcGF0Y2hlcyBhcmUgcmVsYXRlZCB0byB0aGUgc2NlbmFyaW8gZGVzY3JpYmVkIGluIGNv
bW1pdApiZGY2ZmE1MmYwMWIgKCJzY3RwOiBoYW5kbGUgYXNzb2NpYXRpb24gcmVzdGFydHMgd2hl
biB0aGUgc29ja2V0IGlzCmNsb3NlZC4iKS4gVG8gcmVjYXAsIHdoZW4gb3VyIGFzc29jaWF0aW9u
IGlzIGluIFNIVVRET1dOLVBFTkRJTkcgc3RhdGUKYW5kIHdlJ3ZlIGNsb3NlZCBvdXIgb25lLXRv
LW9uZSBzb2NrZXQsIHdoaWxlIHRoZSBwZWVyIGNyYXNoZXMgd2l0aG91dApiZWluZyBkZXRlY3Rl
ZCwgcmVzdGFydHMgYW5kIHJlY29ubmVjdHMgdXNpbmcgdGhlIHNhbWUgYWRkcmVzc2VzIGFuZApw
b3J0cywgd2Ugc3RhcnQgYXNzb2NpYXRpb24gc2h1dGRvd24uCgpJbiB0aGlzIGNhc2UsIEN1bXVs
YXRpdmUgVFNOIEFjayBpbiB0aGUgU0hVVERPV04gdGhhdCB3ZSBzZW5kIGhhcwphbHdheXMgYmVl
biBpbmNvcnJlY3QuIEFkZGl0aW9uYWxseSwgYnVuZGxpbmcgb2YgdGhlIFNIVVRET1dOIHdpdGgg
dGhlCkNPT0tJRS1BQ0sgd2FzIGJyb2tlbiBieSBhIGxhdGVyIGNvbW1pdC4gVGhpcyBzZXJpZXMg
Zml4ZXMgYm90aCBvZgp0aGVzZSBpc3N1ZXMuCgpKZXJlIExlcHDDpG5lbiAoMik6CiAgc2N0cDog
Rml4IGJ1bmRsaW5nIG9mIFNIVVRET1dOIHdpdGggQ09PS0lFLUFDSwogIHNjdHA6IEZpeCBTSFVU
RE9XTiBDVFNOIEFjayBpbiB0aGUgcGVlciByZXN0YXJ0IGNhc2UKCiBuZXQvc2N0cC9zbV9tYWtl
X2NodW5rLmMgfCA2ICsrKysrLQogbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMgIHwgNiArKystLS0K
IDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKCmJhc2Ut
Y29tbWl0OiBhNDYwZmM1ZDRjMTcwODA2YTMxZTU5MGRmMzdlYWQzYWI5NTEzMTVjCi0tIAoyLjI1
LjIKCg==
