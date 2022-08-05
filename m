Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0052B58AFB9
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241236AbiHES1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241225AbiHES12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:27:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A07A533;
        Fri,  5 Aug 2022 11:27:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f11so3318418pgj.7;
        Fri, 05 Aug 2022 11:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AioU5oUE5g4jF1wbScY3S1UHHdfeyCyY6/YrQaOYSsg=;
        b=ad35ukFWKMSqyuH7imBf6ZVcSHjPYpipHSBVJvYPCSL2DaXaRxxsZajWTtT9lKuqSb
         WTJlEPQeqT5G+kJmd1LZd/ESmC2433vWBX1JWTE8IBNyrZ9p2NDD6MTROpXUy4sCYqDU
         hy0GcaqZ2rPu4ExV/gZ+aD80DGJTwBi/I2i83cCTBX2dI3KOY8s/ELUSM9I3+YvnTAzJ
         Rc6VdAd5jz/FVLGpp/9X+cYAdmoSeRtc/kdThgURHPT0yM2hhJW4FPYmXA+X/mz5W3Nv
         dWE99ix2QpZJ57CeD7fDueL95INE835zvEAXl85gUDQLp5L9Yx/XIiegsUk9dIA+KKx9
         NTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AioU5oUE5g4jF1wbScY3S1UHHdfeyCyY6/YrQaOYSsg=;
        b=4Oei6XExi5bgZwzG5ul/enF8iLKX46abOLSwwt622QivVBSW1w6uhJHZP1NbmTNmv6
         /Y5qhIfKJnfGIcxe2msoROhlzeBhv0XsZvIwMj09VycVNwafvvJUgash7Y/XHh7brEOP
         KhFSYZHODvOo67r3yTkRan0H8tuaKsnE3NnuT/coQOrgo/3FEMNeT5/l9fWXDRpcnytI
         oVyk5UeVtPMQpRP91Uobn0NUQ7oKYZfNLc2TVzGuBnvyHVKMjcAgETptpZLp01e+tK8P
         71h3KtD0mphCHV3oWAnIovM74663gFlJlnerB4IY82VyJK0ytdA7ySjmyeWmYy8V73hf
         znFw==
X-Gm-Message-State: ACgBeo1mmruD0+gxzlfvvW3vZvKggwZGyrq7bM1n7NPlKNPHmVr3w5yE
        F1Zpy3CVAXtpQSdpXd09QA==
X-Google-Smtp-Source: AA6agR7LiU0xyCJ09OZa/6LwgqA2y3Bwj+Jwac4aAi+Crn5xO9X0Q3+O42fBF+fuWGndnpSjbIGf8w==
X-Received: by 2002:aa7:9390:0:b0:52d:8816:a906 with SMTP id t16-20020aa79390000000b0052d8816a906mr7910716pfe.63.1659724046005;
        Fri, 05 Aug 2022 11:27:26 -0700 (PDT)
Received: from bytedance ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id ik30-20020a170902ab1e00b0016c1a1c1405sm3244850plb.222.2022.08.05.11.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 11:27:25 -0700 (PDT)
Date:   Fri, 5 Aug 2022 11:27:15 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next] vsock: Reschedule connect_work for
 O_NONBLOCK connect() requests
Message-ID: <20220805182715.GA17335@bytedance>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
 <20220804065923.66bor7cyxwk2bwsf@sgarzare-redhat>
 <20220804234447.GA2294@bytedance>
 <20220805124239.iy5lkeytqwjyvn7g@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805124239.iy5lkeytqwjyvn7g@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 02:42:39PM +0200, Stefano Garzarella wrote:
> On Thu, Aug 04, 2022 at 04:44:47PM -0700, Peilin Ye wrote:
> > 1. I think the root cause of this memleak is, we keep @connect_work
> >   pending, even after the 2nd, blocking request times out (or gets
> >   interrupted) and sets sock->state back to SS_UNCONNECTED.
> > 
> >   @connect_work is effectively no-op when sk->sk_state is
> >   TCP_CLOS{E,ING} anyway, so why not we just cancel @connect_work when
> >   blocking requests time out or get interrupted?  Something like:
> > 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index f04abf662ec6..62628af84164 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1402,6 +1402,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> >                lock_sock(sk);
> > 
> >                if (signal_pending(current)) {
> > +                       if (cancel_delayed_work(&vsk->connect_work))
> > +                               sock_put(sk);
> > +
> >                        err = sock_intr_errno(timeout);
> >                        sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
> >                        sock->state = SS_UNCONNECTED;
> > @@ -1409,6 +1412,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> >                        vsock_remove_connected(vsk);
> >                        goto out_wait;
> >                } else if (timeout == 0) {
> > +                       if (cancel_delayed_work(&vsk->connect_work))
> > +                               sock_put(sk);
> > +
> >                        err = -ETIMEDOUT;
> >                        sk->sk_state = TCP_CLOSE;
> >                        sock->state = SS_UNCONNECTED;
> > 
> >   Then no need to worry about rescheduling @connect_work, and the state
> >   machine becomes more accurate.  What do you think?  I will ask syzbot
> >   to test this.
> 
> It could work, but should we set `sk->sk_err` and call sk_error_report() to
> wake up thread waiting on poll()?
> 
> Maybe the previous version is simpler.

Right, I forgot about sk_error_report().  Let us use the simpler version
then.

> > 2. About your suggestion of setting sock->state = SS_UNCONNECTED in
> >   vsock_connect_timeout(), I think it makes sense.  Are you going to
> >   send a net-next patch for this?
> 
> If you have time, feel free to send it.
> 
> Since it is a fix, I believe you can use the "net" tree. (Also for this
> patch).
> 
> Remember to put the "Fixes" tag that should be the same.

Sure, I will send them this week.  Thanks!

Peilin Ye

