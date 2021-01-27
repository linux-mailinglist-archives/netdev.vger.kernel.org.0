Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C231B305D30
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbhA0N3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:29:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238049AbhA0N1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 08:27:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4kq2-002s8G-Hy; Wed, 27 Jan 2021 14:26:26 +0100
Date:   Wed, 27 Jan 2021 14:26:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 4/7] octeontx2-af: Physical link
 configuration support
Message-ID: <YBFqAkQRig3oTdyd@lunn.ch>
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
 <1611733552-150419-5-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611733552-150419-5-git-send-email-hkelam@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 01:15:49PM +0530, Hariprasad Kelam wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> CGX LMAC, the physical interface support link configuration parameters
> like speed, auto negotiation, duplex  etc. Firmware saves these into
> memory region shared between firmware and this driver.
> 
> This patch adds mailbox handler set_link_mode, fw_data_get to
> configure and read these parameters.
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 60 +++++++++++++++++++++-
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  2 +
>  .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  | 18 ++++++-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 21 ++++++++
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 17 ++++++
>  5 files changed, 115 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index b3ae84c..42ee67e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -658,6 +658,39 @@ static inline void cgx_link_usertable_init(void)
>  	cgx_lmactype_string[LMAC_MODE_USXGMII] = "USXGMII";
>  }
>  
> +static inline int cgx_link_usertable_index_map(int speed)
> +{

Hi Christina, Hariprasad

No inline functions in .c files please. Let the compiler decide.


> +	switch (speed) {
> +	case SPEED_10:
> +		return CGX_LINK_10M;
> +	case SPEED_100:
> +		return CGX_LINK_100M;
> +	case SPEED_1000:
> +		return CGX_LINK_1G;
> +	case SPEED_2500:
> +		return CGX_LINK_2HG;
> +	case SPEED_5000:
> +		return CGX_LINK_5G;
> +	case SPEED_10000:
> +		return CGX_LINK_10G;
> +	case SPEED_20000:
> +		return CGX_LINK_20G;
> +	case SPEED_25000:
> +		return CGX_LINK_25G;
> +	case SPEED_40000:
> +		return CGX_LINK_40G;
> +	case SPEED_50000:
> +		return CGX_LINK_50G;
> +	case 80000:
> +		return CGX_LINK_80G;
> +	case SPEED_100000:
> +		return CGX_LINK_100G;
> +	case SPEED_UNKNOWN:
> +		return CGX_LINK_NONE;
> +	}
> +	return CGX_LINK_NONE;
> +}
> +
>  static inline void link_status_user_format(u64 lstat,
>  					   struct cgx_link_user_info *linfo,
>  					   struct cgx *cgx, u8 lmac_id)

So it looks like previous reviews did not catch inline functions. So
lets say, no new inline functions.

     Andrew
