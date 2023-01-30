Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161A9680D79
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbjA3MSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbjA3MS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:18:27 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E2B74D;
        Mon, 30 Jan 2023 04:18:26 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2E41068B05; Mon, 30 Jan 2023 13:18:21 +0100 (CET)
Date:   Mon, 30 Jan 2023 13:18:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 20/23] rxrpc: use bvec_set_page to initialize a bvec
Message-ID: <20230130121820.GA18981@lst.de>
References: <20230130103343.GA11663@lst.de> <20230130092157.1759539-21-hch@lst.de> <20230130092157.1759539-1-hch@lst.de> <3347459.1675074683@warthog.procyon.org.uk> <3351918.1675077855@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3351918.1675077855@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:24:15AM +0000, David Howells wrote:
> Seems to be something people want to do quite a lot and don't know about.

Hmm.  Right now there is one case where it would be used, and there's
about three that are and should be using bio_add_page.

> I've seen places where someone allocates a buffer and clears it just to use as
> a source of zeros.  There's at least one place in cifs, for example.  I know
> about it from wrangling arch code, but most people working on Linux haven't
> done that.

But we don't really need a helper for every possible page use for that.
People just need to learn about ZERO_PAGE.
