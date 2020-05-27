Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157171E40E2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 13:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgE0LzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 07:55:24 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51082 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729668AbgE0LzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 07:55:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jdueT-0006TD-Jb; Wed, 27 May 2020 13:55:17 +0200
Date:   Wed, 27 May 2020 13:55:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 2/2] mptcp: move recbuf adjustment to recvmsg
 path
Message-ID: <20200527115517.GG2915@breakpoint.cc>
References: <20200525181508.13492-1-fw@strlen.de>
 <20200525181508.13492-3-fw@strlen.de>
 <CALMXkpa8iryjBDu0dpduHnZXROwT5xWWY9rifau93gDE1HJsxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMXkpa8iryjBDu0dpduHnZXROwT5xWWY9rifau93gDE1HJsxg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch <christoph.paasch@gmail.com> wrote:
> tcp_rcv_space_adjust is called even when the app is not yet reading,
> thus wouldn't this mean that we still end up with an ever-growing
> window?

Window is based on available mptcp sk recvbuf.  When data is moved from
ssk to the mptcp sk, the skb truesize is charged to the mptcp rmem.

> E.g., imagine an app that does not read at all at the beginning. The
> call to tcp_rcv_space_adjust in patch 1/2 will make the subflow's
> window grow. Now, the app comes and reads one byte. Then, the window
> at MPTCP-level will jump regardless of how much the app actually read.

Yes, the rcvbufsz value will jump, regardless homw much the app
actually read.

> I think what is needed is to size the MPTCP-level window to 2 x the
> amount of data read by the application within an RTT (maximum RTT
> among all the active subflows). That way if an app reads 1 byte a
> second, the window will remain low. While for a bulk-transfer it will
> allow all subflows to receive at full speed [1].

Sounds like the idea to move skbs to msk was bad one?
Sorry, I don't see how I can make this work.

Even deferring tcp_rcv_space_adjust() until recv() time won't work,
given data has been pulled to the mptcp socket already.

NOT calling tcp_rcv_space_adjust() at all might work, but that would
require something else entirely.  We would still have to adjust the
subflow rcvbufsz in this case, else we may announce a window that is
larger than the memory limit of the ssk (and we will end up dropping
data at tcp level if the worker can't move the skbs fast enough).

> Or do you think that kind of tuning can be done in a follow-up patch?

This sounds completely different so I don't think that makes sense.
