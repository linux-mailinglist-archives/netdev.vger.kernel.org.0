Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4B40FE0D
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhIQQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:43:17 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:36454
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhIQQnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 12:43:17 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B22B93F10B;
        Fri, 17 Sep 2021 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631896913;
        bh=S22coCr6Wjd8NapIAlG5oFT9F+VCIs9qkVZ9L++/fzM=;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=uiNbLNuZfKEoZUD5pzc5T6FQV+YxTd9nR0Id/2ISTxmI1kXQbUEG+QnYNMNDpd7mU
         qjIujQVvnDsdvyW4H+/nhYpD+NQF6fGh6yy5lPMmv120tt1nV/GpMNPUMQS1qFLiKC
         vO4ntgBXMmT+BznNvyJhgWQwHCBuClGiQKlt3U6hNIeleNYEkQlACIXXOxvMcde5ny
         zHetd7jhvaF5Chi6SJk7ejshoGZX8fgJuQ9P8k1TKbICgZ2Sb0iDK9SbVEjdrvcLYi
         6D63al46cdv/DIwRppacBpoj1VDsaoIK3+yy/CpEQxcukhBiT9NL9IUUkfceIBMMnZ
         32znQ8ej2UOPw==
To:     Shaohua Li <shli@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: potential null pointer dereference in ip6_xmit
Message-ID: <516b6617-ab5e-4601-55e4-0f9844f9a49e@canonical.com>
Date:   Fri, 17 Sep 2021 17:41:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity detected a potential null pointer
deference in ip6_xmit, net/ipv6/ip6_output.c, I believe it may have been
introduced by the following commit:

commit 513674b5a2c9c7a67501506419da5c3c77ac6f08
Author: Shaohua Li <shli@fb.com>
Date:   Wed Dec 20 12:10:21 2017 -0800

    net: reevalulate autoflowlabel setting after sysctl setting

The analysis is as follows:

239 /*
240  * xmit an sk_buff (used by TCP, SCTP and DCCP)
241  * Note : socket lock is not held for SYNACK packets, but might be
modified
242 * by calls to skb_set_owner_w() and ipv6_local_error(),
243 * which are using proper atomic operations or spinlocks.
244 */
245 int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct
flowi6 *fl6,
246             __u32 mark, struct ipv6_txoptions *opt, int tclass, u32
priority)
247 {
248        struct net *net = sock_net(sk);
249        const struct ipv6_pinfo *np = inet6_sk(sk);
250        struct in6_addr *first_hop = &fl6->daddr;
251        struct dst_entry *dst = skb_dst(skb);
252        struct net_device *dev = dst->dev;
253        struct inet6_dev *idev = ip6_dst_idev(dst);
254        unsigned int head_room;
255        struct ipv6hdr *hdr;
256        u8  proto = fl6->flowi6_proto;
257        int seg_len = skb->len;
258        int hlimit = -1;
259        u32 mtu;
260
261        head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);

   1. Condition opt, taking true branch.

262        if (opt)
263                head_room += opt->opt_nflen + opt->opt_flen;
264

   2. Condition !!(head_room > skb_headroom(skb)), taking true branch.

265        if (unlikely(head_room > skb_headroom(skb))) {
266                skb = skb_expand_head(skb, head_room);

   3. Condition !skb, taking false branch.

267                if (!skb) {
268                        IP6_INC_STATS(net, idev,
IPSTATS_MIB_OUTDISCARDS);
269                        return -ENOBUFS;
270                }
271        }
272

   4. Condition opt, taking true branch.

273        if (opt) {
274                seg_len += opt->opt_nflen + opt->opt_flen;
275

   5. Condition opt->opt_flen, taking true branch.

276                if (opt->opt_flen)
277                        ipv6_push_frag_opts(skb, opt, &proto);
278

   6. Condition opt->opt_nflen, taking true branch.

279                if (opt->opt_nflen)
280                        ipv6_push_nfrag_opts(skb, opt, &proto,
&first_hop,
281                                             &fl6->saddr);
282        }
283
284        skb_push(skb, sizeof(struct ipv6hdr));
285        skb_reset_network_header(skb);
286        hdr = ipv6_hdr(skb);
287
288        /*
289         *      Fill in the IPv6 header
290         */

   7. Condition np, taking false branch.
   8. var_compare_op: Comparing np to null implies that np might be null.

291        if (np)
292                hlimit = np->hop_limit;

   9. Condition hlimit < 0, taking true branch.

293        if (hlimit < 0)
294                hlimit = ip6_dst_hoplimit(dst);
295

   Dereference after null check (FORWARD_NULL)10. var_deref_model:
Passing null pointer np to ip6_autoflowlabel, which dereferences it.

296        ip6_flow_hdr(hdr, tclass, ip6_make_flowlabel(net, skb,
fl6->flowlabel,
297                                ip6_autoflowlabel(net, np), fl6));
298

There is a null check on np on line 291, so potentially np could be null
on the call on line 296 where a null is passed to the function
ip6_autoflowlabel that dereferences the null np.

Colin
