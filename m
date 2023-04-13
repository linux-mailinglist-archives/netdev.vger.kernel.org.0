Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4165A6E13B9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDMRve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDMRvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:51:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4BA8A5F;
        Thu, 13 Apr 2023 10:51:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-5027d3f4cd7so6500771a12.0;
        Thu, 13 Apr 2023 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681408290; x=1684000290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZfMFCQr2fUDXfv2setDBqfP9SdL0uv4ke+ajqVj8jg=;
        b=o4MsV0Yqr1h7Cjf3dJf951SDXwwdqIzyXzByd2cLKP23J8XQeY6Lif63TNo8tIW7Kd
         ffPrqLgaCbYAWAs211wlTFRN5TTPQSYyGL1OHv7La1BGQggVaEq+7MQxHzoobfD131yc
         zqlEDRQ2HI3o90zMgP6DkCK/VMl7fDpkDsbbqgHaryCx5o7c7mBLCgZYk0VceJJZ1zpk
         5cigAcl9DznD97PiRHixvAVdIQy012UMahNdhHPB1eTOUM9PmrBnhueVu4EidgtH1LYg
         26oFmGuhbNOgnehP+gA0qrcCuvaThgM2mAXYsjMoUd3I8PMj1ZYz2T5Dvp9uTcBpabbD
         TIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681408290; x=1684000290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZfMFCQr2fUDXfv2setDBqfP9SdL0uv4ke+ajqVj8jg=;
        b=QceU3ARjJJ75dsEUuyfeywj539o4vNvoOhIDtfTT6gd9TNn1z2TA8mvusHOzIzXTe1
         /3cyzT6yfBaQDNGwDZOoxOLyDXRLsx7HuWF6cp/WPHgjWtCH9FAGAFbgsc5gE2MHvbG4
         sqDp3QsAGjyTCNPgsi3kcPUTLfODhhZ/xh0webDOGToA4S45BzlbVRDSSAC1FOJ64ryA
         2LYTO8tTn39oTcS8YRTx5/kmlK/B5/T6/zw9VaUdWzZxDV39Em/kffbFQBYqhiybXNyz
         2rYpeOvqKpffTX37q7Mx8xOZm0w7zUj/y1tlfm/hQraMKu1QNMd/wgwsPk5UTpcUrg4C
         uWQA==
X-Gm-Message-State: AAQBX9fFh5S2cqc0JBnRTincGHgcXr40vKPZkIux64cjND6d7Gsi+g83
        bx6DJMWuCWNvu8RGYL2hsng9hXLRtJpunNFO0oE=
X-Google-Smtp-Source: AKy350aP6rHdhOymvCAlesOGDxhv71kELmpT+bFZGSUqjAD++YMMtc33kt63xISiYjHgpQPX7Ky07uRdXDB5HhcdE40=
X-Received: by 2002:a50:a415:0:b0:504:898b:e482 with SMTP id
 u21-20020a50a415000000b00504898be482mr1709774edb.3.1681408289649; Thu, 13 Apr
 2023 10:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230407171654.107311-1-john.fastabend@gmail.com> <20230407171654.107311-4-john.fastabend@gmail.com>
In-Reply-To: <20230407171654.107311-4-john.fastabend@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Apr 2023 10:51:18 -0700
Message-ID: <CAADnVQ+43oW3F3_R2cz76ivfeJNDt6Nf66jOdXADjsp=jJZxgQ@mail.gmail.com>
Subject: Re: [PATCH bpf v6 03/12] bpf: sockmap, improved check for empty queue
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@isovalent.com>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, will@isovalent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 10:17=E2=80=AFAM John Fastabend <john.fastabend@gmai=
l.com> wrote:
>
> We noticed some rare sk_buffs were stepping past the queue when system wa=
s
> under memory pressure. The general theory is to skip enqueueing
> sk_buffs when its not necessary which is the normal case with a system
> that is properly provisioned for the task, no memory pressure and enough
> cpu assigned.
>
> But, if we can't allocate memory due to an ENOMEM error when enqueueing
> the sk_buff into the sockmap receive queue we push it onto a delayed
> workqueue to retry later. When a new sk_buff is received we then check
> if that queue is empty. However, there is a problem with simply checking
> the queue length. When a sk_buff is being processed from the ingress queu=
e
> but not yet on the sockmap msg receive queue its possible to also recv
> a sk_buff through normal path. It will check the ingress queue which is
> zero and then skip ahead of the pkt being processed.
>
> Previously we used sock lock from both contexts which made the problem
> harder to hit, but not impossible.
>
> To fix also check the 'state' variable where we would cache partially
> processed sk_buff. This catches the majority of cases. But, we also
> need to use the mutex lock around this check because we can't have both
> codes running and check sensibly. We could perhaps do this with atomic
> bit checks, but we are already here due to memory pressure so slowing
> things down a bit seems OK and simpler to just grab a lock.
>
> To reproduce issue we run NGINX compliance test with sockmap running and
> observe some flakes in our testing that we attributed to this issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 198bed303c51..f8731818b5c3 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -987,6 +987,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
>  static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff=
 *skb,
>                                   int verdict)
>  {
> +       struct sk_psock_work_state *state;
>         struct sock *sk_other;
>         int err =3D 0;
>         u32 len, off;
> @@ -1003,13 +1004,28 @@ static int sk_psock_verdict_apply(struct sk_psock=
 *psock, struct sk_buff *skb,
>
>                 skb_bpf_set_ingress(skb);
>
> +               /* We need to grab mutex here because in-flight skb is in=
 one of
> +                * the following states: either on ingress_skb, in psock-=
>state
> +                * or being processed by backlog and neither in state->sk=
b and
> +                * ingress_skb may be also empty. The troublesome case is=
 when
> +                * the skb has been dequeued from ingress_skb list or tak=
en from
> +                * state->skb because we can not easily test this case. M=
aybe we
> +                * could be clever with flags and resolve this but being =
clever
> +                * got us here in the first place and we note this is don=
e under
> +                * sock lock and backlog conditions mean we are already r=
unning
> +                * into ENOMEM or other performance hindering cases so le=
ts do
> +                * the obvious thing and grab the mutex.
> +                */
> +               mutex_lock(&psock->work_mutex);
> +               state =3D &psock->work_state;

This splat says that above is wrong:

[   98.732763] BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:580
[   98.733483] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid:
370, name: test_progs
[   98.734103] preempt_count: 102, expected: 0
[   98.734416] RCU nest depth: 4, expected: 0
[   98.734739] 6 locks held by test_progs/370:
[   98.735046]  #0: ffff888106475530 (sk_lock-AF_INET){+.+.}-{0:0},
at: inet_shutdown+0x43/0x150
[   98.735695]  #1: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
__ip_queue_xmit+0x5/0xa00
[   98.736325]  #2: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
process_backlog+0xc0/0x360
[   98.736971]  #3: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
ip_local_deliver_finish+0xbb/0x220
[   98.737668]  #4: ffff8881064748b0 (slock-AF_INET/1){+.-.}-{2:2},
at: tcp_v4_rcv+0x1b72/0x1d80
[   98.738297]  #5: ffffffff84250ba0 (rcu_read_lock){....}-{1:2}, at:
sk_psock_verdict_recv+0x5/0x3a0
[   98.738973] Preemption disabled at:
[   98.738976] [<ffffffff8238bb41>] ip_finish_output2+0x171/0xfa0
[   98.739687] CPU: 1 PID: 370 Comm: test_progs Tainted: G           O
      6.3.0-rc5-00193-g9149a3b041d2 #942
[   98.740379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   98.741164] Call Trace:
[   98.741338]  <IRQ>
[   98.741483]  dump_stack_lvl+0x60/0x70
[   98.741735]  __might_resched+0x21c/0x340
[   98.742005]  __mutex_lock+0xb4/0x12a0
[   98.743721]  ? mutex_lock_io_nested+0x1070/0x1070
[   98.744053]  ? lock_is_held_type+0xda/0x130
[   98.744337]  ? preempt_count_sub+0x14/0xc0
[   98.744624]  ? sk_psock_verdict_apply+0x1a3/0x2f0
[   98.744936]  sk_psock_verdict_apply+0x1a3/0x2f0
[   98.745242]  ? preempt_count_sub+0x14/0xc0
[   98.745530]  sk_psock_verdict_recv+0x1e7/0x3a0
[   98.745858]  ? preempt_count_sub+0x14/0xc0
[   98.746168]  tcp_read_skb+0x19c/0x2d0
[   98.746447]  ? sk_psock_strp_read+0x390/0x390
[   98.746774]  ? tcp_alloc_md5sig_pool+0x230/0x230
[   98.747116]  ? rcu_read_lock_held+0x91/0xa0
[   98.747427]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   98.747772]  ? __rcu_read_unlock+0x6b/0x2a0
[   98.748087]  sk_psock_verdict_data_ready+0x99/0x2d0
[   98.748446]  tcp_data_queue+0xd39/0x19b0
[   98.748749]  ? tcp_send_rcvq+0x280/0x280
[   98.749038]  ? tcp_urg+0x7f/0x4c0
[   98.749298]  ? tcp_ack_update_rtt.isra.55+0x910/0x910
[   98.749644]  ? lockdep_hardirqs_on+0x79/0x100
[   98.749940]  ? ktime_get+0x112/0x120
[   98.750225]  ? ktime_get+0x86/0x120
[   98.750498]  tcp_rcv_established+0x3fb/0xcc0
[   98.752087]  tcp_v4_do_rcv+0x34a/0x4c0
[   98.752400]  tcp_v4_rcv+0x1c9a/0x1d80
[   98.754137]  ip_protocol_deliver_rcu+0x4f/0x4d0
[   98.754562]  ip_local_deliver_finish+0x146/0x220
[   98.754928]  ip_local_deliver+0x100/0x2e0
[   98.756055]  ip_rcv+0xb6/0x2b0
[   98.757689]  __netif_receive_skb_one_core+0xd2/0x110
[   98.759121]  process_backlog+0x160/0x360
[   98.759446]  __napi_poll+0x57/0x300
[   98.759725]  net_rx_action+0x555/0x600
[   98.760029]  ? napi_threaded_poll+0x2b0/0x2b0
[   98.760444]  __do_softirq+0xeb/0x4e7
[   98.760728]  ? ip_finish_output2+0x391/0xfa0
[   98.761059]  do_softirq+0xa1/0xd0

I'm afraid I have to revert this set from bpf tree.
