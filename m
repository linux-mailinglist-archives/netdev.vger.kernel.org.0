Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDF262E3B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgIILx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 07:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgIILmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 07:42:13 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EBA1207DE;
        Wed,  9 Sep 2020 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599649899;
        bh=gk5ai7/vsUBs2dl7VhzTb79HWtwuO4OdRiCJ/geHW4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xt32yCIJZrUnpBjf6/MToHhOH5aK0XvmwKj0BwuSH4Fcsie9nQ0R0tHFTEEnVTFIP
         29njlrTtNhos9A/wOErrHOF4fNWmUSFQ9GV2x/XbjDPYvt+u9vNWaHJT8TSYsNQWbr
         xUrm/P+mViuyxOWWowDpQZ7V6BMBiafgTH9hvMDw=
Received: by pali.im (Postfix)
        id B61AE7A9; Wed,  9 Sep 2020 13:11:36 +0200 (CEST)
Date:   Wed, 9 Sep 2020 13:11:36 +0200
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
Subject: Re: [PATCH v2 2/2] Bluetooth: sco: expose WBS packet length in
 socket option
Message-ID: <20200909111136.ghp5p56m4cxfjreo@pali>
References: <20200909094202.3863687-1-josephsih@chromium.org>
 <20200909174129.v2.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909174129.v2.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 09 September 2020 17:42:02 Joseph Hwang wrote:
> It is desirable to expose the wideband speech packet length via
> a socket option to the user space so that the user space can set
> the value correctly in configuring the sco connection.

Hello! I'm fine with change below, but I would suggest to put more
details into commit message. This change has nothing to do with wideband
nor with exporting socket option to userspace -- which is already done
via SCO_OPTIONS option. Also it is relevant to SCO socket with any codec
data, not only wideband.

This commit description should rather mention that it defines new
getsockopt options BT_SNDMTU/BT_RCVMTU for SCO socket to be compatible
with other bluetooth sockets and that these options return same value as
option SCO_OPTIONS which is already present on existing kernels.

> 
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> (no changes since v1)
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
> 2.28.0.526.ge36021eeef-goog
> 
