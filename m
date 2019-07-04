Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB9F5FA03
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfGDOZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:25:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35353 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfGDOZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:25:13 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190704142511euoutp010afa8796d79cb8b15fce92accabc5236~uOmGPA-Sx2146221462euoutp01C
        for <netdev@vger.kernel.org>; Thu,  4 Jul 2019 14:25:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190704142511euoutp010afa8796d79cb8b15fce92accabc5236~uOmGPA-Sx2146221462euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562250311;
        bh=nDTQvMV2GmtMsbQlwO3htPXTdx4GYhmbGKKFfHVI23s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sYlNM2pLc06yhX4J6R+wYpLvvxtwDi8XUPJR8xeNqRVxyhb0P8pSWuxOmV6YAU9NR
         avQM52l3jlCqIr/HfhHeJIkGLF2ICeAL640pfRnWtbkabgYKMSKwgmrPFq7d7pvhQ3
         D2mkM/Y1ePil3BZLjJ0cgVxvHETqleUoI9eYH6kc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190704142510eucas1p27fcc968426a7dd34b0efc6160ebb1735~uOmFhsDX_2603626036eucas1p28;
        Thu,  4 Jul 2019 14:25:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 0F.84.04325.64C0E1D5; Thu,  4
        Jul 2019 15:25:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642~uOmEt01Ot1504615046eucas1p2b;
        Thu,  4 Jul 2019 14:25:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190704142509eusmtrp2a4468529258676ae900bdac389d2dafb~uOmEfOG0p0491504915eusmtrp2Y;
        Thu,  4 Jul 2019 14:25:09 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-5f-5d1e0c4642f7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7D.77.04146.54C0E1D5; Thu,  4
        Jul 2019 15:25:09 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190704142508eusmtip25289fa98246e93382b2ca1d5375d1111~uOmDvNU--1740317403eusmtip2Q;
        Thu,  4 Jul 2019 14:25:08 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: fix possible cq entry leak
Date:   Thu,  4 Jul 2019 17:25:03 +0300
Message-Id: <20190704142503.23501-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSbUhTYRjt3b279zqc3Kboi8mCUZSWWtSPC1oZVFwowb8ZI69520Q3dVPT
        gjK/m2UWljqGGRbqZn6Moc5MdOpmGlbLbNPCkj7U6HOWLUVz3kn/znPOc855fjwEIrrFDyaS
        lZmsSsmkSjAB2mF1j4Uf8xVL95iag6gF9xROLRe3Aco1aMOo+ru/EUr3tBClxkvcOGWdLcSo
        7pYahHrRrcOoRsvwGlcXSHVe7wUxvrSpycmjzdo3OF3fM8ejNQ47Qhv1VzC6quwdQpeb9IB2
        GcVxRLwgOolNTc5mVZEHEwTy29+N/PRp35wPulaQB6oFGuBDQHI/dOWZMQ0QECKyEcBFhxXn
        hgUASzSjXsUFYEX+R2TD0tTjQDmhAUDz5DyfG/4AaP17FfNsYeRuOGIYBB4cQAbDH12d67kI
        2YfAh7ba9Sj/tagJgxn3YJTcDi9fu8/TAIIQklGwvQjl2rZCQ1sf4vFCsgyHz5wPvGccgZ8q
        R/kc9ofzNhPO4RC4ar7D4/AlOF04BzhzKYBVlhWvcAiaPo/hnjKEDIWt3ZEcfRjW3NMhHhqS
        ftDxZbOHRtbgzY4qLy2EpcUibnsbXOpv8F4TDJ1fXd4LaFjXbFxfF5FSWFAUXgHE2v9VdQDo
        QRCbpVbIWPU+JXsuQs0o1FlKWcSZNIURrD3L6IrtVxfoXU60AJIAEl9hAiaWivhMtjpXYQGQ
        QCQBwsWlEKlImMTknmdVaadVWams2gK2EKgkSHhh09tTIlLGZLIpLJvOqjZUHuETnAd2jU/F
        xscPMMacjAp72NLjFpt/iLNcqsBrZ8pTEhcLywxT7cflm4ZrXsov5j36JtO+dmvTXuFt1IGz
        2h3o85hY5ueN5mirc+K9X9zQQLijeqG2Mtxnhg3cOTsJTlQtL9lDHb1Ddnff4HD96jjvSWnG
        0f7YsZEifYGTiTuZHyVB1XJmbxiiUjP/AGAkir0oAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xe7quPHKxBtsuyFp8+Xmb3eJP2wZG
        i89HjrNZLF74jdlizvkWFosr7T/ZLY69aGGz2LVuJrPF5V1z2CxWHDoBFFsgZrG9fx+jA4/H
        lpU3mTx2zrrL7rF4z0smj64bl5g9Nq3qZPOY3v2Q2aNvyypGj8+b5AI4ovRsivJLS1IVMvKL
        S2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQypn3YxFpwn6fi6Zz1jA2M
        M7i6GDk5JARMJFbuucHSxcjFISSwlFFi8a+LbBAJKYkfvy6wQtjCEn+udbFBFH1jlGjfdZAd
        JMEmoCNxavURRhBbBKjh447t7CBFzAInmCW+z/rMBJIQBlpxbfVOsAYWAVWJxt6lQHEODl4B
        a4mNrSwQC+QlVm84wDyBkWcBI8MqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwJDeduzn5h2M
        lzYGH2IU4GBU4uFNYJOLFWJNLCuuzD3EKMHBrCTC+/23TKwQb0piZVVqUX58UWlOavEhRlOg
        3ROZpUST84HxllcSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgVFq
        s1l8dbKpgeHCl8mvvxT2Nmq7Lz+916b4mrRv9GXPfx4zXcoajz5pTUoOLzOb4vjka6xFgl1w
        A++NC4w93sIli24stlrSxe+uclN0B1PNUqG0b4mtud+vFBYXHLkwzXnqx91r5S1FKstO5ByN
        W/JsqXxIvWvhfPMJRrGWEkrfpIL53k1QUmIpzkg01GIuKk4EAHfN9OJ/AgAA
X-CMS-MailID: 20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completion queue address reservation could not be undone.
In case of bad 'queue_id' or skb allocation failure, reserved entry
will be leaked reducing the total capacity of completion queue.

Fix that by moving reservation to the point where failure is not
possible. Additionally, 'queue_id' checking moved out from the loop
since there is no point to check it there.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f53a6ef7c155..703cf5ea448b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -226,6 +226,9 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 
 	mutex_lock(&xs->mutex);
 
+	if (xs->queue_id >= xs->dev->real_num_tx_queues)
+		goto out;
+
 	while (xskq_peek_desc(xs->tx, &desc)) {
 		char *buffer;
 		u64 addr;
@@ -236,12 +239,6 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 			goto out;
 		}
 
-		if (xskq_reserve_addr(xs->umem->cq))
-			goto out;
-
-		if (xs->queue_id >= xs->dev->real_num_tx_queues)
-			goto out;
-
 		len = desc.len;
 		skb = sock_alloc_send_skb(sk, len, 1, &err);
 		if (unlikely(!skb)) {
@@ -253,7 +250,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err)) {
+		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
-- 
2.17.1

