Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A747C7B2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhLUToZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:44:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhLUToZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 14:44:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dEFjK55pXFeqtv/q14sfwoR57qhngxFbFwSK8SuJ9ps=; b=F++MUPoXxSLqCMRP1MXy5o9qSi
        MsLWE019fuHEjU5pRXBjassKxm87DPMZlsy1YguKFKDbRTCJbFFS96vAYr+jGTwxFWjP3Z6bLO6E1
        9ZFK9pP+BgiFHJs23nbUBxRRqWXouP1VXsls1rIGheXGUj9nx/mmA7e2AtLmiZ4wIkUA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzl3c-00HA8n-31; Tue, 21 Dec 2021 20:44:20 +0100
Date:   Tue, 21 Dec 2021 20:44:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] asix: fix wrong return value in
 asix_check_host_enable()
Message-ID: <YcIulPIwii+7OOzT@lunn.ch>
References: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
 <989915c5f8887e4a0281ed87325277aa8c997291.1640115493.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <989915c5f8887e4a0281ed87325277aa8c997291.1640115493.git.paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 10:40:05PM +0300, Pavel Skripkin wrote:
> If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
> asix_check_host_enable(), which is logically wrong. Fix it by returning
> -ETIMEDOUT explicitly if we have exceeded 30 iterations
> 
> Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/usb/asix_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 06823d7141b6..8c61d410a123 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -83,7 +83,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
>  			break;
>  	}
>  
> -	return ret;
> +	return i >= 30? -ETIMEDOUT: ret;

I think the coding style guidelines would recommend a space before the ?

I would also replace the 30 with a #define, both here and in the for
loop.

	Andrew
