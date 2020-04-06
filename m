Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEACB19FAE8
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgDFRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:01:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgDFRB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:01:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B00215D9F72B;
        Mon,  6 Apr 2020 10:01:27 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:01:23 -0700 (PDT)
Message-Id: <20200406.100123.2069151116269746360.davem@davemloft.net>
To:     will@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, jasowang@redhat.com
Subject: Re: [PATCH] tun: Don't put_page() for all negative return values
 from XDP program
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403151321.20166-1-will@kernel.org>
References: <20200403151321.20166-1-will@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:01:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Deacon <will@kernel.org>
Date: Fri,  3 Apr 2020 16:13:21 +0100

> When an XDP program is installed, tun_build_skb() grabs a reference to
> the current page fragment page if the program returns XDP_REDIRECT or
> XDP_TX. However, since tun_xdp_act() passes through negative return
> values from the XDP program, it is possible to trigger the error path by
> mistake and accidentally drop a reference to the fragments page without
> taking one, leading to a spurious free. This is believed to be the cause
> of some KASAN use-after-free reports from syzbot [1], although without a
> reproducer it is not possible to confirm whether this patch fixes the
> problem.
> 
> Ensure that we only drop a reference to the fragments page if the XDP
> transmit or redirect operations actually fail.
> 
> [1] https://syzkaller.appspot.com/bug?id=e76a6af1be4acd727ff6bbca669833f98cbf5d95
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> CC: Eric Dumazet <edumazet@google.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")
> Signed-off-by: Will Deacon <will@kernel.org>

Applied and queued up for -stable, thank you.
