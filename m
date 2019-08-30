Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE24A2B47
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfH3AHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:07:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfH3AHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:07:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAB7E153C9A48;
        Thu, 29 Aug 2019 17:07:48 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:07:48 -0700 (PDT)
Message-Id: <20190829.170748.656667843147010952.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] taprio: Fix kernel panic in taprio_destroy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828144829.32570-2-olteanv@gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com>
        <20190828144829.32570-2-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:07:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 28 Aug 2019 17:48:27 +0300

> taprio_init may fail earlier than this line:
> 
> 	list_add(&q->taprio_list, &taprio_list);
> 
> i.e. due to the net device not being multi queue.
> 
> Attempting to remove q from the global taprio_list when it is not part
> of it will result in a kernel panic.
> 
> Fix it by iterating through the list and removing it only if found.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

I don't like this solution for two reaons, I think it's actually
error prone, and now every taprio_destroy() eats the cost of traversing
the entire list.

The whole reason to use a list head is O(1) removal.

Just init the list head early in the creation then the list_del() just
works.
