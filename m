Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6833D6E36CA
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 11:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjDPJw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjDPJwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 05:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EEF1BDA
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 02:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681638696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3rm3Tx4scnUmIq1Y7/GKTAQGQLeBUUnvNMLalbZs9d4=;
        b=IapjlLR4ztDMDpW+rx6/AS5XEE9FtpM+74iVkFZbyimyneGzYA/SPpEzLbmFSU/eWsaEFb
        FnG+JXq/y/cXMWe9N92eHfzZRjV/eD6EcWhbVqEFZ9Z+8KHQWee0XQ3s0lhOvkeMluKYJx
        jGu5/91WFeguANMV3k5aUG1a2uQe8/8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-pFmwaZ38MRmb-VHaBeYHqg-1; Sun, 16 Apr 2023 05:51:33 -0400
X-MC-Unique: pFmwaZ38MRmb-VHaBeYHqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA6AB185A78F;
        Sun, 16 Apr 2023 09:51:32 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2053614152F6;
        Sun, 16 Apr 2023 09:51:20 +0000 (UTC)
Date:   Sun, 16 Apr 2023 17:51:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        davem@davemloft.net, dccp@vger.kernel.org, dsahern@kernel.org,
        edumazet@google.com, io-uring@vger.kernel.org, kuba@kernel.org,
        leit@fb.com, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com, ming.lei@redhat.com
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Message-ID: <ZDvFEkRo+yor7FM+@ovpn-8-16.pek2.redhat.com>
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com>
 <ZDgyPL6UrX/MaBR4@gmail.com>
 <ZDi2pP4jgHwCvJRm@ovpn-8-21.pek2.redhat.com>
 <44420e92-f629-f56e-f930-475be6f6a83a@gmail.com>
 <ZDlcXd4K+a2iGbnv@ovpn-8-21.pek2.redhat.com>
 <e152d8f0-6bf9-f658-f484-f7a18055a664@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e152d8f0-6bf9-f658-f484-f7a18055a664@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 03:56:47PM +0100, Pavel Begunkov wrote:
> On 4/14/23 14:59, Ming Lei wrote:
> [...]
> > > > Will this kind of inconsistency cause trouble for driver? Cause READ
> > > > TWICE becomes possible with this patch.
> > > 
> > > Right it might happen, and I was keeping that in mind, but it's not
> > > specific to this patch. It won't reload core io_uring bits, and all
> > 
> > It depends if driver reloads core bits or not, anyway the patch exports
> > all fields and opens the window.
> 
> If a driver tries to reload core bits and even worse modify io_uring
> request without proper helpers, it should be rooted out and thrown
> into a bin. In any case cmds are expected to exercise cautiousness
> while working with SQEs as they may change. I'd even argue that
> hiding it as void *cmd makes it much less obvious.

Fair enough, if it is well documented, then people will know these
problems and any change in this area can get careful review.


Thanks, 
Ming

