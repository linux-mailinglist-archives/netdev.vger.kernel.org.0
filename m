Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8597C1FD522
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 21:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgFQTHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQTHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 15:07:21 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52750C061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:07:21 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so2423599qtq.11
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hExgXDZV3zpYGtiPY9jV9AWM1I/0OncMTJ8ouUg465o=;
        b=Yq/UKsYvS0A5josQgPU+0t/qeW1UDwyO90aOpKP5PVYKTVQERWgvbxo7N6o4rLyGJV
         jaouHK6XMXK4ToLxdbxpdYbs+FMmvt3Z4AyrWrXMOans4RMyzqar+6OvBPnP0VW9A7oP
         lWU9WTEMPcH3OhvGA4Fdx4JuxoIj5K1Ll88ek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hExgXDZV3zpYGtiPY9jV9AWM1I/0OncMTJ8ouUg465o=;
        b=LZhItfTCMjk+Ksf5/n1cSp4kt4FSLezd78yjSIyPWlvg0fFKSp9MJjzGHNr2oDpXwQ
         t2cDEJLHGv7QCA7F9Lc2hz32YnJW0lnTjj1UVsbTUR0Hrn+2Cd7yFqQ4NrJLwltJNKD0
         I1fZq5txAb/nZShSexiMaIRF7eUqg1lIwJpOt3m0WM/i1Tzs1YaJE7YaXypBfPo3TVwj
         7Wm4YpgQe0qYY25ltBcE4YMe38cl7LHeHgzowgfSn2guzWdB5tp4RK4RojYUMfawHSsl
         uhSY3slDAJleWHMcaFY4fpLqriSFAMI1ZaxmpXW0+DCg4778VICDPDFxN1Ib1ojuA1oF
         M+sA==
X-Gm-Message-State: AOAM530yJkRUJEnkJ+WUUqhzhSNwGTuDJ0VQFiirO1nd51kqlhqihtSX
        qdvtG8ic2CDXs8RHi0xT40yCMTFZN+uBbUHZVIQWrQ==
X-Google-Smtp-Source: ABdhPJw2/X6M0huZ3wYR/5SR5uzm7PonmG3PRzsJ0BS0PeITaIZxz6pdiPRuA7pGlJKolACxFYkIkvqmU79DWDg14Qs=
X-Received: by 2002:aed:3fa4:: with SMTP id s33mr663234qth.148.1592420840377;
 Wed, 17 Jun 2020 12:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200615190119.382589-1-drc@linux.vnet.ibm.com> <20200617185117.732849-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20200617185117.732849-1-drc@linux.vnet.ibm.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 17 Jun 2020 12:07:08 -0700
Message-ID: <CACKFLimXALz8LOPFiX7ar456CsucUf-wxmD4_KkJSmjXbZ-q+w@mail.gmail.com>
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

On Wed, Jun 17, 2020 at 11:51 AM David Christensen
<drc@linux.vnet.ibm.com> wrote:
>
> The driver function tg3_io_error_detected() calls napi_disable twice,
> without an intervening napi_enable, when the number of EEH errors exceeds
> eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.
>
> Add check for pcierr_recovery which skips code already executed for the
> "Frozen" state.
>
> Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
