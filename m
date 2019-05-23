Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D440828D26
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbfEWWcB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 May 2019 18:32:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60660 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388293AbfEWWb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 18:31:59 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hTwFi-0000Wl-8Z; Thu, 23 May 2019 22:31:58 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 655235FF12; Thu, 23 May 2019 15:31:56 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5DACBA6E88;
        Thu, 23 May 2019 15:31:56 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     billcarlson@wkks.org
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: bonding-devel mail list?
In-reply-to: <ec7a86ec-56e0-7846-ed02-337850fc8478@wkks.org>
References: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org> <18472.1558629973@famine> <ec7a86ec-56e0-7846-ed02-337850fc8478@wkks.org>
Comments: In-reply-to Bill Carlson <billcarlson@wkks.org>
   message dated "Thu, 23 May 2019 15:06:11 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32363.1558650716.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 23 May 2019 15:31:56 -0700
Message-ID: <32364.1558650716@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bill Carlson <billcarlson@wkks.org> wrote:

>On 5/23/19 11:46 AM, Jay Vosburgh wrote:
>> As far as I'm aware, nesting bonds has no practical benefit; do
>> you have a use case for doing so?
>>
>>
>Use case is very specific, but needed in my situation until some switches
>are stabilized.
>
>Switches A1..Ax provide LACP, 40G. These are unstable, lose link on one or
>more interfaces or drop completely. A single bond to the A switches was
>acceptable at first, including when one interface was down for quite a
>while. Then all A switches dropped.
>
>Switches B1..Bx provide no LACP, 10G. These are sitting and connected
>anyway, already in place for backup.
>
>All are on the same layer two, as in any MAC is visible on any switch.
>
>Goal is to use A switches primarily, and drop back to B _IF_ A are
>completely down. As long as one interface is active on A, that will be
>used.
>
>I assume LACP and active-passive can't be used in the same bond,
>interested to hear if I'm wrong.

	Well, yes and no.

	No, you can't explicitly configure what you describe (in the
sense of saying "slave A is LACP, slave B is active-backup").

	However, the logic in LACP will attach every slave of the bond
to an aggregator.  If one or more slaves are connected to a specific
LACP peer, they will aggregate together.  If any slave is connected to a
non-LACP peer, it will aggregate as an "individual" port.

	When bonding's LACP mode selects the best aggregator to use,
"non-individual" (i.e., connected to a LACP peer) ports are preferred,
but if no such ports are available, an individual port is selected as
the active aggregator.  The precise logic is found in the
ad_agg_selection_test() function [1].

	If what you've got works for you, then that's great, but I
suspect it would still work if all of the interfaces were in a single
802.3ad bond without the nesting.

	-J

[1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/drivers/net/bonding/bond_3ad.c#n1562


>My setup I achieved:
>
>bond0 -> switches B, multiple interfaces, active-passive
>bond1 -> switches A, multiple interfaces, LACP
>bond10 -> slaves bond0 and bond1, active-passive
>Various VLANs are using bond10.
>
>Options to bonding:
>
>bond0: mode=1 fail_over_mac=none miimon=100
>bond1: mode=4 lacp_rate=1 miimon=100
>bond10: mode=1 fail_over_mac=1 primary=bond1 updelay=10000 miimon=100
>(I should probably change to arp monitoring, I know.)
>
>updelay in place because LACP takes a long time to link.
>Making sure the MACs switched was the key.
>
>Network performance tests via iperf3 look good, including when dropping
>bond1. Unfortunately, target test system was on bond0, as its A switches
>were down.
>
>The only, critical, test I haven't been able to perform is physically
>dropping A links, can't reach that far. :)
>
>-- 
>
>Bill Carlson
>
>Anything is possible, given Time and Money.

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
