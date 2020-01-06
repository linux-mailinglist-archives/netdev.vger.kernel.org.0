Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF1131686
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 18:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAFRMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 12:12:05 -0500
Received: from conssluserg-04.nifty.com ([210.131.2.83]:39456 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgAFRMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 12:12:05 -0500
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 006HBsHW010926;
        Tue, 7 Jan 2020 02:11:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 006HBsHW010926
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1578330715;
        bh=2BKWFZ+LLnQcnOkQq6MTiLhs7/t8zBhbAgsZQGvsWNI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=w03EEysuoYBpDGFJjev3LS1FEr90SDHf0BxTBneQNecS1r/jKEgBB89Z8lDdxOBUb
         W53Lm1k+NCNHidnjqdoNj7NqoOEPr1XlEwq+J3uwaoXQuGQwh7W4AK2GYQi4ka/ury
         2wVl83mnoETddJOGvZRLRGbBlgisKca4t/f02/eCOwUVMIMCc9ECLONNIwPKOY88X4
         OYBasc1dRMK5HHGmdW48tj53kwoIQBENms2qCRBEtdWYTB5mr1q7TUEMfVQpefPhnz
         dWEuzXy5hEp7ZWleKcCE15vzv7l8oR2TPhO1xCICRbgirs50o4yDbIvKrP51VDaPiw
         F99d299O5FMUw==
X-Nifty-SrcIP: [209.85.217.42]
Received: by mail-vs1-f42.google.com with SMTP id f8so32035159vsq.8;
        Mon, 06 Jan 2020 09:11:54 -0800 (PST)
X-Gm-Message-State: APjAAAWemtqTqFOl2ivWFYa68Z5hPBvYJWB82RLCjb/P/IDCJL6E8LoV
        ikVa2VFyKPqlG1wpHlwlEtFI4Tc0ma1KV3c4gaw=
X-Google-Smtp-Source: APXvYqxBtMV5kRovjDvmrxMLtRN5q4zbuWgF/aVysEVce79j7Tf9kIRBskOewgbJg4wGkEdfDThOOzNZD8Qq0o8StQM=
X-Received: by 2002:a05:6102:48b:: with SMTP id n11mr43944479vsa.181.1578330713566;
 Mon, 06 Jan 2020 09:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20200106075439.20926-1-masahiroy@kernel.org> <8f17a0bca11604d9818326b01267186bd91236c9.camel@sipsolutions.net>
In-Reply-To: <8f17a0bca11604d9818326b01267186bd91236c9.camel@sipsolutions.net>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 7 Jan 2020 02:11:17 +0900
X-Gmail-Original-Message-ID: <CAK7LNARLw0cBBCV8C6_bKhxEmUSTqP2Ve1RWzUJw6y2cnqdUXQ@mail.gmail.com>
Message-ID: <CAK7LNARLw0cBBCV8C6_bKhxEmUSTqP2Ve1RWzUJw6y2cnqdUXQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: remove object duplication in Makefile
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 12:51 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-01-06 at 16:54 +0900, Masahiro Yamada wrote:
> > The objects in $(iwlwifi-objs) $(iwlwifi-y) $(iwlwifi-m) are linked to
> > iwlwifi.ko .
> >
> > This line adds $(iwlwifi-m) to iwlwifi-objs, so the objects from
> > $(iwlwifi-m) are listed twice as the dependency of the module.
>
> Are you sure? We have
>
> obj-$(CONFIG_IWLWIFI)   += iwlwifi.o
>
> and then "iwlwifi-y += ...", but I was under the impression that
> iwlwifi.o didn't really pick up iwlwifi-m automatically, that's not
> something that you'd normally do, normally -m only makes sense to build
> a module using "obj-m", just here we do it for the mvm sub level
> stuff...
>
> johannes
>

I made a mistake.

iwlwifi-m is automatically handled since commit
cf4f21938e13ea1533ebdcb21c46f1d998a44ee8
but cfg/*.o objects are not liked to vmlinux
under the following combination:

CONFIG_IWLWIFI=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m


Please ignore this patch.

Perhaps, I may come back to this patch,
but I need to change scripts/Makefile.lib beforehand.


-- 
Best Regards
Masahiro Yamada
