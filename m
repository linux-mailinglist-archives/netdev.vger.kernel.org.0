Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A7E59615C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiHPRmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiHPRmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:42:51 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D32880F53
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660671770; x=1692207770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTf1uZ8+p9dkAjrbtwA4e8bpKEjWHYMAg+iF4VSot6g=;
  b=a2OQ43RHqjvUqxoaaEM+035mRV2sF05B/57tkkWBp9Zvpe/ekw4lpV0u
   zW8FjSTxRz9rdsn76VDJSEIXhlI/LRpVj2zBqYnlG+GtxXhtfQ7iJFWzx
   N6W3+BvVEDGHdiFx0UH1xdhAiZ5A1kZszk6gqYvbClc4ue1AaX4bOWYH3
   4=;
X-IronPort-AV: E=Sophos;i="5.93,241,1654560000"; 
   d="scan'208";a="230345203"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 17:42:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com (Postfix) with ESMTPS id CA43280293;
        Tue, 16 Aug 2022 17:42:47 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 17:42:47 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.201) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 17:42:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <david.laight@aculab.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <tkhai@ya.ru>, <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v2 1/2] fs: Export __receive_fd()
Date:   Tue, 16 Aug 2022 10:42:37 -0700
Message-ID: <20220816174237.99392-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3d655b0e4d4d4c2991f54c79b1f50ccd@AcuMS.aculab.com>
References: <3d655b0e4d4d4c2991f54c79b1f50ccd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.201]
X-ClientProxiedBy: EX13D06UWC004.ant.amazon.com (10.43.162.97) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Laight <David.Laight@ACULAB.COM>
Date:   Tue, 16 Aug 2022 17:29:53 +0000
> From: Kuniyuki Iwashima
> > Sent: 16 August 2022 18:15
> > 
> > From:   David Laight <David.Laight@ACULAB.COM>
> > Date:   Tue, 16 Aug 2022 08:03:14 +0000
> > > From: Kirill Tkhai
> > > > Sent: 15 August 2022 22:15
> > > >
> > > > This is needed to make receive_fd_user() available in modules, and it will be used in next patch.
> > > >
> > > > Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> > > > ---
> > > > v2: New
> > > >  fs/file.c |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/fs/file.c b/fs/file.c
> > > > index 3bcc1ecc314a..e45d45f1dd45 100644
> > > > --- a/fs/file.c
> > > > +++ b/fs/file.c
> > > > @@ -1181,6 +1181,7 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> > > >  	__receive_sock(file);
> > > >  	return new_fd;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(__receive_fd);
> > >
> > > It doesn't seem right (to me) to be exporting a function
> > > with a __ prefix.
> > 
> > +1.
> > Now receive_fd() has inline and it's the problem.
> > Can we avoid this by moving receive_fd() in fs/file.c without inline and
> > exporting it?
> 
> It looks like it is receive_fd_user() that should be made a real
> function and then exported.

Right, I did wrong copy-and-paste :p


> __receive_fd() can then be static.
> The extra function call will be noise - and the compiler may
> well either tail-call it or inline different copies of __receive_fd()
> into the two callers.
