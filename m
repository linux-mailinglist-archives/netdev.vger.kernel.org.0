Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9AD24A68A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHSTHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHSTHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:07:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94145C061757;
        Wed, 19 Aug 2020 12:07:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5412112963ADB;
        Wed, 19 Aug 2020 11:50:24 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:07:09 -0700 (PDT)
Message-Id: <20200819.120709.1311664171016372891.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, colyli@suse.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bypass ->sendpage for slab pages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819051945.1797088-1-hch@lst.de>
References: <20200819051945.1797088-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 11:50:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 19 Aug 2020 07:19:45 +0200

> Sending Slab or tail pages into ->sendpage will cause really strange
> delayed oops.  Prevent it right in the networking code instead of
> requiring drivers to guess the exact conditions where sendpage works.
> 
> Based on a patch from Coly Li <colyli@suse.de>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes this fixes the problem, but it doesn't in any way deal with the
callers who are doing this stuff.

They are all likely using sendpage because they expect that it will
avoid the copy, for performance reasons or whatever.

Now it won't.

At least with Coly's patch set, the set of violators was documented
and they could switch to allocating non-slab pages or calling
sendmsg() or write() instead.

I hear talk about ABIs just doing the right thing, but when their
value is increased performance vs. other interfaces it means that
taking a slow path silently is bad in the long term.  And that's
what this proposed patch here does.

