Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157C2279CC1
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgIZWPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIZWPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 18:15:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F5C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:15:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B5E312A190CF;
        Sat, 26 Sep 2020 14:58:55 -0700 (PDT)
Date:   Sat, 26 Sep 2020 15:15:40 -0700 (PDT)
Message-Id: <20200926.151540.1383303857229218158.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, kliteyn@nvidia.com,
        erezsh@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925193809.463047-2-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
        <20200925193809.463047-2-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 26 Sep 2020 14:58:55 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Fri, 25 Sep 2020 12:37:55 -0700

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Add implementation of SW Steering variation of buddy allocator.
> 
> The buddy system for ICM memory uses 2 main data structures:
>   - Bitmap per order, that keeps the current state of allocated
>     blocks for this order
>   - Indicator for the number of available blocks per each order
> 
> In addition, there is one more hierarchy of searching in the bitmaps
> in order to accelerate the search of the next free block which done
> via find-first function:
> The buddy system spends lots of its time in searching the next free
> space using function find_first_bit, which scans a big array of long
> values in order to find the first bit. We added one more array of
> longs, where each bit indicates a long value in the original array,
> that way there is a need for much less searches for the next free area.
> 
> For example, for the following bits array of 128 bits where all
> bits are zero except for the last bit  :  0000........00001
> the corresponding bits-per-long array is:  0001
> 
> The search will be done over the bits-per-long array first, and after
> the first bit is found, we will use it as a start pointer in the
> bigger array (bits array).
> 
> Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Instead of a bits-per-long array, it seems so much simpler and more
cache friendly to maintain instead just a "lowest set bit" value.

In the initial state it is zero for all values, remember this is just
a hint.

When you allocate, if num_free is non-zero of course, you start the
bit scan from the "lowest set bit" value.  When the set bit is found,
update the "lowest set bit" cache to the set bit plus one (or zero if
the new value exceeds the bitmap size).

Then on free you update "lowest set bit" to the bit being set if it is
smaller than the current "lowest set bit" value for that order.

No double scanning of bitmap arrays, just a single bitmap search with
a variable start point.
