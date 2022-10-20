Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9740B606244
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJTNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJTNyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:54:16 -0400
X-Greylist: delayed 556 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 06:54:12 PDT
Received: from rs07.intra2net.com (rs07.intra2net.com [85.214.138.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657FF5B703
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:54:12 -0700 (PDT)
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id F0941150021E;
        Thu, 20 Oct 2022 15:44:54 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id D0ACF737;
        Thu, 20 Oct 2022 15:44:54 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.212,VDF=8.19.26.100)
X-Spam-Status: 
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id CEF8572B;
        Thu, 20 Oct 2022 15:44:53 +0200 (CEST)
Date:   Thu, 20 Oct 2022 15:44:53 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH RFC ipsec] xfrm: fix panic in xfrm_delete from userspace
 on ARM 32
Message-ID: <20221020134453.3pacvts4gfbxcygo@intra2net.com>
References: <00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com>
 <Yn1J20HaaXeOjhLk@unreal>
 <20221020131602.5gzed3e6jrfbaeps@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020131602.5gzed3e6jrfbaeps@intra2net.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You wrote on Thu, Oct 20, 2022 at 03:16:02PM +0200:
> > We all know that it can't be a fix. It is hard to judge by this
> > calltrace, but it looks like something in x->km is not set. It is
> > probably ".all" field.

small update: I'm not sure if I can trust the output of my disassembly,
but I just recompiled the kernel rpm under test with CONFIG_DEBUG_INFO
and when I do this with the address from the backtrace:

(gdb) list *__xfrm_state_delete+0xc9

0x2269 is in __xfrm_state_delete (./include/linux/list.h:856).
851     static inline void __hlist_del(struct hlist_node *n)
852     {
853             struct hlist_node *next = n->next;
854             struct hlist_node **pprev = n->pprev;
855
856             WRITE_ONCE(*pprev, next);
857             if (next)
858                     WRITE_ONCE(next->pprev, pprev);
859     }
860

which seems to match the suspected "list_del(&x->km.all)"
call from the code in 5.15.73:

*******************************
int __xfrm_state_delete(struct xfrm_state *x)
{
        struct net *net = xs_net(x);
        int err = -ESRCH;

        if (x->km.state != XFRM_STATE_DEAD) {
                x->km.state = XFRM_STATE_DEAD;
                spin_lock(&net->xfrm.xfrm_state_lock);
                list_del(&x->km.all);
                hlist_del_rcu(&x->bydst);
                hlist_del_rcu(&x->bysrc);
                if (x->km.seq)
                        hlist_del_rcu(&x->byseq);
                if (x->id.spi)
                        hlist_del_rcu(&x->byspi);
                net->xfrm.state_num--;
                spin_unlock(&net->xfrm.xfrm_state_lock);

                if (x->encap_sk)
                        sock_put(rcu_dereference_raw(x->encap_sk));

                xfrm_dev_state_delete(x);

                /* All xfrm_state objects are created by xfrm_state_alloc.
                 * The xfrm_state_alloc call gives a reference, and that
                 * is what we are dropping here.
                 */
                xfrm_state_put(x);
                err = 0;
        }

        return err;
}
*******************************

I'll still wait for another crash to appear using
a CONFIG_DEBUG_INFO enabled kernel to be sure.

HTH,
Thomas
