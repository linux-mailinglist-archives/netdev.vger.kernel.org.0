Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35EB20C4F6
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 02:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgF1A0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 20:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgF1A0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 20:26:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FEEC061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 17:26:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2A8A13404AED;
        Sat, 27 Jun 2020 17:26:39 -0700 (PDT)
Date:   Sat, 27 Jun 2020 17:26:37 -0700 (PDT)
Message-Id: <20200627.172637.1883014001052557807.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, subashab@codeaurora.org
Subject: Re: [PATCH net] genetlink: take netlink table lock when
 (un)registering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
References: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jun 2020 17:26:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Fri, 26 Jun 2020 18:31:03 -0600

> @@ -328,6 +325,10 @@ int genl_register_family(struct genl_family *family)
>  	if (err)
>  		return err;
>  
> +	/* Acquire netlink table lock before any GENL-specific locks to ensure
> +	 * sync with any netlink operations making calls into the GENL code.
> +	 */
> +	netlink_table_grab();
>  	genl_lock_all();

This locking sequence is illegal, and if you tested this change with the
proper lock debugging options enabled you wouldn't have been able to
even boot a machine without it OOPS'ing.

This code was essentially not tested as far as I am concerned.

netlink_table_grab() takes an atomic lock (write_lock_irq), so it
creates an atomic section.  But then we immediately call
genl_lock_all() which takes multiple sleepable locks (a semaphore and
a mutex).

You'll have to find another way to fix this bug and I would like to ask
that you do so in a way that keeps all of these code paths sleepable
and does not do any GFP_ATOMIC conversions.

Thank you.
