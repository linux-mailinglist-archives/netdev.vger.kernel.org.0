Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F7D2854D2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 01:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgJFXAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 19:00:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:42903 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgJFXAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 19:00:36 -0400
IronPort-SDR: mYUQV1vBZ2gjkJFVSxYa9rVxJhmCAZPv/Gwog0nDoyX4cjPzaBtMEuTLdFHx9EpUjHcDQ4RLuj
 o/sPlH666cwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="228875315"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="228875315"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:00:34 -0700
IronPort-SDR: IGzinGzUpXRkoZu/3OVWRGjsYep8rHv8d+kK9exIYzF/sy3f243n8m5FyV5ogAwLUUIudYBIkB
 ts4ojNSJu9/Q==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297357237"
Received: from ccarpent-mobl.amr.corp.intel.com ([10.255.229.108])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:00:34 -0700
Date:   Tue, 6 Oct 2020 16:00:33 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ccarpent-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: fix infinite loop on recvmsg()/worker()
 race.
In-Reply-To: <5a2464d778499bdc2ced43b56569008030b470bc.1601965539.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2010061600080.22542@ccarpent-mobl.amr.corp.intel.com>
References: <5a2464d778499bdc2ced43b56569008030b470bc.1601965539.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020, Paolo Abeni wrote:

> If recvmsg() and the workqueue race to dequeue the data
> pending on some subflow, the current mapping for such
> subflow covers several skbs and some of them have not
> reached yet the received, either the worker or recvmsg()
> can find a subflow with the data_avail flag set - since
> the current mapping is valid and in sequence - but no
> skbs in the receive queue - since the other entity just
> processed them.
>
> The above will lead to an unbounded loop in __mptcp_move_skbs()
> and a subsequent hang of any task trying to acquiring the msk
> socket lock.
>
> This change addresses the issue stopping the __mptcp_move_skbs()
> loop as soon as we detect the above race (empty receive queue
> with data_avail set).
>
> Reported-and-tested-by: syzbot+fcf8ca5817d6e92c6567@syzkaller.appspotmail.com
> Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
