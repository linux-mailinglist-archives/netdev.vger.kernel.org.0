Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7FE19AF27
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbgDAP4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 11:56:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:46200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732799AbgDAP4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 11:56:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EADAAAC84;
        Wed,  1 Apr 2020 15:56:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9AAD3E0FC6; Wed,  1 Apr 2020 17:56:01 +0200 (CEST)
Date:   Wed, 1 Apr 2020 17:56:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Mikhail Morfikov <morfikov@gmail.com>
Subject: Re: Creating a bonding interface via the ip tool gives it the wrong
 MAC address
Message-ID: <20200401155601.GW31519@unicorn.suse.cz>
References: <a43adea0-8885-2bda-c931-5b8bf06e3a70@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a43adea0-8885-2bda-c931-5b8bf06e3a70@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 05:03:58PM +0200, Mikhail Morfikov wrote:
> A couple months ago I opened an issue on the Debian Bug Tracker[1] concerning
> some weird network behavior, in which bonding interface was involved. Basically, 
> what I wanted to achieve was to have two interfaces (eth0 and wlan0) of my 
> laptop in the *active-backup* mode, and in order to make this work, the 
> *fail_over_mac* has to be set to *none*. Then the two interfaces (and also the 
> bond0 interface) should have the same MAC address, which is set based on the 
> interface specified by the *primary* parameter (in this case eth0). 
> 
> This was working well in the past, but it stopped for some reason. When the 
> bond0 interface is being set up via the /etc/network/interfaces file, it gets 
> wrong MAC address, and it's always the same MAC (ca:16:91:ae:9a:ba).  
> 
> I didn't really know where the problem was (it looks like no one knows so far), 
> but I recently moved from ifupdown to systemd-networkd, and I noticed that the 
> issue went away, at least in the default config. But in my case, I had to 
> create the bonding interface during the initramfs/initrd phase using the *ip* 
> tool (the regular one, and not the one from busybox). And the problem came back, 
> but in this case I couldn't really fix it by just restarting the network 
> connection.
> 
> So I created manually the bond0 interface using the *ip* tool in the following 
> way to check what will happen:
> 
> ip link add name bond0 type bond mode active-backup \
>   miimon 200 \
>   downdelay 400 \
>   updelay 400 \
>   primary eth0 \
>   primary_reselect always \
>   fail_over_mac none \
>   min_links 1
> 
> and the interface got the MAC in question. That gave me the idea that something 
> could be wrong with setting up/configuring the bonding interface via the *ip* 
> tool because it works well with systemd-networkd, which I think doesn't use the 
> tool to configure the network interfaces.
> 
> So why does this happen?

I suspect you may be hitting the same issue as we had in

  https://bugzilla.suse.com/show_bug.cgi?id=1136600

(comment 9 explains the problem).

Michal
