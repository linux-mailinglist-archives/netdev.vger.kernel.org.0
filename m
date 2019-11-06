Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63AEF0BE7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfKFCIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:08:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:08:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 419F81510370C;
        Tue,  5 Nov 2019 18:08:30 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:08:29 -0800 (PST)
Message-Id: <20191105.180829.228337395055155315.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        ebiggers@kernel.org, herbert@gondor.apana.org.au,
        glider@google.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH net v2] net/tls: fix sk_msg trim on fallback to copy
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104233657.21054-1-jakub.kicinski@netronome.com>
References: <20191104233657.21054-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:08:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon,  4 Nov 2019 15:36:57 -0800

> sk_msg_trim() tries to only update curr pointer if it falls into
> the trimmed region. The logic, however, does not take into the
> account pointer wrapping that sk_msg_iter_var_prev() does nor
> (as John points out) the fact that msg->sg is a ring buffer.
> 
> This means that when the message was trimmed completely, the new
> curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> neither smaller than any other value, nor would it actually be
> correct.
> 
> Special case the trimming to 0 length a little bit and rework
> the comparison between curr and end to take into account wrapping.
> 
> This bug caused the TLS code to not copy all of the message, if
> zero copy filled in fewer sg entries than memcopy would need.
> 
> Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> 
> v2:
>  - take into account that msg->sg is a ring buffer (John).
> 
> Link: https://lore.kernel.org/netdev/20191030160542.30295-1-jakub.kicinski@netronome.com/ (v1)
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> Co-developed-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied and queued up for -stable, thanks Jakub.
