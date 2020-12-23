Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3439D2E1506
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgLWCrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:47:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730960AbgLWCq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4B7225AC;
        Wed, 23 Dec 2020 02:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691577;
        bh=fwl/zGdy/F41clowIZcduV9ITHzuom7p0Cs0+cLYeoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2cfukww6oGD7vILcxKaGODJvhgjuVxLuW2EJuv1ZuG/VY7wfk97wZue34HuodzJV
         B9QZ1BqLXqhxb6Vc+VrvdsHCegL/oNs8IzzSM7FUEry1TjWKx6xzexvyWYScHamyAD
         3NEfgSPmkVeM902ZUs01Thp5VxC8xFH9a49I9j7aEOYEu6Tt3NB3HVRZvRE+1avys9
         b6EQyW6VWmMBEKIFNDMw0oaXOzIQufBmGePJbxE+XCVl+lr9SFFTnDB8iZiCU1HB5c
         3mv3JTdO7AJvRBnzuT1SkM3h7sZBVXt9iu9EJ11U2rZPYSfL0UO/ifGjl5toYgfwkG
         VV3NX4plCuo2g==
Date:   Tue, 22 Dec 2020 18:46:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: continue fatal error reset after passive
 init
Message-ID: <20201222184615.13ba9cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201219214034.21123-1-ljp@linux.ibm.com>
References: <20201219214034.21123-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Dec 2020 15:40:34 -0600 Lijun Pan wrote:
> Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
> says "If the passive
> CRQ initialization occurs before the FATAL reset task is processed,
> the FATAL error reset task would try to access a CRQ message queue
> that was freed, causing an oops. The problem may be most likely to
> occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
> process will automatically issue a change MTU request.
> Fix this by not processing fatal error reset if CRQ is passively
> initialized after client-driven CRQ initialization fails."
> 
> Even with this commit, we still see similar kernel crashes. In order
> to completely solve this problem, we'd better continue the fatal error
> reset, capture the kernel crash, and try to fix it from that end.

This basically reverts the quoted fix. Does the quoted fix make things
worse? Otherwise we should leave the code be until proper fix is found.
