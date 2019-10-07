Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC94CE272
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfJGM6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:58:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfJGM6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 08:58:24 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52ECC14014BC1;
        Mon,  7 Oct 2019 05:58:23 -0700 (PDT)
Date:   Mon, 07 Oct 2019 14:58:17 +0200 (CEST)
Message-Id: <20191007.145817.1363255118392494597.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        oss-drivers@netronome.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, simon.horman@netronome.com
Subject: Re: [RFC 1/2] net/tls: don't clear socket error if strparser
 aborted
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007035323.4360-2-jakub.kicinski@netronome.com>
References: <20191007035323.4360-1-jakub.kicinski@netronome.com>
        <20191007035323.4360-2-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 05:58:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sun,  6 Oct 2019 20:53:22 -0700

> If strparser encounters an error it reports it on the socket and
> stops any further processing. TLS RX will currently pick up that
> error code with sock_error(), and report it to user space once.
> Subsequent read calls will block indefinitely.
> 
> Since the error condition is not cleared and processing is not
> restarted it seems more correct to keep returning the error
> rather than sleeping.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

So I guess this is all about what the usual socket error code
semantics work, which is report-and-clear.

States which should signal errors are always checked in the
various code socket call paths and if necessary the socket
error is resignalled.

From what I'm seeing here, the issue is that the strparser stopped
state isn't resampled at the appropriate spot.  So I would rather
see that fixed rather than having socket errors become level
triggered in this special case.
