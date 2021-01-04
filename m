Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389092E923F
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 10:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhADI6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 03:58:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38797 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbhADI6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 03:58:39 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210104085756epoutp047db766d2bada39697cd07124330ed99f~W_7YR_llU2707427074epoutp04E
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 08:57:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210104085756epoutp047db766d2bada39697cd07124330ed99f~W_7YR_llU2707427074epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609750676;
        bh=jFOM9WDc45csBs+u2WOssdEmBx5vbFjwIY2qiwO7t0k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ffLrff3ZlADzxRg4BTpC+OcJorAWU5qIYBq02eXXkQDHWOJiKaJDeJhr2bvRlY3xf
         7BPbNekcHWud1yS/zc+ebEqizXUvMOaQbrlxy9vSWcxEHNQ3PDAEJVdUuHtaFYo4VU
         fHo8AXD4IOnzLwRPf2YZ0sQHnwDp1ccUwNN44wN4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210104085755epcas2p14ed7ed7089a0bf40178de0e279c580d4~W_7XhFcKP0585605856epcas2p1o;
        Mon,  4 Jan 2021 08:57:55 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D8Tzj2Hrtz4x9Q9; Mon,  4 Jan
        2021 08:57:53 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.F1.56312.E88D2FF5; Mon,  4 Jan 2021 17:57:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5~W_7Sh1RsE0318803188epcas2p1u;
        Mon,  4 Jan 2021 08:57:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210104085750epsmtrp2bc29a72db20a7639a721729ee6074a55~W_7Sg8Kky1123111231epsmtrp2Y;
        Mon,  4 Jan 2021 08:57:50 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-ab-5ff2d88ede89
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.01.08745.D88D2FF5; Mon,  4 Jan 2021 17:57:49 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210104085749epsmtip1ecfc0f0f3be2265e4ec29c8972fe7c28~W_7SUN75k3270432704epsmtip1D;
        Mon,  4 Jan 2021 08:57:49 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, namkyu78.kim@samsung.com,
        Dongseok Yi <dseok.yi@samsung.com>
Subject: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Mon,  4 Jan 2021 17:46:45 +0900
Message-Id: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmqW7fjU/xBrOPSFnMOd/CYnFl2h9G
        i7Yz21kttvWuZrSY8Wkju8WFbX2sFuu2LWK06Py+lMXi8q45bBYNb7ksGu40s1kcWyBm8e30
        G0aL3Z0/2C3O/z3OavFuyxF2BwGPLStvMnnsnHWX3WPBplKPliNvWT02repk83i/7yqbR9+W
        VYwem1qXsHoc+r6A1ePzJjmPTU/eMgVwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
        GlpamCsp5CXmptoqufgE6Lpl5gC9o6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkp
        MDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMl4MYu9YJpIxZz2HpYGxp0CXYycHBICJhJnZp5i
        7WLk4hAS2MEo8eLhJVaQhJDAJ0aJ5veaEPZnRonzVxlhGp6fPsMM0bCLUWLjppdQzg9Gif8r
        NoJ1swloSOx/9wLMFhHQllh3oAdsBbPATBaJA8tug40SFgiQuLB8LTuIzSKgKvFxfS9bFyMH
        B6+Aq8TEA6EQ2+Qkbp7rBFsgITCTQ2Jd03pmkBoJAReJb3slIGqEJV4d38IOYUtJfH63lw2i
        pF6itTsGorWHUeLKvicsEDXGErOetTOC1DALaEqs36UPUa4sceQWWAWzAJ9Ex+G/7BBhXomO
        NiEIU0li4pd4iBkSEi9OToaa5yHR9nQyOySkYiWuT3nJNIFRdhbC+AWMjKsYxVILinPTU4uN
        CoyQ42cTIzh1arntYJzy9oPeIUYmDsZDjBIczEoivBUXPsQL8aYkVlalFuXHF5XmpBYfYjQF
        htVEZinR5Hxg8s4riTc0NTIzM7A0tTA1M7JQEuctNngQLySQnliSmp2aWpBaBNPHxMEp1cCU
        xXDxyynv+VPeObQz92+W1ZLIkWV1kXSftNDzvdqbeKnI8w2tzzWyu+482aJ/Xe93Ttqh1Uyn
        Pb7tPdawScJLWmm7jt/NYKbEasbd8+YbJc8//mLqGf/IzV2md6wDym/zRsy8pSfZcDe+zH8j
        u69hqL3C85uPrUOVyhiqH/24HVKpe4j7oVildkGZufD5M8WHtrXN+MymEcoi5helt0vQh/m+
        YgiTdlwaj1QNvyrjBi0R14ezzxeIKl6dfb2/aOHNx7vmrH32xiG6t7n3Q97Jz2x/Dutu2mMr
        IR+k9lajdpukQFPIw0c+e2Y9n5vnnN8puavvmcdftzfBmWFNaQ6W99OYdq4yYGB7FadSq8RS
        nJFoqMVcVJwIAKXUgfEmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnG7vjU/xBgsarCzmnG9hsbgy7Q+j
        RduZ7awW23pXM1rM+LSR3eLCtj5Wi3XbFjFadH5fymJxedccNouGt1wWDXea2SyOLRCz+Hb6
        DaPF7s4f7Bbn/x5ntXi35Qi7g4DHlpU3mTx2zrrL7rFgU6lHy5G3rB6bVnWyebzfd5XNo2/L
        KkaPTa1LWD0OfV/A6vF5k5zHpidvmQK4o7hsUlJzMstSi/TtErgyXsxiL5gmUjGnvYelgXGn
        QBcjJ4eEgInE89NnmEFsIYEdjBLH30h1MXIAxSUkdm12hSgRlrjfcoS1i5ELqOQbo8S/E41M
        IAk2AQ2J/e9esILYIgLaEusO9IAVMQssZ5HYeWoPG0hCWMBPomnXXrAGFgFViY/re9lAFvAK
        uEpMPBAKsUBO4ua5TuYJjDwLGBlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEB7SW
        1g7GPas+6B1iZOJgPMQowcGsJMJbceFDvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE
        0hNLUrNTUwtSi2CyTBycUg1M506nzrmzoCPzxT/B1CMvDKeJfk9gu7SEUzPG351lY2CgEl/x
        onf5YftlpA6w/Tnf0HD4ZMs+9hkKkp7P5pbz9P+YWxy9qumO4ftPhw4d4H00p+T467duvf5V
        grzBFxmKtF8Wc+y6X2a5IcRFz7yFSV1Bqi7Ab98dj+/10b0mXEfWylzx9YmddNU65+ZlI5XO
        hfb7fpRLr/n04olaXW257w/roxb3WOf/Pn1iifu0/EU9+UJ2NZMO5X/dcvDG3J/hgXnrlLaw
        757597DFYt77D60NXCzuNhzi5TpkmmDYW5/4TqUg5P3T5F8vKgSSIh1uNvLO5X65/ektZlX1
        m4fvWwrMLX8pPOnhPa+z/s9klViKMxINtZiLihMBDc4gLtcCAAA=
X-CMS-MailID: 20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbs in frag_list could be shared by pskb_expand_head() from BPF.

While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
chain made by skb_segment_list().

If the new skb (not frag_list) is queued to one of the sk_receive_queue,
multiple ptypes can see this. The skb could be released by ptypes and
it causes use-after-free.

[ 4443.426215] ------------[ cut here ]------------
[ 4443.426222] refcount_t: underflow; use-after-free.
[ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
[ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
[ 4443.426808] Call trace:
[ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426823]  skb_release_data+0x144/0x264
[ 4443.426828]  kfree_skb+0x58/0xc4
[ 4443.426832]  skb_queue_purge+0x64/0x9c
[ 4443.426844]  packet_set_ring+0x5f0/0x820
[ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
[ 4443.426853]  __sys_setsockopt+0x188/0x278
[ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
[ 4443.426869]  el0_svc_common+0xf0/0x1d0
[ 4443.426873]  el0_svc_handler+0x74/0x98
[ 4443.426880]  el0_svc+0x8/0xc

Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
 net/core/skbuff.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3..1dcbda8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
-	struct sk_buff *nskb;
+	struct sk_buff *nskb, *tmp;
+	int err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
+		err = 0;
+		if (skb_shared(nskb)) {
+			tmp = skb_clone(nskb, GFP_ATOMIC);
+			if (tmp) {
+				kfree_skb(nskb);
+				nskb = tmp;
+				err = skb_unclone(nskb, GFP_ATOMIC);
+			} else {
+				err = -ENOMEM;
+			}
+		}
+
 		if (!tail)
 			skb->next = nskb;
 		else
 			tail->next = nskb;
 
+		if (unlikely(err)) {
+			nskb->next = list_skb;
+			goto err_linearize;
+		}
+
 		tail = nskb;
 
 		delta_len += nskb->len;
-- 
2.7.4

