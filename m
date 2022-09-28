Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ADE5EDD4B
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiI1M5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiI1M50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:57:26 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C3B5F9AE;
        Wed, 28 Sep 2022 05:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=pCtCdR4hcSJXdfEpM15FpAxB0Mo5A7EEJ67NwSJQlD4=; b=WitypfhxKF/58dGgak3ePV28B/
        CECE5zOa4g68BOwEybMiWzUgh2lQSafiaBV2qFyMz8gOMuwT4IV4XkNqO1UZfOpESzwm4xEAWte/u
        R3hWHy0ORt6fyyRgaGy2Odv5a54K4lSOH8SCGVCvBNzyd0WMHs2WYt0D6FtDyo6m/K67nAUZ9E9gS
        qRJLWU+ZqcLPVCI3TiUdO5g567g7LJ3n6f9FnOjO3fBXgD8jV+JR4ldxDYSHPNFpHH2U+dsmBu0u4
        MRl3HH/BzdfUMDGobLcUpecgrQCui8v3G/BsIdZSuPgLF8Y+UibNF0Lok8OTHtGei5TNSKv59dAT5
        Y1CZR/vWFMo3C2zYD1wU2ZImYASUdiQwU5R7NeG6KGHvLCP5Hc3y+00cPFqOj/FILyafqPs6vYkPL
        5H8LB0hb/IR+nRtqlNze3u2gjPRgMJ8GglWJmHJwI66fKwHQVJ3sDL9gUgezv/GvAnIbRCI5GtU/b
        ffifn6sVUapBgVBNa8fAiySfZaAyIC6pAgbDgtfDNS/LTl/ZKzpzy37C6Y1qVh8n1GDuaKG3h1iuS
        cTtjb3pxHR5pcfXJRhIWra5suQ/eCXw2PIsUhbmYn5uxXOELlDUt82xbKKEV9EIs5dnmzqA7345uV
        us8/rw0VHUc2l0Rd0z3pG41OB6/SONYUPxrz2bz4k=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, Leon Romanovsky <leon@kernel.org>
Cc:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Date:   Wed, 28 Sep 2022 14:57:07 +0200
Message-ID: <1783490.kFEjeSjHVE@silver>
In-Reply-To: <YzQ12+jtARpwS5bw@unreal>
References: <00000000000015ac7905e97ebaed@google.com> <YzQuoqyGsooyDfId@codewreck.org>
 <YzQ12+jtARpwS5bw@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 28. September 2022 13:54:03 CEST Leon Romanovsky wrote:
> On Wed, Sep 28, 2022 at 08:23:14PM +0900, asmadeus@codewreck.org wrote:
> > Leon Romanovsky wrote on Wed, Sep 28, 2022 at 01:49:19PM +0300:
> > > > But I agree I did get that wrong: trans_mod->close() wasn't called if
> > > > create failed.
> > > > We do want the idr_for_each_entry() that is in p9_client_destroy so
> > > > rather than revert the commit (fix a bug, create a new one..) I'd
> > > > rather
> > > > split it out in an internal function that takes a 'bool close' or
> > > > something to not duplicate the rest.
> > > > (Bit of a nitpick, sure)
> > > 
> > > Please do proper unwind without extra variable.
> > > 
> > > Proper unwind means that you will call to symmetrical functions in
> > > destroy as you used in create:
> > > alloc -> free
> > > create -> close
> > > e.t.c
> > > 
> > > When you use some global function like you did, there is huge chance
> > > to see unwind bugs.
> > 
> > No.
> 
> Let's agree to disagree.
> 
> > Duplicating complicated cleanup code leads to leaks like we used to
> > have; that destroy function already frees up things in the right order.
> 
> It is pretty straightforward code, nothing complex there.
> 
> Just pause for a minute, and ask yourself how totally random guy who
> looked on this syzbot bug just because RDMA name in it, found the issue
> so quickly.
> 
> I will give a hint, I saw not symmetrical error unwind in call trace.

OK, maybe it's just me, but ask yourself Leon, if you were the only guy left 
(i.e. Dominique) still actively taking care for 9p, would those exactly be 
motivating phrases for your efforts? Just saying.

From technical perspective, yes, destruction in reverse order is usually the 
better way to go. Whether I would carve that in stone, without any exception, 
probably not.

Best regards,
Christian Schoenebeck


