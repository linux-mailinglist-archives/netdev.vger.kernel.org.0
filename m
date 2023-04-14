Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5267D6E2444
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjDNNaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDNNaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:30:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F6283D2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OV7CLSGwyWzYJ9UdQYVhqgvofzrlVZKp5tnXZmMZIqA=; b=bFMc0voxGEFIGE1UqyES8TABJG
        KR3+rhbe65QG2bPDDW3Hh2n1dV+KofrNfSNeMebabLkHRjDoBupcr++Dchr/wEWdv04E5luapeq6j
        KTPCIy3881PKoyQszSsL1VEDb1oi5dj/v/FAKSip4yNEYoV/DUPrzFMkM7ecxKY0dCac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pnJUx-00AHj9-J5; Fri, 14 Apr 2023 15:29:55 +0200
Date:   Fri, 14 Apr 2023 15:29:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 1/5] net: wangxun: libwx add tx offload functions
Message-ID: <da6a06f3-d08e-448c-9269-b6b8e0da647a@lunn.ch>
References: <20230414104833.42989-1-mengyuanlou@net-swift.com>
 <20230414104833.42989-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414104833.42989-2-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		case htons(ETH_P_1588):
> +			ptype = WX_PTYPE_L2_TS;
> +			goto exit;
> +		case htons(ETH_P_FIP):
> +			ptype = WX_PTYPE_L2_FIP;
> +			goto exit;
> +		case htons(WX_ETH_P_LLDP):
> +			ptype = WX_PTYPE_L2_LLDP;
> +			goto exit;

ETH_P_LLDP exists.

> +		case htons(WX_ETH_P_CNM):
> +			ptype = WX_PTYPE_L2_CNM;
> +			goto exit;

Is this Congestion Notification Message? Since this is part of 802.1Q,
i see no reason not to add it to if_ether.h

> +/* macro to make the table lines short */
> +#define WX_PTT(ptype, mac, ip, etype, eip, proto, layer)\
> +	      {ptype, \
> +	       1, \
> +	       WX_DEC_PTYPE_MAC_##mac,		/* mac */\
> +	       WX_DEC_PTYPE_IP_##ip,		/* ip */ \
> +	       WX_DEC_PTYPE_ETYPE_##etype,	/* etype */\
> +	       WX_DEC_PTYPE_IP_##eip,		/* eip */\
> +	       WX_DEC_PTYPE_PROT_##proto,	/* proto */\
> +	       WX_DEC_PTYPE_LAYER_##layer	/* layer */}
> +
> +#define WX_UKN(ptype) { ptype, 0, 0, 0, 0, 0, 0, 0 }
> +
> +/* Lookup table mapping the HW PTYPE to the bit field for decoding */
> +/* for ((pt=0;pt<256;pt++)); do printf "macro(0x%02X),\n" $pt; done */
> +static wx_dptype wx_ptype_lookup[256] = {
> +	WX_UKN(0x00),
> +	WX_UKN(0x01),
> +	WX_UKN(0x02),
> +	WX_UKN(0x03),
> +	WX_UKN(0x04),
> +	WX_UKN(0x05),
> +	WX_UKN(0x06),
> +	WX_UKN(0x07),
> +	WX_UKN(0x08),
> +	WX_UKN(0x09),
> +	WX_UKN(0x0A),
> +	WX_UKN(0x0B),
> +	WX_UKN(0x0C),
> +	WX_UKN(0x0D),
> +	WX_UKN(0x0E),
> +	WX_UKN(0x0F),

Since WX_UKN() is 0, you can skip them and use Designated Initializers.

https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html

	Andrew
