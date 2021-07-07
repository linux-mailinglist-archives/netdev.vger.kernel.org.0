Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971843BE9E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhGGOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:41:36 -0400
Received: from relay.sw.ru ([185.231.240.75]:60828 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGGOlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 10:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=jVy+X6vVq5fpVoevgESDcU88nKTp0/pY1fjkW4vr+10=; b=jDu+cIWqMq9d/UPOY48
        RR00+hKtS3I7CUR1kisnUBwoFUiEFjFtyu8C2gIBcDi0BGx19ICiU8yCbBXlUqWdFXbXenGqawJeC
        j0uY9d50hNCT+LQ35hfywA6HcHXWSqYFYDqbYkudXRzjqCh+FKy/OvWDjfojReXTrtQNLrLiX3E=;
Received: from [192.168.15.10] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m18hS-003D4g-8X; Wed, 07 Jul 2021 17:38:54 +0300
Date:   Wed, 7 Jul 2021 17:38:53 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210707173853.5223f68541f867ac3effae41@virtuozzo.com>
In-Reply-To: <20210707073505.37738a3d@hermes.local>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210707073505.37738a3d@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 07:35:05 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed,  7 Jul 2021 15:22:01 +0300
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> 
> > We started to use in-kernel filtering feature which allows to get only
> > needed tables (see iproute_dump_filter()). From the kernel side it's
> > implemented in net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c
> > (inet6_dump_fib). The problem here is that behaviour of "ip route save"
> > was changed after
> > c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> > If filters are used, then kernel returns ENOENT error if requested table
> > is absent, but in newly created net namespace even RT_TABLE_MAIN table
> > doesn't exist. It is really allocated, for instance, after issuing
> > "ip l set lo up".
> > 
> > Reproducer is fairly simple:
> > $ unshare -n ip route save > dump
> > Error: ipv4: FIB table does not exist.
> > Dump terminated
> > 
> > Expected result here is to get empty dump file (as it was before this
> > change).
> > 
> > v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> > (see nl_dump_ext_ack_done() function). We want to suppress error messages
> > in stderr about absent FIB table from kernel too.
> > 
> > v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
> > rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
> > easily extended by changing SUPPRESS_ERRORS_INIT macro).
> > 
> > v4: reworked, rtnl_dump_filter_errhndlr() was introduced. Thanks
> > to Stephen Hemminger for comments and suggestions
> > 
> > v5: space fixes, commit message reformat, empty initializers
> > 
> > Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Andrei Vagin <avagin@gmail.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> 
> Applied this version

Stephen,

Thank you for your review and suggestions!

Alex
