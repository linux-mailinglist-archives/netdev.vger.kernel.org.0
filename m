Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0AF11CC74
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfLLLo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:44:56 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57556 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfLLLoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 06:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bzYtROeLHTdDI+24acxdpnB6/wC/k0aaf6KB5TG5RzE=; b=H7VNdAkEOXGERhUu41O4wZVHX
        dHi5lm19QAcrJxvMviJ7L2Os1hlzzCb6BV+Lmgf6BVAT/y1G0iLKaUVsyjq4fbA5hf91qkdB+epmN
        d4iIIpOws2NJkIYJ+ZlwLJ1M0RVRh926ZVePMLyDkW3DT7WAUHHqnwg+hiFtVP+siC2EHafKxhfWW
        w0ZMr10nw6oPNksqzvaxZ4Imt50zcnBCDvqPpaiySBz7JDx/KAgooGPjFRQ3wCxChxuOI7m36iAck
        qgyruYpSba+ye6Z7FMMnwcKs0fKXJVkBaMAcmlKb8lb4kv5dP3vlzAJzkJknxnIrlmvJsD8YtCFlg
        SYaW5AoqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51952)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifMto-0006PF-Ts
        for netdev@vger.kernel.org; Thu, 12 Dec 2019 11:44:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifMto-0006k4-CX
        for netdev@vger.kernel.org; Thu, 12 Dec 2019 11:44:52 +0000
Date:   Thu, 12 Dec 2019 11:44:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: v5.2: stuck ipv4 redirects
Message-ID: <20191212114452.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm seeing a problem with ipv4 redirects seemingly not expiring.

I have:
- A VM running a 5.2 kernel, with IP address 192.168.0.251/23, default
  route 192.168.0.254.
- The main router at 192.168.0.254/23.
- A second router which was at 192.168.1.59/23, but which I moved to
  192.168.0.245/23.  Behind this is a subnet 192.168.253.252/30.

The VM at some point received a redirect from 192.168.0.254 for
192.168.253.254, telling it to redirect to 192.168.1.59.

Since the IP change of the second router, the VM has been unable to
contact 192.168.253.254, but can contact 192.168.253.253.  What I
see via tcpdump is:

11:34:48.549410 ARP, Request who-has 192.168.1.59 tell 192.168.0.251, length 28

I haven't found a way to view any information on the redirects that
the VM kernel has accepted.  The `ip' tool doesn't seem to have any
way to access that information (or I'm missing something.)

Any ideas what is going on, how to inspect the kernel's state from
userland wrt redirects, and how this can be solved without rebooting?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
