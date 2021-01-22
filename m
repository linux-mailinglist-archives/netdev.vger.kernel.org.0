Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB7E3002DC
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbhAVM01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbhAVMZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:25:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2BFC06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 04:24:34 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l2vUL-00005a-JL; Fri, 22 Jan 2021 13:24:29 +0100
Date:   Fri, 22 Jan 2021 13:24:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
Subject: Re: tc: u32: Wrong sample hash calculation
Message-ID: <20210122122429.GW3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
 <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
 <20210120152359.GM3158@orbyte.nwl.cc>
 <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On Fri, Jan 22, 2021 at 06:25:22AM -0500, Jamal Hadi Salim wrote:
[...]
> Is this always true though for all scenarios of key > 8b?

Key size reduction algorithms simply differ, and before applying the
divisor the key is reduced to an eight bit value. If the higher bytes
are zero, the result is identical. So for some keys the differences are
irrelevant.

> And is there a pattern that can be deduced?

Something like: 'broken = !!(key >> 8)'? ;)

> My gut feel is user space is the right/easier spot to fix this
> as long as it doesnt break the working setup of 8b.

My motivation to write the initial email was that I don't like the
kernel's key folding as it's basically just cutting off the extra bits.
I am aware that fixing user space is easier, but better distribution of
entries might be worth the extra effort. Given that you didn't point out
any implications with changing u32's key folding in kernel space, I'll
just give it a try.

Thanks, Phil
