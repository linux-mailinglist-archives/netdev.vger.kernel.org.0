Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8972F5938B5
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 21:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbiHOS5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiHOSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123CB60F6;
        Mon, 15 Aug 2022 11:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A407761024;
        Mon, 15 Aug 2022 18:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7D1C433D7;
        Mon, 15 Aug 2022 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660588224;
        bh=kvxPs2uAlf3oehVQeRXkeCBLBgQus6xf7LuuT3QozyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BNEBFPOIWsn58eYsBdCMcN0UYHXF3n9C59gmYjiSJyTgQWGAiaJVehUORHR1aXWwW
         Lc5UjZ7+M2ks4EIQKDrFSrR8AdNpO/kT78Db/XIW5Ost4pUK8OKt0YBMW+FiAEjK9f
         8baMVFf8t8Z94wjgWuaP2BGYbBHY4JD2EnNxBdbryUvnYPgsB7pHL7oUC6F5OJ0Kez
         IC1ENd8n5AhM7KWySQv5eAD8UI0qiAsbj16pLXh8CkjuDUecQrpzTo94zn4VJB6yvE
         UkTWScJOxohdgXTxbWXEFDM74o1cQkpcT4CrBl4ET4QKxJfy2INtWhPXdwMazsmouz
         TcrZowa7cgArw==
Date:   Mon, 15 Aug 2022 11:30:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+24bcff6e82ce253f23ec@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        Hawkins Jiawei <yin31149@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in
 bpf_sk_reuseport_detach
Message-ID: <20220815113022.47f28352@kernel.org>
In-Reply-To: <7119881e-5a7a-fd90-8d2f-87ce9cd45831@iogearbox.net>
References: <0000000000007902fc05e6458697@google.com>
        <7119881e-5a7a-fd90-8d2f-87ce9cd45831@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 14:28:58 +0200 Daniel Borkmann wrote:
> [ +Hawkins ]
> 
> On 8/15/22 12:59 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    94ce3b64c62d net/tls: Use RCU API to access tls_ctx->netdev
> > git tree:       net
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=14641e15080000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=53da55f2bdeb0d4c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=24bcff6e82ce253f23ec
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106c89fd080000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ead885080000
> > 
> > The issue was bisected to:
> > 
> > commit f72c38fad234759fe943cb2e40bf3d0f7de1d4d9
> > Author: Edward Cree <ecree.xilinx@gmail.com>
> > Date:   Wed Jul 20 18:33:48 2022 +0000
> > 
> >      sfc: hook up ef100 representor TX  
> 
> Looks rather related to:
> 
> commit 2a0133723f9ebeb751cfce19f74ec07e108bef1f
> Author: Hawkins Jiawei <yin31149@gmail.com>
> Date:   Fri Aug 5 15:48:34 2022 +0800
> 
>      net: fix refcount bug in sk_psock_get (2)

Indeed, looks like the reuseport clearing needs to be some
approximation of rcu_dereference_protected().
