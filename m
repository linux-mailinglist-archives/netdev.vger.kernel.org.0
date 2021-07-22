Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5363D1D47
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 07:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhGVEgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 00:36:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64343 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhGVEgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 00:36:02 -0400
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 16M5GUVJ025255;
        Thu, 22 Jul 2021 14:16:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Thu, 22 Jul 2021 14:16:30 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 16M5GTOE025251
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 22 Jul 2021 14:16:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock
 section
To:     LinMa <linma@zju.edu.cn>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
 <CABBYNZJKWktRo1pCMdafAZ22sE2ZbZeMuFOO+tHUxOtEtTDTeA@mail.gmail.com>
 <674e6b1c.4780d.17aa81ee04c.Coremail.linma@zju.edu.cn>
 <2b0e515c-6381-bffe-7742-05148e1e2dcb@gmail.com>
 <4b955786-d233-8d3f-4445-2422c1daf754@gmail.com>
 <e07c5bbf-115c-6ffa-8492-7b749b9d286b@i-love.sakura.ne.jp>
 <7e4fafe2.58d70.17acc8a1a0b.Coremail.linma@zju.edu.cn>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <38e78054-7713-a142-4161-22890d8981ba@i-love.sakura.ne.jp>
Date:   Thu, 22 Jul 2021 14:16:27 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7e4fafe2.58d70.17acc8a1a0b.Coremail.linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/07/22 13:47, LinMa wrote:
> Hi Tetsuo,
> 
> Just find out another interesting function: sock_owned_by_user(). (I am just a noob of kernel locks)
> 
> Hence I think the following patch has the same 'effect' as the old patch e305509e678b3 ("Bluetooth: use correct lock to prevent UAF of hdev object")
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index b04a5a02ecf3..0cc4b88daa96 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -762,7 +762,11 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>                 /* Detach sockets from device */
>                 read_lock(&hci_sk_list.lock);
>                 sk_for_each(sk, &hci_sk_list.head) {
> -                       lock_sock(sk);
> +                       bh_lock_sock_nested(sk);
> +busywait:
> +                       if (sock_owned_by_user(sk))
> +                               goto busywait;
> +
>                         if (hci_pi(sk)->hdev == hdev) {
>                                 hci_pi(sk)->hdev = NULL;
>                                 sk->sk_err = EPIPE;
> @@ -771,7 +775,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
> 
>                                 hci_dev_put(hdev);
>                         }
> -                       release_sock(sk);
> +                       bh_unlock_sock(sk);
>                 }
>                 read_unlock(&hci_sk_list.lock);
>         }
> 
> The sad thing is that it seems will cost CPU resource to do meaningless wait...
> 
> What do you think? Can this sock_owned_by_user() function do any help?

I don't think it helps.

One of problems we are seeing (and my patch will fix) is a race window that
this sk_for_each() loop needs to wait using lock_sock() because
"hci_pi(sk)->hdev = hdev;" is called by hci_sock_bind() under lock_sock().
Doing hci_pi(sk)->hdev == hdev comparison without lock_sock() will lead to
failing to "/* Detach sockets from device */".

