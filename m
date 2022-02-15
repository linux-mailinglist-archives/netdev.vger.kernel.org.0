Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB074B6D78
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiBONbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:31:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiBONbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:31:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351A2106B0E;
        Tue, 15 Feb 2022 05:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7BBEB819C7;
        Tue, 15 Feb 2022 13:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2847C340EB;
        Tue, 15 Feb 2022 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644931852;
        bh=SGwiNnAFsMNuAXfkYvqfCtWSIiMbagOqHSBujmw9Ntc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NC/gbd/rINWKSV+WAACc5+rd5EBgu251vktYAYJE86giJTlrvUEtxbtniVnOv5civ
         7Z/Ht4DtxAnne6YZnTGvZ5I2ix7SwPiH4ybM3Zj+U2a4H+86i97Qw2RC1R2NVMuht2
         x1T/UOC2JnehTeow5jlKbZ+ObAZdxb8p1gc/FduY=
Date:   Tue, 15 Feb 2022 14:30:49 +0100
From:   Greg KH <gregKH@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] CDC-NCM: avoid overflow in sanity checking
Message-ID: <YgurCSqIL/VkaBmR@kroah.com>
References: <20220215103547.29599-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215103547.29599-1-oneukum@suse.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 11:35:47AM +0100, Oliver Neukum wrote:
> A broken device may give an extreme offset like 0xFFF0
> and a reasonable length for a fragment. In the sanity
> check as formulated now, this will create an integer
> overflow, defeating the sanity check. Both offset
> and offset + len need to be checked in such a manner
> that no overflow can occur.
> And those quantities should be unsigned.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index e303b522efb5..15f91d691bba 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1715,10 +1715,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
>  {
>  	struct sk_buff *skb;
>  	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
> -	int len;
> +	unsigned int len;
>  	int nframes;
>  	int x;
> -	int offset;
> +	unsigned int offset;
>  	union {
>  		struct usb_cdc_ncm_ndp16 *ndp16;
>  		struct usb_cdc_ncm_ndp32 *ndp32;
> @@ -1790,8 +1790,8 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
>  			break;
>  		}
>  
> -		/* sanity checking */
> -		if (((offset + len) > skb_in->len) ||
> +		/* sanity checking - watch out for integer wrap*/
> +		if ((offset > skb_in->len) || (len > skb_in->len - offset) ||
>  				(len > ctx->rx_max) || (len < ETH_HLEN)) {
>  			netif_dbg(dev, rx_err, dev->net,
>  				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",
> -- 
> 2.34.1
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
