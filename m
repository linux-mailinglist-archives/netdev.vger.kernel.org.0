Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B02AC20
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfEZU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:29:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfEZU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 16:29:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33B121423D7B8;
        Sun, 26 May 2019 13:29:21 -0700 (PDT)
Date:   Sun, 26 May 2019 13:29:20 -0700 (PDT)
Message-Id: <20190526.132920.535955459085533409.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org,
        Heesoon.Kim@stratus.com
Subject: Re: [PATCH net] bonding/802.3ad: fix slave link initialization
 transition states
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524134928.16834-1-jarod@redhat.com>
References: <20190524134928.16834-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 13:29:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 24 May 2019 09:49:28 -0400

> Once in a while, with just the right timing, 802.3ad slaves will fail to
> properly initialize, winding up in a weird state, with a partner system
> mac address of 00:00:00:00:00:00. This started happening after a fix to
> properly track link_failure_count tracking, where an 802.3ad slave that
> reported itself as link up in the miimon code, but wasn't able to get a
> valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
> BOND_LINK_DOWN. That was the proper thing to do for the general "my link
> went down" case, but has created a link initialization race that can put
> the interface in this odd state.
> 
> The simple fix is to instead set the slave link to BOND_LINK_DOWN again,
> if the link has never been up (last_link_up == 0), so the link state
> doesn't bounce from BOND_LINK_DOWN to BOND_LINK_FAIL -- it hasn't failed
> in this case, it simply hasn't been up yet, and this prevents the
> unnecessary state change from DOWN to FAIL and getting stuck in an init
> failure w/o a partner mac.
> 
> Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
> Tested-by: Heesoon Kim <Heesoon.Kim@stratus.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied and queued up for -stable.
