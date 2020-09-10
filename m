Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F412265512
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgIJW2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIJW2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:28:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B8C061573;
        Thu, 10 Sep 2020 15:28:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C9B4135EDBF1;
        Thu, 10 Sep 2020 15:11:25 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:28:11 -0700 (PDT)
Message-Id: <20200910.152811.210183159970625640.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     kuba@kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910174826.511423-1-natechancellor@gmail.com>
References: <20200910174826.511423-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 15:11:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Thu, 10 Sep 2020 10:48:27 -0700

> Clang warns (trimmed for brevity):
> 
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3073:7: warning:
> variable 'link' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>                 if (val & MVPP22_XLG_STATUS_LINK_UP)
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3075:31: note:
> uninitialized use occurs here
>                 mvpp2_isr_handle_link(port, link);
>                                             ^~~~
> ...
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3090:8: warning:
> variable 'link' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>                         if (val & MVPP2_GMAC_STATUS0_LINK_UP)
>                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3092:32: note:
> uninitialized use occurs here
>                         mvpp2_isr_handle_link(port, link);
>                                                     ^~~~
> 
> Initialize link to false like it was before the refactoring that
> happened around link status so that a valid valid is always passed into
> mvpp2_isr_handle_link.
> 
> Fixes: 36cfd3a6e52b ("net: mvpp2: restructure "link status" interrupt handling")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1151
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

This got fixed via another change, a much mode simply one in fact,
changing the existing assignments to be unconditional and of the
form "link = (bits & MASK);"
