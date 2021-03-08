Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7995331563
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHSAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhCHR7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 12:59:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9548652AC;
        Mon,  8 Mar 2021 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615226392;
        bh=qOaD9Moa1INCaKhMmKbllBg09QsRr6h8zKRXogFWREQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKL8W8Ub5/9HNbzIeBuw1XzZ4bLvqgYKWTaVQqol/ISUj51rZjb3vOX8uuu1w4zfR
         QpHODvLLWVQzsuLdYD+/YbBl6RGioQXLdW2z8Pq/8F8AdCQmRK9/ZbkohPiHPlHO/U
         d9fnRo6eUHT/LMXRvdB5JrUk/hkSNz8wa1ILKbsc6bhF98IMJMJ6jdtYi++s8/0hat
         vOMNAJqG+Y7RmrkY6VtMxf3ce45Yj/9NoLJcYGCYnBOafllIdiQDo+uEYd5z8XEeFe
         fBvIoOk3HkvG6qSoCeb5sIU6DEGXz508gnx5f8/j4jqAt364gMKvbrPXCCJw+0sHmm
         3Nz3ewwDRxhmg==
Date:   Mon, 8 Mar 2021 09:59:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <20210308095950.3cede742@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210306024220.251721-1-kuba@kernel.org>
        <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
        <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Mar 2021 09:16:00 -0800 Jakub Kicinski wrote:
> > > +	DLH_REMEDY_BAD_PART,    
> > BAD_PART probably indicates that the reporter (or any command line 
> > execution) cannot recover the issue.
> > As the suggested remedy is static per reporter's recover method, it 
> > doesn't make sense for one to set a recover method that by design cannot 
> > recover successfully.
> > 
> > Maybe we should extend devlink_health_reporter_state with POWER_CYCLE, 
> > REIMAGE and BAD_PART? To indicate the user that for a successful 
> > recovery, it should run a non-devlink-health operation?  
> 
> Hm, export and extend devlink_health_reporter_state? I like that idea.

Trying to type it up it looks less pretty than expected.

Let's looks at some examples.

A queue reporter, say "rx", resets the queue dropping all outstanding
buffers. As previously mentioned when the normal remediation fails user
is expected to power cycle the machine or maybe swap the card. The
device itself does not have a crystal ball.

A management FW reporter "fw", has a auto recovery of FW reset
(REMEDY_RESET). On failure -> power cycle.

An "io" reporter (PCI link had to be trained down) can only return 
a hardware failure (we should probably have a HW failure other than
BAD_PART for this).

Flash reporters - the device will know if the flash had a bad block 
or the entire part is bad, so probably can have 2 reporters for this.

Most of the reporters would only report one "action" that can be
performed to fix them. The cartesian product of ->recovery types vs
manual recovery does not seem necessary. And drivers would get bloated
with additional boilerplate of returning ERROR_NEED_POWER_CYCLE for
_all_ cases with ->recovery. Because what else would the fix be if
software-initiated reset didn't work?
