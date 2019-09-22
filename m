Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71A4BA060
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfIVDT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:19:29 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35468 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfIVDT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:19:28 -0400
Received: by mail-vs1-f68.google.com with SMTP id s7so7294492vsl.2
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Er8ZGGI/TjADYPQvrecDVCrxvCWmCoA2BbCCeIE945U=;
        b=Nweq49QVn4WUg+i8S2HVnNH2S2x9Yn/q5k9xnw3/HuywfMnl2NDdz8zaA0oOdT4hmH
         o0jqvQVvrb8en+CZRcTco1ZCELQlwn5wSOtMDHo259I37ExuSDSmQWTckqS80xeBXYVP
         tjg81VGvc9hJ8RwjPBeOi2RpFAnWwltJGejGA23sJfv6LDz8rlOQGrKn9jufj9N3SkLI
         E5TlzHYQ85Jdn3vUw0BeLb0Glccbi2LaukkCpLe4VhEwM3wX65dGCPqiHJ9Q/LRXJ2qG
         nd1WRv2AZ7k8S6jUIzu3s15YVINeeDEotsXnujOXYjcw99Zvh3MXWdTLG47GVLhe1M0L
         KZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Er8ZGGI/TjADYPQvrecDVCrxvCWmCoA2BbCCeIE945U=;
        b=NRt5s9DefbD43+nTyws1fKXSYq2KT1kmhb1V8Z9sXJOMAuijhERqdkAO/TgbjpQLgf
         cd20/KLN0hgYxMR5jrkwIMJGlOmv4pybfAVBCjRAmgOwT1g3gnFN+fHPExD9MM65590G
         YFesnLMNTUYhGYQh22oDhpoOv4xlaOg1RTKgrumONDU+J3quBtEu1RMc+7ETZxxmlcRs
         vzEfg9CywaYkxZWh2H4l5VpJFYkcaOfX8lTQ+qy5ASGKDXKT7KrXJ8Ycb4W/jheK/jDp
         VJ5TA2LSwpeUThi/96rg6TiwnNIukNk2GDFvfpMnFmmfn1+LZNvtocPnJmTZpoLG3JTM
         obMg==
X-Gm-Message-State: APjAAAVe2uF7suQUQtfP5+ilj7aXHNwNGEB0buG2MQYZvXTxclhNOfoV
        g8TN8KQHSb2gNV11p5A+58dP1ulXkvO3R72ma74=
X-Google-Smtp-Source: APXvYqzgzOVvu4Z7wjdoDgwybgPi/LSOJvQve2FqUaQGfmQcXXN0w9MUlVmpckvj09FlposPBjdQenhf01luzoUCnkg=
X-Received: by 2002:a67:7247:: with SMTP id n68mr6931912vsc.219.1569122367455;
 Sat, 21 Sep 2019 20:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
 <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
 <20190918142549.69bfa285@cakuba.netronome.com> <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
 <20190918144528.57a5cb50@cakuba.netronome.com>
In-Reply-To: <20190918144528.57a5cb50@cakuba.netronome.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Sat, 21 Sep 2019 23:19:20 -0400
Message-ID: <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
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

On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:
> > Hi Jakub,
> >
> > I have explained one potential way for the race to happen in my
> > original message to the netdev mailing list here:
> > https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> >
> > Here is the part out of there that's relevant to your question:
> >
> > -----------------------------------------
> >
> > One potential way for race condition to appear:
> >
> > When under tcp memory pressure, Thread 1 takes the following code path:
> > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event
>
> Ugh, so do_tcp_sendpages() can also release the lock :/
>
> Since the problem occurs in tls_sw_do_sendpage() and
> tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?

That won't do because tls_tx_records also gets called when completion
callbacks schedule delayed work. That was the code path that caused
the crash for my test. Cavium's nitrox crypto offload driver calling
tls_encrypt_done, which calls schedule_delayed_work. Delayed work that
was scheduled would then be processed by tx_work_handler.
Notice in my previous reply,
"Thread 2 code path:
tx_work_handler ---> tls_tx_records"


"Thread 2 code path:
tx_work_handler ---> tls_tx_records"
