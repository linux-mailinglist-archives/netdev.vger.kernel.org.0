Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9D9895DD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 05:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfHLDtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 23:49:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHLDtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 23:49:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28656142CA443;
        Sun, 11 Aug 2019 20:49:22 -0700 (PDT)
Date:   Sun, 11 Aug 2019 20:49:18 -0700 (PDT)
Message-Id: <20190811.204918.777837587917672157.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org, sbrivio@redhat.com,
        mleitner@redhat.com
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <209d2ebf-aeb1-de08-2343-f478d51b92fa@gmail.com>
References: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
        <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
        <209d2ebf-aeb1-de08-2343-f478d51b92fa@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 20:49:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Thu, 1 Aug 2019 22:16:00 -0600

> On 8/1/19 10:13 PM, Hangbin Liu wrote:
>> On Thu, Aug 01, 2019 at 01:51:25PM -0600, David Ahern wrote:
>>> On 8/1/19 2:29 AM, Hangbin Liu wrote:
>>>> Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
>>>> if src_addr is not an address on local system.
>>>>
>>>> \# ip route get 1.1.1.1 from 2.2.2.2
>>>> RTNETLINK answers: Invalid argument
>>>
>>> so this is a forwarding lookup in which case iif should be set. Based on
>> 
>> with out setting iif in userspace, the kernel set iif to lo by default.
> 
> right, it presumes locally generated traffic.
>> 
>>> the above 'route get' inet_rtm_getroute is doing a lookup as if it is
>>> locally generated traffic.
>> 
>> yeah... but what about the IPv6 part. That cause a different behavior in
>> userspace.
> 
> just one of many, many annoying differences between v4 and v6. We could
> try to catalog it.

I think we just have to accept this difference because this change would
change behavior for all route lookups, not just those done by ip route get.
