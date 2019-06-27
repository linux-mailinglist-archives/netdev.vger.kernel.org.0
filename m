Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD2058002
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfF0KPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:15:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32906 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfF0KPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:15:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190627101539euoutp026def940e7734db0c026a39120fee485a~sBrPBJIEG2411124111euoutp02f
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:15:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190627101539euoutp026def940e7734db0c026a39120fee485a~sBrPBJIEG2411124111euoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561630539;
        bh=7U/wcOkARKzInXge0mokxOUM4Y+LffGC7GDc3WY2UjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOHonzT472gCi2u0CyzPNiFBtmE4oFiINpkDqyoFfpDZQzoVDKO6vDd19fpi8b+Gj
         ceYfkFdTluRrsMfMes1pcWH0FYK4fNB2y0lHRhgs/eVF9yp9SO3BeVjn/3RVv/JRGi
         iW7SBXo1dw3wG8a7Rcin0E943527/nUcEuDmhHLg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190627101539eucas1p2cfdaa6e5aaf3c1b8577a1bad1878654d~sBrOPAOoT2154921549eucas1p27;
        Thu, 27 Jun 2019 10:15:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 21.FE.04298.A47941D5; Thu, 27
        Jun 2019 11:15:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787~sBrNkykVW2154921549eucas1p25;
        Thu, 27 Jun 2019 10:15:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190627101538eusmtrp297a5d4197cfb5bc2c33723292fd45d00~sBrNWv3Lf2684426844eusmtrp2f;
        Thu, 27 Jun 2019 10:15:38 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-da-5d14974aacdd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D8.3E.04140.A47941D5; Thu, 27
        Jun 2019 11:15:38 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190627101537eusmtip17e324a088cca83c9daa97195d6d47426~sBrMrr6Je0980209802eusmtip1C;
        Thu, 27 Jun 2019 10:15:37 +0000 (GMT)
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
Subject: [PATCH bpf v5 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date:   Thu, 27 Jun 2019 13:15:28 +0300
Message-Id: <20190627101529.11234-2-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627101529.11234-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSa0hTURz37F63u9nitq08zEoZSQ98psiFJHtBo/ogWEHKyJnXabopu7qy
        BymJiUKKrDZN05qPpbFE5hPzcZVNshRt1CTClj3U0B6rlVbW5l307fc8//85HAwR6H3FWIYq
        l1Sr5FkSNg/ttCyPhx7RiWQRKxURxK/iNkA4R6xswnDHhRA1E0UoYbu2zCEsc0VsotdUhRBP
        e2vYhJEedWv1m4iu8n6wz09qvjfNkvZUv+RIDX3zLGmpfQqR6sociPS6uQVIne1b4zmJvNhU
        MitDQ6rD9ybz0o0Nt0BOHe98x+1GUAAasFKAYRCPhqtjilLAwwS4EUDb4H3AkK8Azuj1LIY4
        AWy+4XAT7lqjcGwGYYxmANsnH7IZ8gPAAct3xJNi4yHwUesI8GARLoafu7s4nhCCVyHQPKtF
        PYYQPw5rHfVrBRQPhqOThrUCH98DK2zL3nGBsLVtEPEsy8Vj4WRhpucciOs4cOiJCzCZQ3C2
        ccmbF8IFq5nD4M3wT0+dV78CZ4rmAVMuAVBHr3qNOGj+MM7xDEDwnfBBbzgj74eDHU5f5pHW
        Q/viBo+MuGFlpw5hZD4sKRYw6W3w51AzwmAxnF5yejeQwi6XwfuK5QCu1D5DK0Bg9f9h9QC0
        AH8yj1IqSCpSRZ4Lo+RKKk+lCDuTrWwH7v8ytmr90g2+TaXQAMeAZB3fp08oE/jKNVS+kgYQ
        QyQifvZJkUzAT5XnXyDV2afVeVkkRYMADJX48y/6vEoS4Ap5LplJkjmk+p/LwrjiApDerw84
        GvH4QB2tSbA1DUQtsY2JZc+T42NeXK4c7U5Jm10I0kRGodG/Y8KDTe8/fdTtM24MsOvFikum
        gw7T4t0cbkrPDjw0VJvbrxzejVbftDe9ETYdG3ZZ0rZMaJMOu9wX0dK4LBhNeJugiXuX8fqq
        7MSclU+dDfLbfiqElqBUujxyF6Km5H8BJLWOZisDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xu7pe00ViDb7dZ7H407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PFktmMBfO5KrbOW8rYwLiEo4uRk0NCwESi
        8fR95i5GLg4hgaWMEot+97BCJKQkfvy6AGULS/y51sUGYgsJfGOUuNyiDGKzCehInFp9hBHE
        FgGq/7hjOzuIzSywkFniyyQTEFtYIEii8/B8sDksAqoSJy4uBqvnFbCWmHDlJxPEfHmJ1RsO
        AB3BwcEpYCNxsTEbYpW1xIejP9kmMPItYGRYxSiSWlqcm55bbKRXnJhbXJqXrpecn7uJERjq
        24793LKDsetd8CFGAQ5GJR7eFTuFY4VYE8uKK3MPMUpwMCuJ8OaHicQK8aYkVlalFuXHF5Xm
        pBYfYjQFumkis5Rocj4wDvNK4g1NDc0tLA3Njc2NzSyUxHk7BA7GCAmkJ5akZqemFqQWwfQx
        cXBKNTCqBk9261r1cFmpgmvB9zt+QVKaT4RColUmettXBrvJiYQqCew7++L02kULEh4s/WE/
        5Z9QmpVYpNe9xK6Xe3MvxF96cjt9ssTMRcEexl9VDNQa5t3YEptfx3XsXLsA/+v3L9w3M3he
        mMw09d8JlvtLHloJvl9npmvB9+kKe+isI+cUpv+/z6elxFKckWioxVxUnAgAaXb17osCAAA=
X-CMS-MailID: 20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787
References: <20190627101529.11234-1-i.maximets@samsung.com>
        <CGME20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787@eucas1p2.samsung.com>
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

