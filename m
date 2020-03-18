Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39161894C3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgCREIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:08:11 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44634 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCREIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:08:10 -0400
Received: by mail-io1-f65.google.com with SMTP id v3so13367074iot.11;
        Tue, 17 Mar 2020 21:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1y3VYEMMB36hbyX25xJqlRITD/GhHC8JGwRXWq8x8hA=;
        b=SO1oIEi2lDBKF7zFXFbJuTnir4JvQJ83EqL16ln6U9b73HI37FJPY/n5zd7WBeA4xT
         eSOzwhphtjC7ORQUrP0kEn/x138QBwEZmTGV1ZFH67YzooM5QTeQdhe20aVtaVekb8NI
         /xk5e95ZvfaF+L+HwedaiiDWNLiWVD2GIn0O5GV5HTgtvdXrSlHs5k76QDGfSmBR7EVl
         dZH04BE11Hjcorz0Jivn353F2yM6mHaDdC6UVNlMeYzrsTMCdQXDWkYTKSg4bQ9L/cLv
         ciTKEip9JzgGb8gtO9GBGHvVZgyNsPKIxU8hC+4TeJa1PtMkDlhooHjyQUkoohoaGpU3
         JNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1y3VYEMMB36hbyX25xJqlRITD/GhHC8JGwRXWq8x8hA=;
        b=tAufFOWTrLSSjfYWYvWvPwGhZygK5CkhD78f3XX15TyhCweqQjBu+J01dox2a/dWNF
         0b/ia3/6yhtxqLXvfi9MTroGGGqwDRlVSiJBZJD4GxLxNgzYAPDWnRy8e3HOi804C4Et
         N/VMzN9XKyY3E2w6atzY4ihYtU5+PunyGPLxlHi8M+ntbw2VbFSOyuMC42ZnauRiKdz8
         7TCJFV/UPorTvHdMv37m4O8QFc0lPJziJyddXx9d86wA6cadpLxxJFnj/tA2innKHApd
         BNmAJoZwFldAWm6fRDsVFAgvDCwbbzyXjHBn95QrLwA4b2nrQrdFhDBv0L726n/HF4UD
         3gqQ==
X-Gm-Message-State: ANhLgQ37dhah8DKs1ZBEPNidNqIi3HoJeXwNcpl2/hMjzzjnpfilz+oN
        gr4FPhAWZMuUvGZ4vPBiaODiOrg8WTSNhQj1J/Y=
X-Google-Smtp-Source: ADFU+vvgce9sXkaz3f8wxIYnDObhVxsw1YvGMs4jy4g39o/Wm9Ssbao4HjLfqzLh+ADtG1QWpcoybH8JO0n1aBJbC1U=
X-Received: by 2002:a02:220f:: with SMTP id o15mr2608999jao.106.1584504489108;
 Tue, 17 Mar 2020 21:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
 <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com> <20200318035549.GC3756@localhost.localdomain>
In-Reply-To: <20200318035549.GC3756@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Wed, 18 Mar 2020 12:07:58 +0800
Message-ID: <CAJRQjoeGtALzDHUS+OUJfK-JqQ_T-_RX74Opt-TLTxufVAQN7g@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:55 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Mar 18, 2020 at 10:45:51AM +0800, Qiujun Huang wrote:
>
> Hmm, not sure how you got that out of that debug msg, but okay.
> Even if so, how would this trouble skb be accounted on the wrong sk by
> then?
>
> Asking because the fix that we want may be a better locking, to
> prevent this situation from happening, than compensating for it in
> sctp_wfree(). But for that we need to understand how this happened.
>

Yes, I should find the root cause. Here is the log

[   86.507432][ T8813] [1]skb 0xffff88809fdfc800 0xffff88809621e7c0:
truesize 768, sk alloc 769 sctp_set_owner_w 137
[   86.532042][ T8813] [1]skb 0xffff888099ebbe80 0xffff88809621e7c0:
truesize 131328, sk alloc 132353 sctp_set_owner_w 137
[   86.543426][ T8813] [1]skb 0xffff88809ef55cc0 0xffff88809621e7c0:
truesize 131328, sk alloc 263937 sctp_set_owner_w 137
[   86.563229][ T8813] [1]skb 0xffff88809ef557c0 0xffff88809621e7c0:
truesize 131328, sk alloc 395521 sctp_set_owner_w 137
[   86.589332][ T8813] [1]skb 0xffff88809ef55a40 0xffff88809621e7c0:
truesize 33024, sk alloc 428801 sctp_set_owner_w 137
[   86.602211][ T8813] [1]deal with transmitted 0xffff8880910b0a80
from transport 0xffff8880910b0800  __sctp_outq_teardown, 216
[   86.616336][ T8813] [1]put back to queue 0xffff888091dc8770
sctp_check_transmitted, 1683
[   86.625610][ T8813] [1]get packet 0xffff888099ebbe80 from queue
0xffff888096b2c280  sctp_check_transmitted, 1437
[   86.637105][ T8813] [1]put skb 0xffff888099ebbe80 back.
sctp_check_transmitted, 1533
[   86.646284][ T8813] [1]put back to queue 0xffff888096b2c280
sctp_check_transmitted, 1683          ----
[   86.687575][ T8813] [1]before sk 0xffff88809621e7c0
sctp_sock_migrate, 9592                               ----I think
something wrong opens here. 0xffff888099ebbe80 not changed to newsk
[   86.696296][ T8813] [1]skb 0xffff88809ef55cc0 0xffff88809621e7c0:
truesize 131328, sk alloc 429057 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.721891][ T8813] [1]transmitted done queue 0xffff888091dc83d0
sctp_for_each_tx_datachunk, 166
[   86.757260][ T8813] [1]retransmit done queue 0xffff888091dc8770
sctp_for_each_tx_datachunk, 171
[   86.771065][ T8813] [1]sacked done queue 0xffff888091dc8760
sctp_for_each_tx_datachunk, 176
[   86.797487][ T8813] [1]abandoned done queue 0xffff888091dc8780
sctp_for_each_tx_datachunk, 181
[   86.814856][ T8813] [0]skb 0xffff88809ef557c0 0xffff88809621e7c0:
truesize 131328, sk alloc 297473 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.831799][ T8813] [0]skb 0xffff88809ef55a40 0xffff88809621e7c0:
truesize 33024, sk alloc 165889 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   86.845473][ T8813] [0]out_chunk_list done queue 0xffff888091dc8730
sctp_for_each_tx_datachunk, 186
[   86.866011][ T8813] [0]skb 0xffff88809ef55cc0 0xffff8880a3bb2800:
truesize 131328, sk alloc 131329 sctp_set_owner_w 137
[   86.884811][ T8813] [0]transmitted done queue 0xffff888091dc83d0
sctp_for_each_tx_datachunk, 166
[   86.896150][ T8813] [0]retransmit done queue 0xffff888091dc8770
sctp_for_each_tx_datachunk, 171
[   86.907233][ T8813] [0]sacked done queue 0xffff888091dc8760
sctp_for_each_tx_datachunk, 176
[   86.916825][ T8813] [0]abandoned done queue 0xffff888091dc8780
sctp_for_each_tx_datachunk, 181
[   86.927458][ T8813] [0]skb 0xffff88809ef557c0 0xffff8880a3bb2800:
truesize 131328, sk alloc 262913 sctp_set_owner_w 137
[   86.957446][ T8813] [0]skb 0xffff88809ef55a40 0xffff8880a3bb2800:
truesize 33024, sk alloc 296193 sctp_set_owner_w 137
[   86.971810][ T8813] [0]out_chunk_list done queue 0xffff888091dc8730
sctp_for_each_tx_datachunk, 186
[   86.992386][ T8813] [0]after sk 0xffff8880a3bb2800 sctp_sock_migrate, 9597
[   87.091320][ T8811] [1]deal with transmitted 0xffff8880a6f52280
from transport 0xffff8880a6f52000  __sctp_outq_teardown, 216
[   87.110552][ T8811] [1]skb 0xffff88809fdfc800 0xffff88809621e7c0:
truesize 768, sk alloc 132609 sctp_wfree 9101 real sk
0xffff88809621e7c0
[   87.180238][ T8811] [0]deal with transmitted 0xffff888096b2c280
from transport 0xffff888096b2c000  __sctp_outq_teardown, 216
[   87.264062][ T8811] [0]skb 0xffff888099ebbe80 0xffff8880a3bb2800:
truesize 131328, sk alloc 296449 sctp_wfree 9101 real sk
0xffff88809621e7c0       --->the trouble skb
[   87.289730][ T8811] [1]skb 0xffff88809ef55cc0 0xffff8880a3bb2800:
truesize 131328, sk alloc 296193 sctp_wfree 9101 real sk
0xffff8880a3bb2800
[   87.314206][ T8811] [1]skb 0xffff88809ef557c0 0xffff8880a3bb2800:
truesize 131328, sk alloc 164609 sctp_wfree 9101 real sk
0xffff8880a3bb2800
[   87.329602][ T8811] [1]skb 0xffff88809ef55a40 0xffff8880a3bb2800:
truesize 33024, sk alloc 33025 sctp_wfree 9101 real sk
0xffff8880a3bb2800

>   Marcelo
