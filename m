Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E7823BC47
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 16:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgHDOfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgHDOe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 10:34:28 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0744C061756
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 07:34:20 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j9so30968002ilc.11
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 07:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Mz7Dz4HhN27ky7XInjg78tahh1Tb1kaHJSAvyuhPZI=;
        b=i4UavkhNSo6QPSaRE6hxSLJ+6F/G4lelA0CiGp6bzKeEamYkxGdo6G8aSdhcGOknSp
         uSeehMryIFLQ5/PIVFsLEqG0whteXirWnqr+iobjI5jXiKjc9NrLfvjtIzN91su38GN7
         olOEZsjcLwR/KmjJpRx50bJd22OXG7STLBGX7xSwF1qV+fhvBDs/YKKRfbimFfuryCjo
         g8v3A7eCk+EzfiiAccNp67TYeYs5OQ16gEXyTYt60Fojyz7b6VZjBBziTGGrQU8lNS1g
         /UBJjy+AeEPaxczip54KE84qJz1JHuHP/3ck1Z/mUxsMLp1tiWkDsUxAG/hWi0usSIW6
         B56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Mz7Dz4HhN27ky7XInjg78tahh1Tb1kaHJSAvyuhPZI=;
        b=K+KpfGdIRg/kz+ECcrJlm/fwBofxocAkhT7HPtQQHBhBBuyyMjdPqB5RAJHlmM9BHy
         Jjk4aG4Xh1d6YM5QhDzoLFfsQiWVF4nWK+SsJv+3GkVkx+94W3WGY7uJGfQIxOU+5Ght
         B53qJoTotVOO1J1KRiqzJKhoayg0mTc9aRvkImQGTvHJsGO0V1ccY0V7HmhlehODpPX+
         g2jgK8Od8/7i615X4lmpZf5DM3kjmAUxdk4wUcedOe/66q+UPOed5M9kjgPIlsWBXuse
         Mf9GnuumqV0p9qz8K3Q8O6y3Wnv8ojUyyzQ92czjfG0hY+U+J3l/sNSqrQppeV8M1bml
         DhJg==
X-Gm-Message-State: AOAM533MXVTKmtW8mb6ktOekndXTXpV9CRa6YtIdwrY5KmMxeFCwpakn
        9tmaLVlplHCjEaeMIWYAYqN/zmb8lehD+L4tP/HjDw==
X-Google-Smtp-Source: ABdhPJzvAOv2+6wj7DYgW/bjoRT1xIlwrACuCpPpw1/wcu+H/Ta7pklvxHWABPSeHi1fkpXgHfcXMfo58Lf9XiTcPz0=
X-Received: by 2002:a92:d781:: with SMTP id d1mr4625475iln.68.1596551659736;
 Tue, 04 Aug 2020 07:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <1596541698-18938-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1596541698-18938-1-git-send-email-linmiaohe@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Aug 2020 07:34:07 -0700
Message-ID: <CANn89iK_NVBWwT4QNrb3EpahG3zOQS-Dh68Qdhrm2_xAs7Yu=Q@mail.gmail.com>
Subject: Re: [PATCH] net: Fix potential out of bound write in skb_try_coalesce()
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>, martin.varghese@nokia.com,
        Willem de Bruijn <willemb@google.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, shmulik@metanetworks.com,
        kyk.segfault@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 4:46 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The head_frag of skb would occupy one extra skb_frag_t. Take it into
> account or out of bound write to skb frags may happen.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Please share a stack trace if this was a real bug spotted in the wild.

I do not believe this patch is correct.

if (A + B >= MAX)   is equivalent to  if (A + B + 1 > MAX)

Note how the other condition (when there is no bytes in skb header) is coded :

if (A + B > MAX) return false;

In anycase, please always provide a Fixes: tag for any bug fix.

Thanks.
