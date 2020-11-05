Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3EC2A73B2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732920AbgKEAYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgKEAYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:24:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC602080D;
        Thu,  5 Nov 2020 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604535885;
        bh=uYtt1Nd+0axqH7yuxo8Tc4Yl1kGBqXxqhhp8NdbBKbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ExvxMxxJ+ZxeVDpHX1VNEHHr8mx4wPekye0QK5AmFgc+8JfUXPnXN8E5CSRa/Bs2+
         TFOeeF5Ie5/WISQ7G0HdKNXvkGpLS4hH8f8BLNpsRv03sP+smtq3d/vG0nGHLguH3s
         b1fgHmXEybTKMnNwIx7CfTHyKSrTIY/6K8jnORIw=
Date:   Wed, 4 Nov 2020 16:24:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [RESEND PATCH v3] net: usb: usbnet: update
 __usbnet_{read|write}_cmd() to use new API
Message-ID: <20201104162444.66b5cc56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102173946.13800-1-anant.thazhemadam@gmail.com>
References: <20201102173946.13800-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 23:09:46 +0530 Anant Thazhemadam wrote:
> Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
> However, this could lead to potential partial reads/writes being
> considered valid, and since most of the callers of
> usbnet_{read|write}_cmd() don't take partial reads/writes into account
> (only checking for negative error number is done), and this can lead to
> issues.
> 
> However, the new usb_control_msg_{send|recv}() APIs don't allow partial
> reads and writes.
> Using the new APIs also relaxes the return value checking that must
> be done after usbnet_{read|write}_cmd() is called.
> 
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

So you're changing the semantics without updating the callers?

I'm confused. 

Is this supposed to be applied to some tree which already has the
callers fixed?

At a quick scan at least drivers/net/usb/plusb.c* would get confused 
as it compares the return value to zero and 0 used to mean "nothing
transferred", now it means "all good", no? 

* I haven't looked at all the other callers
