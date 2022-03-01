Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF14C809A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiCAB7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiCAB7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:59:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2F6245AE;
        Mon, 28 Feb 2022 17:58:51 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g21so6452488pfj.11;
        Mon, 28 Feb 2022 17:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQuhZUQchvRiqxYfZ/2ecxKW7Ujm6li2s4k5X8wdVJs=;
        b=Aw8mcqgCxaTZhLI6sConqAzLqNdcyQ90JXNy9afK9cEixRTnqevGJOFRwkMD58lOZc
         kqpIquZtf1gf2BQmhSGa3V5WxNAW2B/O1fNa11vuZbZcrFH4fMQbjC719nIWMbCmANy1
         Ml/BvzX13V9gH+2H/k3vs/KqaLJ5dPD/6X770yLypzdhDspj4Zw96YvJF4WWgNttOURn
         uHiY+5RffpXfRLzymJh9gx/waQD3KMx1Ymt04RXXEz0vSXlNqE+qK9mSX2fqcBWK8w47
         Sr4Rojo9mVWucgBOAPrDo+m1NVnKVzCfFECYv1j6xhb1PW0JVhEjpdfT7WWM13II+Xrv
         FIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQuhZUQchvRiqxYfZ/2ecxKW7Ujm6li2s4k5X8wdVJs=;
        b=l0v/VDXmwEskroGMLD8HaOaty+FddccGIiYRPHnzlGspIDDCFFV7l1Rewpc5S8aha/
         hx/xI834Z4xCpYPplEvsAcArnmoDbnw3JDoLhFriFYwyIawFegZobV2xXZ+XqZKisA9K
         /1jRZdYue38F2nqC5b+23Eb5yNEIEWVy1JYDIacXU7w69C947jTjz/RX+9UUZ5msED8B
         tmDIGZiJ8/Cb5B/umZvNvHAaJEYhFyD/knA+7KY54JU0hhlJq4OM51TJNvSi/a7WeOu6
         Doqkrsr6wkCyHclJpP9dQ6mMdc2zid1cGq9MfIpTPqGxyIS11nUPO2HSXF+aF1YHQLqw
         KR1Q==
X-Gm-Message-State: AOAM532atfS85tHkS0OrM/mcgd6F/R+7SE1XozN+H3LohCseLH6jpMNT
        JG2B2Ge7FnRh3+VhSOYGiszptpYcFxyz0q07Oys=
X-Google-Smtp-Source: ABdhPJzQluYvB7z0jOn3S4FBdVrhC3o3vhblIWhajvG0HgFd7jQM6frwUGJ3ivpa4rlu4XNR+y70aV2fwR+bWvnqd8I=
X-Received: by 2002:a63:451d:0:b0:378:dead:f66b with SMTP id
 s29-20020a63451d000000b00378deadf66bmr1605809pga.150.1646099930872; Mon, 28
 Feb 2022 17:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220228033805.1579435-1-baymaxhuang@gmail.com> <CACGkMEtFFe3mVkXYjYJZtGdU=tAB+T5TYCqySzSxR2N5e4UV1A@mail.gmail.com>
 <20220228091539.057c80ef@hermes.local>
In-Reply-To: <20220228091539.057c80ef@hermes.local>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Tue, 1 Mar 2022 09:58:39 +0800
Message-ID: <CAHJXk3Yth1Q0BTcza8ndpECL3fGjeTYyv3wCAasdog0o6rd2hA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tun: support NAPI for packets received from
 batched XDP buffs
To:     stephen@networkplumber.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 1:15 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 28 Feb 2022 15:46:56 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
> > On Mon, Feb 28, 2022 at 11:38 AM Harold Huang <baymaxhuang@gmail.com> wrote:
> > >
> > > In tun, NAPI is supported and we can also use NAPI in the path of
> > > batched XDP buffs to accelerate packet processing. What is more, after
> > > we use NAPI, GRO is also supported. The iperf shows that the throughput of
> > > single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> > > Gbps nearly reachs the line speed of the phy nic and there is still about
> > > 15% idle cpu core remaining on the vhost thread.
> > >
> > > Test topology:
> > > [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
> > >
> > > Iperf stream:
> > > iperf3 -c 10.0.0.2  -i 1 -t 10
> > >
> > > Before:
> > > ...
> > > [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> > > [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> > > [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> > > [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> > > [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > [ ID] Interval           Transfer     Bitrate         Retr
> > > [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> > > [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
> > >
> > > After:
> > > ...
> > > [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> > > [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> > > [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> > > [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> > > [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > [ ID] Interval           Transfer     Bitrate         Retr
> > > [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> > > [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> > >
> > > Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> > > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
> Would this help when using sendmmsg and recvmmsg on the TAP device?
> Asking because interested in speeding up another use of TAP device, and wondering
> if this would help.

As Jason said, sendmmsg()/recvmsg() could not be used on tuntap. But I
think another choice is to use writev/readv directly on the ttunap fd,
which will call tun_get_user to send msg and NAPI has also been
supported.
