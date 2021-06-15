Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF16E3A7C73
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhFOKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhFOKyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:54:03 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5575EC06175F
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:51:58 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id p5-20020a9d45450000b029043ee61dce6bso6744377oti.8
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JYGWO1SgA7+I8CH5PDMKQu/CeLkMKnpGa2Luun67qpg=;
        b=Zzw3PnPAywtMGZPMrkMNwiFn3JmNjydjp7DIzZra3wMwmjMKSFDLwfE7DykwjrmQj+
         TszZCILOPKos5+pj5KReIPtjNSzsVTHokJxTKIbRW7F6xMqnRuDz4SUN/amfy4sTVkJt
         NtSiBiYtihJYm5O66kJQgVOCSAbPH9aP9vZ5fV255amo9I/wi8R1e72kUi/XA87hgt9F
         EI0EgZ8YW7SWC1Z/2++Qpl45hgOpYHub7GxS1m+x1u3tROEmOltJWkwUb0xTST/4sPck
         stjGiHvKFgdhWW0RCPkJjzgME8yOM7dZa7ETz5PcX+lkmaBT9GjQG7doqHA2euWO2I3Q
         Ifjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYGWO1SgA7+I8CH5PDMKQu/CeLkMKnpGa2Luun67qpg=;
        b=lAPvTXkBEj4Xx7d7M4zF92sbggHztEhk7padsEYfzbipT4Sfmf/u7N7yiAkTlN/lr9
         tJsvTfVTJJwOxFT+WdrBCTpovkZ2B09sp/JxpMUinqvCkGFmBanT/UMudcT43FcJKUbX
         LgRt5+TaTG6eP3TaNZ0byFA7Qs84DZn0Gkvi0G/l4I+BuaxQTZX0ERMzpsa39vp28GQX
         h4qMl0tCNNumVOZpwakQ7XhpYiMZxreqVcrTPf472X65guoj+j237T05t7nuV5oeGUfE
         1x6ilirjOVRQ75M/P+FshAoL+QGyC6lemRioT1+NMItoTXen5r5Lizjjm3j3bU+RHKvs
         gs5g==
X-Gm-Message-State: AOAM530XwYteJN9FbVhN8G1PmB2FO3qO3n6FQNmzHEDDN97Jp5mNOaYb
        VyZ4FklLVgC3Vws+yyw+uiHoWxTZ4lRGHUdVx8g=
X-Google-Smtp-Source: ABdhPJyDpW8sY2Jw0O6HSKVhuTbat7zXFBESYCJ27EfBrWpj9F/QCVhHTct8iOFto65LKVob6kIhJdvIGNDbfSIeptQ=
X-Received: by 2002:a05:6830:154b:: with SMTP id l11mr17724929otp.66.1623754317581;
 Tue, 15 Jun 2021 03:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
 <8735tky064.fsf@miraculix.mork.no> <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com> <877divwije.fsf@miraculix.mork.no>
In-Reply-To: <877divwije.fsf@miraculix.mork.no>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 15 Jun 2021 12:51:46 +0200
Message-ID: <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Tue, Jun 15, 2021 at 12:04 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
> Yes, FLAG_MULTI_PACKET is only applicable to the qmimux case. But I
> think Jakub is right that we should set it anyway. There is no way to
> return from rx_fixup without an error or further processing of the skb,
> unless we set FLAG_MULTI_PACKET.  Or invent something else.  But setting
> that flag and then add the necessary usnet_sb_return call doesn't look
> too bad?

Just so that I am sure that we are on the same page. What you are
suggesting is something like:

* Update FLAG_MULTI_PACKET when qmimux is set/unset.
* Replace the call to netif_rx() inside qmimux_rx_fixup() with a call
to usbnet_skb_return.
* I guess we need to keep the code that updates the qmimux interface
counters. I guess we can just call this code unconditionally?

I think this would be a really nice solution. The same (at least
FLAG_MULTI_PACKET + usbnet_skb_return) could be applied to pass
through as well, giving us consistent handling of aggregated packets.
While we might not save a huge number of lines, I believe the
resulting code will be easier to understand.

If we agree that this is a good way forward, I can prepare a patch. I
have everything set up and ready to go.

Kristian
