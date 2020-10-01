Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566F427F9F9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgJAHOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:14:10 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:49102 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:14:10 -0400
IronPort-SDR: xhHhcrYDFEl+vS29il0sag8AtnMhCGiXX4GvkpvwgvzJG2xawyMpVRDj7MoDAa/0/6Pjj6Pc15
 CVbe1rNqAYq9Rz1nY5BLnDcuipmBe4OWVda4QhY9/2ttOCVR/ufOLLRWazNj1BmDpNmNsyBXxa
 t9TF2JsLkA/FYIlXjaZdkizw9gXrUUT+lpAi84JRigxHYcVKh2J21wwqukPxH9sR6pzNgdjMzH
 p3o79s/XU95nbMLvf9J9TJCSsSpeAzkxJg7PvDUNn+fWePjR3n1+1tq7Sfs3zX9cE+BLeDOAV0
 6AQ=
X-IronPort-AV: E=Sophos;i="5.77,323,1596528000"; 
   d="scan'208";a="53450460"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 30 Sep 2020 23:14:09 -0800
IronPort-SDR: 6qp/5MCh8TZrAUwcXGzSfCbMayY5W5IJffvz4BaVkerN6NCzGdjhHJMnrm4J/AzfNZbvKEylD3
 DUGuReh8WZthwG0JyTpwm7pE6WE2AejMfsAp8CEPUK6nk1tcUhIwiB4CuNpEOvHz8xkR71l4Zf
 xlWgEynqWtqJSu3EjByNqCq8bf58p5j6Xxhn3dt4J9b54YhZE+jKpjAttnwuEWKu2mi8hjlkQe
 A2mMghnPc+N7WYnK/zMyaCXhVi2X6IXN1SM+QdK1JdRNh53RLvpA5U+MzymHOFcan12v52+++8
 FRk=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
CC:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
In-Reply-To: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
Subject: RE: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Thu, 1 Oct 2020 10:13:54 +0300
Organization: Mentor Graphics Corporation
Message-ID: <000001d697c2$71651d70$542f5850$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHWl179dggpQ/YNgUW3t7t7L6TDlKmCUESw
Content-Language: en-us
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-07.mgc.mentorg.com (139.181.222.7) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> -----Original Message-----
> From: Gabbasov, Andrew
> Sent: Wednesday, September 30, 2020 10:21 PM
> To: linux-renesas-soc@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sergei Shtylyov <sergei.shtylyov@gmail.com>; David
> S. Miller <davem@davemloft.net>; geert+renesas@glider.be; Julia Lawall
> <julia.lawall@inria.fr>; Behme, Dirk - Bosch <dirk.behme@de.bosch.com>;
> Eugeniu Rosca <erosca@de.adit-jv.com>; Gabbasov, Andrew
> <Andrew_Gabbasov@mentor.com>
> Subject: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
> 
> In the function ravb_hwtstamp_get() in ravb_main.c with the existing
values
> for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
> (0x6)
> 
> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
> 
> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true, it will never be
> reached.
> 
> This issue can be verified with 'hwtstamp_config' testing program
> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type to
ALL
> and subsequent retrieving it gives incorrect value:
> 
> $ hwtstamp_config eth0 OFF ALL
> flags = 0
> tx_type = OFF
> rx_filter = ALL
> $ hwtstamp_config eth0
> flags = 0
> tx_type = OFF
> rx_filter = PTP_V2_L2_EVENT
> 
> Correct this by converting if-else's to switch.

Earlier you proposed to fix this issue by changing the value
of RAVB_RXTSTAMP_TYPE_ALL constant to 0x4.
Unfortunately, simple changing of the constant value will not
be enough, since the code in ravb_rx() (actually determining
if timestamp is needed)

u32 get_ts = priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE;
[...]
get_ts &= (q == RAVB_NC) ?
                RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
                ~RAVB_RXTSTAMP_TYPE_V2_L2_EVENT;

will work incorrectly and will need to be fixed too, making this
piece of code more complicated.

So, it's probably easier and safer to keep the constant value and
the code in ravb_rx() intact, and just fix the get ioctl code,
where the issue is actually located.

Thanks!

Best regards,
Andrew

> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index df89d09b253e..c0610b2d3b14 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1802,12 +1802,16 @@ static int ravb_hwtstamp_get(struct net_device
> *ndev, struct ifreq *req)
>  	config.flags = 0;
>  	config.tx_type = priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
>  						HWTSTAMP_TX_OFF;
> -	if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> +	switch (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE) {
> +	case RAVB_RXTSTAMP_TYPE_V2_L2_EVENT:
>  		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> -	else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> +		break;
> +	case RAVB_RXTSTAMP_TYPE_ALL:
>  		config.rx_filter = HWTSTAMP_FILTER_ALL;
> -	else
> +		break;
> +	default:
>  		config.rx_filter = HWTSTAMP_FILTER_NONE;
> +	}
> 
>  	return copy_to_user(req->ifr_data, &config, sizeof(config)) ?
>  		-EFAULT : 0;
> --
> 2.21.0


