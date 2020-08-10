Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85345240F6A
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgHJTNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbgHJTNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:13:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF336C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 12:13:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C2A4812752982;
        Mon, 10 Aug 2020 11:56:21 -0700 (PDT)
Date:   Mon, 10 Aug 2020 12:13:06 -0700 (PDT)
Message-Id: <20200810.121306.1528219950635067954.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     netdev@vger.kernel.org, colin.king@canonical.com,
        ard.biesheuvel@linaro.org, edumazet@google.com
Subject: Re: [PATCH net] tcp: correct read of TFO keys on big endian systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1597081119-22280-1-git-send-email-jbaron@akamai.com>
References: <1597081119-22280-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Aug 2020 11:56:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Mon, 10 Aug 2020 13:38:39 -0400

> When TFO keys are read back on big endian systems either via the global
> sysctl interface or via getsockopt() using TCP_FASTOPEN_KEY, the values
> don't match what was written.
> 
> For example, on s390x:
> 
> # echo "1-2-3-4" > /proc/sys/net/ipv4/tcp_fastopen_key
> # cat /proc/sys/net/ipv4/tcp_fastopen_key
> 02000000-01000000-04000000-03000000
> 
> Instead of:
> 
> # cat /proc/sys/net/ipv4/tcp_fastopen_key
> 00000001-00000002-00000003-00000004
> 
> Fix this by converting to the correct endianness on read. This was
> reported by Colin Ian King when running the 'tcp_fastopen_backup_key' net
> selftest on s390x, which depends on the read value matching what was
> written. I've confirmed that the test now passes on big and little endian
> systems.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Fixes: 438ac88009bc ("net: fastopen: robustness and endianness fixes for SipHash")
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Reported-and-tested-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks Jason.
