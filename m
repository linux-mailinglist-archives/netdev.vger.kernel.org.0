Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063751BCE86
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD1VU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726274AbgD1VU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:20:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4DCC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 14:20:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE90B120F52B8;
        Tue, 28 Apr 2020 14:20:58 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:20:57 -0700 (PDT)
Message-Id: <20200428.142057.8792399806987771.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] net: sched: fallback to qdisc noqueue if
 default qdisc setup fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158807197021.1980046.17172496536132159811.stgit@firesoul>
References: <158807197021.1980046.17172496536132159811.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 14:20:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Tue, 28 Apr 2020 13:06:10 +0200

> +	/* Detect default qdisc setup/init failed and fallback to "noqueue" */
> +	if (dev->qdisc == &noop_qdisc) {
> +		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
> +			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
> +		dev->priv_flags |= IFF_NO_QUEUE;

What will ever clear this IFF_NO_QUEUE bit in the future so that another
attempt can be made to attach another qdisc?

An -ENOMEM failure is transient, for example, and shouldn't disable
qdiscs forever on the device.
