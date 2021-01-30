Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473030961D
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhA3O4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 09:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhA3Oxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 09:53:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA3E64E13;
        Sat, 30 Jan 2021 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612018393;
        bh=gHTDus04sfWIV+ckJJfv1Wnagbt5NnNUQdQB3S2RuaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mb0ugb3EJKoSNfar/DePivI7YQa5ZsSkCMRfX4eX6cn7Owh8vbS1z/rbgGHzFRGG
         AF3o8lhVoK3Xy9bEraqpbqDJG9Mrzl7bM7cQkQcvgzSYIDAD0IGX1lUU8Up9yBhm2D
         c3EE0QPjby7rGBSV27IxWEkVO1XnRJVUU0BPXGV0=
Date:   Sat, 30 Jan 2021 15:53:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aviraj CJ <acj@cisco.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH stable v5.4 2/2] IPv6: reply ICMP error if the first
 fragment don't include all headers
Message-ID: <YBVy1kNl5joCU2Xb@kroah.com>
References: <20210130115452.19192-1-acj@cisco.com>
 <20210130115452.19192-2-acj@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130115452.19192-2-acj@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 05:24:52PM +0530, Aviraj CJ wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> 
> commit 2efdaaaf883a143061296467913c01aa1ff4b3ce upstream.
> 
> Based on RFC 8200, Section 4.5 Fragment Header:
> 
>   -  If the first fragment does not include all headers through an
>      Upper-Layer header, then that fragment should be discarded and
>      an ICMP Parameter Problem, Code 3, message should be sent to
>      the source of the fragment, with the Pointer field set to zero.
> 
> Checking each packet header in IPv6 fast path will have performance impact,
> so I put the checking in ipv6_frag_rcv().
> 
> As the packet may be any kind of L4 protocol, I only checked some common
> protocols' header length and handle others by (offset + 1) > skb->len.
> Also use !(frag_off & htons(IP6_OFFSET)) to catch atomic fragments
> (fragmented packet with only one fragment).
> 
> When send ICMP error message, if the 1st truncated fragment is ICMP message,
> icmp6_send() will break as is_ineligible() return true. So I added a check
> in is_ineligible() to let fragment packet with nexthdr ICMP but no ICMP header
> return false.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Aviraj CJ <acj@cisco.com>
> ---
>  net/ipv6/icmp.c       |  8 +++++++-
>  net/ipv6/reassembly.c | 33 ++++++++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
