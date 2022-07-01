Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B50A562CF9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbiGAHrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiGAHri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:47:38 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BA06D55C;
        Fri,  1 Jul 2022 00:47:37 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r20so1976398wra.1;
        Fri, 01 Jul 2022 00:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rE1S3qn0emq5PHeyf06ryXxWn9nDP2udjWAGP9EkRNo=;
        b=BMpIS/AaZ9mkwnYvWb3YzxD0SgLPv4RDjO4ZjZ68DxdKRYIPZvX7D1llnsstpspp5y
         QRTl5h6L82kz0B7VA5xK4BMsaNkPKH8zZ2Q22S7x0vimgRfWwyRH/hOjx60fc46asqpi
         p14SJ39A/qE+J0Oy7e2P+OJMI3KnWtoUXuu9XlQLOSk4BNukgDSnrBH8ejE3pxNkraIR
         jQHAp0LvwIoqzVeu7/tusfwe728MogKFHRQaOYEFvothlAGkgK40MrbrVMzOiCblDDew
         gRuQPnTCmis86h5fCBz2Z7CsSNCCDO1W+KAQNudMIWaXMJvSBh/xHpRe9FrdKbS5ySAb
         4t8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rE1S3qn0emq5PHeyf06ryXxWn9nDP2udjWAGP9EkRNo=;
        b=tuhq1LeIWx7991O+rUOcMUke1apghdjeVSlCB1sgEyHFUf+OIAqd4YGOE3RmsfJYuO
         nrAIi5rlDpmTuE6hDTjHnNJp/I2ip077OvtSDx8R3qzpzFtxqq0ar/9DjWA4C1neb/Mn
         8BQO1MTD7vlw9FV9AIjcIxn6YBt5k5CeVGJL7XG0aL5ZXOsYSDGoZ3gVYDFdmA0bjoz2
         LYrQ67udBgXr6eXsmJ5+8ROEHznoqH8hoUXSV7LgNAmZMuMhpdIJwuMWNoydeVPQ9NV/
         64yrTefQC03IccZnZY+QSeha7ceH3UfPoYN8GNQuPfVtLQZKukWNm4T084OIvvwufZyy
         6pjw==
X-Gm-Message-State: AJIora/79jcVQ6CiXfyBryU3sH7mlaqKta1GOSVTB11Nxz32fKhmkDKQ
        FY1Y9dvmLIezyv38JrDPYem/6neNCAsfDhJNsyY=
X-Google-Smtp-Source: AGRyM1vMgSEumJ6nKjvQL9aVDdXHVXvXN+AuFrw+YNtzVT3c21tagadSTR1PTonOtKu3v/pKrXHd9ybscKGAIwd1xvI=
X-Received: by 2002:a05:6000:12d0:b0:21b:a248:9a2e with SMTP id
 l16-20020a05600012d000b0021ba2489a2emr12784441wrx.437.1656661655797; Fri, 01
 Jul 2022 00:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com> <Yr2LFI1dx6Oc7QBo@shredder>
In-Reply-To: <Yr2LFI1dx6Oc7QBo@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Fri, 1 Jul 2022 09:47:24 +0200
Message-ID: <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Hans Schultz <hans@kapio-technology.com>,
        "David S. Miller" <davem@davemloft.net>,
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

One question though... wouldn't it be an issue that the mentioned
option setting is bridge wide, while the patch applies a per-port
effect?

On Thu, Jun 30, 2022 at 1:38 PM Ido Schimmel <idosch@nvidia.com> wrote:
>
> On Thu, Jun 30, 2022 at 01:16:34PM +0200, Hans Schultz wrote:
> > This patch is related to the patch set
> > "Add support for locked bridge ports (for 802.1X)"
> > Link: https://lore.kernel.org/netdev/20220223101650.1212814-1-schultz.hans+netdev@gmail.com/
> >
> > This patch makes the locked port feature work with learning turned on,
> > which is enabled with the command:
> >
> > bridge link set dev DEV learning on
> >
> > Without this patch, link local traffic (01:80:c2) like EAPOL packets will
> > create a fdb entry when ingressing on a locked port with learning turned
> > on, thus unintentionally opening up the port for traffic for the said MAC.
> >
> > Some switchcore features like Mac-Auth and refreshing of FDB entries,
> > require learning enables on some switchcores, f.ex. the mv88e6xxx family.
> > Other features may apply too.
> >
> > Since many switchcores trap or mirror various multicast packets to the
> > CPU, link local traffic will unintentionally unlock the port for the
> > SA mac in question unless prevented by this patch.
>
> Why not just teach hostapd to do:
>
> echo 1 > /sys/class/net/br0/bridge/no_linklocal_learn
>
> ?
