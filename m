Return-Path: <netdev+bounces-5796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC1E712C49
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7432281986
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13025290FA;
	Fri, 26 May 2023 18:15:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018DC15BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:15:22 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5638E125
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:15:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2bxv-0007vo-Md; Fri, 26 May 2023 20:15:03 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2bxs-00089G-I9; Fri, 26 May 2023 20:15:00 +0200
Date: Fri, 26 May 2023 20:15:00 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
	Robin van der Gracht <robin@protonic.nl>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 2/2] can: j1939: avoid possible use-after-free when
 j1939_can_rx_register fails
Message-ID: <20230526181500.GA26860@pengutronix.de>
References: <20230526171910.227615-1-pchelkin@ispras.ru>
 <20230526171910.227615-3-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230526171910.227615-3-pchelkin@ispras.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Fedor,

On Fri, May 26, 2023 at 08:19:10PM +0300, Fedor Pchelkin wrote:
> Syzkaller reports the following failure:
> 
> BUG: KASAN: use-after-free in kref_put include/linux/kref.h:64 [inline]
> BUG: KASAN: use-after-free in j1939_priv_put+0x25/0xa0 net/can/j1939/main.c:172
> Write of size 4 at addr ffff888141c15058 by task swapper/3/0
> 
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.10.144-syzkaller #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x167 lib/dump_stack.c:118
>  print_address_description.constprop.0+0x1c/0x220 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:186 [inline]
>  check_memory_region+0x145/0x190 mm/kasan/generic.c:192
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
>  __refcount_sub_and_test include/linux/refcount.h:272 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>  refcount_dec_and_test include/linux/refcount.h:333 [inline]
>  kref_put include/linux/kref.h:64 [inline]
>  j1939_priv_put+0x25/0xa0 net/can/j1939/main.c:172
>  j1939_sk_sock_destruct+0x44/0x90 net/can/j1939/socket.c:374
>  __sk_destruct+0x4e/0x820 net/core/sock.c:1784
>  rcu_do_batch kernel/rcu/tree.c:2485 [inline]
>  rcu_core+0xb35/0x1a30 kernel/rcu/tree.c:2726
>  __do_softirq+0x289/0x9a3 kernel/softirq.c:298
>  asm_call_irq_on_stack+0x12/0x20
>  </IRQ>
>  __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
>  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
>  do_softirq_own_stack+0xaa/0xe0 arch/x86/kernel/irq_64.c:77
>  invoke_softirq kernel/softirq.c:393 [inline]
>  __irq_exit_rcu kernel/softirq.c:423 [inline]
>  irq_exit_rcu+0x136/0x200 kernel/softirq.c:435
>  sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1095
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
> 
> Allocated by task 1141:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc9/0xd0 mm/kasan/common.c:461
>  kmalloc include/linux/slab.h:552 [inline]
>  kzalloc include/linux/slab.h:664 [inline]
>  j1939_priv_create net/can/j1939/main.c:131 [inline]
>  j1939_netdev_start+0x111/0x860 net/can/j1939/main.c:268
>  j1939_sk_bind+0x8ea/0xd30 net/can/j1939/socket.c:485
>  __sys_bind+0x1f2/0x260 net/socket.c:1645
>  __do_sys_bind net/socket.c:1656 [inline]
>  __se_sys_bind net/socket.c:1654 [inline]
>  __x64_sys_bind+0x6f/0xb0 net/socket.c:1654
>  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> 
> Freed by task 1141:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
>  __kasan_slab_free+0x112/0x170 mm/kasan/common.c:422
>  slab_free_hook mm/slub.c:1542 [inline]
>  slab_free_freelist_hook+0xad/0x190 mm/slub.c:1576
>  slab_free mm/slub.c:3149 [inline]
>  kfree+0xd9/0x3b0 mm/slub.c:4125
>  j1939_netdev_start+0x5ee/0x860 net/can/j1939/main.c:300
>  j1939_sk_bind+0x8ea/0xd30 net/can/j1939/socket.c:485
>  __sys_bind+0x1f2/0x260 net/socket.c:1645
>  __do_sys_bind net/socket.c:1656 [inline]
>  __se_sys_bind net/socket.c:1654 [inline]
>  __x64_sys_bind+0x6f/0xb0 net/socket.c:1654
>  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> 
> It can be caused by this scenario:
> 
> CPU0					CPU1
> j1939_sk_bind(socket0, ndev0, ...)
>   j1939_netdev_start()
> 					j1939_sk_bind(socket1, ndev0, ...)
>                                           j1939_netdev_start()
>   mutex_lock(&j1939_netdev_lock)
>   j1939_priv_set(ndev0, priv)
>   mutex_unlock(&j1939_netdev_lock)
> 					  if (priv_new)
> 					    kref_get(&priv_new->rx_kref)
> 					    return priv_new;
> 					  /* inside j1939_sk_bind() */
> 					  jsk->priv = priv
>   j1939_can_rx_register(priv) // fails
>   j1939_priv_set(ndev, NULL)
>   kfree(priv)
> 					j1939_sk_sock_destruct()
> 					j1939_priv_put() // <- uaf
> 
> To avoid this, call j1939_can_rx_register() under j1939_netdev_lock so
> that a concurrent thread cannot process j1939_priv before
> j1939_can_rx_register() returns.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  net/can/j1939/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 6ed79afe19a5..ecff1c947d68 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -290,16 +290,18 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  		return priv_new;
>  	}
>  	j1939_priv_set(ndev, priv);
> -	mutex_unlock(&j1939_netdev_lock);
>  
>  	ret = j1939_can_rx_register(priv);
>  	if (ret < 0)
>  		goto out_priv_put;
>  
> +	mutex_unlock(&j1939_netdev_lock);
>  	return priv;
>  
>   out_priv_put:
>  	j1939_priv_set(ndev, NULL);
> +	mutex_unlock(&j1939_netdev_lock);
> +
>  	dev_put(ndev);
>  	kfree(priv);
>  
> -- 
> 2.34.1
> 
> 


Thank you for your investigation. How about this change?
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -285,8 +285,7 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
                 */
                kref_get(&priv_new->rx_kref);
                spin_unlock(&j1939_netdev_lock);
-               dev_put(ndev);
-               kfree(priv);
+               j1939_priv_put(priv);
                return priv_new;
        }
        j1939_priv_set(ndev, priv);
@@ -300,8 +299,7 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 
  out_priv_put:
        j1939_priv_set(ndev, NULL);
-       dev_put(ndev);
-       kfree(priv);
+       j1939_priv_put(priv);
 
        return ERR_PTR(ret);
 }

If I see it correctly, the problem is kfree() which is called without respecting
the ref counting. If CPU1 has priv_new, refcounting is increased. The priv will
not be freed on this place.

Can you please test it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

