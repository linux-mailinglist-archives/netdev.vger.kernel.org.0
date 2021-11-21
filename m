Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D645863D
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 21:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhKUULe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 15:11:34 -0500
Received: from mx1.polytechnique.org ([129.104.30.34]:55557 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhKUULd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 15:11:33 -0500
Received: from localhost.localdomain (85-168-38-217.rev.numericable.fr [85.168.38.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ssl.polytechnique.org (Postfix) with ESMTPSA id C4E2B5647E1;
        Sun, 21 Nov 2021 21:08:25 +0100 (CET)
From:   Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] net: ax88796c: do not receive data in pointer
Date:   Sun, 21 Nov 2021 21:06:42 +0100
Message-Id: <20211121200642.2083316-1-nicolas.iooss_linux@m4x.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Checked: ClamAV using ClamSMTP at svoboda.polytechnique.org (Sun Nov 21 21:08:26 2021 +0100 (CET))
X-Spam-Flag: No, tests=bogofilter, spamicity=0.009647, queueID=1335A5647E2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function axspi_read_status calls:

    ret = spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1,
                              (u8 *)&status, 3);

status is a pointer to a struct spi_status, which is 3-byte wide:

    struct spi_status {
        u16 isr;
        u8 status;
    };

But &status is the pointer to this pointer, and spi_write_then_read does
not dereference this parameter:

    int spi_write_then_read(struct spi_device *spi,
                            const void *txbuf, unsigned n_tx,
                            void *rxbuf, unsigned n_rx)

Therefore axspi_read_status currently receive a SPI response in the
pointer status, which overwrites 24 bits of the pointer.

Thankfully, on Little-Endian systems, the pointer is only used in

    le16_to_cpus(&status->isr);

... which is a no-operation. So there, the overwritten pointer is not
dereferenced. Nevertheless on Big-Endian systems, this can lead to
dereferencing pointers after their 24 most significant bits were
overwritten. And in all systems this leads to possible use of
uninitialized value in functions calling spi_write_then_read which
expect status to be initialized when the function returns.

Moreover function axspi_read_status (and macro AX_READ_STATUS) do not
seem to be used anywhere. So currently this seems to be dead code. Fix
the issue anyway so that future code works properly when using function
axspi_read_status.

Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver")

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/net/ethernet/asix/ax88796c_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/ethernet/asix/ax88796c_spi.c
index 94df4f96d2be..0710e716d682 100644
--- a/drivers/net/ethernet/asix/ax88796c_spi.c
+++ b/drivers/net/ethernet/asix/ax88796c_spi.c
@@ -34,7 +34,7 @@ int axspi_read_status(struct axspi_data *ax_spi, struct spi_status *status)
 
 	/* OP */
 	ax_spi->cmd_buf[0] = AX_SPICMD_READ_STATUS;
-	ret = spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1, (u8 *)&status, 3);
+	ret = spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1, (u8 *)status, 3);
 	if (ret)
 		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
 	else
-- 
2.33.1

