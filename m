Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDAD46F914
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhLJC12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:27:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbhLJC11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:27:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51EDCB82644;
        Fri, 10 Dec 2021 02:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A3CC004DD;
        Fri, 10 Dec 2021 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639103030;
        bh=sDvHbMkdEtVxoJxzEdCAcqFbVX6sMbRNns13Pf7NKvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nzfYAcuT4yEEmborXhhfKAul2zMtptaLcsGMcspeh/QAd7192R/Y+gOpaEyMItYKj
         Lhpu7pPupRUgweHOXgciUCWcMg8fu44rX9wWoXlVnv26jBxCeC5L81r9q2YSKVYyhM
         IN6Dg6zgF5FZjj64OM6cVpGKSl5JSADEcbDwqEKmk0cX3wxAIuY/2k08+jZiwdSK6i
         tg3QwAy3Z8wL78kHRKbTmdZjSpXo4oPFfiZwHxwG3B+fS3V2eYtnIpiJXtxZF7gTuW
         GlaRcvF1mvIfkkSFkO1gRItxq0mS9phb8JzDthO+HTjlkw12owctJk6utZm09Ql4Gt
         oDPFxU9Dr4qVw==
Date:   Thu, 9 Dec 2021 18:23:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ido Schimmel <idosch@idosch.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not
 possible
Message-ID: <20211209182349.038ac2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b294e66b-0bac-008b-52b4-6f1a90215baa@iogearbox.net>
References: <20211209134038.41388-1-cascardo@canonical.com>
        <61b2536e5161d_6bfb2089@john.notmuch>
        <YbJZoK+qBEiLAxxM@shredder>
        <b294e66b-0bac-008b-52b4-6f1a90215baa@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 00:03:40 +0100 Daniel Borkmann wrote:
> > Similar issue was discussed in the past. See:
> > https://lore.kernel.org/netdev/20191204.125135.750458923752225025.davem@davemloft.net/  
> 
> With regards to ENOTSUPP exposure, if the consensus is that we should fix all
> occurences over to EOPNOTSUPP even if they've been exposed for quite some time
> (Jakub?), 

Did you mean me? :) In case you did - I think we should avoid it 
for new code but changing existing now seems risky. Alexei and Andrii
would know best but quick search of code bases at work reveals some
scripts looking for ENOTSUPP.

Thadeu, what motivated the change?

If we're getting those changes fixes based on checkpatch output maybe 
there is a way to mute the checkpatch warnings when it's not run on a 
diff?

> we could give this patch a try maybe via bpf-next and see if anyone complains.
> 
> Thadeu, I think you also need to fix up BPF selftests as test_verifier, to mention
> one example (there are also bunch of others under tools/testing/selftests/), is
> checking for ENOTSUPP specifically..
