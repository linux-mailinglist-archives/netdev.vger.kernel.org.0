Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A212F70C9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbhAODFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:05:04 -0500
Received: from mail.wangsu.com ([123.103.51.227]:42600 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbhAODFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 22:05:03 -0500
Received: from XMCDN1207038 (unknown [218.107.205.212])
        by app2 (Coremail) with SMTP id 4zNnewCX0xgBBgFgPV8FAA--.2416S2;
        Fri, 15 Jan 2021 11:03:29 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Eric Dumazet'" <edumazet@google.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     "'David Miller'" <davem@davemloft.net>,
        "'netdev'" <netdev@vger.kernel.org>
References: <1609192760-4505-1-git-send-email-yangpc@wangsu.com> <20210114085308.7cda4d92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89iK5N-u-DKLmAF4+RSiG1g4Y1YkcizTX5h12hsTdpMt0DA@mail.gmail.com>
In-Reply-To: <CANn89iK5N-u-DKLmAF4+RSiG1g4Y1YkcizTX5h12hsTdpMt0DA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TCP_SKB_CB(skb)->tcp_tw_isn not being used
Date:   Fri, 15 Jan 2021 11:03:27 +0800
Message-ID: <000501d6eaea$ff921960$feb64c20$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJSKHMM7auflcvWART/pWp4omH96gGIvTYkAjasITypE4ecAA==
Content-Language: zh-cn
X-CM-TRANSID: 4zNnewCX0xgBBgFgPV8FAA--.2416S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy3Kr15CFyfArWrZr1UJrb_yoW8GF4xpr
        97JF4SgryUKrZ5ZwnavFn5ZF1rXFsIy34xWr4DXFyS9r9xGFs7ZryxGr4jg3WrGr4xG3WF
        van8X3yDZ34DXwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgFb7Iv0xC_Zr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20x
        vY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I
        3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxV
        WUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8I
        cVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIF
        yTuYvjxUnjjgUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 1:12 AM Eric Dumazet <edumazet@google.com> wrote:
> 
> On Thu, Jan 14, 2021 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 29 Dec 2020 05:59:20 +0800 Pengcheng Yang wrote:
> > > TCP_SKB_CB(skb)->tcp_tw_isn contains an ISN, chosen by
> > > tcp_timewait_state_process() , when SYN is received in TIMEWAIT state.
> > > But tcp_tw_isn is not used because it is overwritten by
> > > tcp_v4_restore_cb() after commit eeea10b83a13 ("tcp: add
> > > tcp_v4_fill_cb()/tcp_v4_restore_cb()").
> > >
> > > To fix this case, we record tcp_tw_isn before tcp_v4_restore_cb() and
> > > then set it in tcp_v4_fill_cb(). V6 does the same.
> > >
> > > Fixes: eeea10b83a13 ("tcp: add tcp_v4_fill_cb()/tcp_v4_restore_cb()")
> > > Reported-by: chenc <chenc9@wangsu.com>
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> >
> > Please fix the date and resend. This patch came in last night,
> > but it has a date of December 28th.
> 
> Not this whole madness about tcp_v4_fill_cb()/tcp_v4_restore_cb()
> could be reverted

This makes isn always been 0 in tcp_conn_request(), because tcp_tw_isn
is always initialized to 0 in tcp_v4_fill_cb() and tcp_tw_isn becomes meaningless.
Do we need to make tcp_tw_isn work again?

> now we have an RB tree for out-of-order packets.

I don't quite understand how setting tcp_tw_isn for SYN would affect
out_of_order_queue?

