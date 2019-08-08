Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B088D8681F
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404324AbfHHRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:32:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45619 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404276AbfHHRcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:32:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id f7so122826qtq.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ShTl8NzjuFW4H+evSiyW4NbMbiHqGaETrF4McIh94ME=;
        b=Dp3Gif+0bf4aZFxAZ6NkwiGMqG9RXmCBpvAZAjNenCWfaPA7I0a0lB/9pvtm+EmdWC
         I6hv4CIqgbhJe4mWu+nn+Dj79b1lGyPYu6Sxmn4I4Z41yJXpsNsZgZBqVz6/mSzVNoYb
         G1sRnHhuR4ookjU2+uaNnjr/7Bb216UszEJwCLoJbBTAV3VsD0xfaLnmFLoIAdWNQaSY
         sHWD/vB0/Mm99iuIaYsEi+buncrkmqqEkMSZ46GL4du+SpIb/86df3/sJ6LozBdhpMkp
         gqVPMc2tQz/YsDTBH+cWGliCZdt5bfWQLVQi9vU+THPjDw/1fqGdWCK0sYUyss+zyTXg
         47eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ShTl8NzjuFW4H+evSiyW4NbMbiHqGaETrF4McIh94ME=;
        b=sXWmWGkMY8ANVR5pGvEh9jV5V373n7kMTnLMFtocaxmL+7tQ5ShpnxrFRf0GEptuUG
         7OZcH/yHYHT9tQ1SNL/03tUXx56r3JhflN0UJt+YxgjXtP9NyYVgdLsTDYWue0JK/Rdw
         xi4V/omgKihEuWPw93pOC1m9Jvza2C9Ywk2tFrddByTa0/mUEhZL3tfgSdWsFFkqIS4u
         u1XaKk1Sxl9vpDRKcZK4jZUTY8ltnlGIOxRtz2L7ezIb/l6Ua26PyaU4E22jy7rPIA/A
         0eG8wqHfgwKOyl44I/IzQk4OBTeczMAjQgAdQFFZOe+INDG7FeAy1N5ZgSUMbS7VR6sg
         FHog==
X-Gm-Message-State: APjAAAVfzY00V+ikAbF+GSAwEQWnJFH7jqpH7bWQ49ZH+FzDyRazdFFF
        UWrw8uzltJFwNJOfG4cR8YqQIw==
X-Google-Smtp-Source: APXvYqxzCzO+Gnqjjfd1Jg5u3oDJ6EQ/fsrFwUYsO2BEeRZkqojlBvw3Pitu9Q5Sfu+6W0g/Fcvzrw==
X-Received: by 2002:a0c:ba0b:: with SMTP id w11mr14327548qvf.71.1565285541347;
        Thu, 08 Aug 2019 10:32:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 6sm649263qtu.15.2019.08.08.10.32.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:32:21 -0700 (PDT)
Date:   Thu, 8 Aug 2019 10:31:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Message-ID: <20190808103148.164bec9f@cakuba.netronome.com>
In-Reply-To: <CA+FuTSc7H6X+rRnxZ5NcFiNy+pw1YCONiUr+K6g800DXzT_0EA@mail.gmail.com>
References: <20190808000359.20785-1-jakub.kicinski@netronome.com>
        <CA+FuTSc7H6X+rRnxZ5NcFiNy+pw1YCONiUr+K6g800DXzT_0EA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 11:59:18 -0400, Willem de Bruijn wrote:
> > diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> > index 7c0b2b778703..43922d86e510 100644
> > --- a/net/tls/tls_device.c
> > +++ b/net/tls/tls_device.c
> > @@ -373,9 +373,9 @@ static int tls_push_data(struct sock *sk,
> >         struct tls_context *tls_ctx = tls_get_ctx(sk);
> >         struct tls_prot_info *prot = &tls_ctx->prot_info;
> >         struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
> > -       int tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
> >         int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
> >         struct tls_record_info *record = ctx->open_record;
> > +       int tls_push_record_flags;
> >         struct page_frag *pfrag;
> >         size_t orig_size = size;
> >         u32 max_open_record_len;
> > @@ -390,6 +390,9 @@ static int tls_push_data(struct sock *sk,
> >         if (sk->sk_err)
> >                 return -sk->sk_err;
> >
> > +       flags |= MSG_SENDPAGE_DECRYPTED;
> > +       tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
> > +  
> 
> Without being too familiar with this code: can this plaintext flag be
> set once, closer to the call to do_tcp_sendpages, in tls_push_sg?
> 
> Instead of two locations with multiple non-trivial codepaths between
> them and do_tcp_sendpages.
> 
> Or are there paths where the flag is not set? Which I imagine would
> imply already passing s/w encrypted ciphertext.

tls_push_sg() is shared with sw path which doesn't have the device
validation. 

Device TLS can read tls_push_sg() via tls_push_partial_record() and
tls_push_data(). tls_push_data() is addressed directly here,
tls_push_partial_record() is again shared with SW path, so we have to
address it by adding the flag in tls_device_write_space().

The alternative is to add a conditional to tls_push_sg() which is 
a little less nice from performance and layering PoV but it is a lot
simpler..

Should I change?
