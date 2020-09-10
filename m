Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E35526400E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgIJIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbgIJIUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 04:20:35 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9878720732;
        Thu, 10 Sep 2020 08:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599726002;
        bh=+uYj31dIE6aLQLGtOUfoRlwyftNHQyhq7bqNm1EFOzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kMedj2nqh7AnwsubKUx2cDGygfPeMZ/DC22/dIFpecBdxjizUINcIlzCJEoaIbbIN
         UWw0szHE23w4EXoWTQS5bdHpXZJn+r4Qn69vCnYUsWm6z4fAaxGT/Xg3uOtH4R0Mwv
         MHIGn/OTGcDdKwWYo8ufZTdtJgupVMoBGdzsB9ys=
Received: by pali.im (Postfix)
        id 736C6582; Thu, 10 Sep 2020 10:20:00 +0200 (CEST)
Date:   Thu, 10 Sep 2020 10:20:00 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Joseph Hwang <josephsih@chromium.org>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, chromeos-bluetooth-upstreaming@chromium.org,
        josephsih@google.com, Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Bluetooth: sco: new getsockopt options
 BT_SNDMTU/BT_RCVMTU
Message-ID: <20200910082000.aiw74ll3z776yqgh@pali>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <20200910140342.v3.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200910140342.v3.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 10 September 2020 14:04:02 Joseph Hwang wrote:
> This patch defines new getsockopt options BT_SNDMTU/BT_RCVMTU
> for SCO socket to be compatible with other bluetooth sockets.
> These new options return the same value as option SCO_OPTIONS
> which is already present on existing kernels.
> 
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>

Looks good,

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
> 
> Changes in v3:
> - Fixed the commit message.
> 
> Changes in v2:
> - Used BT_SNDMTU/BT_RCVMTU instead of creating a new opt name.
> - Used the existing conn->mtu instead of creating a new member
>   in struct sco_pinfo.
> - Noted that the old SCO_OPTIONS in sco_sock_getsockopt_old()
>   would just work as it uses sco_pi(sk)->conn->mtu.
> 
>  net/bluetooth/sco.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index dcf7f96ff417e6..79ffcdef0b7ad5 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -1001,6 +1001,12 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
>  			err = -EFAULT;
>  		break;
>  
> +	case BT_SNDMTU:
> +	case BT_RCVMTU:
> +		if (put_user(sco_pi(sk)->conn->mtu, (u32 __user *)optval))
> +			err = -EFAULT;
> +		break;
> +
>  	default:
>  		err = -ENOPROTOOPT;
>  		break;
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 
