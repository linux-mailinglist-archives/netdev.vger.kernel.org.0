Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844AD5427F1
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiFHHYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353920AbiFHGSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:18:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CF4D132A28;
        Tue,  7 Jun 2022 23:03:31 -0700 (PDT)
Date:   Wed, 8 Jun 2022 08:03:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 7/7] netfilter: nf_tables: bail out early if hardware
 offload is not supported
Message-ID: <YqA7lOw8CKNMaQ28@salvia>
References: <20220606212055.98300-1-pablo@netfilter.org>
 <20220606212055.98300-8-pablo@netfilter.org>
 <20220607180025.6bd26267@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220607180025.6bd26267@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Jun 07, 2022 at 06:00:25PM -0700, Jakub Kicinski wrote:
> On Mon,  6 Jun 2022 23:20:55 +0200 Pablo Neira Ayuso wrote:
> > If user requests for NFT_CHAIN_HW_OFFLOAD, then check if either device
> > provides the .ndo_setup_tc interface or there is an indirect flow block
> > that has been registered. Otherwise, bail out early from the preparation
> > phase. Moreover, validate that family == NFPROTO_NETDEV and hook is
> > NF_NETDEV_INGRESS.
> 
> The whole series is pretty light on the "why".

  - [net,1/7] netfilter: nat: really support inet nat without l3 address
    https://git.kernel.org/netdev/net/c/282e5f8fe907

  This is a fix, otherwise NAT with the inet family (which allows both
  IPv4 and IPv6 traffic) remains broken. It's a datapath fix, the
  control plane was accepting the rule, however NAT was not applied if
  user specified no layer 4 address, which might happen for, eg. redirect.

  - [net,2/7] netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
    https://git.kernel.org/netdev/net/c/ab5e5c062f67

  This is an incremental fix for f9a43007d3f7 ("netfilter: nf_tables:
  double hook unregistration in netns path"), it is using kfree_rcu(ptr)
  variant which works but it has some limitations. Use of free_rcu(ptr)
  was not intentional, hence free_rcu(ptr, rcu)

  - [net,3/7] netfilter: nf_tables: delete flowtable hooks via transaction list
    https://git.kernel.org/netdev/net/c/b6d9014a3335

  Deleting twice the same device on the flowtable might lead to ENOENT
  since hook->inactive is not honored. Instead of honoring such flag,
  this patch is fixing up this by using a flowtable hook list in the
  transaction object to convey the hook that are going to be deleted
  which looks cleaner to me.

  - [net,4/7] netfilter: nf_tables: always initialize flowtable hook list in transaction
    https://git.kernel.org/netdev/net/c/2c9e4559773c

  This is a oneliner, not urgent but Florian already reported in the
  past that the flowtable hook list in the transaction object was not
  initialized (even if not used). This patch initializes it to
  increase robustness, this list is going to be empty/unused for the
  non-update path anyway. Arguably I could have postpone this
  oneliner.

  - [net,5/7] netfilter: nf_tables: release new hooks on unsupported flowtable flags
    https://git.kernel.org/netdev/net/c/c271cc9febaa

  This is a fix. nft_flowtable_parse_hook() populates the hook list,
  but the flowtable flags update logic was not releasing these objects
  from the error path, hence, leading to a memleak.

  - [net,6/7] netfilter: nf_tables: memleak flow rule from commit path
    https://git.kernel.org/netdev/net/c/9dd732e0bdf5

  kmemleak reported this memleak while running a series of test with
  nf_tables hardware offload support for these objects, this is a fix.

> This patch is particularly bad, no idea what the user visible bug
> was here.

  Are you refering to this?

  - [net,7/7] netfilter: nf_tables: bail out early if hardware offload is not supported
    https://git.kernel.org/netdev/net/c/3a41c64d9c11

  Arguably, I could have postponed this patch, but quite recently
  there was a silly bug in the hardware offload infrastructure, see
  b1a5983f56e3 ("netfilter: nf_tables_offload: incorrect flow offload
  action array size. The reporter triggered the bug with the _loopback
  interface_, he wondered why this infrastructure is exposed to all
  devices while only a dozen of NICs support hardware offload, hence
  this patch to disable hardware offload earlier in the control plane
  path.
