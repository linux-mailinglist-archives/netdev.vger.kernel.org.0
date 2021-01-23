Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B83015BA
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 15:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhAWOOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 09:14:05 -0500
Received: from mail.wangsu.com ([123.103.51.227]:45407 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbhAWON7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 09:13:59 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewDX36_KLgxgCY0CAA--.740S2;
        Sat, 23 Jan 2021 22:12:27 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com,
        netdev@vger.kernel.org, yangpc@wangsu.com, ycheng@google.com
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Sat, 23 Jan 2021 22:47:11 +0800
Message-Id: <1611413231-13731-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20210122172703.39cfff6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210122172703.39cfff6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-CM-TRANSID: 4zNnewDX36_KLgxgCY0CAA--.740S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF18GFyrtw13Cr48WF17ZFb_yoW8Ww1xpF
        45uayqyrs5KFy8Cws2yw1fZ3sYgwsxJF1rWr1UCFyjkw12q3WSqF48Kw43WF9Igr18Cw4a
        yrWjgrZIqF1FyFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l
        84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I
        8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv7VCY1x0262k0Y48FwI0_
        Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc
        8vx2IErcIFxwCY02Avz4vE14v_Xryl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv
        8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0Jj4sjbUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 9:27 AM "Jakub Kicinski" <kuba@kernel.org> wrote:
> 
> On Fri, 22 Jan 2021 11:53:46 +0100 Eric Dumazet wrote:
> > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > >
> > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > change from DISORDER to OPEN. If the sender is app-limited, it can only
> > > wait for the RTO timer to expire and retransmit.
> > >
> > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > until after tcp_fastretrans_alert() returns and remove the
> > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > >
> > > This commit has two additional benefits:
> > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > avoid spurious RTO caused by RTO timer early expires.
> > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > timer is set.
> > >
> > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > Cc: Neal Cardwell <ncardwell@google.com>
> >
> > This looks like a very nice patch, let me run packetdrill tests on it.
> > 
> > By any chance, have you cooked a packetdrill test showing the issue
> > (failing on unpatched kernel) ?
> 
> Any guidance on backporting / fixes tag? (once the packetdrill
> questions are satisfied)

By reading the commits, we can add:
Fixes: df92c8394e6e ("tcp: fix xmit timer to only be reset if data ACKed/SACKed")

