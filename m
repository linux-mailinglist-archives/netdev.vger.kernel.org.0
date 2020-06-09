Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C951F3733
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgFIJoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:44:11 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:22411 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726964AbgFIJoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 05:44:11 -0400
X-UUID: 53bf48e4edd44161aa93f1570fba1f19-20200609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=u4KMXSeT0DGxNEg0hfooe1wRE4xbxuD+hCYPLeD3kfA=;
        b=IqBq9AbS7ouHrlfc+Iq1EuKgG11XQ+AT/isYM3eBQpM8TmqA3hca5IXsQskzkAV9nZK7VqZMvW+YfrqWi4TwqHlULGHxv0e53/y4BhwJQoo4NrodJb0o1FOj2/06XrZV0YHW0FQpWd4ws6hQyIfB0pcNxi1KQvFm3zN2BXa4h7w=;
X-UUID: 53bf48e4edd44161aa93f1570fba1f19-20200609
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1117393545; Tue, 09 Jun 2020 17:44:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 9 Jun 2020 17:44:03 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Jun 2020 17:44:03 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <biao.huang@mediatek.com>
Subject: [PATCH] net: stmmac: Fix RX Coalesce IOC always true issue
Date:   Tue, 9 Jun 2020 17:41:33 +0800
Message-ID: <20200609094133.11053-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5IHJ4X2NvdW50X2ZyYW1lcyBpbiBzdG1tYWNfcnhfcmVmaWxsIGFsd2F5cyAwLCB3
aGljaCBsZWFkcyB0bw0KdXNlX3J4X3dkIGZhbHNlLCBhbmQgSU9DIGJpdCBvZiByeF9kZXNjMyB0
cnVlIGZvcmV2ZXIuIEZpeCBpdC4NCg0KRml4ZXM6IDZmYTlkNjkxYjkxYWMgKCJuZXQ6IHN0bW1h
YzogUHJldmVudCBkaXZpZGUtYnktemVybyIpDQpTaWduZWQtb2ZmLWJ5OiBCaWFvIEh1YW5nIDxi
aWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWlj
cm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCAzICstLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
dG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQppbmRleCBlNjg5OGZkNTIyM2YuLjg3YjUyOTc0
M2ZkMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0
bW1hY19tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0
bW1hY19tYWluLmMNCkBAIC0zNjA3LDggKzM2MDcsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc3Rt
bWFjX3J4X3JlZmlsbChzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnByaXYsIHUzMiBxdWV1ZSkNCiAJCXN0
bW1hY19yZWZpbGxfZGVzYzMocHJpdiwgcnhfcSwgcCk7DQogDQogCQlyeF9xLT5yeF9jb3VudF9m
cmFtZXMrKzsNCi0JCXJ4X3EtPnJ4X2NvdW50X2ZyYW1lcyArPSBwcml2LT5yeF9jb2FsX2ZyYW1l
czsNCi0JCWlmIChyeF9xLT5yeF9jb3VudF9mcmFtZXMgPiBwcml2LT5yeF9jb2FsX2ZyYW1lcykN
CisJCWlmIChyeF9xLT5yeF9jb3VudF9mcmFtZXMgPj0gcHJpdi0+cnhfY29hbF9mcmFtZXMpDQog
CQkJcnhfcS0+cnhfY291bnRfZnJhbWVzID0gMDsNCiANCiAJCXVzZV9yeF93ZCA9ICFwcml2LT5y
eF9jb2FsX2ZyYW1lczsNCi0tIA0KMi4xOC4wDQo=

