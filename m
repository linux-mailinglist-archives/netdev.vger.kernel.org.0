Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559682AADB5
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKHVhP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Nov 2020 16:37:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHVhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:37:15 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kbsN1-0008KN-Sy; Sun, 08 Nov 2020 21:37:08 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2C9FB5FEE8; Sun,  8 Nov 2020 13:37:06 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 246D0A0409;
        Sun,  8 Nov 2020 13:37:06 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     LIU Yulong <liuyulong.xa@gmail.com>, netdev@vger.kernel.org,
        LIU Yulong <i@liuyulong.me>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH v2] net: bonding: alb disable balance for IPv6 multicast related mac
In-reply-to: <20201107103950.70cf9353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me> <1604303803-30660-1-git-send-email-i@liuyulong.me> <20201103130559.0335c353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201107103950.70cf9353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Sat, 07 Nov 2020 10:39:50 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16802.1604871426.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Sun, 08 Nov 2020 13:37:06 -0800
Message-ID: <16803.1604871426@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Tue, 3 Nov 2020 13:05:59 -0800 Jakub Kicinski wrote:
>> On Mon,  2 Nov 2020 15:56:43 +0800 LIU Yulong wrote:
>> > According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
>> > construct the multicast destination MAC address for IPv6 multicast traffic.
>> > The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
>> > rule. The work steps [6] are:
>> >   *) Let's assume a destination address of 2001:db8:1:1::1.
>> >   *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
>> >      format of ff02::1:ffXX:XXXX.
>> >   *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
>> >      directly from the last 24 bits of the destination address.
>> >   *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
>> >   *) This, being a multicast address, can be mapped to a multicast MAC
>> >      address, using the format 33-33-XX-XX-XX-XX
>> >   *) Resulting in 33-33-ff-00-00-01.
>> >   *) This is a MAC address that is only being listened for by nodes
>> >      sharing the same last 24 bits.
>> >   *) In other words, while there is a chance for a "address collision",
>> >      it is a vast improvement over ARP's guaranteed "collision".
>> > Kernel related code can be found at [3][4][5].  
>> 
>> Please make sure you keep maintainers CCed on your postings, adding bond
>> maintainers now.
>
>Looks like no reviews are coming in, so I had a closer look.
>
>It's concerning that we'll disable load balancing for all IPv6 multicast
>addresses now. AFAIU you're only concerned about 33:33:ff:00:00:01, can
>we not compare against that?

	It's not fixed as 33:33:ff:00:00:01, that's just the example.
The first two octets are fixed as 33:33, and the remaining four are
derived from the SNMA, which in turn comes from the destination IPv6
address.

	I can't decide if this is genuinely a reasonable change overall,
or if the described topology is simply untenable in the environment that
the balance-alb mode creates.  My specific concern is that the alb mode
will periodically rebalance its TX load, so outgoing traffic will
migrate from one bond port to another from time to time.  It's unclear
to me how the described topology that's broken by the multicast traffic
being TX balanced is not also broken by the alb TX side rebalances.

	-J

>The way the comparison is written now it does a single 64bit comparison
>per address, so it's the same number of instructions to compare the top
>two bytes or two full addresses.


---
	-Jay Vosburgh, jay.vosburgh@canonical.com
