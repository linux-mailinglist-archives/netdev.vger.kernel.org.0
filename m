Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2E72A89CD
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbgKEW3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEW3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:29:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15FA206CA;
        Thu,  5 Nov 2020 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604615371;
        bh=DobVJld3XOD8+niF6lsRIvou3qGiaczfo6HD3Wwn9Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zkfizXwJpxLPmDsNoAYb/Usn4nFHEY42fMDSUCL3uRmIFknA8GC7awJejdsCaew1t
         76hrCQF7Uom4o2KyBDjafsfse0ejX0bUEyJ5mCeooiBCBqYInG9UGrBWFghtMynM2m
         J3wvcAO+ghtyPZgf1hN4aLamnMPBvTqPmrYSuSoQ=
Date:   Thu, 5 Nov 2020 14:29:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        davem@davemloft.net
Subject: Re: [PATCH net-next] sctp: bring inet(6)_skb_parm back to
 sctp_input_cb
Message-ID: <20201105142927.521f323a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105034909.GJ11030@localhost.localdomain>
References: <136c1a7a419341487c504be6d1996928d9d16e02.1604472932.git.lucien.xin@gmail.com>
        <20201105034909.GJ11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 00:49:09 -0300 Marcelo Ricardo Leitner wrote:
> On Wed, Nov 04, 2020 at 02:55:32PM +0800, Xin Long wrote:
> > inet(6)_skb_parm was removed from sctp_input_cb by Commit a1dd2cf2f1ae
> > ("sctp: allow changing transport encap_port by peer packets"), as it
> > thought sctp_input_cb->header is not used any more in SCTP.
> > 
> > syzbot reported a crash:
> > 
> >   [ ] BUG: KASAN: use-after-free in decode_session6+0xe7c/0x1580
> >   [ ]
> >   [ ] Call Trace:
> >   [ ]  <IRQ>
> >   [ ]  dump_stack+0x107/0x163
> >   [ ]  kasan_report.cold+0x1f/0x37
> >   [ ]  decode_session6+0xe7c/0x1580
> >   [ ]  __xfrm_policy_check+0x2fa/0x2850
> >   [ ]  sctp_rcv+0x12b0/0x2e30
> >   [ ]  sctp6_rcv+0x22/0x40
> >   [ ]  ip6_protocol_deliver_rcu+0x2e8/0x1680
> >   [ ]  ip6_input_finish+0x7f/0x160
> >   [ ]  ip6_input+0x9c/0xd0
> >   [ ]  ipv6_rcv+0x28e/0x3c0
> > 
> > It was caused by sctp_input_cb->header/IP6CB(skb) still used in sctp rx
> > path decode_session6() but some members overwritten by sctp6_rcv().
> > 
> > This patch is to fix it by bring inet(6)_skb_parm back to sctp_input_cb
> > and not overwriting it in sctp4/6_rcv() and sctp_udp_rcv().
> > 
> > Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com
> > Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thanks!
