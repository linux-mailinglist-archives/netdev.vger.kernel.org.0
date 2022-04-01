Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303544EECE4
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245554AbiDAMLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiDAMLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:11:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82547C6EEF;
        Fri,  1 Apr 2022 05:10:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1naG6I-0007Oy-V9; Fri, 01 Apr 2022 14:09:58 +0200
Date:   Fri, 1 Apr 2022 14:09:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Message-ID: <20220401120958.GA28321@breakpoint.cc>
References: <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
 <20220401001531.GB9545@breakpoint.cc>
 <7d08dcfd-6ba0-f972-cee3-4fa0eff8c855@uls.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d08dcfd-6ba0-f972-cee3-4fa0eff8c855@uls.co.za>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaco Kroon <jaco@uls.co.za> wrote:
> > Eric Dumazet <edumazet@google.com> wrote:
> >> Next step would be to attempt removing _all_ firewalls, especially not
> >> common setups like yours.
> >>
> >> conntrack had a bug preventing TFO deployment for a while, because
> >> many boxes kept buggy kernel versions for years.
> >>
> >> 356d7d88e088687b6578ca64601b0a2c9d145296 netfilter: nf_conntrack: fix
> >> tcp_in_window for Fast Open
> > Jaco could also try with
> > net.netfilter.nf_conntrack_tcp_be_liberal=1
> >
> > and, if that helps, with liberal=0 and
> > sysctl net.netfilter.nf_conntrack_log_invalid=6
> >
> > (check dmesg/syslog/nflog).
> 
> Our core firewalls already had nf_conntrack_tcp_be_liberal for other
> reasons (asymmetric routing combined with conntrackd left-over if I
> recall), so maybe that's why it got through there ... don't exactly want
> to just flip that setting though, is there a way to log if it would have
> dropped anything, without actually dropping it (yet)?

This means conntrack doesn't tag packets as invalid EVEN if it would
consider sequence/ack out-of-window (e.g. due to a bug).

I have a hard time seeing how tcp liberal-mode conntrack would be to
blame here.

Only thing you could also check is if
net.netfilter.nf_conntrack_checksum=0 helps (but i doubt it).
