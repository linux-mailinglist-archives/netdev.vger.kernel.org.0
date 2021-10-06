Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA4423A12
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhJFI5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:57:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53880 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbhJFI5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:57:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 94DC322474;
        Wed,  6 Oct 2021 08:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633510542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tOUt98g8+9+P34E45fCGWBd76QCTPaEX9GgUrSeLO4E=;
        b=ZcDVID/7Ad9hhcOs6Efq4MybzXxsW3thx4q2eNdU7DJLdbmQn0JFheFaLP0ScDRwfnfZpl
        lcfEkSnhuQZIAauqimaDG3XaI3n8djsFuVYkvDd6qWJIHSQCOqekf9ffcV4zvpJGle6g47
        Frh+O4o5Mh7d7wmdJhufaK25bD4YTYA=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D8853A3B8A;
        Wed,  6 Oct 2021 08:55:40 +0000 (UTC)
Date:   Wed, 6 Oct 2021 10:55:40 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 9/9] net-sysfs: remove the use of
 rtnl_trylock/restart_syscall
Message-ID: <YV1kjDfTE2N2XK9J@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org>
 <20210928125500.167943-10-atenart@kernel.org>
 <YV1GJg/aqPARptJp@dhcp22.suse.cz>
 <163350742102.4226.2656822862076181317@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163350742102.4226.2656822862076181317@kwain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 06-10-21 10:03:41, Antoine Tenart wrote:
> Quoting Michal Hocko (2021-10-06 08:45:58)
> > On Tue 28-09-21 14:55:00, Antoine Tenart wrote:
> > > The ABBA deadlock avoided by using rtnl_trylock and restart_syscall was
> > > fixed in previous commits, we can now remove the use of this
> > > trylock/restart logic and have net-sysfs operations not spinning when
> > > rtnl is already taken.
> > 
> > Shouldn't those lock be interruptible or killable at least? As mentioned
> > in other reply we are seeing multiple a contention on some sysfs file
> > because mlx driver tends to do some heavy lifting in its speed callback
> > so it would be great to be able to interact with waiters during that
> > time.
> 
> Haven't thought much about this, but it should be possible to use
> rtnl_lock_killable. I think this should be a patch on its own with its
> own justification though (to help bisecting). But that is easy to do
> once the trylock logic is gone.

Agreed

-- 
Michal Hocko
SUSE Labs
