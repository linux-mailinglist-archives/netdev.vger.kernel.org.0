Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193F05ED84C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiI1I5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiI1I5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:57:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D526B1DF1A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:57:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1odSsO-0002qo-JP; Wed, 28 Sep 2022 10:57:08 +0200
Date:   Wed, 28 Sep 2022 10:57:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <20220928085708.GI12777@breakpoint.cc>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFp4H/rbdov7iDg@dhcp22.suse.cz>
 <20220926151939.GG12777@breakpoint.cc>
 <D304A05C-D535-43D0-AC70-D5943CE66D89@gmail.com>
 <43A13D50-9CD8-41A5-A355-B361DE277D93@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43A13D50-9CD8-41A5-A355-B361DE277D93@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> And one more from last min
> this is with kernel 5.19.11

This is unrelated to the rhashtable/mm thing, so I am trimming CCs.

> Sep 27 17:44:57 [ 1771.332920][    C8] RIP: 0010:queued_spin_lock_slowpath+0x41/0x1a0
> Sep 27 17:44:57 [ 1771.356563][    C8] Code: 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 3d ff 00 00 00 0f 87 f5 00 00 00 85 c0 74 0f 8b 02 84 c0 74 09 0f ae e8 8b 02 <84> c0 75 f7 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00 81 fe
> Sep 27 17:44:57 [ 1771.405388][    C8] RSP: 0000:ffffa03dc3e3faf8 EFLAGS: 00000202
> Sep 27 17:44:57 [ 1771.429444][    C8] RAX: 0000000000000101 RBX: ffff9d530e975a48 RCX: 0000000000000000
> Sep 27 17:44:57 [ 1771.454289][    C8] RDX: ffff9d5380235d04 RSI: 0000000000000001 RDI: ffff9d5380235d04
> Sep 27 17:44:57 [ 1771.479285][    C8] RBP: ffff9d5380235d04 R08: 0000000000000056 R09: 0000000000000030
> Sep 27 17:44:57 [ 1771.504541][    C8] R10: c3acfae79ca90a0d R11: ffffa03dc3e30a0d R12: 0000000064a1ac01
> Sep 27 17:44:57 [ 1771.529954][    C8] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000001
> Sep 27 17:44:57 [ 1771.555591][    C8]  nf_ct_seqadj_set+0x55/0xd0 [nf_conntrack]
> Sep 27 17:44:57 [ 1771.581511][    C8]  __nf_nat_mangle_tcp_packet+0x102/0x160 [nf_nat]
> Sep 27 17:44:57 [ 1771.607825][    C8]  nf_nat_ftp+0x175/0x267 [nf_nat_ftp]
> Sep 27 17:44:57 [ 1771.634121][    C8]  ? fib_validate_source+0x37/0xd0
> Sep 27 17:44:57 [ 1771.660376][    C8]  ? help+0x4d5/0x6a0 [nf_conntrack_ftp]
> Sep 27 17:44:57 [ 1771.686819][    C8]  help+0x4d5/0x6a0 [nf_conntrack_ftp]

Either need to wait for next 5.19.y release or apply the patch manually:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.19/netfilter-nf_ct_ftp-fix-deadlock-when-nat-rewrite-is.patch

or remove nf_nat ftp module for the time being.
