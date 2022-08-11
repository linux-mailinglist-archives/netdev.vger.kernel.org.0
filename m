Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDEB58FA11
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiHKJ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiHKJ3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:29:42 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7373692F54;
        Thu, 11 Aug 2022 02:29:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VLybihx_1660210174;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VLybihx_1660210174)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 17:29:35 +0800
Date:   Thu, 11 Aug 2022 17:29:34 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Message-ID: <YvTL/sf6lrhuGDuy@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
 <Yus1SycZxcd+wHwz@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yus1SycZxcd+wHwz@ZenIV>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
>
> PS: more than one thread could be calling methods of that struct socket at the
> same time; what's to stop e.g. connect(2) on the same sucker (e.g. called on
> the same descriptor from a different thread that happens to share the same
> descriptor table) to be sitting there trying to lock the struct sock currently
> held locked by caller of tcp_set_ulp()?

Sorry for the late reply.

SMC ULP tries to make original TCP sockets behave like SMC. The original
TCP sockets will belong to this new SMC socket, and it can only be
accessed in kernel with struct socket in SMC. The SMC and TCP sockets are
bonded together.

So this patch replaces the file of TCP to SMC socket which is allocated
in kernel. It is guaranteed that the TCP socket is always freed before
the newly replaced SMC socket.

There is an other approach to archive this by changing af_ops of sockets.
I will fix it without breaking the assertions.

Tony Lu
