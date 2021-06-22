Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850E13B0EB2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFVU2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFVU2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 16:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BDA460E0B;
        Tue, 22 Jun 2021 20:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624393565;
        bh=qpCarUrE6M1bqv8vfKl1s5mpXDSoAtStf6HoT26ljLU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=VwxeTrzroJ/fTsPn+f19sxUCUVp/qw5iiBqCceZP3dmezQMtGqZ90EwayW1muKT7g
         F9wL/Yb0RBeUD/xfvs+IoCICUBHbbHQpk6ZJoI8fE8dRGBib5i95L9T1ahXPyQxrye
         eUh3GqwffVG6/Qkj2zE3A/ShT6OfoHtbfajpFW5Fc+Wf1WEh7DeM+z5gGVTgGUl1JK
         LP6COWKfbqaiVbxiad7mNFjekCB/bQmvg+W9D0bZ6/tY0Cie2kpbbHonZvppePpZM4
         P0OHqScSMjNsPmnsstv4aEYIAsFX/GJPvXLR9/e1+TZwWhGqPRPVtF4ZK93L/CeniX
         inX5lfpBsUzLg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D7B9C5C0166; Tue, 22 Jun 2021 13:26:04 -0700 (PDT)
Date:   Tue, 22 Jun 2021 13:26:04 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210622202604.GH4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk>
 <87r1guovg2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1guovg2.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:55:25PM +0200, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> 
> >> It would also be great if this scenario in general could be placed
> >> under the Documentation/RCU/whatisRCU.rst as an example, so we could
> >> refer to the official doc on this, too, if Paul is good with this.
> >
> > I'll take a look and see if I can find a way to fit it in there...
> 
> OK, I poked around in Documentation/RCU and decided that the most
> natural place to put this was in checklist.rst which already talks about
> local_bh_disable(), but a bit differently. Fixing that up to correspond
> to what we've been discussing in this thread, and adding a mention of
> XDP as a usage example, results in the patch below.
> 
> Paul, WDYT?

I think that my original paragraph needed to have been updated back
when v4.20 came out.  And again when RCU Tasks Trace came out.  ;-)

So I did that updating, then approximated your patch on top of it,
as shown below.  Does this work for you?

							Thanx, Paul

------------------------------------------------------------------------

commit c6ef58907d22f4f327f1e9a637b50a5899aac450
Author: Toke Høiland-Jørgensen <toke@redhat.com>
Date:   Tue Jun 22 11:54:34 2021 -0700

    doc: Give XDP as example of non-obvious RCU reader/updater pairing
    
    This commit gives an example of non-obvious RCU reader/updater pairing
    in the guise of the XDP feature in networking, which calls BPF programs
    from network-driver NAPI (softirq) context.
    
    Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/RCU/checklist.rst b/Documentation/RCU/checklist.rst
index 4df78f8bd700..f4545b7c9a63 100644
--- a/Documentation/RCU/checklist.rst
+++ b/Documentation/RCU/checklist.rst
@@ -236,8 +236,15 @@ over a rather long period of time, but improvements are always welcome!
 
 	Mixing things up will result in confusion and broken kernels, and
 	has even resulted in an exploitable security issue.  Therefore,
-	when using non-obvious pairs of primitives, commenting is of
-	course a must.
+	when using non-obvious pairs of primitives, commenting is
+	of course a must.  One example of non-obvious pairing is
+	the XDP feature in networking, which calls BPF programs from
+	network-driver NAPI (softirq) context.	BPF relies heavily on RCU
+	protection for its data structures, but because the BPF program
+	invocation happens entirely within a single local_bh_disable()
+	section in a NAPI poll cycle, this usage is safe.  The reason
+	that this usage is safe is that readers can use anything that
+	disables BH when updaters use call_rcu() or synchronize_rcu().
 
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
 	usually results in simpler code.  So, unless update performance is
