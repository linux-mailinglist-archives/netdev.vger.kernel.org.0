Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5753B39D983
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhFGKXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:23:12 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:45678 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhFGKXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 06:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1623061276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KioGibBoPTgURi+nNw0lrmRpBYY/hFk/apnT1dhLqhM=;
        b=VDyzC34gXIn/tTkF613iVoW2HVRVJKysFmTGAUaZeD2pzuz4ZsIcGsFzfAQLeRz6Ll3M/m
        bv5qtIOi8rRykDm1EJGGTRvSC0GmMAio83X1ye05npoHfHpubgGFqbqIRapkn/g8eaqBj+
        0UrPNAbOS3E3ey2uPoY7j+lOLP/IcDY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ab50dd02 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 7 Jun 2021 10:21:16 +0000 (UTC)
Date:   Mon, 7 Jun 2021 12:21:12 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     SyzScope <syzscope@gmail.com>
Cc:     syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL3zGGMRwmD7fNK+@zx2c4.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi SyzScope,

On Fri, May 28, 2021 at 02:12:01PM -0700, SyzScope wrote:
 
> The bug was reported by syzbot first in Aug 2020. Since it remains 
> unpatched to this date, we have conducted some analysis to determine its 
> security impact and root causes, which hopefully can help with the 
> patching decisions.
> Specifically, we find that even though it is labeled as "UAF read" by 
> syzbot, it can in fact lead to double free and control flow hijacking as 
> well. Here is our analysis below (on this kernel version: 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)
> 
> ----------------------------- Root cause analysis: 
> --------------------------
> The use-after-free bug happened because the object has two different 
> references. But when it was freed, only one reference was removed, 
> allowing the other reference to be used incorrectly.
> [...]

Thank you very much for your detailed analysis. I think this is very
valuable work, and I appreciate you doing it. I wanted to jump in to
this thread here so as not to discourage you, following Greg's hasty
dismissal. The bad arguments made I've seen have been something like:

- Who cares about the impact? Bugs are bugs and these should be fixed
  regardless. Severity ratings are a waste of time.
- Spend your time writing patches, not writing tools to discover
  security issues.
- This doesn't help my interns.
- "research project" scare quotes.

I think this entire set of argumentation is entirely bogus, and I really
hope it doesn't dissuade you from continuing to conduct useful research
on the kernel.

Specifically, it sounds like your tool is scanning through syzbot
reports, loading them into a symbolic execution engine, and seeing what
other primitives you can finesse out of the bugs, all in an automated
way. So, in the end, a developer gets a report that, rather than just
saying "4 byte out of bounds read into all zeroed memory so not a big
deal anyway even if it should be fixed," the developer gets a report
that says, "4 byte out of bounds read, or a UaF if approached in this
other way." Knowing that seems like very useful information, not just
for prioritization, but also for the urgency at which patches might be
deployed. For example, that's a meaningful distinction were that kind of
bug found in core networking stack or in wifi or ethernet drivers. I
also think it's great that you're pushing forward the field of automated
vulnerability discovery and exploit writing. Over time, hopefully that
leads to crushing all sorts of classes of bugs. It's also impressive
that you're able to do so much with kernel code in a symbolic execution
environment; this sounds a few steps beyond Angr ;-)...

My one suggestion would be that your email alerts / follow-ups to syzbot
reports, if automated, contain a bit more "dumbed-down" information
about what's happening. Not all kernel developers speak security, and as
you've seen, in some places it might be an uphill battle to have your
contributions taken seriously. On the other hand, it sounds like you
might already be working with Dmitry to integrate this into the
syzkaller infrastructure itself, somehow? If so, that'd be great.

Regards,
Jason
