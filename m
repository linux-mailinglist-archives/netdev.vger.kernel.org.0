Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410927AA1E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfG3Nt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:49:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfG3Nt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z6G1T+G+Sh+UZiHP63MYhPyDhXCWooN/11V93iSPTqI=; b=2Wk25JuibETR1EL8M7VecZlEQi
        czkPicuRevafjQcQ4Kx/zJkF9BY4H6Eh/Vb6YG+9HbTjOogmyiG1AJjwd4L7EdyayqKIkZJwKFD+7
        /qlV5d4f5HT5IaamQMzBKUUhdKy08aBgnIGCNyQqhNkWX6qQLqOMMcDPUvnSRz8zdOIM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSVI-0007t8-Nc; Tue, 30 Jul 2019 15:49:24 +0200
Date:   Tue, 30 Jul 2019 15:49:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 1/4] net: dsa: mv88e6xxx: add support for MV88E6220
Message-ID: <20190730134924.GH28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-2-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-2-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:26PM +0200, Hubert Feurstein wrote:
> The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
> not routed to pins. So the usable ports are 0, 1, 5 and 6.

Hi Hubert

Do the registers for the ports exist?

> +	[MV88E6220] = {
> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
> +		.family = MV88E6XXX_FAMILY_6250,
> +		.name = "Marvell 88E6220",
> +		.num_databases = 64,
> +
> +		/* Ports 2-4 are not routed to pins
> +		 * => usable ports 0, 1, 5, 6
> +		 */
> +		.num_ports = 7,

I'm wondering if we should add something like

		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4)


and

        /* Setup Switch Port Registers */
        for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
+		if (chip->info->invalid_port_mask & BIT(i) &&
+		    !dsa_is_unused_port(ds, i))
+		    return -EINVAL;
                if (dsa_is_unused_port(ds, i)) {
                        err = mv88e6xxx_port_set_state(chip, i,
                                                       BR_STATE_DISABLED);
  
	Andrew
