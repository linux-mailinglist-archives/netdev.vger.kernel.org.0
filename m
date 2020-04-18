Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0821AF238
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDRQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726235AbgDRQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:20:48 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8358EC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:20:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so5228488ljn.7
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cYbzHn+cl/PqqlcXXl2qKnMwhYQ3Ap7Dxd7g+1DAPsQ=;
        b=pzelffpasQgvEi5YyDyWsk4OfN0U/6Qsykp04vHeHBrKX0mvEl7jXuEvTAbkDkxpfd
         GG/S0K3dwKas+UE17lPrJUwG9u+5YDHiXi94G9mF+aoaId9BJVJcmXr/RLyXFUgzaX3r
         uLTSyXD77gdOn5mY0kuQZoW0/6WIyqRgvtvPmWNeaRBbbcIPzQl5V3udVUkUz0trZWq4
         WimQrzlDGpQQaBuIFiG/OD76mcpUVyHGOQlmWWq1vr3E/mvYqdqfY/UpYRZEIaajeo5l
         G60sn56cr+H1Aba5LrhrIEHpOhEiHH43X9/UFezCEnxwZTKqOeSB1ACD6mhRbjMIJZTF
         wNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cYbzHn+cl/PqqlcXXl2qKnMwhYQ3Ap7Dxd7g+1DAPsQ=;
        b=D9iQg9VRAutqL17hQeml+QN6Grk98wu1cMNKi09vJQBvjhdlplwB/bt/nPWGYmK3B+
         AqvUs1iNwiGTN0KZJVPJgeluw94A46L6xaV8pZvNYD1A2livnjla5AOo0NTlkeSMCYUF
         DoNxVk9qdejiBS08Hwgb3ztlhLP7gnG16KBlUNB2AyolD0ntF45+FroQhTPYdiphHyFM
         fQX/38vy7KlN3CUcNEM2uu4XQ9ONaVJulQ3YxiCrERu72m56FgrU4RZX6A89ctdgzlnP
         uCTbTRvuA5NABna6jxw72C8Q/4uv9ChFlgF0QpiDMIT0oCmTw6dAjTB7Xf4ujXACjpG6
         jlJw==
X-Gm-Message-State: AGi0PubVKjuR3lqn9Un6fYIeHRMlH/tmR/yrB50WzLRoKnnE8uuF96Wr
        09HPhEoB3vI2zAD+bMDov6JWz/VO21/yC4Np+6I=
X-Google-Smtp-Source: APiQypLYoaf4lW4cOfarpF7OdQbjW8KXznVlL0pg3QCJLnox9HXI70pH71Ozwg+lJZlqL5iQk+416FCtDMcHMcRfi88=
X-Received: by 2002:a05:651c:30b:: with SMTP id a11mr5110127ljp.164.1587226844237;
 Sat, 18 Apr 2020 09:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200418000355.804617-1-andrew@lunn.ch> <20200418000355.804617-2-andrew@lunn.ch>
In-Reply-To: <20200418000355.804617-2-andrew@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 18 Apr 2020 13:21:15 -0300
Message-ID: <CAOMZO5ADZ3JaR_=Wvso+9zX7H4xafowz4L_dTUyRAw2ma-X6BA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: fec: Replace interrupt
 driven MDIO with polled IO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Chris Heally <cphealy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 9:06 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Measurements of the MDIO bus have shown that driving the MDIO bus
> using interrupts is slow. Back to back MDIO transactions take about
> 90uS, with 25uS spent performing the transaction, and the remainder of

Nit: please use 's' instead of 'S' for seconds.
