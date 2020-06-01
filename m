Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BC21EA39C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 14:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFAMPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 08:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFAMPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 08:15:20 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CADEC061A0E;
        Mon,  1 Jun 2020 05:15:20 -0700 (PDT)
Received: from 2606-a000-111b-4634-0000-0000-0000-1bf2.inf6.spectrum.com ([2606:a000:111b:4634::1bf2] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1jfjLE-0006ak-5S; Mon, 01 Jun 2020 08:15:05 -0400
Date:   Mon, 1 Jun 2020 08:14:55 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Julien Gomes <julien@arista.com>
Subject: Re: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4]
 sctp: add some missing events from rfc5061)
Message-ID: <20200601121455.GA210755@hmswarspite.think-freely.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <20200419102536.GA4127396@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419102536.GA4127396@nataraja>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 12:25:36PM +0200, Harald Welte wrote:
> Dear Linux SCTP developers,
> 
> this patchset (merged back in Q4/2019) has broken ABI compatibility, more
> or less exactly as it was discussed/predicted in Message-Id
> <20190206201430.18830-1-julien@arista.com>
> "[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length"
> on this very list in February 2019.
> 
> The process to reproduce this is quite simple:
> * upgrade your kernel / uapi headers to a later version (happens
>   automatically on most distributions as linux-libc-dev is upgraded)
> * rebuild any application using SCTP_EVENTS which was working perfectly
>   fine before
> * fail to execute on any older kernels
> 
> This can be a severe issue in production systems where you may not
> upgrade the kernel until/unless a severe security issue actually makes
> you do so.
> 
> Those steps above can very well happen on different machines, i.e. your
> build server having a more recent linux-libc-dev package (and hence
> linux/sctp.h) than some of the users in the field are running kernels.
> 
> I think this is a severe problem that affects portability of binaries
> between differnt Linux versions and hence the kind of ABI breakage that
> the kernel exactly doesn't want to have.
> 
> The point here is that there is no check if any of those newly-added
> events at the end are actually used.  I can accept that programs using
> those new options will not run on older kernels - obviously.  But old
> programs that have no interest in new events being added should run just
> fine, even if rebuilt against modern headers.
> 
> In the kernel setsockopt handling coee: Why not simply check if any of
> the newly-added events are actually set to non-zero?  If those are all
> zero, we can assume that the code doesn't use them.
> 
> Yes, for all the existing kernels out there it's too late as they simply
> only have the size based check.  But I'm worried history will repeat
> itself...
> 
> Thanks for your consideration.
> 
As Marcello noted, I don't think theres anything we can do here.  We screwed
this up, but reverting the change is just going to create a second breakage
point through which users are going to have to deal with this.  The best way
forward is to document the need to run a newer userspace uapi header set on a
correspondingly new kernel, and be sure in the future that any extension to the
uapi structures are codified as separate structures with separate socket options
(or some simmilar approach to allow for fixed size api structures)

Neil

> -- 
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
> ============================================================================
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. A6)
> 
