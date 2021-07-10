Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5E03C34BB
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 15:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhGJNhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 09:37:38 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60250 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhGJNhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 09:37:38 -0400
Received: from fsav313.sakura.ne.jp (fsav313.sakura.ne.jp [153.120.85.144])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 16ADYYdV027508;
        Sat, 10 Jul 2021 22:34:34 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav313.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp);
 Sat, 10 Jul 2021 22:34:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 16ADYXGa027505
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 10 Jul 2021 22:34:34 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v2] Bluetooth: call lock_sock() outside of spinlock
 section
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Lin Ma <linma@zju.edu.cn>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <CABBYNZ+Vpzy2+u=xYR-7Kxx5M6pAQFQ8TJHYV1-Jr-FvqZ8=OQ@mail.gmail.com>
 <79694c01-b69e-a039-6860-d7e612fbc008@i-love.sakura.ne.jp>
Message-ID: <9771b40f-b544-a2a7-04e1-eddb38a4aae7@i-love.sakura.ne.jp>
Date:   Sat, 10 Jul 2021 22:34:29 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <79694c01-b69e-a039-6860-d7e612fbc008@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/07/08 8:33, Tetsuo Handa wrote:
>>              we could perhaps don't release the reference to hdev
>> either and leave hci_sock_release to deal with it and then perhaps we
>> can take away the backward goto, actually why are you restarting to
>> begin with?
> 
> Do you mean something like
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index b04a5a02ecf3..0525883f4639 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -759,19 +759,14 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>  	if (event == HCI_DEV_UNREG) {
>  		struct sock *sk;
>  
> -		/* Detach sockets from device */
> +		/* Change socket state and notify */
>  		read_lock(&hci_sk_list.lock);
>  		sk_for_each(sk, &hci_sk_list.head) {
> -			lock_sock(sk);
>  			if (hci_pi(sk)->hdev == hdev) {
> -				hci_pi(sk)->hdev = NULL;
>  				sk->sk_err = EPIPE;
>  				sk->sk_state = BT_OPEN;
>  				sk->sk_state_change(sk);
> -
> -				hci_dev_put(hdev);
>  			}
> -			release_sock(sk);
>  		}
>  		read_unlock(&hci_sk_list.lock);
>  	}
> 
> ? I can't judge because I don't know how this works. I worry that
> without lock_sock()/release_sock(), this races with e.g. hci_sock_bind().
> 

I examined hci_unregister_dev() and concluded that this can't work.

hci_sock_dev_event(hdev, HCI_DEV_UNREG) can't defer dropping the reference to
this hdev till hci_sock_release(), for hci_unregister_dev() cleans up everything
related to this hdev and calls hci_dev_put(hdev) and then vhci_release() calls
hci_free_dev(hdev).

That's the reason hci_sock_dev_event() has to use lock_sock() in order not to
miss some hci_dev_put(hdev) calls.

>> This sounds a little too complicated, afaik backward goto is not even
>> consider a good practice either, since it appears we don't unlink the
>> sockets here

Despite your comment, I'd like to go with choice (3) for now. After lock_sock() became
free from delay caused by pagefault handling, we could consider updating to choice (1).

