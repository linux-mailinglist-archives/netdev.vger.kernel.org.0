Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A112D670EA1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjARAcY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Jan 2023 19:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjARAcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:32:02 -0500
X-Greylist: delayed 604 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Jan 2023 15:57:20 PST
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D0144BF2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:57:20 -0800 (PST)
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay04.hostedemail.com (Postfix) with ESMTP id B2DC11A096B;
        Tue, 17 Jan 2023 23:47:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 939102000D;
        Tue, 17 Jan 2023 23:47:11 +0000 (UTC)
Message-ID: <6573e9e23324291b83e81de9659a50c86b55502b.camel@perches.com>
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3
 block close
From:   Joe Perches <joe@perches.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Willem de Bruijn <willemb@google.com>,
        Andy Whitcroft <apw@canonical.com>
Date:   Tue, 17 Jan 2023 15:47:09 -0800
In-Reply-To: <CAF=yD-LMO5Y1Uith1jsbh1kOO3t4oagTnKSdKoM=gQkfd61oAA@mail.gmail.com>
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
         <5f494ec3-9435-b9dc-6dd8-9e1b7354430d@intel.com>
         <CAF=yD-LMO5Y1Uith1jsbh1kOO3t4oagTnKSdKoM=gQkfd61oAA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 939102000D
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Rspamd-Server: rspamout03
X-Stat-Signature: o59petzqy3dzy7pxjx3qu85imforipfh
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+6Ak8WyIfvmleVsucsZ+K1zMV2zZfZLtc=
X-HE-Tag: 1673999231-646028
X-HE-Meta: U2FsdGVkX18zg5LcV8xtXc3+CDdUDeiEiX8sOKnDiOQoK/whM6PPA3ElanXau49WUytRN7pJ6XFiOlOGtRUQYA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-17 at 14:15 -0500, Willem de Bruijn wrote:
> > On 1/16/2023 9:40 AM, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > > 
> > > Avoid race between process wakeup and tpacket_v3 block timeout.
> > > 
> > > The test waits for cfg_timeout_msec for packets to arrive. Packets
> > > arrive in tpacket_v3 rings, which pass packets ("frames") to the
> > > process in batches ("blocks"). The sk waits for
> > > req3.tp_retire_blk_tov
> > > msec to release a block.
> > > 
> > > Set the block timeout lower than the process waiting time, else
> > > the process may find that no block has been released by the time
> > > it
> > > scans the socket list. Convert to a ring of more than one,
> > > smaller,
> > > blocks with shorter timeouts. Blocks must be page aligned, so >=
> > > 64KB.
> > > 
> > > Somewhat awkward while () notation dictated by checkpatch: no
> > > empty
> > > braces allowed, nor statement on the same line as the condition.
> > > 
> > > Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >  tools/testing/selftests/net/toeplitz.c | 13 ++++++++-----
> > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/net/toeplitz.c
> > > b/tools/testing/selftests/net/toeplitz.c
> > > index 90026a27eac0c..66f7f6568643a 100644
> > > --- a/tools/testing/selftests/net/toeplitz.c
> > > +++ b/tools/testing/selftests/net/toeplitz.c
> > > @@ -215,7 +215,7 @@ static char *recv_frame(const struct
> > > ring_state *ring, char *frame)
> > >  }
> > > 
> > >  /* A single TPACKET_V3 block can hold multiple frames */
> > > -static void recv_block(struct ring_state *ring)
> > > +static bool recv_block(struct ring_state *ring)
> > >  {
> > >       struct tpacket_block_desc *block;
> > >       char *frame;
> > > @@ -223,7 +223,7 @@ static void recv_block(struct ring_state
> > > *ring)
> > > 
> > >       block = (void *)(ring->mmap + ring->idx * ring_block_sz);
> > >       if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
> > > -             return;
> > > +             return false;
> > > 
> > >       frame = (char *)block;
> > >       frame += block->hdr.bh1.offset_to_first_pkt;
> > > @@ -235,6 +235,8 @@ static void recv_block(struct ring_state
> > > *ring)
> > > 
> > >       block->hdr.bh1.block_status = TP_STATUS_KERNEL;
> > >       ring->idx = (ring->idx + 1) % ring_block_nr;
> > > +
> > > +     return true;
> > >  }
> > > 
> > >  /* simple test: sleep once unconditionally and then process all
> > > rings */
> > > @@ -245,7 +247,8 @@ static void process_rings(void)
> > >       usleep(1000 * cfg_timeout_msec);
> > > 
> > >       for (i = 0; i < num_cpus; i++)
> > > -             recv_block(&rings[i]);
> > > +             while (recv_block(&rings[i]))
> > > +                     ;
> > 
> > I'd rather have one of
> > 
> >   while (recv_block(&rings[i]));
> > 
> > or
> > 
> >   while (recv_block(&rings[i])) {}
> > 
> > or even (but less preferred:
> > 
> >   do {} (while (recv_block(&rings[i]));
> > 
> > instead of  this ; on its own line.
> > 
> > Even if this violates checkpatch attempts to catch other bad style
> > this
> > is preferable to the lone ';' on its own line.
> > 
> > If necessary we can/should change checkpatch to allow the idiomatic
> > approach.

To me it's a 'Don't care'.

There are many hundreds of these in the kernel and there is no
valid reason to require a particular style.

$ git grep -P  '^\t+;\s*$' -- '*.c' | wc -l
871

