Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E778C52D496
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiESNqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239141AbiESNpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:45:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 731C93EF11
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652967904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUACszed+LKtoDqhdYYmgr5/vCgvv+F8dNjvbCN96TI=;
        b=fo/2n0uCQgyDFlYDgE/5KBdETTtDg0S54cJ70JnkxD/4351+Hp46WrtVHqacpbtHUloRgs
        JkHquV2kfrkApo0R36qkD68822QMfUQq66l9ez1nKlo4pi9OTaK84wnLlnEbk3Lb/UhGcv
        OJDXVzncL4oPkNjRq4HtLtq9cvZcaRI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-4TrUySsNP0eaNGilNT2QnQ-1; Thu, 19 May 2022 09:45:03 -0400
X-MC-Unique: 4TrUySsNP0eaNGilNT2QnQ-1
Received: by mail-wr1-f72.google.com with SMTP id w20-20020adfd1b4000000b0020cbb4347e6so1585864wrc.17
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jUACszed+LKtoDqhdYYmgr5/vCgvv+F8dNjvbCN96TI=;
        b=yLVpLcLoAfesrzDWaVBwd02x0xrxkWZu4/6FMN4wcuCMMIG3byXQ0oh8Pn73zCrpLL
         SOTF6X2nnJLSvbT24lAg5VbnFaRYhOqLJUiT/fGv2LFUsZiGfXrXUosEfDg95BaUdBvn
         KbcOY4mZzAD1JMlLIdbS8c7tAqO2SHf5mtXTYGuFo+7oedgpMMthH7PWG60IeZtUWG6E
         MLkCrAM9Flei1pbXlc9Edxj5Nr0EBV3lKUN120Lghp4WgrQCxC/SjOUOnaFwb5jRfuhV
         +BIUZXqsQv43GRiwD0GylC5jau+EFje8ab/phcs0FYbNuCSqO9vyPit7J2029EpdUyi4
         hE/A==
X-Gm-Message-State: AOAM533L/Seh1cew4Rrj2sgH01/wCK6htBOLB7j6+jhe1GXWVIbYg+G3
        dRBRHQOYRhXOeeqY3XqQm/nVz52A/hD3gKnKy3xbvqVBhMUy6SCFAtrE355zE5J89EKuDwYxv5A
        mHyzMpr9XYjg542E1
X-Received: by 2002:adf:d843:0:b0:20e:614b:2b37 with SMTP id k3-20020adfd843000000b0020e614b2b37mr4256435wrl.618.1652967902268;
        Thu, 19 May 2022 06:45:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXESZGh1S4y52UwXwL5zhLCE3culy1M92cbESkeVBvd/tI6Ye58ts5xYeIx0s6SAsFZ9Qfdw==
X-Received: by 2002:adf:d843:0:b0:20e:614b:2b37 with SMTP id k3-20020adfd843000000b0020e614b2b37mr4256412wrl.618.1652967902036;
        Thu, 19 May 2022 06:45:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id d16-20020a05600c34d000b00394867d66ddsm4511929wmq.35.2022.05.19.06.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:45:01 -0700 (PDT)
Message-ID: <179df95df2f29ed6dfaa6318690dbf0ef29d7d11.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Date:   Thu, 19 May 2022 15:45:00 +0200
In-Reply-To: <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
         <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 14:19 -0700, Tony Nguyen wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> Add the possibility to write raw bytes to the GNSS module through the
> first TTY device. This allows user to configure the module using the
> publicly available u-blox UBX protocol (version 29) commands.
> 
> Create a second read-only TTY device.
> 
> Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |   4 +-
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 241 +++++++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_gnss.h |  26 ++-
>  3 files changed, 240 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 60453b3b8d23..5c472ed99c7a 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -544,8 +544,8 @@ struct ice_pf {
>  	u32 msg_enable;
>  	struct ice_ptp ptp;
>  	struct tty_driver *ice_gnss_tty_driver;
> -	struct tty_port gnss_tty_port;
> -	struct gnss_serial *gnss_serial;
> +	struct tty_port *gnss_tty_port[ICE_GNSS_TTY_MINOR_DEVICES];
> +	struct gnss_serial *gnss_serial[ICE_GNSS_TTY_MINOR_DEVICES];
>  	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
>  	u16 rdma_base_vector;
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
> index c6d755f707aa..4b7b762cd787 100644
> --- a/drivers/net/ethernet/intel/ice/ice_gnss.c
> +++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
> @@ -1,10 +1,102 @@
>  // SPDX-License-Identifier: GPL-2.0
> -/* Copyright (C) 2018-2021, Intel Corporation. */
> +/* Copyright (C) 2021-2022, Intel Corporation. */
>  
>  #include "ice.h"
>  #include "ice_lib.h"
>  #include <linux/tty_driver.h>
>  
> +/**
> + * ice_gnss_do_write - Write data to internal GNSS
> + * @pf: board private structure
> + * @buf: command buffer
> + * @size: command buffer size
> + *
> + * Write UBX command data to the GNSS receiver
> + */
> +static unsigned int
> +ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
> +{
> +	struct ice_aqc_link_topo_addr link_topo;
> +	struct ice_hw *hw = &pf->hw;
> +	unsigned int offset = 0;
> +	int err = 0;
> +
> +	memset(&link_topo, 0, sizeof(struct ice_aqc_link_topo_addr));
> +	link_topo.topo_params.index = ICE_E810T_GNSS_I2C_BUS;
> +	link_topo.topo_params.node_type_ctx |=
> +		FIELD_PREP(ICE_AQC_LINK_TOPO_NODE_CTX_M,
> +			   ICE_AQC_LINK_TOPO_NODE_CTX_OVERRIDE);
> +
> +	/* It's not possible to write a single byte to u-blox.
> +	 * Write all bytes in a loop until there are 6 or less bytes left. If
> +	 * there are exactly 6 bytes left, the last write would be only a byte.
> +	 * In this case, do 4+2 bytes writes instead of 5+1. Otherwise, do the
> +	 * last 2 to 5 bytes write.
> +	 */
> +	while (size - offset > ICE_GNSS_UBX_WRITE_BYTES + 1) {
> +		err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
> +				       cpu_to_le16(buf[offset]),
> +				       ICE_MAX_I2C_WRITE_BYTES,
> +				       &buf[offset + 1], NULL);
> +		if (err)
> +			goto exit;
> +
> +		offset += ICE_GNSS_UBX_WRITE_BYTES;
> +	}
> +
> +	/* Single byte would be written. Write 4 bytes instead of 5. */
> +	if (size - offset == ICE_GNSS_UBX_WRITE_BYTES + 1) {
> +		err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
> +				       cpu_to_le16(buf[offset]),
> +				       ICE_MAX_I2C_WRITE_BYTES - 1,
> +				       &buf[offset + 1], NULL);
> +		if (err)
> +			goto exit;
> +
> +		offset += ICE_GNSS_UBX_WRITE_BYTES - 1;
> +	}
> +
> +	/* Do the last write, 2 to 5 bytes. */
> +	err = ice_aq_write_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
> +			       cpu_to_le16(buf[offset]), size - offset - 1,
> +			       &buf[offset + 1], NULL);
> +	if (!err)
> +		offset = size;
> +
> +exit:
> +	if (err)
> +		dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=%u, size=%u, err=%d\n",
> +			offset, size, err);
> +
> +	return offset;


IMHO more readable with:
	if (err)
		goto err_out;

	return size;

err_out:
	dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=%u, size=%u, err=%d\n",
			offset, size, err);
	return offset;

(plus adjusting the goto above)

Thanks!

Paolo

