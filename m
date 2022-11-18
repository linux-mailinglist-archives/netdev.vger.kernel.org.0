Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3B62F28E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbiKRK3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiKRK3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:29:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C47D18B3D;
        Fri, 18 Nov 2022 02:29:29 -0800 (PST)
Date:   Fri, 18 Nov 2022 11:29:25 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     fw@strlen.de, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: ctmark: Fix data-races around ctmark
Message-ID: <Y3dehd619g/2vlWv@salvia>
References: <7220acad9aaefa2ab891d1bcbbc9d5cc4a8f0a7e.1668022522.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7220acad9aaefa2ab891d1bcbbc9d5cc4a8f0a7e.1668022522.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 12:39:07PM -0700, Daniel Xu wrote:
> nf_conn:mark can be read from and written to in parallel. Use
> READ_ONCE()/WRITE_ONCE() for reads and writes to prevent unwanted
> compiler optimizations.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
> Changes since v1:
> - Remove WRITE_ONCE() from init path
> 
>  net/core/flow_dissector.c               |  2 +-
>  net/ipv4/netfilter/ipt_CLUSTERIP.c      |  4 ++--
>  net/netfilter/nf_conntrack_core.c       |  2 +-
>  net/netfilter/nf_conntrack_netlink.c    | 24 ++++++++++++++----------
>  net/netfilter/nf_conntrack_standalone.c |  2 +-
>  net/netfilter/nft_ct.c                  |  6 +++---
>  net/netfilter/xt_connmark.c             | 18 ++++++++++--------
>  net/openvswitch/conntrack.c             |  8 ++++----
>  net/sched/act_connmark.c                |  4 ++--
>  net/sched/act_ct.c                      |  8 ++++----
>  net/sched/act_ctinfo.c                  |  6 +++---
>  11 files changed, 45 insertions(+), 39 deletions(-)

I am going to place this in nf.git, it's a bit late but it's
relatively small and I think the sooner the better to have this fix.
