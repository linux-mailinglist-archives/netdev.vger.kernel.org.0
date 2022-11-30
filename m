Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9563D1C5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiK3JYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiK3JYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:24:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B9F2A967;
        Wed, 30 Nov 2022 01:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9362B81A99;
        Wed, 30 Nov 2022 09:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D885BC433C1;
        Wed, 30 Nov 2022 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669800287;
        bh=TdyM8hMpRwYA7lJLFOBGQQtN/uspLzJubg/tO0o+fBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qg/4JEpHq0VapvPQZG7o5odpmHpLltXvEx5sITQmJKCpHaaMtJZtLnqP50biDk+fP
         x/wACcZj6kakpvLUFNkXXEG91fjV2fc9frXFy/meS2rYHkYgBA/0pjGITswxQnoLec
         YS230P55xqjrmSnZNvqouwTSbArGMIT31m6aRWr7Z3op0Tm+Tb5ncKnWA/gwt5JKYn
         RlhgI9X9Ytne/HP4aJECeB9AuwuPkccN/WmKIzOda6Ia5SHTRuB1Lsvmdywc7lwBmz
         fISykQFyh8P3jKXuzmBQXeO/RHVlLxsgD8KeuT0y3xU263DpeEjY6NOBsMd556pV7s
         v+rcRUZRyflgA==
Date:   Wed, 30 Nov 2022 11:24:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/9] octeon_ep: defer probe if firmware not
 ready
Message-ID: <Y4chWyR6qTlptkTE@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129130933.25231-2-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 05:09:24AM -0800, Veerasenareddy Burru wrote:
> Defer probe if firmware is not ready for device usage.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>
> ---
> v1 -> v2:
>  * was scheduling workqueue task to wait for firmware ready,
>    to probe/initialize the device.
>  * now, removed the workqueue task; the probe returns EPROBE_DEFER,
>    if firmware is not ready.
>  * removed device status oct->status, as it is not required with the
>    modified implementation.
> 
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 5a898fb88e37..aa7d0ced9807 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -1017,6 +1017,25 @@ static void octep_device_cleanup(struct octep_device *oct)
>  	oct->conf = NULL;
>  }
>  
> +static u8 get_fw_ready_status(struct pci_dev *pdev)

Please change this function to return bool, you are not interested in
status.

> +{
> +	u32 pos = 0;
> +	u16 vsec_id;
> +	u8 status;
> +
> +	while ((pos = pci_find_next_ext_capability(pdev, pos,
> +						   PCI_EXT_CAP_ID_VNDR))) {
> +		pci_read_config_word(pdev, pos + 4, &vsec_id);
> +#define FW_STATUS_VSEC_ID  0xA3
> +		if (vsec_id == FW_STATUS_VSEC_ID) {

Success oriented flow, plase
if (vsec_id != FW_STATUS_VSEC_ID)
 cotitnue;

....

> +			pci_read_config_byte(pdev, (pos + 8), &status);
> +			dev_info(&pdev->dev, "Firmware ready %u\n", status);
> +			return status;
> +		}
> +	}
> +	return 0;
> +}
> +
>  /**
>   * octep_probe() - Octeon PCI device probe handler.
>   *
> @@ -1053,6 +1072,13 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	pci_enable_pcie_error_reporting(pdev);
>  	pci_set_master(pdev);
>  
> +#define FW_STATUS_READY    1
> +	if (get_fw_ready_status(pdev) != FW_STATUS_READY) {

No need to this new define if you change get_fw_ready_status() to return
true/false.

And I think that you can put this check earlier in octep_probe().

Thanks

> +		dev_notice(&pdev->dev, "Firmware not ready; defer probe.\n");
> +		err = -EPROBE_DEFER;
> +		goto err_alloc_netdev;
> +	}
> +
>  	netdev = alloc_etherdev_mq(sizeof(struct octep_device),
>  				   OCTEP_MAX_QUEUES);
>  	if (!netdev) {
> -- 
> 2.36.0
> 
