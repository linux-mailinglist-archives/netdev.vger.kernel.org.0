Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8082B25BB2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfEVBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:42:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfEVBmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 21:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V0i6rM8f3vkwwfHsfAG/etWncROxG9KmVrmT3HvPC0A=; b=ZnZoS6zy61UtpRmvt+fzFYMOP/
        YmzrirAZKmbrqifFoH1onGdmBpBWs9n1fJnt+fjzk1fEjj6diLC4Y64I4fD6RdQJc9l56phO7Z/m0
        3+x8qES87NDLrkU4kVIR7cAswpEKdqiUaAkjfwE+EbhNkbDJjhDVoNQteMAUK/E4c8LY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTGGq-0000OK-IW; Wed, 22 May 2019 03:42:20 +0200
Date:   Wed, 22 May 2019 03:42:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 6/6] ptp: Add a driver for InES time stamping
 IP core.
Message-ID: <20190522014220.GB734@lunn.ch>
References: <20190521224723.6116-7-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521224723.6116-7-richardcochran@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
> +		       struct ines_timestamp *ts);
> +static int ines_rxfifo_read(struct ines_port *port);
> +static u64 ines_rxts64(struct ines_port *port, unsigned int words);
> +static bool ines_timestamp_expired(struct ines_timestamp *ts);
> +static u64 ines_txts64(struct ines_port *port, unsigned int words);
> +static void ines_txtstamp_work(struct work_struct *work);
> +static bool is_sync_pdelay_resp(struct sk_buff *skb, int type);
> +static u8 tag_to_msgtype(u8 tag);

Hi Richard

I don't know about the PTP subsystem, but in general, forward
declarations are frowned upon, and it is generally requested to
reorder the functions to remove them.

> +static struct platform_driver ines_ptp_ctrl_driver = {
> +	.probe  = ines_ptp_ctrl_probe,
> +	.remove = ines_ptp_ctrl_remove,
> +	.driver = {
> +		.name = "ines_ptp_ctrl",
> +		.of_match_table = of_match_ptr(ines_ptp_ctrl_of_match),
> +	},
> +};
> +
> +static int __init ines_ptp_init(void)
> +{
> +	return platform_driver_register(&ines_ptp_ctrl_driver);
> +}
> +
> +static void __exit ines_ptp_cleanup(void)
> +{
> +	platform_driver_unregister(&ines_ptp_ctrl_driver);
> +}

include/linux/platform_device.h:

/* module_platform_driver() - Helper macro for drivers that don't do
 * anything special in module init/exit.  This eliminates a lot of
 * boilerplate.  Each module may only use this macro once, and
 * calling it replaces module_init() and module_exit()
 */
#define module_platform_driver(__platform_driver) \
        module_driver(__platform_driver, platform_driver_register, \
                        platform_driver_unregister)

	Andrew
