Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2416AB799E
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390384AbfISMiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:38:00 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33441 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbfISMh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:37:59 -0400
Received: by mail-yb1-f193.google.com with SMTP id z7so1275544ybg.0
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z85Oyni0CpEVigwWdCOjybdwY5gXYpX/aFcnz7x43/I=;
        b=ilkm10dghz8ixQn9dBliyKKXTAZlnzfkmItnNupps6K1cv+CICCVERFEvFIs1pqIjK
         WhJynH4SH/5Bp1jdRR8viRBXCsml47ZM7gaWRCd1RiPkNolEu3Q4xtBVTQMflfagst+m
         mJwJXuqNpYeqfh4rAps9hlmF+OThxaMHsPbqInIkhl06ByEyMoUFl7OU98rNb0w3Y23/
         sPpoOo4giOpSp9DXi3JFCeAbBMEZcmjVIbM1NBItls5MR1Coo1WxfRG/Ld3PZ8l4g5Ag
         /GAAR/2KffA3294lWimOIMjANDSTiOnR1t4CwEvpM0h6W4IJl9d8y/afD6fGyVk2r7gZ
         glZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z85Oyni0CpEVigwWdCOjybdwY5gXYpX/aFcnz7x43/I=;
        b=tiuRCGmYzdK2OHlkxBcER0F6c6lgbJcTqrr5ivZsDwHIDX5HB9fWjKKgHHBZgrtniF
         Rzf8MhpMSALeVzJzCnSAwuxPa0Y2uwgCRqF9Jo1UQa7KZ8IQ7GyyM2EoUNXsMwu3OR8O
         LxwDlDz2ZQNj5mQ134q0k4Ovp2+3XqvZoqbrh1uKIiQLEoXF7zEPhqDbBTMH/Pdem11H
         KqdFzsflpknggd9wZU2cau4FDa9FZGA7kTTOr+yURrPUwb+hqnimrwQumCHEJrFUCujb
         4JCs2JJUlHDBovFiA6mRONlv9LxS5sa1vMZJ55+c5d+3JzRfqLcZ/cTBUFMj1U8/NY5L
         V39w==
X-Gm-Message-State: APjAAAU/Yg5aqsUFk57mZZK9UbIAk7VJkwRlrxEBs/gYr9+gD7bYeSxp
        gMVC30adMnsisVCt/a5TT66uah8NR/bGR7lVnfU=
X-Google-Smtp-Source: APXvYqyFfs0jqMEW4fhPqs5kkdxOCX9VfllYy3SBE3TwhObReznmQJML2ANjSFXmM4hTAzO/qUTgBDai9o/JQ0Fy3ZA=
X-Received: by 2002:a5b:44b:: with SMTP id s11mr6204095ybp.97.1568896679035;
 Thu, 19 Sep 2019 05:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
In-Reply-To: <20190918072517.16037-1-steffen.klassert@secunet.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 19 Sep 2019 15:37:47 +0300
Message-ID: <CAJ3xEMjucmc-6k=kvEp99uZbCA50tUwPMK1z__wAG+ah7qNzsg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 2:48 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> This patchset adds support to do GRO/GSO by chaining packets
> of the same flow at the SKB frag_list pointer. This avoids
> the overhead to merge payloads into one big packet, and
> on the other end, if GSO is needed it avoids the overhead
> of splitting the big packet back to the native form.
>
> Patch 1 Enables UDP GRO by default.
>
> Patch 2 adds a netdev feature flag to enable listifyed GRO,
> this implements one of the configuration options discussed
> at netconf 2019.
[..]

The slide say that linked packets travel together though the stack.

This sounds somehow similar to the approach suggested by Ed
for skb lists. I wonder what we can say on cases where each of the
approaches would function better.

Or.
