Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE40C2E40
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 09:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbfJAHjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 03:39:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56008 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJAHjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 03:39:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFCkW-00013w-NK; Tue, 01 Oct 2019 09:39:08 +0200
Message-ID: <1b17084d8649bab347b952231d9312b7fb7307f4.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 00/12] net: fix nested device bugs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?Q?Ji=C5=99=C3=AD_P=C3=ADrko?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Date:   Tue, 01 Oct 2019 09:39:07 +0200
In-Reply-To: <CAMArcTWs3wzad7ai_zQPCwzC62cFp-poELn+jnDaP7eT1a9ucw@mail.gmail.com> (sfid-20190929_103128_233294_188E5AB3)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <2e836018c7ea299037d732e5138ca395bd1ae50f.camel@sipsolutions.net>
         <CAMArcTWs3wzad7ai_zQPCwzC62cFp-poELn+jnDaP7eT1a9ucw@mail.gmail.com>
         (sfid-20190929_103128_233294_188E5AB3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-09-29 at 17:31 +0900, Taehee Yoo wrote:

> virt_wifi case is a little bit different case.

Well, arguably, it was also just missing this - it just looks different
:)

> I add the last patch that is to fix refcnt leaks in the virt_wifi module.
> The way to fix this is to add notifier routine.
> The notifier routine could delete lower device before deleting
> virt_wifi device.
> If virt_wifi devices are nested, notifier would work recursively.
> At that time, it would make stack memory overflow.
> 
> Actually, before this patch, virt_wifi doesn't have the same problem.
> So, I will update a comment in a v5 patch.

OK, sure.

> Many other devices use this way to avoid wrong nesting configuration.
> And I think it's a good way.
> But we should think about the below configuration.
> 
> vlan5
>    |
> virt_wifi4
>    |
> vlan3
>    |
> virt_wifi2
>    |
> vlan1
>    |
> dummy0
> 
> That code wouldn't avoid this configuration.
> And all devices couldn't avoid this config.

Good point, so then really that isn't useful to check - most people
won't try to set it up that way (since it's completely useless) and if
they do anyway too much nesting would be caught by your patchset here.

> I have been considering this case, but I couldn't make a decision yet.
> Maybe common netdev function is needed to find the same device type
>  in their graph.

I don't think it's worthwhile just to prevent somebody from making a
configuration that we think now is nonsense. Perhaps they do have some
kind of useful use-case for it ...

> This is a little bit different question for you.
> I found another bug in virt_wifi after my last patch.
> Please test below commands
>     ip link add dummy0 type dummy
>     ip link add vw1 link dummy0 type virt_wifi
>     ip link add vw2 link vw1 type virt_wifi
>     modprobe -rv virt_wifi
> 
> Then, you can see the warning messages.
> If SET_NETDEV_DEV() is deleted in the virt_wifi_newlink(),
> you can avoid that warning message.
> But I'm not sure about it's safe to remove that.
> I would really appreciate it if you let me know about that.

Hmm, I don't see any warnings. SET_NETDEV_DEV() should be there though.
Do you see the same if you stack it with something else inbetween? If
not, I guess preventing virt_wifi from stacking on top of itself would
be sufficient ...

johannes

