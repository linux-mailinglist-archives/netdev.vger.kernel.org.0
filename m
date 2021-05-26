Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F35391C6B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhEZPvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhEZPvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 11:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF93161184;
        Wed, 26 May 2021 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622044178;
        bh=uyJM6RmL4VFOIpdrgSUrinaAJ058EDjZ1XMhpJ0RipY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dUE8zMqAXEPdRvMBVtCaDDomtwIkS8UIos2Vn2ggDOzI/gUAhah5INMyy7aya8QqM
         HCbdOp6JRcQKBvw1x4BnScLAESoZEsHBW5n3VBfgBneBehi14KtfrEBo1clXAhCt7C
         CpvUh1hf2Lz1Xfu2tKbSZwg0+L96lQxa14FY+up8=
Date:   Wed, 26 May 2021 17:49:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hao Xiong <mart1n@zju.edu.cn>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: fix the erroneous flush_work() order
Message-ID: <YK5uD/z8oQqyle3w@kroah.com>
References: <20210525114215.141988-1-gregkh@linuxfoundation.org>
 <87CD8C35-C7D2-4CF7-B9F9-266B3498DB94@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87CD8C35-C7D2-4CF7-B9F9-266B3498DB94@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 05:05:50PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > From: linma <linma@zju.edu.cn>
> 
> this needs a real name, but I could fix that on git am as well.

"Lin Ma"

> > In the cleanup routine for failed initialization of HCI device,
> > the flush_work(&hdev->rx_work) need to be finished before the
> > flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
> > possibly invoke new cmd_work and cause a bug, like double free,
> > in late processings.
> > 
> > This was assigned CVE-2021-3564.
> > 
> > This patch reorder the flush_work() to fix this bug.
> > 
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-bluetooth@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Lin Ma <linma@zju.edu.cn>
> > Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > net/bluetooth/hci_core.c | 7 ++++++-
> > 1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index fd12f1652bdf..88aa32f44e68 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1610,8 +1610,13 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> > 	} else {
> > 		/* Init failed, cleanup */
> > 		flush_work(&hdev->tx_work);
> > -		flush_work(&hdev->cmd_work);
> > +		/*
> > +		 * Since hci_rx_work() is possible to awake new cmd_work
> > +		 * it should be flushed first to avoid unexpected call of
> > +		 * hci_cmd_work()
> > +		 */
> 
> So everything in net/ uses the comment coding style enforced with --strict.

See v2 please.

thanks,

greg k-h
