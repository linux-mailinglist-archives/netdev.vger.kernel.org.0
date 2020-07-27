Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D802422E675
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 09:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgG0H0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 03:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgG0H0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 03:26:35 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84E4C0619D4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 00:26:34 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so12702260qkn.4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 00:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bcQMkiC6JyOAC4Lv4CWi0++I1XNF82/fz8tqn1+E1Hw=;
        b=IyqtPWAaKhAh+DaxDQ4DPb3PUihUUHg8FyCmLNkaMd01kCj5NBl4KCGQa/PWeiKjvy
         lYiDgQlerDSKik78BIzs/K0+t9zjJEXiGFWlYKsGkciLp+jsot0ilKwAfdPe7YGjRNbf
         OR/xYOR5VD5tJTttqVfi3tZ1SpLAtqmyRi3zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bcQMkiC6JyOAC4Lv4CWi0++I1XNF82/fz8tqn1+E1Hw=;
        b=kIP168beztaE0quPNs0VzQMXHcX04y8VxNDxM/A62XYNi2m7vRCnnfxhwZ2KcvoMG/
         2HR0OkCmQjkshxiZ0LpVaTvE+JUGTZC2GKtu2u1zl8JqhjftE9ELfAhSHM+S4CPKdUPr
         8fc+Nj+k/vKfDR1+8Rvo8TO7SPOSoz4o3YyZqUyOPG+dIk+R9S+T5a+6G8ukbW1FAXGK
         5jkPDDHCbwWhwTp/cE7w7jESyzC7KYlGp3tcs2WigvrHj9cg5ptvIiSbul9I9mHggLdo
         Ko4nQT2I4KO1fJdBdj9kYRcoVGZDrHlCTtQuUstRflAavF4rk5Z+RSAhxUjd38zFPONo
         fPHQ==
X-Gm-Message-State: AOAM533IWaNlUf6PX9AcJ2qSvqXyVsIjTMMtvsmhOp45GGVsgsfRtZp3
        4RYCCslo56d2RctYMZFykh84lamP/5YQcE8cC62TXQ==
X-Google-Smtp-Source: ABdhPJx7sIx/y5po184X2+GWLwV1Q6wkqZEsbr9KeZ2FcprUla1gV50XWsaJXbGbAAZ1t3jNlIzBsu1Wfo+Q1W6K+cg=
X-Received: by 2002:a05:620a:209b:: with SMTP id e27mr21265347qka.431.1595834793706;
 Mon, 27 Jul 2020 00:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
 <20200617185117.732849-1-drc@linux.vnet.ibm.com> <4bb07889-063f-c12d-28e0-11de9766c774@linux.vnet.ibm.com>
In-Reply-To: <4bb07889-063f-c12d-28e0-11de9766c774@linux.vnet.ibm.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 27 Jul 2020 00:26:22 -0700
Message-ID: <CACKFLimJTiRx1L+FFOZfR3-yrR9u+TY_Fdy3OSgH49v9QLKGwg@mail.gmail.com>
Subject: Re: [PATCH v2] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 5:19 PM David Christensen
<drc@linux.vnet.ibm.com> wrote:

> In the working case, tg3_init_hw() returns successfully, resulting in
> every instance of napi_disable() being followed by an instance of
> napi_enable().
>
> In the failing case, tg3_hw_init() returns an error. (This is not
> surprising since the system is now preventing the adapter from accessing
> its MMIO registers.  I'm curious why it doesn't always fail.)  When
> tg3_hw_init() fails, tg3_netif_start() is not called, and we end up with
> two sequential calls to napi_disable(), resulting in multiple hung task
> messages.
>

If the driver fails to initialize the chip completely, the tg3_flags
should indicate we are in this failed state.  We already have
TG3_FLAG_INIT_COMPLETE.  Perhaps, we can expand the use of this flag
to cover the scenario that you described above.  We can clear
TG3_FLAG_INIT_COMPLETE before calling tg3_halt() and only set it back
when tg3_hw_init() completes successfully.  This is the rough idea,
but a more detailed analysis on how this flag is used needs to be done
first.

Assuming this works, the EEH handler can check TG3_FLAG_INIT_COMPLETE
to see if we should call tg3_netif_stop().

Another way to fix it is to call dev_close() if tg3_reset_task() fails
to re-initialize the device.
