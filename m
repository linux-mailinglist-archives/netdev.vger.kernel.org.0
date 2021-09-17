Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077E240F9E6
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbhIQOFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbhIQOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:05:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F7C061574;
        Fri, 17 Sep 2021 07:04:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mRETI-0002CE-9i; Fri, 17 Sep 2021 16:04:08 +0200
Date:   Fri, 17 Sep 2021 16:04:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     "fw@strlen.de" <fw@strlen.de>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Anthony Lineham <Anthony.Lineham@alliedtelesis.co.nz>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Blair Steven <Blair.Steven@alliedtelesis.co.nz>,
        Scott Parlane <Scott.Parlane@alliedtelesis.co.nz>
Subject: Re: [PATCH net v4] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210917140408.GD15906@breakpoint.cc>
References: <20210916041057.459-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210916112641.GC20414@breakpoint.cc>
 <77b0addceb098af07f3bb20fbb708d190ae58b03.camel@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b0addceb098af07f3bb20fbb708d190ae58b03.camel@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> On Thu, 2021-09-16 at 13:26 +0200, Florian Westphal wrote:
> > >range_info.max_proto.all) {
> > 		min = 1;
> > 		max = 65535;
> > 		range_size = 65535;
> > 	} else {
> > 		min = ntohs(nat->range_info.min_proto.all);
> > 		max = ntohs(nat->range_info.max_proto.all);
> > 		range_size = max - min + 1;
> > 	}
> 
> The original code defined the range as [ntohs(exp->saved_proto.tcp.port), 65535]. The above would
> cause a change in behaviour, should we try to avoid it?

Oh indeed, oversight on my part.  Good question, current loop
is not good either as it might take too long to complete.

Maybe best to limit/cap the range to 128, e.g. try to use port
as-is, then pick a random value between 1024 and 65535 - 128,
make 128 tries and if all is taken, error out.

I will leave it up to you on how you'd like to handle this.

One way would be to make a small preparation patch and then
built the range patch on top of it.
