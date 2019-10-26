Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E560E580A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfJZCUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:20:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfJZCUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 22:20:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DBAD314B79F99;
        Fri, 25 Oct 2019 19:20:45 -0700 (PDT)
Date:   Fri, 25 Oct 2019 19:20:45 -0700 (PDT)
Message-Id: <20191025.192045.1462505833001638832.davem@davemloft.net>
To:     vincent.prince.fr@gmail.com
Cc:     mkl@pengutronix.de, dave.taht@gmail.com, jhs@mojatatu.com,
        jiri@resnulli.us, kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH v5] net: sch_generic: Use pfifo_fast as fallback
 scheduler for CAN hardware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571838260-19186-1-git-send-email-vincent.prince.fr@gmail.com>
References: <20190327165632.10711-1-mkl@pengutronix.de>
        <1571838260-19186-1-git-send-email-vincent.prince.fr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 19:20:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Prince <vincent.prince.fr@gmail.com>
Date: Wed, 23 Oct 2019 15:44:20 +0200

> There is networking hardware that isn't based on Ethernet for layers 1 and 2.
> 
> For example CAN.
> 
> CAN is a multi-master serial bus standard for connecting Electronic Control
> Units [ECUs] also known as nodes. A frame on the CAN bus carries up to 8 bytes
> of payload. Frame corruption is detected by a CRC. However frame loss due to
> corruption is possible, but a quite unusual phenomenon.
> 
> While fq_codel works great for TCP/IP, it doesn't for CAN. There are a lot of
> legacy protocols on top of CAN, which are not build with flow control or high
> CAN frame drop rates in mind.
> 
> When using fq_codel, as soon as the queue reaches a certain delay based length,
> skbs from the head of the queue are silently dropped. Silently meaning that the
> user space using a send() or similar syscall doesn't get an error. However
> TCP's flow control algorithm will detect dropped packages and adjust the
> bandwidth accordingly.
> 
> When using fq_codel and sending raw frames over CAN, which is the common use
> case, the user space thinks the package has been sent without problems, because
> send() returned without an error. pfifo_fast will drop skbs, if the queue
> length exceeds the maximum. But with this scheduler the skbs at the tail are
> dropped, an error (-ENOBUFS) is propagated to user space. So that the user
> space can slow down the package generation.
> 
> On distributions, where fq_codel is made default via CONFIG_DEFAULT_NET_SCH
> during compile time, or set default during runtime with sysctl
> net.core.default_qdisc (see [1]), we get a bad user experience. In my test case
> with pfifo_fast, I can transfer thousands of million CAN frames without a frame
> drop. On the other hand with fq_codel there is more then one lost CAN frame per
> thousand frames.
> 
> As pointed out fq_codel is not suited for CAN hardware, so this patch changes
> attach_one_default_qdisc() to use pfifo_fast for "ARPHRD_CAN" network devices.
> 
> During transition of a netdev from down to up state the default queuing
> discipline is attached by attach_default_qdiscs() with the help of
> attach_one_default_qdisc(). This patch modifies attach_one_default_qdisc() to
> attach the pfifo_fast (pfifo_fast_ops) if the network device type is
> "ARPHRD_CAN".
> 
> [1] https://github.com/systemd/systemd/issues/9194
> 
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
> Acked-by: Dave Taht <dave.taht@gmail.com>

Applied to net-next.
