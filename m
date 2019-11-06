Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8EDF0BFB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbfKFCTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:19:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730692AbfKFCTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:19:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A63D715104561;
        Tue,  5 Nov 2019 18:19:02 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:19:02 -0800 (PST)
Message-Id: <20191105.181902.1732028417429752629.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: qualcomm: rmnet: Fix potential UAF when
 unregistering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572915262-19149-1-git-send-email-stranche@codeaurora.org>
References: <1572915262-19149-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:19:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Mon,  4 Nov 2019 17:54:22 -0700

> During the exit/unregistration process of the RmNet driver, the function
> rmnet_unregister_real_device() is called to handle freeing the driver's
> internal state and removing the RX handler on the underlying physical
> device. However, the order of operations this function performs is wrong
> and can lead to a use after free of the rmnet_port structure.
> 
> Before calling netdev_rx_handler_unregister(), this port structure is
> freed with kfree(). If packets are received on any RmNet devices before
> synchronize_net() completes, they will attempt to use this already-freed
> port structure when processing the packet. As such, before cleaning up any
> other internal state, the RX handler must be unregistered in order to
> guarantee that no further packets will arrive on the device.
> 
> Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>

Applied and queued up for -stable, thanks.
