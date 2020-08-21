Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F7D24E25F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHUVDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgHUVDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:03:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC479C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:03:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC8C1128A0810;
        Fri, 21 Aug 2020 13:46:41 -0700 (PDT)
Date:   Fri, 21 Aug 2020 14:03:23 -0700 (PDT)
Message-Id: <20200821.140323.1479263590085016926.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        mahesh@bandewar.net, maze@google.com, jianyang@google.com
Subject: Re: [PATCH next] net: add option to not create fall-back tunnels
 in root-ns as well
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819005123.1867051-1-maheshb@google.com>
References: <20200819005123.1867051-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 13:46:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Tue, 18 Aug 2020 17:51:23 -0700

> The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> not create fallback tunnels for non-default namespaces") to create
> fall-back only in root-ns. This patch enhances that behavior to provide
> option not to create fallback tunnels in root-ns as well. Since modules
> that create fallback tunnels could be built-in and setting the sysctl
> value after booting is pointless, so added a config option which defaults
> to zero (to preserve backward compatibility) but also takes values "1" and
> "2" which don't create fallback tunnels in non-root namespaces
> only and no-where respectively.
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
 ...
> +config SYSCTL_FB_TUNNEL
 ...
> -int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
> +int sysctl_fb_tunnels_only_for_init_net __read_mostly = CONFIG_SYSCTL_FB_TUNNEL;

I can't allow this.  This requires a kernel rebuild when none is
really necessary.  You're also forcing distributions to make a choice
they have no place making at all.

You have two ways to handle this situation already:

1) Kernel command line

2) initrd

I'm not allowing to add a third.  And if I had, then that sets
precedence and others will want to do this as well for their
favorite sysctl that has implications as soon as modules get
loaded.
