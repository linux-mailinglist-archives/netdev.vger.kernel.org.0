Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8121E25C973
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgICTYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbgICTYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:24:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEC6C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 12:24:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30EC115C9E8DC;
        Thu,  3 Sep 2020 12:07:31 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:24:17 -0700 (PDT)
Message-Id: <20200903.122417.2272454389968453378.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, drc@linux.vnet.ibm.com,
        baptiste@arista.com
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
References: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 12:07:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Thu,  3 Sep 2020 14:28:54 -0400

> If tg3_reset_task() fails, the device state is left in an inconsistent
> state with IFF_RUNNING still set but NAPI state not enabled.  A
> subsequent operation, such as ifdown or AER error can cause it to
> soft lock up when it tries to disable NAPI state.
> 
> Fix it by bringing down the device to !IFF_RUNNING state when
> tg3_reset_task() fails.  tg3_reset_task() running from workqueue
> will now call tg3_close() when the reset fails.  We need to
> modify tg3_reset_task_cancel() slightly to avoid tg3_close()
> calling cancel_work_sync() to cancel tg3_reset_task().  Otherwise
> cancel_work_sync() will wait forever for tg3_reset_task() to
> finish.
> 
> Reported-by: David Christensen <drc@linux.vnet.ibm.com>
> Reported-by: Baptiste Covolato <baptiste@arista.com>
> Fixes: db2199737990 ("tg3: Schedule at most one tg3_reset_task run")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied and queued up for -stable, thanks.
