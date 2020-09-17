Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5F26D3F5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgIQGv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgIQGv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:51:58 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD0C061756
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 23:51:57 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y9so1261031ilq.2
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 23:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmO3lehPU5xgp/AaU9lW0DTy2BiuALKSxjt4YpqCbPQ=;
        b=OXBVMolKXu9oHOH/RIVylOl8xeQHwn7gTVs/vMb1xmk0j8xZdei1Po6uQNaOcCi0rz
         k/Jz5O9iQZos06Ktg9342AdyYAQwGZNtt26Mwkfv0C35hYQyYctENMR8d/OqQCdpTbS4
         QBVmNA9+8VsrdPxfGbmfu219GQDfZJ9EL/j/jHq9WnPHJTfkYv+T4y1pLQUGrLNHA1yd
         Mu7KIvQVM+I6p+UhhZw2Ji0gC497GSvFD0it8TrSqlO5Fam7Zk3fnx1S3HpBdVjy6wU/
         saKkt6Ejo4b5N/r+CYf70DfONvV0JcvnKQ7ZIyaC2Sr5OoAh9KEn6JuJd1g+gpIB7kCk
         SIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmO3lehPU5xgp/AaU9lW0DTy2BiuALKSxjt4YpqCbPQ=;
        b=AYbSR+kbRaRptZkVUCTJeedpXXMJVP/kg+8keHanSORSzg75yexleCZDjRqV6bReuK
         W41FnsZb/TfHCBXkYNjX510LEISrkcPw4/m5OuddsTSm4qZhCEMZjG/VhcnLpMqK5FRD
         HC503Bm16t+wXJ/LekBN4T48QsG7Ut6vmsubm5m0Rvf0js6VfjnbztGdOzuLEaIqO50X
         uM5xmD2AUutIUFMfchqwi4OgmrzM4cSNwJuYLBsD6/6MDl3G4NtDz4hWs77zQ74eFKBJ
         29B0leq8VAyS9DCD2TpF0lfSBLTvWxkiQO7teYaMl3fxU/hiIj9iGRskpBVUjh/zpQFz
         yfkw==
X-Gm-Message-State: AOAM531fZeHNj13GfVTYlqepjEq58IqJNdbxYX4DiEZZxd7FgGEZ6te3
        44/PJkRabUIh7abXGw2Ysi852h6nT4S7uWLIJ/40SNiSEEc=
X-Google-Smtp-Source: ABdhPJxFYzwV1YLidOSKXI1r/DxKCDAaTVJyjocue5dOmnluWfcXOUoJWW2TLVCA5K/Yy25eZFSB7+QxpoVqTOXas+8=
X-Received: by 2002:a92:d48b:: with SMTP id p11mr19958635ilg.69.1600325516756;
 Wed, 16 Sep 2020 23:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200917020021.0860995C06B9@us180.sjc.aristanetworks.com> <CA+HUmGjX4_4_UXWNn=EehQ_3QtFPZq8RJU146r-nc0nA8apx7w@mail.gmail.com>
In-Reply-To: <CA+HUmGjX4_4_UXWNn=EehQ_3QtFPZq8RJU146r-nc0nA8apx7w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Sep 2020 08:51:45 +0200
Message-ID: <CANn89iJOO9cbOqCNpRK4OrZy-L6P8aJJcPMjs5=RHF=fsjEe2Q@mail.gmail.com>
Subject: Re: [PATCH] net: make netdev_wait_allrefs wake-able
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 8:33 AM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> >  static inline void dev_put(struct net_device *dev)
> >  {
> > +       struct task_struct *destroy_task = dev->destroy_task;
> > +
> >         this_cpu_dec(*dev->pcpu_refcnt);
> > +       if (destroy_task)
> > +               wake_up_process(destroy_task);
> >  }
>
> I just realized that this introduces a race, if dev_put drops the last
> reference, an already running netdev_wait_allrefs runs to completion
> and then dev_put tries to wake it up.
> Any suggestions on how to avoid this without resorting to
> locking?
>

Honestly I would not touch dev_put() at all.

Simply change the msleep(250) to something better, with maybe
exponential backoff.
