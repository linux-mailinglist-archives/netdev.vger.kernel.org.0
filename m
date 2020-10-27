Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6029BB2E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796412AbgJ0P6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804756AbgJ0Pzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:55:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3CB204EF;
        Tue, 27 Oct 2020 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814149;
        bh=2G8/tZz76rvmlUbvFnvKdu+nTFFawfG9VF5BIoYD/Ng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KqVuDxB8qxMTIS+OV4QponM5Rlvl6Mspza11nfLaLn/syqDWXss02j81PgqKu0K9q
         SNYWskMsGGAj7J3ctrenz9QGoyCaa5vKtUobIOCm745JqR6w4/t+qDKAcy1lhpR4rj
         XNPsQfGT9EWZfOcjgjJhDFYn6+Fekck+CDsbtsuc=
Date:   Tue, 27 Oct 2020 08:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, netdev@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
Message-ID: <20201027085548.05b39e0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8e24e490-b3bf-5268-4bd5-98b598b36b36@gmail.com>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
        <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
        <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <8e24e490-b3bf-5268-4bd5-98b598b36b36@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 08:51:07 -0600 David Ahern wrote:
> > Is this another incarnation of 4cb47a8644cc ("tunnels: PMTU discovery
> > support for directly bridged IP packets")? Sounds like non-UDP tunnels
> > need the same treatment to make PMTUD work.
> > 
> > RFC2003 seems to clearly forbid ignoring the inner DF:  
> 
> I was looking at this patch Sunday night. To me it seems odd that
> packets flowing through the overlay affect decisions in the underlay
> which meant I agree with the proposed change.

The RFC was probably written before we invented terms like underlay 
and overlay, and still considered tunneling to be an inefficient hack ;)

> ip_md_tunnel_xmit is inconsistent right now. tnl_update_pmtu is called
> based on the TUNNEL_DONT_FRAGMENT flag, so why let it be changed later
> based on the inner header? Or, if you agree with RFC 2003 and the DF
> should be propagated outer to inner, then it seems like the df reset
> needs to be moved up before the call to tnl_update_pmtu

Looks like TUNNEL_DONT_FRAGMENT is intended to switch between using
PMTU inside the tunnel or just the tunnel dev MTU. ICMP PTB is still
generated based on the inner headers.

We should be okay to add something like IFLA_GRE_IGNORE_DF to lwt, 
but IMHO the default should not be violating the RFC.
