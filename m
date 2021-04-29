Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDDF36E89C
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbhD2KWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:22:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16574 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbhD2KWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:22:33 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210429102145epoutp02e54aea3a3812169394dd25e9263f7044~6TQZkPz-U0350503505epoutp02h
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 10:21:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210429102145epoutp02e54aea3a3812169394dd25e9263f7044~6TQZkPz-U0350503505epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619691705;
        bh=qvvGTSpuXSrZtizggQL76UqiLnmybbPMcVCYW4PRp8U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OI+QhfWleKdc3NdMtqWVlNv/raS3+0xkQ9/78OuyB9muuNA7NIdUFXnZ2o2L8zl3e
         y0AVdrFVhak6hZrmzmt/trKbnk1lfv0CHDmmlE6H+3lfTVxnrAB2ofY5AUIcuhF1Ht
         R7iiroTcXdPVoB/mSG+inMEvIGFh7EeJzM50pCh0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210429102145epcas2p1527c0ca6f17df83a2ea754dd54b36dce~6TQY7zRHr0094500945epcas2p1T;
        Thu, 29 Apr 2021 10:21:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FWBPM5nFxz4x9Q3; Thu, 29 Apr
        2021 10:21:43 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.D4.09433.7B88A806; Thu, 29 Apr 2021 19:21:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210429102143epcas2p4c8747c09a9de28f003c20389c050394a~6TQXNHUkO1667016670epcas2p40;
        Thu, 29 Apr 2021 10:21:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210429102143epsmtrp1e70eec154bd490fe7419c00b0a701a1b~6TQXLU3Q22489024890epsmtrp1_;
        Thu, 29 Apr 2021 10:21:43 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-3f-608a88b7e43d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.23.08637.7B88A806; Thu, 29 Apr 2021 19:21:43 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210429102143epsmtip2a518c690a833daf0b90c4ca5b2986392~6TQW7ko2V1939219392epsmtip25;
        Thu, 29 Apr 2021 10:21:43 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     bpf@vger.kernel.org
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] bpf: check for data_len before upgrading mss when 6 to
 4
Date:   Thu, 29 Apr 2021 19:08:23 +0900
Message-Id: <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmhe72jq4EgxlHtS2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFosr0/4wWjTtWMFk8eLDE0aL5/t6mSwubOtjtbi8aw6bxbEFYhY/
        D59htnixZAajA5/HlpU3mTwmNr9j99g56y67R9eNS8wem1Z1snn0bVnF6PF5k1wAe1SOTUZq
        YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QyUoKZYk5pUCh
        gMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyM7dPm
        shUc5qzYcW4hUwPjffYuRg4OCQETiVPzHbsYuTiEBHYwSmzvOMMO4XxilFj6cxILhPONUWLW
        3CNMXYycYB2LV/+CSuxllFjxYB1Uyw9GiQMvW1lAqtgENCT2v3vBCmKLCIhLLDi2gQmkiFng
        HLPEpflzGEESwgL+ErMfvGQGsVkEVCV+XPsE1sAr4Cyx7P9vdoh1chI3z3UygzRLCHxll1jb
        0M0CkXCR2LF5ExuELSzx6vgWqAYpiZf9bVDf1Uu0dsdA9PYwSlzZ9wSq11hi1rN2RpAaZgFN
        ifW79CHKlSWO3AKrYBbgk+g4/BdqCq9ER5sQhKkkMfFLPMQMCYkXJydDzfOQmH21E+wWIYFY
        if/vT7NPYJSdhTB+ASPjKkax1ILi3PTUYqMCY+Q42sQIToVa7jsYZ7z9oHeIkYmD8RCjBAez
        kgjv73WdCUK8KYmVValF+fFFpTmpxYcYTYGhNZFZSjQ5H5iM80riDU2NzMwMLE0tTM2MLJTE
        eX+m1iUICaQnlqRmp6YWpBbB9DFxcEo1MNneCf2+dpnwtCcxOmp/FV6bC7CK/XJykHbawpi/
        TuN2j1QWj+tCnbNXqvX8dUQ99E/1K5rpiOheffbSii3FYtGVK89kTkj4bvMXYHitXNbnfmfd
        g0Ld54cnmyzkYUv6ZLrsy0MDo7uMZqHbmrnszr0vy3Vh0+yYzvd01cc+lUnF6rXnnM6+abyg
        1Pgt7wfjrS/b+fcmbtO7rpAipbXrpPKH3sOv70b11ATmRS/gKjgQet/9T/OTKi+txbvv5ihu
        sTqw3N72TVykwBS7F1OLZ6+6l67baMjW9s/Po+GkZbJk4rNe/WUyfLfTpk04nDBLYL/6pMvn
        fi00ne9Qa2smGZO34KKviZzUkVNTtaLKlViKMxINtZiLihMBRryFlQ4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWy7bCSvO72jq4Eg43buCy+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFosr0/4wWjTtWMFk8eLDE0aL5/t6mSwubOtjtbi8aw6bxbEFYhY/
        D59htnixZAajA5/HlpU3mTwmNr9j99g56y67R9eNS8wem1Z1snn0bVnF6PF5k1wAexSXTUpq
        TmZZapG+XQJXxvZpc9kKDnNW7Di3kKmB8T57FyMnh4SAicTi1b9Yuhi5OIQEdjNKNPffZO1i
        5ABKSEjs2uwKUSMscb/lCCtEzTdGiak7X7GAJNgENCT2v3vBCmKLCIhLLDi2gQmkiFngFrNE
        98k5jCAJYQFfiYaZ38G2sQioSvy49gmsgVfAWWLZ/99QV8hJ3DzXyTyBkWcBI8MqRsnUguLc
        9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg8NTS3MG4fdUHvUOMTByMhxglOJiVRHh/r+tMEOJN
        SaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoHJrCna96D0zSvH
        ufolTp7banuD5/ObwPZX7w6YanoZvXE7sCnzPKO+xtqfj5UfWDye7XjnVN6Hv3tns7+QT0le
        9uO01Uafxqe6z47Fql6bHn/g8qPTW5tu8tutzsyIStp4/1l+q+cd1t8x8w2ieQp8Lfouvda+
        v5x3H4+tierR4Cu/vnmfFbH6kfpTTTVg2l2L6gkxa2esPvW2b4Ig/9cmbeuSXe0vHl+MulRQ
        vnvBT4XNKUzBO5447Np40aPn9epN1/YdaOf1ml7oqF9cctv6QN26Ta633543ZXdvEfM48D2c
        T1GqPb2fN+bEtSi5+rDpuqZ34pXjFs4pL3W6p8usPHlR8KkDP0OS+14FnGBhUGIpzkg01GIu
        Kk4EANEaXsW+AgAA
X-CMS-MailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_gso_segment check for the size of GROed payload if it is bigger
than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
bigger than the size of GROed payload unexpectedly if data_len is not
big enough.

Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
would increse the gso_size to 1392. tcp_gso_segment will get an error
with 1380 <= 1392.

Check for the size of GROed payload if it is really bigger than target
mss when increase mss.

Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
 net/core/filter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9323d34..3f79e3c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (skb->data_len > len_diff)
+			skb_increase_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
-- 
2.7.4

