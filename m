Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F2520EA19
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgF3AQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgF3AQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:16:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA4420780;
        Tue, 30 Jun 2020 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593476174;
        bh=YEvv5diFUttT1gpPIdbEXdjcPTFEm+AiupFO+TUtfH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XPXqq8DUdenZiS+DwJWNxHyP0PHSj5hz3BKC9AFazNswmFWU7b1djg3mXyCO/Jjy2
         cXWQivbSaTX2pfpK+vBr4skTWvNFQE8h++g5/b0OyHVCUWuBOrDSbWaVQabpOQ7shf
         z6d9vvOY40vIWl5AHdqhZq7XbdUDZ5SF3tXb7iiA=
Date:   Mon, 29 Jun 2020 17:16:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     fruggeri@arista.com (Francesco Ruggeri)
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Message-ID: <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 14:18:01 -0700 Francesco Ruggeri wrote:
> We observed a panic in igb_reset_task caused by this race condition
> when doing a reboot -f:
> 
> 	kworker			reboot -f
> 
> 	igb_reset_task
> 	igb_reinit_locked
> 	igb_down
> 	napi_synchronize
> 				__igb_shutdown
> 				igb_clear_interrupt_scheme
> 				igb_free_q_vectors
> 				igb_free_q_vector
> 				adapter->q_vector[v_idx] = NULL;
> 	napi_disable
> 	Panics trying to access
> 	adapter->q_vector[v_idx].napi_state
> 
> This commit applies to igb the same changes that were applied to ixgbe
> in commit 8f4c5c9fb87a ("ixgbe: reinit_locked() should be called with
> rtnl_lock") and commit 88adce4ea8f9 ("ixgbe: fix possible race in
> reset subtask").
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

Thanks for the patch..

Would you mind adding a fixes tag here? Probably:

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")

And as a matter of fact it looks like e1000e and e1000 have the same
bug :/ Would you mind checking all Intel driver producing matches for
all the affected ones?
