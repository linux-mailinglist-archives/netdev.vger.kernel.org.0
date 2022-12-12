Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559FC64AB3F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiLLXOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiLLXOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C30C48
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB90B80EC1
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76A8C433EF;
        Mon, 12 Dec 2022 23:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886877;
        bh=8Iud0Iqu9JJY+RHtIc/cDRjThAndQJI4b4nJjK1ldU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=caZ40ALXYQEVgViajiHFmtPZ/uTPGC4DCjA6hXFiXeSOJAS3UXD7o4EJ95fFXc1N5
         VeipkP1vAQSWd6rIq1lt/vKv3W6F7nrHuGvZ1lH35+IbR9Et9rPzhdN8JGmDFtr1Lq
         JHr/Tr3bBDIOu7vP+gauN7MGQf7sdjyO+9P4Pr+/EY/z53M/xZ1wSuj9GeovteUFfr
         gPX3U5xuKDdQp4EwOGTuvUUaL5+0vi/78sISK6llDRpDh+mQvotaaopLzyhMvHZM9l
         OPMQfPKufVaMKayITjByYhmhZ20OcWH71zrQsYj0JDWFQBToU17CYjCEZRlGpwRjhX
         JqkqALclnvTLA==
Date:   Mon, 12 Dec 2022 15:14:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: [PATCH net v3 1/3] net: Introduce sk_use_task_frag in struct
 sock.
Message-ID: <20221212151434.71617530@kernel.org>
In-Reply-To: <1a369325ac2d4a604a074428f58fa72a6065e197.1670756903.git.bcodding@redhat.com>
References: <20221209201127.65dc2cdb@kernel.org>
        <1a369325ac2d4a604a074428f58fa72a6065e197.1670756903.git.bcodding@redhat.com>
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

On Sun, 11 Dec 2022 06:20:03 -0500 Benjamin Coddington wrote:
> [PATCH net v3 1/3] net: Introduce sk_use_task_frag in struct sock.

You need to repost the entire series, please.
