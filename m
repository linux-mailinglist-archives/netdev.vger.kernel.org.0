Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1840B099
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhINO1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhINO1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A6261056;
        Tue, 14 Sep 2021 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631629591;
        bh=ZjqNuRgelgffkhgTf9Bhjog74AWahWDRX3CE5QoyfSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mXe4Uub32OYY6DPacl2YyYZlEtqUi5aPijhgob1qOYWMs7nYWuw9hVaL2wf9sbLvF
         Qf/3xhIHL3p8oJmo3xXpxZYEVLPuSqbk1DByjqJR2RHXiO5QGi4/+S4eyAYp6EiIob
         cnISEcN4a32nsNcugA/2sEoihCMyoMUlcQDVOROKskR0wZrlFpjfzufVJaISgblkKd
         U6TsIMzjNtSXUDtLCPyKJSnlPN5wgnN+hDv9fc50S2NDYlQymUhH8hk9y3RsB3qohb
         x3V/NRxf6xF/RPlCU8Y2nvfhf2+fSALPcYzSKtJta4qK4HrKrVtlzcUe2x6JgQxdJf
         I6+XukR3go7lA==
Date:   Tue, 14 Sep 2021 07:26:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <john.hurley@netronome.com>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Questioning requirement for ASSERT_RTNL in indirect code
Message-ID: <20210914072629.3d486b6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
References: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 09:05:00 +0300 Eli Cohen wrote:
> I see the same assert and the same comment, "All callback list access
> should be protected by RTNL.", in the following locations
> 
> drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:1873
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:303
> drivers/net/ethernet/netronome/nfp/flower/offload.c:1770
> 
> I assume the source of this comment is the same. Can you guys explain
> why is this necessary?

Because most drivers (all but mlx5?) depend on rtnl_lock for
serializing tc offload operations.

> Currently, with
> 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation"
> 
> the assert will emit a warning into dmesg with no other noticable
> effect. I am thinking maybe we need to remove this assert.
> 
> Comments?

rtnl_lock must be held unless unlocked_driver_cb is set.
