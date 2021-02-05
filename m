Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9434310474
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBEFUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhBEFUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE8964F95;
        Fri,  5 Feb 2021 05:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612502375;
        bh=Rc7JFa9kHYs+RTNR+WUqvFno9qYZVURcaFIbZ2p2p5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ipkJyq6BfUdCmou5iYyr77dc6zf3tF+6Cd8CfHw5Wi4EB7J2mWXJarv7snU5pKK4P
         p5gpkIYQ560dLaslca/BhraXy7J18UyVeBQ7p/cTCAPJDQJ91xkuF34hqxNrtyC4qT
         Z8Ly3jL8BQGh0a15bV/G8les27oMJCgF21eN+KzJo+q/0Bqwqv0AxF5GP/fhaDanwN
         aTc3UPXsEKtR9Zp7B3gOk1FxRGP9rHw3krkk4tJmvCOlsK5hdwgmwB+bYTuqEeY8a0
         WGVHlLsBxpQtDh8pnCS8JJNubXCDgeEXl4g4zNsZod4uDHNrY8rDPdhDCxSKcRQDaP
         ZmPk9GhtdsXAg==
Date:   Thu, 4 Feb 2021 21:19:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: marvell: prestera: fix port event
 handling on init
Message-ID: <20210204211934.273e54bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203165458.28717-8-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-8-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 18:54:58 +0200 Vadym Kochan wrote:
> For some reason there might be a crash during ports creation if port
> events are handling at the same time  because fw may send initial
> port event with down state.
> 
> The crash points to cancel_delayed_work() which is called when port went
> is down.  Currently I did not find out the real cause of the issue, so
> fixed it by cancel port stats work only if previous port's state was up
> & runnig.

Maybe you just need to move the DELAYED_WORK_INIT() earlier?
Not sure why it's at the end of prestera_port_create(), it 
just initializes some fields.

> [   28.489791] Call trace:
> [   28.492259]  get_work_pool+0x48/0x60
> [   28.495874]  cancel_delayed_work+0x38/0xb0
> [   28.500011]  prestera_port_handle_event+0x90/0xa0 [prestera]
> [   28.505743]  prestera_evt_recv+0x98/0xe0 [prestera]
> [   28.510683]  prestera_fw_evt_work_fn+0x180/0x228 [prestera_pci]
> [   28.516660]  process_one_work+0x1e8/0x360
> [   28.520710]  worker_thread+0x44/0x480
> [   28.524412]  kthread+0x154/0x160
> [   28.527670]  ret_from_fork+0x10/0x38
> [   28.531290] Code: a8c17bfd d50323bf d65f03c0 9278dc21 (f9400020)
> [   28.537429] ---[ end trace 5eced933df3a080b ]---
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index 39465e65d09b..122324dae47d 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -433,7 +433,8 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
>  			netif_carrier_on(port->dev);
>  			if (!delayed_work_pending(caching_dw))
>  				queue_delayed_work(prestera_wq, caching_dw, 0);
> -		} else {
> +		} else if (netif_running(port->dev) &&
> +			   netif_carrier_ok(port->dev)) {
>  			netif_carrier_off(port->dev);
>  			if (delayed_work_pending(caching_dw))
>  				cancel_delayed_work(caching_dw);

