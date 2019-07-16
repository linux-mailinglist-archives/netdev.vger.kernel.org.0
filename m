Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579F46AFED
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfGPTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:37:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGPTh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:37:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F05601522470F;
        Tue, 16 Jul 2019 12:37:25 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:37:23 -0700 (PDT)
Message-Id: <20190716.123723.2173742343657007091.davem@davemloft.net>
To:     nishkadg.linux@gmail.com
Cc:     grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw: Add of_node_put() before
 return and break
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716054843.2957-1-nishkadg.linux@gmail.com>
References: <20190716054843.2957-1-nishkadg.linux@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 12:37:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>
Date: Tue, 16 Jul 2019 11:18:43 +0530

> Each iteration of for_each_available_child_of_node puts the previous
> node, but in the case of a return or break from the middle of the loop,
> there is no put, thus causing a memory leak.

What an incredible terribly designed loop macro, this
for_each_available_child_of_node () thing is.

A macro with non-trivial, invisible, side effects.  It requires
special handling of reference counting of objects if the loop is
terminated early.

This is so error prone.  Is it any wonder we have to go through the
entire tree fixing up nearly every use of this thing?

Instead of looking at the automated analysis of this and saying "great
here are all of these places where I can fix bugs", I would instead
appreicate it if the reaction was more like "this interface is
obviously impossible to use in a non-error-prone fashion, we should
fix it."

I guess I have no choice but to apply your fixes, but the larger issue
must be addressed instead.
