Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D061247EBB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfFQJrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:47:49 -0400
Received: from mout.web.de ([217.72.192.78]:56847 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfFQJrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 05:47:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560764846;
        bh=H/PHN8avuX81CPYaydwdQJ4ODG2xpiWuNDvE+koj39c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=fNK2WQ+oRZ/RzK25qnZ8cCqDfo+bKS6e8WdMsiPM+b2Z2EatEo37K9JTj/z9uhMFM
         RY4WACpsATZsu6UC5J96jC+fpPIRVrcH3qju+F3v/U0nGJE7R/JZJupAqzFNKxLkip
         XMGg8lRLxH133WDc0RxvMJDceXa5ij4c1nJyd/uA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.15.236.75]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LilAv-1iCyrT2O0z-00cyrg; Mon, 17
 Jun 2019 11:47:26 +0200
From:   Soeren Moch <smoch@web.de>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Soeren Moch <smoch@web.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] rt2x00: fix rx queue hang
Date:   Mon, 17 Jun 2019 11:46:56 +0200
Message-Id: <20190617094656.3952-1-smoch@web.de>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:3a3ZYjP+AqN63izDtlh9rhWTl4i2jSWid+rszOAEsfpWHT8/y3O
 NdCi9iShGxrhUFBc6Es54sBTPUJuMyXPc3yNbDBFXXGRwm4DAAe/x4XDBjHUNQ0qmtuvbNO
 sYmTTsA0/x9X7NxUg5LpzwtFCMeayiAdwkTFTeDPU1PQuB4uiN2rva5TVRB03K2WDgdQmH/
 EpLigVkko/2sDNhEnfXFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:p7/ouLm1HwM=:fr/6/hQornvx+OdS9e2yaU
 qY4oB+R2aQjIw78QJfTgz+kmgAjSFQNMjXSOfG5Uofda9cS8HmoeTUnJ367rs1FVRPf7UUOHu
 TcoHrLmezI2c9TvtcmFqeZb9GTwrOYk26HULwMBkC2ncnyD9PPAiW+IVafhW97Uti8QtOaNh3
 3arunkYxota5wdKoQ7dHtTqcBiO6YyOZqdxFIwS+vh2kf3s3QPybCUpRHOtyv6Xw87wFHEIO0
 oKVW3psf+fIgn/xbRCLCv/fWRE5WTbnokIV/4rWFVFGbR/7yEJMsBk9XZqemgvgMiUaqhLyJ5
 imJk8S5ePfmtHidCBCbMXcvUuecsKe2Yy0yoKYDd8ys4L2waHe3+PPxZTIK8KSd6ifYxtDuqm
 zzNvOCvy+ZzsePbUtYctsIRvzI8+ysFAnd274yVg1xFfVr2iF3+Sx+8DDzap57q83ota4uDRn
 4qv992ws15CN56is/U1HTYYqTxtZRcfb5PfEbTf3Sdey1ZSGZg/dGqxaowRQocnn4AoTc3Tyw
 PUVYS53eJWSoj/VMVF2EoK8fh8bTf38b9wuBe+43TXEp9KoAj3J1ySP/3Oxyuoakz949jvdnD
 qZtOSig34oOdQsy5Apz2/O6iWADeMh3b2eK+RfMKlZLRNgvdBbluGa7o4EnmEv2i+DLFmrPaC
 ksmyaXSDb9s/VkS4PrRLEHucLesPKgShpFF4j46+Ax4cmz1Q+YMo5lqgERfDLdneEgvrwS/QO
 a7V7G6E3huQIRhLEAdrxLo0f00A53otwzLvhooeb9qna6wC1ELT3eSFn+wdlRm/kI8DmA3/si
 59n0FHb6owOMqlGHdnxuuQKDBwPpG83MnIbS8JxfsnW2uu4fLzYUMVUxOcHyslvgvDWMCw6AN
 F3rs85H3+3eh2TGjPKk88Zqg45OGx1Pu+8B56rEMCWaBadqqz/W1whqaxzz9C2CgkGhuhLm53
 9US0CObCLBOUFkAIfUUCEzccmJOaX2iY=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ed194d136769 ("usb: core: remove local_irq_save() around
 ->complete() handler") the handlers rt2x00usb_interrupt_rxdone() and
rt2x00usb_interrupt_txdone() are not running with interrupts disabled
anymore. So these handlers are not guaranteed to run completely before
workqueue processing starts. So only mark entries ready for workqueue
processing after proper accounting in the dma done queue.
Note that rt2x00usb_work_rxdone() processes all available entries, not
only such for which queue_work() was called.

This fixes a regression on a RT5370 based wifi stick in AP mode, which
suddenly stopped data transmission after some period of heavy load. Also
stopping the hanging hostapd resulted in the error message "ieee80211
phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
Other operation modes are probably affected as well, this just was
the used testcase.

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete=
() handler")
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/=
wireless/ralink/rt2x00/rt2x00dev.c
index 1b08b01db27b..9c102a501ee6 100644
=2D-- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -263,9 +263,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);

 void rt2x00lib_dmadone(struct queue_entry *entry)
 {
-	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
 	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
+	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);

=2D-
2.17.1

