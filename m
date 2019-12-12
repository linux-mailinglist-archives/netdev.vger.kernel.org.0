Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39CA11CCA9
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbfLLL7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:59:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57732 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbfLLL7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 06:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vnGwr+kZvCAPIxAfB1Tmecji+9efJjgi0AzeGhFUq+c=; b=lHdPaRPWSZ9srrArH8D6H34Qm
        yPTleVnvXFg5rgWrr4A3TnSTXsE6ZpihNljA25d0M4Vfu0CXk0vfvdvIt/QErWTbFEFFLrPZPxhrm
        fRlCxFEe7hyE0HTkzjsDcs6uDNU5JNUMPrL7jyn1QFCdSYwQfkVcREML53+f29czB1/FpdYtOsdIE
        4fB9mV+gywNQjiBKaTm9+3OUHxCvFAYoOhk7tJpsdYcRPXWmBTnYdtn9E5Z0ZIy++wwRNecMoS6fx
        ScTNvekP7rlkU2MRjBhbfO7PfyEQ23RS8J4waUn/9To+qKtgoFnwvyx5X3LEy29shV0H8irmbLfRg
        krmJwtkfQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40300)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifN85-0006TW-Q9
        for netdev@vger.kernel.org; Thu, 12 Dec 2019 11:59:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifN84-0006lV-GG
        for netdev@vger.kernel.org; Thu, 12 Dec 2019 11:59:36 +0000
Date:   Thu, 12 Dec 2019 11:59:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: Re: v5.2: stuck ipv4 redirects
Message-ID: <20191212115936.GG25745@shell.armlinux.org.uk>
References: <20191212114452.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212114452.GF25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 11:44:52AM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> I'm seeing a problem with ipv4 redirects seemingly not expiring.
> 
> I have:
> - A VM running a 5.2 kernel, with IP address 192.168.0.251/23, default
>   route 192.168.0.254.
> - The main router at 192.168.0.254/23.
> - A second router which was at 192.168.1.59/23, but which I moved to
>   192.168.0.245/23.  Behind this is a subnet 192.168.253.252/30.
> 
> The VM at some point received a redirect from 192.168.0.254 for
> 192.168.253.254, telling it to redirect to 192.168.1.59.
> 
> Since the IP change of the second router, the VM has been unable to
> contact 192.168.253.254, but can contact 192.168.253.253.  What I
> see via tcpdump is:
> 
> 11:34:48.549410 ARP, Request who-has 192.168.1.59 tell 192.168.0.251, length 28
> 
> I haven't found a way to view any information on the redirects that
> the VM kernel has accepted.  The `ip' tool doesn't seem to have any
> way to access that information (or I'm missing something.)
> 
> Any ideas what is going on, how to inspect the kernel's state from
> userland wrt redirects, and how this can be solved without rebooting?

It seems others have come across this as well:

http://commandline.ninja/2015/06/18/damn-you-icmp-redirect-or-rather-how-to-flush-a-cached-icmp-redirect-under-centos7linux/

and with that, I've a way to "solve" the problem - but it seems that
some redirects can get stuck:

$ ip -s route get 192.168.253.254
192.168.253.254 via 192.168.1.59 dev enp1s0 src 192.168.0.251 uid 1000
    cache <redirected> users 2
$ ip -s route get 192.168.253.253
192.168.253.253 via 192.168.0.245 dev enp1s0 src 192.168.0.251 uid 1000
    cache <redirected> expires 274sec users 2 age 24sec

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
