Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954471EA21D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgFAKqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFAKqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:46:44 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E63FC061A0E;
        Mon,  1 Jun 2020 03:46:44 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1jfhxj-000525-OD; Mon, 01 Jun 2020 12:46:35 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.93)
        (envelope-from <laforge@gnumonks.org>)
        id 1jfhxe-001xbq-Fy; Mon, 01 Jun 2020 12:46:30 +0200
Date:   Mon, 1 Jun 2020 12:46:30 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org
Subject: Re: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4]
 sctp: add some missing events from rfc5061)
Message-ID: <20200601104630.GQ182140@nataraja>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <20200419102536.GA4127396@nataraja>
 <20200501131607.GU1294372@nataraja>
 <20200501142008.GC2470@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501142008.GC2470@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear SCTP developers,

I have to get back to this bug.  It is slowly turning into a nightmare.

Not only affected it forwards/backwards compatibility of application binaries
during upgrades of a distribution, but it also affects the ability to run
containerized workloads with SCTP.  It's sort-of obvious but I didn't
realize it until now.

We are observing this problem now when we operate CentOS 8 based containers
on a Debian 9 based (docker) host.  Apparently the CentOS userland has a different
definition of the event structure (larger) than the Debian kernel has (smaller) -> boom.

From my point of view, this bug is making it virtually impossible to run
containerized telecom workloads.  I guess most users are very
conservative and still running rather ancient kernels and/or
distributions, but as soon as they start upgrading their kernel to
anything that includes that patch to the SCTP events structure, the
nightmare starts.

To my knowledge, there is no infrastructure at all for a situation like this - neither
in the Docker universe nor in k8s..  You cannot build separate container
images depending on what the host OS/kernel is going to be.

And particularly, if you are not self-hosting your container runtimes
but running your containers on some kind of cloud infrastructure
provider, you have no control over what exact kernel version might be in
use there - and it also may change at any time at the discretion of the
cloud service provider.

On Fri, May 01, 2020 at 11:20:08AM -0300, Marcelo Ricardo Leitner wrote:
> That's what we want as well. Some breakage happened, yes, by mistake,
> and fixing that properly now, without breaking anything else, may be
> just impossible, unfortunatelly. But you can be sure that we are
> engaged on not doing it again.

I would actually seriously consider to roll that change back - not only
in the next kernel release but also in all stable kernel releases.  At least
the breakage then is constrained to a limited set of kernel versions.

Alternatively, I suggest to at least apply a patch to all supported
stable kernel series (picked up hopefully distributions) that makes those
older kernels accept a larger-length sctp_event_subscribe structure from
userspace, *if* any of the additional members are 0 (memcmp the
difference between old and new).

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
