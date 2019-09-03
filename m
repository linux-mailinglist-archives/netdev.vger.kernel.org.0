Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63466A66C3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfICKuO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Sep 2019 06:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbfICKuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 06:50:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B93758BA2D4;
        Tue,  3 Sep 2019 10:50:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAA4A19C78;
        Tue,  3 Sep 2019 10:50:13 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F1C21802216;
        Tue,  3 Sep 2019 10:50:13 +0000 (UTC)
Date:   Tue, 3 Sep 2019 06:50:11 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        eric dumazet <eric.dumazet@gmail.com>,
        xiyou wangcong <xiyou.wangcong@gmail.com>,
        weiyongjun1@huawei.com
Message-ID: <314835944.12221643.1567507811976.JavaMail.zimbra@redhat.com>
In-Reply-To: <5D6E17A7.1020102@huawei.com>
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com> <5D5FB3B6.5080800@huawei.com> <1be732b2-6eda-4ea6-772d-780694557910@redhat.com> <5D6DC5BF.5020009@huawei.com> <4a5d84b7-f3cb-c4e1-d6fe-28d186a551ee@redhat.com> <5D6DFD57.7020905@huawei.com> <71e17457-d4bc-15be-dfb3-d0a977fd7556@redhat.com> <5D6E17A7.1020102@huawei.com>
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.68.5.20, 10.4.195.17]
Thread-Topic: fix use-after-free when register netdev failed
Thread-Index: 5zQmm83IwrU17m9Mg3G/x97/GJJeGw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 03 Sep 2019 10:50:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> 
> 
> On 2019/9/3 14:06, Jason Wang wrote:
> >
> > On 2019/9/3 下午1:42, Yang Yingliang wrote:
> >>
> >>
> >> On 2019/9/3 11:03, Jason Wang wrote:
> >>>
> >>> On 2019/9/3 上午9:45, Yang Yingliang wrote:
> >>>>
> >>>>
> >>>> On 2019/9/2 13:32, Jason Wang wrote:
> >>>>>
> >>>>> On 2019/8/23 下午5:36, Yang Yingliang wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 2019/8/23 11:05, Jason Wang wrote:
> >>>>>>> ----- Original Message -----
> >>>>>>>>
> >>>>>>>> On 2019/8/22 14:07, Yang Yingliang wrote:
> >>>>>>>>>
> >>>>>>>>> On 2019/8/22 10:13, Jason Wang wrote:
> >>>>>>>>>> On 2019/8/20 上午10:28, Jason Wang wrote:
> >>>>>>>>>>> On 2019/8/20 上午9:25, David Miller wrote:
> >>>>>>>>>>>> From: Yang Yingliang <yangyingliang@huawei.com>
> >>>>>>>>>>>> Date: Mon, 19 Aug 2019 21:31:19 +0800
> >>>>>>>>>>>>
> >>>>>>>>>>>>> Call tun_attach() after register_netdevice() to make sure
> >>>>>>>>>>>>> tfile->tun
> >>>>>>>>>>>>> is not published until the netdevice is registered. So the
> >>>>>>>>>>>>> read/write
> >>>>>>>>>>>>> thread can not use the tun pointer that may freed by
> >>>>>>>>>>>>> free_netdev().
> >>>>>>>>>>>>> (The tun and dev pointer are allocated by
> >>>>>>>>>>>>> alloc_netdev_mqs(), they
> >>>>>>>>>>>>> can
> >>>>>>>>>>>>> be freed by netdev_freemem().)
> >>>>>>>>>>>> register_netdevice() must always be the last operation in
> >>>>>>>>>>>> the order of
> >>>>>>>>>>>> network device setup.
> >>>>>>>>>>>>
> >>>>>>>>>>>> At the point register_netdevice() is called, the device is
> >>>>>>>>>>>> visible
> >>>>>>>>>>>> globally
> >>>>>>>>>>>> and therefore all of it's software state must be fully
> >>>>>>>>>>>> initialized and
> >>>>>>>>>>>> ready for us.
> >>>>>>>>>>>>
> >>>>>>>>>>>> You're going to have to find another solution to these
> >>>>>>>>>>>> problems.
> >>>>>>>>>>>
> >>>>>>>>>>> The device is loosely coupled with sockets/queues. Each side is
> >>>>>>>>>>> allowed to be go away without caring the other side. So in this
> >>>>>>>>>>> case, there's a small window that network stack think the
> >>>>>>>>>>> device has
> >>>>>>>>>>> one queue but actually not, the code can then safely drop them.
> >>>>>>>>>>> Maybe it's ok here with some comments?
> >>>>>>>>>>>
> >>>>>>>>>>> Or if not, we can try to hold the device before tun_attach
> >>>>>>>>>>> and drop
> >>>>>>>>>>> it after register_netdevice().
> >>>>>>>>>>
> >>>>>>>>>> Hi Yang:
> >>>>>>>>>>
> >>>>>>>>>> I think maybe we can try to hold refcnt instead of playing
> >>>>>>>>>> real num
> >>>>>>>>>> queues here. Do you want to post a V4?
> >>>>>>>>> I think the refcnt can prevent freeing the memory in this case.
> >>>>>>>>> When register_netdevice() failed, free_netdev() will be called
> >>>>>>>>> directly,
> >>>>>>>>> dev->pcpu_refcnt and dev are freed without checking refcnt of
> >>>>>>>>> dev.
> >>>>>>>> How about using patch-v1 that using a flag to check whether the
> >>>>>>>> device
> >>>>>>>> registered successfully.
> >>>>>>>>
> >>>>>>> As I said, it lacks sufficient locks or barriers. To be clear, I
> >>>>>>> meant
> >>>>>>> something like (compile-test only):
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>> index db16d7a13e00..e52678f9f049 100644
> >>>>>>> --- a/drivers/net/tun.c
> >>>>>>> +++ b/drivers/net/tun.c
> >>>>>>> @@ -2828,6 +2828,7 @@ static int tun_set_iff(struct net *net,
> >>>>>>> struct file *file, struct ifreq *ifr)
> >>>>>>>                                (ifr->ifr_flags & TUN_FEATURES);
> >>>>>>> INIT_LIST_HEAD(&tun->disabled);
> >>>>>>> +               dev_hold(dev);
> >>>>>>>                  err = tun_attach(tun, file, false,
> >>>>>>> ifr->ifr_flags & IFF_NAPI,
> >>>>>>>                                   ifr->ifr_flags & IFF_NAPI_FRAGS);
> >>>>>>>                  if (err < 0)
> >>>>>>> @@ -2836,6 +2837,7 @@ static int tun_set_iff(struct net *net,
> >>>>>>> struct file *file, struct ifreq *ifr)
> >>>>>>>                  err = register_netdevice(tun->dev);
> >>>>>>>                  if (err < 0)
> >>>>>>>                          goto err_detach;
> >>>>>>> +               dev_put(dev);
> >>>>>>>          }
> >>>>>>>            netif_carrier_on(tun->dev);
> >>>>>>> @@ -2852,11 +2854,13 @@ static int tun_set_iff(struct net *net,
> >>>>>>> struct file *file, struct ifreq *ifr)
> >>>>>>>          return 0;
> >>>>>>>     err_detach:
> >>>>>>> +       dev_put(dev);
> >>>>>>>          tun_detach_all(dev);
> >>>>>>>          /* register_netdevice() already called
> >>>>>>> tun_free_netdev() */
> >>>>>>>          goto err_free_dev;
> >>>>>>>     err_free_flow:
> >>>>>>> +       dev_put(dev);
> >>>>>>>          tun_flow_uninit(tun);
> >>>>>>> security_tun_dev_free_security(tun->security);
> >>>>>>>   err_free_stat:
> >>>>>>>
> >>>>>>> What's your thought?
> >>>>>>
> >>>>>> The dev pointer are freed without checking the refcount in
> >>>>>> free_netdev() called by err_free_dev
> >>>>>>
> >>>>>> path, so I don't understand how the refcount protects this pointer.
> >>>>>>
> >>>>>
> >>>>> The refcount are guaranteed to be zero there, isn't it?
> >>>> No, it's not.
> >>>>
> >>>> err_free_dev:
> >>>>         free_netdev(dev);
> >>>>
> >>>> void free_netdev(struct net_device *dev)
> >>>> {
> >>>> ...
> >>>>         /* pcpu_refcnt can be freed without checking refcount */
> >>>>         free_percpu(dev->pcpu_refcnt);
> >>>>         dev->pcpu_refcnt = NULL;
> >>>>
> >>>>         /*  Compatibility with error handling in drivers */
> >>>>         if (dev->reg_state == NETREG_UNINITIALIZED) {
> >>>>                 /* dev can be freed without checking refcount */
> >>>>                 netdev_freemem(dev);
> >>>>                 return;
> >>>>         }
> >>>> ...
> >>>> }
> >>>
> >>>
> >>> Right, but what I meant is in my patch, when code reaches
> >>> free_netdev() the refcnt is zero. What did I miss?
> >> Yes, but it can't fix the UAF problem.
> >
> >
> > Well, it looks to me that the dev_put() in tun_put() won't release the
> > device in this case.
> 
> The device is not released in tun_put().
> This is how the UAF occurs:
> 
>          CPUA                                           CPUB
>      tun_set_iff()
>        alloc_netdev_mqs()
>        tun_attach()
>                                                      tun_chr_read_iter()
>                                                        tun_get()
>                                                        tun_do_read()
>                                                          tun_ring_recv()
>        register_netdevice() <-- inject error
>        goto err_detach
>        tun_detach_all() <-- set RCV_SHUTDOWN
>        free_netdev() <-- called from
>                         err_free_dev path
>          netdev_freemem() <-- free the memory
>                            without check refcount
>          (In this path, the refcount cannot prevent
>           freeing the memory of dev, and the memory
>           will be used by dev_put() called by
>           tun_chr_read_iter() on CPUB.)
>                                                         (Break from
>                                                         tun_ring_recv(),
>                                                         because RCV_SHUTDOWN
>                                                         is set)
>                                                       tun_put()
>                                                       dev_put() <-- use the
>                                                       memory freed by
>                                                       netdev_freemem()
> 
>

My bad, thanks for the patience. Since all evil come from the
tfile->tun, how about delay the publishing of tfile->tun until the
success of registration to make sure dev_put() and dev_hold() work.
(Compile test only)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index db16d7a13e00..aab0be40d443 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -787,7 +787,8 @@ static void tun_detach_all(struct net_device *dev)
 }
 
 static int tun_attach(struct tun_struct *tun, struct file *file,
-		      bool skip_filter, bool napi, bool napi_frags)
+		      bool skip_filter, bool napi, bool napi_frags,
+		      bool publish_tun)
 {
 	struct tun_file *tfile = file->private_data;
 	struct net_device *dev = tun->dev;
@@ -870,7 +871,8 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 	 * initialized tfile; otherwise we risk using half-initialized
 	 * object.
 	 */
-	rcu_assign_pointer(tfile->tun, tun);
+	if (publish_tun)
+		rcu_assign_pointer(tfile->tun, tun);
 	rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
 	tun->numqueues++;
 	tun_set_real_num_queues(tun);
@@ -2730,7 +2732,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		err = tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER,
 				 ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS);
+				 ifr->ifr_flags & IFF_NAPI_FRAGS, true);
 		if (err < 0)
 			return err;
 
@@ -2829,13 +2831,17 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		INIT_LIST_HEAD(&tun->disabled);
 		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS);
+				 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
 		if (err < 0)
 			goto err_free_flow;
 
 		err = register_netdevice(tun->dev);
 		if (err < 0)
 			goto err_detach;
+		/* free_netdev() won't check refcnt, to aovid race
+		 * with dev_put() we need publish tun after registration.
+		 */
+		rcu_assign_pointer(tfile->tun, tun);
 	}
 
 	netif_carrier_on(tun->dev);
@@ -2978,7 +2984,7 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
 		if (ret < 0)
 			goto unlock;
 		ret = tun_attach(tun, file, false, tun->flags & IFF_NAPI,
-				 tun->flags & IFF_NAPI_FRAGS);
+				 tun->flags & IFF_NAPI_FRAGS, true);
 	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
 		tun = rtnl_dereference(tfile->tun);
 		if (!tun || !(tun->flags & IFF_MULTI_QUEUE) || tfile->detached)
-- 
2.18.1



> >
> > Thanks
> >
> 
> 
> 
