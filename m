Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B185D14B3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbfJIQ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:57:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44802 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731451AbfJIQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:57:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id r16so2642702edq.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=at370kWjC+LUESAY4tkAqQaR26pmhJRvBRmjCEIpUw0=;
        b=RsYXWkGOTGVNrjU1NYeKRB/ilsUerL0y5lfD2BQz3QODsrLKoW2uQz9o9KH899wcbG
         rB/l8iEIJK2n8Ti1loJWbzM8nluHqERZiRgDgP2MnNO4cbx8tNy6kpjALmv9Ib9t/T1B
         lXsDGc654EzfxVJbX+IfDIQvfRB8+7SuNwunSSjQAfRKdC4BmNefdKLqjbm64V5FP96c
         fb/gN8V64PnuHe8pJJ687gttTX6rpS5+v55iPyxEefGufyzxdmo2WXPXUw0z384VMskY
         SF0r9EWOgfVKGebm1UhgG7zsB/wkJgnWk+VJGB7K2jM3+G2qA37boIykE0O3B52uxmVg
         8brA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=at370kWjC+LUESAY4tkAqQaR26pmhJRvBRmjCEIpUw0=;
        b=Y0HXok4zpIWr+ceLd0bBdZSctthqHjxgWJqQ/Ms5ch7nCmLhsCfox2EITVtbZMrMz0
         GK59efJ6rN/+CQU3XZinxvZFDD5J7aiZ0fpEXDHFkbfVG0FQ5GL7GIAlLThlAJFDxMpw
         aJ2ZtE3G5X/T+Jli85k6K81ojt3WQoIg0m441nelI4svr+V5rHqNP5h31cV/1FQVLXfT
         5MX1r3YT3lxwodE9F1E6mpMiLKMsfvm/ODq2GtCb2EjEvMFlsDQPXuliV7XeBHBA9fvH
         gDH4tmJ/p+rqPpNEwUX+LM67LRyKx/JfwWayKdKUHYClzCdMz82c7KpKotdUJmDTOhtH
         Tc+w==
X-Gm-Message-State: APjAAAU+yAI1U7No89i9lVh311TFPBabPrnjFD0GRgYOSb2pKJ93z0aC
        eZjwKM/RH/I+BXIULo0MH3Q=
X-Google-Smtp-Source: APXvYqzEFdLbGavUdP0aB9gQlfiaCeyG3AC4KXUqnmeHyvv9rTK+fnjKb7Cd+erJc8jwOslXkZcrYw==
X-Received: by 2002:a17:907:2172:: with SMTP id rl18mr3846168ejb.125.1570640264287;
        Wed, 09 Oct 2019 09:57:44 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id s9sm317741ejf.44.2019.10.09.09.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 09:57:43 -0700 (PDT)
Date:   Wed, 9 Oct 2019 16:57:39 +0000
From:   Pooja Trivedi <poojatrivedi@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20191009165739.GA1848@kvmhost.ch.hwng.net>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
 <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
 <20190918142549.69bfa285@cakuba.netronome.com>
 <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
 <20190918144528.57a5cb50@cakuba.netronome.com>
 <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
 <20190923172811.1f620803@cakuba.netronome.com>
 <CAOrEds=zEh5R_4G1UuT-Ee3LT-ZiTV=1JNWb_4a=5Mb4coFEVg@mail.gmail.com>
 <20190927173753.418634ef@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190927173753.418634ef@cakuba.netronome.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 05:37:53PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Sep 2019 12:48:26 -0400, Pooja Trivedi wrote:
> > On Mon, Sep 23, 2019 at 8:28 PM Jakub Kicinski wrote:
> > > On Sat, 21 Sep 2019 23:19:20 -0400, Pooja Trivedi wrote: =20
> > > > On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski wrote: =20
> > > > > On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote: =20
> > > > > > Hi Jakub,
> > > > > >
> > > > > > I have explained one potential way for the race to happen in my
> > > > > > original message to the netdev mailing list here:
> > > > > > https://marc.info/?l=3Dlinux-netdev&m=3D156805120229554&w=3D2
> > > > > >
> > > > > > Here is the part out of there that's relevant to your question:
> > > > > >
> > > > > > -----------------------------------------
> > > > > >
> > > > > > One potential way for race condition to appear:
> > > > > >
> > > > > > When under tcp memory pressure, Thread 1 takes the following co=
de path:
> > > > > > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > > > > > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > > > > > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event =
=20
> > > > >
> > > > > Ugh, so do_tcp_sendpages() can also release the lock :/
> > > > >
> > > > > Since the problem occurs in tls_sw_do_sendpage() and
> > > > > tls_sw_do_sendmsg() as well, should we perhaps fix it at that lev=
el? =20
> > > >
> > > > That won't do because tls_tx_records also gets called when completi=
on
> > > > callbacks schedule delayed work. That was the code path that caused
> > > > the crash for my test. Cavium's nitrox crypto offload driver calling
> > > > tls_encrypt_done, which calls schedule_delayed_work. Delayed work t=
hat
> > > > was scheduled would then be processed by tx_work_handler.
> > > > Notice in my previous reply,
> > > > "Thread 2 code path:
> > > > tx_work_handler ---> tls_tx_records"
> > > >
> > > > "Thread 2 code path:
> > > > tx_work_handler ---> tls_tx_records" =20
> > >
> > > Right, the work handler would obviously also have to obey the exclusi=
on
> > > mechanism of choice.
> > >
> > > Having said that this really does feel like we are trying to lock cod=
e,
> > > not data here :( =20
> >=20
> > Agree with you and exactly the thought process I went through. So what
> > are some other options?
> >=20
> > 1) A lock member inside of ctx to protect tx_list
> > We are load testing ktls offload with nitrox and the performance was
> > quite adversely affected by this. This approach can be explored more,
> > but the original design of using socket lock didn't follow this model
> > either.
> > 2) Allow tagging of individual record inside of tx_list to indicate if
> > it has been 'processed'
> > This approach would likely protect the data without compromising
> > performance. It will allow Thread 2 to proceed with the TX portion of
> > tls_tx_records while Thread 1 sleeps waiting for memory. There will
> > need to be careful cleanup and backtracking after the thread wakes up
> > to ensure a consistent state of tx_list and record transmission.
> > The approach has several problems, however -- (a) It could cause
> > out-of-order record tx (b) If Thread 1 is waiting for memory, Thread 2
> > most likely will (c) Again, socket lock wasn't designed to follow this
> > model to begin with
> >=20
> >=20
> > Given that socket lock essentially was working as a code protector --
> > as an exclusion mechanism to allow only a single writer through
> > tls_tx_records at a time -- what other clean ways do we have to fix
> > the race without a significant refactor of the design and code?
>=20
> Very sorry about the delay. I don't think we can maintain the correct
> semantics without sleeping :( If we just bail in tls_tx_records() when
> there's already another writer the later writer will return from the
> system call, even though the data is not pushed into the TCP layer.
>=20

Thanks for your response and sorry about the delay!

I am trying the following scenarios in my head to see how valid your
concern is. Play along with me please.

The two main writers in picture here are
Thread 1 -- Enqueue thread (sendfile system call) -- pushes records to
card, also performs completions (push to tcp) if records are ready
Thread 2 -- Work handler (tx_work_handler) -- bottom-half completions routi=
ne

With the submitted patch,
Case 1 (your concern) : Thread 2 grabs socket lock, calls
tls_tx_records, runs into memory pressure, releases socket lock, waits
for memory. Now Thread 1 grabs socket lock, calls tls_tx_records, bails.
In this case, sendfile system call will bail out without performing
completions. Is that really a problem? When Thread 1 ultimately
proceeds, it will perform the completions anyway.

Case 2: Threads grab socket lock in a reverse sequence of Case 1. So
Thread 1 grabs socket lock first and ends up waiting for memory.
Thread 2 comes in later and bails from tls_tx_records.
In this case, in the submitted patch, I realized that we are not rescheduli=
ng=20
the work before bailing. So I think an amendment to that patch,=20
something along the lines of what's shown below, would fare better.

***************************************************************************=
*****

diff --git a/include/net/tls.h b/include/net/tls.h
index c664e6dba0d1..4ae3b4822770 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -162,6 +162,7 @@ struct tls_sw_context_tx {
=20
 #define BIT_TX_SCHEDULED	0
 #define BIT_TX_CLOSING		1
+#define BIT_TX_IN_PROGRESS	2
 	unsigned long tx_bitmask;
 };
=20
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c2b5e0d2ba1a..608db30bbe62 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -359,7 +359,7 @@ static void tls_free_open_rec(struct sock *sk)
 	}
 }
=20
-int tls_tx_records(struct sock *sk, int flags)
+int tls_tx_records(struct sock *sk, int flags, bool bh)
 {
 	struct tls_context *tls_ctx =3D tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx =3D tls_sw_ctx_tx(tls_ctx);
@@ -367,6 +367,15 @@ int tls_tx_records(struct sock *sk, int flags)
 	struct sk_msg *msg_en;
 	int tx_flags, rc =3D 0;
=20
+	/* If another writer is already in tls_tx_records, backoff and leave */
+	if (test_and_set_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask)) {
+		if (bh) {
+			if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+				schedule_delayed_work(&ctx->tx_work.work, 1);
+		}
+		return 0;
+	}
+
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rec =3D list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
@@ -415,6 +424,9 @@ int tls_tx_records(struct sock *sk, int flags)
 	if (rc < 0 && rc !=3D -EAGAIN)
 		tls_err_abort(sk, EBADMSG);
=20
+	/* clear the bit so another writer can get into tls_tx_records */
+	clear_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask);
+
 	return rc;
 }
=20
@@ -747,7 +759,7 @@ static int tls_push_record(struct sock *sk, int flags,
 		ctx->open_rec =3D tmp;
 	}
=20
-	return tls_tx_records(sk, flags);
+	return tls_tx_records(sk, flags, false);
 }
=20
 static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
@@ -1084,7 +1096,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *ms=
g, size_t size)
 	/* Transmit if any encryptions have completed */
 	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 		cancel_delayed_work(&ctx->tx_work.work);
-		tls_tx_records(sk, msg->msg_flags);
+		tls_tx_records(sk, msg->msg_flags, false);
 	}
=20
 send_end:
@@ -1208,7 +1220,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct=
 page *page,
 		/* Transmit if any encryptions have completed */
 		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 			cancel_delayed_work(&ctx->tx_work.work);
-			tls_tx_records(sk, flags);
+			tls_tx_records(sk, flags, false);
 		}
 	}
 sendpage_end:
@@ -2072,7 +2084,7 @@ void tls_sw_release_resources_tx(struct sock *sk)
 	if (atomic_read(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
=20
-	tls_tx_records(sk, -1);
+	tls_tx_records(sk, -1, false);
=20
 	/* Free up un-sent records in tx_list. First, free
 	 * the partially sent record if any at head of tx_list.
@@ -2171,7 +2183,7 @@ static void tx_work_handler(struct work_struct *work)
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
 	lock_sock(sk);
-	tls_tx_records(sk, -1);
+	tls_tx_records(sk, -1, true);
 	release_sock(sk);
 }

***************************************************************************=
*****

> What was reason for the performance impact on (1)?=20


While the performance impact still needs to be investigated, that effort ha=
s stopped short due=20
to other issues with that approach like hard lockups. The basic problem is =
that the socket lock=20
is touched at multiple layers (tls, tcp etc.).

Here are the two approaches we tried along the lines of using an additional=
 lock...

Approach 1 -- Protect tx_list with a spinlock_t tx_list_lock :

***************************************************************************=
*****

--- test/linux-5.3.2/include/net/tls.h	2019-10-01 02:24:50.000000000 -0400
+++ linux-5.3.2/include/net/tls.h	2019-10-01 09:34:34.490353833 -0400
@@ -155,6 +155,7 @@
 	struct tx_work tx_work;
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
+	spinlock_t tx_list_lock;	/* protects records list */
 	atomic_t encrypt_pending;
 	int async_notify;
 	int async_capable;
--- test/linux-5.3.2/net/tls/tls_sw.c	2019-10-01 02:24:50.000000000 -0400
+++ tls/tls_sw.c	2019-10-01 09:55:55.113629719 -0400
@@ -366,7 +366,9 @@
 	struct tls_rec *rec, *tmp;
 	struct sk_msg *msg_en;
 	int tx_flags, rc =3D 0;
-
+	unsigned long lock_flags;
+=09
+	spin_lock_irqsave(&ctx->tx_list_lock, lock_flags);=09
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rec =3D list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
@@ -412,6 +414,7 @@
 	}
=20
 tx_err:
+	spin_unlock_irqrestore(&ctx->tx_list_lock, lock_flags);=09
 	if (rc < 0 && rc !=3D -EAGAIN)
 		tls_err_abort(sk, EBADMSG);
=20
@@ -1195,6 +1198,7 @@
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
+		//printk("%s %d\n", __func__, __LINE__);
 		ret =3D sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
 			tls_trim_both_msgs(sk, msg_pl->sg.size);
@@ -2259,6 +2263,7 @@
 		aead =3D &sw_ctx_tx->aead_send;
 		INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
 		INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
+		spin_lock_init(&sw_ctx_tx->tx_list_lock);
 		sw_ctx_tx->tx_work.sk =3D sk;
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);

***************************************************************************=
*****

Approach 1 produced the following crash:

---------------------------------------------------------------------------=
-----

[  771.311524] 00000000: 7d 33 88 93 0f 93 b2 42
[ 1658.735003] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
[ 1658.735004] Modules linked in: n5pf(OE) tls(OE) netconsole ip6t_rpfilter=
 ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set n=
fnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_s=
ecurity ip6table_raw iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defr=
ag_ipv4 iptable_mangle iptable_security iptable_raw ebtable_filter ebtables=
 ip6table_filter ip6_tables iptable_filter intel_rapl_msr intel_rapl_common=
 sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_=
wdt iTCO_vendor_support mxm_wmi irqbypass crct10dif_pclmul crc32_pclmul gha=
sh_clmulni_intel aesni_intel ses crypto_simd enclosure cryptd mei_me pcspkr=
 glue_helper sg mei i2c_i801 lpc_ich ipmi_si ipmi_devintf ipmi_msghandler w=
mi acpi_pad ip_tables xfs libcrc32c sd_mod ast drm_vram_helper ttm drm_kms_=
helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm qede qed igb liqui=
dio mpt3sas ahci crc32c_intel libahci dca libata crc8 raid_class ptp scsi_t=
ransport_sas i2c_algo_bit
[ 1658.735018]  pps_core dm_mirror dm_region_hash dm_log dm_mod
[ 1658.735020] CPU: 15 PID: 435 Comm: kworker/15:1 Kdump: loaded Tainted: G=
           OE     5.3.2 #2
[ 1658.735020] Hardware name: Echostreams DOPPLER/S7076GM2NR, BIOS V7.401 0=
5/12/2017
[ 1658.735020] Workqueue: events tx_work_handler [tls]
[ 1658.735021] RIP: 0010:native_queued_spin_lock_slowpath+0x5d/0x1f0
[ 1658.735021] Code: ff ff 75 3e f0 0f ba 2f 08 0f 82 27 01 00 00 31 d2 8b =
07 30 e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b=
> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47
[ 1658.735022] RSP: 0018:ffffa02087083e00 EFLAGS: 00000002
[ 1658.735022] RAX: 0000000000000101 RBX: 0000000000000282 RCX: ffff939d9f4=
6a960
[ 1658.735023] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff938e441=
c4ca8
[ 1658.735023] RBP: ffff939d9df38940 R08: 000073746e657665 R09: 80808080808=
08080
[ 1658.735023] R10: 0000000000000001 R11: ffff939d97c09438 R12: 00000000fff=
fffff
[ 1658.735023] R13: ffff939d9f470700 R14: 0000000000000000 R15: ffff938e441=
c4c00
[ 1658.735024] FS:  0000000000000000(0000) GS:ffff939d9f440000(0000) knlGS:=
0000000000000000
[ 1658.735024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1658.735024] CR2: 00007f0b08006000 CR3: 00000010369f2003 CR4: 00000000003=
606e0
[ 1658.735025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1658.735025] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1658.735025] Call Trace:
[ 1658.735025]  queued_spin_lock_slowpath+0x7/0x17
[ 1658.735026]  _raw_spin_lock_irqsave+0x35/0x40
[ 1658.735026]  tls_tx_records+0x3f/0x200 [tls]
[ 1658.735026]  tx_work_handler+0x4b/0x60 [tls]
[ 1658.735026]  process_one_work+0x171/0x380
[ 1658.735027]  worker_thread+0x49/0x3f0
[ 1658.735027]  kthread+0xf8/0x130
[ 1658.735027]  ? max_active_store+0x80/0x80
[ 1658.735027]  ? kthread_bind+0x10/0x10
[ 1658.735027]  ret_from_fork+0x35/0x40
[ 1658.735028] Kernel panic - not syncing: Hard LOCKUP
[ 1658.735028] CPU: 15 PID: 435 Comm: kworker/15:1 Kdump: loaded Tainted: G=
           OE     5.3.2 #2
[ 1658.735028] Hardware name: Echostreams DOPPLER/S7076GM2NR, BIOS V7.401 0=
5/12/2017
[ 1658.735029] Workqueue: events tx_work_handler [tls]
[ 1658.735029] Call Trace:
[ 1658.735029]  <NMI>
[ 1658.735029]  dump_stack+0x5a/0x73
[ 1658.735030]  panic+0x102/0x2ec
[ 1658.735030]  ? ret_from_fork+0x34/0x40
[ 1658.735030]  nmi_panic+0x37/0x40
[ 1658.735030]  watchdog_overflow_callback+0xef/0x110
[ 1658.735031]  __perf_event_overflow+0x51/0xe0
[ 1658.735031]  handle_pmi_common+0x1b2/0x270
[ 1658.735031]  intel_pmu_handle_irq+0xad/0x170
[ 1658.735032]  perf_event_nmi_handler+0x2e/0x50
[ 1658.735032]  nmi_handle+0x6e/0x110
[ 1658.735032]  default_do_nmi+0x3e/0x110
[ 1658.735033]  do_nmi+0x164/0x1c0
[ 1658.735033]  end_repeat_nmi+0x16/0x50
[ 1658.735033] RIP: 0010:native_queued_spin_lock_slowpath+0x5d/0x1f0
[ 1658.735034] Code: ff ff 75 3e f0 0f ba 2f 08 0f 82 27 01 00 00 31 d2 8b =
07 30 e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b=
> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47
[ 1658.735034] RSP: 0018:ffffa02087083e00 EFLAGS: 00000002
[ 1658.735035] RAX: 0000000000000101 RBX: 0000000000000282 RCX: ffff939d9f4=
6a960
[ 1658.735035] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff938e441=
c4ca8
[ 1658.735036] RBP: ffff939d9df38940 R08: 000073746e657665 R09: 80808080808=
08080
[ 1658.735036] R10: 0000000000000001 R11: ffff939d97c09438 R12: 00000000fff=
fffff
[ 1658.735036] R13: ffff939d9f470700 R14: 0000000000000000 R15: ffff938e441=
c4c00
[ 1658.735037]  ? native_queued_spin_lock_slowpath+0x5d/0x1f0
[ 1658.735037]  ? native_queued_spin_lock_slowpath+0x5d/0x1f0
[ 1658.735037]  </NMI>
[ 1658.735037]  queued_spin_lock_slowpath+0x7/0x17
[ 1658.735037]  _raw_spin_lock_irqsave+0x35/0x40
[ 1658.735038]  tls_tx_records+0x3f/0x200 [tls]
[ 1658.735038]  tx_work_handler+0x4b/0x60 [tls]
[ 1658.735038]  process_one_work+0x171/0x380
[ 1658.735038]  worker_thread+0x49/0x3f0
[ 1658.735039]  kthread+0xf8/0x130
[ 1658.735039]  ? max_active_store+0x80/0x80
[ 1658.735039]  ? kthread_bind+0x10/0x10
[ 1658.735039]  ret_from_fork+0x35/0x40

---------------------------------------------------------------------------=
-----

Approach 2 -- Protect tx_list with a spinlock_t tx_list_lock and move lock/=
release of socket lock to tls_push_sg :

***************************************************************************=
*****

diff --git a/test/linux-5.3.2/include/net/tls.h b/linux-5.3.2/include/net/t=
ls.h
index 41b2d41..8606e55 100644
--- a/test/linux-5.3.2/include/net/tls.h
+++ b/linux-5.3.2/include/net/tls.h
@@ -155,6 +155,7 @@ struct tls_sw_context_tx {
 	struct tx_work tx_work;
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
+	spinlock_t tx_list_lock;	/* protects records list */
 	atomic_t encrypt_pending;
 	int async_notify;
 	int async_capable;
diff --git a/test/linux-5.3.2/net/tls/tls_main.c b/tls/tls_main.c
index 43252a8..c31180c 100644
--- a/test/linux-5.3.2/net/tls/tls_main.c
+++ b/tls/tls_main.c
@@ -106,11 +106,13 @@ int tls_push_sg(struct sock *sk,
 	struct page *p;
 	size_t size;
 	int offset =3D first_offset;
+	int rc =3D 0;
=20
 	size =3D sg->length - offset;
 	offset +=3D sg->offset;
=20
 	ctx->in_tcp_sendpages =3D true;
+	lock_sock(sk);
 	while (1) {
 		if (sg_is_last(sg))
 			sendpage_flags =3D flags;
@@ -132,7 +134,8 @@ retry:
 			ctx->partially_sent_offset =3D offset;
 			ctx->partially_sent_record =3D (void *)sg;
 			ctx->in_tcp_sendpages =3D false;
-			return ret;
+			rc =3D ret;
+			goto end;
 		}
=20
 		put_page(p);
@@ -146,8 +149,9 @@ retry:
 	}
=20
 	ctx->in_tcp_sendpages =3D false;
-
-	return 0;
+end:
+	release_sock(sk);
+	return rc;
 }
=20
 static int tls_handle_open_record(struct sock *sk, int flags)
diff --git a/test/linux-5.3.2/net/tls/tls_sw.c b/tls/tls_sw.c
index 91d21b0..32042f3 100644
--- a/test/linux-5.3.2/net/tls/tls_sw.c
+++ b/tls/tls_sw.c
@@ -366,7 +366,9 @@ int tls_tx_records(struct sock *sk, int flags)
 	struct tls_rec *rec, *tmp;
 	struct sk_msg *msg_en;
 	int tx_flags, rc =3D 0;
+	unsigned long lock_flags;
=20
+	spin_lock_irqsave(&ctx->tx_list_lock, lock_flags);=09
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rec =3D list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
@@ -412,6 +414,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
=20
 tx_err:
+	spin_unlock_irqrestore(&ctx->tx_list_lock, lock_flags);
 	if (rc < 0 && rc !=3D -EAGAIN)
 		tls_err_abort(sk, EBADMSG);
=20
@@ -1110,7 +1113,9 @@ static int tls_sw_do_sendpage(struct sock *sk, struct=
 page *page,
 	int record_room;
 	int ret =3D 0;
 	bool eor;
+	int flag =3D 0;
=20
+	lock_sock(sk);
 	eor =3D !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
=20
@@ -1195,6 +1200,7 @@ alloc_payload:
 wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
+		//printk("%s %d\n", __func__, __LINE__);
 		ret =3D sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
 			tls_trim_both_msgs(sk, msg_pl->sg.size);
@@ -1208,10 +1214,14 @@ wait_for_memory:
 		/* Transmit if any encryptions have completed */
 		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 			cancel_delayed_work(&ctx->tx_work.work);
+			release_sock(sk);
+			flag =3D 1;
 			tls_tx_records(sk, flags);
 		}
 	}
 sendpage_end:
+	if (flag =3D=3D 0)
+		release_sock(sk);
 	ret =3D sk_stream_error(sk, flags, ret);
 	return copied ? copied : ret;
 }
@@ -1225,9 +1235,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *pag=
e,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -ENOTSUPP;
=20
-	lock_sock(sk);
 	ret =3D tls_sw_do_sendpage(sk, page, offset, size, flags);
-	release_sock(sk);
 	return ret;
 }
=20
@@ -2172,9 +2180,9 @@ static void tx_work_handler(struct work_struct *work)
=20
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	lock_sock(sk);
+	//lock_sock(sk);
 	tls_tx_records(sk, -1);
-	release_sock(sk);
+	//release_sock(sk);
 }
=20
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
@@ -2259,6 +2267,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_co=
ntext *ctx, int tx)
 		aead =3D &sw_ctx_tx->aead_send;
 		INIT_LIST_HEAD(&sw_ctx_tx->tx_list);
 		INIT_DELAYED_WORK(&sw_ctx_tx->tx_work.work, tx_work_handler);
+		spin_lock_init(&sw_ctx_tx->tx_list_lock);
 		sw_ctx_tx->tx_work.sk =3D sk;
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);

***************************************************************************=
*****

Approach 2 produced the following crash:

---------------------------------------------------------------------------=
-----

[  177.884608] 00000000: 7d 33 88 93 0f 93 b2 42
[  571.779993] NMI watchdog: Watchdog detected hard LOCKUP on cpu 24
[  571.779993] Modules linked in: n5pf(OE) tls(OE) netconsole ip6t_rpfilter=
 ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set n=
fnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_s=
ecurity ip6table_raw iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defr=
ag_ipv4 iptable_mangle iptable_security iptable_raw ebtable_filter ebtables=
 ip6table_filter ip6_tables iptable_filter intel_rapl_msr intel_rapl_common=
 sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt =
kvm iTCO_vendor_support mxm_wmi irqbypass crct10dif_pclmul crc32_pclmul gha=
sh_clmulni_intel aesni_intel ses enclosure crypto_simd mei_me cryptd glue_h=
elper pcspkr sg mei i2c_i801 lpc_ich ipmi_si ipmi_devintf ipmi_msghandler w=
mi acpi_pad ip_tables xfs libcrc32c sd_mod ast drm_vram_helper ttm drm_kms_=
helper qede syscopyarea sysfillrect sysimgblt fb_sys_fops qed drm liquidio =
igb ahci libahci mpt3sas crc32c_intel libata dca crc8 ptp raid_class scsi_t=
ransport_sas i2c_algo_bit
[  571.780006]  pps_core dm_mirror dm_region_hash dm_log dm_mod
[  571.780007] CPU: 24 PID: 13915 Comm: uperf Kdump: loaded Tainted: G     =
      OE     5.3.2 #2
[  571.780007] Hardware name: Echostreams DOPPLER/S7076GM2NR, BIOS V7.401 0=
5/12/2017
[  571.780008] RIP: 0010:native_queued_spin_lock_slowpath+0x5f/0x1f0
[  571.780008] Code: 75 3e f0 0f ba 2f 08 0f 82 27 01 00 00 31 d2 8b 07 30 =
e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 8b 07 <84=
> c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47 01 00
[  571.780008] RSP: 0018:ffffbba507f6fbf8 EFLAGS: 00000002
[  571.780009] RAX: 0000000000000101 RBX: 0000000000000296 RCX: dead0000000=
00122
[  571.780009] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff96ea43c=
27428
[  571.780009] RBP: ffff96f199250940 R08: 0000000000000001 R09: ffff96f1925=
8c5c0
[  571.780010] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[  571.780010] R13: 0000000000001000 R14: ffff96f1c3c84000 R15: ffff96ea43c=
27380
[  571.780010] FS:  00007f3d40d6e700(0000) GS:ffff96f99f680000(0000) knlGS:=
0000000000000000
[  571.780010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  571.780011] CR2: 00007f75400058b0 CR3: 0000000859128001 CR4: 00000000003=
606e0
[  571.780011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  571.780011] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  571.780011] Call Trace:
[  571.780011]  queued_spin_lock_slowpath+0x7/0x17
[  571.780012]  _raw_spin_lock_irqsave+0x35/0x40
[  571.780012]  tls_tx_records+0x3f/0x200 [tls]
[  571.780012]  tls_sw_sendpage+0x3ea/0x420 [tls]
[  571.780012]  inet_sendpage+0x52/0x80
[  571.780012]  ? direct_splice_actor+0x40/0x40
[  571.780013]  kernel_sendpage+0x1a/0x30
[  571.780013]  sock_sendpage+0x23/0x30
[  571.780013]  pipe_to_sendpage+0x5d/0xa0
[  571.780013]  __splice_from_pipe+0xff/0x170
[  571.780013]  ? generic_file_splice_read+0x19a/0x1b0
[  571.780014]  ? direct_splice_actor+0x40/0x40
[  571.780014]  splice_from_pipe+0x5b/0x90
[  571.780014]  direct_splice_actor+0x35/0x40
[  571.780014]  splice_direct_to_actor+0xb3/0x240
[  571.780015]  ? generic_pipe_buf_nosteal+0x10/0x10
[  571.780015]  do_splice_direct+0x87/0xd0
[  571.780015]  do_sendfile+0x1c6/0x3d0
[  571.780015]  __x64_sys_sendfile64+0x5c/0xb0
[  571.780015]  do_syscall_64+0x5b/0x1d0
[  571.780016]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  571.780016] RIP: 0033:0x7f3d436a1f1a
[  571.780016] Code: 31 c0 5b c3 0f 1f 40 00 48 89 da 4c 89 ce 44 89 c7 5b =
e9 09 fe ff ff 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 28 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 26 2f 2d 00 f7 d8 64 89 01 48
[  571.780016] RSP: 002b:00007f3d40d6dd08 EFLAGS: 00000206 ORIG_RAX: 000000=
0000000028
[  571.780017] RAX: ffffffffffffffda RBX: 00000000010f9460 RCX: 00007f3d436=
a1f1a
[  571.780017] RDX: 00007f3d40d6dd18 RSI: 0000000000000005 RDI: 00000000000=
0000c
[  571.780018] RBP: 000000000000000c R08: 0000000000001000 R09: 00007f3d439=
75140
[  571.780018] R10: 0000000000001000 R11: 0000000000000206 R12: 00000000000=
00000
[  571.780018] R13: 0000000000001000 R14: 0000000000000000 R15: 00000000011=
054d0
[  571.780018] Kernel panic - not syncing: Hard LOCKUP
[  571.780019] CPU: 24 PID: 13915 Comm: uperf Kdump: loaded Tainted: G     =
      OE     5.3.2 #2
[  571.780019] Hardware name: Echostreams DOPPLER/S7076GM2NR, BIOS V7.401 0=
5/12/2017
[  571.780019] Call Trace:
[  571.780019]  <NMI>
[  571.780020]  dump_stack+0x5a/0x73
[  571.780020]  panic+0x102/0x2ec
[  571.780020]  nmi_panic+0x37/0x40
[  571.780020]  watchdog_overflow_callback+0xef/0x110
[  571.780020]  __perf_event_overflow+0x51/0xe0
[  571.780021]  handle_pmi_common+0x1b2/0x270
[  571.780021]  intel_pmu_handle_irq+0xad/0x170
[  571.780021]  perf_event_nmi_handler+0x2e/0x50
[  571.780021]  nmi_handle+0x6e/0x110
[  571.780021]  default_do_nmi+0xc3/0x110
[  571.780021]  do_nmi+0x164/0x1c0
[  571.780022]  end_repeat_nmi+0x16/0x50
[  571.780022] RIP: 0010:native_queued_spin_lock_slowpath+0x5f/0x1f0
[  571.780022] Code: 75 3e f0 0f ba 2f 08 0f 82 27 01 00 00 31 d2 8b 07 30 =
e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 8b 07 <84=
> c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47 01 00
[  571.780023] RSP: 0018:ffffbba507f6fbf8 EFLAGS: 00000002
[  571.780023] RAX: 0000000000000101 RBX: 0000000000000296 RCX: dead0000000=
00122
[  571.780023] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff96ea43c=
27428
[  571.780023] RBP: ffff96f199250940 R08: 0000000000000001 R09: ffff96f1925=
8c5c0
[  571.780024] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[  571.780024] R13: 0000000000001000 R14: ffff96f1c3c84000 R15: ffff96ea43c=
27380
[  571.780024]  ? native_queued_spin_lock_slowpath+0x5f/0x1f0
[  571.780024]  ? native_queued_spin_lock_slowpath+0x5f/0x1f0
[  571.780025]  </NMI>
[  571.780025]  queued_spin_lock_slowpath+0x7/0x17
[  571.780025]  _raw_spin_lock_irqsave+0x35/0x40
[  571.780025]  tls_tx_records+0x3f/0x200 [tls]
[  571.780025]  tls_sw_sendpage+0x3ea/0x420 [tls]
[  571.780026]  inet_sendpage+0x52/0x80
[  571.780026]  ? direct_splice_actor+0x40/0x40
[  571.780026]  kernel_sendpage+0x1a/0x30
[  571.780026]  sock_sendpage+0x23/0x30
[  571.780026]  pipe_to_sendpage+0x5d/0xa0
[  571.780027]  __splice_from_pipe+0xff/0x170
[  571.780027]  ? generic_file_splice_read+0x19a/0x1b0
[  571.780027]  ? direct_splice_actor+0x40/0x40
[  571.780027]  splice_from_pipe+0x5b/0x90
[  571.780027]  direct_splice_actor+0x35/0x40
[  571.780028]  splice_direct_to_actor+0xb3/0x240
[  571.780028]  ? generic_pipe_buf_nosteal+0x10/0x10
[  571.780028]  do_splice_direct+0x87/0xd0
[  571.780028]  do_sendfile+0x1c6/0x3d0
[  571.780028]  __x64_sys_sendfile64+0x5c/0xb0
[  571.780029]  do_syscall_64+0x5b/0x1d0
[  571.780029]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  571.780029] RIP: 0033:0x7f3d436a1f1a
[  571.780029] Code: 31 c0 5b c3 0f 1f 40 00 48 89 da 4c 89 ce 44 89 c7 5b =
e9 09 fe ff ff 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 28 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 26 2f 2d 00 f7 d8 64 89 01 48
[  571.780030] RSP: 002b:00007f3d40d6dd08 EFLAGS: 00000206 ORIG_RAX: 000000=
0000000028
[  571.780030] RAX: ffffffffffffffda RBX: 00000000010f9460 RCX: 00007f3d436=
a1f1a
[  571.780030] RDX: 00007f3d40d6dd18 RSI: 0000000000000005 RDI: 00000000000=
0000c
[  571.780031] RBP: 000000000000000c R08: 0000000000001000 R09: 00007f3d439=
75140
[  571.780031] R10: 0000000000001000 R11: 0000000000000206 R12: 00000000000=
00000
[  571.780031] R13: 0000000000001000 R14: 0000000000000000 R15: 00000000011=
054d0

---------------------------------------------------------------------------=
-----

> My feeling is that
> we need to make writers wait to maintain socket write semantics, and
> that implies putting writers to sleep, which is indeed very costly..
>=20
> Perhaps something along the lines of:
>=20
> 	if (ctx->in_tcp_sendpages) {
> 		rc =3D sk_stream_wait_memory(sk, &timeo);
> 		...
> 	}
>=20
> in tls_tx_records() would be the "most correct" solution? If we get
> there and there is already a writer, that means the first writer has
> to be waiting for memory, and so should the second..
>=20
> WDYT?

Hmmm, I am not sure what the benefit would be of having two threads do the =
completions, as explained above with Case 1 and Case 2 scenarios. If we mad=
e the later thread wait also while earlier one waits for memory, just so th=
e later one can also perform the completions, it will either have no comple=
tions left to take care of or have minimal (a few records that may have sne=
aked in while the earlier thread returned and second made it in).

The only patch that we have been able to make consistently work without cra=
shing and also without compromising performance, is the previously submitte=
d one where later thread bails out of tls_tx_records. And as mentioned, it =
can perhaps be made more efficient by rescheduling delayed work in the case=
 where work handler thread turns out to be the later thread that has to bai=
l.
