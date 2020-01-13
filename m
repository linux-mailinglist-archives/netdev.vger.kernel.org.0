Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922B8139268
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAMNoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:44:32 -0500
Received: from mx4.wp.pl ([212.77.101.12]:60350 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgAMNoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 08:44:32 -0500
Received: (wp-smtpd smtp.wp.pl 10166 invoked from network); 13 Jan 2020 14:44:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578923069; bh=UsdRYxS3iGOmtf0BEiK0IvADZIqLSlvpWzvsyvMhIXo=;
          h=From:To:Cc:Subject;
          b=gN9yEc2Vyd63V7y0w1TnejykErvemGMT0NtKxOurlQfv5EjFBMaOZMthDVqh6mtoO
           T+tjr4cyHs+GHch7mQ3HcWX/AlQb3jfWvms5l92k9selHMGC34ygppSvj23nXxAGUX
           iH2WR19JM4B5HfoGJIc5Ucgwxpw1YL4yK7S5r6JY=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ms@dev.tdt.de>; 13 Jan 2020 14:44:29 +0100
Date:   Mon, 13 Jan 2020 05:44:21 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     khc@pm.waw.pl, davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wan/hdlc_x25: fix skb handling
Message-ID: <20200113054421.55cd5ddc@cakuba>
In-Reply-To: <20200113124551.2570-2-ms@dev.tdt.de>
References: <20200113124551.2570-1-ms@dev.tdt.de>
        <20200113124551.2570-2-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 5947819778d9914c21dddc05a56b3135
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [QfPU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 13:45:51 +0100, Martin Schiller wrote:
>  o call skb_reset_network_header() before hdlc->xmit()
>  o change skb proto to HDLC (0x0019) before hdlc->xmit()
>  o call dev_queue_xmit_nit() before hdlc->xmit()
> 
> This changes make it possible to trace (tcpdump) outgoing layer2
> (ETH_P_HDLC) packets
> 
>  o use a copy of the skb for lapb_data_request() in x25_xmit()

It's not clear to me why

> This fixes the problem, that tracing layer3 (ETH_P_X25) packets
> results in a malformed first byte of the packets.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
>  drivers/net/wan/hdlc_x25.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
> index b28051eba736..434e5263eddf 100644
> --- a/drivers/net/wan/hdlc_x25.c
> +++ b/drivers/net/wan/hdlc_x25.c
> @@ -72,6 +72,7 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
>  	unsigned char *ptr;
>  
>  	skb_push(skb, 1);
> +	skb_reset_network_header(skb);
>  
>  	if (skb_cow(skb, 1))

This skb_cow() here is for the next handler down to have a 1 byte of
headroom guaranteed? It'd seem more natural to have skb_cow before the
push.. not that it's related to your patch.

>  		return NET_RX_DROP;
> @@ -88,6 +89,9 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
>  static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
>  {
>  	hdlc_device *hdlc = dev_to_hdlc(dev);

Please insert a new line after the variable declaration since you're
touching this one.

> +	skb_reset_network_header(skb);
> +	skb->protocol = hdlc_type_trans(skb, dev);
> +	dev_queue_xmit_nit(skb, dev);
>  	hdlc->xmit(skb, dev); /* Ignore return value :-( */
>  }
>  
