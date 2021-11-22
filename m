Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC5D45910D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbhKVPOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbhKVPOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:14:41 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64049C061574;
        Mon, 22 Nov 2021 07:11:34 -0800 (PST)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id CFFCD2E19B0;
        Mon, 22 Nov 2021 18:11:27 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id YiPih2xZ0h-BQsOL2aO;
        Mon, 22 Nov 2021 18:11:27 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1637593887; bh=5SoeLo1xTGbCZidoCkfBDOnFEuE/R0Qz7W+q8Uyq6I4=;
        h=In-Reply-To:References:Date:From:To:Subject:Message-ID:Cc;
        b=2vRHIv1S2bOBt4EJL7FB9EKnVMkVu9oyf8rr4twhznsXRqq5168NXXdVTmcwf/eNL
         UL1VclENnC3L8CvkHPhRAddD7J3UvfONOCX5W+STzaLH1tc7ZSY5CHVU7HgWQa3QPo
         TZ3NZJgTcGM+1KFGzxgUW2rSTxR5i18rmAEju04M=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from [IPv6:2a02:6b8:0:107:3e85:844d:5b1d:60a] (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id adw8Ie3kCo-BQw4PPnO;
        Mon, 22 Nov 2021 18:11:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Subject: Re: [PATCH 6/6] vhost_net: use RCU callbacks instead of
 synchronize_rcu()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211115153003.9140-6-arbn@yandex-team.com>
 <CACGkMEumax9RFVNgWLv5GyoeQAmwo-UgAq=DrUd4yLxPAUUqBw@mail.gmail.com>
 <b163233f-090f-baaf-4460-37978cab4d55@yandex-team.com>
 <20211122043620-mutt-send-email-mst@kernel.org>
From:   Andrey Ryabinin <arbn@yandex-team.com>
Message-ID: <ba4dbc25-f912-fb34-a0e2-c6c85b34b918@yandex-team.com>
Date:   Mon, 22 Nov 2021 18:12:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122043620-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/21 12:37 PM, Michael S. Tsirkin wrote:
> On Fri, Nov 19, 2021 at 02:32:05PM +0300, Andrey Ryabinin wrote:
>>
>>
>> On 11/16/21 8:00 AM, Jason Wang wrote:
>>> On Mon, Nov 15, 2021 at 11:32 PM Andrey Ryabinin <arbn@yandex-team.com> wrote:
>>>>
>>>> Currently vhost_net_release() uses synchronize_rcu() to synchronize
>>>> freeing with vhost_zerocopy_callback(). However synchronize_rcu()
>>>> is quite costly operation. It take more than 10 seconds
>>>> to shutdown qemu launched with couple net devices like this:
>>>>         -netdev tap,id=tap0,..,vhost=on,queues=80
>>>> because we end up calling synchronize_rcu() netdev_count*queues times.
>>>>
>>>> Free vhost net structures in rcu callback instead of using
>>>> synchronize_rcu() to fix the problem.
>>>
>>> I admit the release code is somehow hard to understand. But I wonder
>>> if the following case can still happen with this:
>>>
>>> CPU 0 (vhost_dev_cleanup)   CPU1
>>> (vhost_net_zerocopy_callback()->vhost_work_queue())
>>>                                                 if (!dev->worker)
>>> dev->worker = NULL
>>>
>>> wake_up_process(dev->worker)
>>>
>>> If this is true. It seems the fix is to move RCU synchronization stuff
>>> in vhost_net_ubuf_put_and_wait()?
>>>
>>
>> It all depends whether vhost_zerocopy_callback() can be called outside of vhost
>> thread context or not. If it can run after vhost thread stopped, than the race you
>> describe seems possible and the fix in commit b0c057ca7e83 ("vhost: fix a theoretical race in device cleanup")
>> wasn't complete. I would fix it by calling synchronize_rcu() after vhost_net_flush()
>> and before vhost_dev_cleanup().
>>
>> As for the performance problem, it can be solved by replacing synchronize_rcu() with synchronize_rcu_expedited().
> 
> expedited causes a stop of IPIs though, so it's problematic to
> do it upon a userspace syscall.
> 

How about something like this?


---
 drivers/vhost/net.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 97a209d6a527..556df26c584d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -144,6 +144,10 @@ struct vhost_net {
 	struct page_frag page_frag;
 	/* Refcount bias of page frag */
 	int refcnt_bias;
+
+	struct socket *tx_sock;
+	struct socket *rx_sock;
+	struct rcu_work rwork;
 };
 
 static unsigned vhost_net_zcopy_mask __read_mostly;
@@ -1389,6 +1393,24 @@ static void vhost_net_flush(struct vhost_net *n)
 	}
 }
 
+static void vhost_net_cleanup(struct work_struct *work)
+{
+	struct vhost_net *n =
+		container_of(to_rcu_work(work), struct vhost_net, rwork);
+	vhost_dev_cleanup(&n->dev);
+	vhost_net_vq_reset(n);
+	if (n->tx_sock)
+		sockfd_put(n->tx_sock);
+	if (n->rx_sock)
+		sockfd_put(n->rx_sock);
+	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
+	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
+	kfree(n->dev.vqs);
+	if (n->page_frag.page)
+		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
+	kvfree(n);
+}
+
 static int vhost_net_release(struct inode *inode, struct file *f)
 {
 	struct vhost_net *n = f->private_data;
@@ -1398,21 +1420,11 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 	vhost_net_stop(n, &tx_sock, &rx_sock);
 	vhost_net_flush(n);
 	vhost_dev_stop(&n->dev);
-	vhost_dev_cleanup(&n->dev);
-	vhost_net_vq_reset(n);
-	if (tx_sock)
-		sockfd_put(tx_sock);
-	if (rx_sock)
-		sockfd_put(rx_sock);
-	/* Make sure no callbacks are outstanding */
-	synchronize_rcu();
+	n->tx_sock = tx_sock;
+	n->rx_sock = rx_sock;
 
-	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
-	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
-	kfree(n->dev.vqs);
-	if (n->page_frag.page)
-		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
-	kvfree(n);
+	INIT_RCU_WORK(&n->rwork, vhost_net_cleanup);
+	queue_rcu_work(system_wq, &n->rwork);
 	return 0;
 }
 
-- 

