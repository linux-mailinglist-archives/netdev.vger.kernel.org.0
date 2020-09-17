Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFF526E533
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIQTNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIQTMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 15:12:25 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C9820672;
        Thu, 17 Sep 2020 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600369895;
        bh=ajBZWptjR+4/DgvjPNb+OHJkTGyVuVOG0g+Y9AOLi4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J3ikwQQviPGUGhvMSmUxT+I/vZ6dfN5u1UGs4mXkdxms8Sea6tDyTL+diYfE/eSW3
         5EHHqI6cb5jTx4hSMJJPYq1l+GMmILq1XDs9pivEkoaV+w5lyOX+MTMEQqjbNELusH
         0bqq4SsTglEFNDhv9nKUKeMOcme49GdAzZbiyjjI=
Message-ID: <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Date:   Thu, 17 Sep 2020 12:11:33 -0700
In-Reply-To: <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
References: <20200917143846.37ce43a0@carbon>
         <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 05:54 -0700, Maciej Żenczykowski wrote:
> On Thu, Sep 17, 2020 at 5:39 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> > 
> > As you likely know[1] I'm looking into moving the MTU check (for
> > TC-BPF)
> > in __bpf_skb_max_len() when e.g. called by bpf_skb_adjust_room(),
> > because when redirecting packets to another netdev it is not
> > correct to
> > limit the MTU based on the incoming netdev.
> > 
> > I was looking at doing the MTU check in bpf_redirect() helper,
> > because
> > at this point we know the redirect to netdev, and returning an
> > indication/error that MTU was exceed, would allow the BPF-prog
> > logic to
> > react, e.g. sending ICMP (instead of packet getting silently
> > dropped).
> > BUT this is not possible because bpf_redirect(index, flags) helper
> > don't provide the packet context-object (so I cannot lookup the
> > packet
> > length).
> > 
> > Seeking input:
> > 
> > Should/can we change the bpf_redirect API or create a new helper
> > with
> > packet-context?
> > 
> >  Note: We have the same need for the packet context for XDP when
> >  redirecting the new multi-buffer packets, as not all destination
> > netdev
> >  will support these new multi-buffer packets.
> > 
> > I can of-cause do the MTU checks on kernel-side in skb_do_redirect,
> > but
> > then how do people debug this? as packet will basically be silently
> > dropped.
> > 
> > 
> > 
> > (Looking at how does BPF-prog logic handle MTU today)
> > 
> > How do bpf_skb_adjust_room() report that the MTU was exceeded?
> > Unfortunately it uses a common return code -ENOTSUPP which used for
> > multiple cases (include MTU exceeded). Thus, the BPF-prog logic
> > cannot
> > use this reliably to know if this is a MTU exceeded event. (Looked
> > BPF-prog code and they all simply exit with TC_ACT_SHOT for all
> > error
> > codes, cloudflare have the most advanced handling with
> > metrics->errors_total_encap_adjust_failed++).
> > 
> > 
> > [1] 
> > https://lore.kernel.org/bpf/159921182827.1260200.9699352760916903781.stgit@firesoul/
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 
> 
> (a) the current state of the world seems very hard to use correctly,
> so adding new apis,
> or even changing existing ones seems ok to me.
> especially if this just means changing what error code they return
> 
> (b) another complexity with bpf_redirect() is you can call it, it can
> succeed,
> but then you can not return TC_ACT_REDIRECT from the bpf program,
> which effectively makes the earlier *successful* bpf_redirect() call
> an utter no-op.
> 
> (bpf_redirect() just determines what a future return TC_ACT_REDIRECT
> will do)
> 
> so if you bpf_redirect to interface with larger mtu, then increase
> packet size,

why would you redirect then touch the packet afterwards ? 
if you have a bad program, then it is a user issue.

> then return TC_ACT_OK, then you potentially end up with excessively
> large
> packet egressing through original interface (with small mtu).
> 
> My vote would be to return a new distinct error from bpf_redirect()
> based on then current
> packet size and interface being redirected to, save this interface
> mtu
> somewhere,
> then in operations that increase packet size check against this saved
> mtu,
> for correctness you still have to check mtu after the bpf program is
> done,
> but this is then just to deal with braindead bpf code (that calls
> bpf_redirect and returns TC_ACT_OK, or calls bpf_redirect() multiple
> times, or something...).
> 


Another solution is to have an exception function defined in the
BPF_prog, this function by itself is another program that can be
executed to notify the prog about any exception/err that happened after
the main BPF_program exited and let the XDP program react by its own
logic.

example:

BPF_prog:
    int XDP_main_prog(xdp_buff) {
        xdp_adjust_head/tail(xdp_buff);
        return xdp_redirect(ifindex, flags);
    }

    int XDP_exception(xdp_buff, excption_code) {
        if (excetption_code == XDP_REDIRECRT_MTU_EXCEEDED) {
                ICMP_response(xdp_buff);
                return XDP_TX;
        }
        return XDP_DROP;
    }


netdev_driver_xdp_handle():
   act = bpf_prog_run_xdp(prog, xdp); // Run XDP_main_prog
   if (act == XDP_REDIRECT)
       err = xdp_do_redirect(netdev, xdp, prog);
       if (err) { 
          // Run XDP_exception() function in the user prog
          // finds the exception handler of active program
          act = bpf_prog_run_xdp_exciption(prog, xdp, err);
          // then handle exception action in the driver
(XDP_TX/DROP/FORWARD).. 
       }

of-course a user program will be notified only on the first err .. 
if it fails on the 2nd time .. just drop..

-Saeed.

