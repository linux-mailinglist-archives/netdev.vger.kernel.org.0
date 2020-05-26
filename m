Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19D11E3275
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390674AbgEZW2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389382AbgEZW2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:28:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381F7C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:28:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95E33120ED4BE;
        Tue, 26 May 2020 15:28:01 -0700 (PDT)
Date:   Tue, 26 May 2020 15:28:00 -0700 (PDT)
Message-Id: <20200526.152800.1859140520396255826.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, dahern@digitalocean.com
Subject: Re: [PATCH net 0/5] nexthops: Fix 2 fundamental flaws with nexthop
 groups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526150114.41687-1-dsahern@kernel.org>
References: <20200526150114.41687-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:28:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 26 May 2020 09:01:09 -0600

> From: David Ahern <dahern@digitalocean.com>
> 
> Nik's torture tests have exposed 2 fundamental mistakes with the initial
> nexthop code for groups. First, the nexthops entries and num_nh in the
> nh_grp struct should not be modified once the struct is set under rcu.
> Doing so has major affects on the datapath seeing valid nexthop entries.
> 
> Second, the helpers in the header file were convenient for not repeating
> code, but they cause datapath walks to potentially see 2 different group
> structs after an rcu replace, disrupting a walk of the path objects.
> This second problem applies solely to IPv4 as I re-used too much of the
> existing code in walking legs of a multipath route.
> 
> Patches 1 is refactoring change to simplify the overhead of reviewing and
> understanding the change in patch 2 which fixes the update of nexthop
> groups when a compnent leg is removed.
> 
> Patches 3-5 address the second problem. Patch 3 inlines the multipath
> check such that the mpath lookup and subsequent calls all use the same
> nh_grp struct. Patches 4 and 5 fix datapath uses of fib_info_num_path
> with iterative calls to fib_info_nhc.
> 
> fib_info_num_path can be used in control plane path in a 'for loop' with
> subsequent fib_info_nhc calls to get each leg since the nh_grp struct is
> only changed while holding the rtnl; the combination can not be used in
> the data plane with external nexthops as it involves repeated dereferences
> of nh_grp struct which can change between calls.
> 
> Similarly, nexthop_is_multipath can be used for branching decisions in
> the datapath since the nexthop type can not be changed (a group can not
> be converted to standalone and vice versa).
> 
> Patch set developed in coordination with Nikolay Aleksandrov. He did a
> lot of work creating a good reproducer, discussing options to fix it
> and testing iterations.
> 
> I have adapted Nik's commands into additional tests in the nexthops
> selftest script which I will send against -next.

Series applied and queued up for -stable, thanks David.
