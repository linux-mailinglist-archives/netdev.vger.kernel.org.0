Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A6206703
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbgFWWLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388955AbgFWWLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:11:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66973C061573;
        Tue, 23 Jun 2020 15:11:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0D0B1294AFBF;
        Tue, 23 Jun 2020 15:11:45 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:11:45 -0700 (PDT)
Message-Id: <20200623.151145.1336624346097080182.davem@davemloft.net>
To:     brianvv@google.com
Cc:     brianvv.kernel@gmail.com, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lrizzo@google.com, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 2/2] ipv6: fib6: avoid indirect calls from
 fib6_rule_lookup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623164232.175846-2-brianvv@google.com>
References: <20200623164232.175846-1-brianvv@google.com>
        <20200623164232.175846-2-brianvv@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:11:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>
Date: Tue, 23 Jun 2020 09:42:32 -0700

> It was reported that a considerable amount of cycles were spent on the
> expensive indirect calls on fib6_rule_lookup. This patch introduces an
> inline helper called pol_route_func that uses the indirect_call_wrappers
> to avoid the indirect calls.
> 
> This patch saves around 50ns per call.
> 
> Performance was measured on the receiver by checking the amount of
> syncookies that server was able to generate under a synflood load.
> 
> Traffic was generated using trafgen[1] which was pushing around 1Mpps on
> a single queue. Receiver was using only one rx queue which help to
> create a bottle neck and make the experiment rx-bounded.
> 
> These are the syncookies generated over 10s from the different runs:
> 
> Whithout the patch:
 ...
> With the patch:
 ...
> Without the patch the average is 354263 pkt/s or 2822 ns/pkt and with
> the patch the average is 360738 pkt/s or 2772 ns/pkt which gives an
> estimate of 50 ns per packet.
> 
> [1] http://netsniff-ng.org/
> 
> Changelog since v1:
>  - Change ordering in the ICW (Paolo Abeni)
> 
> Cc: Luigi Rizzo <lrizzo@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied.
