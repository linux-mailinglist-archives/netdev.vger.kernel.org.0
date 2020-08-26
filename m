Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8885C253797
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 20:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHZSwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 14:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgHZSwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 14:52:33 -0400
Received: from ganesha.gnumonks.org (unknown [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3B1C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 11:52:31 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kB0Wy-0006aR-Qy; Wed, 26 Aug 2020 20:52:20 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kB0Wg-000Xwy-FF; Wed, 26 Aug 2020 20:52:02 +0200
Date:   Wed, 26 Aug 2020 20:52:02 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org,
        Gabriel Ganne <gabriel.ganne@6wind.com>, kuba@kernel.org,
        davem@davemloft.net, pablo@netfilter.org
Subject: Re: [PATCH net-next v2] gtp: add notification mechanism
Message-ID: <20200826185202.GZ3739@nataraja>
References: <20200825143556.23766-1-nicolas.dichtel@6wind.com>
 <20200825155715.24006-1-nicolas.dichtel@6wind.com>
 <20200825170109.GH3822842@nataraja>
 <bd834ad7-b06e-69f0-40a6-5f4a21a1eba2@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd834ad7-b06e-69f0-40a6-5f4a21a1eba2@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Wed, Aug 26, 2020 at 09:47:54AM +0200, Nicolas Dichtel wrote:
> > Sending (unsolicited) notifications about all of those seems quite heavyweight to me.
>
> There is no 'unsolicited' notifications with this patch. Notifications are sent
> only if a userspace application has subscribed to the gtp mcast group.
> ip routes or conntrack entries are notified in the same way and there could a
> lot of them also (more than 100k conntrack entries for example).

Ok, thanks for reminding me of that.  However, even if those events are
not sent/multicasted, it still looks like the proposed patch is
unconditionally allocating a netlink message and filling it with
information about the PDP.  That alone looks like adding significant
overhead to every user - even the majority of current use cases where
nobody is listening/subscribing to that multicast group.

Wouldn't it make sense to only allocate + fill those messages if we
actually knew a subscriber existed?

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
