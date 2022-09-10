Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5DC5B461E
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIJLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 07:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiIJLtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 07:49:25 -0400
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7465AA12
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 04:49:21 -0700 (PDT)
X-Envelope-From: thomas@x-berg.in-berlin.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 28ABn5Ki2858591
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 13:49:05 +0200
Received: from thomas by x-berg.in-berlin.de with local (Exim 4.94.2)
        (envelope-from <thomas@x-berg.in-berlin.de>)
        id 1oWyyv-0008Qi-11; Sat, 10 Sep 2022 13:49:05 +0200
Date:   Sat, 10 Sep 2022 13:49:04 +0200
From:   Thomas Osterried <thomas@osterried.de>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org
Subject: Re: [AX25] patch did not fix --  was: ax25: fix incorrect
 dev_tracker usage
Message-ID: <Yxx5sJh/TLzSR5xU@x-berg.in-berlin.de>
References: <Yxw5siQ3FC6VHo7C@x-berg.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxw5siQ3FC6VHo7C@x-berg.in-berlin.de>
Sender: Thomas Osterried <thomas@x-berg.in-berlin.de>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

please allow me the question what the patch tries to fix.

1. we add sessions to the list of active sessions ax25_cb_add(ax25),
   and remove them on close.
   Why do we need a tracker?

2. ax25_dev.c:
   ax25_dev_device_up():
     netdev_hold(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
   ax25_dev_device_down():
     netdev_put(dev, &ax25_dev->dev_tracker);
   ax25_dev_free():
     netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);

   Just to be sure: It's the list of active ax25-interface, correct?

   -> Looks good to me.

3. On device status change, i.e. NETDEV_DOWN, ax25_device_event() calls
   ax25_kill_by_device(dev)
     and
   ax25_dev_device_down(dev) (we saw in 2)).

   Before patches
     7c6327c77d509e78bff76f2a4551fcfee851682e /	d7c4c9e075f8cc6d88d277bc24e5d99297f03c06
   we did
    in ax25_relase(): netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
   and
    in ax25_bind(); netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);

   ax25_kill_by_device() traverses through the list of active connections
   (ax25_list):
       if (sk->sk_socket) {
               netdev_put(ax25_dev->dev,
                      &ax25_dev->dev_tracker);
               ax25_dev_put(ax25_dev);
       }

    The patches mentioned above were:
      ax25_release(): netdev_put(ax25_dev->dev, &ax25->dev_tracker);
      ax25_bind(): netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);

    -> Previously, each session (ax25_cb) was added to it's device with the
         dev_tracker of the _device_ (&ax25_dev->dev_tracker)
       Now, each session (ax25_cb) is added with it's own dev_tracker
         &ax25->dev_tracker
       But:
         ax25_kill_by_device() goes through the list of active sessions and
         does
           netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
         instead of the new concept; I would have expected:
           netdev_put(ax25_dev->dev, &s->dev_tracker);
         
         If we netdev_put() to a non-existent tracker, this may explain
         the warnings
           unregister_netdevice: waiting for bpq1 to become free. Usage count = -2
         and
           refcount_t: underflow; use-after-free.
         that I observed in my previous mail.

   
4. Again, my question for understanding about the dev_tracker concept:
   should _all_ in- and outgoing sessions be tracked?
   If so, I argue we have to add
     - new outbound sessions to the tracker (i.E. if a IP mode VC frame is
       sent)
     - new inbound sessions to the tracker


   Also, ax25_bind() currently does not track all sessions:

        /*
         * User already set interface with SO_BINDTODEVICE
         */
        if (ax25->ax25_dev != NULL)
                goto done;
        ...
        if (ax25_dev) {
                ax25_fillin_cb(ax25, ax25_dev);
                netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
        }
	done:
        	ax25_cb_add(ax25);

    -> If user has previously called ax25_setsockopt() with SO_BINDTODEVICE,
       the device has been added to ax25->ax25_dev. But ax25_bind() does not
       add it to the tracker list (see above, ax25->ax25_dev is != NULL).


   ax25_connect() does also currently not track all sessions:

      There's a spcial condition sock_flag(sk, SOCK_ZAPPED), where connect()
      is allowed to be called without having gone through ax25_bind().
      Via ax25_rt_autobind(ax25, ..) it get's the appropriete ax25>dev.
      -> ax25_fillin_cb(ax25, ax25->ax25_dev);
         ax25_cb_add(ax25);
      => No tracker is added for this session.


   ax25_kill_by_device() does remove the tracker. I argued above, it removes
   the wrong tracker here:
                        if (sk->sk_socket) {
                                netdev_put(ax25_dev->dev,
                                           &ax25_dev->dev_tracker);
                                ax25_dev_put(ax25_dev);
                        }
   ..instead of &s->dev_tracker.

   And if we have trackers for all sessions (not only those that came via
   ax25_bind() from userspace), it's not enough to remove the tracker only
   for sessions with sk->socket.
   
   -> I would have expeted
      ax25_for_each(s, &ax25_list) {
        if (s->ax25_dev == ax25_dev) {
          if (s->ax25_dev == ax25_dev) {
            netdev_put(ax25_dev->dev, &s->dev_tracker);
            ...
   

   Finally:
   On normal session close (userspace program, or idle timer expiry),
   we need to have timers running for correct AX.25-session-close:
   If we are in connected state (AX25_STATE_3 or AX25_STATE_4), we need
   to send DISC in interval until max retry reached, or until we receive
   a DM-). 
   In ax25_release(), we see:
     if (ax25_dev) {
         ...
         netdev_put(ax25_dev->dev, &ax25->dev_tracker);
         ax25_dev_put(ax25_dev);
   But we need have timers running for ax25_cb's that still refer to
   the network dev (and need to be there until correct session
   termination), we have a conflict here, because
   netdev_put() assures here we are not allowed to refer to the
   dev anymore.
   That needs to be resolved.
 

Context:

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index bbac3cb4dc99d..d82a51e69386b 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1066,7 +1066,7 @@ static int ax25_release(struct socket *sock)
 			del_timer_sync(&ax25->t3timer);
 			del_timer_sync(&ax25->idletimer);
 		}
-		netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
+		netdev_put(ax25_dev->dev, &ax25->dev_tracker);
 		ax25_dev_put(ax25_dev);
 	}
 
@@ -1147,7 +1147,7 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
-		netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
+		netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
 	}
 
 done:



