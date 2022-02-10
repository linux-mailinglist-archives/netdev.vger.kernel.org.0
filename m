Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00204B120D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbiBJPtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:49:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiBJPta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:49:30 -0500
Received: from asav21.altibox.net (asav21.altibox.net [109.247.116.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C415BAF;
        Thu, 10 Feb 2022 07:49:31 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id 0ED3980057;
        Thu, 10 Feb 2022 16:49:29 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 21AFnSp0671539
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 10 Feb 2022 16:49:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1644508168; bh=3h9EX+Wp/qqCte+/Xxvl0bps+n94aH8reUc0oM4lZ7c=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=DE5jF2ZBYESuyu9J8K3dxaRP8Ad7U9xgK5SZqWwFq4brlPFL+uxFAKu/gks1mVicf
         9GWjmld1iTs1jJevhSYePcQMkaVjk022MkKl8qZ4lbIFdbAPyEDVcNHW+TrRn3HtOF
         IT3/50zcYtVlvOKkEecfBaI8Tmy1IoOlgXpyweds=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nIBhI-002Zh3-8g; Thu, 10 Feb 2022 16:49:28 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: possible integer overflow in CDC-NCM checks
Organization: m
References: <68332064-3c38-fe81-b659-613940a6cfb1@suse.com>
Date:   Thu, 10 Feb 2022 16:49:28 +0100
In-Reply-To: <68332064-3c38-fe81-b659-613940a6cfb1@suse.com> (Oliver Neukum's
        message of "Thu, 10 Feb 2022 16:23:58 +0100")
Message-ID: <87a6eypvqv.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=Adef4UfG c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=M51BFTxLslgA:10
        a=iox4zFpeAAAA:8 a=pbfN2906ulaCXouL280A:9 a=QEXdDO2ut3YA:10
        a=WzC6qhA0u3u7Ye7llzcV:22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

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
> sk_buff *skb; struct cdc_ncm_ctx *ctx =3D (struct cdc_ncm_ctx
> *)dev->data[0]; - int len; + unsigned int len; int nframes; int x; - int
> offset; + unsigned int offset; union { struct usb_cdc_ncm_ndp16 *ndp16;
> struct usb_cdc_ncm_ndp32 *ndp32; @@ -1791,7 +1791,7 @@ int
> cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in) } /* sanity
> checking */ - if (((offset + len) > skb_in->len) || + if ((offset >
> skb_in->len - len) || (len > ctx->rx_max) || (len < ETH_HLEN)) {
> netif_dbg(dev, rx_err, dev->net, "invalid frame detected (ignored)
> offset[%u]=3D%u, length=3D%u, skb=3D%p\n", -- 2.34.1

I don't mind taking a look at it, but that's beyond unreadable...

Could you please resend using "git send-email" or something else that
works?



Bj=C3=B8rn
