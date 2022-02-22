Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A384BF726
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiBVLWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiBVLWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:22:30 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AFFF65C6
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:22:05 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id q9so15240261vsg.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNrbVHrFKQg2EOJ3Eg+FasrQkGTaUvfXva+BB10TxU0=;
        b=WwxdpND6tXq041ZtPbppaCbY0ezFe4nYHg2bFpCn3odIeL0nBc69TaT0wnYtqxGWJz
         m0RV9jIjKDRFgdah0Xxycopgzpk2XUhQd1gfdZ1E2LTLlaNZEyiH2ztwscahFyQh1dic
         SZYOctyE8vsdFCnSfmQbgowRVJ27CbNiMSU/3n99h1Xkb/a0h07ngSoJ1TlNGXC7h5Q4
         xPs1KbTB1sAq5iRnmRL6f+3cwdhHLXPeHMFecD6mylNYNijRXwgU0f382ZGIlRDimt2S
         Zm0h65LDRNP7VfpYLjcynHNEvju+vRC3gJISTlJMfRIRDCa+6fhW+BbjmguvmMBLbO6m
         pgEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNrbVHrFKQg2EOJ3Eg+FasrQkGTaUvfXva+BB10TxU0=;
        b=FJgsu5AjNBvzGRRawCC2C6woSrkzOzH4II4Mc1b7Ts59PT0ufZJpbf8smg1VApiCa4
         qzO/D39KZQiWX7oy+mnRy/IV1nV4gYPzY5K5B8VVymK8MGV8rF53fGxLrPq8MuFfPud0
         VSuQCsbfasdKT+79hAttL0XqI+zA+ZZ/RqM86mPZC133EGdmukfXxBAj4cTK8dtJqe+k
         yz5e9dnQkq0a+n2s8H+aGO3TkMMbnkSF/skGpdr0nltFOuDU6KL+xXvboHsH/sc1mC2P
         FsmBe5/jlRLnM8isTtMplIivrjXZ1iowWAFMEQDPJCr4FimuWLrs7NZyWjxf78MN45rc
         uKaQ==
X-Gm-Message-State: AOAM532El0sHxh3sx2ZoC444PW5G1UGwslMrgqs3NSZ548YSraxP9XwF
        /0Ol1aFMu+grsRlECw6FHq3SSY7rK1CfVKAiPZlsgeu3+HU=
X-Google-Smtp-Source: ABdhPJyuzdf0di/Kmp/cEUefdeXBe/7+cgPW0fkDQ8EWGLX9HIaOj9zlneBt97i5wK/fEJ80zuJAgoMEF+4FplWV294=
X-Received: by 2002:a67:d29d:0:b0:31b:82c5:9718 with SMTP id
 z29-20020a67d29d000000b0031b82c59718mr8916426vsi.27.1645528924672; Tue, 22
 Feb 2022 03:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20210224114350.2791260-1-olteanv@gmail.com> <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
In-Reply-To: <YD0GyJfbhqpPjhVd@shredder.lan>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 22 Feb 2022 13:21:53 +0200
Message-ID: <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast
 filtering for the bridge device
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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

Hi Ido,

On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The bridge device currently goes into promiscuous mode when it has an
> > upper with a different MAC address than itself. But it could do better:
> > it could sync the MAC addresses of its uppers to the software FDB, as
> > local entries pointing to the bridge itself. This is compatible with
> > switchdev, since drivers are now instructed to trap these MAC addresses
> > to the CPU.
> >
> > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > works for VLAN-unaware bridges.
>
> IOW, it breaks VLAN-aware bridges...
>
> I understand that you do not want to track bridge uppers, but once you
> look beyond L2 you will need to do it anyway.
>
> Currently, you only care about getting packets with specific DMACs to
> the CPU. With L3 offload you will need to send these packets to your
> router block instead and track other attributes of these uppers such as
> their MTU so that the hardware will know to generate MTU exceptions. In
> addition, the hardware needs to know the MAC addresses of these uppers
> so that it will rewrite the SMAC of forwarded packets.

Ok, let's say I want to track bridge uppers. How can I track the changes to
those interfaces' secondary addresses, in a way that keeps the association
with their VLAN ID, if those uppers are VLAN interfaces?
