Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5BC57065
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfFZSP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:15:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47156 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfFZSP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:15:29 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190626181527euoutp01148e403b0079d4e359e2b06c3117f170~r0k3niX8G0227202272euoutp01Q
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 18:15:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190626181527euoutp01148e403b0079d4e359e2b06c3117f170~r0k3niX8G0227202272euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561572927;
        bh=7U/wcOkARKzInXge0mokxOUM4Y+LffGC7GDc3WY2UjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvDwRHPZ+JTYFC41E/8TXn2Q/xzQcFkiJocIkC2mS7OR1RRoJaywVP+U8j1+pca4T
         RZend4y0MccEbr02x9UKD4Gyf+GdlwUmqaShLwjWiLtkd45r/lFoW/nSV7Z8bTscnu
         FUSiV7PVIJculNQe6hT93PER8HHoUc9OlXImcKnQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190626181526eucas1p1e846f4feb146d197b3d26a8762330588~r0k2K9Gy41404414044eucas1p1p;
        Wed, 26 Jun 2019 18:15:26 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 04.DF.04377.E36B31D5; Wed, 26
        Jun 2019 19:15:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190626181525eucas1p2d0f467c8ba7504b7dcc639712575032e~r0k1QCoBt0246102461eucas1p2W;
        Wed, 26 Jun 2019 18:15:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190626181525eusmtrp1831b5309fe2fd1958b332093af990f7f~r0k1B-L120317303173eusmtrp1n;
        Wed, 26 Jun 2019 18:15:25 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-ca-5d13b63e80ed
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D8.2B.04146.C36B31D5; Wed, 26
        Jun 2019 19:15:24 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190626181524eusmtip2c0b67caaa1dc4603efb08bff71dd6b69~r0k0FKqZe0894308943eusmtip2E;
        Wed, 26 Jun 2019 18:15:24 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v4 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date:   Wed, 26 Jun 2019 21:15:14 +0300
Message-Id: <20190626181515.1640-2-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626181515.1640-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsWy7djPc7p224RjDbb9ZbL407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PFktmMBfO5
        KrbOW8rYwLiEo4uRk0NCwERi7odDLF2MXBxCAisYJbo+XWSEcL4wSuzav5YNwvnMKPGv6S8T
        TMuG/XuhqpYzSlyc85QJwvnBKPHk21wWkCo2AR2JU6uPMILYIgJSEh93bGcHKWIWmMksseXx
        FLAiYYEQiZ0f1oKNZRFQlbh9YAE7iM0rYCVxY88eZoh18hKrNxwAszkFrCVOTPgEtlpCYDq7
        RM/rg1BFLhI317azQ9jCEq+Ob4GyZSROT+5hgbDrJe63vIRq7mCUmH7oH9RD9hJbXp8DauAA
        Ok9TYv0ufYiwo8TU7xPBwhICfBI33gqChJmBzEnbpjNDhHklOtqEIKpVJH4fXA51jZTEzXef
        oS7wkGh5/JgVEkB9jBI/v9xjn8AoPwth2QJGxlWM4qmlxbnpqcVGeanlesWJucWleel6yfm5
        mxiBKeb0v+NfdjDu+pN0iFGAg1GJh7dBXihWiDWxrLgy9xCjBAezkgjv0kSBWCHelMTKqtSi
        /Pii0pzU4kOM0hwsSuK81QwPooUE0hNLUrNTUwtSi2CyTBycUg2M1sbfbwad2r8uSNZlxlP3
        UNbSzzFm69UT7+y+O+F6I8Oel8ZvPHU/pVge/CQW325+y3viXz8/RuZJh25+yvE8UH92htWU
        qogpTmvfsjm0Lz+rN+uQvseOLcu49yz9ETqz4sSbN40d3xteba1M2bH7naXyjjd7zm/Yn8Z/
        5LPoJdvPUU17s5vPRiqxFGckGmoxFxUnAgAOvoK2LQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xe7o224RjDT6v0rX407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PFktmMBfO5KrbOW8rYwLiEo4uRk0NCwERi
        w/69jF2MXBxCAksZJc7NPcgIkZCS+PHrAiuELSzx51oXG0TRN0aJmUu2MYEk2AR0JE6tPgLW
        IALU8HHHdnYQm1lgIbPEl0kmXYwcHMICQRIvT7GAhFkEVCVuH1gAVsIrYCVxY88eZoj58hKr
        NxwAszkFrCVOTPjECNIqBFSzrYNzAiPfAkaGVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIGh
        vu3Yz807GC9tDD7EKMDBqMTD2yAvFCvEmlhWXJl7iFGCg1lJhHdpokCsEG9KYmVValF+fFFp
        TmrxIUZToJsmMkuJJucD4zCvJN7Q1NDcwtLQ3Njc2MxCSZy3Q+BgjJBAemJJanZqakFqEUwf
        EwenVAPjrC+WFXnvZ+79HzDnnX5Bd7fxhRt98SLXXXrDujXvuM3+/ln+zO6gpUpRjWaHLitW
        Xrrcysp6MWK69P17+0zeu2rX+pVfFFj7WUTve2dNzqe4rB8V1ptClnpG7J44m0G84F+a6wb5
        uaZfCkWyzxzauHV3r/7jPDG/Rdzcs68Yz1ySY2WSdXONEktxRqKhFnNRcSIAzIkrAosCAAA=
X-CMS-MailID: 20190626181525eucas1p2d0f467c8ba7504b7dcc639712575032e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190626181525eucas1p2d0f467c8ba7504b7dcc639712575032e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190626181525eucas1p2d0f467c8ba7504b7dcc639712575032e
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181525eucas1p2d0f467c8ba7504b7dcc639712575032e@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device pointer stored in umem regardless of zero-copy mode,
so we heed to hold the device in all cases.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f114f8..267b82a4cbcf 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -105,6 +105,9 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 
 	umem->dev = dev;
 	umem->queue_id = queue_id;
+
+	dev_hold(dev);
+
 	if (force_copy)
 		/* For copy-mode, we are done. */
 		goto out_rtnl_unlock;
@@ -124,7 +127,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		goto err_unreg_umem;
 	rtnl_unlock();
 
-	dev_hold(dev);
 	umem->zc = true;
 	return 0;
 
@@ -163,10 +165,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
 	rtnl_unlock();
 
-	if (umem->zc) {
-		dev_put(umem->dev);
-		umem->zc = false;
-	}
+	dev_put(umem->dev);
+	umem->dev = NULL;
+	umem->zc = false;
 }
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
-- 
2.17.1

