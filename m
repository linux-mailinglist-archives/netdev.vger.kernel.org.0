Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184941CC08F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgEIKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 06:53:06 -0400
Received: from a3.inai.de ([88.198.85.195]:51516 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgEIKxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 06:53:05 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 3D8FA58726E2B; Sat,  9 May 2020 12:52:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3A3BF60D6DCD7;
        Sat,  9 May 2020 12:52:59 +0200 (CEST)
Date:   Sat, 9 May 2020 12:52:59 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID'
 packets
In-Reply-To: <20200509052235.150348-1-zenczykowski@gmail.com>
Message-ID: <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr>
References: <20200509052235.150348-1-zenczykowski@gmail.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Saturday 2020-05-09 07:22, Maciej Żenczykowski wrote:
>diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
>index 0030a51f..b6474811 100644
>--- a/extensions/libip6t_REJECT.man
>+++ b/extensions/libip6t_REJECT.man
>@@ -30,3 +30,18 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
> hosts (which won't accept your mail otherwise).
> \fBtcp\-reset\fP
> can only be used with kernel versions 2.6.14 or later.
>+.PP
>+\fIWarning:\fP if you are using connection tracking and \fBACCEPT\fP'ing
>+\fBESTABLISHED\fP (and possibly \fBRELATED\fP) state packets, do not
>+indiscriminately \fBREJECT\fP (especially with \fITCP RST\fP) \fBINVALID\fP
>+state packets.  Sometimes naturally occuring packet reordering will result
>+in packets being considered \fBINVALID\fP and the generated \fITCP RST\fP
>+will abort an otherwise healthy connection.

I fail to understand the problem here.

1. Because ESTABLISHED and INVALID are mutually exclusive, there is no ordering
dependency between two rules of the kind {EST=>ACCEPT, INV=>REJ},
and thus their order plays no role.

2. Given packets D,R (data, rst) leads to state(ct(D))=EST, state(ct(R))=EST in
the normal case. When this gets reordered to R,D, then we end up with
state(ct(R))=EST, state(ct(D))=INV. Though the outcome of nfct changes,
I do not think that will be of consequence, because in the absence of
filtering, the tcp layer should be discarding/rejecting D.

3. Natural reordering of D1,D2 to D2,D1 should not cause nfct to drop the ct
at reception of D1 and turn the state to INV. Reordering can happen at any
time, and we'd be having more reports of problems if it did, wouldn't we...
