Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7664C845
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 12:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiLNLnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 06:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiLNLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 06:42:55 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F922252A7;
        Wed, 14 Dec 2022 03:42:42 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kw15so43796946ejc.10;
        Wed, 14 Dec 2022 03:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fb4eoBXDusNp5heiH1+hwpgm6R6EZrtNaJCa9LS6HN8=;
        b=B303LRYBThL4Qe3QgL5ho6c8lwDE632ct4nIvxxdARWXdDF1IjktsGlLoj5m/N+vEl
         wyWHjQ2C7w9UpR7K26OhFxnmv36bS5jq+YbvCJ6/UVHXDXSuH+WiG9YRikBVXw8RxkBm
         oKX8dgcO25YXKi8Dc+FDshziTUtxSDzJcNZLeXkcOlfC2H2FOl2QBCh/wl5kcp83gtAo
         NeVxL8g3KnvGMbnMMK4eW1ST8ayZAIHaDr2zdNdGbASOhg3m3qj7zV6mmQ8DSnxG+asc
         wc/w42DfzXlpKSuvQjSU/JP5fINg21rugD70YxYBlQNtK1HXd/Qpamv5tUN6L+aVDiNK
         hapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fb4eoBXDusNp5heiH1+hwpgm6R6EZrtNaJCa9LS6HN8=;
        b=fIa4iyFux3N8nssVwcfXGkmnjNpKbnAwiYOeLyOx/u9ZLk2hQPsYHN3iBr7CVT8HG+
         9IJNl6VUo3mz2jZT3SbmJNPawKY9mJoAjlVty50V0/IIVZ/mt/9t6oBuow96SSmd8tzD
         slKynx7g5oK57HUeAU3ZGDhXC44d4SntFzCuIRBZRo7WUVrb6viha/pYeubh8sxox710
         Tjv/g1pZblOluaAhK49OGxfblOjtt4Cetl8FF6WwGVG6kGMtL9vmZ3v3ZxT7IERVKPzZ
         hXry+u5xT2fi78yfj7PumtdTImmbVMb2OmnrU/WkKAuAzQipcU+RLG1wRrLFrHUnOoW0
         tn0g==
X-Gm-Message-State: ANoB5pnb6gpAIQvYPPB7+zJEoUYmjqHHObotVAXHMFXPC/LDS8LWdrna
        NKEcRcXX41NGiO8LIG++UgA1OCNxKUDa6GV08eo=
X-Google-Smtp-Source: AA0mqf7GzwVsCvg+Gr5un5dC3XkX4W0lgsyKzH1bUu1D6C7Q6LSFtxyBAW/M6MLXg5UR+BWvs7E3aVQ2xhOhgoPa4K4=
X-Received: by 2002:a17:906:34da:b0:7c0:f2cf:23fd with SMTP id
 h26-20020a17090634da00b007c0f2cf23fdmr16686137ejb.709.1671018160720; Wed, 14
 Dec 2022 03:42:40 -0800 (PST)
MIME-Version: 1.0
References: <20221213225856.1506850-1-bigunclemax@gmail.com> <20221214110359.y4kam23sxby7vpek@skbuf>
In-Reply-To: <20221214110359.y4kam23sxby7vpek@skbuf>
From:   Maxim Kiselev <bigunclemax@gmail.com>
Date:   Wed, 14 Dec 2022 14:42:29 +0300
Message-ID: <CALHCpMgL-GQQQYMRii8PUkXVw_4Hit7MAUF+DsvAaT6eFPhtsQ@mail.gmail.com>
Subject: Re: Subject: Locking mv88e6xxx_reg_lock twice leads deadlock for
 88E6176 switch
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     fido_max@inbox.ru, mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Thanks for the quick fix, Vladimir!

=D1=81=D1=80, 14 =D0=B4=D0=B5=D0=BA. 2022 =D0=B3. =D0=B2 14:04, Vladimir Ol=
tean <olteanv@gmail.com>:
>
> On Wed, Dec 14, 2022 at 01:58:55AM +0300, Maksim Kiselev wrote:
> > Hello, friends.
>
> Hello.
>
> > I have a device with Marvell 88E6176 switch.
> > After 'mv88e6xxx: fix speed setting for CPU/DSA ports (cc1049ccee20)'co=
mmit was applied to
> > mainline kernel I faced with a problem that switch driver stuck at 'mv8=
8e6xxx_probe' function.
>
> Sorry for that.
>
> > I made some investigations and found that 'mv88e6xxx_reg_lock' called t=
wice from the same thread which leads to deadlock.
> >
> > I added logs to 'mv88e6xxx_reg_lock' and 'mv88e6xxx_reg_unlock' functio=
ns to see what happened.
>
> I hope you didn't spend too much time doing that. If you enable CONFIG_PR=
OVE_LOCKING,
> you should automatically get a stack trace with the two threads that
> acquired the mutex leading to the deadlock.
>
> I've sent a patch which solves that issue here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221214110120.33684=
72-1-vladimir.oltean@nxp.com/
> I've regression-tested it on 88E6390. Please confirm with a Tested-by:
> tag on that patch that it does resolve the deadlock for 88E6176.
>
> Thanks for reporting!
