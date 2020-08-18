Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A059224833A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHRKkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgHRKkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:40:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0688C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EgxluJtSwSB4hG73Dg/lU+tgvA30akhkiqvcWLa/qIw=; b=n2r7+o9dznc6fQaKxznvx+CHD
        lHQUZRhqjIF3YovOUZXWV5u99sr6lGvAq059IVMnb8Q8mD+2LaCRec0ihYnMFnNbIn4JWpfNA6CIA
        S8uwKG45A4aaKcnmO/lhcZLrmzs8geSkmjl2+rMRnyvIMDw9z+1Reya7Fu/KSlWjINp7p9JO7QA+e
        PseNqx3k1gvA95sg6NxLVvz831XQuyR/7uxwbI7UzauRkBqROjHclp6GGpGV+pJvUXXnq+whj5xZM
        gb3ULsbi+BUvsj502UANBcVi6sgRzvH5/a/ziofUfPhgXFE6ZJzxNC2SDUqVMP6s2RdpQNRMDlklw
        9IBTwUu3A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54020)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k7z2C-0000JA-ST; Tue, 18 Aug 2020 11:40:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k7z2C-0001LV-Cg; Tue, 18 Aug 2020 11:40:04 +0100
Date:   Tue, 18 Aug 2020 11:40:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 2/9] ptp: Add generic ptp message type function
Message-ID: <20200818104004.GA1551@shell.armlinux.org.uk>
References: <20200818103251.20421-1-kurt@linutronix.de>
 <20200818103251.20421-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818103251.20421-3-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:32:44PM +0200, Kurt Kanzenbach wrote:
> The message type is located at different offsets within the ptp header depending
> on the ptp version (v1 or v2). Therefore, drivers which also deal with ptp v1
> have some code for it.
> 
> Extract this into a helper function for drivers to be used.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/linux/ptp_classify.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> index 996f31e8f35d..39bad015d1d6 100644
> --- a/include/linux/ptp_classify.h
> +++ b/include/linux/ptp_classify.h
> @@ -96,6 +96,31 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb);
>   */
>  struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
>  
> +/**
> + * ptp_get_msgtype - Extract ptp message type from given header
> + * @hdr: ptp header
> + * @type: type of the packet (see ptp_classify_raw())
> + *
> + * This function returns the message type for a given ptp header. It takes care
> + * of the different ptp header versions (v1 or v2).
> + *
> + * Return: The message type
> + */
> +static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
> +				 unsigned int type)
> +{
> +	u8 msgtype;
> +
> +	if (unlikely(type & PTP_CLASS_V1)) {
> +		/* msg type is located at the control field for ptp v1 */
> +		msgtype = hdr->control;
> +	} else {
> +		msgtype = hdr->tsmt & 0x0f;
> +	}
> +
> +	return msgtype;
> +}

Are there 256 different message types in V1? I wonder how hardware
that uses the message type as an index into a 16-bit lookup table
and supports both V1 and V2 cope with that (such as the Marvell PTP
implementation found in their DSA switches and PHYs.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
