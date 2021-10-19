Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC31433DAC
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhJSRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJSRoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:44:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284A0C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:42:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r4so9132945edi.5
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FBFB5TpvCM2ffvAvKnFSlCgvqyq0TJ9lHk49iX31/z4=;
        b=wtDfIxAopPK3YdfWAUQxFYYuLqtBo5X09KwU4oRyNkF7nQ3w6UHKKBOR4Ss+YMbbz/
         qxnISxkdk+5MlWe6Rqx/CLRN0StexKNEXbC8OfMGlA0jR7j6DjgVhoXuhav1jGTXfxiH
         +9q1oyxgkI7HrI9WHfI54im6ovTg4kQWkndQvLF7xRz7MVe8YvInZsoKCU9wj88F8kDC
         IWJ2Xp9sBk0dnKfPDznxlhHvOnpGEkiMEmuJEOS+DMBRlz7cGc45QJmay+soj5eah+sj
         XHz3RJP7CvHhTDm8/kgY7a+KZVTbN1nNhYT+9s2XgnNk+3Mz2Yz7Qt7XzcahkKBdUznm
         kE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FBFB5TpvCM2ffvAvKnFSlCgvqyq0TJ9lHk49iX31/z4=;
        b=LOboUem8wuEyqpzpgm8gbxXXUcp3eDfy1APvwmS/Viy9AwvUlbL4WMWdMSnwUi3XSZ
         iaKVtEYSsMTnw39AzoLUN/cUdCHtjVnKqZKQcMds780s7C+TqsHldI3yuKpFOyIR1NHj
         t1A7Y3r8U2ebs/kfM/Ef+VIJ5DDpkCZWW51vdKPbNZacGCn7WBLW+Xj1jxqRE21XXPPM
         Bgkl8BQW2g5bNMEdvjBs1StAUH7RB75RUJQOH7q/ig8hlMQL4Wrdchs3qWkRyD0dMjw1
         6DrQ7r39S4UTGp8R67ZW+lMfNgP7Tay1OxR1RVOhTRkOwti/YyibxSMQuqipltUMr9aN
         k3SA==
X-Gm-Message-State: AOAM530ooNR/cwtGguLplvKnaHMIS1VhIM+iBt9bY4nudu9YjKmKPsje
        oW1opB9khMVN5a3QpjxNpne83Oje+LClOcJxWrXGHp4l6RIZywpp9QI=
X-Google-Smtp-Source: ABdhPJzfo2ze0heRi2KfK1PcOqBhINxGfn0+3IQEhHpQwsxkzsNldAQt0r8Dih8slmmDCBVknTt+nWf7OCHz68hJb8E=
X-Received: by 2002:a17:907:168c:: with SMTP id hc12mr39661473ejc.570.1634665317380;
 Tue, 19 Oct 2021 10:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211017171657.85724-1-erik@kryo.se> <YW7idC0/+zq6dDNv@lunn.ch>
In-Reply-To: <YW7idC0/+zq6dDNv@lunn.ch>
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 19 Oct 2021 19:41:46 +0200
Message-ID: <CAGgu=sCBUU29tkjqOP9j7EZJL-T4O6NoTDNB+-PFNhUkOTdWuw@mail.gmail.com>
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 17:21, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Oct 17, 2021 at 07:16:57PM +0200, Erik Ekman wrote:
> > Everything except the first 32 bits was lost when the pause flags were
> > added. This makes the 50000baseCR2 mode flag (bit 34) not appear.
> >
> > I have tested this with a 10G card (SFN5122F-R7) by modifying it to
> > return a non-legacy link mode (10000baseCR).
>
> Does this need a Fixes: tag? Should it be added to stable?
>

The speed flags in use that can be lost are for 50G and 100G.
The affected devices are ones based on the Solarflare EF100 networking
IP in Xilinx FPGAs supporting 10/25/40/100-gigabit.
I don't know how widespread these are, and if there might be enough
users for adding this to stable.

The gsettings api code for sfc was added in 7cafe8f82438ced6d ("net:
sfc: use new api ethtool_{get|set}_link_ksettings")
and the bug was introduced then, but bits would only be lost after
support for 25/50/100G was added in
5abb5e7f916ee8d2d ("sfc: add bits for 25/50/100G supported/advertised speeds").
Not sure which of these should be used for a Fixes tag.

I only noticed this because I was using newer flags for signaling
1G/10G fibre support in my other patch.

Thanks
/Erik
