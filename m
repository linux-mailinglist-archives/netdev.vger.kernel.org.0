Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734EB1F476A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgFITrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgFITrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:47:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84096C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 12:47:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E6C512771EE5;
        Tue,  9 Jun 2020 12:47:10 -0700 (PDT)
Date:   Tue, 09 Jun 2020 12:47:09 -0700 (PDT)
Message-Id: <20200609.124709.1693195732249155694.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] ionic: wait on queue start until after IFF_UP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609034143.7668-1-snelson@pensando.io>
References: <20200609034143.7668-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 12:47:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon,  8 Jun 2020 20:41:43 -0700

> The netif_running() test looks at __LINK_STATE_START which
> gets set before ndo_open() is called, there is a window of
> time between that and when the queues are actually ready to
> be run.  If ionic_check_link_status() notices that the link is
> up very soon after netif_running() becomes true, it might try
> to run the queues before they are ready, causing all manner of
> potential issues.  Since the netdev->flags IFF_UP isn't set
> until after ndo_open() returns, we can wait for that before
> we allow ionic_check_link_status() to start the queues.
> 
> On the way back to close, __LINK_STATE_START is cleared before
> calling ndo_stop(), and IFF_UP is cleared after.  Both of
> these need to be true in order to safely stop the queues
> from ionic_check_link_status().
> 
> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

What will make sure the queues actually get started if this
event's queue start gets skipped in this scenerio?

This code is only invoked when the link status changes or
when the firmware is started.
