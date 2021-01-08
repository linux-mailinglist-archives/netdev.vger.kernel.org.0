Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129882EEB6A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbhAHClT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:41:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27275 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAHClT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 21:41:19 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210108024034epoutp033595cdaf9e4de537ca86ab8fcebec43c~YIXCemsbG0797207972epoutp03c
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 02:40:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210108024034epoutp033595cdaf9e4de537ca86ab8fcebec43c~YIXCemsbG0797207972epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610073634;
        bh=xoxMlfIfvypitpgcSZX4fbihu3AN0H7pI4jhhwBCZeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQ69pu+lp8KKH4RaawzWttS4BmrPJ81nhfwm/ATIjDwvBpfkDhqkeeFjugAdQ+lwT
         iDlFhQ8bzvs5t8siDab+eSDSUlhX5vXWwjxGJSb6w7i6GIHRudjn9fDQOSACTx3oJr
         wFgtlDhPTZccFJVkGf20lqSL983NwwsAn8Ef/dLs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210108024023epcas2p1daa15258b0bc73df9a7b7e54a8c341e2~YIW4yudrp1202812028epcas2p1S;
        Fri,  8 Jan 2021 02:40:23 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DBnQG0lSrz4x9Q1; Fri,  8 Jan
        2021 02:40:22 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.7A.10621.516C7FF5; Fri,  8 Jan 2021 11:40:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20~YIWzFRV8s3207132071epcas2p4J;
        Fri,  8 Jan 2021 02:40:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210108024017epsmtrp23c51d887357ec6ba192bfe28a033243f~YIWzEZNCH2908929089epsmtrp2o;
        Fri,  8 Jan 2021 02:40:17 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-a3-5ff7c6151935
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.6D.13470.116C7FF5; Fri,  8 Jan 2021 11:40:17 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210108024017epsmtip28ecfd9f7f2f17c0fb643aed5da867562~YIWyzSEpv2014720147epsmtip2x;
        Fri,  8 Jan 2021 02:40:17 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
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
Subject: [PATCH net v3] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Fri,  8 Jan 2021 11:28:38 +0900
Message-Id: <1610072918-174177-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmua7ose/xBpfWWFgsXviN2WLO+RYW
        iyvT/jBatJ3ZzmqxrXc1o8WMTxvZLS5s62O1WLdtEaNF5/elLBaXd81hs2h4y2XRcKeZzeLY
        AjGLb6ffMFrs7vzBbnH+73FWi3dbjrA7CHpsWXmTyWPnrLvsHgs2lXq0HHnL6tF14xKzx6ZV
        nWwe7/ddZfPo27KK0WNT6xJWj0PfF7B6fN4k57HpyVumAJ6oHJuM1MSU1CKF1Lzk/JTMvHRb
        Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMeUFMoSc0qBQgGJxcVK+nY2RfmlJakK
        GfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GZvnnGYr2CdR8ePhMeYGxj/C
        XYycHBICJhKf//SydjFycQgJ7GCU6Jw4nRnC+cQo0ff/LzuE841R4sLGa6wwLZdXLGKCSOxl
        lNjxbRVU/w+gln0QVWwCGhL7370As0UEaiQu/lzKCFLELPCBWWJdJ0SRsECwxPJbX4F2cHCw
        CKhKXNjHCBLmFXCVeL9jIzPENjmJm+c6mUFKOAXcJB70ZIGMkRA4wSHR+O4WC0SNi8SkxrdM
        ELawxKvjW9ghbCmJz+/2soH0SgjUS7R2x0D09jBKXNn3BKrXWGLWs3ZGkBpmAU2J9bv0IcqV
        JY5ATGcW4JPoOPyXHSLMK9HRJgRhKklM/BIPMUNC4sXJyVDzPCRO9X+DBttMRomNr/awTWCU
        m4UwfwEj4ypGsdSC4tz01GKjAkPk+NrECE63Wq47GCe//aB3iJGJg/EQowQHs5IIr8WxL/FC
        vCmJlVWpRfnxRaU5qcWHGE2BATeRWUo0OR+Y8PNK4g1NjczMDCxNLUzNjCyUxHmLDR7ECwmk
        J5akZqemFqQWwfQxcXBKNTBN2PMhNt/R8l5dyJ3dNSVzv2w6KuPr7uujsS049dS3Zw2fGeRL
        Y0NbkhmMXlRUhMp/vWe2c2r8q6lrFi/w1TvIdKfmg5un95RXDvPPFSQvNas775rvknpkz/zs
        raKSGx563PU9sDpp2YHWRltr1ZzSiivxgVpZk74WrTow61RI9r0pM9uPr4qfVzsh0mPnPpM0
        M7WfEvp2ypFef6fNSuupfTDNszzTSZPTV+vdg9PdBRqu0y+12KSLBh13FpsbfUrDT6Z76RJr
        n/9zNq7/3vI1emfZjvtP72pv3/9XU7g6KveS5A/zY1nTdqW/6E7JU9zwS2TV9M7OoFMnWKSv
        i53bEXSXW22VHMNWoX28kb+VWIozEg21mIuKEwFg6VuyQAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSvK7gse/xBlMeqlksXviN2WLO+RYW
        iyvT/jBatJ3ZzmqxrXc1o8WMTxvZLS5s62O1WLdtEaNF5/elLBaXd81hs2h4y2XRcKeZzeLY
        AjGLb6ffMFrs7vzBbnH+73FWi3dbjrA7CHpsWXmTyWPnrLvsHgs2lXq0HHnL6tF14xKzx6ZV
        nWwe7/ddZfPo27KK0WNT6xJWj0PfF7B6fN4k57HpyVumAJ4oLpuU1JzMstQifbsErozNc06z
        FeyTqPjx8BhzA+Mf4S5GTg4JAROJyysWMXUxcnEICexmlDh6Zh57FyMHUEJCYtdmV4gaYYn7
        LUdYIWq+MUp8+rOMFSTBJqAhsf/dCzBbRKBO4tbxpWwgRcwC/5glnq7exg6SEBYIlHi+9wkj
        yFAWAVWJC/sYQcK8Aq4S73dsZIZYICdx81wnM0gJp4CbxIOeLJCwEFDJ2zMPWScw8i1gZFjF
        KJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcF1qaOxi3r/qgd4iRiYPxEKMEB7OSCK/F
        sS/xQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTAtSmfK
        bVl1XW/e5BD3qh8+aQLcu4w/Hei1esUQ6DKzxf/Kz7opD34defVSbqXfR6nIa3dtri1PkPNW
        fP7m5d+rikJcjlc7Xlceatplw/dpU57t4epE68AVLc95zDwCunyur4vaeOV9qtfp6d881U4x
        lK25L/OvVPWqsarBCq6PE453x5VJpixlWOEfeTMo+kf5t+rmorDYnvTvf/WvX3wgNjtj0bkL
        nbI2ep8nSd74+u6vaE702j8KtpvNWm8bpGSpSPFYXVxe2Xfg09/7NbmTlpgemr/nWdz3vV1M
        01Xc063WBJgf+un/dFGVnGDADeWqTzZP5zQI7j/+TSD6xPFK08VG6rpTe60CJBfWiOoqsRRn
        JBpqMRcVJwIAz0BZh/oCAAA=
X-CMS-MailID: 20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20
References: <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbs in fraglist could be shared by a BPF filter loaded at TC. If TC
writes, it will call skb_ensure_writable -> pskb_expand_head to create
a private linear section for the head_skb. And then call
skb_clone_fraglist -> skb_get on each skb in the fraglist.

skb_segment_list overwrites part of the skb linear section of each
fragment itself. Even after skb_clone, the frag_skbs share their
linear section with their clone in PF_PACKET.

Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
a link for the same frag_skbs chain. If a new skb (not frags) is
queued to one of the sk_receive_queue, multiple ptypes can see and
release this. It causes use-after-free.

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

v2:
per Willem de Bruijn request,
expanded the commit message to clarify a BPF filter loaded.

v3:
per Daniel Borkmann request,
added further details from Willem in the commit message,
and use consume_skb instead of kfree_skb.

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3..b6f2b52 100644
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
+				consume_skb(nskb);
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

