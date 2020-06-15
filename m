Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639761FA156
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgFOUUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731249AbgFOUUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:20:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1C2C061A0E;
        Mon, 15 Jun 2020 13:20:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CC09120ED49A;
        Mon, 15 Jun 2020 13:20:32 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:20:31 -0700 (PDT)
Message-Id: <20200615.132031.260816488025362367.davem@davemloft.net>
To:     bruceshenzk@gmail.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: alx: fix race condition in alx_remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615155029.21002-1-bruceshenzk@gmail.com>
References: <20200614165912.25622-1-bruceshenzk@gmail.com>
        <20200615155029.21002-1-bruceshenzk@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:20:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>
Date: Mon, 15 Jun 2020 11:50:29 -0400

> There is a race condition exist during termination. The path is
> alx_stop and then alx_remove. An alx_schedule_link_check could be called
> before alx_stop by interrupt handler and invoke alx_link_check later.
> Alx_stop frees the napis, and alx_remove cancels any pending works.
> If any of the work is scheduled before termination and invoked before
> alx_remove, a null-ptr-deref occurs because both expect alx->napis[i].
> 
> This patch fix the race condition by moving cancel_work_sync functions
> before alx_free_napis inside alx_stop. Because interrupt handler can call
> alx_schedule_link_check again, alx_free_irq is moved before
> cancel_work_sync calls too.
> 
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

Applied, thank you.
