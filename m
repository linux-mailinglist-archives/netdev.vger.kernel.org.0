Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D95A2EC768
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAGAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:51:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:17494 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAGAvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 19:51:15 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210107005032epoutp021983f861d75671d39c30f9bfa3d06d35~XzNrYhxMd0695806958epoutp02S
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 00:50:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210107005032epoutp021983f861d75671d39c30f9bfa3d06d35~XzNrYhxMd0695806958epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609980632;
        bh=myQi6DtdWZZkwRj5cSI2a+HgH834d6rXO/mkCH4tOGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCJDNJx3sIEh1Y3cfIrr15RdRGJwTuIHCM3KbBLcPY4D2tTWvnHZpjUIITxmDltdF
         sqxwouIr+rn2Qhizk0oaYqO7l2O3+y1Kju0XswUgBCRfgsR6ETvpp+MopQ3F5MRWhL
         dtsqxT1yNMdetkHi9xUk8qT4tPvmWN8te/Qc4SZw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210107005031epcas2p4b4d53dcda0c45677eeb69ee7a4a7219f~XzNquBlDr2854428544epcas2p4F;
        Thu,  7 Jan 2021 00:50:31 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DB71x2ZjMzMqYkf; Thu,  7 Jan
        2021 00:50:29 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.A2.10621.5DA56FF5; Thu,  7 Jan 2021 09:50:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210107005028epcas2p35dfa745fd92e31400024874f54243556~XzNnrwg4x0223202232epcas2p3C;
        Thu,  7 Jan 2021 00:50:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210107005028epsmtrp12630259aa2131468ff5bafb826bce474~XzNnqyalx0844808448epsmtrp17;
        Thu,  7 Jan 2021 00:50:28 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-02-5ff65ad510b7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.25.13470.3DA56FF5; Thu,  7 Jan 2021 09:50:27 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210107005027epsmtip1585c9e6a3f55e0339dc7eef722161faa~XzNnZEGws0497604976epsmtip1j;
        Thu,  7 Jan 2021 00:50:27 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
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
Subject: [PATCH net v2] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Thu,  7 Jan 2021 09:39:13 +0900
Message-Id: <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxjH896114MNOavgK4kEz80fOKBFCweDjgRll+gSMvYHYS7nBS6F
        2F/2WnCOaYlQqYJKUMcaNN3sxiiLaNeA1AhJafgRCTABFaaLZs4AEaYFC5sS1/Yw23/f530+
        3+d53+d9cFTqwOLwMq2RM2hZNYlFijp6d6QlTRQFGFlD51qqeaRaRI1ffA0oy1CnmOqobwNU
        k/+6hBrtOCOmrnZ8Dyjr0g8iaszTjFHmuUjK/OAERvXZY6nA7WeAumldllAjK/1iat7tk+QQ
        tLt1EqG7bA8ltN1loqt9c2La5bRi9F/dExh9xu0EtKvGIaa9S3YxveCKp11P5pD8d4rUWaUc
        W8IZEjhtsa6kTKvKJvcVMLmMIk0mT5JnUOlkgpbVcNnknv35SXll6uBzyIRyVm0KHuWzPE+m
        KLMMOpORSyjV8cZsktOXqPVyuT6ZZzW8SatKLtZpMuUyWaoiSB5Ul474zkv0CzFHXs50ImYw
        v/YUiMAhsRtebPKKToFIXErcANBsaUGFwA9gS+sfmBAEABy7N4G8tbTUdCNC4haAQxeaVi3L
        AN4aWJGEKIzYDnvmp8UhvZ74DA4+rgIhCCWeo/Cq9W44sY4ogE3trrBBRLwPB8xLaEhHEXth
        3eyYWGgXDyeHreHzCCIPel4shVtDwo3Dc8PXglfHg8EeOPlrtMCvg7P9bomg4+DMWYtEQI7D
        mtMHBGsdgOPdT0QCswvanp4EIQYldsB2T4qAb4G+qTCBEmtgbe/KapUoWGuRCpKEDYuMUAPC
        6cHG1Xo09PtbV+f2LYDfLN0RnwPxtv/q2wFwglhOz2tUHJ+ql///w1wgvK6Je2+AxrnnyV6A
        4MALII6S66OovkVGGlXCfnmUM+gYg0nN8V6gCE6uAY2LKdYF911rZOSK1LQ0WYaCUqSlUuSG
        KF72iJESKtbIHeI4PWd460PwiDgzwr+ydfo2KB2998sDeZtzHV+XH7H0fXip8Mr9T03TjYtD
        iT0+dOXZ9hfkrqk7bPrLn5JdW7wo0VZ5NncKsfy5bfh1m+UrttQ5nuk/XJmbrry2XPgb+wrH
        nFK07tjmOMumArTrTb1p5pN7juYipe3BmtGebRW2E8XwsEIrRX9hVe9uuh5fh2OXP7LN192s
        v303JS9Jobmy8+Tn5tjRn49+USWrMO38rvKDQOR7H48t9+tSOxhls515U82Pt3c9lg7UxuTM
        ODbu1kRzGRrP0+jjtpy2qsJAxfSxh1sZ2e/KH8+ffvRPDmffqIgwH/L8XdiwuP9gtkG5cCDr
        EpI5O9i/1UGK+FJWnogaePZfIunc6jcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnO7lqG/xBuemW1vMOd/CYnFl2h9G
        i7Yz21kttvWuZrSY8Wkju8WFbX2sFuu2LWK06Py+lMXi8q45bBYNb7ksGu40s1kcWyBm8e30
        G0aL3Z0/2C3O/z3OavFuyxF2BwGPLStvMnnsnHWX3WPBplKPliNvWT02repk83i/7yqbR9+W
        VYwem1qXsHoc+r6A1ePzJjmPTU/eMgVwR3HZpKTmZJalFunbJXBlnD8yhb3gs2jF15fbmRoY
        3wl2MXJySAiYSCxv3cfUxcjFISSwm1Hi3qLprF2MHEAJCYldm10haoQl7rccYYWo+cYoceTD
        GWaQBJuAhsT+dy9YQWwRgRCJtR3rwIqYBf4xSzxdvY0dJCEsEChxvO0zE4jNIqAqcaLhO1gz
        r4CrRM+ry6wQG+Qkbp7rBItzCrhJ7Pr4HaxeCKimtfUv2wRGvgWMDKsYJVMLinPTc4sNCwzz
        Usv1ihNzi0vz0vWS83M3MYLjQEtzB+P2VR/0DjEycTAeYpTgYFYS4bU49iVeiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqZ8qavn/OuiPxg4OAut3Wnp
        fazPd1eX9yqu6lSmSer6V1zUdy1veravu08+oCLM75l58Jf0wKNZB2ZuKXUNEt6hpcCkK86s
        PvXM8u45Ah+KAkV+lb3l2GFpU7ROry7l4JO5MQ5sE9MTlLb9Lnvc3LbukrKY2Y0zcv0aWmJ8
        64+Lp/M/cZZceYHN7E1I81PGS8VpNebp1o1HHn/dnFPKFvvHQZZvx7vWgCXVv25ODl58a2G3
        U7rwnDuOtR9vr2Q1lWPWmde8h0H/x8eK1gW/zl2r53lpYdv8ILs2NefFvy16Uyo/G4lfOfsi
        JG5ZiFRvbAODToG5wewNZ0+5i6j+PBnR6BvNoL/0Nq9IhthnJZbijERDLeai4kQAETp/E/IC
        AAA=
X-CMS-MailID: 20210107005028epcas2p35dfa745fd92e31400024874f54243556
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210107005028epcas2p35dfa745fd92e31400024874f54243556
References: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210107005028epcas2p35dfa745fd92e31400024874f54243556@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbs in fraglist could be shared by a BPF filter loaded at TC. It
triggers skb_ensure_writable -> pskb_expand_head ->
skb_clone_fraglist -> skb_get on each skb in the fraglist.

While tcpdump, sk_receive_queue of PF_PACKET has the original fraglist.
But the same fraglist is queued to PF_INET (or PF_INET6) as the fraglist
chain made by skb_segment_list.

If the new skb (not fraglist) is queued to one of the sk_receive_queue,
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
Acked-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

v2: Expand the commit message to clarify a BPF filter loaded

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

