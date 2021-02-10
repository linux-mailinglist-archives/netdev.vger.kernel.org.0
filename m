Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7BC316F49
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhBJSyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:54:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234315AbhBJSwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:52:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C6C64E2E;
        Wed, 10 Feb 2021 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612983106;
        bh=1s5f/R1DM99wGvEfSEbLPf1XcQJ9YeYe/V1zd/Bm/E4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WhuXk47CRaiC4PtXeChhe79xiiWvdWtUMXieYJp6bjV/oBEk/1dXp8OyJYK92SANI
         2PLqw0xsNZkWx5Ek0UQuDrz93wwozj+Dx5cs36BysAw1akXkmfYQ4D3OKYkR8Ra7//
         lowDJmp8Z0VNTFzs6iDv94gHD86uP9YXfjnJlchWybVhOJsicphh15YIcyHhD4LgZM
         U0LZSLbAIAZ094fTrHT8AO52CWfgz6gMLJp+6A/OmD0cWJZ6XdPC90Kdc2Xd2ZpgDo
         YWQPpk9YyqcWP0wswL/4pe6Gvc/JfOv+8mrXxC84KG4K0JrEaMH/wIazG958ZPcCs3
         1ykyGXC/DoY1A==
Date:   Wed, 10 Feb 2021 10:51:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Message-ID: <20210210105145.4d8a4936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
        <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
        <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
        <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 13:53:34 -0800 Jacob Keller wrote:
> On 2/4/2021 11:10 AM, Jacob Keller wrote:
> > I'd rather see the right solution designed here, so if this isn't the
> > right direction I want to work with the list to figure out what makes
> > the most sense. (Even if that's "minimum security should update
> > automatically").
> >  
> I want to clarify here based on feedback I received from customer
> support engineers: We believe it is not acceptable to update this
> automatically, because not all customers want that behavior and would
> prefer to have control over when to lock in the minimum security revision.
> 
> Previous products have behaved this way and we had significant feedback
> when this occurred that many of our customers were unhappy about this,
> even after we explained the reasoning.
> 
> I do not believe that we can accept an automatic/default update of
> minimum security revision.

I spent some time reading through various docs, and my main concern 
now is introduction of an API which does not have any cryptographic
guarantees.

An attacker who has infiltrated the OS but did not manage to crack 
the device yet, can fake the SEV responses and keep the counter from
ever being bumped until they successfully expoit the device. Is the 
min SEV counter included in device measurements?

I'm starting to think that distributing separate FW builds with and
without auto-SEV bump is the best way to fit into the SecBoot infra,
without additional wrinkles and attack vectors.

WDYT?
