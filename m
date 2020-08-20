Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6D24C84C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgHTXNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgHTXNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DADC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:35 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 653E7128708AD;
        Thu, 20 Aug 2020 15:56:48 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:13:33 -0700 (PDT)
Message-Id: <20200820.161333.1002939663815793496.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH net-next] net: zerocopy: combine pages in
 zerocopy_sg_from_iter()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820154359.1806305-1-edumazet@google.com>
References: <20200820154359.1806305-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:56:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 20 Aug 2020 08:43:59 -0700

> Currently, tcp sendmsg(MSG_ZEROCOPY) is building skbs with order-0 fragments.
> Compared to standard sendmsg(), these skbs usually contain up to 16 fragments
> on arches with 4KB page sizes, instead of two.
> 
> This adds considerable costs on various ndo_start_xmit() handlers,
> especially when IOMMU is in the picture.
> 
> As high performance applications are often using huge pages,
> we can try to combine adjacent pages belonging to same
> compound page.
> 
> Tested on AMD Rome platform, with IOMMU, nominal single TCP flow speed
> is roughly doubled (~55Gbit -> ~100Gbit), when user application
> is using hugepages.
> 
> For reference, nominal single TCP flow speed on this platform
> without MSG_ZEROCOPY is ~65Gbit.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, the refcounitng in these kinds of patchs is always fun to
audit :-)
