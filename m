Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFABD3FD163
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbhIACgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241128AbhIACgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 22:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E253060FE6;
        Wed,  1 Sep 2021 02:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630463724;
        bh=A9CIKTTo3fDD2pTFK9SNRvm3W4vqdwZ1+KiRth/yruI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXGK9uIv1VfzqKfuI0+TX6NH6UF3lIenvdlL4b5eUh70uOrftc3jVOxz9DU0ptQ21
         khBW1Ert2eveJIY9K5Nw1JJLyh0Xt1ORlZUBlzb3cqkeSoZSBlJmTzpEF6xzQ+7Cq9
         C0gEaFu5a8JeYmqmZbCG1uf9qH54OuMttTFQoycfuNX03amQe+wUZ3VrCVW7ZIM8an
         eLo/S9j5ZMi3P/G5ZvmblXIDgWacr7b7YunsHTTo1nRVr9U0Ri3tyhuY1mPoVfAysY
         BMqWTC9E5O0qhs891Q7GN1N9bwg85/GMt4MVHsT3GuRzzKIe+eTDlBwKREAUiMoahB
         P53y2W64cUe1A==
Date:   Tue, 31 Aug 2021 19:35:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 0/9] ibmvnic: Reuse ltb, rx, tx pools
Message-ID: <20210831193523.3929a265@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 17:08:03 -0700 Sukadev Bhattiprolu wrote:
> It can take a long time to free and reallocate rx and tx pools and long
> term buffer (LTB) during each reset of the VNIC. This is specially true
> when the partition (LPAR) is heavily loaded and going through a Logical
> Partition Migration (LPM). The long drawn reset causes the LPAR to lose
> connectivity for extended periods of time and results in "RMC connection"
> errors and the LPM failing.
> 
> What is worse is that during the LPM we could get a failover because
> of the lost connectivity. At that point, the vnic driver releases
> even the resources it has already allocated and starts over.
> 
> As long as the resources we have already allocated are valid/applicable,
> we might as well hold on to them while trying to allocate the remaining
> resources. This patch set attempts to reuse the resources previously
> allocated as long as they are valid. It seems to vastly improve the
> time taken for the vnic reset. We have also not seen any RMC connection
> issues during our testing with this patch set.
> 
> If the backing devices for a vnic adapter are not "matched" (see "pool
> parameters" in patches 8 and 9) it is possible that we will still free
> all the resources and allocate them. If that becomes a common problem,
> we have to address it separately.
> 
> Thanks to input and extensive testing from Brian King, Cris Forno,
> Dany Madden, Rick Lindsley.

Please fix the kdoc issues in this submission. Kdoc script is your
friend:

./scripts/kernel-doc -none <files>

