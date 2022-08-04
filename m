Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690D5589521
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbiHDAMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiHDALW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:11:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E50BD13D32;
        Wed,  3 Aug 2022 17:11:20 -0700 (PDT)
Date:   Thu, 4 Aug 2022 02:11:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Networking for 6.0
Message-ID: <YusOpd6IuLB29LHs@salvia>
References: <20220803101438.24327-1-pabeni@redhat.com>
 <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 04:52:32PM -0700, Linus Torvalds wrote:
> On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0
> 
> Hmm. Another thing I note about this.
> 
> It adds a new NF_FLOW_TABLE_PROCFS option, and that one has two problems:
> 
>  - it is 'default y'. Why?
>
>  - it has 'depends on PROC_FS' etc, but guess what it does *not*
> depend on? NF_FLOW_TABLE itself.

For these two questions, this new Kconfig toggle was copied from:

 config NF_CONNTRACK_PROCFS
        bool "Supply CT list in procfs (OBSOLETE)"
        default y
        depends on PROC_FS

which is under:

 if NF_CONNTRACK

but the copy and paste was missing this.

> So not only does this new code try to enable itself by default, which
> is a no-no. We do "default y" if it's an old feature that got split
> out as a config option, or if it's something that everybody *really*
> should have, but I don't see that being the case here.
> 
> But it also asks the user that question even when the user doesn't
> even have NF_FLOW_TABLE at all. Which seems entirely crazy.
> 
> Am I missing something? Because it looks *completely* broken.
> 
> I've said this before, and I'll say this again: our kernel config is
> hard on users as-is, and we really shouldn't make it worse by making
> it ask invalid questions or have invalid defaults.

Completely agree. Patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220804000843.86722-1-pablo@netfilter.org/

Thanks for reviewing.


