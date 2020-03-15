Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73295185B06
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgCOHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:25:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgCOHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:25:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FB2813EA9468;
        Sun, 15 Mar 2020 00:25:14 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:25:13 -0700 (PDT)
Message-Id: <20200315.002513.2013860756126327349.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, jrosen@cisco.com, willemb@google.com
Subject: Re: [PATCH net] net/packet: tpacket_rcv: avoid a producer race
 condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313161809.142676-1-willemdebruijn.kernel@gmail.com>
References: <20200313161809.142676-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:25:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 13 Mar 2020 12:18:09 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> PACKET_RX_RING can cause multiple writers to access the same slot if a
> fast writer wraps the ring while a slow writer is still copying. This
> is particularly likely with few, large, slots (e.g., GSO packets).
> 
> Synchronize kernel thread ownership of rx ring slots with a bitmap.
> 
> Writers acquire a slot race-free by testing tp_status TP_STATUS_KERNEL
> while holding the sk receive queue lock. They release this lock before
> copying and set tp_status to TP_STATUS_USER to release to userspace
> when done. During copying, another writer may take the lock, also see
> TP_STATUS_KERNEL, and start writing to the same slot.
> 
> Introduce a new rx_owner_map bitmap with a bit per slot. To acquire a
> slot, test and set with the lock held. To release race-free, update
> tp_status and owner bit as a transaction, so take the lock again.
> 
> This is the one of a variety of discussed options (see Link below):
> 
> * instead of a shadow ring, embed the data in the slot itself, such as
> in tp_padding. But any test for this field may match a value left by
> userspace, causing deadlock.
> 
> * avoid the lock on release. This leaves a small race if releasing the
> shadow slot before setting TP_STATUS_USER. The below reproducer showed
> that this race is not academic. If releasing the slot after tp_status,
> the race is more subtle. See the first link for details.
> 
> * add a new tp_status TP_KERNEL_OWNED to avoid the transactional store
> of two fields. But, legacy applications may interpret all non-zero
> tp_status as owned by the user. As libpcap does. So this is possible
> only opt-in by newer processes. It can be added as an optional mode.
> 
> * embed the struct at the tail of pg_vec to avoid extra allocation.
> The implementation proved no less complex than a separate field.
> 
> The additional locking cost on release adds contention, no different
> than scaling on multicore or multiqueue h/w. In practice, below
> reproducer nor small packet tcpdump showed a noticeable change in
> perf report in cycles spent in spinlock. Where contention is
> problematic, packet sockets support mitigation through PACKET_FANOUT.
> And we can consider adding opt-in state TP_KERNEL_OWNED.
> 
> Easy to reproduce by running multiple netperf or similar TCP_STREAM
> flows concurrently with `tcpdump -B 129 -n greater 60000`.
> 
> Based on an earlier patchset by Jon Rosen. See links below.
> 
> I believe this issue goes back to the introduction of tpacket_rcv,
> which predates git history.
> 
> Link: https://www.mail-archive.com/netdev@vger.kernel.org/msg237222.html
> Suggested-by: Jon Rosen <jrosen@cisco.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks everyone.
