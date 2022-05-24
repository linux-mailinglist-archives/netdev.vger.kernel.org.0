Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0B0533359
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 00:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbiEXWNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 18:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238914AbiEXWNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 18:13:43 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD3C5DD3F
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 15:13:42 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ec42eae76bso196636277b3.10
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 15:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHIJKfxgTwjjvyeenG8PqcpEQiKi1RaY8gq052ZcCvA=;
        b=T6hMuCVEX+qbOyFR89d+IsjkmG2gLaJBxFErHe2gyjpChqhEV06irPnesumPglEbfQ
         9RzraS+IIv/IhS0qu2Eb0eQBfqdVIF0RlpIoeWoDmLfii1Sv2YC4SF3LbnRSukQZ9qzz
         pJeqxph4Qi7c2sNv99au5tIQWl0ozkKlnmd0V0WGFX7sQ3dOwTkeZMU1khTXPmPQHJUl
         tZRACg67zb7w/EkNZGLYl1lNsBDGe92KUIKcc3T5erYvU9J/dpKPz0/i2XHRBRlFK4A3
         /sJCr+ROTjxFyDkrFfp0KBpEqKnWDuU4RBCUt/jU889SHRV3NrZrFAXMFOer49lqOH/N
         eGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHIJKfxgTwjjvyeenG8PqcpEQiKi1RaY8gq052ZcCvA=;
        b=LHpdeBrloXi0ONSjxgeIu3GkCAlJ1QHw4M6ui7dAUA2W9wiJEjABTcFvf0jJ9bQUuc
         L7dMp/VnGetJIHdPHpidrg2HzP47URXhErXoujqcxLLBZ24yfP1mZpp3lh8RtMWssSAO
         gPGpOKpT/ZrW63lojCQ/aHoZrC+d/rPpD2IGPeNkRzof8EhqNyrxLq9mxCDCGPBXKbks
         Xm+2vm27hsVCMjm614aZD+Cepb7fGCmezmU+JK0A43UikeEBdVSLoRBb7E1t11GQDLMU
         kuazY/2jbizY6n5ZbAYtp66p7EOH6kvCicAFuXIgJGDzgVxWheVHF6u5Ir0KfxPKqbGl
         iB2g==
X-Gm-Message-State: AOAM530Ehw1oLrBLa35teilg/JORh1iL5bZmeTXgbRkoYKXRUyrkHXIP
        lmxOeR34TlYzVrnOwcf5D0swzbmEh6lV1KsIV2r7Mw==
X-Google-Smtp-Source: ABdhPJyPc88P2qZG0MlVyVyfq8FoXxqbvtwhO8/rX8P/8ABbhE+AGmGT7ZRg5cLCPMPFGBCy5w823/y9Oc1NWeiO0uU=
X-Received: by 2002:a81:b401:0:b0:300:2e86:e7e5 with SMTP id
 h1-20020a81b401000000b003002e86e7e5mr4631478ywi.467.1653430421051; Tue, 24
 May 2022 15:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
In-Reply-To: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 May 2022 15:13:29 -0700
Message-ID: <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 1:19 AM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Hello,
>
> We have a set of processes which talk with each other through a local
> TCP socket. If the process(es) are killed (through SIGKILL) and
> restarted at once, the bind() fails with EADDRINUSE error. This error
> only appears if application is restarted at once without waiting for 60
> seconds or more. It seems that there is some timeout of 60 seconds for
> which the previous TCP connection remains alive waiting to get closed
> completely. In that duration if we try to connect again, we get the error.
>
> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> socket in a hack. But this hack cannot be added to the application
> process as we don't own it.
>
> I've looked at the TCP connection states after killing processes in
> different ways. The TCP connection ends up in 2 different states with
> timeouts:
>
> (1) Timeout associated with FIN_WAIT_1 state which is set through
> `tcp_fin_timeout` in procfs (60 seconds by default)
>
> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> seems like this timeout has come from RFC 1337.
>
> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> also doesn't seem feasible to change the timeout of TIME_WAIT state as
> the RFC mentions several hazards. But we are talking about a local TCP
> connection where maybe those hazards aren't applicable directly? Is it
> possible to change timeout for TIME_WAIT state for only local
> connections without any hazards?
>
> We have tested a hack where we replace timeout of TIME_WAIT state from a
> value in procfs for local connections. This solves our problem and
> application starts to work without any modifications to it.
>
> The question is that what can be the best possible solution here? Any
> thoughts will be very helpful.
>

One solution would be to extend TCP diag to support killing TIME_WAIT sockets.
(This has been raised recently anyway)

Then you could zap all sockets, before re-starting your program.

ss -K -ta src :listen_port

Untested patch:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..1b7bde889096aa800b2994c64a3a68edf3b62434
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4519,6 +4519,15 @@ int tcp_abort(struct sock *sk, int err)
                        local_bh_enable();
                        return 0;
                }
+               if (sk->sk_state == TCP_TIME_WAIT) {
+                       struct inet_timewait_sock *tw = inet_twsk(sk);
+
+                       refcount_inc(&tw->tw_refcnt);
+                       local_bh_disable();
+                       inet_twsk_deschedule_put(tw);
+                       local_bh_enable();
+                       return 0;
+               }
                return -EOPNOTSUPP;
        }
