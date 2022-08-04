Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0891C5896B7
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 05:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiHDDsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 23:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbiHDDsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 23:48:14 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D7C3A4B2;
        Wed,  3 Aug 2022 20:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C2vVQksbZ1MNoZZ8nE57IM4USVRK+xczEP8c/5HM5jk=; b=Gb37F/noH4vAgJdhC01lTqx7Ha
        FORfGx8GwyI9fy0bYfnLvyaiy9iSA/JWPJOZ2HdfKwGKOXRjmw3jkJioXOieMP3FBk0TptCe5cRGR
        B+qNoTjU87j5ffC6u6HnxsvnAcTygnaqQOg+1PLDOIWMxNLriDgV18fIrUhBopMREJa8tBpH1Y54z
        pPqZsPMsJYmK0cyfN7lv1lJbL+ZK/77TO4hS8nCdi6Gar+iqcVe60p4j3NQ+gVwYyfslnX/IF5WGc
        E3RwFUsvlx2H8DBxQBBTyKUWypu4M0HyuHmAvedjhWRtR7IuJRMnVdskoD2eAAr/F+AVrRpfVaHBK
        KIAW2vpw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oJRq7-00126W-5E;
        Thu, 04 Aug 2022 03:48:03 +0000
Date:   Thu, 4 Aug 2022 04:48:03 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Message-ID: <YutBc9aCQOvPPlWN@ZenIV>
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
 <Yus1SycZxcd+wHwz@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yus1SycZxcd+wHwz@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 03:56:11AM +0100, Al Viro wrote:
> 	Half a year too late, but then it hadn't been posted on fsdevel.
> Which it really should have been, due to
> 
> > +	/* replace tcp socket to smc */
> > +	smcsock->file = tcp->file;
> > +	smcsock->file->private_data = smcsock;
> > +	smcsock->file->f_inode = SOCK_INODE(smcsock); /* replace inode when sock_close */
> > +	smcsock->file->f_path.dentry->d_inode = SOCK_INODE(smcsock); /* dput() in __fput */
> > +	tcp->file = NULL;
> 
> this.  It violates a bunch of rather fundamental assertions about the
> data structures you are playing with, and I'm not even going into the
> lifetime and refcounting issues.
> 
> 	* ->d_inode of a busy positive dentry never changes while refcount
> of dentry remains positive.  A lot of places in VFS rely upon that.
> 	* ->f_inode of a file never changes, period.
> 	* ->private_data of a struct file associated with a socket never
> changes; it can be accessed lockless, with no precautions beyond "make sure
> that refcount of struct file will remain positive".

Consider, BTW, what it does to sockfd_lookup() users.  We grab a reference
to struct file, pick struct socket from its ->private_data, work with that
sucker, then do sockfd_put().  Which does fput(sock->file).

Guess what happens if sockfd_lookup() is given the descriptor of your
TCP socket, just before that tcp->file = NULL?  Right, fput(NULL) as
soon as matching sockfd_put() is called.  And the very first thing fput()
does is this:
        if (atomic_long_dec_and_test(&file->f_count)) {

And that's just one example - a *lot* of places both in VFS and in
net/* rely upon these assertions.  This is really not a workable approach.
