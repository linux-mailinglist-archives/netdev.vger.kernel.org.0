Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCB2A745A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgKEBEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:04:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgKEBEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:04:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaThf-005JCz-HJ; Thu, 05 Nov 2020 02:04:39 +0100
Date:   Thu, 5 Nov 2020 02:04:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201105010439.GH933237@lunn.ch>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104165720.2566399-7-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dpaa2_switch_build_single_fd(struct ethsw_core *ethsw,
> +					struct sk_buff *skb,
> +					struct dpaa2_fd *fd)
> +{
> +	struct device *dev = ethsw->dev;
> +	struct sk_buff **skbh;
> +	dma_addr_t addr;
> +	u8 *buff_start;
> +	void *hwa;
> +
> +	buff_start = PTR_ALIGN(skb->data - DPAA2_SWITCH_TX_DATA_OFFSET -
> +			       DPAA2_SWITCH_TX_BUF_ALIGN,
> +			       DPAA2_SWITCH_TX_BUF_ALIGN);
> +
> +	/* Clear FAS to have consistent values for TX confirmation. It is
> +	 * located in the first 8 bytes of the buffer's hardware annotation
> +	 * area
> +	 */
> +	hwa = buff_start + DPAA2_SWITCH_SWA_SIZE;
> +	memset(hwa, 0, 8);
> +
> +	/* Store a backpointer to the skb at the beginning of the buffer
> +	 * (in the private data area) such that we can release it
> +	 * on Tx confirm
> +	 */
> +	skbh = (struct sk_buff **)buff_start;
> +	*skbh = skb;

Where is the TX confirm which uses this stored pointer. I don't see it
in this file.

It can be expensive to store pointer like this in buffers used for
DMA. It has to be flushed out of the cache here as part of the
send. Then the TX complete needs to invalidate and then read it back
into the cache. Or you use coherent memory which is just slow.

It can be cheaper to keep a parallel ring in cacheable memory which
never gets flushed.

      Andrew
