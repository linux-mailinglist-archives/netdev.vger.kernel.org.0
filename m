Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8842422B6A0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGWTTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgGWTTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:19:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E2EC0619DC;
        Thu, 23 Jul 2020 12:19:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED87011E45902;
        Thu, 23 Jul 2020 12:02:45 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:19:30 -0700 (PDT)
Message-Id: <20200723.121930.163681559677190095.davem@davemloft.net>
To:     salyzyn@android.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        netdev@vger.kernel.org, kuba@kernel.org, tgraf@suug.ch
Subject: Re: [PATCH] netlink: add buffer boundary checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723182136.2550163-1-salyzyn@android.com>
References: <20200723182136.2550163-1-salyzyn@android.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 12:02:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Salyzyn <salyzyn@android.com>
Date: Thu, 23 Jul 2020 11:21:32 -0700

> Many of the nla_get_* inlines fail to check attribute's length before
> copying the content resulting in possible out-of-boundary accesses.
> Adjust the inlines to perform nla_len checking, for the most part
> using the nla_memcpy function to faciliate since these are not
> necessarily performance critical and do not need a likely fast path.
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Graf <tgraf@suug.ch>
> Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")

Please, let's avoid stuff like this.

Now it is going to be expensive to move several small attributes,
which is common.  And there's a multiplier when dumping, for example,
thousands of networking devices, routes, or whatever, and all of their
attributes in a dump.

If you can document actual out of bounds accesses, let's fix them.  Usually
contextually the attribute type and size has been validated by the time we
execute these accessors.

I'm not applying this, sorry.
