Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D872559957
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfF1LmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:42:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:51260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfF1LmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:42:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A62BDAD72;
        Fri, 28 Jun 2019 11:42:14 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C0A6EE00E0; Fri, 28 Jun 2019 13:42:12 +0200 (CEST)
Date:   Fri, 28 Jun 2019 13:42:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628114212.GE29149@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628111216.GA2568@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:
> 
> I think that it is desired for kernel to work with "real alias" as a
> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
> Userspace mapping like you did here might be perhaps okay for iproute2,
> but I think that we need something and easy to use for all.
> 
> Let's call it "altname". Get would return:
> 
> IFLA_NAME  eth0
> IFLA_ALT_NAME_LIST
>    IFLA_ALT_NAME  eth0
>    IFLA_ALT_NAME  somethingelse
>    IFLA_ALT_NAME  somenamethatisreallylong
> 
> then userspace would pass with a request (get/set/del):
> IFLA_ALT_NAME eth0/somethingelse/somenamethatisreallylong
> or
> IFLA_NAME eth0 if it is talking with older kernel
> 
> Then following would do exactly the same:
> ip link set eth0 addr 11:22:33:44:55:66
> ip link set somethingelse addr 11:22:33:44:55:66
> ip link set somenamethatisreallylong addr 11:22:33:44:55:66

Yes, this sounds nice.

> We would have to figure out the iproute2 iface to add/del altnames:
> ip link add eth0 altname somethingelse
> ip link del eth0 altname somethingelse
>   this might be also:
>   ip link del somethingelse altname somethingelse

This would be a bit confusing, IMHO, as so far

  ip link add $name ...

always means we want to add or delete new device $name which would not
be the case here. How about the other way around:

  ip link add somethingelse altname_for eth0

(preferrably with a better keyword than "altname_for" :-) ). Or maybe

  ip altname add somethingelse dev eth0
  ip altname del somethingelse dev eth0

Michal
