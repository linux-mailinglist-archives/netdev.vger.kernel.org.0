Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD6B5C301
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfGAS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:27:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfGAS1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:27:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7CAA14C7ABB9;
        Mon,  1 Jul 2019 11:27:51 -0700 (PDT)
Date:   Mon, 01 Jul 2019 11:27:51 -0700 (PDT)
Message-Id: <20190701.112751.509316780582361121.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net/rds: Give fr_state a chance to
 transition to FRMR_IS_FREE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
References: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 11:27:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Mon, 1 Jul 2019 09:39:44 -0700

> +			/* Memory regions make it onto the "clean_list" via
> +			 * "rds_ib_flush_mr_pool", after the memory region has
> +			 * been posted for invalidation via "rds_ib_post_inv".
> +			 *
> +			 * At that point in time, "fr_state" may still be
> +			 * in state "FRMR_IS_INUSE", since the only place where
> +			 * "fr_state" transitions to "FRMR_IS_FREE" is in
> +			 * is in "rds_ib_mr_cqe_handler", which is
> +			 * triggered by a tasklet.
> +			 *
> +			 * So in case we notice that
> +			 * "fr_state != FRMR_IS_FREE" (see below), * we wait for
> +			 * "fr_inv_done" to trigger with a maximum of 10msec.
> +			 * Then we check again, and only put the memory region
> +			 * onto the drop_list (via "rds_ib_free_frmr")
> +			 * in case the situation remains unchanged.
> +			 *
> +			 * This avoids the problem of memory-regions bouncing
> +			 * between "clean_list" and "drop_list" before they
> +			 * even have a chance to be properly invalidated.
> +			 */
> +			frmr = &ibmr->u.frmr;
> +			wait_event_timeout(frmr->fr_inv_done,
> +					   frmr->fr_state == FRMR_IS_FREE,
> +					   msecs_to_jiffies(10));
> +			if (frmr->fr_state == FRMR_IS_FREE)
> +				break;

If we see FRMR_IS_FREE after the timeout, what cleans this up?

Also, why 10msec?  Why that specific value and not some other value?  Why
not wait for however long it takes for the tasklet to run and clean it up?
