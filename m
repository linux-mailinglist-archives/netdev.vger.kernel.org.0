Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC60155C1E3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbiF1IyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245613AbiF1Ix4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:53:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 894C52D1CA
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656406434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qn+7M6/58v/qWfDB4rVpPVkzumdDHs8l3v8xNnDREoM=;
        b=dmXtIXukyauI+07wtPnGvysOP9/SjSUWSpWVzeTyrtRsfhsZS50rX4R6+vIFNuwV09RSq4
        RxkmCl3wmlh7tT9L/34jL46idI6EaBc/2wYsF7cdCmOmHLIR48anWfucHqI5JVkbyDjKG0
        2sv9Nng1I/H/4EXE9/Grk187FN2fHhM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-iqs9QXQ-PAeNwk3VTTFTBw-1; Tue, 28 Jun 2022 04:53:53 -0400
X-MC-Unique: iqs9QXQ-PAeNwk3VTTFTBw-1
Received: by mail-wr1-f70.google.com with SMTP id q15-20020a5d61cf000000b0021bc2461141so1032424wrv.5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Qn+7M6/58v/qWfDB4rVpPVkzumdDHs8l3v8xNnDREoM=;
        b=Hlc3XfpBgosTSzKeJr+Fq5lWFMNbTfU/9ryKJCwlI6QKP/Cq6YKgP+2xbrO1HlCkEh
         /qUSAZDbmQ4heqUxO6n0wh3wdiCL2SYrzIVw/Mqi6si7jvVug8NQIRWvIl+l3DLPFBzv
         gFk1RmLXngKqKSqZsgyFlgBJ6XOVK/PXsx7tP98zBbORBKGm06gXHq12CTT+isXFTjPy
         wFdMm1FsRQmrj8YbUTY/W4wywfZh1Ydvb11wCKS+B6hQ+Uy7TL/55FUvPrHsSF6ITbPz
         jdn+6vUN3lADex3K4719uiqHvyd4Lf3Vnmo3TMyCZm2zwrkCa7s2wCcJgXgW0MxJ9XZf
         li2w==
X-Gm-Message-State: AJIora9ix5JAU+AL75NeCbmbqmhkeJPKhIhPtQ3S2jIHo/IdwjVLkibE
        doaymebX8Wm53dxAk/LHR/8B+qv5NdAHjF9JY14KhJxPQqWsapq+aaO3GKb9lkhmgjELb+oBkmc
        mVSYSFDHROCL1AuzY
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr16731482wrr.472.1656406431535;
        Tue, 28 Jun 2022 01:53:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uVVSqLPpd47qGJlZPEVc0zvOb11zq7Jr3nvdEZtxQY7UDHwACWiMGFBNrmh/UfpUP25V0iag==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr16731460wrr.472.1656406431240;
        Tue, 28 Jun 2022 01:53:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-110.dyn.eolo.it. [146.241.115.110])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c024700b003a03e63e428sm15912113wmj.36.2022.06.28.01.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 01:53:50 -0700 (PDT)
Message-ID: <6e6e2482e3cf917b9cf34b4e180d95e568b0848c.camel@redhat.com>
Subject: Re: [PATCH] net: usb: ax88179_178a: corrects packet receiving
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jose Alonso <joalonsof@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 28 Jun 2022 10:53:49 +0200
In-Reply-To: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
References: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-23 at 11:06 -0300, Jose Alonso wrote:
> This patch corrects the packet receiving in ax88179_rx_fixup.
> 
> - problem observed:
>   ifconfig shows always a lot of 'RX Errors' while packets
>   are received normally.
> 
>   This occurs because ax88179_rx_fixup does not recognize properly
>   the usb urb received.
>   The packets are normally processed and at the end, the code exits
>   with 'return 0', generating RX Errors.
>   (with pkt_cnt==-2 and ptk_hdr over the field rx_hdr trying to identify
>    another packet there)
> 
>   This is a usb urb received by "tcpdump -i usbmon2 -X":
>   0x0000:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
>            ^         packet 1 start (pkt_len = 0x05ec)
>            ^^^^      IP alignment pseudo header
>                 ^    ethernet frame start
>            last byte of packet        vv
>            padding (8-bytes aligned)     vvvv vvvv
>   0x05e0:  c92d d444 1420 8a69 83dd 272f e82b 9811
>   0x05f0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
>   ...      ^ packet 2
>   0x0be0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
>   ...
>   0x1130:  9d41 9171 8a38 0ec5 eeee f8e3 3b19 87a0
>   ...
>   0x1720:  8cfc 15ff 5e4c e85c eeee f8e3 3b19 87a0
>   ...
>   0x1d10:  ecfa 2a3a 19ab c78c eeee f8e3 3b19 87a0
>   ...
>   0x2070:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
>   ...      ^ packet 7
>   0x2120:  7c88 4ca5 5c57 7dcc 0d34 7577 f778 7e0a
>   0x2130:  f032 e093 7489 0740 3008 ec05 0000 0080
>                                ====1==== ====2====
>            hdr_off             ^
>            pkt_len = 0x05ec         ^^^^
>            AX_RXHDR_*=0x00830  ^^^^   ^
>            pkt_len = 0                        ^^^^
>            AX_RXHDR_DROP_ERR=0x80000000  ^^^^   ^
>   0x2140:  3008 ec05 0000 0080 3008 5805 0000 0080
>   0x2150:  3008 ec05 0000 0080 3008 ec05 0000 0080
>   0x2160:  3008 5803 0000 0080 3008 c800 0000 0080
>            ===11==== ===12==== ===13==== ===14====
>   0x2170:  0000 0000 0e00 3821
>                      ^^^^ ^^^^ rx_hdr
>                      ^^^^      pkt_cnt=14
>                           ^^^^ hdr_off=0x2138
>            ^^^^ ^^^^           padding
> 
>   The dump shows that pkt_cnt is the number of entries in the
>   per-packet metadata. It is "2 * packet count".
>   Each packet have two entries. The first have a valid
>   value (pkt_len and AX_RXHDR_*) and the second have a
>   dummy-header 0x80000000 (pkt_len=0 with AX_RXHDR_DROP_ERR).
>   Why exists dummy-header for each packet?!?
>   My guess is that this was done probably to align the
>   entry for each packet to 64-bits and maintain compatibility
>   with old firmware.
>   There is also a padding (0x00000000) before the rx_hdr to
>   align the end of rx_hdr to 64-bit.
>   Note that packets have a alignment of 64-bits (8-bytes).
> 
>   This patch assumes that the dummy-header and the last
>   padding are optional. So it preserves semantics and
>   recognizes the same valid packets as the current code.
>  
>   This patch was made using only the dump file information and
>   tested with only one device:
>   0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet
> 
> Signed-off-by: Jose Alonso <joalonsof@gmail.com>
> 
> ---
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index 4704ed6f00ef..02bd113c5045 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1472,6 +1472,42 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  	 * are bundled into this buffer and where we can find an array of
>  	 * per-packet metadata (which contains elements encoded into u16).
>  	 */
> +
> +	/* SKB contents for current firmware:
> +	 *   <packet 1> <padding>
> +	 *   ...
> +	 *   <packet N> <padding>
> +	 *   <per-packet metadata entry 1> <dummy header>
> +	 *   ...
> +	 *   <per-packet metadata entry N> <dummy header>
> +	 *   <padding2> <rx_hdr>
> +	 *
> +	 * where:
> +	 *   <packet N> contains pkt_len bytes:
> +	 *		2 bytes of IP alignment pseudo header
> +	 *		packet received
> +	 *   <per-packet metadata entry N> contains 4 bytes:
> +	 *		pkt_len and fields AX_RXHDR_*
> +	 *   <padding>	0-7 bytes to terminate at
> +	 *		8 bytes boundary (64-bit).
> +	 *   <padding2> 4 bytes to make rx_hdr terminate at
> +	 *		8 bytes boundary (64-bit)
> +	 *   <dummy-header> contains 4 bytes:
> +	 *		pkt_len=0 and AX_RXHDR_DROP_ERR
> +	 *   <rx-hdr>	contains 4 bytes:
> +	 *		pkt_cnt and hdr_off (offset of
> +	 *		  <per-packet metadata entry 1>)
> +	 *
> +	 * pkt_cnt is number of entries in the per-packet metadata.
> +	 * In current firmware there is 2 entries per packet.
> +	 * The first points to the packet and the
> +	 *  second is a dummy header.
> +	 * This was done probably to align fields in 64-bit and
> +	 *  maintain compatibility with old firmware.
> +	 * This code assumes that <dummy header> and <padding2> are
> +	 *  optional.
> +	 */
> +
>  	if (skb->len < 4)
>  		return 0;
>  	skb_trim(skb, skb->len - 4);
> @@ -1485,51 +1521,66 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  	/* Make sure that the bounds of the metadata array are inside the SKB
>  	 * (and in front of the counter at the end).
>  	 */
> -	if (pkt_cnt * 2 + hdr_off > skb->len)
> +	if (pkt_cnt * 4 + hdr_off > skb->len)
>  		return 0;
>  	pkt_hdr = (u32 *)(skb->data + hdr_off);
>  
>  	/* Packets must not overlap the metadata array */
>  	skb_trim(skb, hdr_off);
>  
> -	for (; ; pkt_cnt--, pkt_hdr++) {
> +	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
>  		u16 pkt_len;
> +		u16 pkt_len_plus_padd;

Very minor nit: please respect the reverse xmas tree order in variable
declaration - in this case:

		u16 pkt_len_plus_padd;
		u16 pkt_len;

Other then that, LGTM! Feel free to include my acked-by tag on re-spin.

I understand this is targeting -net, if so please include the correct
tag into the patch subj. Additionally adding a Fixes tag is advised, if
your intention is push this patch to stable trees.

Thanks!

Paolo

