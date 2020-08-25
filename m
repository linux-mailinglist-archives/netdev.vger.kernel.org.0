Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344F2514E2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgHYJA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:00:28 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:20448
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729672AbgHYI7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDeKv7f9kZqwqCPLjwW+JUN0dsYeiKJSu834C9HWorHHZhhI0JieBU67gTI8hlXQnMq4NIH16alnajHqKvRmIBgNME9ae4VaNzE9OohRi6WE1SmS5phvnngmbEfvzjibcprBhYB6aLtN1h7J6IGwK5mDrc7ZYB7/QEeIbTQvAI9I23c6EdwGwiCoVwuAayOuyHGNCxJGEbLHTEvGoqzt5bqVuAOVViueVx41BsqOWOsH2IhkvDiNzRRqMORS2Hd5rE6SvgRtyUP9gg31NWf0cpz4+ZeZcDXYGouaL4xQt8BztWbBY3jMWmMe64JbHYDZHoFP5cVawX6oHjs+QKAoTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rBtP5u0nh32OciXaVgs0skqMaNtbGtASNU92LkxqA=;
 b=gMbcMBLpgmLbJgzDNHwSiIDucDx4wgvLg386r+MzB86wFo5R68RBGbcqJzbDCYTUjabbgpDqPEnl6vCeD/8jl4hrmHtO7XSn03y7H1uS/8o+z9vfUGVd6UPZFRx61U3rDPLwDtufGcSv+NXErnxpJ8mOs7ggqADC+5dH1crBPmprVvzuKXD0sohyfMPrOGmGgJ5arBi6mxvLBTrB2+c0K/llf5ReiQwCJUHjTvpBzroDKlJDlDcvYM8JXw7co/E47fYeXr0kZGp+NY7qjenUHkrdQiAwCMQrrWr2IoPGLANeEyGAb3TKLofYboIpqno5u5OszEUo5Gfz115m+J/80w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rBtP5u0nh32OciXaVgs0skqMaNtbGtASNU92LkxqA=;
 b=fU+9AnIM4OockertY+ATqQ4Ex5Y6dFZz8tenAYnGhMxCUNaQ7SAhcdBKHH7rDu+mKzPDawdGHZKhsNBnXUhC8ByUUzKPIh+hm2dVo6Zkt9MKqze1vS8VEEuRuELVLXOg0tJRp4UifuwwNV38a1Jn13OGijmuk9nIG4jCq7p/NNE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:10 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 10/12] staging: wfx: enable powersave on probe
Date:   Tue, 25 Aug 2020 10:58:26 +0200
Message-Id: <20200825085828.399505-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:08 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6be8db3-345f-4f74-f50c-08d848d5218c
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501B6DE970067D98377765793570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhBySxw0t2CB55Mb/Fzjmt1QPy5u/ZOdt1lvX06FQj+3nr2rw/it41hcjfPT4aUIsOzpum7rhUq1MOQbxbMt0OPqRj1DiNJsU6YgxZBuFgf7R9WOSEx7AjDdZ89TkHx8IGXYzNXIKzu8CyxfBlAYlsbQXWRqNLRDShcKcSnETMVBgerPD0+SRJat4fe1vA5C+rBRUWko3isEq28crwmujI8MwD02iEzfi+AscHQPLRXcG8wkf0ae3xWBYp2xPNRJuHq+35oeTJqph1IurT2dUNEWNdNF69WKhhorCAAxWrjznyyUBocrzUQy9GJhB2n8tpUYrHCByVtplmWiiS1OlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(4744005)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kQbtbU0k6CZTNO7u7pJ9aYF4bC9Qiq1BotACZIE8UbrmAcfzs1gU50phqmqPHj4beTqZcGkzlnbEfZOFJuQA5a2sYQvqR2U2K24HlfHjMil95qi9dlsviX+MH0PyBTOFGN2xXzjtLPj64mTF23vheTmmdeWl+TDV7IL86Yg6zcSLuNEAlP05CCql3WFGTiH724btRER3YGGilNnB8UA1yh7pfrXMRH7jx0WtAaoW0NynoH9A6RGqyQ6uMOyQ06Rh5E7zxy6tT+ol9Y308JVeI8ruqsp/+iStrue+fUEWFVGEhml0XYoj+ZYyunKgkk5faJl48cgr+ZlrEcQzPzOtXfQONvEVQzsYNYqbfdw76p6uai8gsPv9DMalxygGyPEfsEi0aXJZfbeErOlEyjPH17SC8ZtGhnOyuzY6WRav/GQ15pKFkURiSFgDpMj6BpE2gt7pTVr75aE69e5awm2KuVL5A1bDgPZS8+vc8bYjAO+Lbti0L4anVodDpKmk7DZ1hFnl4Rs5gpzx5VxH7o2+oLbwBplAZeUwZ2hcwYrFMp+ygQV1BpBYvbTTV+akh4Mm87LKNSehY/E80JawV/tZNr8mcLkaooKmgImS16nV8+jT/gfvbXR8/fOegPWNS6RIQqF0gRaGFJE+755gGsoVRw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6be8db3-345f-4f74-f50c-08d848d5218c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:10.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwEpjS0IjRl28JIVmAPHVHJVvGMq2bc7sx3yuDEIxokxJz7/S/TIf/mPmKF2Vbz42ErY2Y6N/fOKJRGXhuV5xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG9sZCBkYXlzLCBpZWVlODAyMTEgcG93ZXJzYXZlIGhhcyBzb21lIGltcGFjdCBvbiB0aGUg
Unggc3BlZWQuClRoZXNlIHByb2JsZW1zIGFyZSBzb2x2ZWQgZm9yIGEgbG9uZyB0aW1lIG5vdy4g
VGhlcmUgaXMgbm8gbW9yZSByZWFzb24KdG8gbm90IGVuYWJsaW5nIGl0LgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9tYWluLmMKaW5kZXggNWEzMDE4ZTE0NDQ1Li41ZTJiODI0OTkwMDQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jCkBAIC0yODUsNyArMjg1LDYgQEAgc3RydWN0IHdmeF9kZXYgKndmeF9pbml0X2Nv
bW1vbihzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJaHctPndpcGh5LT5mZWF0dXJlcyB8PSBOTDgwMjEx
X0ZFQVRVUkVfQVBfU0NBTjsKIAlody0+d2lwaHktPmZsYWdzIHw9IFdJUEhZX0ZMQUdfQVBfUFJP
QkVfUkVTUF9PRkZMT0FEOwogCWh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19BUF9VQVBT
RDsKLQlody0+d2lwaHktPmZsYWdzICY9IH5XSVBIWV9GTEFHX1BTX09OX0JZX0RFRkFVTFQ7CiAJ
aHctPndpcGh5LT5tYXhfYXBfYXNzb2Nfc3RhID0gSElGX0xJTktfSURfTUFYOwogCWh3LT53aXBo
eS0+bWF4X3NjYW5fc3NpZHMgPSAyOwogCWh3LT53aXBoeS0+bWF4X3NjYW5faWVfbGVuID0gSUVF
RTgwMjExX01BWF9EQVRBX0xFTjsKLS0gCjIuMjguMAoK
