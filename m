Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBF36265E1
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiKLANc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiKLAN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:13:29 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77C3D9E
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:13:27 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 130so5577378pgc.5
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2aTnXJgxe9dRVq9RmjeXyvcN+WV3pvmOGyDRUxHY7U=;
        b=qHAmONvFxQcpjV2QeHrnnXtTy7XG/c3tRMnFt5HD6TemsCrC+OylJ6Pjm2/N+f6Eqm
         JNOqFp3Une4AT5hpoWvdufSHo37iBU5DWjIO56avnd583UgX7vnUH/qcLswX5prch/sG
         oYDd1+AqJU/qX7UKxAGU+5FT28pUAnDSwRPhGyZLaLxUJ+Q2Je7m/ZymoTIBpFqICVpl
         8kfPJDiYSx9QQ7T61KYeG+LCwHj7bQQ27CMAtd/y+k3OQ2/BWf0raHHwDWsnlej7Ho1D
         pI3I/YtUGf/e4E8XsXuDNyXR/bWezFRvvQno0lb1hpfTQapU9h6qOHa9FB++WcKTseCi
         +CSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2aTnXJgxe9dRVq9RmjeXyvcN+WV3pvmOGyDRUxHY7U=;
        b=DgG6m0oweK840MnPlrVhavd4QplnzHIwSkTh4rt1hZ/9j4onlJhciTBdo3QmElGXq9
         GCRdx+YJ/zK7bFeaSuEKx+NtX6q8+KZCYdVVaYMghz250HOXgjE0eN9syNWokElzNJKR
         G+jTR4CB42h75bMtxWzS62m5ogoHXe6z3GRfEmg/LdVEKoPar+YU0xarIsHK/PdkJH+T
         V64i4CkXL1c2gIyBC35XXorg2H6IQKqvPOtGphqP2L2nVbMIMkxFHaLCZDAHc8z74ixu
         FCSnRKO6eRE1CQ8aGN6D8SElIjZdSUYHkMZe8lve4mLKcd+zguhgfCLspVRTSdtD4toj
         08Yw==
X-Gm-Message-State: ANoB5ploka12HgEw52iHRu7keAo5WiZ+eBtf9tE2agsXvOLCzlYFBx3P
        sWEaCmBjm0KhxeaBwck59utZBJyhD4PvHuri3oo=
X-Google-Smtp-Source: AA0mqf42DzpU68bKwpyIa0Dqx1J5dHdBiZh4zpyKQeSdnLmCuvtvoniTXr5Th1ZAMJzrXUcsDSsMkIxaRHVfGdQfy6o=
X-Received: by 2002:a63:134c:0:b0:45f:bf96:771c with SMTP id
 12-20020a63134c000000b0045fbf96771cmr3743857pgt.131.1668212007132; Fri, 11
 Nov 2022 16:13:27 -0800 (PST)
MIME-Version: 1.0
References: <20221111211020.543540-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221111211020.543540-1-vladimir.oltean@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 11 Nov 2022 21:13:12 -0300
Message-ID: <CAOMZO5BRmu-DFQ9QaPLvKXrDpPSnmK6X2ZA9m+TLXJhKqEj1dQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: make dsa_master_ioctl() see through
 port_hwtstamp_get() shims
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Nov 11, 2022 at 6:10 PM Vladimir Oltean <vladimir.oltean@nxp.com> w=
rote:
>
> There are multi-generational drivers like mv88e6xxx which have code like
> this:
>
> int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
>                                 struct ifreq *ifr)
> {
>         if (!chip->info->ptp_support)
>                 return -EOPNOTSUPP;
>
>         ...
> }
>
> DSA wants to deny PTP timestamping on the master if the switch supports
> timestamping too. However it currently relies on the presence of the
> port_hwtstamp_get() callback to determine PTP capability, and this
> clearly does not work in that case (method is present but returns
> -EOPNOTSUPP).
>
> We should not deny PTP on the DSA master for those switches which truly
> do not support hardware timestamping.
>
> Create a dsa_port_supports_hwtstamp() method which actually probes for
> support by calling port_hwtstamp_get() and seeing whether that returned
> -EOPNOTSUPP or not.
>
> Fixes: f685e609a301 ("net: dsa: Deny PTP on master if switch supports it"=
)
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221110124345=
.3901389-1-festevam@gmail.com/
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Reported-by: Steffen B=C3=A4tz <steffen@innosonix.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for your fix!

Tested-by: Fabio Estevam <festevam@denx.de>
