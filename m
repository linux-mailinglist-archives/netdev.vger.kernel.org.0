Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3042CCB07
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgLCAeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLCAeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 19:34:23 -0500
Date:   Wed, 2 Dec 2020 16:33:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606955622;
        bh=BNuSiikvwMMRU9B8Ceoq9RG/zEEc+C+s80EIkuxsoZY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=a1ZlYCh2KksMH85FDo5JiZws6Lg5yAb2xvLhe8aRjguW4VoinP8KAO3lXjjfraSNX
         y9IhZt1bSmcYim7dytr4RBtQd9LY2ZRVMg1cdN81jUMkGAcVohWaiK1Dfq8rXbobfM
         j6Gq0qKGAFRy110D8UbVYen3sWVE1KF+58tZpjLNGzsCE989+PStiJ/8PsFq+4uRyK
         OewYfPRnDFNwCC3WmuOe67b0epQgTAkj84yD4rquAaUBUkPygGDyVybtjwlJXC3Kdm
         TBAcknunoTFh3CbuqG8anNWs37HOJl9iqn8PauNB5XljcK0qD0iBDZM0CwlaQJjdFj
         Juf/zTAoNrNHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: Re: [PATCH net-next v2] ibmvnic: process HMC disable command
Message-ID: <20201202163340.33da3a42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <270f309212915ad2b4a0513222039f20@imap.linux.ibm.com>
References: <20201123235841.6515-1-drt@linux.ibm.com>
        <20201125130855.7eb08d0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a0d2426ed35a02e14882bd1ce51e4e8e@imap.linux.ibm.com>
        <75f4529be5cfab14ec2b0decf47dcd86@imap.linux.ibm.com>
        <b4177b1aa6eaaab4a77f96fb272714cb@imap.linux.ibm.com>
        <270f309212915ad2b4a0513222039f20@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 15:50:58 -0800 Dany Madden wrote:
> On 2020-12-02 12:02, drt wrote:
> > On 2020-11-30 10:19, drt wrote:  
> >> On 2020-11-25 15:55, drt wrote:  
> >>> On 2020-11-25 13:08, Jakub Kicinski wrote:  
> >>>> On Mon, 23 Nov 2020 18:58:41 -0500 Dany Madden wrote:  
> >>>>> Currently ibmvnic does not support the "Disable vNIC" command from
> >>>>> the Hardware Management Console. The HMC uses this command to 
> >>>>> disconnect
> >>>>> the adapter from the network if the adapter is misbehaving or 
> >>>>> sending
> >>>>> malicious traffic. The effect of this command is equivalent to 
> >>>>> setting
> >>>>> the link to the "down" state on the linux client.
> >>>>> 
> >>>>> Enable support in ibmvnic driver for the Disable vNIC command.
> >>>>> 
> >>>>> Signed-off-by: Dany Madden <drt@linux.ibm.com>  
> >>>> 
> >>>> It seems that (a) user looking at the system where NIC was disabled 
> >>>> has
> >>>> no idea why netdev is not working even tho it's UP, and (b) AFAICT
> >>>> nothing prevents the user from bringing the device down and back up
> >>>> again.  
> >>> 
> >>> User would see the interface as DOWN. ibmvnic_close() requests the
> >>> vnicserver to do a link down. The vnicserver responds with a link
> >>> state indication CRQ message with logical link down, client would 
> >>> then
> >>> do netif_carrier_off().
> >>> 
> >>> You are correct, nothing is preventing the user from bringing the
> >>> device back online.
> >>>   
> >>>> 
> >>>> You said this is to disable misbehaving and/or sending malicious 
> >>>> vnic,
> >>>> obviously the guest can ignore the command so it's not very 
> >>>> dependable,
> >>>> anyway.  
> >>> 
> >>> Without this patch, ibmvnic would ignore the command. With this 
> >>> patch,
> >>> it will handle the disable command from the HMC. If the guest insists
> >>> on being bad, the HMC does have the ability to remove vnic adapter
> >>> from the guest.
> >>>   
> >>>> 
> >>>> Would it not be sufficient to mark the carrier state as down to cut 
> >>>> the
> >>>> vnic off?  
> >>> Essentially, this is what ibmvnic_disable does.  
> >> 
> >> Hello Jakub, did I address your concern? If not, please let me know.  
> > 
> > Hello Jakub,
> > 
> > I am pulling this patch. Suka pointed out that rwi lock is not being
> > held when it walks the rwi_list, also the reset bit is incorrectly
> > checked. We will send a v3.
> > 
> > Apologize for any inconvenient.  
> 
> It appears that my email is not showing up in the mailing archive 
> because of email aliases. I hope this is going thru.
> 
> Please do not commit this patch.

FWIW you can check the status of active patches in patchwork:

https://patchwork.kernel.org/project/netdevbpf/list/

This one has already been made inactive so it won't be applied in its
current form.
