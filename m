Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C408C2F9006
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 02:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbhAQBWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 20:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAQBWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 20:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EDA22BF3;
        Sun, 17 Jan 2021 01:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610846481;
        bh=X01ly3U51Dml9KkkfYM2AMh2knS4iTsiQgsBlO4rI5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dLT5xC+un6l1jXjOHcCA5qD4lLIHh8b6UE3zuPEUy4jQQZIpzSnTVIRMADZf0x6rr
         35PkE+MrQ6GekpJbwdyFWpjpnpNe3NZU45B+vGYi6ky/OUFGYgFRswEJmp4vOGhlTn
         pn1iOTUiiHey33lblF7Wk2XlWnsa6W2wXqELuwYkgVh87MKlymEw9HNkb0JCFpVlqb
         FOBUU6Z7mQN+iSUJ8xBpFvOG71wFsQSovkJ+HjKiadd8079Fn3e8A36dOM1ocMVtmJ
         JqVek5Kse6mASPletUTQEUoWwYsfujehoNFUxh87DFN0HWmVp/cqW1Jd7skD/r0IeC
         QGR1KyU5C5l0g==
Date:   Sat, 16 Jan 2021 17:21:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
Message-ID: <20210116172119.2c68d4c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
        <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 22:12:23 +0100 Michal Kubecek wrote:
> On Fri, Jan 15, 2021 at 03:53:25PM -0800, Jakub Kicinski wrote:
> > On Fri, 15 Jan 2021 14:59:50 -0800 Edwin Peer wrote:  
> > > The maximum possible length of an RTNL attribute is 64KB, but the
> > > nested VFINFO list exceeds this for more than about 220 VFs (each VF
> > > consumes approximately 300 bytes, depending on alignment and optional
> > > fields). Exceeding the limit causes IFLA_VFINFO_LIST's length to wrap
> > > modulo 16 bits in the kernel's nla_nest_end().  
> > 
> > Let's add Michal to CC, my faulty memory tells me he was fighting with
> > this in the past.  
> 
> I've been looking into this some time ago and even tried to open
> a discussion on this topic two or three times but there didn't seem
> sufficient interest.
> 
> My idea back then was to use a separate  query which would allow getting
> VF information using a dump request (one VF per message); the reply for
> RTM_GETLINK request would either list all VFs as now if possible or only
> as many as fit into a nested attribute and indicate that the information
> is incomplete (or maybe omit the VF information in such case as
> usefulness of the truncated list is questionable).
> 
> However, my take from the discussions was that most developers who took
> part rather thought that there is no need for such rtnetlink feature as
> there is a devlink interface which does not suffer from this limit and
> NICs with so many VFs that IFLA_VFINFO_LIST exceeds 65535 bytes can
> provide devlink interface to handle them.

Indeed, that's still my position. AFAICT the options of "fixing" this
interface are rather limited and we don't want to perpetuate the
legacy-ndo-based method of configuring VFs - so reimplementation is
not appealing..

One way of working around the 64k limit we discussed with Edwin was
filtering attributes, effectively doing two dumps each with different
filtering flags, so that each one fits (e.g. dropping stats in one and
MAC addresses in the other).

> In any case, while the idea of handling the malformed messages composed
> by existing kernels makes sense, we should IMHO consider this a kernel
> bug which should be fixed so that kernel does not reply with malformed
> netlink messages (independently of whether this patch is applied to
> iproute2 or not).

I wonder. There is something inherently risky about making
a precedent for user space depending on invalid kernel output.

_If_ we want to fix the kernel, IMO we should only fix the kernel.
