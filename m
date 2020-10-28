Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2487129E196
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgJ2CCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:02:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57054 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgJ1VtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:12 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201028015037epoutp010210e5075411d70c1c4e60541e2af800~CBO30yi0w1107211072epoutp01v
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:50:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201028015037epoutp010210e5075411d70c1c4e60541e2af800~CBO30yi0w1107211072epoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603849837;
        bh=XlTmgcFRTKSPsuEfcMy+F63TXyvoyD4ogFdij9pRF/k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=eNsntGMqL8KQAYN4+pB3NuB9TwMgFFKtgJpjokcmcr5hu4btL1i5hBNgibgssE+kV
         9DqCAkz/T1B9XVLpXllIb+0Z5cZdKyjFq/5/mv1hZKGbs0C/5p2Pw1W7AHsCQbUT5H
         +D4cRWu2tzUP8AKoipFlfEp6VkHb1tm7YCkx2K9w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201028015036epcas1p2b1be0b0896a5b9e9d4ae3b7ea9f2ca1f~CBO3ML-fq2392723927epcas1p20;
        Wed, 28 Oct 2020 01:50:36 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.153]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CLWk15kfszMqYl3; Wed, 28 Oct
        2020 01:50:33 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.D8.02418.96EC89F5; Wed, 28 Oct 2020 10:50:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20201028015033epcas1p4f3d9b38b037ff6d4432e1a2866544e38~CBOz4yoMj1110511105epcas1p4B;
        Wed, 28 Oct 2020 01:50:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201028015033epsmtrp114d0e06e788eb5bbc5386fe065d9f5eb~CBOz3krpe0215602156epsmtrp1O;
        Wed, 28 Oct 2020 01:50:33 +0000 (GMT)
X-AuditID: b6c32a35-c23ff70000010972-dd-5f98ce69cdb9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.B3.08745.86EC89F5; Wed, 28 Oct 2020 10:50:32 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.222]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201028015032epsmtip153ed2103d33ac191a8e49e8aea265a1a~CBOzgzDvn0587005870epsmtip1d;
        Wed, 28 Oct 2020 01:50:32 +0000 (GMT)
From:   Seung-Woo Kim <sw0312.kim@samsung.com>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc:     smoch@web.de, sandals@crustytoothpaste.net, rafal@milecki.pl,
        digetx@gmail.com, double.lo@cypress.com, amsr@cypress.com,
        stanley.hsu@cypress.com, saravanan.shanmugham@cypress.com,
        jean-philippe@linaro.org, frank.kao@cypress.com,
        netdev@vger.kernel.org, sw0312.kim@samsung.com,
        jh80.chung@samsung.com
Subject: [PATCH v2] brcmfmac: Fix memory leak for unpaired
 brcmf_{alloc/free}
Date:   Wed, 28 Oct 2020 10:52:47 +0900
Message-Id: <1603849967-22817-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmrm7muRnxBnv3alvsPfSH1WL70jcs
        Fp9b2pgs3k78wGbxtn0ak8Wc8y0sFqs/Pma0OHflN7tF/6cZzBY/Fr1gs/jx6AaLRcPqC6wW
        N361sVpc2NbHarFo5UI2izcr7rBbHFsgZrF77SImi7aZP5gsNq4Ks5h1exKrxb3WPUwWMya/
        ZLOY/mM3k4OEx6z7Z9k8Lvf1Mnksv/mXyaOtKdNjy8qbTB47Z91l99i0qpPN4861PWwe56d6
        evRtWcXo8XmTnMftZ9tYAniism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgF5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BRYFugVJ+YW
        l+al6yXn51oZGhgYmQIVJmRn/J7zjanggEDFvb7jLA2MM/i6GDk5JARMJDp+/2LrYuTiEBLY
        wSjRe62NBcL5xCjxZuY3JgjnM6PEwitnWGFa9v4/zQyR2MUosWvLa6j+L4wS3b+amEGq2AR0
        JPYv+c0KkhAR2MwksW3jDLAqZoHtTBL7TjwEqxIW8JdYuPklUIKDg0VAVeJkKxNImFfADai+
        nQ1inYLEgntvwXolBB5wSFzZ+pEdIuEiMXfGSxYIW1ji1fEtUHEpiZf9bVB2tcT2CT/ZIZo7
        GCV62huhGowl9i+dzASymFlAU2L9Ln2IsKLEzt9zGUFsZgE+iXdfe1hBSiQEeCU62oQgSlQk
        dh6dxAYRlpKYtSEYIuwhseP2WrCvhARiJV5/bmOewCg7C2H+AkbGVYxiqQXFuempxYYFhsjR
        tIkRnJ61THcwTnz7Qe8QIxMH4yFGCQ5mJRHeOTJT44V4UxIrq1KL8uOLSnNSiw8xmgKDayKz
        lGhyPjBD5JXEG5oaGRsbW5gYmpkaGiqJ8/7R7ogXEkhPLEnNTk0tSC2C6WPi4JRqYNowu/jQ
        LEPFFzXpK/WDam6WL9CMiQ5hyWXkDm52F/2z0TLrfNe2xaucxN3MVJ2lG7Pyvn8//LctflKj
        fPhn2bRO20mav57U9x2zCnXQVJkjfvXiC7ES3uNZxzJnni83F3+lcaRMlFvrYXqy9gKt40ck
        JFdXP+OMWRE2f4NY8257l9OuadOjz/zQvBOTx3vhzrZvT/k6Ku3y7I9ntL2/WyzO2f1Trezv
        +XNFynYZd0qeyy44OMV90v/2NUsfcaXz5d+uabKTsL30Y2E3O4vO7Uy9OY0LEiZ+3piQeW3X
        8iS783P/3ek3fFg0pUOpLFNgcUAUlzjrt4Dzf9tyXHj85CbdTZMvzJpmsq5onzyzEktxRqKh
        FnNRcSIA2lonj1gEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnG7GuRnxBkcbbC32HvrDarF96RsW
        i88tbUwWbyd+YLN42z6NyWLO+RYWi9UfHzNanLvym92i/9MMZosfi16wWfx4dIPFomH1BVaL
        G7/aWC0ubOtjtVi0ciGbxZsVd9gtji0Qs9i9dhGTRdvMH0wWG1eFWcy6PYnV4l7rHiaLGZNf
        sllM/7GbyUHCY9b9s2wel/t6mTyW3/zL5NHWlOmxZeVNJo+ds+6ye2xa1cnmcefaHjaP81M9
        Pfq2rGL0+LxJzuP2s20sATxRXDYpqTmZZalF+nYJXBm/53xjKjggUHGv7zhLA+MMvi5GTg4J
        AROJvf9PM3cxcnEICexglOhcdIsVIiElMffbdsYuRg4gW1ji8OFiiJpPjBKHDq9gA6lhE9CR
        2L/kNytIQkRgP5NEy8kmMIdZ4DiTxO/GLcwg3cICvhKX31iBmCwCqhInW5lAenkF3CS2bWxn
        g9ilILHg3lu2CYw8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeLltYOxj2r
        PugdYmTiYDzEKMHBrCTCO0dmarwQb0piZVVqUX58UWlOavEhRmkOFiVx3q+zFsYJCaQnlqRm
        p6YWpBbBZJk4OKUamFqn7PVWZAnYdPXbp+k3ftVf0QqIalg2x8NA8GDHnIsfPivpHS3+z8Mg
        wvh20+XMhP3h3lud+94t9Hh35vD7CaejNvNoMM9+kyp3LX2te/GJ1SrzUn2l509lnRo6X3Xa
        4zmVr/o5rzo0PrnMumzezJPrimU/Pjriq/P+i1SShdKjxGPGr+UTLJs3L/q/WuN2783+/Z5e
        kXu/JT5OX6Is8e8V+2WuGCWfZtGT9fzr1IodNZd8mmvw3/H4vLNf8vwaSqK7dsZtlu6yemOz
        mO967969Md7aDT1cc9e/elOaYOUrleMjLOL+8V5hV1CQc8FW3Tea5/PuaaR/sktb+1aC5QgX
        k/yTxrVLFBf+ebNGNV6JpTgj0VCLuag4EQACT9aSBQMAAA==
X-CMS-MailID: 20201028015033epcas1p4f3d9b38b037ff6d4432e1a2866544e38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201028015033epcas1p4f3d9b38b037ff6d4432e1a2866544e38
References: <CGME20201028015033epcas1p4f3d9b38b037ff6d4432e1a2866544e38@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are missig brcmf_free() for brcmf_alloc(). Fix memory leak
by adding missed brcmf_free().

Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
Fixes: commit 450914c39f88 ("brcmfmac: split brcmf_attach() and brcmf_detach() functions")
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Change from v1 [1]
- add Fixes tag for the commit creating brcmf_alloc/free and unpaired path
- add Reviewd-by tag from Arend

[1] https://lore.kernel.org/linux-wireless/1603795630-14638-1-git-send-email-sw0312.kim@samsung.com/
---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    6 ++++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 39381cb..d8db0db 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1936,16 +1936,18 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	fwreq = brcmf_pcie_prepare_fw_request(devinfo);
 	if (!fwreq) {
 		ret = -ENOMEM;
-		goto fail_bus;
+		goto fail_brcmf;
 	}
 
 	ret = brcmf_fw_get_firmwares(bus->dev, fwreq, brcmf_pcie_setup);
 	if (ret < 0) {
 		kfree(fwreq);
-		goto fail_bus;
+		goto fail_brcmf;
 	}
 	return 0;
 
+fail_brcmf:
+	brcmf_free(&devinfo->pdev->dev);
 fail_bus:
 	kfree(bus->msgbuf);
 	kfree(bus);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 99987a7..59c2b2b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4541,6 +4541,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
 		brcmf_detach(bus->sdiodev->dev);
+		brcmf_free(bus->sdiodev->dev);
 
 		cancel_work_sync(&bus->datawork);
 		if (bus->brcmf_wq)
-- 
1.7.4.1

