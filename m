Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4459522D21D
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGXXQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgGXXQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 19:16:05 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD73206F0;
        Fri, 24 Jul 2020 23:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595632565;
        bh=eqMUTQIurV39w4+oyz/r52Y3aolA936qQf19diXSnXk=;
        h=From:To:Cc:Subject:Date:From;
        b=c1ktj2d44SPmHwAKhVRVTrCj4P/c66B/yhoIfQdyVVSkSoswDR1BQ436mlR2XjFJ7
         HTiYju5rKK0nOqeWAXlplsqbHqK6Zyl0CGN+s7AInTVUj10ZpnjJ+JW5ifl/uqGSVx
         +8iO50KVC3Oirbb4ehM/umEW5rSqM4PFQU1uJBBw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        Jakub Kicinski <kuba@kernel.org>, Jake Lawrence <lawja@fb.com>
Subject: [PATCH net] mlx4: disable device on shutdown
Date:   Fri, 24 Jul 2020 16:15:43 -0700
Message-Id: <20200724231543.3295117-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that not disabling a PCI device on .shutdown may lead to
a Hardware Error with particular (perhaps buggy) BIOS versions:

    mlx4_en: eth0: Close port called
    mlx4_en 0000:04:00.0: removed PHC
    reboot: Restarting system
    {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
    {1}[Hardware Error]: event severity: fatal
    {1}[Hardware Error]:  Error 0, type: fatal
    {1}[Hardware Error]:   section_type: PCIe error
    {1}[Hardware Error]:   port_type: 4, root port
    {1}[Hardware Error]:   version: 1.16
    {1}[Hardware Error]:   command: 0x4010, status: 0x0143
    {1}[Hardware Error]:   device_id: 0000:00:02.2
    {1}[Hardware Error]:   slot: 0
    {1}[Hardware Error]:   secondary_bus: 0x04
    {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x2f06
    {1}[Hardware Error]:   class_code: 000604
    {1}[Hardware Error]:   bridge: secondary_status: 0x2000, control: 0x0003
    {1}[Hardware Error]:   aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00000000
    {1}[Hardware Error]:   aer_uncor_severity: 0x00062030
    {1}[Hardware Error]:   TLP Header: 40000018 040000ff 791f4080 00000000
[hw error repeats]
    Kernel panic - not syncing: Fatal hardware error!
    CPU: 0 PID: 2189 Comm: reboot Kdump: loaded Not tainted 5.6.x-blabla #1
    Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 05/05/2017

Fix the mlx4 driver.

This is a very similar problem to what had been fixed in:
commit 0d98ba8d70b0 ("scsi: hpsa: disable device during shutdown")
to address https://bugzilla.kernel.org/show_bug.cgi?id=199779.

Fixes: 2ba5fbd62b25 ("net/mlx4_core: Handle AER flow properly")
Reported-by: Jake Lawrence <lawja@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3d9aa7da95e9..2d3e45780719 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4356,12 +4356,14 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 static void mlx4_shutdown(struct pci_dev *pdev)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct mlx4_dev *dev = persist->dev;
 
 	mlx4_info(persist->dev, "mlx4_shutdown was called\n");
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	mlx4_pci_disable_device(dev);
 }
 
 static const struct pci_error_handlers mlx4_err_handler = {
-- 
2.26.2

