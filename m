Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138BA5541DF
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347603AbiFVEwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiFVEwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:52:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4872E35858
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 21:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D78B661949
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0168CC34114;
        Wed, 22 Jun 2022 04:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655873542;
        bh=o2pO/1klxyMLGn+rFqnSe6Z40EyODwBTkjoQVa5ndgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XpxQm0qdAIXvEvdI/joK3JaZ6Y7FL5nEtQ21fGSTKwvYXlN0OssjiHRh/9Od3+XnG
         Tk0t8aZR+tikpK/pCMEdFNiaXX7pl9G2k4eT+afVm//h7qzKTq6Xuula0GGItcyhF7
         K/7ixaNKPEfjNbKb4ulyzwK4j2OZsUC1c8ZHu9He3CPgA0Dpx87kLocB//kcc4LnxJ
         stGUpK/zqmelW53NOAtPGCRV0vdlBuiMhX1eER3TLvVRvkSQaG0kWBkycNdbFH9Hot
         3UpdxdfZOmvdwLTFYyguQ/LHRcD82UBhBI6BqaAchVXz/rSxQ8mhQr0UGf3SmUQEGi
         k/zCb0AXF+5Sw==
Date:   Tue, 21 Jun 2022 21:52:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net: usb: ax88179_178a: ax88179_rx_fixup corrections
Message-ID: <20220621215220.78f86712@kernel.org>
In-Reply-To: <8d3ed098f1dc0ce98191abf5e924c9e81250ea27.camel@gmail.com>
References: <8d3ed098f1dc0ce98191abf5e924c9e81250ea27.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 00:59:46 -0300 Jose Alonso wrote:
> This patch corrects the receiving of packets in ax88179_rx_fixup.
> 
> corrections:
> - the size check of the bounds of the metadata array.
> - the handling of the metadata array.
>    The current code is allways exiting with return 0
>    while trying to access pkt_hdr out of metadata array and
>    generating RX Errors.
> - avoid changing the skb->data content (swap bytes) in case
>    of big-endian. le32_to_cpus(pkt_hdr)
> 
> Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Whenever you have to write a list like this chances are the change
should be split into multiple patches. Please try to perform the fixes
first and code refactoring afterwards, so that the fixes can be
backported to older releases easily.

>  static void
> -ax88179_rx_checksum(struct sk_buff *skb, u32 *pkt_hdr)
> +ax88179_rx_checksum(struct sk_buff *skb, u32 pkt_hdr_val)
>  {
>  	skb->ip_summed = CHECKSUM_NONE;
>  
>  	/* checksum error bit is set */
> -	if ((*pkt_hdr & AX_RXHDR_L3CSUM_ERR) ||
> -	    (*pkt_hdr & AX_RXHDR_L4CSUM_ERR))
> +	if ((pkt_hdr_val & AX_RXHDR_L3CSUM_ERR) ||
> +	    (pkt_hdr_val & AX_RXHDR_L4CSUM_ERR))
>  		return;
>  
>  	/* It must be a TCP or UDP packet with a valid checksum */
> -	if (((*pkt_hdr & AX_RXHDR_L4_TYPE_MASK) == AX_RXHDR_L4_TYPE_TCP) ||
> -	    ((*pkt_hdr & AX_RXHDR_L4_TYPE_MASK) == AX_RXHDR_L4_TYPE_UDP))
> +	if (((pkt_hdr_val & AX_RXHDR_L4_TYPE_MASK) == AX_RXHDR_L4_TYPE_TCP) ||
> +	    ((pkt_hdr_val & AX_RXHDR_L4_TYPE_MASK) == AX_RXHDR_L4_TYPE_UDP))
>  		skb->ip_summed = CHECKSUM_UNNECESSARY;
>  }

This for example looks like pure refactoring which can be done
separately.

> +	 *   <dummy-header> contains 4 bytes:
> +	 *		pkt_len=0 and AX_RXHDR_DROP_ERR
> +	 *   <rx-hdr>	contains 4 bytes:
> +	 *		pkt_cnt and hdr_off (offset of 

There's trailing whitespace on this line.
