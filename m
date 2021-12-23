Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D447E994
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 23:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhLWWxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 17:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhLWWxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 17:53:07 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1465EC061756
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:53:07 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e136so20564111ybc.4
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZcEv8EcLJVrHvC/I5/J7MwrmBXZn8X2kMKVjuhCef14=;
        b=Y1aTx1YrmjZq5GG2AVe7+K3dzJAMOMWNq8DYehXq7+z97i1nm+M2Ea2sAzDUXJjKp2
         GnNc4dqe1KYLwgMy+pKHEvAj0hVHmofr0XHbr5dtZTeDL13QlJbENdsPTdkpu+VOA+BD
         ReleBwzcVXENo4HNU9m2daQiGj+nPgn1x0LWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZcEv8EcLJVrHvC/I5/J7MwrmBXZn8X2kMKVjuhCef14=;
        b=6tD8qqIAlLlTDkmxVOZBRLIS2FzYAYQCx3UiTWKRKzkT6ZocIY1j5wOQmM4tNBT+DY
         7DygnyxOZL5POaShe+dpcxO/wizsEQnX8Mpw/ycITke79isjK6N+kTYhpLJQINZzMKD/
         FeCCbMr2AtSoxdtsSMWX64pMRQ8kdfDMWBuBnzhF6ZqTXNBsSiRdrL1zDGINnRHf27QH
         Ap4QoXfoOkKeTIkA93ckDqCBo7Agjg1O5wD3hkKCWomZrvnf/1q3mIfNxFjOUMPDVof3
         EyUp7fquve5dy5xugenLD43enYDYoqQrSDOQSvc43y1TYLfSc1uiDOsu16OdaA2ws/rb
         yf7A==
X-Gm-Message-State: AOAM533/eUevXiliFQUQevSOHSZRZuAjq1jFVA62vymFOuq/u70OB3JE
        byhokhVcVg1kNSsKZq6+bH4/KeLO4UGfMHtyj8r8hA==
X-Google-Smtp-Source: ABdhPJwE+p02x6CD8c8Z3xtjknTsne4NEUfj3GqbYLVPV1vZGGJhs3fskI38m4tdIitm33R3WVJMb3Q0j+4HsaVIBw8=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr93571ybg.693.1640299986168;
 Thu, 23 Dec 2021 14:53:06 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3bzd4P0nsyZe6P6coBCQ2jN=kVOJte62zKj=Q8iJCSOQ@mail.gmail.com>
 <CANn89i+mhqGaM2tuhgEmEPbbNu_59GGMhBMha4jnnzFE=UBNYg@mail.gmail.com>
In-Reply-To: <CANn89i+mhqGaM2tuhgEmEPbbNu_59GGMhBMha4jnnzFE=UBNYg@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 23 Dec 2021 14:52:55 -0800
Message-ID: <CABWYdi0qBQ57OHt4ZbRxMtdSzhubzkPaPKkYzdNfu4+cgPyXCA@mail.gmail.com>
Subject: Re: Initial TCP receive window is clamped to 64k by rcv_ssthresh
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
> Stack is conservative about RWIN increase, it wants to receive packets
> to have an idea
> of the skb->len/skb->truesize ratio to convert a memory budget to  RWIN.
>
> Some drivers have to allocate 16K buffers (or even 32K buffers) just
> to hold one segment
> (of less than 1500 bytes of payload), while others are able to pack
> memory more efficiently.
>
> I guess that you could use eBPF code to precisely tweak stack behavior
> to your needs.

Adding ebpf for this is certainly an option and it seems similar to
TCP_BPF_SNDCWND_CLAMP. I can certainly look into crafting a patch for
this.

Is it not possible to do anything automatically to pick a bigger
window without ebpf? When the scaled window is first advertised in the
very first ACK, the kernel already has the SYN ACK skb from the other
end of the connection. Could the skb->len / skb->truesize ratio be
looked up there?

Increasing tcp_rmem (the middle part specifically) is a lower entry
barrier than making ebpf involved, and it can really help with latency
even for human use cases like opening a website across the ocean.
