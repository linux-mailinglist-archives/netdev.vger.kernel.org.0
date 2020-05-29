Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7011E8C56
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgE2Xwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgE2Xwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:52:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB125C08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:52:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48DFB1286AB9F;
        Fri, 29 May 2020 16:52:35 -0700 (PDT)
Date:   Fri, 29 May 2020 16:52:34 -0700 (PDT)
Message-Id: <20200529.165234.25764810096006532.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [net-next 0/2] net: sched: cls-flower: add support for
 port-based fragment filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
References: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:52:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Wed, 27 May 2020 16:25:28 -0400

> Port based allow rules must currently allow all fragments since the
> port number is not included in the 1rst fragment. We want to restrict
> allowing all fragments by inclucding the port number in the 1rst
> fragments.
> 
> For example, we can now allow fragments for only port 80 via:
> 
> # tc filter add dev $DEVICE parent ffff: priority 1 protocol ipv4 flower
>   ip_proto tcp dst_port 80 action pass
> # tc filter add dev $DEVICE parent ffff: priority 2 protocol ipv4 flower
>   ip_flags frag/nofirstfrag action pass
> 
> The first patch includes ports for 1rst fragments.
> The second patch adds test cases, demonstrating the new behavior.

But this is only going to drop the first frag right?

Unless there is logic to toss the rest of the frags this seems
extremely hackish as best.

I don't want to apply this as-is, it's a short sighted design
as far as I am concerned.
