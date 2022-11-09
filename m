Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF70E622167
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKIBpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIBpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:45:19 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552E63151
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:45:18 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y186so14773811yby.10
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 17:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zl7djpckIlUZhDC/ziSV0wxNfd2RCmhyQYA1QA+llpI=;
        b=G0VlGXOArsBaAxYUBMrzPHsuky40/YF44+MhW1M5Flx+dKOShyTTtJ7lx6G5E5gWfh
         YJFqW6yjAmsTlBnLXvUxT52s+Zt4iBYbMayGAxGNokk8Aj2JfAC8JPDg7K0gcSxqJtsx
         uagCjz2wrL7KZ4odpbZ/xBh7ob0XacFyPbhWzjD+JIl0YbgPMcm6esa4bMemU0Duj6Kx
         EwAoK2zG0U7+2o4TMBW3TPvnzG9DoMLoxt3rF9EhI0eNnV0T7OTN55htbTUceHUhn/GL
         LsEwgp9RKgITeLjTV3HLXfZWBr07aGzM3GVWPgLFb+9im+mhsazi+x5yTJCwnBlqKFRG
         PLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zl7djpckIlUZhDC/ziSV0wxNfd2RCmhyQYA1QA+llpI=;
        b=rUVpWHrkPukcFT20JXkDxIN1Dax0kdlA3+GoL8qdqZxtAZY8i/iKZTmHuOPmSLZDmZ
         5NC6DJLq6TdBRRSD+TgVmUvc1hhe276GTBsc4SVGAzX0QKyJ/8E/7wZlgSyRN43kMkJR
         JlU4WpNlil0elDHiEd473cfLVfkzn2dCdjkXLpHAARcEZ0fdlGOKsaFdZy8AipaKwNAw
         pX6Vq3XIoIxSJB+Ot9sbmZlpsnMIBz+p4/LJi8U33NEaDcvOgpfc6SvH47OR88m3sXI+
         3GRN1gRWjP7qD6Pxg7Wq0Zoh+ISNWU86FLfBxyPjqThSmaKLugVh9UpVGBakncr+WAIp
         J/fg==
X-Gm-Message-State: ACrzQf0uWnNs0WEafSx9GzoZ5DvJ+0p0tfted9EmTVzJdCt0wlTLoEf2
        9X/fnKtGdNtcn/HTn7qCGNy63qcl88TlSJ3bU6jX6g==
X-Google-Smtp-Source: AMsMyM6td8uer229uim33dULMcRblRFLhs5C8+dDqMa/gpmXntaedVg9x9xCjMPpBKtmdzB7+drlQArYvoa5Z5bZ/CQ=
X-Received: by 2002:a25:d914:0:b0:6cb:13e2:a8cb with SMTP id
 q20-20020a25d914000000b006cb13e2a8cbmr57072510ybg.231.1667958317504; Tue, 08
 Nov 2022 17:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20221107180011.188437-1-edumazet@google.com> <20221108174057.2336512c@kernel.org>
In-Reply-To: <20221108174057.2336512c@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Nov 2022 17:45:06 -0800
Message-ID: <CANn89i+eZ0OZCxP=s4BsY5qoPcwg-zZ1vYqGQvPaOs8OCG8Nzw@mail.gmail.com>
Subject: Re: [PATCH net] net: tun: call napi_schedule_prep() to ensure we own
 a napi
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Wang Yufen <wangyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 5:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  7 Nov 2022 18:00:11 +0000 Eric Dumazet wrote:
> >               if (unlikely(headlen > skb_headlen(skb))) {
> > +                     WARN_ON_ONCE(1);
> > +                     err = -ENOMEM;
> >                       dev_core_stats_rx_dropped_inc(tun->dev);
> > +napi_busy:
> >                       napi_free_frags(&tfile->napi);
> >                       rcu_read_unlock();
> >                       mutex_unlock(&tfile->napi_mutex);
> > -                     WARN_ON(1);
> > -                     return -ENOMEM;
> > +                     return err;
> >               }
> >
> > -             local_bh_disable();
> > -             napi_gro_frags(&tfile->napi);
> > -             napi_complete(&tfile->napi);
> > -             local_bh_enable();
> > +             if (likely(napi_schedule_prep(&tfile->napi))) {
> > +                     local_bh_disable();
> > +                     napi_gro_frags(&tfile->napi);
> > +                     napi_complete(&tfile->napi);
> > +                     local_bh_enable();
> > +             } else {
> > +                     err = -EBUSY;
> > +                     goto napi_busy;
>
> This can only hit if someone else is trying to detach / napi_disable()
> at the same time?

I think this can happen if /sys/class/net/${dev}/gro_flush_timeout is used.

napi_watchdog() might grab NAPI_STATE_SCHED

Since this is mostly used by validation tools, I think it is better to
let the tool retry,
rather than trying to spin to acquire NAPI_STATE_SCHED.
