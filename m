Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DF22D3CC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 04:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgGYCoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 22:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGYCoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 22:44:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144C2C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 19:44:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F7E71277892C;
        Fri, 24 Jul 2020 19:27:34 -0700 (PDT)
Date:   Fri, 24 Jul 2020 19:44:17 -0700 (PDT)
Message-Id: <20200724.194417.2151242753657227232.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] ionic: recover from ringsize change
 failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200725002326.41407-3-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
        <20200725002326.41407-3-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:27:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Fri, 24 Jul 2020 17:23:24 -0700

> If the ringsize change fails, try restoring the previous setting.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

You really can't recover properly, or reliably, with the way all of this
is structured in the ionic driver.  This is at best a half attempt at
error recovery.

Doing a full ionic_open() call abstracts things too heavily.

What you need to do is save away the current queue memory and object,
without freeing them, and only release them when you can successfully
setup the new queues.

This is the only way you can properly recover from errors in this
operation, with a proper check/commit sequence.

I'd rather not merge half solutions to this problem, sorry.
