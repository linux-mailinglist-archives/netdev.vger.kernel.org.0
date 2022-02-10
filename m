Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9D94B135E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244662AbiBJQqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:46:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244202AbiBJQq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:46:29 -0500
X-Greylist: delayed 453 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 08:46:29 PST
Received: from mail.turbocat.net (turbocat.net [IPv6:2a01:4f8:c17:6c4b::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731A990;
        Thu, 10 Feb 2022 08:46:29 -0800 (PST)
Received: from [10.36.2.165] (unknown [178.17.145.105])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.turbocat.net (Postfix) with ESMTPSA id 855DB2600D0;
        Thu, 10 Feb 2022 17:38:54 +0100 (CET)
Message-ID: <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
Date:   Thu, 10 Feb 2022 17:38:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Content-Language: en-US
To:     Oliver Neukum <oneukum@suse.com>, bjorn@mork.no,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20220210155455.4601-1-oneukum@suse.com>
From:   Hans Petter Selasky <hps@selasky.org>
In-Reply-To: <20220210155455.4601-1-oneukum@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 16:54, Oliver Neukum wrote:
> A broken device may give an extreme offset like 0xFFF0
> and a reasonable length for a fragment. In the sanity
> check as formulated now, this will create an integer
> overflow, defeating the sanity check. It needs to be
> rewritten as a subtraction and the variables should be
> unsigned.
> 

Hi Oliver,

First of all I'd like to update:

Hans Petter Selasky <hans.petter.selasky@stericsson.com>

To:

Hans Petter Selasky <hselasky@freebsd.org>

Secondly,

"int" variables are 32-bit, so 0xFFF0 won't overflow.

The initial driver code written by me did only support 16-bit lengths 
and offset. Then integer overflow is not possible.

It looks like somebody else introduced this integer overflow :-(

commit 0fa81b304a7973a499f844176ca031109487dd31
Author: Alexander Bersenev <bay@hackerdom.ru>
Date:   Fri Mar 6 01:33:16 2020 +0500

     cdc_ncm: Implement the 32-bit version of NCM Transfer Block

     The NCM specification defines two formats of transfer blocks: with 
16-bit
     fields (NTB-16) and with 32-bit fields (NTB-32). Currently only 
NTB-16 is
     implemented.

....

With NCM 32, both "len" and "offset" must be checked, because these are 
now 32-bit and stored into regular "int".

The fix you propose is not fully correct!

--HPS

> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>   drivers/net/usb/cdc_ncm.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index e303b522efb5..f78fccbc4b93 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1715,10 +1715,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
>   {
>   	struct sk_buff *skb;
>   	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
> -	int len;
> +	unsigned int len;
>   	int nframes;
>   	int x;
> -	int offset;
> +	unsigned int offset;
>   	union {
>   		struct usb_cdc_ncm_ndp16 *ndp16;
>   		struct usb_cdc_ncm_ndp32 *ndp32;
> @@ -1791,7 +1791,7 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
>   		}
>   
>   		/* sanity checking */
> -		if (((offset + len) > skb_in->len) ||
> +		if ((offset > skb_in->len - len) ||
>   				(len > ctx->rx_max) || (len < ETH_HLEN)) {
>   			netif_dbg(dev, rx_err, dev->net,
>   				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",

