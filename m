Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F6470098
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbhLJM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 07:27:47 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55734
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237629AbhLJM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 07:27:47 -0500
Received: from mussarela (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id EB79E40078;
        Fri, 10 Dec 2021 12:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639139050;
        bh=oAEuyXSS+FfBE7IbC9Qm9bPmNR/CHY86PuhFfkuo8Ak=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=lHxFDgr55MI0m1wV2nQ4dpY/zmLA1P/LAcOtm6Mm55I4KYV7zYc+IzULPjY+vDZAC
         6VYrll6fjoQ7hrkYBw+BQHESJLZqulswRcCTZX99WYpybGrLW7UTGcbDT1HmvCxQp+
         l4OhYNBmupNm6DiR+bwXRkMa8RRJL/xTrc+6bAJMqsCIe1+dPyO9QU7MxP46vDvrbo
         AT4z24d0Lmx6VK+KdG1qUaJx7V1LgQLPRmqTwFdqIBgf6xQg1IOG2yqyvr8CLk1B/q
         MjsjuRm5Yc/cmgj1nYKqEprPIZKvnNIu9szc0lADAvIGbUGfRchb4YSkdI/SHYNwtH
         yT3+6IO5qVbtA==
Date:   Fri, 10 Dec 2021 09:24:04 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@idosch.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not
 possible
Message-ID: <YbNG5BliqnCyhs4J@mussarela>
References: <20211209134038.41388-1-cascardo@canonical.com>
 <61b2536e5161d_6bfb2089@john.notmuch>
 <YbJZoK+qBEiLAxxM@shredder>
 <b294e66b-0bac-008b-52b4-6f1a90215baa@iogearbox.net>
 <20211209182349.038ac2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209182349.038ac2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:23:49PM -0800, Jakub Kicinski wrote:
> On Fri, 10 Dec 2021 00:03:40 +0100 Daniel Borkmann wrote:
> > > Similar issue was discussed in the past. See:
> > > https://lore.kernel.org/netdev/20191204.125135.750458923752225025.davem@davemloft.net/  
> > 
> > With regards to ENOTSUPP exposure, if the consensus is that we should fix all
> > occurences over to EOPNOTSUPP even if they've been exposed for quite some time
> > (Jakub?), 
> 
> Did you mean me? :) In case you did - I think we should avoid it 
> for new code but changing existing now seems risky. Alexei and Andrii
> would know best but quick search of code bases at work reveals some
> scripts looking for ENOTSUPP.
> 
> Thadeu, what motivated the change?
> 
> If we're getting those changes fixes based on checkpatch output maybe 
> there is a way to mute the checkpatch warnings when it's not run on a 
> diff?
> 

It was not checkpatch that motivated me.

I was looking into the following commits as we hit a failed test.

be08815c5d3b ("bpf: add also cbpf long jump test cases with heavy expansion")
050fad7c4534 ("bpf: fix truncated jump targets on heavy expansions") 

Then, I realized that if given the right number of BPF_LDX | BPF_B | BPF_MSH
instructions, it will pass the bpf_convert_filter stage, but fail at blinding.
And if you have CONFIG_BPF_JIT_ALWAYS_ON, setting the filter will fail with
ENOTSUPP, which should not be sent to userspace.

I noticed other ENOTSUPP, but they seemed to be returned by helpers, and I was
not sure this would be relayed to userspace. So, I went for fixing the observed
case.

I will see if any of the tests I can run is broken by this change and submit it
again with the tests fixed as well.

Cascardo.

> > we could give this patch a try maybe via bpf-next and see if anyone complains.
> > 
> > Thadeu, I think you also need to fix up BPF selftests as test_verifier, to mention
> > one example (there are also bunch of others under tools/testing/selftests/), is
> > checking for ENOTSUPP specifically..
