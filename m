Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE23D62726D
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiKMULG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKMULD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:11:03 -0500
Received: from smtp3.cs.Stanford.EDU (smtp3.cs.stanford.edu [171.64.64.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A7B9FE0
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 12:11:00 -0800 (PST)
Received: from mail-ed1-f43.google.com ([209.85.208.43]:35722)
        by smtp3.cs.Stanford.EDU with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1ouJJj-0005zg-W2
        for netdev@vger.kernel.org; Sun, 13 Nov 2022 12:11:00 -0800
Received: by mail-ed1-f43.google.com with SMTP id x2so14574692edd.2
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 12:11:00 -0800 (PST)
X-Gm-Message-State: ANoB5pnFSACcYCWcPGTxEPYHjVgneVrS1HNNQP0g0o6M2f76p6eeyQFT
        B7MSjkKQ1U3lxaigzjPPKXfcyGnYVAgJk7d/jSo=
X-Google-Smtp-Source: AA0mqf5e1Sc0kNz04BvLRo0pxRNXsxS6M+3X2d3Mop7NdHgLBvo1h+Y3QWW1cztzCwztV+c1P8yfr++53fgSOD49XAs=
X-Received: by 2002:a05:6402:4491:b0:461:a7e0:735c with SMTP id
 er17-20020a056402449100b00461a7e0735cmr9218486edb.14.1668370259227; Sun, 13
 Nov 2022 12:10:59 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local> <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch> <Y29RBxW69CtiML6I@nanopsycho> <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
 <Y3ElDxZi6Hswga2D@lunn.ch>
In-Reply-To: <Y3ElDxZi6Hswga2D@lunn.ch>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Sun, 13 Nov 2022 12:10:22 -0800
X-Gmail-Original-Message-ID: <CAGXJAmwfyU0rdrp0g6UU8ctLHUrq_sAKTSk2R4LWoOgMTfPEAA@mail.gmail.com>
Message-ID: <CAGXJAmwfyU0rdrp0g6UU8ctLHUrq_sAKTSk2R4LWoOgMTfPEAA@mail.gmail.com>
Subject: Re: Upstream Homa?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Scan-Signature: 980022258218d8e0da9e8fd80fb6777b
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 9:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Homa implements RPCs rather than streams like TCP or messages like
> > UDP. An RPC consists of a request message sent from client to server,
> > followed by a response message from server back to client. This requires
> > additional information in the API beyond what is provided in the arguments to
> > sendto and recvfrom. For example, when sending a request message, the
> > kernel returns an RPC identifier back to the application; when waiting for
> > a response, the application can specify that it wants to receive the reply for
> > a specific RPC identifier (or, it can specify that it will accept any
> > reply, or any
> > request, or both).
>
> This sounds like the ancillary data you can pass to sendmsg(). I've
> not checked the code, it might be the current plumbing is only into to
> the kernel, but i don't see why you cannot extend it to also allow
> data to be passed back to user space. If this is new functionality,
> maybe add a new flags argument to control it.
>
> recvmsg() also has ancillary data.

Whoah! I'd never noticed the msg_control and msg_controllen fields before.
These may be sufficient to do everything Homa needs. Thanks for pointing
this out.

-John-
