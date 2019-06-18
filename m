Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4834A8E5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfFRRzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:55:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfFRRzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:55:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B00C21510A308;
        Tue, 18 Jun 2019 10:55:48 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:55:48 -0700 (PDT)
Message-Id: <20190618.105548.2200622033433520074.davem@davemloft.net>
To:     lifei.shirley@bytedance.com
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengfeiran@bytedance.com,
        duanxiongchun@bytedance.com
Subject: Re: [PATCH net v2] tun: wake up waitqueues after IFF_UP is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617132636.72496-1-lifei.shirley@bytedance.com>
References: <20190617132636.72496-1-lifei.shirley@bytedance.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:55:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Li <lifei.shirley@bytedance.com>
Date: Mon, 17 Jun 2019 21:26:36 +0800

> Currently after setting tap0 link up, the tun code wakes tx/rx waited
> queues up in tun_net_open() when .ndo_open() is called, however the
> IFF_UP flag has not been set yet. If there's already a wait queue, it
> would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
> Then the saving vhost_poll_start() will add the wq into wqh until it
> is waken up again. Although this works when IFF_UP flag has been set
> when tun_chr_poll detects; this is not true if IFF_UP flag has not
> been set at that time. Sadly the latter case is a fatal error, as
> the wq will never be waken up in future unless later manually
> setting link up on purpose.
> 
> Fix this by moving the wakeup process into the NETDEV_UP event
> notifying process, this makes sure IFF_UP has been set before all
> waited queues been waken up.
> 
> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks.
