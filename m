Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF60B44F123
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhKMEQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235660AbhKMEQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:16:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C13AA61075;
        Sat, 13 Nov 2021 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636776814;
        bh=7obbUHnhGVo3HIrtdHNO3+k7dyrBbIhwpeSkXsUGAVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W2kCmiqkDLdeRUrC32Lsxw3De5eyxF45xN+qwSr9bzgP53GpHfuhVofZwXAG/FXNg
         XzrBpzey9kUeuc9xRj7I5Jx1CHzCdnapxoxF8D15MJFqJQy0tDo4P+HW6E7fv6LjKX
         tVi8wcDbj9NEpwqafzOK4Ezik7Geo+YijnzglixxCQHXG8LkkLmzFOI4H5AceUMNZp
         HYKI3NxBJQrvG6HWt7ctXFEvT0FhKuBb4vJVCwre/eXGzxiu8J2G5rJcYAI7irx/ds
         JK0j9Cs65/YoCc0IHFJ5+3iCSpQoTq1sIUCA7O3OT0fsu3TGAhieqbKnwM2y6J2U1n
         Qu1LwHbkUz/rg==
Date:   Fri, 12 Nov 2021 20:13:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] tipc: check for null after calling kmemdup
Message-ID: <20211112201332.601b8646@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0f144d68-37c8-1e4a-1516-a3a572f06f8f@redhat.com>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
        <0f144d68-37c8-1e4a-1516-a3a572f06f8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 19:06:18 -0500 Jon Maloy wrote:
> On 11/11/21 15:59, Tadeusz Struk wrote:
> > kmemdup can return a null pointer so need to check for it, otherwise
> > the null key will be dereferenced later in tipc_crypto_key_xmit as
> > can be seen in the trace [1].

> > [1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58
> >
> > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> > ---
> >   net/tipc/crypto.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> > index dc60c32bb70d..988a343f9fd5 100644
> > --- a/net/tipc/crypto.c
> > +++ b/net/tipc/crypto.c
> > @@ -597,6 +597,11 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
> >   	tmp->cloned = NULL;
> >   	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
> >   	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
> > +	if (!tmp->key) {
> > +		free_percpu(tmp->tfm_entry);
> > +		kfree_sensitive(tmp);
> > +		return -ENOMEM;
> > +	}

> Acked-by: Jon Maloy <jmaloy@redhat.com>

Hm, shouldn't we free all the tfm entries here?
