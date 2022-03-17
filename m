Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2134DC15C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiCQIfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiCQIfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 258CCD1CD9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647506030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iu919w2LqaFt1Uy2fudLj6gbHpZoM5jHRrx787A1Nho=;
        b=iE7uAQdCliPKRTx8TG4UrsXSQtCK5511kIhU+SMgT3vbF9CdOMyC+3W9XNYSOPRnMgBuwY
        fNRxgbNlKQB4kE2er/uPsHq2unyoBhpMOmpf/IPZ4yQgFtUBEfcWAnzQetlzNARd8TYrvy
        Cx9jZg5yhyUO24ls+lUzOVzBzolV4Sk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-g4-8NqNMNvCpzLqSrHvgJg-1; Thu, 17 Mar 2022 04:33:48 -0400
X-MC-Unique: g4-8NqNMNvCpzLqSrHvgJg-1
Received: by mail-wm1-f70.google.com with SMTP id k26-20020a05600c0b5a00b0038c6c41159bso1885233wmr.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Iu919w2LqaFt1Uy2fudLj6gbHpZoM5jHRrx787A1Nho=;
        b=jQW1u6JQkMCTXfEv/e1RYr99LgqrFsEHvvyDy83eV08qhIc4BwEn8oJhj8dVs8bpfR
         DTvC3v+eTrGWHgSoN5rjs5wvmQ0X26pRzsBxcR8yNbxYXAyRwjzdfRFIhx8MDEaigV+K
         79rT7lzNg3Q2fMkX14y2EO51klnIdO6i0zidnfNXc258eXcRmW52rBYpWN6IofnXv2Xw
         LpH/19uBWAOgZbwck7aTV8VOzEFOvBdy7/BNKX40iwWahBOQK0cOsGQ53hYVUAG64+cM
         GaNQqoe5LuqLOGjKk1WWhsC3YSmP8R3L0jLkn6l9LbpMP8D8YnkjrTswgiCcwXNveGGa
         KNQA==
X-Gm-Message-State: AOAM532Ja1oxGOgTSRkcoCqUc6jLjXlDFV/dIC110WKMOsxoe2ompU8n
        iA9WWfzagICZZfGnijdQJd5GEw5JPQG/Atrnr+kErOePbYaxWtSyQjONs2VCaNYhoQBNujt1aGq
        ZksDPUsRhdDqFnJ0O
X-Received: by 2002:a05:600c:3b89:b0:389:cf43:eafc with SMTP id n9-20020a05600c3b8900b00389cf43eafcmr2810567wms.205.1647506027360;
        Thu, 17 Mar 2022 01:33:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNxGZ2T7piT9Fpahr104wp7JWegFg/Tc2taqUCIUCLva8ktV6qOSpfQRH5gGoVgKIh6Rad3g==
X-Received: by 2002:a05:600c:3b89:b0:389:cf43:eafc with SMTP id n9-20020a05600c3b8900b00389cf43eafcmr2810544wms.205.1647506027142;
        Thu, 17 Mar 2022 01:33:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id i10-20020a5d584a000000b00203e8019f2dsm1337201wrf.61.2022.03.17.01.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:33:46 -0700 (PDT)
Message-ID: <87764612d480432134b5253f17e3d6fff816e147.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net: icmp: introduce
 __ping_queue_rcv_skb() to report drop reasons
From:   Paolo Abeni <pabeni@redhat.com>
To:     Menglong Dong <menglong8.dong@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Date:   Thu, 17 Mar 2022 09:33:45 +0100
In-Reply-To: <CADxym3Z_o6P+jSu5sUZDQf4bGUj4f4tGEYi7a9z+wRjYu0o1xw@mail.gmail.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
         <20220316063148.700769-3-imagedong@tencent.com>
         <f6c1dbe5-ba6f-6e68-aa3b-4fe018d5092f@kernel.org>
         <CADxym3Z_o6P+jSu5sUZDQf4bGUj4f4tGEYi7a9z+wRjYu0o1xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-17 at 13:25 +0800, Menglong Dong wrote:
> On Thu, Mar 17, 2022 at 11:56 AM David Ahern <dsahern@kernel.org> wrote:
> > 
> > On 3/16/22 12:31 AM, menglong8.dong@gmail.com wrote:
> > > diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> > > index 3ee947557b88..9a1ea6c263f8 100644
> > > --- a/net/ipv4/ping.c
> > > +++ b/net/ipv4/ping.c
> > > @@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> > >  }
> > >  EXPORT_SYMBOL_GPL(ping_recvmsg);
> > > 
> > > -int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > +static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
> > > +                                              struct sk_buff *skb)
> > >  {
> > > +     enum skb_drop_reason reason;
> > > +
> > >       pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
> > >                inet_sk(sk), inet_sk(sk)->inet_num, skb);
> > > -     if (sock_queue_rcv_skb(sk, skb) < 0) {
> > > -             kfree_skb(skb);
> > > +     if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> > > +             kfree_skb_reason(skb, reason);
> > >               pr_debug("ping_queue_rcv_skb -> failed\n");
> > > -             return -1;
> > > +             return reason;
> > >       }
> > > -     return 0;
> > > +     return SKB_NOT_DROPPED_YET;
> > > +}
> > > +
> > > +int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > +{
> > > +     return __ping_queue_rcv_skb(sk, skb) ?: -1;
> > >  }
> > >  EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
> > > 
> > 
> > This is a generic proto callback and you are now changing its return
> > code in a way that seems to conflict with existing semantics
> 
> The return value of ping_queue_rcv_skb() seems not changed.
> In the previous code, -1 is returned on failure and 0 for success.
> This logic isn't changed, giving __ping_queue_rcv_skb() != 0 means
> failure and -1 is returned. Isn't it?

With this patch, on failure __ping_queue_rcv_skb() returns 'reason' (>
0) and ping_queue_rcv_skb() returns the same value.

On success __ping_queue_rcv_skb() returns SKB_NOT_DROPPED_YET (==0) and
ping_queue_rcv_skb() return -1.

You need to preserve the old ping_queue_rcv_skb() return values, under
the same circumstances.

Thanks,

Paolo

