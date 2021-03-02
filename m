Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB5A32B3BF
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574619AbhCCEFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:39 -0500
Received: from relay-b03.edpnet.be ([212.71.1.220]:46094 "EHLO
        relay-b03.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835429AbhCBTG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:06:56 -0500
X-ASG-Debug-ID: 1614710693-15c4356e4c23060001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (94.105.105.240.dyn.edpnet.net [94.105.105.240]) by relay-b03.edpnet.be with ESMTP id b4Gey686mZx8ui2U; Tue, 02 Mar 2021 19:44:53 +0100 (CET)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 94.105.105.240.dyn.edpnet.net[94.105.105.240]
X-Barracuda-Apparent-Source-IP: 94.105.105.240
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 3D62612A739F;
        Tue,  2 Mar 2021 19:44:53 +0100 (CET)
Date:   Tue, 2 Mar 2021 19:44:51 +0100
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] can: c_can: fix control interface used by
 c_can_do_tx
Message-ID: <20210302184451.GC26930@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH v3 3/6] can: c_can: fix control interface used by
 c_can_do_tx
Mail-Followup-To: Dario Binacchi <dariobin@libero.it>,
        linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-4-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210228103856.4089-4-dariobin@libero.it>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 94.105.105.240.dyn.edpnet.net[94.105.105.240]
X-Barracuda-Start-Time: 1614710693
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1116
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.88269
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Feb 2021 11:38:52 +0100, Dario Binacchi wrote:
> According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
> IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> ---
> 
> (no changes since v1)
> 
>  drivers/net/can/c_can/c_can.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index dbcc1c1c92d6..69526c3a671c 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
> @@ -732,7 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
>  		idx--;
>  		pend &= ~(1 << idx);
>  		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> -		c_can_inval_tx_object(dev, IF_RX, obj);
> +		c_can_inval_tx_object(dev, IF_TX, obj);

Right. I had a similar effort last year to increase the reception
throughput, but I ended with some sporadic strange tx echo problems.
This fix may have fixed my problem as wel.

>  		can_get_echo_skb(dev, idx, NULL);
>  		bytes += priv->dlc[idx];
>  		pkts++;
> -- 
> 2.17.1
> 
