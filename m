Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C418614A
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfHHMCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:02:54 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44728 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfHHMCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:02:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id b7so67248211otl.11
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 05:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ok9mLnOKFtXZBpSGud2dejp7d1jDOoe9Rwc5KBzs9Tw=;
        b=vFNtyN5xGye1n5v7sQUOaeKwEDK0hjGOvJmetZjpSJxDGdtlSnNEfQFtYZDKgxeOJ9
         uJhvQNpD4xbKzljcNGvv01dYXHNNy2U01Zpa3COjtSWvIGRWFxIomW0FCpX+ASO/849n
         YPx40OOQHhm9z6JVM8/OSybTF9k74T1gG3Y1ZhnrwpFViCRiyDFw+pwqH2PrFosGnIp1
         19DrkvX8G+QEC3I4fO/uXxVPswKox43P8UJ/B7gVlza9gpk4C6W7g+RBlDVc8RoAbYyK
         K0EJtvDzXy5ollN+vkkNR8m34hVw/BVfU1iJ1Fvri1GEpTIty6V2m/pAfdGeOaGSJvDt
         olgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ok9mLnOKFtXZBpSGud2dejp7d1jDOoe9Rwc5KBzs9Tw=;
        b=SoNgLnRA4aBu/RrNNrYPgekEA08zcUKUAfDcJVhaPAtaF9f8LsAGHcq70qfsAH6IBF
         mTJ1/gg3LXMDIfHdZpEjuUSEUl4JQuRdQy/Y6pHBJwYzWZViBNJplcQa1jUhsBRh25/H
         YYaG+ioQBuA3hn7nAhH+HBNWFI7yZ0tDhXzoyVGMtzn3ym7K4gABx6vEprs5t5Clazxw
         XKsML2VcWaW+KXVzAp0yEac2Z1Y89HWW5O5wsZjOpApjsP4DfTOfyhInVTqZsGo6i9QL
         koDa/IDm53V3r7ulD1TjZnw6dArq4UQ3kvVXwakVGmPcAIpdzuYoB/LgS17/659PekFM
         OZXw==
X-Gm-Message-State: APjAAAXkcc2fFrHy1vVi4vTo9sqjwzVO6yORNYtADZFUvYj5wP1RdYoz
        tXn8kKjMqlvYhnqHMPGKIplG0QZYrMaGXRYHTOzJcg==
X-Google-Smtp-Source: APXvYqzh01K9SSu7hkyVCoCjURbV9brDg3HgoMcaopGEBxT18PZc8ePWtlte5n8pdOhjnt+xyE24guthFX8edkEaMeI=
X-Received: by 2002:a05:6808:4d:: with SMTP id v13mr2229390oic.22.1565265773146;
 Thu, 08 Aug 2019 05:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1565221950-1376-1-git-send-email-johunt@akamai.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 8 Aug 2019 08:02:37 -0400
Message-ID: <CADVnQynyZoUqC4YK75Vp7AsvamahsGYU02GqwzB3y0Ooik8=pw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] tcp: add new tcp_mtu_probe_floor sysctl
To:     Josh Hunt <johunt@akamai.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 7:55 PM Josh Hunt <johunt@akamai.com> wrote:
>
> The current implementation of TCP MTU probing can considerably
> underestimate the MTU on lossy connections allowing the MSS to get down to
> 48. We have found that in almost all of these cases on our networks these
> paths can handle much larger MTUs meaning the connections are being
> artificially limited. Even though TCP MTU probing can raise the MSS back up
> we have seen this not to be the case causing connections to be "stuck" with
> an MSS of 48 when heavy loss is present.
>
> Prior to pushing out this change we could not keep TCP MTU probing enabled
> b/c of the above reasons. Now with a reasonble floor set we've had it
> enabled for the past 6 months.
>
> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> administrators the ability to control the floor of MSS probing.
>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Josh. I agree with Eric that it would be great if you are able
to share the value that you have found to work well.

neal
