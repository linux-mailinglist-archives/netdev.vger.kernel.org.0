Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A469993B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388254AbfHVQcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:32:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36720 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbfHVQcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:32:32 -0400
Received: by mail-lf1-f65.google.com with SMTP id j17so4992803lfp.3
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujwYz/NxPt4KuZjfQpu/cnFqN0PKCiE0M+fWaEKXyzU=;
        b=pi6XK9pe93bWuyf6pKryFGG43zRe1ZCwwDleYSgufZv9Ci87EtNumSlh81D/RMBUB1
         SkpQVhfDqHWd+OvxONVKRfKsmHySwguPchGfTt+wRko0hWR9DVzcoHkWnhqNRVJLc463
         PiOXVl+YsmkFkn5w2u+TMtRHc6qyawh1xi+nxO6St0bc+jI1FT3TA/9k/+Vm2YIdcgGp
         EBYt5j1wQaaqWleGeWnb3Mw9+6lZSjsrpJAvvXLPTJFHmVqklBrovOL1hU02MgFGeiqX
         PC7aIX8nX/8P96zUM4rYaQG02bsss1BLzMdmXQ2sZU/WQaDv1/5fphkKSKBF1bFyqIJi
         4FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujwYz/NxPt4KuZjfQpu/cnFqN0PKCiE0M+fWaEKXyzU=;
        b=mx7nt1HiSF0c70zi3eg7MSplFR6KotnkCUlgtqHZxDgm088jlvHjQrU198SJMQ9GQN
         xZAkjmtB26UU3YQLQY2J1HaqhRN9e9a8q7I0fdcFdRdDw1EjgCX2bT0UAk7aalriq174
         U62cF5cxQtmz4yIxmLMkqjN1Q5XYvFLRCTCgTbRx4zUME7ruAxNGGvRllx1QyLSvkxLR
         JY/PcyHc8J+HSgI9dOM4+PFwGyrR2mjNP8N6pvlpWFNrKdZ/JuI1C+HOe4+HdJyDiIlz
         5ml/mggNacnQRNKnwKnInEuJWeti2LaXLaNHLW8gd+NFRsoXu985au3/tWRaf1QEDfjm
         E8JQ==
X-Gm-Message-State: APjAAAW+ADozYN5mfpN/yX/DNf+NPcwh796ZlLazsycLRPY+xemDSf0i
        ClPPBcBU+LdotVYQdnDt+lH8HQN2No+b4Vw+zx1B
X-Google-Smtp-Source: APXvYqzz2n4ssNU9eUBLNHNiiN1igpCWk1mywwCx6WmTr0Wqj7FtpXsRl6ByHayPfeQfIrJhDa2FjRZ8pjDimCZFisc=
X-Received: by 2002:a19:4349:: with SMTP id m9mr35378lfj.64.1566491549775;
 Thu, 22 Aug 2019 09:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
 <20190822070358.GE20113@breakpoint.cc>
In-Reply-To: <20190822070358.GE20113@breakpoint.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 22 Aug 2019 12:32:18 -0400
Message-ID: <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 3:03 AM Florian Westphal <fw@strlen.de> wrote:
> Paul Moore <paul@paul-moore.com> wrote:
> > Hello netdev,
> >
> > I was just made aware of the skb extension work, and it looks very
> > appealing from a LSM perspective.  As some of you probably remember,
> > we (the LSM folks) have wanted a proper security blob in the skb for
> > quite some time, but netdev has been resistant to this idea thus far.
>
> Is that "blob" in addition to skb->secmark, or a replacement?

That's a good question.  While I thought about that, I wasn't sure if
that was worth bringing up as previous attempts to trade the secmark
field for a void pointer met with failure.  Last time I played with it
I was able to take the additional 32-bits from holes in the skb, and
possibly even improve some of the cacheline groupings (but that is
always going to be a dependent on use case I think), but that wasn't
enough.

I think we could consider freeing up the secmark in the main skb, and
move it to a skb extension, but this would potentially increase the
chances that we would need to add an extension to a skb.  I don't have
any hard numbers, but based on discussions and questions I suspect
Secmark is more widely used than NetLabel and/or labeled IPsec;
although I'm confident it is still a minor percentage of the overall
Linux installed base.

For me the big question is what would it take for us to get a security
blob associated with the skb?  Would moving the secmark into the skb
extension be enough?  Something else?  Or is this simply never going
to happen?  I want to remain optimistic, but I've been trying for this
off-and-on for over a decade and keep running into a brick wall ;)

-- 
paul moore
www.paul-moore.com
