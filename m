Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB056BA37
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiGHNAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGHNAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:00:54 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8021820BC4
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=uUgQz5drJuRxwq718pUlHf9G0oCeKtbwx5N/3KXL+1w=; b=egqw9Px4AzMTi3neswF9XadCp3
        Dz2rThAKxZZcCYbacQheOGJ5+UBXrpG/mdk+TOMzS/GvOBKKVrjnw/n5OBoeTXuwtUSgwkQJp2tzJ
        PRUGLiZyORX/Xc5CvsY1WXIhyFLl0F346Ddz57Tr1gvuXDci2ljtCXQUcYbbyOcKrAycCogPHIRWY
        Z+Rkz7P+5SlICTJTRRIpSQC8NnjoI8wrTVGUggl0CdZkkSPKiF2DVfFhIDBZTGtZxqlvx4iD8Slow
        A4eoZdC0+UO/TAUF/Ke1mSqhdU2PIG3q2RWLrxtOQGxwxYM637ajy5MdO63kTYEQGEVFDZA4UcNBC
        GxXFglNjOqwuOgrWWJtldLYnqUHPeyDOGZNLss864Lb6BgUFestpPL+DM1GLZK33er8dTQq4HZ+al
        XT3cq6p7xMwku3g5zv/x5mUCZYwsBZgjfxRO4KUDcfB0gT+4DIafwP2r3/LFwPOZCkAhIewSmV2ai
        uX1uud98Ne0Dbf0m5XjDb/hqxPP2ew0jCMXgK6wcy1wc/5ZiUHk1EKGOwr8zfq8I4TaPjv7k7e+SH
        U4DLkvvDe4ochbfZvir889synhHiuRoorvTGPWcxH25LlPqRFUd/+ucdVL6F+6+YydLL+Zw38Z3iT
        2Snv5CtneU6rTYNyr8d+eP3xxd6ht1frNC94aIXd8=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>
Cc:     Greg Kurz <groug@kaod.org>, Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Fri, 08 Jul 2022 15:00:45 +0200
Message-ID: <7969175.Y4Flz6HuuJ@silver>
In-Reply-To: <YsgXtBsfLEQ9dFux@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com> <1690835.L3irNgtgWz@silver>
 <YsgXtBsfLEQ9dFux@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 8. Juli 2022 13:40:36 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Fri, Jul 08, 2022 at 01:18:40PM +0200:
> > On Freitag, 8. Juli 2022 04:26:40 CEST Eric Van Hensbergen wrote:
[...]
> https://github.com/kvmtool/kvmtool indeed has a 9p server, I think I
> used to run it ages ago.
> I'll give it a fresh spin, thanks for the reminder.
> 
> For this one it defines VIRTQUEUE_NUM to 128, so not quite 1024.

Yes, and it does *not* limit client supplied 'msize' either. It just always 
sends the same 'msize' value as-is back to client. :/ So I would expect it to 
error (or worse) if client tries msize > 512kB.

> > > > I found https://github.com/moby/hyperkit for OSX but that doesn't
> > > > really
> > > > help me, and can't see much else relevant in a quick search
> > 
> > So that appears to be a 9p (@virtio-PCI) client for xhyve,
> 
> oh the 9p part is client code?
> the readme says it's a server:
> "It includes a complete hypervisor, based on xhyve/bhyve"
> but I can't run it anyway, so I didn't check very hard.

Hmm, I actually just interpreted this for it to be a client:

fprintf(stderr, "virtio-9p: unexpected EOF writing to server-- did the 9P 
server crash?\n");

But looking at it again, it seems you are right, at least I see that it also 
handles even 9p message type numbers, but only Twrite and Tflush? I don't see 
any Tversion or msize handling in general. [shrug]

> > with max. 256kB buffers <=> max. 68 virtio descriptors (memory segments) 
[1]:
> huh...
> 
> Well, as long as msize is set I assume it'll work out anyway?

If server would limit 'msize' appropriately, yes. But as the kvmtool example 
shows, that should probably not taken for granted.

> How does virtio queue size work with e.g. parallel messages?

Simple question, complicated to answer.

From virtio spec PoV (and current virtio <= v1.2), the negotiated virtio queue 
size defines both the max. amount of parallel (round-trip) messages *and* the 
max. amount of virtio descriptors (memory segments) of *all* currently active/
parallel messages in total. I "think" because of virtio's origin for 
virtualized network devices?

So yes, if you are very strict what the virtio spec <= v1.2 says, and say you 
have a virtio queue size of 128 (e.g. hard coded by QEMU, kvmtool), and say 
client would send out the first 9p request with 128 memory segments, then the 
next (i.e. second) parallel 9p request sent to server would already exceed the 
theoretically allowed max. amount of virtio descriptors.

But in practice, I don't see that this theoretical limitation would exist in 
actual 9p virtio server implementations. At least in all server 
implementations I saw so far, they all seem to handle the max. virtio 
descriptors amount for each request separately.

> Anyway, even if the negotiation part gets done servers won't all get
> implemented in a day, so we need to think of other servers a bit..

OTOH kernel should have the name of the hypervisor/emulator somewhere, right? 
So Linux client's max. virtio descriptors could probably made dependent on 
that name?

Best regards,
Christian Schoenebeck


