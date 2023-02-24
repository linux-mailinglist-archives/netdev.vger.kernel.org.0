Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB78D6A1BBF
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjBXMCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXMCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:02:07 -0500
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C82664D54
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:02:04 -0800 (PST)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1pVWly-007isE-OF; Fri, 24 Feb 2023 13:01:59 +0100
Date:   Fri, 24 Feb 2023 13:01:58 +0100
From:   David Lamparter <equinox@diac24.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Lamparter <equinox@diac24.net>, Jens Axboe <axboe@kernel.dk>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
Message-ID: <Y/inNodCGZlPz5wF@eidolon.nox.tf>
References: <20230224071745.20717-1-equinox@diac24.net>
 <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 11:26:27AM +0100, Eric Dumazet wrote:
> On Fri, Feb 24, 2023 at 8:18 AM David Lamparter <equinox@diac24.net> wrote:
[...]
> > packet_recvmsg() whitelists a bunch of MSG_* flags, which notably does
> > not include MSG_NOSIGNAL.  Unfortunately, io_uring always sets
> > MSG_NOSIGNAL, meaning AF_PACKET sockets can't be used in io_uring
> > recvmsg().
> 
> This is odd... I think MSG_NOSIGNAL flag has a meaning for sendmsg()
> (or write sides in general)
> 
> EPIPE is not supposed to be generated at the receiving side ?

I would agree, but then again the behavior is inconsistent between
socket types.  (AF_INET6, SOCK_RAW, ...) works fine with
io_uring/MSG_NOSIGNAL, meanwhile setting MSG_NOSIGNAL on (AF_PACKET,
SOCK_RAW, ...) gives EINVAL.

Just to get consistency, MSG_NOSIGNAL might be worth ignoring in
AF_PACKET recvmsg?  Independent of dropping it from io_uring...

> So I would rather make io_uring slightly faster :
[...]
> -       sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
> +       sr->msg_flags = READ_ONCE(sqe->msg_flags);
