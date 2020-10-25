Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50462983BA
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418940AbgJYVnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbgJYVnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 17:43:10 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEAD022282;
        Sun, 25 Oct 2020 21:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603662190;
        bh=Z+yQdosHIqWTtqIGi4Es45MVjtutsHIFOW6HVcKv0SE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NOoc9Z+//Fo8hoMZ6Ao1h6Lil8qzbsn7aXB7dSzfdaNv7RDtZkZeLW+/g9mHgEvsx
         mbeSzEZeDOlrMwRhhwelDNNbUIr8+hYUn8EHTaYRXdPLwTzEjnUVHCNMEYtBZUZLXI
         Z7feVB5A62k+RvbuYIDhGHhfQ7h3va8zSC7VwJS0=
Date:   Sun, 25 Oct 2020 14:43:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
Message-ID: <20201025144309.1c91b166@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023184816.GB21673@pc-2.home>
References: <cover.1603469145.git.gnault@redhat.com>
        <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
        <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201023184816.GB21673@pc-2.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 20:48:16 +0200 Guillaume Nault wrote:
> On Fri, Oct 23, 2020 at 11:23:04AM -0700, Jakub Kicinski wrote:
> > On Fri, 23 Oct 2020 18:19:43 +0200 Guillaume Nault wrote:  
> > > Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
> > > mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
> > > need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.  
> > 
> > Does it generate an error or a warning? I don't know much about soft
> > dependencies, but I'd think it's optional.  
> 
> Yes, it's optional from a softdep point of view. My point was that
> having a softdep isn't a complete solution, as a bad .config can still
> result in inability to properly transmit GSO packets.

IMO the combination of select and softdep feels pretty strange.

It's either a softdep and therefore optional, or we really don't 
want to be missing it in a correctly functioning system, and the
dependency should be made stronger.
