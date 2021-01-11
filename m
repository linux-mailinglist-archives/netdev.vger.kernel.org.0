Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806C82F1FAF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391038AbhAKTnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387724AbhAKTnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B16B922BEF;
        Mon, 11 Jan 2021 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610394190;
        bh=Rj7BwqRZu/wHEnmTfmVtzliqvn/aFd/pt1XBAvp9Mw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WVPCclPqMhZPlOdJqjnq33xOSRIjw/XgyQERFRodqcDxrOvPq9RzknDYApsjhoNxT
         J/hK6M+NeGhNALPhu3LHOCSWFFygQgC6jhuc3ZsrptJm1UAnRLHuu9OkvBLkP0yRCO
         fzrkOnYK5SChmJF8Gw+7iC9Kd9M5ViFqbqgrzLRirQPhd+7VyBwC+qEOI3hdHuwixO
         wwzA+b9NozRCD0rbSg+tCIhq639SywdrAw0F3UPxM2GP+JIVFiBW6AByDVBY6e7kPB
         BlC8x+nm/NXvnUNsbJNLVVYD5FstrYuIVoMORhmfQ3454YMvokXC/9Oz3W+rjX32Wc
         dmey21Od1ZzfQ==
Date:   Mon, 11 Jan 2021 11:43:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 5/7] ibmvnic: use a lock to serialize remove/reset
Message-ID: <20210111114309.6de6a281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111035225.GB165065@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
        <20210108071236.123769-6-sukadev@linux.ibm.com>
        <20210109194146.7c8ac5ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111035225.GB165065@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 19:52:25 -0800 Sukadev Bhattiprolu wrote:
> Jakub Kicinski [kuba@kernel.org] wrote:
> > On Thu,  7 Jan 2021 23:12:34 -0800 Sukadev Bhattiprolu wrote:  
> > > Use a separate lock to serialze ibmvnic_reset() and ibmvnic_remove()
> > > functions. ibmvnic_reset() schedules work for the worker thread and
> > > ibmvnic_remove() flushes the work before removing the adapter. We
> > > don't want any work to be scheduled once we start removing the
> > > adapter (i.e after we have already flushed the work).  
> > 
> > Locking based on functions, not on data being accessed is questionable
> > IMO. If you don't want work to be scheduled isn't it enough to have a
> > bit / flag that you set to let other flows know not to schedule reset?  
> 
> Maybe I could improve the description, but the "data" being protected
> is the work queue. Basically don't add to the work queue while/after
> it is (being) flushed.
> 
> Existing code is checking for the VNIC_REMOVING state before scheduling
> the work but without a lock. If state goes to REMOVING after we check,
> we could schedule work after the flush?

I see, and you can't just use the state_lock because it has to be a
spin_lock? If that's the case please just update the commit message 
and comments to describe the data protected.
