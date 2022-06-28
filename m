Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E570C55DBD4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiF1Fmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245055AbiF1Fml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2253A15FFC;
        Mon, 27 Jun 2022 22:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4C13B81C0D;
        Tue, 28 Jun 2022 05:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DC4C3411D;
        Tue, 28 Jun 2022 05:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656394957;
        bh=i4IQ7mI8v3I51rhfoiIPQVDJPufpQ55yf7neoa0dHJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UlbPryCxIRTdLBTqYWQU8lnuCx6bve+r9jG/ypm4NcgLz4sWstZlEx4LrqjRpmjXM
         g2x8cRdM066MxplrOX7bvB44rSfKQ2pDaiLw7lTxA5H8hLljrmVbnop8bjSNGJfzLL
         5R8tl4h/tQAqca/jydyJLKImb63d3G9mGEFVjULE=
Date:   Tue, 28 Jun 2022 07:42:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Franklin Lin <franklin_lin@wistron.corp-partner.google.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        franklin_lin@wistron.com
Subject: Re: [PATCH] drivers/net/usb/r8152: Enable MAC address passthru
 support
Message-ID: <YrqUyvS1OVSTIvvP@kroah.com>
References: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:53:25AM +0800, Franklin Lin wrote:
> From: franklin_lin <franklin_lin@wistron.corp-partner.google.com>
> 
> Enable the support for providing a MAC address
> for a dock to use based on the VPD values set in the platform.
> 
> Signed-off-by: franklin_lin <franklin_lin@wistron.corp-partner.google.com>
> ---
>  drivers/net/usb/r8152.c | 49 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 7389d6ef8..732e48d99 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -3,6 +3,7 @@
>   *  Copyright (c) 2014 Realtek Semiconductor Corp. All rights reserved.
>   */
>  
> +#include <linux/fs.h>
>  #include <linux/signal.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -1608,6 +1609,11 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
>  
> +	struct file *fp;
> +	unsigned char read_buf[32];
> +	loff_t f_pos = 0;
> +	int i, j, len;
> +
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
>  		mac_obj_type = ACPI_TYPE_STRING;
> @@ -1641,22 +1647,39 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
>  	/* returns _AUXMAC_#AABBCCDDEEFF# */
>  	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
>  	obj = (union acpi_object *)buffer.pointer;
> -	if (!ACPI_SUCCESS(status))
> -		return -ENODEV;
> -	if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
> -		netif_warn(tp, probe, tp->netdev,
> +	if (ACPI_SUCCESS(status)) {
> +		if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
> +			netif_warn(tp, probe, tp->netdev,
>  			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",
>  			   obj->type, obj->string.length);
> -		goto amacout;
> -	}
> -
> -	if (strncmp(obj->string.pointer, "_AUXMAC_#", 9) != 0 ||
> -	    strncmp(obj->string.pointer + 0x15, "#", 1) != 0) {
> -		netif_warn(tp, probe, tp->netdev,
> -			   "Invalid header when reading pass-thru MAC addr\n");
> -		goto amacout;
> +			goto amacout;
> +		}
> +		if (strncmp(obj->string.pointer, "_AUXMAC_#", 9) != 0 ||
> +			strncmp(obj->string.pointer + 0x15, "#", 1) != 0) {
> +			netif_warn(tp, probe, tp->netdev,
> +				"Invalid header when reading pass-thru MAC addr\n");
> +			goto amacout;
> +		}
> +		ret = hex2bin(buf, obj->string.pointer + 9, 6);
> +	} else {
> +		/* read from "/sys/firmware/vpd/ro/dock_mac" */
> +		fp = filp_open("/sys/firmware/vpd/ro/dock_mac", O_RDONLY, 0);

Woah, what?  No, that's not how firmware works at all, sorry.  Please
use the correct firmware interface if this really is firmware.  If it is
not, please use the correct networking interface instead.

you should NEVER read from a file from a driver, that is a sure sign
something is really really wrong.

thanks,

greg k-h
