Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8511A63954B
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 11:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiKZK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 05:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKZK25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 05:28:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93382655E
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 02:28:55 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oysQM-0000DK-Lc; Sat, 26 Nov 2022 11:28:42 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oysQK-0004kT-5j; Sat, 26 Nov 2022 11:28:40 +0100
Date:   Sat, 26 Nov 2022 11:28:40 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: j1939: do not wait 250 ms if the same addr was
 already claimed
Message-ID: <20221126102840.GA21761@pengutronix.de>
References: <20221124051611.GA7870@pengutronix.de>
 <20221125170418.34575-1-devid.filoni@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221125170418.34575-1-devid.filoni@egluetechnologies.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 06:04:18PM +0100, Devid Antonio Filoni wrote:
> The ISO 11783-5 standard, in "4.5.2 - Address claim requirements", states:
>   d) No CF shall begin, or resume, transmission on the network until 250
>      ms after it has successfully claimed an address except when
>      responding to a request for address-claimed.
> 
> But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
> prioritization" show that the CF begins the transmission after 250 ms
> from the first AC (address-claimed) message even if it sends another AC
> message during that time window to resolve the address contention with
> another CF.
> 
> As stated in "4.4.2.3 - Address-claimed message":
>   In order to successfully claim an address, the CF sending an address
>   claimed message shall not receive a contending claim from another CF
>   for at least 250 ms.
> 
> As stated in "4.4.3.2 - NAME management (NM) message":
>   1) A commanding CF can
>      d) request that a CF with a specified NAME transmit the address-
>         claimed message with its current NAME.
>   2) A target CF shall
>      d) send an address-claimed message in response to a request for a
>         matching NAME
> 
> Taking the above arguments into account, the 250 ms wait is requested
> only during network initialization.
> 
> Do not restart the timer on AC message if both the NAME and the address
> match and so if the address has already been claimed (timer has expired)
> or the AC message has been sent to resolve the contention with another
> CF (timer is still running).
> 
> Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  v1 -> v2: Added ISO 11783-5 standard references
> 
>  net/can/j1939/address-claim.c | 40 +++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/net/can/j1939/address-claim.c b/net/can/j1939/address-claim.c
> index f33c47327927..ca4ad6cdd5cb 100644
> --- a/net/can/j1939/address-claim.c
> +++ b/net/can/j1939/address-claim.c
> @@ -165,6 +165,46 @@ static void j1939_ac_process(struct j1939_priv *priv, struct sk_buff *skb)
>  	 * leaving this function.
>  	 */
>  	ecu = j1939_ecu_get_by_name_locked(priv, name);
> +
> +	if (ecu && ecu->addr == skcb->addr.sa) {
> +		/* The ISO 11783-5 standard, in "4.5.2 - Address claim
> +		 * requirements", states:
> +		 *   d) No CF shall begin, or resume, transmission on the
> +		 *      network until 250 ms after it has successfully claimed
> +		 *      an address except when responding to a request for
> +		 *      address-claimed.
> +		 *
> +		 * But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
> +		 * prioritization" show that the CF begins the transmission
> +		 * after 250 ms from the first AC (address-claimed) message
> +		 * even if it sends another AC message during that time window
> +		 * to resolve the address contention with another CF.
> +		 *
> +		 * As stated in "4.4.2.3 - Address-claimed message":
> +		 *   In order to successfully claim an address, the CF sending
> +		 *   an address claimed message shall not receive a contending
> +		 *   claim from another CF for at least 250 ms.
> +		 *
> +		 * As stated in "4.4.3.2 - NAME management (NM) message":
> +		 *   1) A commanding CF can
> +		 *      d) request that a CF with a specified NAME transmit
> +		 *         the address-claimed message with its current NAME.
> +		 *   2) A target CF shall
> +		 *      d) send an address-claimed message in response to a
> +		 *         request for a matching NAME
> +		 *
> +		 * Taking the above arguments into account, the 250 ms wait is
> +		 * requested only during network initialization.
> +		 *
> +		 * Do not restart the timer on AC message if both the NAME and
> +		 * the address match and so if the address has already been
> +		 * claimed (timer has expired) or the AC message has been sent
> +		 * to resolve the contention with another CF (timer is still
> +		 * running).
> +		 */
> +		goto out_ecu_put;
> +	}
> +
>  	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
>  		ecu = j1939_ecu_create_locked(priv, name);
>  
> -- 
> 2.34.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
