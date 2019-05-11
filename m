Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E21A967
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 22:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfEKU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 16:27:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37526 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfEKU1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 16:27:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id w37so10718942edw.4
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 13:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0NKzY9Nh28EBvV8QvFJQ8CwCqYyFTSCabdXLEjLbQiw=;
        b=UF6W/uneg5TY5r1Ily33F1R/CRuzU7sfwUPV84mvTk5KFGUSbFvBGMTkyaDYCB6x+w
         HaEr5hHqYCZ0SYvU7dZFYG/Ak2azrYaJDr5KJufHiPWXT/UdPoViJ8yXVTmF+Epckw6h
         7cBEsmod4XNq+oHwsCUagbAXRQ587nUiWWW+ctsu9e3mFl8u6fHBDhy7pCTYPDGnMwgs
         /1QjHgeRZGrB6IwaDj0Eec5ee3I8318XWyUxqPM0EVWydKAJcPMX73uHeotN1lkatAYb
         8KRcCDuv0v2bvFGtFYygq74RkzAcbqpWe0aKqjT07Ij1uw4Hq31UDy1zcKTCmZKCBjHK
         7LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NKzY9Nh28EBvV8QvFJQ8CwCqYyFTSCabdXLEjLbQiw=;
        b=kvZ+2SbpTD75g0jg26RVgdeAP/bfSMRTMm7DlzdEpw1iSTmJJdsfYLb/QHoP9CgYjG
         +H07kcAqdOwwNaoRsb+2ZEW6ohjG4bI4qvFIBqmFvAh2SPLToZMtc1UiaMNrv+hzDsOz
         e+L3CkvGb3UTWjnXP02ahU7pQ3R0X9jZX/kGpbAmz25MdT8fHh5qQWOiV18+c+pWMim4
         IP0pcdF1Ajku+uWQJ5IWkjKr0gSWVz86/EokIajxodwyZTGZxFeXDmp7Q/MADgsvsxQM
         xdJWxKDzRgUM6vr/VtriwEE3EHdh39U2y6zKnj5E87pB+5cbhwulbWNsiFBjD2DOpjln
         FFMA==
X-Gm-Message-State: APjAAAUHNse8PUnE6JhZ+yVR701mG4SLQLLwEepK2cKbhgMmOLYlxRL1
        Xj1OSDSFmcI4ohyUmacHitmqLMZjSmOQTXZztaCSUL9k
X-Google-Smtp-Source: APXvYqyyaPro1J1QA+Giu5rBnZiO8jJ30ChReHABOHuUP7kdjJJJFBGWgkxPWfcgALgUIAMvRrFYjyMbmgRVY69btcc=
X-Received: by 2002:a50:90dd:: with SMTP id d29mr19335282eda.127.1557606425518;
 Sat, 11 May 2019 13:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190511201447.15662-1-olteanv@gmail.com>
In-Reply-To: <20190511201447.15662-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 11 May 2019 23:26:54 +0300
Message-ID: <CA+h21hpB3=SuvYsjsKRKOGDqDcSwG98ExZ2DodwWMUDYQzP+6w@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix a bug and avoid dangerous usage patterns
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 May 2019 at 23:16, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Making DSA use the sk_buff control block was my idea during the
> 'Traffic-support-for-SJA1105-DSA-driver' patchset, and I had also
> introduced a series of macro helpers that turned out to not be so
> helpful:
>
> 1. DSA_SKB_ZERO() zeroizes the 48-byte skb->cb area, but due to the high
>    performance impact in the hotpath it was only intended to be called
>    from the timestamping path. But it turns out that not zeroizing it
>    has uncovered the reading of an uninitialized member field of
>    DSA_SKB_CB, so in the future just be careful about what needs
>    initialization and remove this macro.
> 2. DSA_SKB_CLONE() contains a flaw in its body definition (originally
>    put there to silence checkpatch.pl) and is unusable at this point
>    (will only cause NPE's when used). So remove it.
> 3. For DSA_SKB_COPY() the same performance considerations apply as above
>    and therefore it's best to prune this function before it reaches a
>    stable kernel and potentially any users.
>
> Vladimir Oltean (3):
>   net: dsa: Initialize DSA_SKB_CB(skb)->deferred_xmit variable
>   net: dsa: Remove dangerous DSA_SKB_CLONE() macro
>   net: dsa: Remove the now unused DSA_SKB_CB_COPY() macro
>
>  include/net/dsa.h | 15 ---------------
>  net/dsa/slave.c   |  2 ++
>  2 files changed, 2 insertions(+), 15 deletions(-)
>
> --
> 2.17.1
>

The title was "Fix a bug and avoid dangerous usage patterns [...around
DSA_SKB_CB]", not sure why it got trimmed.
