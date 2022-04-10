Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CE94FAE92
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbiDJPoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 11:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbiDJPoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 11:44:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6433FD33;
        Sun, 10 Apr 2022 08:41:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ndZhA-0004Ms-Mb; Sun, 10 Apr 2022 17:41:44 +0200
Date:   Sun, 10 Apr 2022 17:41:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Mark Mielke <mark.mielke@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Ensure nf_ct_put is not called with null
 pointer
Message-ID: <YlL6uN9WDPtFri0p@strlen.de>
References: <20220409094036.20051-1-mark.mielke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409094036.20051-1-mark.mielke@gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark Mielke <mark.mielke@gmail.com> wrote:
> A recent commit replaced calls to nf_conntrack_put() with calls
> to nf_ct_put(). nf_conntrack_put() permitted the caller to pass
> null without side effects, while nf_ct_put() performs WARN_ON()
> and proceeds to try and de-reference the pointer. ovs-vswitchd
> triggers the warning on startup:
> 
> [   22.178881] WARNING: CPU: 69 PID: 2157 at include/net/netfilter/nf_conntrack.h:176 __ovs_ct_lookup+0x4e2/0x6a0 [openvswitch]
> ...
> [   22.213573] Call Trace:
> [   22.214318]  <TASK>
> [   22.215064]  ovs_ct_execute+0x49c/0x7f0 [openvswitch]
> ...
> Cc: stable@vger.kernel.org
> Fixes: 408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")

Actually, no.  As Pablo Neira just pointed out to me Upstream kernel is fine.
The preceeding commit made nf_ct_out() a noop when ct is NULL.
