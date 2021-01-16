Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15D2F8F62
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 22:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbhAPVNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 16:13:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:35630 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbhAPVNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 16:13:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE75BAC4F;
        Sat, 16 Jan 2021 21:12:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 52B6E60797; Sat, 16 Jan 2021 22:12:23 +0100 (CET)
Date:   Sat, 16 Jan 2021 22:12:23 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
Message-ID: <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
 <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:53:25PM -0800, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 14:59:50 -0800 Edwin Peer wrote:
> > The maximum possible length of an RTNL attribute is 64KB, but the
> > nested VFINFO list exceeds this for more than about 220 VFs (each VF
> > consumes approximately 300 bytes, depending on alignment and optional
> > fields). Exceeding the limit causes IFLA_VFINFO_LIST's length to wrap
> > modulo 16 bits in the kernel's nla_nest_end().
> 
> Let's add Michal to CC, my faulty memory tells me he was fighting with
> this in the past.

I've been looking into this some time ago and even tried to open
a discussion on this topic two or three times but there didn't seem
sufficient interest.

My idea back then was to use a separate  query which would allow getting
VF information using a dump request (one VF per message); the reply for
RTM_GETLINK request would either list all VFs as now if possible or only
as many as fit into a nested attribute and indicate that the information
is incomplete (or maybe omit the VF information in such case as
usefulness of the truncated list is questionable).

However, my take from the discussions was that most developers who took
part rather thought that there is no need for such rtnetlink feature as
there is a devlink interface which does not suffer from this limit and
NICs with so many VFs that IFLA_VFINFO_LIST exceeds 65535 bytes can
provide devlink interface to handle them.

In any case, while the idea of handling the malformed messages composed
by existing kernels makes sense, we should IMHO consider this a kernel
bug which should be fixed so that kernel does not reply with malformed
netlink messages (independently of whether this patch is applied to
iproute2 or not).

Michal
