Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1882BC327
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 03:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKVCXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 21:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgKVCXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 21:23:46 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42CC0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 18:23:45 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id e81so10969871ybc.1
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 18:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=drvOrm5HOCzzdlsJr6uoDdnMss9pCbJ2gn+MO1r79/8=;
        b=nx5jyp0V8NXeKP7AgD/zmBhob+Pl5Z398z/r55z8WY/mCSAlBB7iMccwLFqWuN34Of
         9O6OBl4QZOpRkRz+ChilvA+Fv3WlDEpb4eSOeqdWY6ZdpKIW3zLLoouLV57HalF6sVlw
         6pB0A1aIGaU2lGib4gCTb4CB96Hno2gNJZkJilMOlp4jy5CP0thf4zQWYT/O2dLc4+pg
         JHNhXFSBaZ1f3b/40hF1n2MRFL3/fcsLNhUuR1qowjUC1l6+fAXfVglFLd0LoabqWaPS
         JBNu3N+wdXGS0EznLAUUTRI3850siDCidKsaZqw+5s4Y6InULucSrqzPOSkfofWnsevb
         cLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=drvOrm5HOCzzdlsJr6uoDdnMss9pCbJ2gn+MO1r79/8=;
        b=EKTOQl1IvvrUY0ya1WrKVpZ330TxJXhO2qZ9vrEAeqGCOOvoMQUBMMJbzgz1Ftm5yX
         T7q3A0cbfCb7jX27HFe2YaCy7DdGuTXSH2YPRgP7JmCaiUEQNcKBDiUpmwFdyG3OVt7S
         u7Lw7lfTH7VD9an/VX/YNVzZ0+IMVlNSTspDGOQIrl8X2XHeXmcPEaourO6kXykSoc6m
         c4smNqkUVDIhj6fFwxlzS2SJvVcBTxZ4WFKF1NfP/CLFIApWYdUe/TBWwiO8VFB0a912
         32J/MAuHa1K8fPL8GNrRw6W0xjlpKvpo3PivI234w2G09rUKV5YOTLHJsSapdt1Ou/Nj
         Nz1Q==
X-Gm-Message-State: AOAM533NvXXOF0og85Il0WrwVU7d6KzJU01EQPmhrmllPZ/iIVspWyBg
        aXzRDv1BdJxz3ce3sHbzqjmyqrscqHWq+wu7Borc6w==
X-Google-Smtp-Source: ABdhPJxrMkeyIh4OUi49PwOpDJC1KDBIXPiL6xNFbefCMHQF61kcfYlmLPz6txSOqplckUVJo9pz7T7+0oBCyQXSxcs=
X-Received: by 2002:a25:6851:: with SMTP id d78mr43797908ybc.408.1606011824856;
 Sat, 21 Nov 2020 18:23:44 -0800 (PST)
MIME-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com> <20201118191009.3406652-2-weiwan@google.com>
 <20201121163136.024d636c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201121163136.024d636c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Wei Wang <weiwan@google.com>
Date:   Sat, 21 Nov 2020 18:23:33 -0800
Message-ID: <CAEA6p_ATLr-=xQ8cZLJE3cbWn=cFx11kpWm0cV2J2hiaOVFPzg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/5] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 4:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 11:10:05 -0800 Wei Wang wrote:
> > +int napi_set_threaded(struct napi_struct *n, bool threaded)
> > +{
> > +     ASSERT_RTNL();
> > +
> > +     if (n->dev->flags & IFF_UP)
> > +             return -EBUSY;
> > +
> > +     if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> > +             return 0;
> > +     if (threaded)
> > +             set_bit(NAPI_STATE_THREADED, &n->state);
> > +     else
> > +             clear_bit(NAPI_STATE_THREADED, &n->state);
>
> Do we really need the per-NAPI control here? Does anyone have use cases
> where that makes sense? The user would be guessing which NAPI means
> which queue and which bit, currently.

Thanks for reviewing this.
I think one use case might be that if the driver uses separate napi
for tx and rx, one might want to only enable threaded mode for rx, and
leave tx completion in interrupt mode.


>
> > +     /* if the device is initializing, nothing todo */
> > +     if (test_bit(__LINK_STATE_START, &n->dev->state))
> > +             return 0;
> > +
> > +     napi_thread_stop(n);
> > +     napi_thread_start(n);
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(napi_set_threaded);
>
> Why was this exported? Do we still need that?
>

Yea. I guess it is not needed.

> Please rejig the patches into a reviewable form. You can use the
> Co-developed-by tag to give people credit on individual patches.

Will do. Thanks!
