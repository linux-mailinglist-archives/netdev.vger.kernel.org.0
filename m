Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0F714AC
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388748AbfGWJJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:09:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:36958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729427AbfGWJJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 05:09:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 890A3AF79;
        Tue, 23 Jul 2019 09:09:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3D87CE0E22; Tue, 23 Jul 2019 11:09:08 +0200 (CEST)
Date:   Tue, 23 Jul 2019 11:09:08 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Thomas Haller <thaller@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
Message-ID: <20190723090908.GA2204@unicorn.suse.cz>
References: <cover.1556806084.git.mkubecek@suse.cz>
 <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
 <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:57:54AM +0200, Thomas Haller wrote:
> Does this flag and strict validation really provide any value?
> Commonly a netlink message is a plain TLV blob, and the meaning
> depends entirely on the policy.
> 
> What I mean is that for example
> 
>   NLA_PUT_U32 (msg, ATTR_IFINDEX, (uint32_t) ifindex)
>   NLA_PUT_STRING (msg, ATTR_IFNAME, "net")
> 
> results in a 4 bytes payload that does not encode whether the data is
> a number or a string.
> 
> Why is it valuable in this case to encode additional type information
> inside the message, when it's commonly not done and also not
> necessary?

One big advantage of having nested attributes explicitly marked is that
it allows parsers not aware of the semantics to recognize nested
attributes and parse their inner structure.

This is very important e.g. for debugging purposes as without the flag,
wireshark can only recurse into nested attributes if it understands the
protocol and knows they are nested, otherwise it displays them only as
an opaque blob (which is what happens for most netlink based protocols).
Another example is mnl_nlmsg_fprintf() function from libmnl which is
also a valuable debugging aid but without NLA_F_NESTED flags it cannot
show message structure properly.

Michal Kubecek
