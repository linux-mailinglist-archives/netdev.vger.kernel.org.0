Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01A273619
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgIUW6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgIUW6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:58:38 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721432076E;
        Mon, 21 Sep 2020 22:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600729117;
        bh=2xk7Fmz3JjDQIAEPGMqF5VAoFrIcEHgYldDvUP9ihFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wlgl2Qt6SzVzrUnzox+uuaj2db3MfOfg8BnxPS8w3MUlFffW0wNf9oCF9nJMxLgc5
         9+yBxfTqZgFDLxXDuSUxsvMo6KCvA0lRMLvCzymt1weUI4lWxtGKe3BQN1lkYKGZD6
         bH62rL+RtrSyBOGvZvSyCWfiQrIvn8ciNV0EPaYk=
Date:   Tue, 22 Sep 2020 00:58:35 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
Message-ID: <20200921225834.GA30521@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917112359.00006e10@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 11:23:59AM -0700, Jesse Brandeburg wrote:
> Nitesh Narayan Lal wrote:
> 
> > In a realtime environment, it is essential to isolate unwanted IRQs from
> > isolated CPUs to prevent latency overheads. Creating MSIX vectors only
> > based on the online CPUs could lead to a potential issue on an RT setup
> > that has several isolated CPUs but a very few housekeeping CPUs. This is
> > because in these kinds of setups an attempt to move the IRQs to the
> > limited housekeeping CPUs from isolated CPUs might fail due to the per
> > CPU vector limit. This could eventually result in latency spikes because
> > of the IRQ threads that we fail to move from isolated CPUs.
> > 
> > This patch prevents i40e to add vectors only based on available
> > housekeeping CPUs by using num_housekeeping_cpus().
> > 
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> 
> The driver changes are straightforward, but this isn't the only driver
> with this issue, right?  I'm sure ixgbe and ice both have this problem
> too, you should fix them as well, at a minimum, and probably other
> vendors drivers:
> 
> $ rg -c --stats num_online_cpus drivers/net/ethernet
> ...
> 50 files contained matches

Ouch, I was indeed surprised that these MSI vector allocations were done
at the driver level and not at some $SUBSYSTEM level.

The logic is already there in the driver so I wouldn't oppose to this very patch
but would a shared infrastructure make sense for this? Something that would
also handle hotplug operations?

Does it possibly go even beyond networking drivers?

Thanks.

> 
> for this patch i40e
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
