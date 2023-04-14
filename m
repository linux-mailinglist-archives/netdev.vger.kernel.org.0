Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD426E24EF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDNN77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjDNN76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:59:58 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF48DF;
        Fri, 14 Apr 2023 06:59:56 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 97B6F13867;
        Fri, 14 Apr 2023 16:59:53 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 7FDEE13863;
        Fri, 14 Apr 2023 16:59:53 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id F11643C0323;
        Fri, 14 Apr 2023 16:59:47 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 33EDxgWB047230;
        Fri, 14 Apr 2023 16:59:44 +0300
Date:   Fri, 14 Apr 2023 16:59:42 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Abhijeet Rastogi <abhijeet.1989@gmail.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
In-Reply-To: <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
Message-ID: <2bc64d6d-6aa7-1477-0cd-8a41e68fcc5@ssi.bg>
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com> <d2519ce3-e49b-a544-b79d-42905f4a2a9a@ssi.bg> <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 13 Apr 2023, Abhijeet Rastogi wrote:

> Hi Simon, Andrea and Julian,
> 
> I really appreciate you taking the time to respond to my patch. Some follow up
> questions that I'll appreciate a response for.
> 
> @Simon Horman
> >In any case, I think this patch is an improvement on the current situation.
> 
> +1 to this. I wanted to add that, we're not changing the defaults
> here, the default still stays at 2^12. If a kernel user changes the
> default, they probably already know what the limitations are, so I
> personally don't think it is a big concern.
> 
> @Andrea Claudi
> >for the record, RHEL ships with CONFIG_IP_VS_TAB_BITS set to 12 as
> default.
> 
> Sorry, I should have been clearer. RHEL ships with the same default,
> yes, but it doesn't have the range check, at least, on the version I'm
> using right now (3.10.0-1160.62.1.el7.x86_64).
> 
> On this version, I'm able to load with bit size 30, 31 gives me error
> regarding allocating memory (64GB host) and anything beyond 31 is
> mysteriously switched to a lower number. The following dmesg on my
> host confirms that the bitsize 30 worked, which is not possible
> without a patch on the current kernel version.
> 
> "[Fri Apr 14 01:14:51 2023] IPVS: Connection hash table configured (size=1073741
> 824, memory=16777216Kbytes)"
> 
> @Julian Anastasov,
> >This is not a limit of number of connections. I prefer
> not to allow value above 24 without adding checks for the
> available memory,
> 
> Interesting that you brought up that number 24, that is exactly what
> we use in production today. One IPVS node is able to handle spikes of
> 10M active connections without issues. This patch idea originated as
> my company is migrating from the ancient RHEL version to a somewhat
> newer CentOS (5.* kernel) and noticed that we were unable to load the
> ip_vs kernel module with anything greater than 20 bits. Another
> motivation for kernel upgrade is utilizing maglev to reduce table size
> but that's out of context in this discussion.
> 
> My request is, can we increase the range from 20 to something larger?
> If 31 seems a bit excessive, maybe, we can settle for something like
> [8,30] or even lower. With conn_tab_bits=30, it allocates 16GB at
> initialization time, it is not entirely absurd by today's standards.
> 
> I can revise my patch to a lower range as you guys see fit.

	Some 32-bit platforms have a 120MB limit for
vmalloc. 24-bit table on 32-bit box will allocate 64MB.

	One way to solve the problem is to use in Kconfig:

range 8 20 if !64BIT
range 8 27 if 64BIT

	Why 30 and above do not work? Because we store the
size, mask in 'int' which is 32 bits. But also some places do not
allow allocations above INT_MAX, for example, kvmalloc_node().
So, even 28 may not work for 8-byte array items on 64-bit.

	It would be good to check if the provided
value does not exceed some real limits. Here is an example
that assumes IPVS will allocate up to 1/8 of the memory,
8 conns average in a hash row. Such checks should not
exceed the small vmalloc area for 32-bit boxes and also
kvmalloc allows vmalloc with huge pages. This idea is
entirely untested/compiled. These checks apply some
sane thresholds. If you need something above, you are
probably allocating more than needed.

/* This will match the Kconfig range: */
int min = 8;
#if __BITS_PER_LONG > 32
int max = 27;
#else
int max = 20;
#endif

	We can safely use 27 in Kconfig even for 32-bit
due to the below checks, they will clamp it to lower value.

	/* Order of the available memory */
	int max_avail = order_base_2(totalram_pages()) + PAGE_SHIFT;

	We can remove this 'if' check:
	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
	}

	max_avail -= 3;				/* ~8 in hash row */
	max_avail -= 3;				/* IPVS up to 1/8 of mem */
	/* The hash table links allocated memory for IPVS conns */
	max_avail -= order_base_2(sizeof(struct ip_vs_conn));
	/* Range should not exceed the available memory */
	max = clamp(max, min, max_avail);
	/* Clamp configured value silently */
	ip_vs_conn_tab_bits = clamp_val(ip_vs_conn_tab_bits, min, max);
	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;

	/* Switch to kvmalloc */
	ip_vs_conn_tab = kvmalloc_array(ip_vs_conn_tab_size,
					sizeof(*ip_vs_conn_tab), GFP_KERNEL);

	and use everywhere kvfree(ip_vs_conn_tab);

	For 64GB box the calcs should be:

max_avail = 36 - 3 - 3 - 9 => ip_vs_conn_tab_bits = 21
Allocated hash table: (2^21)*8=16MB
Allocated for IPVS conns (8 cols per row): (2^21)*8*(400..512)=6..8GB
which is ~1/8 of 64GB. All memory will be allocated with
~64 conns per row. May be the above calcs can be changed
to ~4 cols and 1/2 mem to use 128MB (24 bits instead of 21)
for our example: 36 - 2 - 1 - 9 => 24.

	Possible problems if using large table that is
not loaded with enough conns:

- walking the table will cost more cycles, for example,
ip_vs_random_dropentry() wants to walk part of the table
every second. Even normal netns cleanup has to walk it.

- cat /proc/net/ip_vs_conn will be slower

Regards

--
Julian Anastasov <ja@ssi.bg>

