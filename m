Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0885019F644
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgDFNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:00:16 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33121 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgDFNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:00:15 -0400
Received: by mail-lf1-f67.google.com with SMTP id h6so7231745lfc.0
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HaRtA1Jxq4FuD6KqIBhNnRMRisYsJA5aLAs60fjZD2Q=;
        b=rD2AULqSP96WxjXaqAFp5EsQfPhsFzhnNWBb8t2W/fTRDZ4yomA7CMj74SfCjCGPfr
         B/Ilxh+VR73N/yBlOUaLew5ENt0LqEJR/0252PKKN/vc/3wspe4donmTh2zcWSVH9v1V
         CijhHhY4atIh1Avty7uGZYDLi0sezXPX6t0rZQMcnBRFc76hkXGZHInYAI63UiW+wbQ8
         NbEthKqfcLUYQDUuAyhONVCYhn1IAkM2dB+VeAIkkPl7fhzacMVYKGCSFpr++ME88JnU
         eEWuQMML8MKSGEUELb5W/Td4Bg057bP8H9NIN65XVJxCzTcgOQNpP1DUVjIBmIIuUl9j
         bl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HaRtA1Jxq4FuD6KqIBhNnRMRisYsJA5aLAs60fjZD2Q=;
        b=ETcq3jCIhInQiywm0xSnmW+8nghkvI8Qd730Xfc3DJiCJXPZuEwxsV+meXnaamNM1Y
         dzm6gIQIqQ/Lpy4ICZBuzT1DYgvVcBTDMnUZ2swZY0WwWvt7fPCcnAuZc3GAjfxhHw8H
         CHW3f5E6fQYGqTTLKa/jOouLumRzrvLTlLwuTXJr6luDl2P/HLzwL3oumyleqAqk3DQI
         /MUzBvqlcC0ECu9wltVL8t/0mAgGu2jxblb8G1VJl05g+qnAOUWiaA1o53Fvr7Be/NXF
         taFe49tfylYP6ATHy0nPXbVwsU4qJ8bWDCQz5lsZR9gR7mhIP74///TSO2+ZPXsJbBez
         sXqA==
X-Gm-Message-State: AGi0PubdcVur7xAnm3CoCOpRLjnS7V1gKml5NrvhcJRVgOJkSbIH5eGW
        IRhri8ZBvzZce0skqlsfwjrxlTN4erxXNkLxrCtNTg==
X-Google-Smtp-Source: APiQypKWLxaOr2JwxPFRIKy8DyIk+GnLoWmCpZts1WGuVzegc2XBLTsdqA1LYFKaM6QY1KoWLGPuGNAn7rVqCVucQYw=
X-Received: by 2002:a19:6749:: with SMTP id e9mr12526614lfj.122.1586178012739;
 Mon, 06 Apr 2020 06:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org> <f2a393a2f01c93776446c83e345a102a780cfe88.camel@sipsolutions.net>
In-Reply-To: <f2a393a2f01c93776446c83e345a102a780cfe88.camel@sipsolutions.net>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 6 Apr 2020 18:30:01 +0530
Message-ID: <CAFA6WYPBef1w2YG8vDTnRK9N3Tjt-vQahpYd61H6twsRuT8YZw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Apr 2020 at 18:14, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-04-06 at 17:51 +0530, Sumit Garg wrote:
> > A race condition leading to a kernel crash is observed during invocation
> > of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> > driver built as a loadable module along with a wifi manager in user-space
> > waiting for a wifi device (wlanX) to be active.
> >
> > Sequence diagram for a particular kernel crash scenario:
> >
> >     user-space  ieee80211_register_hw()  RX IRQ
> >     +++++++++++++++++++++++++++++++++++++++++++++
> >        |                    |             |
> >        |<---wlan0---wiphy_register()      |
> >        |----start wlan0---->|             |
> >        |                    |<---IRQ---(RX packet)
> >        |              Kernel crash        |
> >        |              due to unallocated  |
> >        |              workqueue.          |
> >        |                    |             |
> >        |       alloc_ordered_workqueue()  |
> >        |                    |             |
> >        |              Misc wiphy init.    |
> >        |                    |             |
> >        |            ieee80211_if_add()    |
> >        |                    |             |
> >
> > As evident from above sequence diagram, this race condition isn't specific
> > to a particular wifi driver but rather the initialization sequence in
> > ieee80211_register_hw() needs to be fixed.
>
> Indeed, oops.
>
> > So re-order the initialization
> > sequence and the updated sequence diagram would look like:
> >
> >     user-space  ieee80211_register_hw()  RX IRQ
> >     +++++++++++++++++++++++++++++++++++++++++++++
> >        |                    |             |
> >        |       alloc_ordered_workqueue()  |
> >        |                    |             |
> >        |              Misc wiphy init.    |
> >        |                    |             |
> >        |<---wlan0---wiphy_register()      |
> >        |----start wlan0---->|             |
> >        |                    |<---IRQ---(RX packet)
> >        |                    |             |
> >        |            ieee80211_if_add()    |
> >        |                    |             |
>
> Makes sense.
>
> > @@ -1254,6 +1250,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> >               local->sband_allocated |= BIT(band);
> >       }
> >
> > +     rtnl_unlock();
> > +
> > +     result = wiphy_register(local->hw.wiphy);
> > +     if (result < 0)
> > +             goto fail_wiphy_register;
> > +
> > +     rtnl_lock();
>
> I'm a bit worried about this unlock/relock here though.
>
> I think we only need the RTNL for the call to
> ieee80211_init_rate_ctrl_alg() and then later ieee80211_if_add(), so
> perhaps we can move that a little closer?
>

Sure, will move rtnl_unlock() to just after call to
ieee80211_init_rate_ctrl_alg().

> All the stuff between is really just setting up local stuff, so doesn't
> really need to worry?
>

Okay.

-Sumit

> johannes
>
>
