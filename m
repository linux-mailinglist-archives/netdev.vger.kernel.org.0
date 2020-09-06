Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634AE25EF1B
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIFQ01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 12:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFQ0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 12:26:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C0B820709;
        Sun,  6 Sep 2020 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599409583;
        bh=hJp+qATOFylIa3y0vlxW2BD+WH7p8cy8K26upvnrakI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZGYWf5GvVkRR144ONX9qVMifl9mCy4NpoNHh9qJHRJnvQ0+OdTn2omykDa9IXuQq2
         9lC43miWxqIbIqOWwhtjLqLOUQuC1Qp5ZgrnZQdTqYjPdfwHhMeunSHUOMKUEHtpxm
         3c42pKtZ9tOEvusFFR+kGv8Eb2CCOaUkvhjFnqDg=
Date:   Sun, 6 Sep 2020 09:26:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH net] hv_netvsc: Fix hibernation for mlx5 VF driver
Message-ID: <20200906092621.72005293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <KU1P153MB012097D6AA971EC957D854B2BF2B0@KU1P153MB0120.APCP153.PROD.OUTLOOK.COM>
References: <20200905025218.45268-1-decui@microsoft.com>
        <20200905162712.65b886a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <KU1P153MB012097D6AA971EC957D854B2BF2B0@KU1P153MB0120.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 03:05:48 +0000 Dexuan Cui wrote:
> > > @@ -2635,6 +2632,10 @@ static int netvsc_resume(struct hv_device *dev)
> > >  	netvsc_devinfo_put(device_info);
> > >  	net_device_ctx->saved_netvsc_dev_info = NULL;
> > >
> > > +	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
> > > +	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
> > > +		ret = -EINVAL;  
> > 
> > Should you perhaps remove the VF in case of the failure?  
> IMO this failure actually should not happen since we're resuming the netvsc
> NIC, so we're sure we have a valid pointer to the netvsc net device, and
> netvsc_vf_changed() should be able to find the netvsc pointer and return
> NOTIFY_OK. In case of a failure, something really bad must be happening,
> and I'm not sure if it's safe to simply remove the VF, so I just return
> -EINVAL for simplicity, since I believe the failure should not happen in practice.

Okay, I see that the errors propagated by netvsc_vf_changed() aren't
actually coming from netvsc_switch_datapath(), so you're right. The
failures here won't be meaningful.

> I would rather keep the code as-is, but I'm OK to add a WARN_ON(1) if you
> think that's necessary.

No need, I think core will complain when resume callback fails. That
should be sufficient.
