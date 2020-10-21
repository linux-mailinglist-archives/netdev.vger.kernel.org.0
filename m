Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50771295176
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503432AbgJURXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503425AbgJURXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 13:23:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364B32224E;
        Wed, 21 Oct 2020 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603300997;
        bh=YA9jBkVMmo05R+aNQt5Q2EoT45SvEhPakf2Z3jA36TQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ospIKljzcpG0W2b/7kov9FOV5ZWUhI9200O1Rdf0GF1asl+1ZQ0KAhNTSmhMTzPAt
         X3YtHg/vqtLkUs7xyAedboCcaYq4/kqcAUP9mUmBJecBri7KugXKFG/BNg0leNIoWT
         r1Yty3Xh9Ucw6hVXiLH2hC5ZGCql+Pvv4BtH7Z1U=
Date:   Wed, 21 Oct 2020 10:23:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Defang Bo <bodefang@126.com>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tg3: Avoid NULL pointer dereference in
 netif_device_attach()
Message-ID: <20201021102315.3dab7bc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1603265889-8967-1-git-send-email-bodefang@126.com>
References: <1603265889-8967-1-git-send-email-bodefang@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 15:38:09 +0800 Defang Bo wrote:
> Similar to commit<1b0ff89852d7>("tg3: Avoid NULL pointer dereference in tg3_io_error_detected()")
> This patch avoids NULL pointer dereference add a check for netdev being NULL on tg3_resume().
> 
> Signed-off-by: Defang Bo <bodefang@126.com>

Are you actually hitting this error or can otherwise prove it may
happen?

PCIe error handlers could reasonably happen asynchronously during
probe, but suspend/resume getting called on a device that wasn't fully
probed sounds like something that should be prevented by the bus.

> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index ae756dd..345c6aa 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -18099,7 +18099,7 @@ static int tg3_resume(struct device *device)
>  
>  	rtnl_lock();
>  
> -	if (!netdev || !netif_running(dev))
> +	if (!dev || !netif_running(dev))
>  		goto unlock;
>  
>  	netif_device_attach(dev);

