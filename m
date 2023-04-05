Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6F6D85AD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbjDESH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjDESHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:07:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202F7A97;
        Wed,  5 Apr 2023 11:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=xSgARidbSrbR51sAvFluXb6jWPhaQNLco18yBBJHCVc=; b=jAtjuZ4xXNLvq/2JGDp6JgMaoj
        gAIoMFyE/X0Luo1gp4xQwfMCbfXXYJqs9KJFpC/JPosJaOSEEGBfP7XCFxnSlrdvWabT+1URapyAY
        Ge81vkvk+tffke1MO4pzti1k1kK2frr3IYnRnvhpdWoSdKsUxxe0KJ0oi+/O0MyVJ6wuuC6Wl9G5a
        48O9+qRBJqfsCZyUdsRw8vhrs5DpF6Rp2YgmO8mPl9yHp+2/NjNlQFUTxCMEe8Girj0WbIskqD2N3
        98desdq3Sy/t+WLE1UIxIjbP2WCF8vURjMybpg2N0OsD/gvefWtJkoIy3s6uWUv4iIvYgNVyVKon4
        B8VONlNg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pk7XN-00GcaF-Hs; Wed, 05 Apr 2023 18:07:13 +0000
Date:   Wed, 5 Apr 2023 19:07:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Sean Anderson <seanga2@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Message-ID: <ZC240XCeYCaSCu0X@casper.infradead.org>
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
 <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
 <ZC23vf6tNKU1FgRP@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZC23vf6tNKU1FgRP@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 08:02:37PM +0200, Simon Horman wrote:
> On Wed, Apr 05, 2023 at 01:34:11PM -0400, Sean Anderson wrote:
> > On 4/5/23 13:29, Simon Horman wrote:
> > > A recent rearrangement of includes has lead to a problem on m68k
> > > as flagged by the kernel test robot.
> > > 
> > > Resolve this by moving the block asm includes to below linux includes.
> > > A side effect i that non-Sparc asm includes are now immediately
> > > before Sparc asm includes, which seems nice.
> > > 
> > > Using sparse v0.6.4 I was able to reproduce this problem as follows
> > > using the config provided by the kernel test robot:
> > > 
> > > $ wget https://download.01.org/0day-ci/archive/20230404/202304041748.0sQc4K4l-lkp@intel.com/config
> > > $ cp config .config
> > > $ make ARCH=m68k oldconfig
> > > $ make ARCH=m68k C=2 M=drivers/net/ethernet/sun
> > >     CC [M]  drivers/net/ethernet/sun/sunhme.o
> > >   In file included from drivers/net/ethernet/sun/sunhme.c:19:
> > >   ./arch/m68k/include/asm/irq.h:78:11: error: expected ‘;’ before ‘void’
> > >      78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
> > >         |           ^~~~~
> > >         |           ;
> > >   ./arch/m68k/include/asm/irq.h:78:40: warning: ‘struct pt_regs’ declared inside parameter list will not be visible outside of this definition or declaration
> > >      78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
> > >         |                                        ^~~~~~~
> > 
> > This seems like a problem with the header. m68k's asm/irq.h should include linux/interrupt.h before its declarations.
> 
> Hi Sean,
> 
> I do see your point. But TBH I'm unsure which way to go on this one.
> Geert, do you have any input?

We always include linux/* headers before asm/*.  The "sorting" of
headers in this way was inappropriate.
