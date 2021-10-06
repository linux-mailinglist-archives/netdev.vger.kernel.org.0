Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6714A42384E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhJFGry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:47:54 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58514 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJFGrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:47:53 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E108D2249E;
        Wed,  6 Oct 2021 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633502760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HdVrfvv8CiG4slv8hQ8NwxfbUMG9cPN5Ln0rBoKfymg=;
        b=mriM0IYF8WdSs1XXqrRPVb5pt/vaekRt+dDOGfYZmtJWmOUncSopfoH9VCwuVIes/JJREv
        4Gs9Vs/64p28EthY0/WAHGl2HryYjXZZ3fSXnwjqf/40UM5WFcV3K1j4lFWCLe5WYpVEuD
        fdg9imffuOWG3oK/bEF45RSsOOGcfGQ=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 420F7A3B87;
        Wed,  6 Oct 2021 06:46:00 +0000 (UTC)
Date:   Wed, 6 Oct 2021 08:45:58 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 9/9] net-sysfs: remove the use of
 rtnl_trylock/restart_syscall
Message-ID: <YV1GJg/aqPARptJp@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org>
 <20210928125500.167943-10-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928125500.167943-10-atenart@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 28-09-21 14:55:00, Antoine Tenart wrote:
> The ABBA deadlock avoided by using rtnl_trylock and restart_syscall was
> fixed in previous commits, we can now remove the use of this
> trylock/restart logic and have net-sysfs operations not spinning when
> rtnl is already taken.

Shouldn't those lock be interruptible or killable at least? As mentioned
in other reply we are seeing multiple a contention on some sysfs file
because mlx driver tends to do some heavy lifting in its speed callback
so it would be great to be able to interact with waiters during that
time.
-- 
Michal Hocko
SUSE Labs
