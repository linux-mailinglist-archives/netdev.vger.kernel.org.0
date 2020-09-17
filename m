Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95F626D466
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIQHQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgIQHQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 03:16:10 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05C82072E;
        Thu, 17 Sep 2020 07:16:08 +0000 (UTC)
Date:   Thu, 17 Sep 2020 10:16:05 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Herrington <hankinsea@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: mark symbols static where possible
Message-ID: <20200917071605.GQ486552@unreal>
References: <20200917022508.9732-1-hankinsea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200917022508.9732-1-hankinsea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 10:25:08AM +0800, Herrington wrote:
> We get 1 warning when building kernel with W=1:
> drivers/ptp/ptp_pch.c:182:5: warning: no previous prototype for ‘pch_ch_control_read’ [-Wmissing-prototypes]
>  u32 pch_ch_control_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for ‘pch_ch_control_write’ [-Wmissing-prototypes]
>  void pch_ch_control_write(struct pci_dev *pdev, u32 val)
> drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for ‘pch_ch_event_read’ [-Wmissing-prototypes]
>  u32 pch_ch_event_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for ‘pch_ch_event_write’ [-Wmissing-prototypes]
>  void pch_ch_event_write(struct pci_dev *pdev, u32 val)
> drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for ‘pch_src_uuid_lo_read’ [-Wmissing-prototypes]
>  u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for ‘pch_src_uuid_hi_read’ [-Wmissing-prototypes]
>  u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for ‘pch_rx_snap_read’ [-Wmissing-prototypes]
>  u64 pch_rx_snap_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for ‘pch_tx_snap_read’ [-Wmissing-prototypes]
>  u64 pch_tx_snap_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for ‘pch_set_station_address’ [-Wmissing-prototypes]
>  int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
>
> Signed-off-by: Herrington <hankinsea@gmail.com>
> ---
>  drivers/ptp/ptp_pch.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

This file is total mess.

>
> diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
> index ce10ecd41ba0..8db2d1893577 100644
> --- a/drivers/ptp/ptp_pch.c
> +++ b/drivers/ptp/ptp_pch.c
> @@ -179,7 +179,7 @@ static inline void pch_block_reset(struct pch_dev *chip)
>  	iowrite32(val, (&chip->regs->control));
>  }
>
> -u32 pch_ch_control_read(struct pci_dev *pdev)
> +static u32 pch_ch_control_read(struct pci_dev *pdev)
>  {
>  	struct pch_dev *chip = pci_get_drvdata(pdev);
>  	u32 val;
> @@ -190,7 +190,7 @@ u32 pch_ch_control_read(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pch_ch_control_read);

This function is not used and can be deleted.

>
> -void pch_ch_control_write(struct pci_dev *pdev, u32 val)
> +static void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>  {
>  	struct pch_dev *chip = pci_get_drvdata(pdev);
>
> @@ -198,7 +198,7 @@ void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>  }
>  EXPORT_SYMBOL(pch_ch_control_write);


This function in use (incorrectly) by
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c

Your patch will break it.

I didn't check other functions, but assume they are broken too.

Thanks
