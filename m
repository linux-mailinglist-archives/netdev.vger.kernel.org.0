Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E193357994
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF0CiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:38:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF0CiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:38:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D20D314DE8713;
        Wed, 26 Jun 2019 19:38:22 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:38:22 -0700 (PDT)
Message-Id: <20190626.193822.1775075982713010832.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     netdev@vger.kernel.org, mcroce@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v4 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625215749.22840-1-nhorman@tuxdriver.com>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
        <20190625215749.22840-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 19:38:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 25 Jun 2019 17:57:49 -0400

> When an application is run that:
> a) Sets its scheduler to be SCHED_FIFO
> and
> b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> MSG_DONTWAIT flag cleared, its possible for the application to hang
> forever in the kernel.  This occurs because when waiting, the code in
> tpacket_snd calls schedule, which under normal circumstances allows
> other tasks to run, including ksoftirqd, which in some cases is
> responsible for freeing the transmitted skb (which in AF_PACKET calls a
> destructor that flips the status bit of the transmitted frame back to
> available, allowing the transmitting task to complete).
> 
> However, when the calling application is SCHED_FIFO, its priority is
> such that the schedule call immediately places the task back on the cpu,
> preventing ksoftirqd from freeing the skb, which in turn prevents the
> transmitting task from detecting that the transmission is complete.
> 
> We can fix this by converting the schedule call to a completion
> mechanism.  By using a completion queue, we force the calling task, when
> it detects there are no more frames to send, to schedule itself off the
> cpu until such time as the last transmitted skb is freed, allowing
> forward progress to be made.
> 
> Tested by myself and the reporter, with good results
> 
> Appies to the net tree
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Matteo Croce <mcroce@redhat.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 ...

Applied and queued up for -stable.
