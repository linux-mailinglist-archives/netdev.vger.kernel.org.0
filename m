Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC6BBF5A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503627AbfIXA2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 20:28:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46841 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503623AbfIXA2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 20:28:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so75582qtq.13
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 17:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IFV5JGbWyg2zPREceyybvOhU+xMZWne8JX/BmrpWMao=;
        b=Lt5fO+xHKdk6Rumcp3Ca59JjZb4Mh5/xiACIkBKhXN6n6P6VfIwKoGta0Xd/zXzy9r
         RDp7FX6sVT5pWMHfP+MQ7FOH4ffVX68O7eI7//1DfPZ7sf24dn4dYyZ5o+UDOKaD81pK
         UH9tU3qg+A96yw9cg43luxu/OnfgRnyKX4WMhiQCwQZ6XbzLi7BIq+0QkzidnIs73IbT
         c9SXkmjY08XmS4CrB4/RAFjE1AyRu5KmeUDglidC5fXwhsGxjvrOyE9A/0IwxXd0nNqj
         TuiDYYO0nvFvXIM/A6L4VbHClOyGdGLFuI7iEgqqXphBJmLrxVp2HZVyF9YaaoGftErt
         S8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IFV5JGbWyg2zPREceyybvOhU+xMZWne8JX/BmrpWMao=;
        b=Numt48yOQ+Si57pZsxXGhn/XyL+/kcRXEfwHxicKfjjfajXn4A+IQO4Ll3nRBRJbva
         foYcjnQOTVqYL4f8tvStOOsMe7Ql3fAFdUeHLsKk5TQKgI25Q+E4PAnLZGP/IPB8ICpS
         BgWZw3lLW8etNa0gi8JDwR25UH67SzdyFwFiEIbTkoU5IjY0pec8sI6Vn8k2B+dTKg7V
         YY2gz4ZvvIDGBu7iFfHb3hPo1k3h9w0jQ+CUngRPpCue5Hhm3W3I+hgjbHVwiRbYTkWQ
         u2A3hNObMoagoAy3vsE2a4fsMYNJ5ek2gO1WXpyXXnNXVPhvUT8dVTtfRYGIWbgV6nnB
         byvw==
X-Gm-Message-State: APjAAAV+ZhGRgWDV3LhIv3X7wHTceKR6yqCbRj10kIBsUpSFATRgosfL
        wpvkOZNRB+P2mfg/GHUAtJpsRA==
X-Google-Smtp-Source: APXvYqxjLopYoeVFs4OEBD/cLnj52KbJZQxxnrdS+UHdCvPFJ57Gcy07E6hbhWauDmiBMDK9XvN1qg==
X-Received: by 2002:a0c:e2c9:: with SMTP id t9mr287664qvl.22.1569284897616;
        Mon, 23 Sep 2019 17:28:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x59sm26602qte.20.2019.09.23.17.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 17:28:17 -0700 (PDT)
Date:   Mon, 23 Sep 2019 17:28:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20190923172811.1f620803@cakuba.netronome.com>
In-Reply-To: <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
        <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
        <20190918142549.69bfa285@cakuba.netronome.com>
        <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
        <20190918144528.57a5cb50@cakuba.netronome.com>
        <CAOrEdsk6P=HWfK-mKyLt7=tZh342gZrRKwOH9f6ntkNyya-4fA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 23:19:20 -0400, Pooja Trivedi wrote:
> On Wed, Sep 18, 2019 at 5:45 PM Jakub Kicinski wrote:
> > On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:  
> > > Hi Jakub,
> > >
> > > I have explained one potential way for the race to happen in my
> > > original message to the netdev mailing list here:
> > > https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> > >
> > > Here is the part out of there that's relevant to your question:
> > >
> > > -----------------------------------------
> > >
> > > One potential way for race condition to appear:
> > >
> > > When under tcp memory pressure, Thread 1 takes the following code path:
> > > do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> > > tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> > > do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event  
> >
> > Ugh, so do_tcp_sendpages() can also release the lock :/
> >
> > Since the problem occurs in tls_sw_do_sendpage() and
> > tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?  
> 
> That won't do because tls_tx_records also gets called when completion
> callbacks schedule delayed work. That was the code path that caused
> the crash for my test. Cavium's nitrox crypto offload driver calling
> tls_encrypt_done, which calls schedule_delayed_work. Delayed work that
> was scheduled would then be processed by tx_work_handler.
> Notice in my previous reply,
> "Thread 2 code path:
> tx_work_handler ---> tls_tx_records"
> 
> "Thread 2 code path:
> tx_work_handler ---> tls_tx_records"

Right, the work handler would obviously also have to obey the exclusion
mechanism of choice.

Having said that this really does feel like we are trying to lock code,
not data here :(
