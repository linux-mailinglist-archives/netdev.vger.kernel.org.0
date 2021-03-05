Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4332F5CD
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhCEWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhCEWS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1199865068;
        Fri,  5 Mar 2021 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614982738;
        bh=ZmbUDVyFThVB/PPBMR6fmYdPuirmu9fypW77xRB2rPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gmydiq7movEhnLSdBkmNbPZnaepPSXmCSPOCjhTEwMaBrLJaSddnFikxhLHFx4Ody
         PIETpLkQFedlmYkeFiGkVmmRCvahle7x36sSMHoNNoRc/GDPJxpR7mr7DImjL0Tziu
         UnK6OQ1D63UKDdNHOz6hQPfImD281zWMNOHVuV7HGcE11cXtDaNFvZQrLGI4c3o058
         ZepaUfRfF6xZlNOV77V9ZDrpXEatdE2m+QTL9SRFtz+HeKZZjFTQARkrfvCt4uIEuY
         R9zaoYAIxzimCepWCvykvGIu6j3g0ysRcARW0NZqKk5Z6E7ErGTu+qDMPPBgRyD649
         e8BVslRqHT76A==
Date:   Fri, 5 Mar 2021 14:18:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zbynek Michl <zbynek.michl@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [regression] Kernel panic on resume from sleep
Message-ID: <20210305141857.1e6e60a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJH0kmzTD2+zbTWrBxN0_2f4A266YhoUTFa4-Tcg+Obx=TDqgA@mail.gmail.com>
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
        <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com>
        <20210304095110.7830dce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJH0kmzTD2+zbTWrBxN0_2f4A266YhoUTFa4-Tcg+Obx=TDqgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Mar 2021 13:50:28 +0100 Zbynek Michl wrote:
> On Thu, Mar 4, 2021 at 6:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > Depends if kernel attempts to try to send a packet before __alx_open()
> > finishes. You can probably make it more likely by running trafgen, iperf
> > or such while suspending and resuming?  
> 
> I've tried "ping -f <GW>" first, but there was no effect - PC woke up
> successfully.
> 
> Then I've tried TCP connection, like "wget -O /dev/null
> https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.3.tar.xz" and
> this kills the kernel on resume reliably.
> 
> So perphaps ICMP and TCP behave differently?
> 
> Anyway, I'm happy to be able to finally enforce the kernel crash this way :)
> 
> > I didn't look too closely to find out if things indeed worked 100%
> > correctly before, but now they will reliably crash on a NULL pointer
> > dereference if transmission comes before open is done.  
> 
> I can confirm that the fix really works and I cannot enforce the
> kernel crash anymore.
> 
> So can we merge the patch to the mainline, and ideally also to the 5.10?

Great, I submitted the patch and marked it for stable inclusion!

It should percolate through the trees in a couple of weeks.
