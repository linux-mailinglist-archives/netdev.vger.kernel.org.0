Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7C46C8C3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhLHAkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:40:19 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:42168 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhLHAkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 19:40:19 -0500
X-Greylist: delayed 896 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2021 19:40:18 EST
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 1B80L87R014116;
        Wed, 8 Dec 2021 01:21:13 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id DD79F1205A3;
        Wed,  8 Dec 2021 01:21:02 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1638922863; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0tM8YuAY1Y+Gc66Lb7MSiM1E3PZgPHg8g/zgD4BiQhs=;
        b=+20Ovl9mIjMX96pDcKk262Mf72ADdVL7ga6yN7G0PVC5+5YuJFj4ndRLpb+FHbTdcYGen0
        UBHOpjOljiBWoSBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1638922863; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0tM8YuAY1Y+Gc66Lb7MSiM1E3PZgPHg8g/zgD4BiQhs=;
        b=BA1UMO6+loIrca+OccCfKcUbU4Jrx4Oy9cChj5BQinWvpOJ87DqDRX0QLBPpg8hGAbzvLx
        BdmJqIUTfLM01CTXE/DMBlPpkaMAwN/sG613i+oL7aCIA+dz/yutSzWSb2iQrFMax5Ctps
        BivpYY3jBri/qTXVQREDN5ghXBsiLxNFeCFol2OfHj0wgn+Kt7WFm3Oy05xezA5FIC/Bed
        7afd0sefikRYd4hZcpxBA1KaznZ2bgicQKVse7H1y8SHR1LTAtpFsYSPeJnI0ilWQA2e70
        OoHVLk8wBPg9RDbJ66FhYTK5zokaHubzS+UC5atz++fVj+q0akkrW7EffT3PzQ==
Date:   Wed, 8 Dec 2021 01:21:02 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Message-Id: <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
In-Reply-To: <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
        <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
Thank you for reporting it and thanks also to Andrea Righi for catching that
issue.

Please see my answer below.

On Tue, 7 Dec 2021 08:51:13 -0700
David Ahern <dsahern@gmail.com> wrote:

> [ cc a few SR6 folks ]
> 
> On 12/6/21 9:34 AM, Andrea Righi wrote:
> > It is possible to trigger a NULL pointer dereference by running the srv6
> > net kselftest (tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh):
> > 
> > [  249.051216] BUG: kernel NULL pointer dereference, address: 0000000000000378
> > [  249.052331] #PF: supervisor read access in kernel mode
> > [  249.053137] #PF: error_code(0x0000) - not-present page
> > [  249.053960] PGD 0 P4D 0
> > [  249.054376] Oops: 0000 [#1] PREEMPT SMP NOPTI
> > [  249.055083] CPU: 1 PID: 21 Comm: ksoftirqd/1 Tainted: G            E     5.16.0-rc4 #2
> > [  249.056328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
> > [  249.057632] RIP: 0010:ip6_forward+0x53c/0xab0
> > [  249.058354] Code: 49 c7 44 24 20 00 00 00 00 48 83 e0 fe 48 8b 40 30 48 3d 70 b2 b5 81 0f 85 b5 04 00 00 e8 7c f2 ff ff 41 89 c5 e9 17 01 00 00 <44> 8b 93 78 03 00 00 45 85 d2 0f 85 92 fb ff ff 49 8b 54 24 10 48
> > [  249.061274] RSP: 0018:ffffc900000cbb30 EFLAGS: 00010246
> > [  249.062042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881051d3400
> > [  249.063141] RDX: ffff888104bda000 RSI: 00000000000002c0 RDI: 0000000000000000
> > [  249.064264] RBP: ffffc900000cbbc8 R08: 0000000000000000 R09: 0000000000000000
> > [  249.065376] R10: 0000000000000040 R11: 0000000000000000 R12: ffff888103409800
> > [  249.066498] R13: ffff8881051d3410 R14: ffff888102725280 R15: ffff888103525000
> > [  249.067619] FS:  0000000000000000(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
> > [  249.068881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  249.069777] CR2: 0000000000000378 CR3: 0000000104980000 CR4: 0000000000750ee0
> > [  249.070907] PKRU: 55555554
> > [  249.071337] Call Trace:
> > [  249.071730]  <TASK>
> > [  249.072070]  ? debug_smp_processor_id+0x17/0x20
> > [  249.072807]  seg6_input_core+0x2bb/0x2d0
> > [  249.073436]  ? _raw_spin_unlock_irqrestore+0x29/0x40
> > [  249.074225]  seg6_input+0x3b/0x130
> > [  249.074768]  lwtunnel_input+0x5e/0xa0
> > [  249.075357]  ip_rcv+0x17b/0x190
> > [  249.075867]  ? update_load_avg+0x82/0x600
> > [  249.076514]  __netif_receive_skb_one_core+0x86/0xa0
> > [  249.077231]  __netif_receive_skb+0x15/0x60
> > [  249.077843]  process_backlog+0x97/0x160
> > [  249.078389]  __napi_poll+0x31/0x170
> > [  249.078912]  net_rx_action+0x229/0x270
> > [  249.079506]  __do_softirq+0xef/0x2ed
> > [  249.080085]  run_ksoftirqd+0x37/0x50
> > [  249.080663]  smpboot_thread_fn+0x193/0x230
> > [  249.081312]  kthread+0x17a/0x1a0
> > [  249.081847]  ? smpboot_register_percpu_thread+0xe0/0xe0
> > [  249.082677]  ? set_kthread_struct+0x50/0x50
> > [  249.083340]  ret_from_fork+0x22/0x30
> > [  249.083926]  </TASK>
> > [  249.090295] ---[ end trace 1998d7ba5965a365 ]---
> > 
> > It looks like commit 0857d6f8c759 ("ipv6: When forwarding count rx stats
> > on the orig netdev") tries to determine the right netdev to account the
> > rx stats, but in this particular case it's failing and the netdev is
> > NULL.
> > 
> > Fallback to the previous method of determining the netdev interface (via
> > skb->dev) to account the rx stats when the orig netdev can't be
> > determined.
> > 
> > Fixes: 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev")
> > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> > ---
> >  net/ipv6/ip6_output.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index ff4e83e2a506..7ca4719ff34c 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -472,6 +472,9 @@ int ip6_forward(struct sk_buff *skb)
> >  	u32 mtu;
> >  
> >  	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
> > +	if (unlikely(!idev))
> > +		idev = __in6_dev_get_safely(skb->dev);
> > +
> 
> We need to understand why iif is not set - or set to an invalid value.
> 

When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
interface index into the IPv4 socket control block (v5.16-rc4,
net/ipv4/ip_input.c line 510):
    IPCB(skb)->iif = skb->skb_iif;

If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH header,
the seg6_do_srh_encap(...) performs the required encapsulation. 
In this case, the seg6_do_srh_encap function clears the IPv6 socket control
block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):
    memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));

The memset(...) was introduced in commit ef489749aae5 ("ipv6: sr: clear
IP6CB(skb) on SRH ip4ip6 encapsulation") a long time ago (2019-01-29).

Since the IPv6 socket control block and the IPv4 socket control block share the
same memory area (skb->cb), the receiving interface index info is lost
(IP6CB(skb)->iif is set to zero).

As a side effect, that condition triggers a NULL pointer dereference if patch
0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev") is
applied.

To fix that, I can send a patch where we set the IP6CB(skb)->iif to the
index of the receiving interface, i.e.:

int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
         [...]
         ip6_flow_hdr(hdr, 0, flowlabel);
         hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));

         memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+        IP6CB(skb)->iif = skb->skb_iif;
         [...]

What do you think?

Andrea
