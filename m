Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD860B8D8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiJXTy4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Oct 2022 15:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiJXTy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:54:27 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Oct 2022 11:18:45 PDT
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE60275BAB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:18:44 -0700 (PDT)
X-Envelope-From: thomas@osterried.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 29OI04nQ1929842
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 20:00:04 +0200
Received: from x-berg.in-berlin.de ([217.197.86.42] helo=smtpclient.apple)
        by x-berg.in-berlin.de with esmtpa (Exim 4.94.2)
        (envelope-from <thomas@osterried.de>)
        id 1on1k3-0008Bw-Pu; Mon, 24 Oct 2022 20:00:04 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [AX25] patch did not fix --  was: ax25: fix incorrect dev_tracker
 usage
From:   Thomas Osterried <thomas@osterried.de>
In-Reply-To: <Yxx5sJh/TLzSR5xU@x-berg.in-berlin.de>
Date:   Mon, 24 Oct 2022 20:00:00 +0200
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2B6541B7-FF35-41D2-8A20-18D5EEE7A919@osterried.de>
References: <Yxw5siQ3FC6VHo7C@x-berg.in-berlin.de>
 <Yxx5sJh/TLzSR5xU@x-berg.in-berlin.de>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

perhaps my questions in my last post were too complex.

I seem to not fully understand the concept of netdev_hold() / netdev_put().
I'll restart with my question "1" of my previous post, and for convenience,
I try to answer my question by myself (-> "yes" or "no" makes it easier
to answer ;)


  I) Why do we need these trackers?

     If we remove a network device, there may be active network structures
     (in our case AX.25-sessions) that use the device.
     It's a good idea to trace them (and inform), so we know that they linger
     around, and even more, we could wait until they are cleaned up properly.


 II) What consequences has the tracker counter?

     As far as I can see by kernel messages, the netdev tracker forces the
     kernel to wait
       (on ifdown (i.e. ifconfig ax0 down) 
        or rmmod (i.e. rmmod bpqether or rmmod ax25) )
     until all references to the network device are freed.
     If there's a bug (refcount > 0 or < 0), kernel obviously waits for ever.


III) Is it only to track sessions initiated from userspace?

     I think no.
     But in the current implementation, netdev_hold() is only
     called in ax25_bind(). And even there, not in all cases.
     But netdev_put() is called in all cases -> wrong count possible.
     There's no netdev_hold() for new
        - incoming AX.25-connects
     or
        - outgoing AX.25-sessions (initiated by i.e. by a packet of type
          IP-over-AX.25, netrom or rose).
     "Luckily" (in regard of the refcounter), there's also no netdev_put()
     if the AX.25 session get disconnected.
     
     Can this be correct?


Thank you for your help,

	- Thomas  dl9sau

> Am 10.09.2022 um 13:49 schrieb Thomas Osterried <thomas@osterried.de>:
> 
> Hello,
> 
> please allow me the question what the patch tries to fix.
> 
> 1. we add sessions to the list of active sessions ax25_cb_add(ax25),
>   and remove them on close.
>   Why do we need a tracker?
> 
> 2. ax25_dev.c:
>   ax25_dev_device_up():
>     netdev_hold(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
>   ax25_dev_device_down():
>     netdev_put(dev, &ax25_dev->dev_tracker);
>   ax25_dev_free():
>     netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
> 
>   Just to be sure: It's the list of active ax25-interface, correct?
> 
>   -> Looks good to me.
> 
> 3. On device status change, i.e. NETDEV_DOWN, ax25_device_event() calls
>   ax25_kill_by_device(dev)
>     and
>   ax25_dev_device_down(dev) (we saw in 2)).
> 
>   Before patches
>     7c6327c77d509e78bff76f2a4551fcfee851682e /	d7c4c9e075f8cc6d88d277bc24e5d99297f03c06
>   we did
>    in ax25_relase(): netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
>   and
>    in ax25_bind(); netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> 
>   ax25_kill_by_device() traverses through the list of active connections
>   (ax25_list):
>       if (sk->sk_socket) {
>               netdev_put(ax25_dev->dev,
>                      &ax25_dev->dev_tracker);
>               ax25_dev_put(ax25_dev);
>       }
> 
>    The patches mentioned above were:
>      ax25_release(): netdev_put(ax25_dev->dev, &ax25->dev_tracker);
>      ax25_bind(): netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
> 
>    -> Previously, each session (ax25_cb) was added to it's device with the
>         dev_tracker of the _device_ (&ax25_dev->dev_tracker)
>       Now, each session (ax25_cb) is added with it's own dev_tracker
>         &ax25->dev_tracker
>       But:
>         ax25_kill_by_device() goes through the list of active sessions and
>         does
>           netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
>         instead of the new concept; I would have expected:
>           netdev_put(ax25_dev->dev, &s->dev_tracker);
> 
>         If we netdev_put() to a non-existent tracker, this may explain
>         the warnings
>           unregister_netdevice: waiting for bpq1 to become free. Usage count = -2
>         and
>           refcount_t: underflow; use-after-free.
>         that I observed in my previous mail.
> 
> 
> 4. Again, my question for understanding about the dev_tracker concept:
>   should _all_ in- and outgoing sessions be tracked?
>   If so, I argue we have to add
>     - new outbound sessions to the tracker (i.E. if a IP mode VC frame is
>       sent)
>     - new inbound sessions to the tracker
> 
> 
>   Also, ax25_bind() currently does not track all sessions:
> 
>        /*
>         * User already set interface with SO_BINDTODEVICE
>         */
>        if (ax25->ax25_dev != NULL)
>                goto done;
>        ...
>        if (ax25_dev) {
>                ax25_fillin_cb(ax25, ax25_dev);
>                netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
>        }
> 	done:
>        	ax25_cb_add(ax25);
> 
>    -> If user has previously called ax25_setsockopt() with SO_BINDTODEVICE,
>       the device has been added to ax25->ax25_dev. But ax25_bind() does not
>       add it to the tracker list (see above, ax25->ax25_dev is != NULL).
> 
> 
>   ax25_connect() does also currently not track all sessions:
> 
>      There's a spcial condition sock_flag(sk, SOCK_ZAPPED), where connect()
>      is allowed to be called without having gone through ax25_bind().
>      Via ax25_rt_autobind(ax25, ..) it get's the appropriete ax25>dev.
>      -> ax25_fillin_cb(ax25, ax25->ax25_dev);
>         ax25_cb_add(ax25);
>      => No tracker is added for this session.
> 
> 
>   ax25_kill_by_device() does remove the tracker. I argued above, it removes
>   the wrong tracker here:
>                        if (sk->sk_socket) {
>                                netdev_put(ax25_dev->dev,
>                                           &ax25_dev->dev_tracker);
>                                ax25_dev_put(ax25_dev);
>                        }
>   ..instead of &s->dev_tracker.
> 
>   And if we have trackers for all sessions (not only those that came via
>   ax25_bind() from userspace), it's not enough to remove the tracker only
>   for sessions with sk->socket.
> 
>   -> I would have expeted
>      ax25_for_each(s, &ax25_list) {
>        if (s->ax25_dev == ax25_dev) {
>          if (s->ax25_dev == ax25_dev) {
>            netdev_put(ax25_dev->dev, &s->dev_tracker);
>            ...
> 
> 
>   Finally:
>   On normal session close (userspace program, or idle timer expiry),
>   we need to have timers running for correct AX.25-session-close:
>   If we are in connected state (AX25_STATE_3 or AX25_STATE_4), we need
>   to send DISC in interval until max retry reached, or until we receive
>   a DM-). 
>   In ax25_release(), we see:
>     if (ax25_dev) {
>         ...
>         netdev_put(ax25_dev->dev, &ax25->dev_tracker);
>         ax25_dev_put(ax25_dev);
>   But we need have timers running for ax25_cb's that still refer to
>   the network dev (and need to be there until correct session
>   termination), we have a conflict here, because
>   netdev_put() assures here we are not allowed to refer to the
>   dev anymore.
>   That needs to be resolved.
> 
> 
> Context:
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index bbac3cb4dc99d..d82a51e69386b 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1066,7 +1066,7 @@ static int ax25_release(struct socket *sock)
> 			del_timer_sync(&ax25->t3timer);
> 			del_timer_sync(&ax25->idletimer);
> 		}
> -		netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
> +		netdev_put(ax25_dev->dev, &ax25->dev_tracker);
> 		ax25_dev_put(ax25_dev);
> 	}
> 
> @@ -1147,7 +1147,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> 
> 	if (ax25_dev) {
> 		ax25_fillin_cb(ax25, ax25_dev);
> -		netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> +		netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
> 	}
> 
> done:
> 
> 
> 
> 

