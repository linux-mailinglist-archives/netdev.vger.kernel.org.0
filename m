Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22D7589655
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbiHDC43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiHDC40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:56:26 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C326AC4;
        Wed,  3 Aug 2022 19:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DI++b03efWrJd+m3jlb7sTKz4TjX2Yl/VSxHlJaPntE=; b=bZLt07uInORJYXOd8q4w382O6J
        vI7h1HzZJH4s66Dy/TQGXHAhpHQ6uaou8hc6VLN7wOMT+GZX5v6VvPbEE3lrrjkh/20i579v0KCHs
        kOHlOntwGQgS1QGQpDHsUiafRb+vcEFm1iLoG5dHEEwKTupxF4euYQBjWGNWGZAjMCF6u4veD2Zlf
        VuPfhNDM5blAeendPcpSRuN6h/COLbVsDl2nslWIgeNVAughWmCnEMHBvfMkY+WTceiixH/6oBOaL
        OnYlK0G2yN8GrCYBCSewiM2bzR0W0xS1bA0kxsLGmnMgLX4ym6lqz/tzLBHJmrI5rvx0BzhHPQvVl
        JJIv8ORA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oJR1v-0011Ue-B7;
        Thu, 04 Aug 2022 02:56:11 +0000
Date:   Thu, 4 Aug 2022 03:56:11 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Message-ID: <Yus1SycZxcd+wHwz@ZenIV>
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228134435.41774-1-tonylu@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Half a year too late, but then it hadn't been posted on fsdevel.
Which it really should have been, due to

> +	/* replace tcp socket to smc */
> +	smcsock->file = tcp->file;
> +	smcsock->file->private_data = smcsock;
> +	smcsock->file->f_inode = SOCK_INODE(smcsock); /* replace inode when sock_close */
> +	smcsock->file->f_path.dentry->d_inode = SOCK_INODE(smcsock); /* dput() in __fput */
> +	tcp->file = NULL;

this.  It violates a bunch of rather fundamental assertions about the
data structures you are playing with, and I'm not even going into the
lifetime and refcounting issues.

	* ->d_inode of a busy positive dentry never changes while refcount
of dentry remains positive.  A lot of places in VFS rely upon that.
	* ->f_inode of a file never changes, period.
	* ->private_data of a struct file associated with a socket never
changes; it can be accessed lockless, with no precautions beyond "make sure
that refcount of struct file will remain positive".

PS: more than one thread could be calling methods of that struct socket at the
same time; what's to stop e.g. connect(2) on the same sucker (e.g. called on
the same descriptor from a different thread that happens to share the same
descriptor table) to be sitting there trying to lock the struct sock currently
held locked by caller of tcp_set_ulp()?
