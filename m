Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702A232DFE2
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCEDEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:04:44 -0500
Received: from correo.us.es ([193.147.175.20]:53934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEDEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 22:04:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F572DA84E
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 04:04:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F205DDA78D
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 04:04:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E712CDA789; Fri,  5 Mar 2021 04:04:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-105.9 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        FORGED_MUA_MOZILLA,NICE_REPLY_A,SMTPAUTH_US2,USER_IN_WELCOMELIST,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E437DA704;
        Fri,  5 Mar 2021 04:04:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Mar 2021 04:04:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8006742DC6E2;
        Fri,  5 Mar 2021 04:04:37 +0100 (CET)
Date:   Fri, 5 Mar 2021 04:04:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     fw@strlen.de, netdev@vger.kernel.org, linux-man@vger.kernel.org,
        teigland@redhat.com
Subject: Re: [PATCH resend] netlink.7: note not reliable if NETLINK_NO_ENOBUFS
Message-ID: <20210305030437.GA4268@salvia>
References: <20210304205728.34477-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210304205728.34477-1-aahringo@redhat.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Thu, Mar 04, 2021 at 03:57:28PM -0500, Alexander Aring wrote:
> This patch adds a note to the netlink manpage that if NETLINK_NO_ENOBUFS
> is set there is no additional handling to make netlink reliable. It just
> disables the error notification.

A bit more background on this toggle.

NETLINK_NO_ENOBUFS also disables netlink broadcast congestion control
which kicks in when the socket buffer gets full. The existing
congestion control algorithm keeps dropping netlink event messages
until the queue is emptied. Note that it might take a while until your
userspace process fully empties the socket queue that is congested
(and during that time _your process is losing every netlink event_).

The usual approach when your process hits ENOBUFS is to resync via
NLM_F_DUMP unicast request. However, getting back to sync with the
kernel subsystem might be expensive if the number of items that are
exposed via netlink is huge.

Note that some people select very large socket buffer queue for
netlink sockets when they notice ENOBUFS. This might however makes
things worse because, as I said, congestion control drops every
netlink message until the queue is emptied. Selecting a large socket
buffer might help to postpone the ENOBUFS error, but once your process
hits ENOBUFS, then the netlink congestion control kicks in and you
will make you lose a lot of event messages (until the queue is empty
again!).

So NETLINK_NO_ENOBUFS from userspace makes sense if:

1) You are subscribed to a netlink broadcast group (so it does _not_
   make sense for unicast netlink sockets).
2) The kernel subsystem delivers the netlink messages you are
   subscribed to from atomic context (e.g. network packet path, if
   the netlink event is triggered by network packets, your process
   might get spammed with a lot of netlink messages in little time,
   depending on your network workload).
3) Your process does not want to resync on lost netlink messages.
   Your process assumes that events might get lost but it does not
   case / it does not want to make any specific action in such case.
4) You want to disable the netlink broadcast congestion control.

To provide an example kernel subsystem, this toggle can be useful with
the connection tracking system, when monitoring for new connection
events in a soft real-time fashion.

> The used word "avoid" receiving ENOBUFS errors can be interpreted
> that netlink tries to do some additional queue handling to avoid
> that such scenario occurs at all, e.g. like zerocopy which tries to
> avoid memory copy. However disable is not the right word here as
> well that in some cases ENOBUFS can be still received. This patch
> makes clear that there will no additional handling to put netlink in
> a more reliable mode.

Right, the NETLINK_NO_ENOBUFS toggle alone itself is not making
netlink more reliable for the broadcast scenario, it just changes the
way it netlink broadcast deals with congestion: userspace process gets
no reports on lost messages and netlink congestion control is
disabled.
