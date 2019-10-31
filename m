Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9370EB96A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfJaV6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:58:42 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42289 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbfJaV6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:58:42 -0400
Received: by mail-oi1-f195.google.com with SMTP id i185so6555814oif.9
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 14:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wc3vWa+fr8h3dOHTN3KOywapXOUo1DYubM0ogmupdTc=;
        b=gAMhuQvc1z/gAuET0C/E368mt0CeA4xYak+vj63Bbj8zPwrJ2E/VUDJ+Ykk3Mgsx70
         MWUudwOpeymuS5iJGXj5MElOVv3OBRUwKBnV9xtVMNufZSsZdlibasbw9Qy1f32ia6sw
         2u+K+jw776TdP0IquCoaZVmp9C9EIMbEkhCcRy+s61d7CWzSYx2RAJfBTvX+hWOlShZV
         T6xLSzXsOERnToCTpiekhJBfz7pmCUPeyO1d4VuIR2kJT9xyFk6Mkwt2OzcQ4M4+r4Ix
         andAyqWbVYIJm/wtZbx6FKX7pl8/l3G4vwfZGRIbg7yQEhxKND4b1np9xPAjgginFWwx
         eddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wc3vWa+fr8h3dOHTN3KOywapXOUo1DYubM0ogmupdTc=;
        b=R7xeq80UN3XbtPG6jSJ0NqhO30NguO7ksqYpXZwNE37rZqOaFnMmq9bkYSkavC/5oa
         IkgKav/aSzeCca29wvyXQSYJs7OscuiOFrAoAQcmtm4F1ZVowZT4se5EVrPF8MFT4LQ0
         x+dW3dsBUHVfmUmrVDtuKz6ExQfno/Be8EKVSEsf7ngHntkTSi6MY1wAlDI4ihT/Gobk
         CxyL5xJOS83rB7ZMmf9dc1eJoTi8JBemqg4PbrpBWpyr4jGjT/7q9JYR3+RJPmUtRyXS
         sQPt98g9rih//OqcNeTIwXH+OMzW7NG5ChkqmvDpvrfZ7cJr1d+F8hNfsSS4dFCEI5PE
         Iypg==
X-Gm-Message-State: APjAAAVc6Mqqlh5/RIkX9LTWtIrduAJ0mr2mUgfi/lkyly6ZSgMowOYb
        ECGgLWxhmxRboLBQPzD9lxrK7nqIGqHPc8t/KLeOjaZr
X-Google-Smtp-Source: APXvYqwtFVOGgIivIGoPekibrWFtyvHDMpPwKfUVALRtpMOardUilQ7AErP226y8Lj6/k7w/1221VVuqrqbEZalu16k=
X-Received: by 2002:aca:ec51:: with SMTP id k78mr1765529oih.0.1572559120913;
 Thu, 31 Oct 2019 14:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191030220032.199832-1-yangchun@google.com> <20191031.141609.111804442534478009.davem@davemloft.net>
In-Reply-To: <20191031.141609.111804442534478009.davem@davemloft.net>
From:   Yangchun Fu <yangchun@google.com>
Date:   Thu, 31 Oct 2019 14:58:27 -0700
Message-ID: <CAOPXMbmPbJxk1K7wwfVQNA1q5s8Kr1TB2Qk1oPSUsE6EsAWM_A@mail.gmail.com>
Subject: Re: [PATCH net v2] gve: Fixes DMA synchronization.
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 2:16 PM David Miller <davem@davemloft.net> wrote:
>
> From: Yangchun Fu <yangchun@google.com>
> Date: Wed, 30 Oct 2019 15:00:32 -0700
>
> > -static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
> > +static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
> > +                                 u64 iov_offset, u64 iov_len)
> > +{
> > +     u64 addr;
> > +     dma_addr_t dma;
>
> Please place local variables in reverse christmas tree ordering (longest to
> shortest line) here.
>
> Thank you.

Sure I will send the v3 patch with this.
