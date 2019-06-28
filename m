Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C105E598D5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfF1Kzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:55:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47106 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF1Kzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:55:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgoXW-0007Gu-QZ; Fri, 28 Jun 2019 12:55:34 +0200
Message-ID: <ef0411526d0e699a590c1546507cd179e73e8559.camel@sipsolutions.net>
Subject: Re: VLAN tags in mac_len
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        jhs@mojatatu.com, David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Date:   Fri, 28 Jun 2019 12:55:33 +0200
In-Reply-To: <fa2b9787-c658-ac49-1c35-0d84d52b3ec1@iogearbox.net>
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
         <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
         <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
         <fa2b9787-c658-ac49-1c35-0d84d52b3ec1@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 10:49 +0200, Daniel Borkmann wrote:

> > > > Any other thoughts?
> > > 
> > > imo skb_vlan_push() should still change mac_len.
> > > tc, ovs, bpf use it and expect vlan to be part of L2.
> > 
> > I'm not sure tc really cares, but it *is* a reasonable argument to make.
> > 
> > Like I said, whichever way I look at the problem, a different solution
> > looks more reasonable ;-)
> 
> Agree with Alexei that the approach which would be least confusing and/or
> potentially causing regressions might be to go for 1). 

Toshiaki explained already that (1) [changing the bridge code] isn't
sufficient, but Zahari is going to send patches to do (1) since that
lets use disentangle the bridge code from the rest of the discussion,
basically making it able to handle anything we throw at it.

> tc *does* care at least
> for the *BPF* case. In sch_clsact we have the ingress and egress hook where we
> can attach to and programs don't need to care where they are being attached
> since for both cases they see skb->data starting at eth header! In order to
> do this, we do a __skb_push()/__skb_pull() dance based on skb->mac_len depending
> from where we come. This also means that if a program pushed/popped a vlan tag,
> this still must be correct wrt expectations for the receive side. It is essential
> that there is consistent behavior on skb->mac_len given skbs can also be redirected
> from TX->RX or RX->TX(->RX), so that we don't pull to a wrong offset next time.

As somebody (also Toshiaki I think) explained, this is already not right
and tc mirred is broken.

So I still think we have a semantic problem here with mac_len and TX/RX,
but it's not something I feel I'm competent enough to really address.

johannes

