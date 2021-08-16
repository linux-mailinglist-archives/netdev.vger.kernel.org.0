Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984513EDA1D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhHPPqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhHPPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:46:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A5EC061764;
        Mon, 16 Aug 2021 08:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=Rp/i5q5qkGZSCwt8ltdnIxxLD/muU+MEfh/mQJtSKYk=; b=CMUQ2oW0we0hxLauspXHyJZiWW
        sErGYYsqTzE5bkvyt1nTqzUov3X07Z9O32ZKERbiGuMZHWEVvh2Q0WINVoJW+70EuoXk8ZshNtjxs
        u5EcAJzK7xR7x4ykbjDix8YM2n+zysKzLUTvFtVn+QAXiPISnebfN6CWhhk9RvCkLW+lbpWJXuCC7
        X2xxZyL8us7mZmi9B3b6qIR5R8Mz3vmOdxt2BePNvNO6Fx0havBwVYrYXbCdZZ/XtWsVIwIusfRGP
        CPSOF4FHGDAP5sWHQYJsaTRS8A7X4KGc/L16gyccHzKJvCqx0h+99lJc0BIUv+202JkAogMydgYtH
        mnptBrtgAD5VboxBVBbuyVGWTapAv90aDL0SRXfheREG0Y5/I265sh5FLr/BelrI66DOr4aEC1hOz
        Vsbq9Sz6iAsTRj+zl3l423T1xXcfsdsvrOO7tNoVP1gRNRS8CXaCj/FXhvv/ViMeb1Te/Y8UdIS9W
        Ki9cpOM0NvvpN/9hfUogyidW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mFenw-001ZNp-HV; Mon, 16 Aug 2021 15:45:36 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1628871893.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <17841c48-093e-af1c-c7c9-aa00859eb1b9@samba.org>
Date:   Mon, 16 Aug 2021 17:45:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> The behaviour is controlled by setting sqe->file_index, where 0 implies
> the old behaviour. If non-zero value is specified, then it will behave
> as described and place the file into a fixed file slot
> sqe->file_index - 1. A file table should be already created, the slot
> should be valid and empty, otherwise the operation will fail.
> 
> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
> accept takes a file, and it already uses the flag with a different
> meaning.

Would it be hard to support IOSQE_FIXED_FILE for the dirfd of openat*, renameat, unlinkat, statx?
(And mkdirat, linkat, symlinkat when they arrive)
renameat and linkat might be trickier as they take two dirfds, but it
would make the feature more complete and useful.

metze
