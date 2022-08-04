Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C749758A3FC
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 01:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbiHDXoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 19:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiHDXox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 19:44:53 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3B070E55;
        Thu,  4 Aug 2022 16:44:52 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id b7so767810qvq.2;
        Thu, 04 Aug 2022 16:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HVkR14o42hi6hJ+phzjown/t9tdn1qa9dzhn9JkAgYE=;
        b=FUPBygbQUj/wdWVItvPxp+dnHVAGcLFC/JxkbBQs+3cZoWgmaCxQKmzffYZLmcQnV+
         6EsQGI7fvIAnuFhhox7dtWTgwYdlChzNl1MAwCvHQE97b/YiRxEZMtvxuPqp+62JwORZ
         GhgOWMepuqTBL9OCkHEGU5AbEMFeNp/dTBiGos5+dXLso5bPexe22yphqS8xzAPuWML8
         6PGw7RVkDeU53Md4N8kfOhWvWxsXb4JFDlyIF3f2PGCtWbuhPzSYCL0IePbjaIwjMzXM
         2leMfvDjyFC096vb26dys74XEezet50ye4/YrZZGDMn1Dc+OPZ0gkixG2xWy1u9PRA3s
         fviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HVkR14o42hi6hJ+phzjown/t9tdn1qa9dzhn9JkAgYE=;
        b=i46VcGw8w91iLi4lvRQPG6i26BbTLDCwFh9DxyKoUAP5/QJKVRyvj6sFiQ88XaSnYS
         9cNMrV2d7Jv+eReOUn7BI5qvm0J8XUwtfyAIL4iRLebO38gK5h0ezNRHDU6sAOy1sgM1
         2kMXjzP0pA7t2K32WtZkWvHUgWsgWpb8naaxdh1APbbRPPAlHKQT2tS3jypgBXs/2qVq
         fQnVCmEJlIyYUNw4TEXXMVE6W6678743pLVvz4JhCEm8Ue/5gRey7mFMIqoJDSVemoSU
         HZrxyvbeqB/jVzYAb0PCINhq0x1w+AbX5uokYCHLfZ77THnjOISM7lK0RqLg6nzxQFPY
         lm4w==
X-Gm-Message-State: ACgBeo3HbDZjZG54YIz1iXQ/zuLADgum5Ov7y2h3TE9iWVb/LSgsDH50
        +y5BID5ZwMT+MLfrjGBCVg==
X-Google-Smtp-Source: AA6agR46IBnjSSMjNG8eh7tClgbT4ZO9RhxTMgsNzmRC8MWOIN/iv0pnXymVkhOmG2qUgWy6nn1jtQ==
X-Received: by 2002:ad4:4ea9:0:b0:474:7389:8593 with SMTP id ed9-20020ad44ea9000000b0047473898593mr3820374qvb.94.1659656692012;
        Thu, 04 Aug 2022 16:44:52 -0700 (PDT)
Received: from bytedance (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id e13-20020a05622a110d00b00339163a06fcsm1721967qty.6.2022.08.04.16.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 16:44:51 -0700 (PDT)
Date:   Thu, 4 Aug 2022 16:44:47 -0700
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
Message-ID: <20220804234447.GA2294@bytedance>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
 <20220804065923.66bor7cyxwk2bwsf@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804065923.66bor7cyxwk2bwsf@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

On Thu, Aug 04, 2022 at 08:59:23AM +0200, Stefano Garzarella wrote:
> The last thing I was trying to figure out before sending the patch was
> whether to set sock->state = SS_UNCONNECTED in vsock_connect_timeout().
> 
> I think we should do that, otherwise a subsequent to connect() with
> O_NONBLOCK set would keep returning -EALREADY, even though the timeout has
> expired.
> 
> What do you think?

Thanks for bringing this up, after thinking about sock->state, I have 3
thoughts:

1. I think the root cause of this memleak is, we keep @connect_work
   pending, even after the 2nd, blocking request times out (or gets
   interrupted) and sets sock->state back to SS_UNCONNECTED.

   @connect_work is effectively no-op when sk->sk_state is
   TCP_CLOS{E,ING} anyway, so why not we just cancel @connect_work when
   blocking requests time out or get interrupted?  Something like:

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f04abf662ec6..62628af84164 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1402,6 +1402,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
                lock_sock(sk);

                if (signal_pending(current)) {
+                       if (cancel_delayed_work(&vsk->connect_work))
+                               sock_put(sk);
+
                        err = sock_intr_errno(timeout);
                        sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
                        sock->state = SS_UNCONNECTED;
@@ -1409,6 +1412,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
                        vsock_remove_connected(vsk);
                        goto out_wait;
                } else if (timeout == 0) {
+                       if (cancel_delayed_work(&vsk->connect_work))
+                               sock_put(sk);
+
                        err = -ETIMEDOUT;
                        sk->sk_state = TCP_CLOSE;
                        sock->state = SS_UNCONNECTED;

   Then no need to worry about rescheduling @connect_work, and the state
   machine becomes more accurate.  What do you think?  I will ask syzbot
   to test this.

2. About your suggestion of setting sock->state = SS_UNCONNECTED in
   vsock_connect_timeout(), I think it makes sense.  Are you going to
   send a net-next patch for this?

3. After a TCP_SYN_SENT sock receives VIRTIO_VSOCK_OP_RESPONSE in
   virtio_transport_recv_connecting(), why don't we cancel @connect_work?
   Am I missing something?

Thanks,
Peilin Ye

