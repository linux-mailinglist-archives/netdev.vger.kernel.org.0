Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA78AADD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfHLW6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLW6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 18:58:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 400BB307D90E;
        Mon, 12 Aug 2019 22:58:37 +0000 (UTC)
Received: from localhost (unknown [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82F0571D52;
        Mon, 12 Aug 2019 22:58:35 +0000 (UTC)
Date:   Tue, 13 Aug 2019 00:58:30 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@gmail.com, liuhangbin@gmail.com, netdev@vger.kernel.org,
        mleitner@redhat.com
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
Message-ID: <20190813005830.41f92428@redhat.com>
In-Reply-To: <20190811.204918.777837587917672157.davem@davemloft.net>
References: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
        <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
        <209d2ebf-aeb1-de08-2343-f478d51b92fa@gmail.com>
        <20190811.204918.777837587917672157.davem@davemloft.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 12 Aug 2019 22:58:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Aug 2019 20:49:18 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: David Ahern <dsahern@gmail.com>
> Date: Thu, 1 Aug 2019 22:16:00 -0600
> 
> > On 8/1/19 10:13 PM, Hangbin Liu wrote:  
> >> On Thu, Aug 01, 2019 at 01:51:25PM -0600, David Ahern wrote:  
> >>> On 8/1/19 2:29 AM, Hangbin Liu wrote:  
> >>>> Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
> >>>> if src_addr is not an address on local system.
> >>>>
> >>>> \# ip route get 1.1.1.1 from 2.2.2.2
> >>>> RTNETLINK answers: Invalid argument  
> >>>
> >>> so this is a forwarding lookup in which case iif should be set. Based on  
> >> 
> >> with out setting iif in userspace, the kernel set iif to lo by default.  
> > 
> > right, it presumes locally generated traffic.  
> >>   
> >>> the above 'route get' inet_rtm_getroute is doing a lookup as if it is
> >>> locally generated traffic.  
> >> 
> >> yeah... but what about the IPv6 part. That cause a different behavior in
> >> userspace.  
> > 
> > just one of many, many annoying differences between v4 and v6. We could
> > try to catalog it.  
> 
> I think we just have to accept this difference because this change would
> change behavior for all route lookups, not just those done by ip route get.

How so, actually? I don't see how that would happen. On the forwarding
path, 'iif' is set (not to loopback interface), so that's not affected.

Is there any other route lookup possibility I'm missing?

-- 
Stefano
