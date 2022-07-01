Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A563B563766
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGAQHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGAQHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:07:23 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBCB22BE6;
        Fri,  1 Jul 2022 09:07:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r20so3913046wra.1;
        Fri, 01 Jul 2022 09:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHKMope5SWjzop2Rp2Epmmp+QmZit+SL7styTSQamZY=;
        b=cRRLhPkA26KHCS0gtvJXn447hDg4hRDT5oKadmE0G58kf6IdaSYc1buPIirB/Blm+H
         bVU6AvPAFeGP+2Zsv2TIQaeOskpNDYvxUMLd30+e1rWqJK1XxnEmbGkzDOxOchJd/VIH
         xZKWBKD0He04ZcEFAPOhPCvGhYx9w5ONil9zZu148QunDcBxDXctq6HkqU2yqD7GEOs/
         w9ih4spSeU9JtlzmQkpDR0LmtgiswNebBF/A+7yc7I5HAis+v6a4ykAtPgs/V4evTugq
         DJMXJeUJStNwWwyVyBWBuP0lEenR74t52c7fjmNRXvUafpRZbrJ3aLsYHyf1fTU3vAhq
         6D2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHKMope5SWjzop2Rp2Epmmp+QmZit+SL7styTSQamZY=;
        b=KcmXvMwiEW0YFX7QJuc+eeoGtQ/4ZSE1/Q6WLGY+dZhta5dERFXKWjpXhLp9R8p7pa
         44XnsieCqybLkAr5JqvRjYpuciEKZCkAWRicswADUvF4RQaKmUjHO3xCsaEYM0tDukX/
         4yOp0Vpk4+gL1u6wKjRT8CoVAMN0KjZPiVsezHUS1QW3L4UCKysoQZjXzeLjF5eWYDHa
         peEinHSafz2J9XsSniztBx1QRDMtZ3/RQPaZtIMwN0ZnS4RkXDHj7GQy40jAV+fWTSUf
         u4GmMz1Cn4Jlt6AmID4hB4CZJFjuvLO2W5gtg3w/RujeWqsHcHWvzhrc2TRKm8UKypYx
         hmqQ==
X-Gm-Message-State: AJIora8+LUp6WilsIhrv8vUxF34TvrupX0Uu+rW2TVlHS80sjcVZW6ey
        Nae93vGE3sbuZIuSH79jykJFI9hiyUT6RwQPYHA=
X-Google-Smtp-Source: AGRyM1uldNpApaYepYj4cywZLC25EKKS3tiGxNTcIgJvCeFs2LW2RPgQ8/DwRpMTtIk5voB+JRx3hUC1k+/T7SYJ90E=
X-Received: by 2002:a5d:4c90:0:b0:21b:8b2a:1656 with SMTP id
 z16-20020a5d4c90000000b0021b8b2a1656mr14427680wrs.249.1656691641354; Fri, 01
 Jul 2022 09:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
In-Reply-To: <Yr778K/7L7Wqwws2@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Fri, 1 Jul 2022 18:07:10 +0200
Message-ID: <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is several issues when learning is turned off with the mv88e6xxx driver:

Mac-Auth requires learning turned on, otherwise there will be no miss
violation interrupts afair.
Refreshing of ATU entries does not work with learning turn off, as the
PAV is set to zero when learning is turned off.
This then further eliminates the use of the HoldAt1 feature and
age-out interrupts.

With dynamic ATU entries (an upcoming patch set), an authorized unit
gets a dynamic ATU entry, and if it goes quiet for 5 minutes, it's
entry will age out and thus get removed.
That also solves the port relocation issue as if a device relocates to
another port it will be able to get access again after 5 minutes.

On Fri, Jul 1, 2022 at 3:51 PM Ido Schimmel <idosch@nvidia.com> wrote:
>
> On Fri, Jul 01, 2022 at 09:47:24AM +0200, Hans S wrote:
> > One question though... wouldn't it be an issue that the mentioned
> > option setting is bridge wide, while the patch applies a per-port
> > effect?
>
> Why would it be an issue? To me, the bigger issue is changing the
> semantics of "locked" in 5.20 compared to previous kernels.
>
> What is even the use case for enabling learning when the port is locked?
> In current kernels, only SAs from link local traffic will be learned,
> but with this patch, nothing will be learned. So why enable learning in
> the first place? As an administrator, I mark a port as "locked" so that
> only traffic with SAs that I configured will be allowed. Enabling
> learning when the port is locked seems to defeat the purpose?
>
> It would be helpful to explain why mv88e6xxx needs to have learning
> enabled in the first place. IIUC, the software bridge can function
> correctly with learning disabled. It might be better to solve this in
> mv88e6xxx so that user space would not need to enable learning on the SW
> bridge and then work around issues caused by it such as learning from
> link local traffic.
