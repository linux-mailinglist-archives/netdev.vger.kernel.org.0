Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6759480F24
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhL2DCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238461AbhL2DCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 22:02:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5080FC061574;
        Tue, 28 Dec 2021 19:02:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id v25so17375132pge.2;
        Tue, 28 Dec 2021 19:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H70Gh5GeGP3DCR9wXHQc0AqjiiJZ2/7tzP/ZebEKVew=;
        b=VrdjWLvfi7ntTLRzjwaXjt9MdsfaT+iKlSUwf1sI/ICDItKg3bIXw7YGeSyYiyQRKB
         /qj4ueX+wDWUuUqvV+yhIu8+Ma6MmedYA0xhNbBKOp8z2D5i/o6ZXOB6hg7Iql8jpEov
         yW/mMFLQ5IIR0O1cxxLmbtn31gSpAAxXpEs75MdSTUfwtoVIER3vDt+OuSAfvNDGJ5VT
         DOhzeHBGEGzMVdxITjgCa4VQLvCuPtWWSaOrHiIOVTy+qaTfmTIpKPS6ZsLmnHVlX956
         AnN9K75+YNZTzaNBFa+ojwfNRdxLjzqZ4PpYWlfbda4KuT7qEScOOsMDLj2YshEoZUMH
         3obA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H70Gh5GeGP3DCR9wXHQc0AqjiiJZ2/7tzP/ZebEKVew=;
        b=YbeIhpmHwABjyOBxTGYvfbuoh32yLhucNoHRIOAfa58/IzpYXLwVEJY/B2oi2amHDg
         lZYGFmvhrwotEFcil2kC+s8PWK/53uVgn9RUO1mQ/zQpR1RTt4QwDGj/OE5ukEFtObWj
         oBon6VtK9dN1pweTBkI5rP2+HKXxTocgcPqlyQeY4bF8WwJtyOAyMFy/8rLQkc6/8G9p
         8s3YVplSwHTgQqGFrW2UoQIvRPhC2Ft303DVB5mFTT8aPtTtZ5l5WEmrbPt7lIg3xXVz
         h9bbuPrmn2F8o5OrXqL8wKZqP8zS8Nw4TJ6mmh8f3j4dkOlRFUnqK4wty0vAi8Q6KeQ1
         0xiw==
X-Gm-Message-State: AOAM532xSRJPb5Os1fp0UZkBWR2R00vP9VCx17CqX534PqZd3oFWhS26
        CCq19juaRXV6KqhH2akoibdGNX9nG+RgIFisRYM=
X-Google-Smtp-Source: ABdhPJzVCJQ41F/p+nGAEw99ol+ouzSJYVVBMI3lAOeKm8YSQjSFCJf4ZAdS33ASc90MhodLIIQ5nXIAaPjRMW4y4rU=
X-Received: by 2002:a65:4381:: with SMTP id m1mr21269143pgp.375.1640746932653;
 Tue, 28 Dec 2021 19:02:12 -0800 (PST)
MIME-Version: 1.0
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com> <20211216135958.3434-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20211216135958.3434-4-maciej.fijalkowski@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Dec 2021 19:02:01 -0800
Message-ID: <CAADnVQLGq69c-Tw9M=v_pXFCMYDTA1rqNFWagkE6x7bRao9ZGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 6:00 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>  }
>
>  /**
> - * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
> - * @xdp_ring: XDP Tx ring
> - * @budget: NAPI budget
> + * ice_clean_xdp_irq - Reclaim resources after transmit completes on XDP ring
> + * @xdp_ring: XDP ring to clean
>   *
> - * Returns true if cleanup/tranmission is done.
> + * Returns count of cleaned descriptors
>   */
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
> +static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)

The patches look good, but please fix the warnings:

../drivers/net/ethernet/intel/ice/ice_xsk.c:636: warning: expecting
prototype for ice_clean_xdp_irq(). Prototype was for
ice_clean_xdp_irq_zc() instead
../drivers/net/ethernet/intel/ice/ice_xsk.c:719: warning: expecting
prototype for ice_xmit_pkt(). Prototype was for ice_xmit_pkt_batch()
instead
../drivers/net/ethernet/intel/ice/ice_xsk.c:636: warning: expecting
prototype for ice_clean_xdp_irq(). Prototype was for
ice_clean_xdp_irq_zc() instead
../drivers/net/ethernet/intel/ice/ice_xsk.c:719: warning: expecting
prototype for ice_xmit_pkt(). Prototype was for ice_xmit_pkt_batch()
instead
