Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8517CD07
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfGaTlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:41:49 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:39050 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728380AbfGaTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4E+dFsOzoruLk6cM0QGDsMUoGc5qn/PzRbagVkP50Oc=; b=W9cUM6jXW12VRY++eziWb15NbL
        SAAbuQMrXpauEcE0y3S2p5feAbZueJLFbmv8WV6mpi1o9U5X72bleylH1Q40ioJN+vpxrIKkKSX1y
        Jsqflw+1kKJBlPv6oXYq4Avo3swzXNb/p+qtqsTK7N39mKgqwYNPU0BJ6r3DPjpY/TNI=;
Received: from 212-39-89-16.ip.btc-net.bg ([212.39.89.16] helo=carbon)
        by zztop.nucleusys.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <petkan@nucleusys.com>)
        id 1hstzl-0004XF-0C; Wed, 31 Jul 2019 22:10:41 +0300
Date:   Wed, 31 Jul 2019 22:10:40 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fix improper read if get_registers()
 fail
Message-ID: <20190731191039.gip2sttd2og2olx6@carbon>
References: <20190730131357.30697-1-dkirjanov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730131357.30697-1-dkirjanov@suse.com>
User-Agent: NeoMutt/20180716
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 19-07-30 15:13:57, Denis Kirjanov wrote: > get_registers()
    may fail with -ENOMEM and in this > case we can read a garbage from the status
    variable tmp. > > Reported-by: syzbot+3499a83b2d062ae409d4@ [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19-07-30 15:13:57, Denis Kirjanov wrote:
> get_registers() may fail with -ENOMEM and in this
> case we can read a garbage from the status variable tmp.
> 
> Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/usb/pegasus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 6d25dea5ad4b..f7d117d80cfb 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -282,7 +282,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
>  static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
>  {
>  	int i;
> -	__u8 tmp;
> +	__u8 tmp = 0;
>  	__le16 retdatai;
>  	int ret;

Unfortunately this patch does not fix anything.  Even if get_registers() fail 
with -ENOMEM the "for" loop will cover for it and will exit only if the 
operation was successful or the device got disconnected.  Please read the code 
carefully.

So while the patch is harmless it isn't solving a problem.


cheers,
Petko
