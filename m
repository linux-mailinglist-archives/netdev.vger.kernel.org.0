Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04F06493DB
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiLKLVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiLKLU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8137DC776
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670757600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9u74SX/yxedJP+nMBoKKBQ6urgezrZB9IhgcVA+fsE=;
        b=LjEFxMCJP6jzDthkkmQ2b5AFweKbIOOsVusvfAhiIHFcJgU91WtR1FbvNneaGOhnw09dem
        GybtDHsZfcsFJPMpDZH2fvfFLd2uWaFN6Z/pTtPJb5YSBt6MtFL30t5IPQkfecE0qEiNtP
        oJRfA5LouRC+fjXeW2TQ7yxM/fn52iw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-m9iY4DbKOIy4jJzs980FVQ-1; Sun, 11 Dec 2022 06:19:55 -0500
X-MC-Unique: m9iY4DbKOIy4jJzs980FVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F4BB8037A6;
        Sun, 11 Dec 2022 11:19:53 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AC7E40C6EC2;
        Sun, 11 Dec 2022 11:19:45 +0000 (UTC)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?utf-8?q?Christoph_B=C3=B6hmwalder?= 
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
Date:   Sun, 11 Dec 2022 06:19:42 -0500
Message-ID: <719D1BBA-6870-43A9-9AA0-7B8E64C019D9@redhat.com>
In-Reply-To: <20221209201127.65dc2cdb@kernel.org>
References: <cover.1670609077.git.bcodding@redhat.com>
 <774369bc01dd625aec8202a47ba38008c43b003d.1670609077.git.bcodding@redhat.com>
 <20221209201127.65dc2cdb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9 Dec 2022, at 23:11, Jakub Kicinski wrote:

> On Fri,  9 Dec 2022 13:19:23 -0500 Benjamin Coddington wrote:
>> +  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag=
=2E
>> +			   Sockets that can be used under memory reclaim should
>> +			   set this to false.
>
> sorry to nit pick but kernel-doc does not like the lack of * at the
> start of these lines:
>
> include/net/sock.h:322: warning: bad line:                            S=
ockets that can be used under memory reclaim should
> include/net/sock.h:323: warning: bad line:                            s=
et this to false.

Sorry about that -- I'll send a v3 for this patch here.

Ben

