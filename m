Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C11CB97F8
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436757AbfITTqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:46:10 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44065 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfITTqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 15:46:09 -0400
Received: by mail-vs1-f67.google.com with SMTP id w195so5452916vsw.11;
        Fri, 20 Sep 2019 12:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Io9RJ3JL2fzUchkhXxqR2KLLvNnWVOLhMcfl4bJ3PtU=;
        b=A+mCBrL1vpFmLrtLGyrnmeQtJXeAMN5reVnCv0L8Y1ZXSubri84vFcUGnWLI6VqcXA
         avdCr1Fmkqfq1M5ZK1soM1hFckd/2wh6LG1LGX+XNXaJSKdYH6nHglkP5hAIGoyU4znP
         d9xspJfUg05Zp3j67scz7LGZ9wwRZaReJVge0oy4NCuhtqSh1T9Bz6pSRapE+/460VMj
         1EQRhF+CZKV8ycM5EVFCCtqWM1Tz2kE0VDIcFGvrCXzjbtztSc4Ys7MDW4xFegEx3EW0
         90gyeV5qkIhksYOuiGyOSKvZX0KzZ/UtKw5rznkzyCG0oJK1r6UOI4xudW247GafyG5h
         LnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Io9RJ3JL2fzUchkhXxqR2KLLvNnWVOLhMcfl4bJ3PtU=;
        b=P3cO0Jp+BeEq78VPclB+GV+SKR03LzbQm78ISHAhTnYGI5iouApjHH9boJIw69vaeI
         ymvhU71uc3t2R2tg7fT4ePc9YCkm3IaNgMdzfeRrSjGcoHRtN897n9cNidij+P963IDs
         VeGa3O7xCHU0RN1dzzcwQHFtl660UjydIgDIJIoBVumgQqQQmbX9e9jyMhObbIXbQ6xs
         Wu9OmYMz+9QMw4qlGfn+iAnw2dv55NIHMF7pWcZ/FoxkhMOmb53S8KgrLi3Ad6S8XMP+
         Ta9tCldEe/+w/K3nsdkEm30w+NJ2/cwJfBhGMG/6InuCWboFqKfAn4lF9cbLbEAaQ48b
         uwVg==
X-Gm-Message-State: APjAAAUvsBBpBktqwVpgjLFSitRaS8maZK25iVhU31VwuM6cCEFuDxMd
        0f7MvXo5usbvh5sYn+s+HGILQpvePQxM5yZCFsM=
X-Google-Smtp-Source: APXvYqw7oCfZ9PAVUf+G2Ozrp2x9H1visonA1g+8HuC6672fCZ+A38Jrk5MfqKuk2C81VU0aAUVsI6zmYYGEm1IQL50=
X-Received: by 2002:a67:c181:: with SMTP id h1mr1367388vsj.195.1569008768252;
 Fri, 20 Sep 2019 12:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
In-Reply-To: <20190920185843.4096-1-matthew.cover@stackpath.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Fri, 20 Sep 2019 12:45:56 -0700
Message-ID: <CAGyo_hoSPGRs8xvs9=D8c+1D_qKWhb2-9i5++mOC20xiYmZ71w@mail.gmail.com>
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>, mst@redhat.com,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 11:59 AM Matthew Cover <werekraken@gmail.com> wrote:
>
> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
> to fallback to tun_automq_select_queue() for tx queue selection.
>
> Compilation of this exact patch was tested.
>
> For functional testing 3 additional printk()s were added.
>
> Functional testing results (on 2 txq tap device):
>
>   [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>   [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
>   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>   [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
>   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>   [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
>   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
>   [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
>   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
>   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>
> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> ---
>  drivers/net/tun.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index aab0be4..173d159 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>         return txq;
>  }
>
> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>  {
>         struct tun_prog *prog;
>         u32 numqueues;
> -       u16 ret = 0;
> +       int ret = -1;
>
>         numqueues = READ_ONCE(tun->numqueues);
>         if (!numqueues)
>                 return 0;
>
> +       rcu_read_lock();
>         prog = rcu_dereference(tun->steering_prog);
>         if (prog)
>                 ret = bpf_prog_run_clear_cb(prog->prog, skb);
> +       rcu_read_unlock();
>
> -       return ret % numqueues;
> +       if (ret >= 0)
> +               ret %= numqueues;
> +
> +       return ret;
>  }
>
>  static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
>                             struct net_device *sb_dev)
>  {
>         struct tun_struct *tun = netdev_priv(dev);
> -       u16 ret;
> +       int ret;
>
> -       rcu_read_lock();
> -       if (rcu_dereference(tun->steering_prog))
> -               ret = tun_ebpf_select_queue(tun, skb);
> -       else
> +       ret = tun_ebpf_select_queue(tun, skb);
> +       if (ret < 0)
>                 ret = tun_automq_select_queue(tun, skb);
> -       rcu_read_unlock();
>
>         return ret;
>  }
> --
> 1.8.3.1
>

Sorry for sending this while net-next is closed... I
should have been more careful.

Please let me know if I should resubmit once net-next
is open again.
