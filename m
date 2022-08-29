Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97235A4EC1
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiH2ODb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2OD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:03:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5D9832C8;
        Mon, 29 Aug 2022 07:03:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oSfMG-0000t9-Ln; Mon, 29 Aug 2022 16:03:20 +0200
Date:   Mon, 29 Aug 2022 16:03:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     john.p.donnelly@oracle.com
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        syzkaller@googlegroups.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH nf] netfilter: ebtables: reject blobs that don't provide
 all entry points
Message-ID: <20220829140320.GB27814@breakpoint.cc>
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
 <20220820173555.131326-1-fw@strlen.de>
 <93eca5ab-46ee-241a-b01c-a6131b28ba29@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93eca5ab-46ee-241a-b01c-a6131b28ba29@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

john.p.donnelly@oracle.com <john.p.donnelly@oracle.com> wrote:
> On 8/20/22 12:35 PM, Florian Westphal wrote:
> > For some reason ebtables reject blobs that provide entry points that are
> > not supported by the table.
> > 
> > What it should instead reject is the opposite, i.e. rulesets that
> > DO NOT provide an entry point that is supported by the table.
> > 
> > t->valid_hooks is the bitmask of hooks (input, forward ...) that will
> > see packets.  So, providing an entry point that is not support is
> > harmless (never called/used), but the reverse is NOT, this will cause
> > crash because the ebtables traverser doesn't expect a NULL blob for
> > a location its receiving packets for.
> > 
> > Instead of fixing all the individual checks, do what iptables is doing and
> > reject all blobs that doesn't provide the expected hooks.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Hi,
> 
>  Could you please add the panic stack mentioned above  and syzkaller
> reproducer ID to the commit text ?

I did not see a reproducer ID.  What ended up in the tree is this:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7997eff82828304b780dc0a39707e1946d6f1ebf
