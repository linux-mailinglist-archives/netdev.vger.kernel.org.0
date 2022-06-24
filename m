Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5A7558C43
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiFXA3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 20:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiFXA3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 20:29:38 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E3A424B1;
        Thu, 23 Jun 2022 17:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kfktLyJGFbdGRMR4t6fGt+oJoBpkUKK2mMpGpmGBT0c=; b=OjRm91aTcOgezr61Ir6vqcW3Pu
        7Ts3LFVf7W4J6h8kC+ovTXp00Bv0su29ZPF/lCEXD/5/KxKwJwxskMLYRXgR6GTtJduh8Yl2qOWqE
        FoLfq8lt26NSN8bzF+UV2EeW8zNeAo/L3Av0rTz9HKRzNqpLiMLcX4vF7vwi4bQoUftmwbqrAY4nW
        t9jIoei+lRuKcix/dSF0494Zmrg/KyQBpOO7zVOfc0bhDO2j1TTdQhWFC1P8jLM7gpBgVVkP/J0mK
        7uYIfSj1kp9K4CkOy9p6WYaa9ZQ1iJHzkSdLu0gebOC3Fa/dYIe6EOUXamvY/lQwtJs670GZzdl3Y
        BlFOTnuQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1o4XCW-003ieU-42;
        Fri, 24 Jun 2022 00:29:32 +0000
Date:   Fri, 24 Jun 2022 01:29:32 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Message-ID: <YrUFbLJ5uVbWtZbf@ZenIV>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
 <YrTvq2ED+Xugqpyi@ZenIV>
 <1E65ABAA-C9D9-41F3-A93C-086381A78F10@oracle.com>
 <4417FB68-83C9-43DC-BB57-122D405302E7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4417FB68-83C9-43DC-BB57-122D405302E7@oracle.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:14:53AM +0000, Chuck Lever III wrote:
> 
> > On Jun 23, 2022, at 7:51 PM, Chuck Lever III <chuck.lever@oracle.com> wrote:
> > 
> >> On Jun 23, 2022, at 6:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> 
> >> On Wed, Jun 22, 2022 at 10:15:50AM -0400, Chuck Lever wrote:
> >> 
> >>> +static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
> >>> +{
> >>> +	const struct nfsd_file *nf = data;
> >>> +
> >>> +	return jhash2((const u32 *)&nf->nf_inode,
> >>> +		      sizeof_field(struct nfsd_file, nf_inode) / sizeof(u32),
> >>> +		      seed);
> >> 
> >> Out of curiosity - what are you using to allocate those?  Because if
> >> it's a slab, then middle bits of address (i.e. lower bits of
> >> (unsigned long)data / L1_CACHE_BYTES) would better be random enough...
> > 
> > 261 static struct nfsd_file *
> > 262 nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
> > 263 {
> > 264         static atomic_t nfsd_file_id;
> > 265         struct nfsd_file *nf;
> > 266 
> > 267         nf = kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
> > 
> > Was wondering about that. pahole says struct nfsd_file is 112
> > bytes on my system.
> 
> Oops. nfsd_file_obj_hashfn() is supposed to be generating the
> hash value based on the address stored in the nf_inode field.
> So it's an inode pointer, alloced via kmem_cache_alloc by default.

inode pointers are definitely "divide by L1_CACHE_BYTES and take lower
bits" fodder...
