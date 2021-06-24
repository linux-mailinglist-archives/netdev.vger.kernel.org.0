Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AD63B33FB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFXQf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXQfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0D4F613D8;
        Thu, 24 Jun 2021 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624552386;
        bh=U85H3nNtvGQ2AWcLA/f8xUdWkXbVZ6/BYvvjfQFZb7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cvKMagF3ZXr1K64DyK3qeNjFC2yE7zYVA1wUJ+0vMqIWUgb+XgwSEmW/GcjESgWj6
         UTgwGOsrHoUCXq6TfR8j67GSkf218RHu1xS/BPbRO+XXcd9YM1VCPBMd6URiB8lZw4
         0liLSyoZiNLL93v1zrtg0uS9nvqc0CMMeW3CuDBEG7rdqI475lcIQCBjwH4LAZeVaz
         NmQaI1PPcmQL5nW4PGrWqGXP2P5gqcnULbGtrV2MHRgV+jTdZO7WahWLtVKE8cfgrh
         8EZuWycjAtSGSB1SI+JZJtQeqQYWUNYGKT8IzdJR1Qr7BUyrwuIMj43G5A7E/LklkD
         waO+DThR1u9Jg==
Date:   Thu, 24 Jun 2021 09:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Guillaume Nault <gnault@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, vfedorenko@novek.ru
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
Message-ID: <20210624093305.4b4bb49e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <18a17215-e4e4-a1ef-b2d0-a934dca2b21c@gmail.com>
References: <20210622015254.1967716-1-kuba@kernel.org>
        <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
        <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
        <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5011b8aa-8bbf-9172-0982-599afed69c5d@gmail.com>
        <20210624133915.GA4606@pc-32.home>
        <18a17215-e4e4-a1ef-b2d0-a934dca2b21c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 08:36:12 -0600 David Ahern wrote:
> >> It is to let IPv6 DAD to complete otherwise the address will not be
> >> selected as a source address. That typically results in test failures.
> >> There are sysctl settings that can prevent the race and hence the need
> >> for the sleep.  
> > 
> > But Jakub's script uses "nodad" in the "ip address add ..." commands.
> > Isn't that supposed to disable DAD entirely for the new address?
> > Why would it need an additional "sleep 2"?
> >   
> 
> it should yes. I think the selftests have acquired a blend of nodad,
> sysctl and sleep. I'm sure it could be cleaned up and made consistent.

I was guessing that the DAD is happening on the link local address,
that's why, no? I'm using link local in the underlay.
