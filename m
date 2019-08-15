Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6228F5B9
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731957AbfHOU0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:26:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42495 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731850AbfHOU0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 16:26:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id s19so2494112lfb.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 13:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMu2C04ftY81TYFCnc8lXX04zGDDGOcRI0zFGGiMOC0=;
        b=lKumc5s3VZUto1TE0iTCoHL9TAw+ySrWt4qf38RzqlZOcyiAiHQ3yabZ1IX6Mb/ilK
         vdH98kxp4z3xxBRqOFO8Ligh5CG7U1ddsStwqBCkgBoU+bv4ICOpIWoQMyOEo5D1l7A/
         wdiZ49xHK3w2p3ZZSJivn2hJZ/j+dfn10VKHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMu2C04ftY81TYFCnc8lXX04zGDDGOcRI0zFGGiMOC0=;
        b=a3A6sJahPHsl+UR5R8wha8tLB/UGGFQGbE+Um/R+WA6sXFZxdQP+CKopM5AbWFa4vE
         +PVzuxpru+Zrq21q0Hoxfh+eC6nPbaErrNz98/7/yP/PB7xLGruvtoWowJtwvFHxmuEL
         u9Pmn7xIoEHimgTVze+Bka2+vpjqq2xtd4geNwW/5kdelOGSGjXbXGouSOdksiZRTOZC
         wA/Y45tvRKTUnWVh9RptXI4rzJ+Y9HNR/BL6zDTNS4cFIRDq75l1f+ptYUAaGM6xwPty
         RQYMlqQZGADyK4K5NDYz8jo1Xx0A55j1+yfADfbp45Gyg8I9z2mxsP9gpEiNU5e444rh
         aWqA==
X-Gm-Message-State: APjAAAWGs2vbuTciwCLsIuUg5Q42wziaLmIRhA/ZbHpgsPyNoJ//klUb
        hVveOCCmRKdKdICFedRBc45SiRgC3Hc=
X-Google-Smtp-Source: APXvYqxt2C0RoQVaecUT/R7fWEgvTL5K1i/gbr9BgH4YwmDUNsl1tLw1JJRzMQkTdxlFdd/s8o53gw==
X-Received: by 2002:ac2:5ec3:: with SMTP id d3mr3237740lfq.44.1565900761578;
        Thu, 15 Aug 2019 13:26:01 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id y66sm646227lje.61.2019.08.15.13.25.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 13:25:58 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id s19so2493979lfb.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 13:25:58 -0700 (PDT)
X-Received: by 2002:a19:ed11:: with SMTP id y17mr3283567lfy.141.1565900757828;
 Thu, 15 Aug 2019 13:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190709161550.GA8703@infradead.org> <20190710083825.7115-1-jian-hong@endlessm.com>
In-Reply-To: <20190710083825.7115-1-jian-hong@endlessm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 15 Aug 2019 13:25:46 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOgCHzAfyQDAGhkFZMO4UaXfrnpkN9a95jzfQY_L+EbAg@mail.gmail.com>
Message-ID: <CA+ASDXOgCHzAfyQDAGhkFZMO4UaXfrnpkN9a95jzfQY_L+EbAg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessm.com, Daniel Drake <drake@endlessm.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I realize this already is merged, and it had some previous review
comments that led to the decisions in this patch, but I'd still like
to ask here, where I think I'm reaching the relevant parties:

On Wed, Jul 10, 2019 at 1:43 AM Jian-Hong Pan <jian-hong@endlessm.com> wrote:
...
> This patch allocates a new, data-sized skb first in RX ISR. After
> copying the data in, we pass it to the upper layers. However, if skb
> allocation fails, we effectively drop the frame. In both cases, the
> original, full size ring skb is reused.
>
> In addition, by fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
>
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---
> v2:
>  - Allocate new data-sized skb and put data into it, then pass it to
>    mac80211. Reuse the original skb in RX ring by DMA sync.

Is it really wise to force an extra memcpy() for *every* delivery?
Isn't there some other strategy that could be used to properly handle
low-memory scenarios while still passing the original buffer up to
higher layers most of the time? Or is it really so bad to keep
re-allocating RTK_PCI_RX_BUF_SIZE (>8KB) of contiguous memory, to
re-fill the RX ring? And if that is so bad, can we reduce the
requirement for contiguous memory instead? (e.g., keep with smaller
buffers, and perform aggregation / scatter-gather only for frames that
are really larger?)

Anyway, that's mostly a long-term thought, as this patch is good for
fixing the important memory errors, even if it's not necessarily the
ideal solution.

Regards,
Brian
