Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA7D626DE1
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 07:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKMG0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 01:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMG0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 01:26:31 -0500
Received: from smtp2.cs.Stanford.EDU (smtp2.cs.stanford.edu [171.64.64.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A595F13F32
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 22:26:30 -0800 (PST)
Received: from mail-ej1-f43.google.com ([209.85.218.43]:43742)
        by smtp2.cs.Stanford.EDU with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1ou6Rp-0002Nv-B3
        for netdev@vger.kernel.org; Sat, 12 Nov 2022 22:26:30 -0800
Received: by mail-ej1-f43.google.com with SMTP id m22so21232737eji.10
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 22:26:29 -0800 (PST)
X-Gm-Message-State: ANoB5plVf7r4hFo97xWc1BnAPk0LqQc/KE5gI3LE2VJxOR9GXFLj0Dsh
        mmYJpKrGPLjUiji6wkjvPCt9tLdyXH5k7PSYsCc=
X-Google-Smtp-Source: AA0mqf6C6eYL2focG3qyTjHKKSKi7lwuXjtO2j87SQKyBdKLPcMkVWiCXO6WH9C2Y515jypGSPxDjXCtg2bSTZReV7k=
X-Received: by 2002:a17:906:654a:b0:78d:e645:9f7d with SMTP id
 u10-20020a170906654a00b0078de6459f7dmr6491589ejn.572.1668320788367; Sat, 12
 Nov 2022 22:26:28 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local> <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch> <Y29RBxW69CtiML6I@nanopsycho>
In-Reply-To: <Y29RBxW69CtiML6I@nanopsycho>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Sat, 12 Nov 2022 22:25:50 -0800
X-Gmail-Original-Message-ID: <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
Message-ID: <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
Subject: Re: Upstream Homa?
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Scan-Signature: 6b0537b5faa14548adc1759647fcb4de
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 11:53 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Fri, Nov 11, 2022 at 08:25:44PM CET, andrew@lunn.ch wrote:
> >On Fri, Nov 11, 2022 at 10:59:58AM -0800, John Ousterhout wrote:
> >> The netlink and 32-bit kernel issues are new for me; I've done some digging to
> >> learn more, but still have some questions.
> >>
> >
> >> * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
> >> currently uses ioctls on sockets for I/O (its APIs aren't sockets-compatible).
>
> Why exactly it isn't sockets-comatible?

Homa implements RPCs rather than streams like TCP or messages like
UDP. An RPC consists of a request message sent from client to server,
followed by a response message from server back to client. This requires
additional information in the API beyond what is provided in the arguments to
sendto and recvfrom. For example, when sending a request message, the
kernel returns an RPC identifier back to the application; when waiting for
a response, the application can specify that it wants to receive the reply for
a specific RPC identifier (or, it can specify that it will accept any
reply, or any
request, or both).

> >> It looks like switching to netlink would double the number of system calls that
> >> have to be invoked, which would be unfortunate given Homa's goal of getting the
> >> lowest possible latency. It also looks like netlink might be awkward for
> >> dumping large volumes of kernel data to user space (potential for buffer
> >> overflow?).
>
> Netlink is slow, you should use it for fast path. It is for
> configuration and stats.
>
>
