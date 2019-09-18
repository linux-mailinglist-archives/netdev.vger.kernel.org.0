Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F20B6EF0
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbfIRVh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:37:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41358 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732151AbfIRVh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:37:57 -0400
Received: by mail-vs1-f68.google.com with SMTP id l2so848090vsr.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 14:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vk7Mk6Hyk1UZ3/Jo6MnCpcwc/r22hRV4llpjGClQOAE=;
        b=KXFN/b4u3I9w3AbooCr7HnWd9AFUNmJ34hRoHiMtIH8q/ggcKv22gOdejM9IePmNMJ
         BOnCeYkC/qdGW7ix/y3y4x2YdCWhU/USU11kVtVcvsysZKl4Gm7pzsfZV1ufVPfi+gyw
         FRh483dC7gWvjsuom5BWm++aOZT/JfwyzotJz89g/CrixZVUZjosuWxdaA2mZ3wWaGq4
         QcXg3MSydpZ6ZL1cjQcvxjBSXAMlW5V1WGYZ+cm2WNxmbcki+hmi6aKuF8BBKBkzQW3n
         WZZ2fd6VuOFGoP7LWSR3em0YwdW0trhR48udBJDICPippIGVbCPLPtZ3GX6hxQy2a9VP
         shUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vk7Mk6Hyk1UZ3/Jo6MnCpcwc/r22hRV4llpjGClQOAE=;
        b=EDCTeug7AHt/e4xFmjkObgpXmVUTYsOTYHnU2bna7fturLsuDqacG8VOCeCSNUasN4
         M7ZOSqYYtV4eyj7hVl1W48pGz6woVvrmNd9ElI7xNvo0xI0CemJg3Cl5M2IgZGvSG4vB
         hWD2xHpqHlN5LKJ92SbHfl2NlDFzFSUEyCDIkI+UrYM08V/e2Z7NJge2ZAIeLJNXEKH/
         p3e5Ai3ePPSNA3tW+tF5cuHiCOD6OyOqe4zu5FKsk49l5DBvX7bW+UcaLSzITpsFpWGv
         /DQKegKS0n/LUjKnYbyCGQBJsmyA/CwUtthvNO+zyKCwaTEc6GBfyUuaN/zeR8j7HerE
         NW7g==
X-Gm-Message-State: APjAAAUpYA3rKehrdBpL7bb9XXkZSlhtLcyY/SwKZe9aiYgAMhsbxZGV
        HH1xMxLkwb8uSTtpb3hx/TR6ZcE7nuEYixEcMzg=
X-Google-Smtp-Source: APXvYqylWInDUB43HC4Qw/JRLD9kqTnwnK6/f7BREMUlMSiYpX5UHw2c5JS88uA/Bd0XJ9BwcQLqlzQ68eF0ETIX99g=
X-Received: by 2002:a67:f6c8:: with SMTP id v8mr3442318vso.22.1568842675504;
 Wed, 18 Sep 2019 14:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
 <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com> <20190918142549.69bfa285@cakuba.netronome.com>
In-Reply-To: <20190918142549.69bfa285@cakuba.netronome.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Wed, 18 Sep 2019 17:37:44 -0400
Message-ID: <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I have explained one potential way for the race to happen in my
original message to the netdev mailing list here:
https://marc.info/?l=linux-netdev&m=156805120229554&w=2

Here is the part out of there that's relevant to your question:

-----------------------------------------

One potential way for race condition to appear:

When under tcp memory pressure, Thread 1 takes the following code path:
do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event

sk_wait_event releases the socket lock and sleeps waiting for memory:

#define sk_wait_event(__sk, __timeo, __condition, __wait)       \
     ({  int __rc;                       \
         release_sock(__sk);                 \
         __rc = __condition;                 \
         if (!__rc) {                        \
             *(__timeo) = wait_woken(__wait,         \
                         TASK_INTERRUPTIBLE, \
                         *(__timeo));        \
         }                           \
         sched_annotate_sleep();                 \
         lock_sock(__sk);                    \
         __rc = __condition;                 \
         __rc;                           \
     })

Thread 2 code path:
tx_work_handler ---> tls_tx_records

Thread 2 is able to obtain the socket lock and go through the
transmission of the ctx->tx_list, deleting the sent ones (as in the
for loop below).

int tls_tx_records(struct sock *sk, int flags)
{
     ....
     ....
     ....
     ....
     list_for_each_entry_safe(rec, tmp, &ctx->tx_list, list) {
          if (READ_ONCE(rec->tx_ready)) {
              if (flags == -1)
                  tx_flags = rec->tx_flags;
              else
                  tx_flags = flags;

              msg_en = &rec->msg_encrypted;
              rc = tls_push_sg(sk, tls_ctx,
                       &msg_en->sg.data[msg_en->sg.curr],
                       0, tx_flags);
              if (rc)
                  goto tx_err;

              list_del(&rec->list); // **** crash location ****
              sk_msg_free(sk, &rec->msg_plaintext);
              kfree(rec);
          } else {
              break;
          }
      }
     ....
     ....
     ....
     ....
}

When Thread 1 wakes up from tls_push_sg call and attempts list_del on
previously grabbed record which was sent and deleted by Thread 2, it
causes the crash.

To fix this race, a flag or bool inside of ctx can be used to
synchronize access to tls_tx_records.

-----------------------------------------

Let me know if you need more information. Thanks!






On Wed, Sep 18, 2019 at 5:25 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 17 Sep 2019 21:13:56 +0000, Pooja Trivedi wrote:
> > From: Pooja Trivedi <pooja.trivedi@stackpath.com>
>
> Ugh the same problem was diagnosed recently by Mallesham but I just
> realized he took the conversation off list so you can't see it.
>
> > Enclosing tls_tx_records within lock_sock/release_sock pair to ensure
> > write-synchronization is not sufficient because socket lock gets released
> > under memory pressure situation by sk_wait_event while it sleeps waiting
> > for memory, allowing another writer into tls_tx_records. This causes a
> > race condition with record deletion post transmission.
> >
> > To fix this bug, use a flag set in tx_bitmask field of TLS context to
> > ensure single writer in tls_tx_records at a time
>
> Could you point me to the place where socket lock gets released in/under
> tls_tx_records()? I thought it's only done in tls_sw_do_sendpage()/
> tls_sw_do_sendmsg().
>
> FWIW this was my answer to Mallesham:
>
> If I understand you correctly after we release and re-acquire socket
> lock msg_pl may be pointing to already freed message? Could we perhaps
> reload the pointer from the context/record? Something like:
>
>         if (ret) {
>                 rec = ctx->open_rec;
>                 if (rec)
>                         tls_trim_both_msgs(sk, &rec->msg_plaintext.sg.size);
>                 goto sendpage_end;
>         }
>
> I'm not 100% sure if that makes sense, perhaps John will find time to
> look or you could experiment?
>
> We could try to add some state like we have ctx->in_tcp_sendpages to
> let the async processing know it's not needed since there's still a
> writer present, but I get a feeling that'd end up being more complex.
>
> > The bug resulted in the following crash:
> >
> > [  270.888952] ------------[ cut here ]------------
> > [  270.890450] list_del corruption, ffff91cc3753a800->prev is
> > LIST_POISON2 (dead000000000122)
> > [  270.891194] WARNING: CPU: 1 PID: 7387 at lib/list_debug.c:50
> > __list_del_entry_valid+0x62/0x90
> > [  270.892037] Modules linked in: n5pf(OE) netconsole tls(OE) bonding
> > intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
> > intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support
> > irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> > aesni_intel crypto_simd mei_me cryptd glue_helper ipmi_si sg mei
> > lpc_ich pcspkr joydev ioatdma i2c_i801 ipmi_devintf ipmi_msghandler
> > wmi ip_tables xfs libcrc32c sd_mod mgag200 drm_vram_helper ttm
> > drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm isci
> > libsas ahci scsi_transport_sas libahci crc32c_intel serio_raw igb
> > libata ptp pps_core dca i2c_algo_bit dm_mirror dm_region_hash dm_log
> > dm_mod [last unloaded: nitrox_drv]
> > [  270.896836] CPU: 1 PID: 7387 Comm: uperf Kdump: loaded Tainted: G
> >         OE     5.3.0-rc4 #1
> > [  270.897711] Hardware name: Supermicro SYS-1027R-N3RF/X9DRW, BIOS
> > 3.0c 03/24/2014
> > [  270.898597] RIP: 0010:__list_del_entry_valid+0x62/0x90
> > [  270.899478] Code: 00 00 00 c3 48 89 fe 48 89 c2 48 c7 c7 e0 f9 ee
> > 8d e8 b2 cf c8 ff 0f 0b 31 c0 c3 48 89 fe 48 c7 c7 18 fa ee 8d e8 9e
> > cf c8 ff <0f> 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 50 fa ee 8d e8 87
> > cf c8
> > [  270.901321] RSP: 0018:ffffb6ea86eb7c20 EFLAGS: 00010282
> > [  270.902240] RAX: 0000000000000000 RBX: ffff91cc3753c000 RCX: 0000000000000000
> > [  270.903157] RDX: ffff91bc3f867080 RSI: ffff91bc3f857738 RDI: ffff91bc3f857738
> > [  270.904074] RBP: ffff91bc36020940 R08: 0000000000000560 R09: 0000000000000000
> > [  270.904988] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > [  270.905902] R13: ffff91cc3753a800 R14: ffff91cc37cc6400 R15: ffff91cc3753a800
> > [  270.906809] FS:  00007f454a88d700(0000) GS:ffff91bc3f840000(0000)
> > knlGS:0000000000000000
> > [  270.907715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  270.908606] CR2: 00007f453c00292c CR3: 000000103554e003 CR4: 00000000001606e0
> > [  270.909490] Call Trace:
> > [  270.910373]  tls_tx_records+0x138/0x1c0 [tls]
> > [  270.911262]  tls_sw_sendpage+0x3e0/0x420 [tls]
> > [  270.912154]  inet_sendpage+0x52/0x90
> > [  270.913045]  ? direct_splice_actor+0x40/0x40
> > [  270.913941]  kernel_sendpage+0x1a/0x30
> > [  270.914831]  sock_sendpage+0x20/0x30
> > [  270.915714]  pipe_to_sendpage+0x62/0x90
> > [  270.916592]  __splice_from_pipe+0x80/0x180
> > [  270.917461]  ? direct_splice_actor+0x40/0x40
> > [  270.918334]  splice_from_pipe+0x5d/0x90
> > [  270.919208]  direct_splice_actor+0x35/0x40
> > [  270.920086]  splice_direct_to_actor+0x103/0x230
> > [  270.920966]  ? generic_pipe_buf_nosteal+0x10/0x10
> > [  270.921850]  do_splice_direct+0x9a/0xd0
> > [  270.922733]  do_sendfile+0x1c9/0x3d0
> > [  270.923612]  __x64_sys_sendfile64+0x5c/0xc0
> >
> > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> > ---
> >  include/net/tls.h | 1 +
> >  net/tls/tls_sw.c  | 7 +++++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/include/net/tls.h b/include/net/tls.h
> > index 41b2d41..f346a54 100644
> > --- a/include/net/tls.h
> > +++ b/include/net/tls.h
> > @@ -161,6 +161,7 @@ struct tls_sw_context_tx {
> >
> >  #define BIT_TX_SCHEDULED     0
> >  #define BIT_TX_CLOSING               1
> > +#define BIT_TX_IN_PROGRESS   2
> >       unsigned long tx_bitmask;
> >  };
> >
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 91d21b0..6e99c61 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -367,6 +367,10 @@ int tls_tx_records(struct sock *sk, int flags)
> >       struct sk_msg *msg_en;
> >       int tx_flags, rc = 0;
> >
> > +     /* If another writer is already in tls_tx_records, backoff and leave */
> > +     if (test_and_set_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask))
> > +             return 0;
> > +
> >       if (tls_is_partially_sent_record(tls_ctx)) {
> >               rec = list_first_entry(&ctx->tx_list,
> >                                      struct tls_rec, list);
> > @@ -415,6 +419,9 @@ int tls_tx_records(struct sock *sk, int flags)
> >       if (rc < 0 && rc != -EAGAIN)
> >               tls_err_abort(sk, EBADMSG);
> >
> > +     /* clear the bit so another writer can get into tls_tx_records */
> > +     clear_bit(BIT_TX_IN_PROGRESS, &ctx->tx_bitmask);
> > +
> >       return rc;
> >  }
> >
>
