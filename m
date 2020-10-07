Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B65285CC0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgJGKUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:20:19 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:13506
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728029AbgJGKUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:20:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtNNG95vaS1Trnf4Gy/0twCs+7n/kzy9wkIEO0IJgT7SpbhALRMFrxEwhDgzksDx8iI8vt3Xo2g4PI93OvWk1B07JKCXa9mI0A/snzdytn4q/rGuPzBm6OY9OV3+AkQY+2qkocYKsgKEwrKr67RbTLnicMdi3yBRrXYnsVKxZklwWOp+bCzJjub6zEcSohlqYiyrr2QPRMc7DEyax84V1vTRCEK+yQiro9fhMDggE9GBUxpF1/1p8aZ/U9B9NiQqhaNvlBqk4ZBuejiiIu3bzArMH6aVPm2aNBO4ST8MAnqx/CXMmQdzj76HzdZWiybCO7xiT9c9d3ZrDmAPCNaY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqPnL0gi5acflRGc9mweGH3oOEzMLHjkZgZJqC9mTFo=;
 b=EeQ5GbkdAQjgVWW4EP6XRSir3oipH30CCuyJhV99WGQ6XAAtr1K+SNzU7j+OHtO83uc0kAuO+bEuqD6pOZmwYMEKKP0+1PuU6fBLanDm2XEVy4uI7GL+dCd/+YMQthEenDjRC6DfaHThZiOPcH/x+kaNoeRihGFfdDSuMQJuCwh+DJWSMThxV1hzWMrnpni9ZC6m413bDNephSQvw3LRb4TbbOu558FnSjkcgYzvDEyqdqY9t/b44C9DQD84/H7d3XVA0VReRCksSwUNEttdl9qwaYXnGuFS6kFOqRpbSjYZoW93QNEZ7vbkXqGnfpHOoiHp1NO2RA5BzSIMvHAyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqPnL0gi5acflRGc9mweGH3oOEzMLHjkZgZJqC9mTFo=;
 b=KsspoNOzBJf4GvZAq2T2VERLZpp8GQcSJfEY8dNgWE5IOS4r5JxAdAetkmUffJ+oxM4JINATvjHD7HArOyqK2UkyMc4Isu4xYJUCo2NIobAg+3uGpjEqr+WkNCYpTgRfCCGbgYQpnWAgklCI2APJYf8OHwVXDrBS8i6lqduTbmk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4670.namprd11.prod.outlook.com (2603:10b6:806:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Wed, 7 Oct
 2020 10:20:08 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:20:08 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 3/7] staging: wfx: fix BA sessions for older firmwares
Date:   Wed,  7 Oct 2020 12:19:39 +0200
Message-Id: <20201007101943.749898-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 10:20:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c43c7c16-7c07-4aa7-3b97-08d86aaa90ff
X-MS-TrafficTypeDiagnostic: SA0PR11MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4670EAF5CED046F10725B508930A0@SA0PR11MB4670.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0yT3ytOczOF2iE5SEqBwP85SdUFnGPNKSTL6j+PzMG8q2MeXyIgW/xIRFgKjiV0s5w2qJ0bM4mIhg0PNipIHdergj6I0N3P8Wbs1EeqYuO/ObqZrOqVEEGifEBl1bCn7JtQFLdW5pYIuWN7+HCmjaE1CWYEwH18FWzrOBSNrDx63P5Rcc9QTF7qT5TywMokwFNp1Z+StD9i5yQxi4PjOQMaNbQFEY4N1UBQ10OgkMdUR5ZJYNfjIJhQhu5EFre5N6e786WUMzjSxXNUu30OhTJeQ2yTNUvf7AoOEewr2Nnr/XKAw2MSiBa1EU0dcbbj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(136003)(376002)(366004)(396003)(66556008)(66476007)(6486002)(66946007)(316002)(54906003)(4326008)(478600001)(2906002)(1076003)(5660300002)(186003)(8936002)(8676002)(16526019)(52116002)(83380400001)(26005)(6506007)(2616005)(86362001)(956004)(107886003)(8886007)(36756003)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: d+2Fgue/VsMbnoo1i46Ujlw4Gg8KO1W1ZJAFJ4d4JpmN5b/v9IW1MVsF5y2EfPyZsg77PpN0OXDct8ZmOujfm1JWPKo3A/Wr+MBUOFcpuElr8ZxlhznaoqK1JID/sJZ1I2qlXLh+kvQhIxRCDOAYEV9mZEjOGhGNBu5JlamgNgfTjjNcEgWKSgb8o50c2MjR7LD2hMpQ5cFy5g9CbQ0LWoFg8ujCOr19RqfAYj+igwqr1IvlT+0WDnxqWZ6V1HiJ7MDMveXcz0MZcGs2ZYpGQU2Z+ELBAa9KU8OF79TjrFb2e96Bjt/5EERj2zdlAjwTmvDCtUveqdx9KEDlaVVIKg2vTfiT4Uoloc64nwEATOCpm2AJec/hxQ4FjpG2OeSTbWNS98KXic/RXTi8CfUGojn2xOsei2kJ97lvWjyWkw3i4XwY6fgTMxrG1HZklL694EFwUpW71nhPoIL37ke1oGPgi1f7i0r3oJSBM8S+uP+zS/SXmkLdUDjoVZ1zHcrwi38+c1JdLK0TLQ4l6LQqaqc5+RrVtVS2U6LJopOLT1UU/8UPw+0/Vu1s+7Nuj/PMhawRVM3xYX8yn/MMLwRoTNMsLpecssvpr2iursyO/jNIR4wn1q9canB1pMfPM4ENVxBPIyVFG2uclvJDYsePeA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c43c7c16-7c07-4aa7-3b97-08d86aaa90ff
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 10:20:08.4044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZ2tmvqCLU8AGuF7pzL+mYSjBzf2pNz9Nnmb9ykdHoJ8sz9HOn1oTZvOZQAmG19jtp5K753B7YKu73hqq1lutg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4670
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmly
bXdhcmVzIHdpdGggQVBJIDwgMy42IGRvIG5vdCBmb3J3YXJkIERFTEJBIHJlcXVlc3RzLiBUaHVz
LCB3aGVuIGEKQmxvY2sgQWNrIHNlc3Npb24gaXMgcmVzdGFydGVkLCB0aGUgcmVvcmRlcmluZyBi
dWZmZXIgaXMgbm90IGZsdXNoZWQgYW5kCnRoZSByZWNlaXZlZCBzZXF1ZW5jZSBudW1iZXIgaXMg
bm90IGNvbnRpZ3VvdXMuIFRoZXJlZm9yZSwgbWFjODAyMTEKc3RhcnRzIHRvIHdhaXQgc29tZSBt
aXNzaW5nIGZyYW1lcyB0aGF0IGl0IHdpbGwgbmV2ZXIgcmVjZWl2ZS4KClRoaXMgcGF0Y2ggZGlz
YWJsZXMgdGhlIHJlb3JkZXJpbmcgYnVmZmVyIGZvciBvbGQgZmlybXdhcmUuIEl0IGlzCmhhcm1s
ZXNzIHdoZW4gdGhlIG5ldHdvcmsgaXMgdW5lbmNyeXB0ZWQuIFdoZW4gdGhlIG5ldHdvcmsgaXMg
ZW5jcnlwdGVkLAp0aGUgbm9uLWNvbnRpZ3VvdXMgZnJhbWVzIHdpbGwgYmUgdGhyb3duIGF3YXkg
YnkgdGhlIFRLSVAvQ0NNUCByZXBsYXkKcHJvdGVjdGlvbi4gU28sIHRoZSB1c2VyIHdpbGwgb2Jz
ZXJ2ZSBzb21lIHBhY2tldCBsb3NzIHdpdGggVURQIGFuZApwZXJmb3JtYW5jZSBkcm9wIHdpdGgg
VENQLgoKRml4ZXM6IGU1ZGE1ZmJkNzc0MSAoInN0YWdpbmc6IHdmeDogZml4IENDTVAvVEtJUCBy
ZXBsYXkgcHJvdGVjdGlvbiIpClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcngu
YyB8IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
cnguYwppbmRleCA4Njc4MTA5OGVkYzAuLjM4MjJhMjJiOWZlMyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4
LmMKQEAgLTE3LDYgKzE3LDkgQEAgc3RhdGljIHZvaWQgd2Z4X3J4X2hhbmRsZV9iYShzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9tZ210ICptZ210KQogewogCWludCBwYXJh
bXMsIHRpZDsKIAorCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od3ZpZi0+d2RldiwgMywgNikpCisJ
CXJldHVybjsKKwogCXN3aXRjaCAobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuYWN0aW9uX2Nv
ZGUpIHsKIAljYXNlIFdMQU5fQUNUSU9OX0FEREJBX1JFUToKIAkJcGFyYW1zID0gbGUxNl90b19j
cHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuY2FwYWIpOwotLSAKMi4yOC4wCgo=
