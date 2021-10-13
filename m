Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B843942B441
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 06:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhJMEfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 00:35:22 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:47338 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229881AbhJMEfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 00:35:18 -0400
Received: from localhost.localdomain (unknown [222.205.7.222])
        by mail-app4 (Coremail) with SMTP id cS_KCgCXDSkQYWZhWpicAw--.35224S4;
        Wed, 13 Oct 2021 12:31:12 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     linux-nfc@lists.01.org
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, bongsu.jeon@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Ma <linma@zju.edu.cn>
Subject: [PATCH] NFC: NULL out conn_info reference when conn is closed
Date:   Wed, 13 Oct 2021 12:30:52 +0800
Message-Id: <20211013043052.16379-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgCXDSkQYWZhWpicAw--.35224S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4xJrWDWryxKrWxtrWDurg_yoW8Xw1kpa
        yfWFy3ta1DWr1ayF4UZFy8Xr13Zw4kGFZ7Kr95uw45C39xJryIvr4ktrya9FWDCFZ5Aanr
        Ar1Uta1UWF17uwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8XwCF04k20xvY0x0EwIxG
        rwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UfcTPUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nci_core_conn_close_rsp_packet() function will release the conn_info
with given conn_id. However, this reference of this object may still held
by other places like ndev->rf_conn_info in routine:
.. -> nci_recv_frame()
     -> nci_rx_work()
       -> nci_rsp_packet()
         -> nci_rf_disc_rsp_packet()
           -> devm_kzalloc()
              ndev->rf_conn_info = conn_info;

or ndev->hci_dev->conn_info in routine:
.. -> nci_recv_frame()
     -> nci_rx_work()
       -> nci_rsp_packet()
         -> nci_core_conn_create_rsp_packet()
           -> devm_kzalloc()
              ndev->hci_dev->conn_info = conn_info;

If these two places are not NULL out, potential UAF can be exploited by
the attacker when emulating an UART NFC device. This patch compares the
deallocating object with the two places and writes NULL to prevent that.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/nfc/nci/rsp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a2e72c003805..99de76e5e855 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -334,6 +334,14 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
 							 ndev->cur_conn_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			/* Other places held conn_info like
+			 * ndev->hci_dev->conn_info, ndev->rf_conn_info
+			 * need to be NULL out.
+			 */
+			if (ndev->hci_dev->conn_info == conn_info)
+				ndev->hci_dev->conn_info = NULL;
+			if (ndev->rf_conn_info == conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}
-- 
2.33.0

