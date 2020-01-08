Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762F7134FF6
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgAHXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:21:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:21:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2CCA158823C4;
        Wed,  8 Jan 2020 15:21:37 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:21:37 -0800 (PST)
Message-Id: <20200108.152137.1374468272236816533.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, siva.kallam@broadcom.com,
        christopher.lee@cspi.com, ecree@solarflare.com,
        johannes.berg@intel.com
Subject: Re: [PATCH 0/8] reduce open coded skb->next access for gso segment
 walking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108215909.421487-1-Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:21:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed,  8 Jan 2020 16:59:01 -0500

> This patchset introduces the skb_list_walk_safe helper macro, in order
> to add some sanity to the myrid ways drivers have of walking through gso
> segments. The goal is to reduce future bugs commonly caused by open
> coding these sorts of things, and to in the future make it easier to
> swap out the underlying list representation.
> 
> This first patch series addresses the easy uses of drivers iterating
> over the returned list of skb_gso_segments, for drivers that live in
> drivers/net/*. There are still other use cases to tackle later for
> net/*, and after these low-hanging fruits are taken care of, I imagine
> there are more subtle cases of gso segment walking that isn't just a
> direct return value from skb_gso_segments, and eventually this will have
> to be tackled. This series is the first in that direction.

I like this, applied to net-next and build testing.  Let's see where this
goes.

In the iwlwifi case, the skb_mark_not_on_list() is really redundant because
deep down inside the skb queue tail insert, __skb_insert() will unconditionally
always write both ->next and ->prev and there are no debugging checks along
the way which would trigger if skb->next was non-NULL.

I guess you could argue for defensive programming here, so there's that.

Anyways, thanks.
