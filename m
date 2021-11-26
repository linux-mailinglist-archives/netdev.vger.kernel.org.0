Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6620E45F147
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354276AbhKZQKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:10:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349870AbhKZQIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637942691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reXogvPJYTr6AC/O2Dk+/vWSEM80FShKN3nnN85aqjA=;
        b=cNcLKG4OKs8jmSCKbYB+sLfhHdvFwcrhUfbeVTlvPKPCcEYMHG3Pg4pacm8dtsM8AqpeYe
        p3NIKJ33dL8wvYoF9GHKexh5XRrCbA6EgpkPkxSa95Q3IxHoPgVqGsmsPbTdBbyU8IZhm5
        71cv47DjBcxbr+qYPqbOLJVSpCOxW/Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-acsB3COrPaWuj4Ql0V8V8Q-1; Fri, 26 Nov 2021 11:04:50 -0500
X-MC-Unique: acsB3COrPaWuj4Ql0V8V8Q-1
Received: by mail-ed1-f70.google.com with SMTP id b15-20020aa7c6cf000000b003e7cf0f73daso8312171eds.22
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 08:04:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=reXogvPJYTr6AC/O2Dk+/vWSEM80FShKN3nnN85aqjA=;
        b=k9HsS7nDZNHe6U/Oh87LmQKeXHDM3pohFFo2B0Ak3hPg9lCtD73H70ypK0T1KFNhLD
         ZQC/rMOgaTmVI9+0Q2ni1VJxB66EXmLo6Mtf414N+42QTwzs55difDWsf8SxH2QW5dPs
         Lkyd85U5jDuLq7M7pfVObsXyBtmQZSacG1LLxpoGOjX/OhAmcwSGtCkDwUGNH5U/zapc
         UTVTmtIw8MPncUpuJvF51tAWFNwDDd8Xl53+wj/58SYtHl/Vwd7sDNknx4xpPyFbdoUK
         Y7ih+eOjKWcI1fr4pms/PWqG+x8gAguvLMZOEhtxL0/A9uBgSYqoylVZG6RMRD9T+aHE
         raPw==
X-Gm-Message-State: AOAM532UXyM9OmH+GzJiuori0eLbhNttK0C+IKLEPlyeOgYkEuw9atSz
        A9ax1A9pyUVjNB3Dqf2Y6wghrcExLriBNpPy0x/zeY0Y/uyXvvIs1Z7LAZpqcKKr1eVaqiXaDQA
        HjshaO0oqBm3DDfPU
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr38885404ejc.374.1637942689162;
        Fri, 26 Nov 2021 08:04:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOM55rVBz+YwzqK4n3dYUFi3+3BUBFH6fAwSLOlqNRYThRjAibblX75DOjzYALeOQKsuEadQ==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr38885369ejc.374.1637942688932;
        Fri, 26 Nov 2021 08:04:48 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-234-118.dyn.eolo.it. [146.241.234.118])
        by smtp.gmail.com with ESMTPSA id b11sm4670302edz.50.2021.11.26.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 08:04:48 -0800 (PST)
Message-ID: <5cf05f168a1b1e16195cdabf9205047c59e162d6.camel@redhat.com>
Subject: Re: [PATCH net] tcp: fix page frag corruption on page fault
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Date:   Fri, 26 Nov 2021 17:04:47 +0100
In-Reply-To: <CANn89iJx9b=Z=40TGhNtc7fRQSd=9MeG1x1PnJv2S5PYdYUoyw@mail.gmail.com>
References: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
         <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com>
         <169f6a93856664dd4001840081c82f792ae1dc99.camel@redhat.com>
         <CANn89iJ=BRJheZjb_hMoLbEca1h3p79iKkpgPbF7DTpGcx=46g@mail.gmail.com>
         <CANn89iJx9b=Z=40TGhNtc7fRQSd=9MeG1x1PnJv2S5PYdYUoyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2021-11-26 at 07:32 -0800, Eric Dumazet wrote:
> On Fri, Nov 26, 2021 at 7:27 AM Eric Dumazet <edumazet@google.com> wrote:
> 
> > We need to find one flag that can ask  gfpflags_normal_context() to
> > return false for this case.
> > 
> > Or if too difficult, stop only using sk->sk_allocation to decide
> > between the per-thread frag, or the per socket one.
> > 
> > I presume there are few active CIFS sockets on a host. They should use
> > a per socket sk_frag.
> > 
> 
> A pure networking change could be to use a new MSG_  flag to force sendmsg()
> to use the sk->sk_frag, but that would add yet another test in TCP fast path.
> 
> About gfpflags_normal_context being used by dlm : we can simply add our own
> helper with a new name describing that we want:
> 
> Both being in process context, and not from page fault handler .

Thanks for the hints! I'm testing the following (replacing the helper
with direct usage of a suitable check). Plus some adjusting to the
sk_page_frag() description.

Paolo
---
diff --git a/include/net/sock.h b/include/net/sock.h
index b32906e1ab55..8ae6fecfa18c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2442,7 +2442,8 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-       if (gfpflags_normal_context(sk->sk_allocation))
+       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+           (__GFP_DIRECT_RECLAIM | __GFP_FS))
                return &current->task_frag;
 
        return &sk->sk_frag;

