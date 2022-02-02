Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6204A769A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiBBROg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiBBROf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:14:35 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E933C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:14:35 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k31so680869ybj.4
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 09:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PHyVUVYWEHQaEKpOEUsKaJbOWLxLTsmgbpmZOLISTU=;
        b=FBHP57MxCHCtTuFnnvPb5r6y9sh9yrN/3VV7ZtjG4902ARN50XAJ5J0GEMtLNvg85c
         2y6fwZdD76CpK5LXwbPzH11eW7IqxP1bL2N0qR+TX5+jb83FcmM9VTVPsTSRCuOctvVf
         RULshAWkIVf6U92OWOgdz33D5ZhYK9LdZ25a8H/deZ5qPMhe32JQMcQyw8OgI7uLNRf4
         VE2K4k+apfBMnc2ASpBpfYl2EcQuvvDxW8kNCgv481FCsCDBNd0oKZAMBj7mX6tpDaUm
         l5C7P5iKqJvExfQmU3179+4WsQwSQ7zx49wZatgIZqiJwXKnhRMcghwmalVan/swTLSY
         X+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PHyVUVYWEHQaEKpOEUsKaJbOWLxLTsmgbpmZOLISTU=;
        b=iHzGvkiLYFgDKIe7SwlbSAHdLFu/3lpcDnbNLHhSZ+0oqcQATxSHk2X0w9L5sK1mKF
         CSPpsLBiizMbk3PcoGwxZkSF42D5h6meWNJMQBvdI+yykAcb65em/0tDZXf8BUWzr99f
         BHRZ0owapa5gfB0mI5lSJLnZexFGCDC6bmS8nN7U13M7RE6jBdfEkW+eWE2S/HbH30oc
         F6/+LQEHo1ihoBuce5QQj7117DECTHcdT8w5hDGGk14ez3LnU7jaFSNmhiywG/SY5VHM
         UGeS0o1bxx28nUMAEgsEbxvvQ+kZUJ8gF5YRC1ecKeuMAg7Yg8u7Mae6UCFxQ866kost
         itxw==
X-Gm-Message-State: AOAM533e+WW9lypo+nSL00gkzOVpw/VifmtMYQakPuO/k5+6TqRRL734
        TiOYM5U/dsnKhRSLXNvKIUj1tGjH/axEOCq/9wbSbw==
X-Google-Smtp-Source: ABdhPJzZtM1EDVsi+zSTsCFC2siJzI18W5/giGGoB/BVS0d/5XAW/VrGenGm6xrceO+5Ga5pTv33nL41FZWlT0TIzZ4=
X-Received: by 2002:a81:8411:: with SMTP id u17mr1627887ywf.414.1643822073954;
 Wed, 02 Feb 2022 09:14:33 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de> <20220202122848.647635-3-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-3-bigeasy@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 09:14:22 -0800
Message-ID: <CANn89iJoLSRP0zckRN0HtY=ii7VDkcoCP0SzMdzL99Tiw=EJDw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: dev: Remove get_cpu() in netif_rx_internal().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 4:28 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The get_cpu() usage was added in commit
>     b0e28f1effd1d ("net: netif_rx() must disable preemption")
>
> because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemtion
> causing a warning in smp_processor_id(). The function netif_rx() should
> only be invoked from an interrupt context which implies disabled
> preemption. The commit
>    e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")
>
> was addressing this and replaced netif_rx() with in netif_rx_ni() in
> ip_dev_loopback_xmit().
>
> Based on the discussion on the list, the former patch (b0e28f1effd1d)
> should not have been applied only the latter (e30b38c298b55).
>
> Remove get_cpu() since the function is supossed to be invoked from
> context with stable per-CPU pointers (either by disabling preemption or
> software interrupts).
>
> Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
