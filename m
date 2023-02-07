Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4846268DE38
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBGQvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGQvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:51:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8062367D
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675788630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux0mmfKkphxoPa36aiTHBWDRHrPHYlMhgTpD+S7fBoM=;
        b=QlT9vKFe34eBEFn3PctQl+jMojGBmZJzv9GKds2gX6qjhixKbYaXBTfSVpFcjmUOK7iTrh
        9jNAoKIrQlg5/TpA0qvtIbutaOIhjQv2Zi4kvsT1u8znwk7mNnu3eB6bZwUGM/t2xDw8cg
        7ikFVFnFJJ0EAL9pXXjO4m/OQzwGnRU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-MuBUBqIeM6abu69YFhxkdg-1; Tue, 07 Feb 2023 11:50:29 -0500
X-MC-Unique: MuBUBqIeM6abu69YFhxkdg-1
Received: by mail-pf1-f199.google.com with SMTP id v23-20020aa78097000000b005748c087db1so8340899pff.2
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 08:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ux0mmfKkphxoPa36aiTHBWDRHrPHYlMhgTpD+S7fBoM=;
        b=Zs2Z6liyD6Ue1BMwYFF7D7k1SkVdYmpV1B+ipOUsoI5jTs94jD4wLFhnpQ9q3nqfoN
         hOguwSdX2bBfvK6Xk/LLGyciL2QRAT6yrmZSlW3Igpr588Q1NzxTl0dRkfmaZxYom4kT
         X/IP+MAZK6y6h+YmDDLVha4cu0wVXr1ks0m8gjS1uhKesj2emOBTcf6KrDKLgR0al5Wl
         5apxNPG4txTDBTF5WMloI6KTSqMk6Ok1geVMEYvdoc9/XStxzhKxqzmZjSVoaOhULrSl
         t4oXHuJIbDdZ7D/ZOXyAfWUX8QQBUSSm7QqpSvmtp0cu6jXGxFpdUMyOlu5nyRh0Y73p
         2Gdw==
X-Gm-Message-State: AO0yUKVLR+191cY1D4ll9AoQaONp5cmir+KSpaVPZheJcuJFyxJZn98B
        EOcsMlnler9nreboyBHe1AuvT57wUrtEndHiFM4fbVPWTYUElfu4KEwWfjeQW2eUDHMnrrdnLSJ
        267r7YmDjlil3Lium
X-Received: by 2002:a17:902:c755:b0:199:1c65:2c42 with SMTP id q21-20020a170902c75500b001991c652c42mr2807578plq.12.1675788628192;
        Tue, 07 Feb 2023 08:50:28 -0800 (PST)
X-Google-Smtp-Source: AK7set9Ecof491y5T7KAvJJUvUguy2ifRnXyA0sF5o/encxu7p8vkz0C0zDmDQbUpwpa2sUuQuIStQ==
X-Received: by 2002:a17:902:c755:b0:199:1c65:2c42 with SMTP id q21-20020a170902c75500b001991c652c42mr2807560plq.12.1675788627852;
        Tue, 07 Feb 2023 08:50:27 -0800 (PST)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ff0100b0019602dd914csm6689293plj.180.2023.02.07.08.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:50:27 -0800 (PST)
Date:   Wed, 8 Feb 2023 01:50:22 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+KBTktdS8WLV/3/@kernel-devel>
References: <20230130154438.1373750-1-syoshida@redhat.com>
 <Y9f4eAhcJXhh0+c2@debian>
 <Y9qItT82LcJdJVlF@kernel-devel>
 <Y9voRRiiWK/V7WQD@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9voRRiiWK/V7WQD@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume,

On Thu, Feb 02, 2023 at 05:43:49PM +0100, Guillaume Nault wrote:
> On Thu, Feb 02, 2023 at 12:43:49AM +0900, Shigeru Yoshida wrote:
> > Hi Guillaume,
> > 
> > On Mon, Jan 30, 2023 at 06:03:52PM +0100, Guillaume Nault wrote:
> > > On Tue, Jan 31, 2023 at 12:44:38AM +0900, Shigeru Yoshida wrote:
> > > > This patch fixes the issue by returning error when a pppol2tp socket
> > > > itself is passed.
> > > 
> > > Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
> > > 
> > > > Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> > > > ---
> > > >  net/l2tp/l2tp_ppp.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
> > > > index db2e584c625e..88d1a339500b 100644
> > > > --- a/net/l2tp/l2tp_ppp.c
> > > > +++ b/net/l2tp/l2tp_ppp.c
> > > > @@ -702,11 +702,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
> > > >  			struct l2tp_tunnel_cfg tcfg = {
> > > >  				.encap = L2TP_ENCAPTYPE_UDP,
> > > >  			};
> > > > +			int dummy = 0;
> > > 
> > > There's no need to initialise dummy here. This is just confusing.
> > > We could even do without any extra variable and reuse error in
> > > sockfd_lookup().
> > > 
> > > >  			/* Prevent l2tp_tunnel_register() from trying to set up
> > > > -			 * a kernel socket.
> > > > +			 * a kernel socket.  Also, prevent l2tp_tunnel_register()
> > > > +			 * from trying to use pppol2tp socket itself.
> > > >  			 */
> > > > -			if (info.fd < 0) {
> > > > +			if (info.fd < 0 ||
> > > > +			    sock == sockfd_lookup(info.fd, &dummy)) {
> > > >  				error = -EBADF;
> > > >  				goto end;
> > > >  			}
> > > 
> > > That should work, but the real problem is calling l2tp_tunnel_register()
> > > under lock_sock(). We should instead get/create the tunnel before
> > > locking the pppol2tp socket.
> > 
> > Thank you so much for your comment, and sorry for the late response.
> > 
> > Do you mean we can call l2tp_tunnel_register() without pppol2tp socket
> > lock?
> 
> Yes. At this point, we're creating a new tunnel which is independant
> from the pppol2tp socket.
> 
> > I've read the source code of pppol2tp_connect(), but I'm not
> > sure why pppol2tp socket is locked at the beginning of this function.
> > If we can call l2tp_tunnel_register() without pppol2tp socket lock, I
> > think we can move lock_sock() after l2tp_tunnel_register().
> 
> Here are a few more details to be sure we're on the same page.
> 
> Locking the pppol2tp socket remains necessary since we access and
> modify some of its protected attributes. But we can fetch or create
> the tunnel before working on the socket. For this, the only information
> we need to get from the socket is its netns. And calling sock_net(sk)
> without holding the socket lock is fine because user space sockets
> can't have their netns modified after initialisation.
> 
> So the code for retrieving or creating the tunnel can be moved before
> the lock_sock(sk) call in pppol2tp_register(). Just make sure to adjust
> the error path accordingly. Also, a helper function might help to make
> the code more readable.

Thank you so much for the detailed explanation.  I really appreciate.
I'll think about it further, and try to prepare v2 patch.

Thanks,
Shigeru

> 
> > Thanks,
> > Shigeru
> > 
> > > 
> > 
> 

