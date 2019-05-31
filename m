Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5803D30895
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfEaGgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:36:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:60130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfEaGgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 02:36:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 243A9AF98;
        Fri, 31 May 2019 06:35:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9B1D9E00E3; Fri, 31 May 2019 08:35:58 +0200 (CEST)
Date:   Fri, 31 May 2019 08:35:58 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next 1/9] libnetlink: Set NLA_F_NESTED in
 rta_nest
Message-ID: <20190531063558.GA15954@unicorn.suse.cz>
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-2-dsahern@kernel.org>
 <20190530104345.3598be4d@hermes.lan>
 <22198e57-c573-abe6-16f7-92796daf7025@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22198e57-c573-abe6-16f7-92796daf7025@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 11:50:59AM -0600, David Ahern wrote:
> On 5/30/19 11:43 AM, Stephen Hemminger wrote:
> > 
> > I assume older kernels ignore the attribute?
> > 
> > Also, how is this opt-in for running iproute2-next on old kernels?
> 
> from what I can see older kernel added the flag when generating a nest
> (users of nla_nest_start), but did not pay attention to the flag for
> messages received from userspace.

Most of kernel generated messages do not set NLA_F_NESTED as
nla_nest_start() did not set it automatically before commit ae0be8de9a53
("netlink: make nla_nest_start() add NLA_F_NESTED flag") which only
reached mainline in 5.2 merge window. Unfortunately we cannot simply
start setting the flag everywhere as there may be userspace software
using nla->type directly rather than through a wrapper masking out the
flags.

On the other hand, it's safe to set set NLA_F_NESTED in messages sent to
kernel. When checking kernel tree for direct nla->type access, I found
only few (~10) places doing that and with one exception, those were
special cases, e.g. when attribute type was (ab)used as an array index.
Most of the code (and IIRC all of rtnetlink) either uses parse functions
or nla_type() accessor.

Michal
