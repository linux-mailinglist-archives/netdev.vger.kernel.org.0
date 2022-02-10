Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF84B1215
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbiBJPvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:51:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiBJPvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD902BAE;
        Thu, 10 Feb 2022 07:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 682F460C73;
        Thu, 10 Feb 2022 15:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282BBC004E1;
        Thu, 10 Feb 2022 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644508301;
        bh=nubEB62qXGgMipLJXS91h6q6SoVK1lEkSdMk43wWdT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S44eB9FGzytQ+OJB53LFbGNe0lq9tirKkHsoUsOH6+I+NL6f9xrtyhS2f9fCnlarH
         nHYevbCzAYnXu+iTufRF3msGYQ622tTiNNU3FwWRrsoMTep+veV1rUlJSAYxBE5LOJ
         Fi1EIHgNUQzsHYVz0j5g3+R6JH7x5X0BysiSMWAY=
Date:   Thu, 10 Feb 2022 16:51:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: possible integer overflow in CDC-NCM checks
Message-ID: <YgU0imlDm4Otol6a@kroah.com>
References: <68332064-3c38-fe81-b659-613940a6cfb1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68332064-3c38-fe81-b659-613940a6cfb1@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:23:58PM +0100, Oliver Neukum wrote:
> Hi,
> 
> unfortunately there is no maintainer and you were among
> the last to send fixes for this driver, so I am going to ask
> you for review.
> 
> It looks to me like the sanity check in
> cdc_ncm_rx_fixup() can be fooled by abusing integer overflows.
> You cannot guarantee that the addition of offset and len will
> fit into an integer and this gets worse if offset can be
> negative.
> 
> As this is tricky, do you think this fix is correct?
> 
>     Regards
>         Oliver
> 
> CDC-NCM: avoid overflow in sanity checking A broken device may give an
> extreme offset like 0xFFF0 and a reasonable length for a fragment. In
> the sanity check as formulated now, this will create an integer
> overflow, defeating the sanity check. It needs to be rewritten as a
> subtraction and the variables should be unsigned. Signed-off-by: Oliver
> Neukum <oneukum@suse.com> --- drivers/net/usb/cdc_ncm.c | 6 +++--- 1
> file changed, 3 insertions(+), 3 deletions(-) diff --git
> a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c index
> e303b522efb5..f78fccbc4b93 100644 --- a/drivers/net/usb/cdc_ncm.c +++
> b/drivers/net/usb/cdc_ncm.c @@ -1715,10 +1715,10 @@ int
> cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in) { struct
> sk_buff *skb; struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx
> *)dev->data[0]; - int len; + unsigned int len; int nframes; int x; - int
> offset; + unsigned int offset; union { struct usb_cdc_ncm_ndp16 *ndp16;
> struct usb_cdc_ncm_ndp32 *ndp32; @@ -1791,7 +1791,7 @@ int
> cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in) } /* sanity
> checking */ - if (((offset + len) > skb_in->len) || + if ((offset >
> skb_in->len - len) || (len > ctx->rx_max) || (len < ETH_HLEN)) {
> netif_dbg(dev, rx_err, dev->net, "invalid frame detected (ignored)
> offset[%u]=%u, length=%u, skb=%p\n", -- 2.34.1
> 

Your fix is impossible to read :(
