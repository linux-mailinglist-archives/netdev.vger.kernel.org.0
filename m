Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651EB2CC10F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgLBPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:38:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727699AbgLBPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606923447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fUuCnMgUdAY/5QaW55yV5XnS5wXbHHaY4noHpbS0oA=;
        b=VGgJfl/yLsVBMhMEDmr0ieyhQ2hESlRtcTjQCDRV2sm2gB8zfLiOnENyAUf3TMDHAKMFTS
        /qm+vQJx5/EW7dckWJ33YikOfHQCy+/JTHDnHDy9CF1AhkErMhntvRBeKaPvIZBp99FiW4
        kjzod1AO8QNOnGIkZchKjnuyYZvNJq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-8qkSluLSN7eTpGH0QGyooQ-1; Wed, 02 Dec 2020 10:37:25 -0500
X-MC-Unique: 8qkSluLSN7eTpGH0QGyooQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82F7F3E757;
        Wed,  2 Dec 2020 15:37:24 +0000 (UTC)
Received: from ovpn-112-254.ams2.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9D2D60C17;
        Wed,  2 Dec 2020 15:37:22 +0000 (UTC)
Message-ID: <665bb3a603afebdcc85878f6b45bcf0313607994.camel@redhat.com>
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Date:   Wed, 02 Dec 2020 16:37:21 +0100
In-Reply-To: <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
         <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 14:18 +0100, Eric Dumazet wrote:
> 
> On 11/24/20 10:51 PM, Paolo Abeni wrote:
> > We can enter the main mptcp_recvmsg() loop even when
> > no subflows are connected. As note by Eric, that would
> > result in a divide by zero oops on ack generation.
> > 
> > Address the issue by checking the subflow status before
> > sending the ack.
> > 
> > Additionally protect mptcp_recvmsg() against invocation
> > with weird socket states.
> > 
> > v1 -> v2:
> >  - removed unneeded inline keyword - Jakub
> > 
> > Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
> >  1 file changed, 49 insertions(+), 18 deletions(-)
> > 
> 
> Looking at mptcp recvmsg(), it seems that a read(fd, ..., 0) will
> trigger an infinite loop if there is available data in receive queue ?

Thank you for looking into this!

I can't reproduce the issue with the following packetdrill ?!?

+0.0  connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
+0.1   > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8,mpcapable v1 fflags[flag_h] nokey>
+0.1   < S. 0:0(0) ack 1 win 65535 <mss 1460,sackOK,TS val 700 ecr 100,nop,wscaale 8,mpcapable v1 flags[flag_h] key[skey=2] >
+0.1  > . 1:1(0) ack 1 <nop, nop, TS val 100 ecr 700,mpcapable v1 flags[flag_h]] key[ckey,skey]>
+0.1 fcntl(3, F_SETFL, O_RDWR) = 0
+0.1   < .  1:201(200) ack 1 win 225 <dss dack8=1 dsn8=1 ssn=1 dll=200 nocs,  nop, nop>
+0.1   > .  1:1(0) ack 201 <nop, nop, TS val 100 ecr 700, dss dack8=201 dll=00 nocs>
+0.1 read(3, ..., 0) = 0

The main recvmsg() loop is interrupted by the following check:

                if (copied >= target)
                        break;

I guess we could loop while the msk has available rcv space and some
subflow is feeding new data. If so, I think moving:

	if (skb_queue_empty(&msk->receive_queue) &&
                    __mptcp_move_skbs(msk, len - copied))
                        continue;

after the above check should address the issue, and will make the
common case faster. Let me test the above - unless I underlooked
something relevant!

Thanks,

Paolo

