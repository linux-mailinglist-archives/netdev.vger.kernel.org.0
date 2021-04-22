Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17283685C8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhDVRWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:22:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:42600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhDVRWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:22:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 515C4B1A4;
        Thu, 22 Apr 2021 17:21:38 +0000 (UTC)
Date:   Thu, 22 Apr 2021 19:21:36 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        netdev@vger.kernel.org, Lijun Pan <ljp@linux.vnet.ibm.com>,
        Tom Falcon <tlfalcon@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
Message-ID: <20210422172135.GY6564@kitsune.suse.cz>
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <20210421064527.GA2648262@us.ibm.com>
 <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Apr 22, 2021 at 12:06:45AM -0500, Lijun Pan wrote:
> On Wed, Apr 21, 2021 at 2:25 AM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
> > >
> > >
> > > > On Apr 20, 2021, at 4:35 PM, Dany Madden <drt@linux.ibm.com> wrote:
> > > >
> > > > When ibmvnic gets a FATAL error message from the vnicserver, it marks
> > > > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> > > > FATAL reset fails and a transmission timeout reset follows, the CRQ is
> > > > still inactive, ibmvnic's attempt to set link down will also fail. If
> > > > ibmvnic abandons the reset because of this failed set link down and this
> > > > is the last reset in the workqueue, then this adapter will be left in an
> > > > inoperable state.
> > > >
> > > > Instead, make the driver ignore this link down failure and continue to
> > > > free and re-register CRQ so that the adapter has an opportunity to
> > > > recover.
> > >
> > > This v2 does not adddress the concerns mentioned in v1.
> > > And I think it is better to exit with error from do_reset, and schedule a thorough
> > > do_hard_reset if the the adapter is already in unstable state.
> >
> > We had a FATAL error and when handling it, we failed to send a
> > link-down message to the VIOS. So what we need to try next is to
> > reset the connection with the VIOS. For this we must talk to the
> > firmware using the H_FREE_CRQ and H_REG_CRQ hcalls. do_reset()
> > does just that in ibmvnic_reset_crq().
> >
> > Now, sure we can attempt a "thorough hard reset" which also does
> > the same hcalls to reestablish the connection. Is there any
> > other magic in do_hard_reset()? But in addition, it also frees lot
> > more Linux kernel buffers and reallocates them for instance.
> 
> Working around everything in do_reset will make the code very difficult
> to manage. Ultimately do_reset can do anything I am afraid, and do_hard_reset
> can be removed completely or merged into do_reset.

This debate is not very constructive.

In the context of driver that has separate do_reset and do_hard_reset
this fix picks the correct one unless you can refute the arguments
provided.

Merging do_reset and do_hard_reset might be a good code cleanup which is
out of the scope of this fix.



Given that vast majority of fixes to the vnic driver are related to the
reset handling it would improve stability and testability if every
reset took the same code path.

In the context of merging do_hard_reset and do_reset the question is
what is the intended distinction and performance gain by having
'lightweight' reset.

I don't have a vnic protocol manual at hand and I suspect I would not
get one even if I searched for one.

From reading through the fixes in the past my understanding is that the
full reset is required when the backend changes which then potentially
requires different size/number of buffers.

What is the expected situation when reset is required without changing
the backend?

Is this so common that it warrants a separate 'lightweight' optimized
function?

Thanks

Michal
