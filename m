Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E36232721
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgG2VqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:46:12 -0400
Received: from correo.us.es ([193.147.175.20]:38246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2VqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:46:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 248E0FB374
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 23:46:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1800DDA78F
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 23:46:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D170DA72F; Wed, 29 Jul 2020 23:46:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAD81DA73D;
        Wed, 29 Jul 2020 23:46:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jul 2020 23:46:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 941A74265A2F;
        Wed, 29 Jul 2020 23:46:07 +0200 (CEST)
Date:   Wed, 29 Jul 2020 23:46:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Will McVicker <willmcvicker@google.com>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] netfilter: nat: add range checks for access to
 nf_nat_l[34]protos[]
Message-ID: <20200729214607.GA30831@salvia>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727175720.4022402-2-willmcvicker@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On Mon, Jul 27, 2020 at 05:57:20PM +0000, Will McVicker wrote:
> The indexes to the nf_nat_l[34]protos arrays come from userspace. So we
> need to make sure that before indexing the arrays, we verify the index
> is within the array bounds in order to prevent an OOB memory access.
> Here is an example kernel panic on 4.14.180 when userspace passes in an
> index greater than NFPROTO_NUMPROTO.
> 
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:...
> Process poc (pid: 5614, stack limit = 0x00000000a3933121)
> CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
> Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
> task: 000000002a3dfffe task.stack: 00000000a3933121
> pc : __cfi_check_fail+0x1c/0x24
> lr : __cfi_check_fail+0x1c/0x24
> ...
> Call trace:
> __cfi_check_fail+0x1c/0x24
> name_to_dev_t+0x0/0x468
> nfnetlink_parse_nat_setup+0x234/0x258

If this oops is only triggerable from userspace, I think a sanity
check in nfnetlink_parse_nat_setup should suffice to reject
unsupported layer 3 and layer 4 protocols.

I mean, in this patch I see more chunks in the packet path, such as
nf_nat_l3proto_ipv4 that should never happen. I would just fix the
userspace ctnetlink path.

BTW, do you have a Fixes: tag for this? This will be useful for
-stable maintainer to pick up this fix.

Thanks.
