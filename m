Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCCD420AFF
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhJDMl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:41:59 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:51152 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhJDMl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 08:41:58 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 8C0B820D4E42
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
Organization: Open Mobile Platform
Message-ID: <58ca2e47-9c25-c394-51e5-067ebaa66538@omp.ru>
Date:   Mon, 4 Oct 2021 15:40:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/1/21 6:06 PM, Biju Das wrote:

> Initialize GbEthernet DMAC found on RZ/G2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> RFC->v1:
>  * Removed RIC3 initialization from DMAC init, as it is 
>    same as reset value.

   I'm not sure we do a reset everytime...

>  * moved stubs function to earlier patches.
>  * renamed "rgeth" with "gbeth"
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  3 ++-
>  drivers/net/ethernet/renesas/ravb_main.c | 30 +++++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 2 deletions(-)
> 
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index dc817b4d95a1..5790a9332e7b 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -489,7 +489,35 @@ static void ravb_emac_init(struct net_device *ndev)
>  
>  static int ravb_dmac_init_gbeth(struct net_device *ndev)
>  {
> -	/* Place holder */
> +	int error;
> +
> +	error = ravb_ring_init(ndev, RAVB_BE);
> +	if (error)
> +		return error;
> +
> +	/* Descriptor format */
> +	ravb_ring_format(ndev, RAVB_BE);
> +
> +	/* Set AVB RX */

   AVB? We don't have it, do we?

> +	ravb_write(ndev, 0x60000000, RCR);

   Not even RCR.EFFS? And what do bits 29..30 mean?

[...]
> +	/* Set FIFO size */
> +	ravb_write(ndev, 0x00222200, TGC);

   Do TBD<n> (other than TBD0) fields even exist?

[...]

MBR, Sergey
