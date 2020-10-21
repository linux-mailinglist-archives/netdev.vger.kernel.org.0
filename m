Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2145D29460F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439674AbgJUAde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410972AbgJUAde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 20:33:34 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A7C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:33:33 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y20so861733iod.5
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=51goe9OOqirZz/BXcXOYYCx8lxrd5W9DOj8iSTGDf/s=;
        b=k3pFFnR0WMMuZ91S+BQBszk54rGxtbJCHvZgD3dBIbTpAK5gvfkPFDPhCjScTGajvM
         afUP+F2HIHHsl2I3ZAFHKqyRzn1Ny9bnwtMeoEXibm5RtDgnugM2zSGv/sFBOOyypyRD
         Y3/CWCc9fBIKygqFEo+WBipkM3lqKXyI5rsB54XZu/6u8qhVnEbUkcGnTem/kpMK6oD5
         UIMAuS03PmdwPOFLmrjVrTZW5MMWZfjHrUmsRYKYMgRaqCjDrKKbrfxldSBCaU4aq2OS
         /VzyeHKH7qoe8gWi8zR2pBZso7vXuTdP+YqP+YqT/YFxdbvlvPkl2Lm6FuqIWI9ijVUV
         Px+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=51goe9OOqirZz/BXcXOYYCx8lxrd5W9DOj8iSTGDf/s=;
        b=WPWOrE/Xq5nNnSSlpkHkrjTKJXfquB813epq+1eIMN8ovB4WouW1vU4WalSqXMieE6
         z/tLXMt49Hdq4BLT1nYC5880UexfbisX5UP1wnMFz60bGQ88XfkPEoEPPerB04e0j0/6
         dymg644v2vuR+WfQZssLbsXF50hhlxTG7cJRk+UacChOIt0LmekHhgdPgrOz1TOi6dxz
         Dlyg4ajt4DnyjYFXyqKOfTAlJhofCK55W2zfmSDaWE4kkO5bbVtRR617eaz8ur/QT2kR
         KScNHh4l0yjHt5zXks6YYMxqJoAhTr9/I9CbXG3yKeTu6guncqit70M1sXelFlGPsZ9j
         vrFg==
X-Gm-Message-State: AOAM530z9//o3Av0Kk8UrrZz0kpZOrPN4siFyNYsg9kYX20XNpwIZ/dO
        OxO4desx4CyiDJkF48pYtlzXvPwnUeEogkpnQqWzbqc7lNTrFA==
X-Google-Smtp-Source: ABdhPJxwL92nuFMpJizJcvvNp3ettaHPK013+xHZ6mipGrCwD/nLSFZotD6NAP3w4/ONye9I3wkCQf+QMrqfAO0bM8I=
X-Received: by 2002:a6b:3c14:: with SMTP id k20mr712681iob.12.1603240413159;
 Tue, 20 Oct 2020 17:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <36ebe969f6d13ff59912d6464a4356fe6f103766.1603231100.git.dcaratti@redhat.com>
In-Reply-To: <36ebe969f6d13ff59912d6464a4356fe6f103766.1603231100.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 20 Oct 2020 17:33:22 -0700
Message-ID: <CAM_iQpWk_x6j7Ox=u8Om=dnrKUwU7zDpDghW3LExQLf0+8pL6A@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_tunnel_key: fix OOB write in case of
 IPv6 ERSPAN tunnels
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Shuang Li <shuali@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 3:03 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> the following command
>
>  # tc action add action tunnel_key \
>  > set src_ip 2001:db8::1 dst_ip 2001:db8::2 id 10 erspan_opts 1:6789:0:0
>
> generates the following splat:
...
> using IPv6 tunnels, act_tunnel_key allocates a fixed amount of memory for
> the tunnel metadata, but then it expects additional bytes to store tunnel
> specific metadata with tunnel_key_copy_opts().
>
> Fix the arguments of __ipv6_tun_set_dst(), so that 'md_size' contains the
> size previously computed by tunnel_key_get_opts_len(), like it's done for
> IPv4 tunnels.

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
