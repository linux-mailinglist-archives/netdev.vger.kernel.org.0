Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8893DCC1F
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 16:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhHAOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 10:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhHAOiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 10:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21FF560EC0;
        Sun,  1 Aug 2021 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627828723;
        bh=FGFBjq9YabKmgwU/bI9mR68bFsA5bC2U0VYVG88m/G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+14xulSFoSHkTFlm6lwVn3IlS7QvZDKznfgvCwQiFzW8oBfN8nLWIISUDU2L7eJ9
         ZejrtxUz2o0qwWciBSYJQinFCAS47u2wNtXsoFmPf4430EFu3aRbNMQOQIV6SwI30w
         Nqa6iEjoxTptMAYNrWrzgAE0yMS/WLc0gLHCkS0+wJLO1kF1hvvfIrYDfjhOMPxvP3
         f+BgRkzInqFPwhuMnePiV82Vb3eHKWOwVR97sPHbn8RryNem3lwm/qDvoSA5/12O0u
         R8m2uQvwJScrOn+A9XK0bZqKLjAiV3w/LIjis//b3o+wTdgG5Bte2wIWcTdqraYMl7
         vULbur0Patrwg==
Received: by pali.im (Postfix)
        id C5EC5EF9; Sun,  1 Aug 2021 16:38:40 +0200 (CEST)
Date:   Sun, 1 Aug 2021 16:38:40 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <20210801143840.j6bfvt3zsfb2x7q5@pali>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <YQawRZL6aeBkuDSZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YQawRZL6aeBkuDSZ@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 01 August 2021 16:31:33 Andrew Lunn wrote:
> On Sat, Jul 31, 2021 at 10:30:54PM +0200, Pali Rohár wrote:
> > Hello!
> > 
> > Via rtnetlink API (RTM_NEWLINK/NLM_F_CREATE) it is possible to create a
> > new network interface without specifying neither interface name nor id.
> > This will let kernel to choose some interface name which does not
> > conflicts with any already existing network interface. So seems like
> > ideal way if I do not care about interface names. But at some stage it
> > is needed to "configure" interface and for this action it is required to
> > know interface id or name (as some ioctls use interface name instead of
> > id).
> 
> Hi Pali
> 
> Looking at __rtnl_newlink() it looks like you can specify the
> dev->ifindex when you request the create. So you can leave the kernel
> to pick the name, but pick the if_index from user space.
> 
>    Andrew

Hello! This has additional issue that I have to choose some free ifindex
number and it introduce another race condition that other userspace
process may choose same ifindex number. So create request in this case
fails if other userspace process is faster... So it has same race
condition as specifying interface name.
