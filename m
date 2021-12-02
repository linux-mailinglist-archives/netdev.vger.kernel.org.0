Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CE465D67
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355335AbhLBEcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344863AbhLBEcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 23:32:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD81C061574;
        Wed,  1 Dec 2021 20:29:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E74B8214E;
        Thu,  2 Dec 2021 04:29:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3531D60E0B;
        Thu,  2 Dec 2021 04:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638419347;
        bh=/Avwtz+hyAMoKucKqNis+tKLK0MEdhOVdr1B0uiyAy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aea2wso8gFOcCnWcSUUXbz2cdA9ahhoAHGkCMgws6l3vbOedtiIRehS9E8VAcUAhZ
         zJQ2WHZLwTKSR6G6dVSEgjv8d6yhjzJc9ZPHU58JYEVulTwO5eK9XY3C6qpHSBmZgP
         ln3T9NVPm+VvUhKlhyvG6A0QWqhU734VXMGTKAME=
Date:   Wed, 1 Dec 2021 20:29:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, leon@kernel.org, w@1wt.eu,
        keescook@chromium.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH -next] mm: delete oversized WARN_ON() in kvmalloc()
 calls
Message-Id: <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
In-Reply-To: <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com>
References: <1638410784-48646-1-git-send-email-cuibixuan@linux.alibaba.com>
        <20211201192643.ecb0586e0d53bf8454c93669@linux-foundation.org>
        <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 12:05:15 +0800 Bixuan Cui <cuibixuan@linux.alibaba.com> wrote:

> 
> 在 2021/12/2 上午11:26, Andrew Morton 写道:
> >> Delete the WARN_ON() and return NULL directly for oversized parameter
> >> in kvmalloc() calls.
> >> Also add unlikely().
> >>
> >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> >> Signed-off-by: Bixuan Cui<cuibixuan@linux.alibaba.com>
> >> ---
> >> There are a lot of oversize warnings and patches about kvmalloc() calls
> >> recently. Maybe these warnings are not very necessary.
> > Or maybe they are.  Please let's take a look at these warnings, one at
> > a time.  If a large number of them are bogus then sure, let's disable
> > the runtime test.  But perhaps it's the case that calling code has
> > genuine issues and should be repaired.
> Such as：

Thanks, that's helpful.

Let's bring all these to the attention of the relevant developers.

If the consensus is "the code's fine, the warning is bogus" then let's
consider retiring the warning.

If the consensus is otherwise then hopefully they will fix their stuff!



> https://syzkaller.appspot.com/bug?id=24452f89446639c901ac07379ccc702808471e8e

(cc bpf@vger.kernel.org)

> https://syzkaller.appspot.com/bug?id=f7c5a86e747f9b7ce333e7295875cd4ede2c7a0d

(cc netdev@vger.kernel.org, maintainers)

> https://syzkaller.appspot.com/bug?id=8f306f3db150657a1f6bbe1927467084531602c7

(cc kvm@vger.kernel.org)

> https://syzkaller.appspot.com/bug?id=6f30adb592d476978777a1125d1f680edfc23e00

(cc netfilter-devel@vger.kernel.org)

> https://syzkaller.appspot.com/bug?id=4c9ab8c7d0f8b551950db06559dc9cde4119ac83

(bpf again).

