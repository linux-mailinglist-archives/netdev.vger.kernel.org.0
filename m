Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A006B28BCFF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgJLPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbgJLPzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:55:02 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB1AC0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:55:02 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m13so16231049otl.9
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Ipj6KApmqDordHHkZA5BdwogTRTbSz9ufEP2mPZJkg=;
        b=bqM+JLYeYtmZLKVItTggBkanB+K1wLMBpj7MByYdi1dXJ89PovuV9CfiJ0Z52A5pOo
         v09VFIcwFD5Mk5KK8RpEZUNGVeMwhJnlXCJDl5EEpDfGkleP4MQpXYkhFm2dlxODF+Za
         3sdMFjM0CAKrxOkWulu8F1GYHUPxLq48Io9jI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Ipj6KApmqDordHHkZA5BdwogTRTbSz9ufEP2mPZJkg=;
        b=cNudSlxEPvRgdK2AJeojhM3LVogTgYWTurDpZIT3aMKebAZjc+Gk6cg0OcPuq6Mzwe
         6SYko/F7yE9lXkW32T48rqP2AE79PvOkEl54PznqVpZYhRvxY+klMSgSPSq7ZDxdVGig
         EvogUSTUuFiCWdBHNABFcsruhhs9NRLAeqphhxaRgS2xB/jJe0wv+bNn+zbcq3ZKdWis
         P83hhSbUM5lHMoebKYTFVGJ/Gf7qUCnCcD+7uDXHp8fXL3mZv7Tu6aQLuu9bASnKru92
         D++k9sw6rXqzQkQVhoQK4Rod1GhB2JYinZySGXcO2/MW+oxNBENIT8ep4M+G8iN+YE2r
         4/bw==
X-Gm-Message-State: AOAM533SGkzWHVLmBvIRrogSpVuxuPo4AK89/w/tIyCBjdBjr7UBBgTg
        7GmKSPyAdyRYIqbWsQSJRwdM5K9Dazlxtqmp9Hlrhg==
X-Google-Smtp-Source: ABdhPJx+keD6z4dt02aa8k+J2BwE04JZ7uXERqCyeIC3cQdasnyOXK211tshxI858hddaUTcqvIBCQadIhBaz7Crf2I=
X-Received: by 2002:a9d:6ad5:: with SMTP id m21mr17217338otq.147.1602518101673;
 Mon, 12 Oct 2020 08:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul> <160216615258.882446.12640007391672866038.stgit@firesoul>
In-Reply-To: <160216615258.882446.12640007391672866038.stgit@firesoul>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 12 Oct 2020 17:54:50 +0200
Message-ID: <CACAyw9-Ou=T7d6uDC8yKLNUf+QC5sZg_itOEJfhAinKznDdGCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 3/6] bpf: add BPF-helper for MTU checking
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 at 16:09, Jesper Dangaard Brouer <brouer@redhat.com> wrote:

...

> + *             The *flags* argument can be a combination of one or more of the
> + *             following values:
> + *
> + *              **BPF_MTU_CHK_RELAX**
> + *                     This flag relax or increase the MTU with room for one
> + *                     VLAN header (4 bytes) and take into account net device
> + *                     hard_header_len.  This relaxation is also used by the
> + *                     kernels own forwarding MTU checks.
> + *
> + *             **BPF_MTU_CHK_GSO**
> + *                     This flag will only works for *ctx* **struct sk_buff**.
> + *                     If packet context contains extra packet segment buffers
> + *                     (often knows as frags), then those are also checked
> + *                     against the MTU size.

Maybe this is a documentation issue, but how / when am I expected to
use these flags? I'm really ignorant when it comes to GSO, but could
BPF_MTU_CHK_GSO be implied when the skb is using GSO?

> + *
> + *             The *mtu_result* pointer contains the MTU value of the net
> + *             device including the L2 header size (usually 14 bytes Ethernet
> + *             header). The net device configured MTU is the L3 size, but as
> + *             XDP and TX length operate at L2 this helper include L2 header
> + *             size in reported MTU.

What does mtu_result represent in the GSO case? I can imagine there
being some funky interactions between skb->len and the return value,
depending on how this is defined.

> + *
> + *     Return
> + *             * 0 on success, and populate MTU value in *mtu_result* pointer.
> + *
> + *             * < 0 if any input argument is invalid (*mtu_result* not updated)
> + *
> + *             MTU violations return positive values, but also populate MTU
> + *             value in *mtu_result* pointer, as this can be needed for
> + *             implemeting PMTU handing:
> + *
> + *             * **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *             * **BPF_MTU_CHK_RET_GSO_TOOBIG**
> + *

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
