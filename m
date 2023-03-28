Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF866CC21A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjC1OdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjC1OdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:33:19 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080DD198
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:33:19 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q6so5448471iot.2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680013998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GusYEHXMJbcUKnmY5cnn7tZjPE6Mz2n+Wk5NJNEtiNU=;
        b=Qg+Yt+OgVU/6zQ4xrb0tJogRbOJzCHgXBA7r6+g14HrsOD3OWOaq1gbZ1tevnkDEmz
         7PA23kHHTgGrNCiNfKBmKpzn/TWVRp4ZafGDG1EzdR9XX1p0wxsOaBW2IMzcEYy04a1t
         H7VUjG4g+Pzx+BHmJpwmI2URTiZioE+UIkFPPfalNx7y3h/28Ex41UVD1WLmk4+qE5Ld
         rb4/pSGBdHVTlvSTCtS1Y7wfg64PM/5o8ur7kD8mAEsEdIAvoZ2EmB+/XMUOYpkTa4Zn
         Ui29T9+hnJHJx5Sy2TonC4X8Gg2oQa7g98jU6pl1Q8OL4TpzqaYklUW4NWZt88G+L3TP
         /udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680013998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GusYEHXMJbcUKnmY5cnn7tZjPE6Mz2n+Wk5NJNEtiNU=;
        b=sIVJOqJZx5rRVr3cvemdPIf4ZpTi44zTJpUpr5UvxnkFjCXgaHk8FSL2sThqh4D/Bf
         /DAMiE5C2AReJjr9SqV5/9RPhdnmQx2nuvp3WowX+gCZVFyDmqxyQP3HNQLkqgMMmXy+
         S7mBiwUIxV5pjK4il/CbwKk1HV0Yzhwvv3PqF8b2es2ra6UljIverM2XGbQmlSeoUd2x
         a78fWJ4PIpyDH3+5VdSVo74crtW+SFOZIg2zaz0I6OS6h1udxksV7R23k/s7k1QpXnF5
         +5SvbXZn1kBw7MWF0SEyfhbxOi9p9nJpTdefoGHgXN1Lil3nty9oMImLrWTYr7TiH5Vr
         eGkw==
X-Gm-Message-State: AAQBX9cUqYBDl5R06Swndx3TJ4bGUgjQO3ryQEWiQD/5DTmpfa8SYMBt
        SAuBO8nlU5eL+ejV+fbP+PbLTkh38MNl5koYVFLk7Q==
X-Google-Smtp-Source: AKy350aCrTvtvQP50DE7WOlLI93sYMy2Keoiu5oQtckHB0ueX07C6yjds9Ne8clVM5UrQ1/z01hLC05ta2evfS32EvA=
X-Received: by 2002:a05:6602:394b:b0:75c:9538:fdcb with SMTP id
 bt11-20020a056602394b00b0075c9538fdcbmr1401594iob.2.1680013998206; Tue, 28
 Mar 2023 07:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230328142112.12493-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230328142112.12493-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 16:33:06 +0200
Message-ID: <CANn89iLXA198djT-+NGSgTqTYA=cJtcvFmcoFbY59VewrqT0BA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: rps: avoid raising a softirq on the current
 cpu when scheduling napi
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 4:21=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> When we are scheduling napi and then RPS decides to put the skb into
> a backlog queue of another cpu, we shouldn't raise the softirq for
> the current cpu. When to raise a softirq is based on whether we have
> more data left to process later. But apparently, as to the current
> cpu, there is no indication of more data enqueued, so we do not need
> this action. After enqueuing to another cpu, net_rx_action() or
> process_backlog() will call ipi and then another cpu will raise the
> softirq as expected.
>
> Also, raising more softirqs which set the corresponding bit field
> can make the IRQ mechanism think we probably need to start ksoftirqd
> on the current cpu. Actually it shouldn't happen.
>
> Here are some codes to clarify how it can trigger ksoftirqd:
> __do_softirq()
>   [1] net_rx_action() -> enqueue_to_backlog() -> raise an IRQ
>   [2] check if pending is set again -> wakeup_softirqd
>
> Comments on above:
> [1] when RPS chooses another cpu to enqueue skb
> [2] in __do_softirq() it will wait a little bit of time around 2 jiffies
>
> In this patch, raising an IRQ can be avoided when RPS enqueues the skb
> into another backlog queue not the current one.
>
> I captured some data when starting one iperf3 process and found out
> we can reduces around ~1500 times/sec at least calling
> __raise_softirq_irqoff().
>
> Fixes: 0a9627f2649a ("rps: Receive Packet Steering")

No Fixes: tag, when you are trying to optimize things, and so far fail at t=
his.

> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2:
> 1) change the title and add more details.
> 2) add one parameter to recognise whether it is napi or non-napi case
> suggested by Eric.
> Link: https://lore.kernel.org/lkml/20230325152417.5403-1-kerneljasonxing@=
gmail.com/
> ---

Wrong again.

I think I will send a series, instead of you trying so hard to break the st=
ack.

You have not considered busy polling, and that netif_receive_skb() contract
does not enforce it to be called from net_rx_action().
