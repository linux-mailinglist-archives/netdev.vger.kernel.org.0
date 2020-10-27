Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB08B29A9F8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418051AbgJ0Kpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:45:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22052 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417816AbgJ0KpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:45:10 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201027104500epoutp018d39115453f90b8fb77f78eaafefc5e6~B04KV5l5v0954109541epoutp01E
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 10:45:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201027104500epoutp018d39115453f90b8fb77f78eaafefc5e6~B04KV5l5v0954109541epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603795500;
        bh=AoWOVmY9nKcz0B6XsbEqVzVvxhKF+tcFV06B7yi2G3w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HoaMwH8z7VVcoOFO1OyjWI2+nK72AlY7i1Yc1aSjn+X2MmV3gIGj8Qbs/HXRewwVv
         cStPPiRlNHwt9X8rtxwJt6qiIeGXayWflgrEezAS76rHduj+ksrKi4GnzexXZv6UZK
         KykBgFXbNgv4eFWqWjmka1td/ilE7XtUekEXcUq8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201027104459epcas1p3282254891db5b5fa0a4add6d26058773~B04JxGf5_0381603816epcas1p3b;
        Tue, 27 Oct 2020 10:44:59 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.154]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CL7d46yt0zMqYlr; Tue, 27 Oct
        2020 10:44:56 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.B7.09543.82AF79F5; Tue, 27 Oct 2020 19:44:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20201027104456epcas1p44c0f3c748f5aa52da1725d3e5a24b3de~B04Gqet5a2251722517epcas1p4e;
        Tue, 27 Oct 2020 10:44:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201027104456epsmtrp194e73abfd482410ccbeebd2467938fa1~B04GpXWdE1619816198epsmtrp1t;
        Tue, 27 Oct 2020 10:44:56 +0000 (GMT)
X-AuditID: b6c32a35-347ff70000002547-14-5f97fa28bb05
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.44.08604.72AF79F5; Tue, 27 Oct 2020 19:44:55 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.222]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201027104455epsmtip1a3b499a0aa5a26850cd906ac73ac1b92~B04GNEhQv0769307693epsmtip1N;
        Tue, 27 Oct 2020 10:44:55 +0000 (GMT)
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
Subject: [PATCH] brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}
Date:   Tue, 27 Oct 2020 19:47:10 +0900
Message-Id: <1603795630-14638-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVCTdRz39+zZsyHOnsZLv3ahuOUdIG8D5n5woJZGD5YdHFxXaTef2BPs
        GNvaBmp5iRxNNJq8HEILTyC5cBwZtHgnaCBgyctJeHIyK+hUVBQc1mJobT529d/n8/l+Pr/v
        9/fG5wj7CRFfpTEyeg2tFhNr8baB0KiIkJUqRfTUXBzqta9yUXvDXRw5i0wYWihbJNDCsVMY
        qhkvwlHT0hxAYz+7eejkg2oOctXfIpBr9iqOCpomuOjqiomLJtrMXFR/ro5AdxtneGioNhB1
        N9djyPS5C0Mt1jeR5Vo5F13/pAdD1RXzBKpydWM7IGX5ZZSgJs2fYdRX048wylSoomznpjGq
        0+LgUa3W4wQ1c6WHoMYrUyizzQooZ+sG6tqNNjx13Ts5idkMrWT0wYwmU6tUabKSxK+lK3Yq
        ZFujpRHSeCQXB2voXCZJvOv11IhkldqzdXFwPq3O80iptMEgjtqWqNfmGZngbK3BmCRmdEq1
        Ll4XaaBzDXmarMhMbW6CNDo6RuYx7s/JtjicPF2H4OCtT9UFoN/3BODzIRkHF2++fwKs5QvJ
        DgDrz1ZgLHkAYN/yBQ/x8ZA/AHxYynixN1DluM9jTb0Amr/owlmyDGBDpYvjdRFkOOw76+Z6
        C/7ktxhsa6kmvIRDtmPw+5HfON7mfuRuONAt8QZwcjOcGLvB82IBmQyvjNcQbLtgWHt94UkW
        kjN8WFh3mssOvgv2XzzEevzg7WEbj8UiOH/S9BR/BNtL/+Kx2WIAS44dxdlCLOxr8G6U7xko
        FJ7vimLlTbDTfRp4MYdcD+89LHnaSgCLTULW8iLsvFBOsLIIWr5JZ2UKTjkneV5ZSL4Ly2cT
        S0GQ5b/lawGwgkBGZ8jNYgxSnfT/N9QKnjzlMFkHKFtYjLQDjA/sAPI5Yn9BzQuVCqFASR/6
        kNFrFfo8NWOwA5nntMo4ooBMrecvaIwKqSwmNjYWxUm3yqRS8XOC1S3FCiGZRRuZHIbRMfp/
        cxjfR1SA0dgraybkF92DmGvU97EyJMA2uZLW3Lr30uWeneYv6+5LwjavSdi78Y77mbfP7PZR
        bjfkaMIDnb++2mjdt3566mZL/I4jwt9HJKvbjoTOj9S3v3G8Ny1meM/8e8sJjj1Ds7IMW9Nl
        5bMHlhT7Ygd744pn3Xan/3DCppQl65wkFP87IyX5eXNrS4Yo3REVZuS9zJGHZ1RUNaKvOZrp
        weXwNElArmK/a/u9/ANxM3e++6Gr8UdrXySIWD0vtxQGDfgdNa8L3DIqUV06ZVkOHHtLnp+U
        edia/WfHYdXcBwczXvq40Pe2Xr5xqLw9qOQMg4f8pG3Wpt9zOIdtGx5FrY7Yi4of14hxQzYt
        DePoDfQ/GMbielMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWy7bCSnK76r+nxBtOYLfYe+sNqsX3pGxaL
        zy1tTBZvJ35gs3jbPo3JYs75FhaL1R8fM1qcu/Kb3aL/0wxmix+LXrBZ/Hh0g8WiYfUFVosb
        v9pYLS5s62O1WLRyIZvFmxV32C2OLRCz2L12EZNF28wfTBYbV4VZzLo9idXiXuseJosZk1+y
        WUz/sZvJQcJj1v2zbB6X+3qZPJbf/Mvk0daU6bFl5U0mj52z7rJ7bFrVyeZx59oeNo/zUz09
        +rasYvT4vEnO4/azbSwBPFFcNimpOZllqUX6dglcGbPufmYv2MFb8aI7p4HxAHcXIyeHhICJ
        xPS779m7GLk4hAR2M0ps2fiUCSIhJTH323bGLkYOIFtY4vDhYpCwkMAnRon+yVYgNpuAjsT+
        Jb9ZQXpFBPYzSbScbAJzmAWOM0n8btzCDNIsLOAlcXi3MkgDi4CqxIVzz9hBbF4BN4lr5+ew
        QexSkFhw7y3bBEaeBYwMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgiNFS3MH4/ZV
        H/QOMTJxMB5ilOBgVhLhnSMzNV6INyWxsiq1KD++qDQntfgQozQHi5I4743ChXFCAumJJanZ
        qakFqUUwWSYOTqkGphnCJpE7Jm8Uv/Riq5CKxk2Xq0YLu+5tvHlmWcHPaYyzw622P+OUN21V
        vPtz+jn17TKLtabff3+vW8GgsnDSuZCV/L4V5hZf8mYpT1aSN/p57Lqh3YYjUVXu4TssIvKF
        ZWcFvuQxn1/bH9ezZTrDEf5T+T78Cyd/5z5zsb204/r5AyICmgKrGlwmKUU6/Lt63sL7ee36
        fPtXDx60P2ErNPu09njV0xT3sjmui5rieJu/i4g7rujdOkv63CZ7A58tZW9LDyZ3HVugJvhb
        Md5+kqC29QXPlBLnpm0cC7KMg2tYSiwOmpYzlFrNTK3RE9Q4lavyM1rnt2+PeNOSaMWZZnHT
        rIKeyanvfndiXfk1JZbijERDLeai4kQAyHEclgMDAAA=
X-CMS-MailID: 20201027104456epcas1p44c0f3c748f5aa52da1725d3e5a24b3de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201027104456epcas1p44c0f3c748f5aa52da1725d3e5a24b3de
References: <CGME20201027104456epcas1p44c0f3c748f5aa52da1725d3e5a24b3de@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are missig brcmf_free() for brcmf_alloc(). Fix memory leak
by adding missed brcmf_free().

Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
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

