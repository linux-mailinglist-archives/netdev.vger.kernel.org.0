Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B326843FE6B
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ2OaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhJ2OaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 10:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B599B61051;
        Fri, 29 Oct 2021 14:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h5pbQNL/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1635517650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QnWkyN6KGUfNiy5qk93ywFf1HQovAYF4w85+8oNqIOw=;
        b=h5pbQNL/W0oxByC5nvKmb9PSHqsXw1BVkB3Vy7zcnlpyiayS4KdCQHCK08qaZkRGeHRh35
        JperHsXpJ0gcLgexSqp5qMRq9SjEGACqdoeE2kTKivTsvwh5mZ6hZPtTJI2H36ao4oSwuJ
        b6PcKfJzQcKenUpetv/UoUr1xG23Cko=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ff5fffe5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Oct 2021 14:27:29 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id d10so13801696ybe.3;
        Fri, 29 Oct 2021 07:27:29 -0700 (PDT)
X-Gm-Message-State: AOAM53037gVbGVwBbrieaIdW2/N8k9DcfKEsiOBZDVrq/V06KQTDZ4Qp
        NOt9eOXMUMoHGKj0CFMwyCDZbiaRBOCznRdFOC0=
X-Google-Smtp-Source: ABdhPJzppDmksYWOAYQDlFsf24rGw4CsBIkDXLIIUOvgUCnYvBmovuZkegEbO8TM7O5PotQ+r833GzYmOzoln94qAhc=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr12765514ybg.62.1635517648595;
 Fri, 29 Oct 2021 07:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <1635469664-1708957-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1635469664-1708957-1-git-send-email-jiasheng@iscas.ac.cn>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 29 Oct 2021 16:27:17 +0200
X-Gmail-Original-Message-ID: <CAHmME9p9EA0qCw2ha_X9HR7NWSt1Zam4+srYHCs=-U4LvQiJdA@mail.gmail.com>
Message-ID: <CAHmME9p9EA0qCw2ha_X9HR7NWSt1Zam4+srYHCs=-U4LvQiJdA@mail.gmail.com>
Subject: Re: [PATCH] wireguard: queueing: Fix implicit type conversion
To:     jiasheng@iscas.ac.cn
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 3:08 AM Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:
> It is universally accepted that the implicit type conversion is
> terrible.

I'm not so sure about this, but either way, I think this needs a bit
more justification and analysis to merge. cpumask_weight returns an
unsigned, for example, and is used as a modulo operand later in the
function. It looks like nr_cpumask_bits is also unsigned. And so on.
So you're really trading one implicit type conversion package for
another. If you're swapping these around, why? It can't be because,
"it is universally accepted that the implicit type conversion is
terrible," since you're adding more of it in a different form. Is your
set of implicit type conversions semantically more proper? If so,
please describe that. Alternatively, is there a way to harmonize
everything into one type? Is there a minimal set of casts that enables
that?

Jason
