Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACEA1AF964
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgDSKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 06:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725923AbgDSKne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 06:43:34 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Apr 2020 03:43:34 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E94C061A0C;
        Sun, 19 Apr 2020 03:43:34 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1jQ79J-0006qa-Fq; Sun, 19 Apr 2020 12:26:05 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.93)
        (envelope-from <laforge@gnumonks.org>)
        id 1jQ78q-003NMz-AL; Sun, 19 Apr 2020 12:25:36 +0200
Date:   Sun, 19 Apr 2020 12:25:36 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Julien Gomes <julien@arista.com>
Subject: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4] sctp:
 add some missing events from rfc5061)
Message-ID: <20200419102536.GA4127396@nataraja>
References: <cover.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux SCTP developers,

this patchset (merged back in Q4/2019) has broken ABI compatibility, more
or less exactly as it was discussed/predicted in Message-Id
<20190206201430.18830-1-julien@arista.com>
"[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length"
on this very list in February 2019.

The process to reproduce this is quite simple:
* upgrade your kernel / uapi headers to a later version (happens
  automatically on most distributions as linux-libc-dev is upgraded)
* rebuild any application using SCTP_EVENTS which was working perfectly
  fine before
* fail to execute on any older kernels

This can be a severe issue in production systems where you may not
upgrade the kernel until/unless a severe security issue actually makes
you do so.

Those steps above can very well happen on different machines, i.e. your
build server having a more recent linux-libc-dev package (and hence
linux/sctp.h) than some of the users in the field are running kernels.

I think this is a severe problem that affects portability of binaries
between differnt Linux versions and hence the kind of ABI breakage that
the kernel exactly doesn't want to have.

The point here is that there is no check if any of those newly-added
events at the end are actually used.  I can accept that programs using
those new options will not run on older kernels - obviously.  But old
programs that have no interest in new events being added should run just
fine, even if rebuilt against modern headers.

In the kernel setsockopt handling coee: Why not simply check if any of
the newly-added events are actually set to non-zero?  If those are all
zero, we can assume that the code doesn't use them.

Yes, for all the existing kernels out there it's too late as they simply
only have the size based check.  But I'm worried history will repeat
itself...

Thanks for your consideration.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
