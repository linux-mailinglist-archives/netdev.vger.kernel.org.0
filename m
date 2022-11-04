Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264EE618F8A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiKDEo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKDEoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:44:24 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D893275F6
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 21:44:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oqoY1-009y34-F7; Fri, 04 Nov 2022 12:43:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Nov 2022 12:43:53 +0800
Date:   Fri, 4 Nov 2022 12:43:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Leon Romanovsky <leon@kernel.org>, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <Y2SYiVHXyKR48MZ8@gondor.apana.org.au>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
 <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
 <Y2FvHZiWejxRiIS8@moon.secunet.de>
 <Y2IXTc1M6K7KaQwW@gondor.apana.org.au>
 <20221102083159.2rqu6j27weg2cxtq@intra2net.com>
 <20221102101848.ibvumaxg2jdvk52y@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102101848.ibvumaxg2jdvk52y@intra2net.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 11:18:48AM +0100, Thomas Jarosch wrote:
> Kernel 5.14 added a new "byseq" index to speed
> up xfrm_state lookups by sequence number in commit
> fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
> 
> While the patch was thorough, the function pfkey_send_new_mapping()
> in net/af_key.c also modifies x->km.seq and never added
> the current xfrm_state to the "byseq" index.
> 
> This leads to the following kernel Ooops:
>     BUG: kernel NULL pointer dereference, address: 0000000000000000
>     ..
>     RIP: 0010:__xfrm_state_delete+0xc9/0x1c0
>     ..
>     Call Trace:
>     <TASK>
>     xfrm_state_delete+0x1e/0x40
>     xfrm_del_sa+0xb0/0x110 [xfrm_user]
>     xfrm_user_rcv_msg+0x12d/0x270 [xfrm_user]
>     ? remove_entity_load_avg+0x8a/0xa0
>     ? copy_to_user_state_extra+0x580/0x580 [xfrm_user]
>     netlink_rcv_skb+0x51/0x100
>     xfrm_netlink_rcv+0x30/0x50 [xfrm_user]
>     netlink_unicast+0x1a6/0x270
>     netlink_sendmsg+0x22a/0x480
>     __sys_sendto+0x1a6/0x1c0
>     ? __audit_syscall_entry+0xd8/0x130
>     ? __audit_syscall_exit+0x249/0x2b0
>     __x64_sys_sendto+0x23/0x30
>     do_syscall_64+0x3a/0x90
>     entry_SYSCALL_64_after_hwframe+0x61/0xcb
> 
> Exact location of the crash in __xfrm_state_delete():
>     if (x->km.seq)
>         hlist_del_rcu(&x->byseq);
> 
> The hlist_node "byseq" was never populated.
> 
> The bug only triggers if a new NAT traversal mapping (changed IP or port)
> is detected in esp_input_done2() / esp6_input_done2(), which in turn
> indirectly calls pfkey_send_new_mapping() *if* the kernel is compiled
> with CONFIG_NET_KEY and "af_key" is active.
> 
> The PF_KEYv2 message SADB_X_NAT_T_NEW_MAPPING is not part of RFC 2367.
> Various implementations have been examined how they handle
> the "sadb_msg_seq" header field:
> 
> - racoon (Android): does not process SADB_X_NAT_T_NEW_MAPPING
> - strongswan: does not care about sadb_msg_seq
> - openswan: does not care about sadb_msg_seq
> 
> There is no standard how PF_KEYv2 sadb_msg_seq should be populated
> for SADB_X_NAT_T_NEW_MAPPING and it's not used in popular
> implementations either. Herbert Xu suggested we should just
> use the current km.seq value as is. This fixes the root cause
> of the oops since we no longer modify km.seq itself.
> 
> The update of "km.seq" looks like a copy'n'paste error
> from pfkey_send_acquire(). SADB_ACQUIRE must indeed assign a unique km.seq
> number according to RFC 2367. It has been verified that code paths
> involving pfkey_send_acquire() don't cause the same Oops.
> 
> PF_KEYv2 SADB_X_NAT_T_NEW_MAPPING support was originally added here:
>     https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> 
>     commit cbc3488685b20e7b2a98ad387a1a816aada569d8
>     Author:     Derek Atkins <derek@ihtfp.com>
>     AuthorDate: Wed Apr 2 13:21:02 2003 -0800
> 
>         [IPSEC]: Implement UDP Encapsulation framework.
> 
>         In particular, implement ESPinUDP encapsulation for IPsec
>         Nat Traversal.
> 
> A note on triggering the bug: I was not able to trigger it using VMs.
> There is one VPN using a high latency link on our production VPN server
> that triggered it like once a day though.
> 
> Link: https://github.com/strongswan/strongswan/issues/992
> Link: https://lore.kernel.org/netdev/00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com/T/
> Link: https://lore.kernel.org/netdev/20221027142455.3975224-1-chenzhihao@meizu.com/T/
> 
> Fixes: fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
> Reported-by: Roth Mark <rothm@mail.com>
> Reported-by: Zhihao Chen <chenzhihao@meizu.com>
> Tested-by: Roth Mark <rothm@mail.com>
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  net/key/af_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
