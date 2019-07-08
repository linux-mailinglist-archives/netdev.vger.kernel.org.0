Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F076E61D79
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfGHLDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:03:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36722 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfGHLDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:03:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190708110352euoutp024029bdd185cc3f50a6e135326476e096~vabdfSBJ72074620746euoutp02R
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 11:03:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190708110352euoutp024029bdd185cc3f50a6e135326476e096~vabdfSBJ72074620746euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562583832;
        bh=iJ/vgkwgHEVtdCA4ebVEDI6nMvu1XOQWTINwB5UZ21Y=;
        h=From:To:Cc:Subject:Date:References:From;
        b=p/W7OiNKgo0dmURd6p3j4pnJKCJsvGTOwhQY8qjyQTcAWqk0b4GYIMy8PEIB5pUdz
         WSrGIapQc4oCR3H8UtrTg4S034/QGWszC5Shvp8EAAf0vqQM0n+0nnpRBFDI1UcWIO
         u8UG9Ij9UTM2Ng6ULrFC9zTL3MkLLyFhsuutBRNs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190708110351eucas1p2bde3ebc38e8c48b9413055c03c7ab96c~vabcvLjwd2083220832eucas1p2j;
        Mon,  8 Jul 2019 11:03:51 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F2.FD.04298.613232D5; Mon,  8
        Jul 2019 12:03:50 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1~vabbxYcUy2519125191eucas1p1L;
        Mon,  8 Jul 2019 11:03:50 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190708110349eusmtrp2de94694ed18e2b6000e2c0fca30ad84f~vabbjN_S43170831708eusmtrp2M;
        Mon,  8 Jul 2019 11:03:49 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-7b-5d232316b880
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 84.EA.04140.513232D5; Mon,  8
        Jul 2019 12:03:49 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190708110349eusmtip2f28b183397c1dd08fb6127d5326a04e9~vaba1exG-1263912639eusmtip2c;
        Mon,  8 Jul 2019 11:03:49 +0000 (GMT)
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
Subject: [PATCH bpf] xdp: fix potential deadlock on socket mutex
Date:   Mon,  8 Jul 2019 14:03:44 +0300
Message-Id: <20190708110344.23278-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djP87piysqxBo9mWVh8+Xmb3eJP2wZG
        i89HjrNZLF74jdlizvkWFosr7T/ZLY69aGGz2LVuJrPF5V1z2CxWHDoBFFsgZrG9fx+jA4/H
        lpU3mTx2zrrL7rF4z0smj64bl5g9Nq3qZPOY3v2Q2aNvyypGj8+b5AI4orhsUlJzMstSi/Tt
        Ergy1q3TKngjXrF/p0wDY69wFyMnh4SAicTLPRvYuxi5OIQEVjBKTGlZywjhfGGUeNk3Ecr5
        zCgx/98mJpiWWzNfQLUsZ5TobX8OVfWDUeL5wivsIFVsAjoSp1YfYQSxRQSkJD7u2A7WwSxw
        gFli9/F5zCAJYQEHiZeT/rOA2CwCqhJP286zgti8AtYSi6btYoNYJy+xesMBZpBmCYFudokp
        X+4xQiRcJF7/3AxVJCzx6vgWdghbRuL/zvlQt9ZL3G95yQjR3MEoMf3QP6iEvcSW1+eAGjiA
        TtKUWL9LHyLsKHGo8QkrSFhCgE/ixltBkDAzkDlp23RmiDCvREebEES1isTvg8uZIWwpiZvv
        PkNd4CExf+MBsEVCArES02ZvY5/AKDcLYdcCRsZVjOKppcW56anFhnmp5XrFibnFpXnpesn5
        uZsYgYnl9L/jn3Ywfr2UdIhRgINRiYd3g7RSrBBrYllxZe4hRgkOZiUR3sQg+Vgh3pTEyqrU
        ovz4otKc1OJDjNIcLErivNUMD6KFBNITS1KzU1MLUotgskwcnFINjInnIpoEld5b//7503yH
        pV+93+oTq0/lVi26bBPzT43zl7us9PVsv8DLhpJn+A0e7u9XLtuus3/hosLcS2fvWZ05ciPo
        fJqbQdVc/X/pPrmO3WonW2sruA0XuF52W3TLNr2U+6jJPaNyvWxOuQ9JCn9tDSpXnzxkxeI+
        aZNpG6OH30pWRgkNJZbijERDLeai4kQAvrZObygDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xe7qiysqxBps3m1t8+Xmb3eJP2wZG
        i89HjrNZLF74jdlizvkWFosr7T/ZLY69aGGz2LVuJrPF5V1z2CxWHDoBFFsgZrG9fx+jA4/H
        lpU3mTx2zrrL7rF4z0smj64bl5g9Nq3qZPOY3v2Q2aNvyypGj8+b5AI4ovRsivJLS1IVMvKL
        S2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy1q3TKngjXrF/p0wDY69w
        FyMnh4SAicStmS/Yuxi5OIQEljJKLP31kx0iISXx49cFVghbWOLPtS42iKJvjBKt3VcYQRJs
        AjoSp1YfAbNFgBo+7tgONolZ4ASzxPdZn5lAEsICDhIvJ/1nAbFZBFQlnradB5vKK2AtsWja
        LjaIDfISqzccYJ7AyLOAkWEVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYEBvO/Zzyw7GrnfB
        hxgFOBiVeHg55JRihVgTy4orcw8xSnAwK4nwJgbJxwrxpiRWVqUW5ccXleakFh9iNAVaPpFZ
        SjQ5HxhteSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGLUmScpt
        2lh39vP3c40aJ7nn3+CPY/r9JfjmsatT10h2zWf0TknOdJ2+Yu3lN6W/fbV+ndi5oMU9n9dz
        p80O1jnHhfX/L45gun9l+9UL/QwNilGHoxL3TX5vbap48Qz/hxCHJ4Fvq+/rl/5hqn54s88j
        vOZv+8mE6QtqEzoUlqV9PzXf26j3m4sSS3FGoqEWc1FxIgDpDUB/fgIAAA==
X-CMS-MailID: 20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1
References: <CGME20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 call chains:

  a) xsk_bind --> xdp_umem_assign_dev
  b) unregister_netdevice_queue --> xsk_notifier

with the following locking order:

  a) xs->mutex --> rtnl_lock
  b) rtnl_lock --> xdp.lock --> xs->mutex

Different order of taking 'xs->mutex' and 'rtnl_lock' could produce a
deadlock here. Fix that by moving the 'rtnl_lock' before 'xs->lock' in
the bind call chain (a).

Reported-by: syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com
Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound to xdp socket")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

This patch is a fix for patch that is not yet in mainline, but
already in 'net' tree. I'm not sure what is the correct process
for applying such fixes.

 net/xdp/xdp_umem.c | 16 ++++++----------
 net/xdp/xsk.c      |  2 ++
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 20c91f02d3d8..83de74ca729a 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -87,21 +87,20 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	struct netdev_bpf bpf;
 	int err = 0;
 
+	ASSERT_RTNL();
+
 	force_zc = flags & XDP_ZEROCOPY;
 	force_copy = flags & XDP_COPY;
 
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	rtnl_lock();
-	if (xdp_get_umem_from_qid(dev, queue_id)) {
-		err = -EBUSY;
-		goto out_rtnl_unlock;
-	}
+	if (xdp_get_umem_from_qid(dev, queue_id))
+		return -EBUSY;
 
 	err = xdp_reg_umem_at_qid(dev, umem, queue_id);
 	if (err)
-		goto out_rtnl_unlock;
+		return err;
 
 	umem->dev = dev;
 	umem->queue_id = queue_id;
@@ -110,7 +109,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 
 	if (force_copy)
 		/* For copy-mode, we are done. */
-		goto out_rtnl_unlock;
+		return 0;
 
 	if (!dev->netdev_ops->ndo_bpf ||
 	    !dev->netdev_ops->ndo_xsk_async_xmit) {
@@ -125,7 +124,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
 	if (err)
 		goto err_unreg_umem;
-	rtnl_unlock();
 
 	umem->zc = true;
 	return 0;
@@ -135,8 +133,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		err = 0; /* fallback to copy mode */
 	if (err)
 		xdp_clear_umem_at_qid(dev, queue_id);
-out_rtnl_unlock:
-	rtnl_unlock();
 	return err;
 }
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 703cf5ea448b..2aa6072a3e55 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -416,6 +416,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY))
 		return -EINVAL;
 
+	rtnl_lock();
 	mutex_lock(&xs->mutex);
 	if (xs->state != XSK_READY) {
 		err = -EBUSY;
@@ -501,6 +502,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		xs->state = XSK_BOUND;
 out_release:
 	mutex_unlock(&xs->mutex);
+	rtnl_unlock();
 	return err;
 }
 
-- 
2.17.1

