Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EE4986C5
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiAXR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiAXR31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:29:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379A3C06173B;
        Mon, 24 Jan 2022 09:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAEF961261;
        Mon, 24 Jan 2022 17:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CDBC340E5;
        Mon, 24 Jan 2022 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643045366;
        bh=ogGBVzyyN+YYSzH3BaF6lXVfYkJA5EmUbebAVPzmLh4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RnvoP58W/N/jVa8aIiNBe2tryjrtotDSkPY9Kf5gzcH+tRZHbU80XgsYhlEruI2Wc
         bKl4484JNr5Vdd4IjNo1f17xypA/0QUCWOthb0TXZjouZ+zfb0d8UispZ1R5sZpu6L
         ENaFXO/3Z2K0/HX9pMpFtkZukM40VewumKWL+c3v4ATziGJ0ED77f9qyqmQ4CxLFoi
         6YhK1ZjnMcUb551jmNi2z7tMrneLwsuh7RpGjS9T0+jk+ApmmaUc0cAeSlWjw/EK3r
         Tu2NtQrmZMwX0pxC5R4yxaeBd4KEQKyjXeUr0IMnh34vzMffD8rd5Ux6MGf1mJ43hQ
         9WAmLVKN/WKdA==
Date:   Mon, 24 Jan 2022 09:29:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
Message-ID: <20220124092924.0eb17027@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
References: <20220122000301.1872828-1-jeffreyji@google.com>
        <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:13:12 -0800 Brian Vazquez wrote:
> On Fri, Jan 21, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat, 22 Jan 2022 00:03:01 +0000 Jeffrey Ji wrote:  
> > > From: jeffreyji <jeffreyji@google.com>
> > >
> > > Increment InMacErrors counter when packet dropped due to incorrect dest
> > > MAC addr.
> > >
> > > example output from nstat:
> > > \~# nstat -z "*InMac*"
> > > \#kernel
> > > Ip6InMacErrors                  0                  0.0
> > > IpExtInMacErrors                1                  0.0
> > >
> > > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > > with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> > > counter was incremented.
> > >
> > > Signed-off-by: jeffreyji <jeffreyji@google.com>  
> >
> > How about we use the new kfree_skb_reason() instead to avoid allocating
> > per-netns memory the stats?  
> 
> I'm not too familiar with the new kfree_skb_reason , but my
> understanding is that it needs either the drop_monitor  or ebpf to get
> the reason from the tracepoint, right? This is not too different from
> using perf tool to find where the pkt is being dropped.
> 
> The idea here was to have a high level metric that is easier to find
> for users that have less expertise on using more advance tools.

That much it's understood, but it's a trade off. This drop point
existed for 20 years, why do we need to consume extra memory now?
