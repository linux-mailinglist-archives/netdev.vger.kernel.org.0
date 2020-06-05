Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB791F0083
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 21:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgFETsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 15:48:08 -0400
Received: from ja.ssi.bg ([178.16.129.10]:51994 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727010AbgFETsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 15:48:08 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 055JllY1009376;
        Fri, 5 Jun 2020 22:47:49 +0300
Date:   Fri, 5 Jun 2020 22:47:47 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Christoph Paasch <christoph.paasch@gmail.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
In-Reply-To: <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
Message-ID: <alpine.LFD.2.22.394.2006052206190.3874@ja.home.ssi.bg>
References: <538FB666.9050303@yahoo-inc.com> <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg> <5397A98F.2030206@yahoo-inc.com> <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 4 Jun 2020, Christoph Paasch wrote:

> On Wed, Jun 11, 2014 at 11:05 PM Julian Anastasov <ja@ssi.bg> wrote:
> >
> >
> > > The behavior that we want is for the receipt of the duplicate bare
> > > ACK to not result in waking up user space.  The socket still hasn't
> > > received any data, so there's no point in the process accepting the
> > > socket since there's nothing the process can do.
> >
> >         One problem with this behavior is that after first ACK
> > more ACKs are not expected. Your RST logic still relies on the
> > last SYN+ACK we sent to trigger additional ACK. I guess,
> > we can live with this because for firewalls it is not worse
> > than current behavior. We replace accept() with RST.
> >
> > > I would prefer that we send a RST upon receipt of a bare ACK for a
> > > socket that has completed the 3way handshake, waited the
> > > TCP_DEFER_ACCEPT timeout and has never received any
> > > data.  If it has timed out, then the server should be done with the
> > > connection request.
> >
> >         I'm ok with this idea.
> 
> Is there any specific reason as to why we would not want to do this?
> 
> API-breakage does not seem to me to be a concern here. Apps that are
> setting DEFER_ACCEPT probably would not expect to get a socket that
> does not have data to read.

	There are older threads that explain why we create sockets
on bare ACK:

https://marc.info/?t=125541062900001&r=1&w=2

	Starting message:

https://marc.info/?l=linux-netdev&m=125541058019459&w=2

	In short, it is better for firewalls when we
do not drop silently the request socket. For now we
do not have a way to specify that we do not want
child sockets without DATA.

TL;DR

Here is how TCP_DEFER_ACCEPT works for server, with
pseudo-states.

TCP_DEFER_ACCEPT for server uses:
- num_timeout: increments when it is time to send SYN+ACK
- num_retrans: increments when SYN+ACK is sent

- TCP_DEFER_ACCEPT (seconds) is converted to retransmission
periods. The possible time for SYN+ACK retransmissions is
calculated as the maximum of SYNCNT/tcp_synack_retries and
the TCP_DEFER_ACCEPT periods, see reqsk_timer_handler().

- when bare ACK is received we avoid resending SYN+ACKs, we
start to resend just when the last TCP_DEFER_ACCEPT period
is started, see syn_ack_recalc().

Pseudo States for SYN_RECV:

WAIT_AND_RESEND:
	- when:
		- SYN is received
	- [re]send SYN+ACK depending on SYNCNT (at least for
	TCP_DEFER_ACCEPT time, if set), the retransmission
	period is max-of(TCP_DEFER_ACCEPT periods, SYNCNT)
	- on received DATA => create socket
	- on received bare ACK:
		- if using TCP_DEFER_ACCEPT => enter WAIT_SILENTLY
		- if not using TCP_DEFER_ACCEPT => create socket

WAIT_SILENTLY:
	- when:
		- using TCP_DEFER_ACCEPT
		- bare ACK received (indicates that client received
		our SYN+ACK, so no need to resend anymore)
	- do not send SYN+ACK
	- on received DATA => create socket
	- on received bare ACK: drop it (do not resend on packet)
	- when the last TCP_DEFER_ACCEPT period starts enter
	REFRESH_STATE

REFRESH_STATE:
	- when:
		- last TCP_DEFER_ACCEPT period starts after bare ACK
	- resend depending on SYNCNT to update the connection state
	in client and stateful firewalls. Such packets will trigger
	DATA (hopefully), ACK, FIN, RST, etc. When SYNCNT is less
	than the TCP_DEFER_ACCEPT period, we will send single
	SYN+ACK, otherwise more SYN+ACKs will be sent (up to SYNCNT).
	- on received DATA => create socket
	- on received bare ACK: create socket
	- no more resends (SYNCNT) => Drop req.

Programming hints for servers:

1. TCP_DEFER_ACCEPT controlled with TCP_SYNCNT
	- set TCP_DEFER_ACCEPT (defer period) to 1 (used as flag=Enabled)
	- tune the possible retransmission period with TCP_SYNCNT
	- PRO:
		- more control on the sent packets
	- CON:
		- time depends on TCP_TIMEOUT_INIT value
		- server is not silent after bare ACK because
		defer period is small

2. Use just seconds in TCP_DEFER_ACCEPT
	- PRO:
		- defer period is specified in seconds
		- no SYN+ACKs are sent in defer period after bare ACK
		- can send more SYN+ACKs when TCP_SYNCNT is greater,
		to avoid losses

- In both cases be ready to accept sockets without data
after the defer period

Regards

--
Julian Anastasov <ja@ssi.bg>
