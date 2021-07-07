Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E94E3BF27F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhGGXgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:36:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59711 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhGGXgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 19:36:36 -0400
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 167NXad9056266;
        Thu, 8 Jul 2021 08:33:36 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Thu, 08 Jul 2021 08:33:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 167NXZAR056260
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 8 Jul 2021 08:33:36 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v2] Bluetooth: call lock_sock() outside of spinlock
 section
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <CABBYNZ+Vpzy2+u=xYR-7Kxx5M6pAQFQ8TJHYV1-Jr-FvqZ8=OQ@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <79694c01-b69e-a039-6860-d7e612fbc008@i-love.sakura.ne.jp>
Date:   Thu, 8 Jul 2021 08:33:32 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZ+Vpzy2+u=xYR-7Kxx5M6pAQFQ8TJHYV1-Jr-FvqZ8=OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/07/08 3:20, Luiz Augusto von Dentz wrote:
>> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
>> index b04a5a02ecf3..d8e1ac1ae10d 100644
>> --- a/net/bluetooth/hci_sock.c
>> +++ b/net/bluetooth/hci_sock.c
>> @@ -758,20 +758,46 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>>
>>         if (event == HCI_DEV_UNREG) {
>>                 struct sock *sk;
>> +               bool put_dev;
>>
>> +restart:
>> +               put_dev = false;
>>                 /* Detach sockets from device */
>>                 read_lock(&hci_sk_list.lock);
>>                 sk_for_each(sk, &hci_sk_list.head) {
>> +                       /* hci_sk_list.lock is preventing hci_sock_release()
>> +                        * from calling bt_sock_unlink().
>> +                        */
>> +                       if (hci_pi(sk)->hdev != hdev || sk_unhashed(sk))
>> +                               continue;
>> +                       /* Take a ref because we can't call lock_sock() with
>> +                        * hci_sk_list.lock held.
>> +                        */
>> +                       sock_hold(sk);
>> +                       read_unlock(&hci_sk_list.lock);
>>                         lock_sock(sk);
>> -                       if (hci_pi(sk)->hdev == hdev) {
>> +                       /* Since hci_sock_release() might have already called
>> +                        * bt_sock_unlink() while waiting for lock_sock(),
>> +                        * use sk_hashed(sk) for checking that bt_sock_unlink()
>> +                        * is not yet called.
>> +                        */
>> +                       write_lock(&hci_sk_list.lock);
>> +                       if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
>>                                 hci_pi(sk)->hdev = NULL;
>>                                 sk->sk_err = EPIPE;
>>                                 sk->sk_state = BT_OPEN;
>>                                 sk->sk_state_change(sk);
>> -
>> -                               hci_dev_put(hdev);
>> +                               put_dev = true;
>>                         }
>> +                       write_unlock(&hci_sk_list.lock);
>>                         release_sock(sk);
>> +                       sock_put(sk);
>> +                       if (put_dev)
>> +                               hci_dev_put(hdev);
>> +                       /* Restarting is safe, for hci_pi(sk)->hdev != hdev if
>> +                        * condition met and sk_unhashed(sk) == true otherwise.
>> +                        */
>> +                       goto restart;
> 
> This sounds a little too complicated, afaik backward goto is not even
> consider a good practice either, since it appears we don't unlink the
> sockets here

Because hci_sock_release() might be concurrently called while
hci_sock_dev_event() from hci_unregister_dev() from vhci_release() is running.

While hci_sock_dev_event() itself does not unlink the sockets from hci_sk_list.head,
bt_sock_unlink() from hci_sock_release() unlinks a socket from hci_sk_list.head.

Therefore, as long as there is possibility that hci_sk_list is modified by other thread
when current thread is traversing this list, we need to be prepared for such race.

>              we could perhaps don't release the reference to hdev
> either and leave hci_sock_release to deal with it and then perhaps we
> can take away the backward goto, actually why are you restarting to
> begin with?

Do you mean something like

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..0525883f4639 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -759,19 +759,14 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
 
-		/* Detach sockets from device */
+		/* Change socket state and notify */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
-				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
 				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
 			}
-			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}

? I can't judge because I don't know how this works. I worry that
without lock_sock()/release_sock(), this races with e.g. hci_sock_bind().

We could take away the backward goto if we can do something like below.

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..1ca03769badf 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -43,6 +43,8 @@ static DEFINE_IDA(sock_cookie_ida);
 
 static atomic_t monitor_promisc = ATOMIC_INIT(0);
 
+static DEFINE_MUTEX(sock_list_lock);
+
 /* ----- HCI socket interface ----- */
 
 /* Socket info */
@@ -760,7 +762,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		struct sock *sk;
 
 		/* Detach sockets from device */
-		read_lock(&hci_sk_list.lock);
+		mutex_lock(&sock_list_lock);
 		sk_for_each(sk, &hci_sk_list.head) {
 			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
@@ -773,7 +775,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 			}
 			release_sock(sk);
 		}
-		read_unlock(&hci_sk_list.lock);
+		mutex_unlock(&sock_list_lock);
 	}
 }
 
@@ -838,6 +840,7 @@ static int hci_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	mutex_lock(&sock_list_lock);
 	lock_sock(sk);
 
 	switch (hci_pi(sk)->channel) {
@@ -860,6 +863,7 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	bt_sock_unlink(&hci_sk_list, sk);
+	mutex_unlock(&sock_list_lock);
 
 	hdev = hci_pi(sk)->hdev;
 	if (hdev) {
@@ -2049,7 +2053,9 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
 
+	mutex_lock(&sock_list_lock);
 	bt_sock_link(&hci_sk_list, sk);
+	mutex_unlock(&sock_list_lock);
 	return 0;
 }
 

>             It is also weird that this only manifests in the Bluetooth
> HCI sockets or other subsystems don't use such locking mechanism
> anymore?

If other subsystems have similar problem, that should be handled by different
patches. This patch fixes a regression introduced when fixing CVE-2021-3573,
and I think that Linux distributors are waiting for this regression to be fixed
so that they can backport commit e305509e678b3a4a ("Bluetooth: use correct lock
to prevent UAF of hdev object"). Also, this regression is currently 7th top
crashers for syzbot, and I'd like to apply this patch as soon as possible.

I think that this patch can serve as a response to Lin's comment

  > In short, I have no idea if there is any lock replacing solution for
  > this bug. I need help and suggestions because the lock mechanism is
  > just so difficult.

at https://patchwork.kernel.org/project/bluetooth/patch/CAJjojJsj9pzF4j2MVvsM-hCpvyR7OkZn232yt3MdOGnLxOiRRg@mail.gmail.com
without changing behavior.

> 
> 
>>                 }
>>                 read_unlock(&hci_sk_list.lock);
>>         }
>> --
>> 2.18.4

