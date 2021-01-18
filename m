Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07042FA8E4
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407437AbhARSb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:31:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436897AbhARSa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:30:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 677C7B7C4;
        Mon, 18 Jan 2021 18:30:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B2C79603EF; Mon, 18 Jan 2021 19:30:15 +0100 (CET)
Date:   Mon, 18 Jan 2021 19:30:15 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
Message-ID: <20210118183015.aelwbgfzrsctjek7@lion.mk-sys.cz>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
 <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
 <20210116172119.2c68d4c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <807bb557-6e0c-1567-026c-13becbaff9c2@gmail.com>
 <CAKOOJTyD-et6psSo0v-zvycFpJCLLmdSCr792OQzx_cLM2SjLw@mail.gmail.com>
 <fee064d8-f650-11b8-44b4-55316aec60d3@gmail.com>
 <CAKOOJTwSc6TppMu5+2n5boh7bz8vwAC2d7zpODzn9-ZYJyyTyQ@mail.gmail.com>
 <155ba7e5-2344-f868-73cf-f43169b841a9@gmail.com>
 <CAKOOJTzGei6a0HUbs6wo5sHOwAAVzGLFmMzbJsR8QYpAwyYqfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTzGei6a0HUbs6wo5sHOwAAVzGLFmMzbJsR8QYpAwyYqfA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:20:35AM -0800, Edwin Peer wrote:
> On Mon, Jan 18, 2021 at 9:49 AM David Ahern <dsahern@gmail.com> wrote:
> 
> > Different bug, different solution required. The networking stack hits
> > these kind of scalability problems from time to time with original
> > uapis, so workarounds are needed. One example is rtmsg which only allows
> > 255 routing tables, so RTA_TABLE attribute was added as a u32. Once a
> > solution is found for the VF problem, iproute2 can be enhanced to
> > accommodate.
> 
> The problem is even worse, because user space already depends on the
> broken behavior. Erroring out will cause the whole ip link show
> command to fail, which works today. Even though the VF list is bust,
> the rest of the netdevs are still dumped correctly. A hard fail would
> break those too.

We could cut the list just before overflowing and inform userspace that
the list is incomplete. Not perfect but there is no perfect solution
which would not require userspace changes to work properly for devices
with "too many" VFs.

Michal
