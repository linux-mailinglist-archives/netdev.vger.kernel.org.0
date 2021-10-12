Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669B542A19E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhJLKES convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Oct 2021 06:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbhJLKEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:04:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C160C061570;
        Tue, 12 Oct 2021 03:02:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1maEbk-00068g-Tu; Tue, 12 Oct 2021 12:02:05 +0200
Date:   Tue, 12 Oct 2021 12:02:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Message-ID: <20211012100204.GB2942@breakpoint.cc>
References: <346934f2ad88d64589fa9a942aed844443cf7110.1634028240.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <346934f2ad88d64589fa9a942aed844443cf7110.1634028240.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
> only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
> The access by ((const struct rt0_hdr *)rh)->reserved will overflow
> the buffer. So this access should be moved below the 2nd call to
> skb_header_pointer().
> 
> Besides, after the 2nd skb_header_pointer(), its return value should
> also be checked, othersize, *rp may cause null-pointer-ref.

Patch looks good but I think you can just axe these pr_debug statements
instead of moving them.

Before pr_debug conversion these statments were #if-0 out, I don't think
they'll be missed if they are removed.

