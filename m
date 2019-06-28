Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34655958E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF1IEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:04:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46212 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfF1IEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:04:21 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080419euoutp0240aa5270a56f5320b0a9b051a19087e2~sTh2ePdV21470214702euoutp02N
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:04:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190628080419euoutp0240aa5270a56f5320b0a9b051a19087e2~sTh2ePdV21470214702euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561709059;
        bh=/DCcaQL4KIaru6eSY0qTOKmLgKNdZSlhfLXy28ktkDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmkvJjBijRsco2QTreUM7nLg3G3/ceygOxXHwClmarYqwrI2XLnliUE7rfFN8vOea
         Bsn1cnRJ0a9rtw+WAmFnsdcQrdB5QtcNfDoVjUyRCHaJCHWKxpgI5vcq4y4fzPQwbY
         3ibh4P2lfTH+3bu2VW7cENvolE5JLUm+tVwL0KeA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190628080418eucas1p2f39d2a67f27d91a536f94fc2d9d378fa~sTh1lBOi81539015390eucas1p2G;
        Fri, 28 Jun 2019 08:04:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 5F.63.04377.20AC51D5; Fri, 28
        Jun 2019 09:04:18 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080418eucas1p1fa312ee412b805346dce631e81f7c093~sTh0zQtFM1751917519eucas1p14;
        Fri, 28 Jun 2019 08:04:18 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190628080417eusmtrp1e55a76b06e7fe4c6d934a2b791f410f4~sTh0lEaZL2335823358eusmtrp17;
        Fri, 28 Jun 2019 08:04:17 +0000 (GMT)
X-AuditID: cbfec7f4-113ff70000001119-92-5d15ca02bf44
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9A.10.04140.10AC51D5; Fri, 28
        Jun 2019 09:04:17 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080416eusmtip192d14bf957130d1f1b7f63f0f65783dd~sThzrPJBv2336323363eusmtip1S;
        Fri, 28 Jun 2019 08:04:16 +0000 (GMT)
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
Subject: [PATCH bpf v6 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date:   Fri, 28 Jun 2019 11:04:06 +0300
Message-Id: <20190628080407.30354-2-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628080407.30354-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsWy7djP87pMp0RjDZbu0bL407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK6Nt2jX2gitc
        Ff8m9LE3MF7h6GLk5JAQMJE40/6KqYuRi0NIYAWjxIeO7VDOF0aJVfv2MkM4nxkl1kw9xgzT
        suPucUaIxHJGienH1rBAOD8YJb5en8EGUsUmoCNxavURRhBbREBK4uOO7ewgRcwCM5kltjye
        wgKSEBYIkTj2cAlYEYuAqkTz/C52EJtXwFri2Lk17BDr5CVWbzgAtppTwEbi/fM2sNUSApPZ
        JTq234YqcpHofLCeBcIWlnh1fAtUXEbi9OQeqHi9xP2Wl1DNHUB3H/rHBJGwl9jy+hxQAwfQ
        eZoS63fpQ4QdJU5PBAUNB5DNJ3HjrSBImBnInLRtOjNEmFeio00IolpF4vfB5dAQkpK4+e4z
        1AUeEttm/mWHBFA/o8TR/a9YJjDKz0JYtoCRcRWjeGppcW56arFRXmq5XnFibnFpXrpecn7u
        JkZgijn97/iXHYy7/iQdYhTgYFTi4VXYKRIrxJpYVlyZe4hRgoNZSYRX8hxQiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOG81w4NoIYH0xJLU7NTUgtQimCwTB6dUA+O8+20MzhcrpP7vMc5vu+/N
        /U1Cc/+xtL/qBX0ihr53J7vvX3ygRCzh1uQgjV9X3nSsMjTesy/ky5u/DzbMDmj6ENf2P9Ta
        W/1F/6PEw72yz8J2vvxQO6k68HH4lcDnVSdl74Xse72ul/X3Xf+TJYGBEWLCd3PfX9zeJnXv
        VLj3B55/3KkNUZ5KLMUZiYZazEXFiQBbqHWDLQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xu7qMp0RjDZoPqVn8advAaPH5yHE2
        i8ULvzFbzDnfwmJxpf0nu8WxFy1sFrvWzWS2uLxrDpvFikMngGILxCy29+9jdOD22LLyJpPH
        zll32T0W73nJ5NF14xKzx/Tuh8wefVtWMXp83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
        oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9E27Rp7wRWuin8T+tgbGK9wdDFyckgImEjs
        uHucsYuRi0NIYCmjxMvuySwQCSmJH78usELYwhJ/rnWxQRR9Y5R4/fEWWBGbgI7EqdVHGEFs
        EaCGjzu2s4PYzAILmSW+TDIBsYUFgiTWXLzLBGKzCKhKNM/vAqvhFbCWOHZuDTvEAnmJ1RsO
        MIPYnAI2Eu+ft4HNFAKqebj3F+sERr4FjAyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAsN9
        27GfW3Ywdr0LPsQowMGoxMOrsFMkVog1say4MvcQowQHs5IIr+Q5oBBvSmJlVWpRfnxRaU5q
        8SFGU6CjJjJLiSbnA2MxryTe0NTQ3MLS0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMH
        p1QD43KZQMXPRdFv1jbKFd12/tduxyW3/f4Hy9bb1wwWbuqUfJO9g/1lpE/Im/DbNmVX7Iun
        fy3ht/pXl+HhEaCUsvfPmd41J45IyJ/V6Pi3/g93RJO8ZEv8+aqPPV+ebjx0KvSDeN/qoE//
        2ndqPxPwetOxdYHpkvifj37Nm9XJV3n6V6bkc7UfFUosxRmJhlrMRcWJAH7Q8QeNAgAA
X-CMS-MailID: 20190628080418eucas1p1fa312ee412b805346dce631e81f7c093
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190628080418eucas1p1fa312ee412b805346dce631e81f7c093
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190628080418eucas1p1fa312ee412b805346dce631e81f7c093
References: <20190628080407.30354-1-i.maximets@samsung.com>
        <CGME20190628080418eucas1p1fa312ee412b805346dce631e81f7c093@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device pointer stored in umem regardless of zero-copy mode,
so we heed to hold the device in all cases.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
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

