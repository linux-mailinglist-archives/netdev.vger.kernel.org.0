Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A846135EE2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbgAIRHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:07:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:49716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731444AbgAIRHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:07:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 56469AE03;
        Thu,  9 Jan 2020 17:07:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1454DE008B; Thu,  9 Jan 2020 18:07:46 +0100 (CET)
Date:   Thu, 9 Jan 2020 18:07:46 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.19 46/84] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20200109170746.GO22387@unicorn.suse.cz>
References: <20191227174352.6264-1-sashal@kernel.org>
 <20191227174352.6264-46-sashal@kernel.org>
 <CA+G9fYv8o4he83kqpxB9asT7eUMAeODyX3MBbmwsCdgqLcXPWw@mail.gmail.com>
 <20200109153226.GG1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109153226.GG1706@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 10:32:26AM -0500, Sasha Levin wrote:
> On Thu, Jan 02, 2020 at 01:31:22PM +0530, Naresh Kamboju wrote:
> > On Fri, 27 Dec 2019 at 23:17, Sasha Levin <sashal@kernel.org> wrote:
> > > 
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > [ Upstream commit 8dbd76e79a16b45b2ccb01d2f2e08dbf64e71e40 ]
> > > 
> > > Michal Kubecek and Firo Yang did a very nice analysis of crashes
> > > happening in __inet_lookup_established().
> > > 
> > > Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
> > > (via a close()/socket()/listen() cycle) without a RCU grace period,
> > > I should not have changed listeners linkage in their hash table.
> > > 
> > > They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
> > > so that a lookup can detect a socket in a hash list was moved in
> > > another one.
> > > 
> > > Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
> > > merge conflict for v4/v6 ordering fix"), we have to add
> > > hlist_nulls_add_tail_rcu() helper.
> > 
> > The kernel panic reported on all devices,
> > While running LTP syscalls accept* test cases on stable-rc-4.19 branch kernel.
> > This report log extracted from qemu_x86_64.
> > 
> > Reverting this patch re-solved kernel crash.
> 
> I'll drop it until we can look into what's happening here, thanks!

It was already discussed here:

  http://lkml.kernel.org/r/CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com

and fixed version should be in 4.19, 4.14 and 4.9 stable branches now.

Michal Kubecek
