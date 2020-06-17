Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A741FD157
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgFQPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 11:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgFQPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 11:54:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD80C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 08:54:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 260DC12964388;
        Wed, 17 Jun 2020 08:54:52 -0700 (PDT)
Date:   Wed, 17 Jun 2020 08:54:48 -0700 (PDT)
Message-Id: <20200617.085448.2300826067257423419.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org, jmaloy@redhat.com,
        maloy@donjonn.com, lkp@intel.com
Subject: Re: [net-next v2] tipc: update a binding service via broadcast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200617065605.8800-1-hoang.h.le@dektech.com.au>
References: <20200617065605.8800-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 08:54:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Huu Le <hoang.h.le@dektech.com.au>
Date: Wed, 17 Jun 2020 13:56:05 +0700

> Currently, updating binding table (add service binding to
> name table/withdraw a service binding) is being sent over replicast.
> However, if we are scaling up clusters to > 100 nodes/containers this
> method is less affection because of looping through nodes in a cluster one
> by one.
> 
> It is worth to use broadcast to update a binding service. This way, the
> binding table can be updated on all peer nodes in one shot.
> 
> Broadcast is used when all peer nodes, as indicated by a new capability
> flag TIPC_NAMED_BCAST, support reception of this message type.
> 
> Four problems need to be considered when introducing this feature.
> 1) When establishing a link to a new peer node we still update this by a
> unicast 'bulk' update. This may lead to race conditions, where a later
> broadcast publication/withdrawal bypass the 'bulk', resulting in
> disordered publications, or even that a withdrawal may arrive before the
> corresponding publication. We solve this by adding an 'is_last_bulk' bit
> in the last bulk messages so that it can be distinguished from all other
> messages. Only when this message has arrived do we open up for reception
> of broadcast publications/withdrawals.
> 
> 2) When a first legacy node is added to the cluster all distribution
> will switch over to use the legacy 'replicast' method, while the
> opposite happens when the last legacy node leaves the cluster. This
> entails another risk of message disordering that has to be handled. We
> solve this by adding a sequence number to the broadcast/replicast
> messages, so that disordering can be discovered and corrected. Note
> however that we don't need to consider potential message loss or
> duplication at this protocol level.
> 
> 3) Bulk messages don't contain any sequence numbers, and will always
> arrive in order. Hence we must exempt those from the sequence number
> control and deliver them unconditionally. We solve this by adding a new
> 'is_bulk' bit in those messages so that they can be recognized.
> 
> 4) Legacy messages, which don't contain any new bits or sequence
> numbers, but neither can arrive out of order, also need to be exempt
> from the initial synchronization and sequence number check, and
> delivered unconditionally. Therefore, we add another 'is_not_legacy' bit
> to all new messages so that those can be distinguished from legacy
> messages and the latter delivered directly.
> 
> v1->v2:
>  - fix warning issue reported by kbuild test robot <lkp@intel.com>
>  - add santiy check to drop the publication message with a sequence
> number that is lower than the agreed synch point
> 
> Signed-off-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> Acked-by: Jon Maloy <jmaloy@redhat.com>

Applied, thank you.
