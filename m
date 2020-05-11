Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B61CDF5F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbgEKPts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:49:48 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbgEKPtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcLgH5Z/Tbykv3MLotLh7U8WwRF7mOt0/7dgH/CCStszpDhoDptLNxJVWQ6U6zmTiAyqGHmexp94co9iIHgkWnuqW0sumjoEqNlO3Dpur6gwAY/XEt4QE6TeZdLoGwc4ktIXQ1cUTimGNhMwlYKsqH4LgPhX/qp1p+KXM8MNr+QZb/jM5TmFd/4ksNu8ToYJWNuzVXp1v6k3Q/0jACax1U+O5OpVIsUccbPEgbK3vVDtm9Yb4qtBl50EyHGhNZ4EWrvKmD/NTkv5uad6t65iQ991yEpe7hFvva/7f7J0TyrrZVpeVu+fgQ1XFqUKU0U0ilvf7wVUhelF8HknuApIQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/TB9JC+WJu9XPSdbNjc/pIfsnX0Jy3XdP7lwsqL9sk=;
 b=ECDpEw00IXwVIrX5uiYXJY5p3WPuINj9bE+mb+N9CmNDL0IQBZeZPxPbKmqRnEsR5SbYYS5MYChH+Rvr4HShAl1El9VIyvdT/R6jAHdOs96E82IzCYl36v5HUM7wbJsh8nQ98g+0oYxGM3fNm0kajsDEoYbhsht6DGaFsP9xns9ST6pLEma0tPE7Sa1NKtgiwgrn0UXOdx8iXb6VRaEWpEzPZGtmDoukps5nEvtdJqII/MNGDy3HvG5FiIpX37H1LGcPylqmO4mU1QY96RDBfM5VvCoeZrgAI9TMTEbUbTid1G2/MjNWeOiybuwdeqIGfXqpkRLlV6ZB407ck7tL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/TB9JC+WJu9XPSdbNjc/pIfsnX0Jy3XdP7lwsqL9sk=;
 b=Om6SQfVHGbbJU+5ES+zSqbFGUKnJMQVDmh5ehRbY5I79MBRkHVzjy8NdHHs+a40rhw9V5pPcc9jMmBTBdahfS1seVQyOrzi5a6esDGpdImv6FiBmzdUI2jEVjNWqL4U6JHZkiTEoF7zsjey3NQ3UnDDd9YZ/YOd6PwJD3gweoFU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:49:45 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:49:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/17] staging: wfx: fix support for big-endian hosts
Date:   Mon, 11 May 2020 17:49:13 +0200
Message-Id: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:49:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 188d453f-ba90-4f70-0af4-08d7f5c2ecd3
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB196870469C3EA8481038921193A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TI7mMsl8/OL4r7UdyA169y9aRTtzsH3Xx6FWCHwDC3477FqrDLmXDbXs1WS8DJw1KkSnSjBpv+ICpWPQC8z8TKVHN8ufNP9pqvoFKQ4pXUBamVj6EYnmFqcKP7kz6IFgWhajMqlL4oQtbgbz0vg2nnZxrLkafm/2jJMi3fDaVVJJPUHIHhyhxKfIXjStOG64P6wBwF+LmkDSR+R8p9U0sXfswI3u2hnf8Amh+5K/k5Lc0+y3Aon+zP2UHiGKTu04+MjoKS2M5KDOHjpK6kOalafamonZaJIryWr63BDJphDZfrbTRK59rlBXz0NpI8M8BuudWlV5u19NizRPw1Fw/8XcEEay/0b2kArI/h92p4+WpbCigP/pJBr5wnz6AOzvXmdx1ognbIGyLt4IEqZkaoOC6yVEdK3zbpcaMsPcAXjkN/D0Qsokj56dOXoocxLiP+PnJzmW3OEDJvDKToqQ2+2XiuegenmYJk1QhDmJnPnbxIfZTNd25ufHOvwdTjEawlJJq1/GxfFwWShJl7/KTCagu+QR1cx9Lok00d11ZZPpgGA67Pxvw/6SoXAN4PTUUnTPsS448MrZhGwWuIOn4XY/TFjzb1W9QDR8uokPuCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(966005)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Hx1lVDi/EGwhqr0snJER/ZH9+KOJoP6GkWAXVGjPF5DRa5Dxd8p1oGFKV72DsEi0RGBmue9k/U8nx821DzWx+SRjW6EHWS/gf4QvUkd8jwftLArVw1522to7BH72KLj1QonpLlkaphQowFivABHmqKP2thwC/EFS6LsnLlbccbquzKWkrPN3GDX7HppR0CgT1/nRtSi2xFVa6YLn4HeCc5Ok9UG5+O8/AtF1/Z5oPRY0tBjVwflZ4ZN5GmY5iWaMrVzzNf3YLY8ZI2msGQDNOPBBjXVVok9DsvwvEz38liH8N0dX6BNsdeIBp+v3/zLdYb8PT+16kMOOv0XYB/bekpD9ZlsSb8eblmgvEVOfo5kWr9L6EGDEUK5PQx+X6voXPHTlLuzYT4wr872mf28qfrmzHGwwvCEDae9NWPkNFnNUg4bj2mc/Yk0Kxq6DyOguqHqJ8I6BHukCqJllluci8CDWsD3W1lAcloZ5yTBC3vI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 188d453f-ba90-4f70-0af4-08d7f5c2ecd3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:49:44.5267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ju1YfG5D0bYDFS0Hu5wRhScJIlv+S/bkhfk8PIEw+Tsib6hDrChprH/gh5FZcA3o+E/0ujNMQOatewyKOBzOeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sIAoKQXMgYWxyZWFkeSBkaXNjdXNzZWQgaGVyZVsxXSwgdGhpcyBzZXJpZXMgaW1wcm92ZXMg
c3VwcG9ydCBmb3IgYmlnCmVuZGlhbiBob3N0cy4gQWxsIHdhcm5pbmdzIHJhaXNlZCBieSBzcGFy
c2UgYXJlIG5vdyBmaXhlZC4KCk5vdGUsIHRoaXMgc2VyaWVzIGFpbXMgdG8gYmUgYXBwbGllZCBv
biB0b3Agb2YgUFIgbmFtZWQgInN0YWdpbmc6IHdmeDoKZml4IE91dC1PZi1CYW5kIElSUSIKClsx
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMTkxMTExMjAyODUyLkdYMjY1MzBAWmVu
SVYubGludXgub3JnLnVrCiAgCkrDqXLDtG1lIFBvdWlsbGVyICgxNyk6CiAgc3RhZ2luZzogd2Z4
OiBmaXggdXNlIG9mIGNwdV90b19sZTMyIGluc3RlYWQgb2YgbGUzMl90b19jcHUKICBzdGFnaW5n
OiB3Zng6IHRha2UgYWR2YW50YWdlIG9mIGxlMzJfdG9fY3B1cCgpCiAgc3RhZ2luZzogd2Z4OiBm
aXggY2FzdCBvcGVyYXRvcgogIHN0YWdpbmc6IHdmeDogZml4IHdyb25nIGJ5dGVzIG9yZGVyCiAg
c3RhZ2luZzogd2Z4OiBmaXggb3V0cHV0IG9mIHJ4X3N0YXRzIG9uIGJpZyBlbmRpYW4gaG9zdHMK
ICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5uZXNzIG9mIGZpZWxkcyBtZWRpYV9kZWxheSBhbmQg
dHhfcXVldWVfZGVsYXkKICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5uZXNzIG9mIGhpZl9yZXFf
cmVhZF9taWIgZmllbGRzCiAgc3RhZ2luZzogd2Z4OiBmaXggYWNjZXNzIHRvIGxlMzIgYXR0cmli
dXRlICdwc19tb2RlX2Vycm9yJwogIHN0YWdpbmc6IHdmeDogZml4IGFjY2VzcyB0byBsZTMyIGF0
dHJpYnV0ZSAnZXZlbnRfaWQnCiAgc3RhZ2luZzogd2Z4OiBmaXggYWNjZXNzIHRvIGxlMzIgYXR0
cmlidXRlICdpbmRpY2F0aW9uX3R5cGUnCiAgc3RhZ2luZzogd2Z4OiBkZWNsYXJlIHRoZSBmaWVs
ZCAncGFja2V0X2lkJyB3aXRoIG5hdGl2ZSBieXRlIG9yZGVyCiAgc3RhZ2luZzogd2Z4OiBmaXgg
ZW5kaWFubmVzcyBvZiB0aGUgc3RydWN0IGhpZl9pbmRfc3RhcnR1cAogIHN0YWdpbmc6IHdmeDog
Zml4IGVuZGlhbm5lc3Mgb2YgdGhlIGZpZWxkICdsZW4nCiAgc3RhZ2luZzogd2Z4OiBmaXggZW5k
aWFubmVzcyBvZiB0aGUgZmllbGQgJ3N0YXR1cycKICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5u
ZXNzIG9mIHRoZSBmaWVsZCAnbnVtX3R4X2NvbmZzJwogIHN0YWdpbmc6IHdmeDogZml4IGVuZGlh
bm5lc3Mgb2YgdGhlIGZpZWxkICdjaGFubmVsX251bWJlcicKICBzdGFnaW5nOiB3Zng6IHVwZGF0
ZSBUT0RPCgogZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPICAgICAgICAgICAgICB8IDE5IC0tLS0t
LS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jICAgICAgICAgICAgICB8IDExICsrKy0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMgICAgICAgICB8ICA0ICstCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYyAgICAgICAgIHwgIDkgKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGVidWcuYyAgICAgICAgICAgfCAxMSArKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9jbWQuaCAgICAgfCA0MiArKysrKysrKystLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2dlbmVyYWwuaCB8IDU1ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyAgICAgICAgICB8IDMyICsrKysrKysrLS0tLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICAgICAgfCAyMCArKysrKy0tLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYyAgICAgIHwgIDIgKy0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaHdpby5jICAgICAgICAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgICAgICAgICAgICB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5o
ICAgICAgICAgIHwgIDggKystLQogMTMgZmlsZXMgY2hhbmdlZCwgMTA1IGluc2VydGlvbnMoKyks
IDExMiBkZWxldGlvbnMoLSkKCi0tIAoyLjI2LjIKCg==
