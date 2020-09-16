Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF4026BD9A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIPHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 03:02:49 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:56168 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbgIPHCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 03:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8fk+I4ZemBY5OogXFdLgsK51XfiRHsT4RBnrN+8HFMs=; b=GjClFFipRMYmH+d63qEmRBuFZk
        tbSOhuRA3TDineS+sjSW56nDqjshXWGsvcDP7vVm93n+woR2YO9knE+1tCYpthCNoAoMySrQDJ15H
        UGW0yStPQHrGcI6Z46aIBOKaZd9vaDN5eAKF15c9OL9kuxkUX4XqF4zKwnEytCz3OKwU=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kIQnC-00058i-Qu; Wed, 16 Sep 2020 09:19:47 +0300
Date:   Wed, 16 Sep 2020 09:19:46 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs
 on failed register reads
Message-ID: <20200916061946.GA38262@p310>
References: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-16 10:35:40, Anant Thazhemadam wrote: > get_registers()
    copies whatever memory is written by the > usb_control_msg() call even if
    the underlying urb call ends up failing. Not true, memcpy() is only called
    if "ret" is positive. 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-16 10:35:40, Anant Thazhemadam wrote:
> get_registers() copies whatever memory is written by the
> usb_control_msg() call even if the underlying urb call ends up failing.

Not true, memcpy() is only called if "ret" is positive.

> If get_registers() fails, or ends up reading 0 bytes, meaningless and junk 
> register values would end up being copied over (and eventually read by the 
> driver), and since most of the callers of get_registers() don't check the 
> return values of get_registers() either, this would go unnoticed.

usb_control_msg() returns negative on error (look up usb_internal_control_msg() 
to see for yourself) so it does not go unnoticed.  If for some reason it return 
zero, nothing is copied.  Also, if usb transfer fail no register values are 
being copied anywhere.

Your patch also allows for memcpy() to be called with 'size' either zero or 
greater than the allocated buffer size. Please, look at the code carefully.

> It might be a better idea to try and mirror the PCI master abort
> termination and set memory to 0xFFs instead in such cases.

I wasn't aware drivers are now responsible for filling up the memory with 
anything.  Does not sound like a good idea to me.

> Fixes: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

Well, NACK from me.


cheers,
Petko


> ---
>  drivers/net/usb/rtl8150.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 733f120c852b..04fca7bfcbcb 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -162,8 +162,13 @@ static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>  	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
>  			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
>  			      indx, 0, buf, size, 500);
> -	if (ret > 0 && ret <= size)
> +
> +	if (ret < 0)
> +		memset(data, 0xff, size);
> +
> +	else
>  		memcpy(data, buf, ret);
> +
>  	kfree(buf);
>  	return ret;
>  }
> @@ -276,7 +281,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>  
>  static inline void set_ethernet_addr(rtl8150_t * dev)
>  {
> -	u8 node_id[6];
> +	u8 node_id[6] = {0};
>  
>  	get_registers(dev, IDR, sizeof(node_id), node_id);
>  	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> -- 
> 2.25.1
> 
> 
