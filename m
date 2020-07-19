Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD57224ED9
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 05:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGSD3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 23:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgGSD3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 23:29:54 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C6EC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 20:29:53 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id g4so4019883uaq.10
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 20:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T9mdi2pLJwUbcSCsBJBwXpyFkujCyjuf7fCR4x8y2Z8=;
        b=iUJoUiSLbnvj1ZGBxmX7E5hkHE7YX92Y2RgqCfyrE+uHiJty8g387JIymAkql9NiRF
         2y3cicN79ZdZYVDVfbmjb5Fd0dxxY6kADZITNyczlF69z8PfHuS+64jPSp/Rniv9wHxd
         93oMrl8zrd03zBwzofbljJakXZXKAnvWxyPu8zs+U2hzk2xn1mCrp/E1l7kRCvSlVAEF
         BthLcBrb7EO9YxvfZ6sNoRuweEbuba65lyhyCDqHr9JbLAcTfBUUOWeWhELH8w70EU0l
         u8jhlWhxS87FZRNVMhbYYgM30bSAcD36YqneS9LrbolcAQgWwldUw/qlh0e/BKqm2Z0u
         HbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T9mdi2pLJwUbcSCsBJBwXpyFkujCyjuf7fCR4x8y2Z8=;
        b=TtCKxyqbFAMDVMvLn1FOZPCN0X9oJBPGr2fWQU8FfCoQDgw+adPVPhSBT199cf1VVX
         bmtxdk5pZabohwVFZMqg5tDDeXWt92iG373h5AVsyZP2fLqAUMiE3UzVVNcCh9/gWYXS
         95G43wPDrX43GwwxNpcnDyOYdR7rwXuCokEAJ6PaxwV6NAQgOcFUuMHKTfcKgK7DlKLp
         FbasmYi1wKxMGF2QcMv345VuLzxfJW2dapHhfGXF5acergjkXq3YxX5ApJbsfXO3zFGK
         yxKCcN6bJjMP2vGInWWicEpvXMNYe+/+UypXOY9h2DrTTd/OCeqPHJ3acN1TUbH5MWxQ
         CxEg==
X-Gm-Message-State: AOAM531/c20n8qeQ4fsZLfNlAt4NlhbZ3oqEQrty/uWj1cSJZHpJ9ae8
        02fNSvkFOzRNqtTtZxfzhIN4oMlvA3VSIwhw5Z0oqg==
X-Google-Smtp-Source: ABdhPJwda/hA2gjlpnIvnECw//fC2Cex6QyiIvfERxuFteuH3yeNikh3Ndr4Rd3IhP9Co6a6Id31MkWc9dG8UmXo9Rs=
X-Received: by 2002:ab0:64cd:: with SMTP id j13mr11028892uaq.33.1595129392017;
 Sat, 18 Jul 2020 20:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <66945532-2470-4240-b213-bc36791b934b@huawei.com>
 <CADVnQyksf4Nt2hHsWaAs3wLOK+rDp79ph5TZywMqfEAPOVgzww@mail.gmail.com> <0694e7d6-6cb2-d515-0bca-0ae4a3f68dc5@huawei.com>
In-Reply-To: <0694e7d6-6cb2-d515-0bca-0ae4a3f68dc5@huawei.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 18 Jul 2020 23:29:34 -0400
Message-ID: <CADVnQymfO7EDqUvhtE=n=AGmND1ajfUPzcPLR6wB7PBVzYRSZA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Optimize the recovery of tcp when lack of SACK
To:     hujunwei <hujunwei4@huawei.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, wangxiaogang3@huawei.com,
        jinyiting@huawei.com, xuhanbing@huawei.com, zhengshaoyu@huawei.com,
        Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 6:43 AM hujunwei <hujunwei4@huawei.com> wrote:
>
>
> On 2020/7/17 22:44, Neal Cardwell wrote:
> > On Fri, Jul 17, 2020 at 7:43 AM hujunwei <hujunwei4@huawei.com> wrote:
> >>
> >> From: Junwei Hu <hujunwei4@huawei.com>
> >>
> >> In the document of RFC2582(https://tools.ietf.org/html/rfc2582)
> >> introduced two separate scenarios for tcp congestion control:
> >
> > Can you please elaborate on how the sender is able to distinguish
> > between the two scenarios, after your patch?
> >
> > It seems to me that with this proposed patch, there is the risk of
> > spurious fast recoveries due to 3 dupacks in the second second
> > scenario (the sender unnecessarily retransmitted three packets below
> > "send_high"). Can you please post a packetdrill test to demonstrate
> > that with this patch the TCP sender does not spuriously enter fast
> > recovery in such a scenario?
> >
> Hi neal,
> Thanks for you quick reply!
> What I want to says is when these three numbers: snd_una, high_seq and
> snd_nxt are the same, that means all data outstanding
> when the Loss state began have successfully been acknowledged.

Yes, that seems true.

> So the sender is time to exits to the Open state.
> I'm not sure whether my understanding is correct.

I don't think we want the sender to exit to the CA_Open state in these
circumstances. I think section 5 ("Avoiding Multiple Fast
Retransmits") of RFC 2582 states convincingly that senders should take
steps to avoid having duplicate acknowledgements at high_seq trigger a
new fast recovery. The Linux TCP implements those steps by *not*
exiting to the Open state, and instead staying in CA_Loss or
CA_Recovery.

To make things more concrete, here is the kind of timeline/scenario I
am concerned about with your proposed patch. I have not had cycles to
cook a packetdrill test like this, but this is the basic idea:

[connection does not have SACK or TCP timestamps enabled]
app writes 4*SMSS
Send packets P1, P2, P3, P4
TLP, spurious retransmit of P4
spurious RTO, set cwnd to 1, enter CA_Loss, retransmit P1
receive ACK for P1 (original copy)
slow-start, increase cwnd to 2, retransmit P2, P3
receive ACK for P2 (original copy)
slow-start, increase cwnd to 3, retransmit P4
receive ACK for P3 (original copy)
slow-start, increase cwnd to 4
receive ACK for P4 (original copy)
slow-start, increase cwnd to 5
[with your patch, at this point the sender does not meet the
 conditions for "Hold old state until something *above* high_seq is ACKed.",
 so sender exits CA_Loss and enters Open]
app writes 4*MSS
send P5, P6, P7, P8
receive dupack for P4 (due to spurious TLP retransmit of P4)
receive dupack for P4 (due to spurious CA_Loss retransmit of P1)
receive dupack for P4 (due to spurious CA_Loss retransmit of P2)
[with your patch, at this point we risk spuriously entering
 fast recovery because we have  received 3 duplicate ACKs for P4]

A packetdrill test that shows that this is not the behavior of your
proposed patch would help support your proposed patch (presuming > is
replaced by after()).

best,
neal

> >> This patch enhance the TCP congestion control algorithm for lack
> >> of SACK.
> >
> > You describe this as an enhancement. Can you please elaborate on the
> > drawback/downside of staying in CA_Loss in this case you are
> > describing (where you used kprobes to find that TCP stayed in CA_Loss
> > state when high_seq was equal to snd_nxt)?
> >
> I tried, but I can't reproduce it by packetdrill. This problem appeared
> in our production environment. Here is part of the trace message:
>
> First ack:
> #tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
>         packets_out=4 retrans_out=1 sacked_out=0 lost_out=4 snd_nxt=3427491485
>         snd_una=3427485917 high_seq=3427491485 reordering=1 mss_cache=1392
>         icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=1
>
> #tcp_fastretrans_alert: (tcp_fastretrans_alert+0x0/0x7b0) prior_snd_una=3427485917
>         num_dupack=0 packets_out=0 retrans_out=0 sacked_out=0 lost_out=0
>         snd_nxt=3427491485 snd_una=3427491485 high_seq=3427491485 reordering=1
>         mss_cache=1392 icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=1
>
> As we can see by func tcp_fastretrans_alert icsk_ca_state remains CA_Loss (4),
> and the numbers: snd_nxt, snd_una and high_seq are the same.
>
> first dup ack:
> #tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
>         packets_out=2 retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427494269
>         snd_una=3427491485 high_seq=3427491485 reordering=1 mss_cache=1392
>         icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=2
>
> #tcp_fastretrans_alert: (tcp_fastretrans_alert+0x0/0x7b0) num_dupack=1 packets_out=2
>         retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427494269 snd_una=3427491485
>         high_seq=3427491485 reordering=1 icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=2
>
> second dup ack:
> #tcp_ack: (tcp_ack+0x0/0x920) skb_tcp_seq=0x1dc21196 skb_tcp_ack_seq=0x9d5e4bcc(3427491485)
>         packets_out=4 retrans_out=0 sacked_out=0 lost_out=0 snd_nxt=3427497053
>         snd_una=3427491485 high_seq=3427491485 reordering=1 mss_cache=1392
>         icsk_ca_state=4 sack_ok=0 undo_retrans=1 snd_cwnd=4
>
> So, I really hope someone can answer whether my understanding is correct.
>
> > To deal with sequence number wrap-around, sequence number comparisons
> > in TCP need to use the before() and after() helpers, rather than
> > comparison operators. Here it seems the patch should use after()
> > rather than >. However,  I think the larger concern is the concern
> > mentioned above.
> >
> If this patch is useful, I will modify this.
>
> Regards Junwei
>
