Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37DF11D59B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfLLScX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:32:23 -0500
Received: from mail.nic.cz ([217.31.204.67]:51446 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbfLLScU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 13:32:20 -0500
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 8A1F0140E44;
        Thu, 12 Dec 2019 19:32:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1576175538; bh=ZmC6CchjybjXVa6TO/1AkmEB1/mDD1k1orvejWCSEZg=;
        h=Date:From:To;
        b=qaiN9MaQQi3RsiXr1LEJ0AZkTzDizJAGi7CKUqdIJIYMH5SINrRNxNCp+DhMBq3pk
         P4Wq/K3ZGO45Szf/u7zZwu1Rf7nbx7sFdXcbrekUnd2sMIX8/cAha2Xn/yC4H0Dg0w
         qgkPTesd7xrl9KQdnFIXf3hrumQefpyA4OqC+rt0=
Date:   Thu, 12 Dec 2019 19:32:18 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212193218.2f91df52@nic.cz>
In-Reply-To: <20191212181729.mviz5c26ysebg4w3@sapphire.tkos.co.il>
References: <87tv67tcom.fsf@tarshish>
        <20191211131111.GK16369@lunn.ch>
        <87fthqu6y6.fsf@tarshish>
        <20191211174938.GB30053@lunn.ch>
        <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
        <20191212131448.GA9959@lunn.ch>
        <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
        <20191212151355.GE30053@lunn.ch>
        <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
        <20191212181729.mviz5c26ysebg4w3@sapphire.tkos.co.il>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 20:17:29 +0200
Baruch Siach <baruch@tkos.co.il> wrote:

> This is not enough to fix v5.4, though. Commit 7a3007d22e8dc ("net: dsa: 
> mv88e6xxx: fully support SERDES on Topaz family") breaks switch Tx on SolidRun 
> Clearfog GT-8K in much the same way. I could not easily revert 7a3007d22e8dc 
> on top of v5.4, but this is enough to make Tx work again with v5.4:
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 7b5b73499e37..e7e6400a994e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3191,7 +3191,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
>  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
>  	.port_link_state = mv88e6352_port_link_state,
>  	.port_get_cmode = mv88e6352_port_get_cmode,
> -	.port_set_cmode = mv88e6341_port_set_cmode,
>  	.port_setup_message_port = mv88e6xxx_setup_message_port,
>  	.stats_snapshot = mv88e6390_g1_stats_snapshot,
>  	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
> 
> Marek, do you have any idea how to properly fix this?
> 
> Thanks,
> baruch
> 

Hi Baruch,

can you tell on which port the port_set_cmode is called when things
break? Because if it is other than port 5, than method
mv88e6341_port_set_cmode does nothing. If it is port 5, do you have cpu
connected to the switch via port 5? What phy mode?

Marek
