Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EAB648D12
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLJELc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLJELb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:11:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7685470B96
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 20:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C449D601BC
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13DCC433F0;
        Sat, 10 Dec 2022 04:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670645489;
        bh=7EHxyJ4yUo3vl6S2WStImjLPO2WOPzY7RGUVjBF5k9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D4hfzPNpot0KUgm+NWm5DTvm1yYVYSr7jYmm8Qkzz3MNgxERJtVMfjfe6CQHc5dt1
         3G0sH/+tOUHn31jU4TGwsdBw7iBzxS6FCHEqAPae5yLX6PrKens6Y3R1vjxJvk3QE8
         GBFZ/cTG9yT9ZKR7ZDnv1SbkXIyGBVHP0hY66x9/hkB/RFxAsdKnrYTObnu9TDDTIQ
         xcj6DT8qtOxjpVb2cEiqd1XkCYB2pS83xsjfAT5qBagewo2xTsHGxYIoYmUEhT8/XN
         VAlVmi4LMIrsOFL9D+h1pwdl1NbyRDrabAj/pL2gV4hFyr1PqTZXlwuMQOZWLOk1py
         4MZn9Cw31w9RA==
Date:   Fri, 9 Dec 2022 20:11:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?UTF-8?B?QsO2aG13YWxkZXI=?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: Introduce sk_use_task_frag in struct
 sock.
Message-ID: <20221209201127.65dc2cdb@kernel.org>
In-Reply-To: <774369bc01dd625aec8202a47ba38008c43b003d.1670609077.git.bcodding@redhat.com>
References: <cover.1670609077.git.bcodding@redhat.com>
        <774369bc01dd625aec8202a47ba38008c43b003d.1670609077.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Dec 2022 13:19:23 -0500 Benjamin Coddington wrote:
> +  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
> +			   Sockets that can be used under memory reclaim should
> +			   set this to false.

sorry to nit pick but kernel-doc does not like the lack of * at the
start of these lines:

include/net/sock.h:322: warning: bad line:                            Sockets that can be used under memory reclaim should
include/net/sock.h:323: warning: bad line:                            set this to false.
