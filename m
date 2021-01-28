Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8230686E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhA1ANt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhA1ANU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F40A64DCE;
        Thu, 28 Jan 2021 00:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611792759;
        bh=Ch04IrTsXiJfcg5gOJZ6sVCk2XLo2pICGT/oH/mUx5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eU6IeJ1rLR0LuJD/E99PQObEG05yjMOlXoGVdrc7dtxq+rINAMfnR84dV7w4IyKQY
         xihSSxA/5p0eVKrMjJjm00+3gmY9+aqPd/WfC7zr/bH8bda/aB6M50lc+O9rcIMUVg
         NRnYnb6CGkcsx+HvkFUuEieODaC7S3j4lUfofZhaB3iaeqKpUmyM77d6pKu+7sbey1
         kGsWodLaBiT5nlMXLt1bGkMHOAWOGO0zGbWhGygWFquweQsVYdHLhiyQVf5x+BMVtU
         DQBJrtztGf+yqYlmfAjCh0ynl/rln+rvvW7DYHhGnGLApn3KaVHtXopHVdiFjImSdk
         jui+Sx9bculpQ==
Date:   Wed, 27 Jan 2021 16:12:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next v8 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20210127161238.123840ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126011109.2425966-3-weiwan@google.com>
References: <20210126011109.2425966-1-weiwan@google.com>
        <20210126011109.2425966-3-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 17:11:08 -0800 Wei Wang wrote:
> This patch allows running each napi poll loop inside its own
> kernel thread.
> The kthread is created during netif_napi_add() if dev->threaded
> is set. And threaded mode is enabled in napi_enable(). We will
> provide a way to set dev->threaded and enable threaded mode
> without a device up/down in the following patch.
> 
> Once that threaded mode is enabled and the kthread is
> started, napi_schedule() will wake-up such thread instead
> of scheduling the softirq.
> 
> The threaded poll loop behaves quite likely the net_rx_action,
> but it does not have to manipulate local irqs and uses
> an explicit scheduling point based on netdev_budget.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>

include/linux/netdevice.h:2150: warning: Function parameter or member 'threaded' not described in 'net_device'


scripts/kernel-doc -none $files

is your friend - W=1 does not check headers.
