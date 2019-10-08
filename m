Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642E8CF25A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfJHGES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:04:18 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37052 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728297AbfJHGES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:04:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iHibW-0000HF-3h; Tue, 08 Oct 2019 08:04:14 +0200
Date:   Tue, 8 Oct 2019 08:04:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak
 warning"
Message-ID: <20191008060414.GB25052@breakpoint.cc>
References: <20191008053507.252202-1-zenczykowski@gmail.com>
 <20191008053507.252202-2-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191008053507.252202-2-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This reverts commit 114aa35d06d4920c537b72f9fa935de5dd205260.
> 
> By my understanding of kmemleak the reasoning for this patch
> is incorrect.  If kmemleak couldn't handle rcu we'd have it
> reporting leaks all over the place.  My belief is that this
> was instead papering over a real leak.

Perhaps, but note that this is related to nfct->ext, not nfct itself.

I think we could remove __krealloc and use krealloc directly with
a bit of changes in the nf_conntrack core to make sure we do not
access nfct->ext without holding a reference to nfct, and then drop
rcu protection of nfct->ext, I don't think its strictly required anymore.
