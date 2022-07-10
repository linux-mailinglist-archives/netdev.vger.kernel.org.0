Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BCB56CD8D
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 08:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiGJGiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 02:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGJGiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 02:38:14 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43AEBB49D;
        Sat,  9 Jul 2022 23:38:13 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2C094204C41E;
        Sat,  9 Jul 2022 23:38:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2C094204C41E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1657435092;
        bh=VbG2aFZzOBvuXpefJTY7qkZ8KfcxF36UmtS/hmfYQsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfxJx3TxYOTNdcu6ZzlzIwcj/kAC2tn3u7SFCHQevr9PeeAfIUAOcVuu/ZJYwEfCp
         OFQcxvaeTh+VriuYMbDDHApIO+9qCUCWGuWsUWj+wNsdKU2XczmH9Z0LWMBJWHIj9b
         dDMCE9eeocGxbJdv0Op5pMEw6HP/M/n8tQFxa0+A=
Date:   Sun, 10 Jul 2022 01:38:08 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Initialize the iounit field during fid creation
Message-ID: <20220710063808.GB272934@sequoia>
References: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
 <20220710062557.GA272934@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710062557.GA272934@sequoia>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-10 01:26:13, Tyler Hicks wrote:
> On 2022-07-09 15:00:05, Tyler Hicks wrote:
> > Ensure that the fid's iounit field is set to zero when a new fid is
> > created. Certain 9P operations, such as OPEN and CREATE, allow the
> > server to reply with an iounit size which the client code assigns to the
> > fid struct shortly after the fid is created in p9_fid_create(). Other
> > operations that follow a call to p9_fid_create(), such as an XATTRWALK,
> > don't include an iounit value in the reply message from the server. In
> > the latter case, the iounit field remained uninitialized. Depending on
> > allocation patterns, the iounit value could have been something
> > reasonable that was carried over from previously freed fids or, in the
> > worst case, could have been arbitrary values from non-fid related usages
> > of the memory location.
> > 
> > The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> > after the uninitialized iounit field resulted in the typical sequence of
> > two getxattr(2) syscalls, one to get the size of an xattr and another
> > after allocating a sufficiently sized buffer to fit the xattr value, to
> > hit an unexpected ERANGE error in the second call to getxattr(2). An
> > uninitialized iounit field would sometimes force rsize to be smaller
> > than the xattr value size in p9_client_read_once() and the 9P server in
> > WSL refused to chunk up the READ on the attr_fid and, instead, returned
> > ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> > the READ and this problem goes undetected there. However, there are
> > likely other non-xattr implications of this bug that could cause
> > inefficient communication between the client and server.

^ I think this last sentence can be removed. I now believe that this
only affects xattr get/set operations because nothing else calling the
functions that honor iounit is getting the fid directly from a call to
p9_fid_create().

> > 

Please add the following tag:

 Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")

I'm happy to do both of these things in a v2 if any changes/improvements
are requested. Thanks!

Tyler

> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> > ---
> > 
> > Note that I haven't had a chance to identify when this bug was
> > introduced so I don't yet have a proper Fixes tag. The history looked a
> > little tricky to me but I'll have another look in the coming days. We
> > started hitting this bug after trying to move from linux-5.10.y to
> > linux-5.15.y but I didn't see any obvious changes between those two
> > series. I'm not confident of this theory but perhaps the fid refcounting
> > changes impacted the fid allocation patterns enough to uncover the
> > latent bug?
> 
> From reading the source, I believe that this first showed up in commit
> ebf46264a004 ("fs/9p: Add support user. xattr") which landed in v2.6.36.
> Before that commit, p9_client_read(), p9_client_write(), and
> p9_client_readdir() were always passed a fid that came from a file's
> private_data and went through the open/create functions that initialized
> iounit. That commit was the first that passed a fid directly from
> p9_fid_create() to p9_client_read().
> 
> Tyler
