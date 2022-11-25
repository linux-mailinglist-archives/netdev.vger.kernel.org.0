Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E74639007
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 19:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKYSoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 13:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYSoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 13:44:07 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D20C1B79F
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:44:05 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g10so4682931plo.11
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFUcQ3hLuxafQYtxQnWs87DdE99a3mWHbnJqXUnaU40=;
        b=wJNS50eWgo70qBzwRJ/eacnPCkagYxdtrqNdFD4nfBt0ByVzB1jHs4I5dSd7W/hRlV
         XLAEIcyFK1c0YL3L1oqAuONU+7aF5NIHAIWAFc/UoPvh8fGWv8DU+nDyugqquQphVyvy
         mZABavgj6fEQ9KleIjLsKS88R8uRtrMJPlde1PWmnrp1JLlbdjF12SwrSyZN0pRoGlrv
         /Os3aKcXhKKm91745O+g/S8vJk9t8X2eCEWZ6Rfxvjdgw3BhUKoKF0v8KOm8HFZZNMFU
         1Cce1lG+UBgDXqirKs4LEddhvaXFYG+kvCfyImLrnlMPxeu1GvJASeqKrpq/mYrOI6iR
         MUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFUcQ3hLuxafQYtxQnWs87DdE99a3mWHbnJqXUnaU40=;
        b=QZROZCzG7uDdJTsALC3ZsgehFn9sKH7zpJXrgODdQ2feBbuTDmRHbS+4draHPcD6US
         9CqK0KO0T+pOIuGhIcIChTQmc4dt3b23djYFcB4HmaPWKUO3pmcCKkCeDmag9938rJbf
         2UZf9bdRzNyToHnEssYaxZlpibL3uJqDVCOVJC1cI5Pj25wvDwun3kgtW1Mhm61cr8YS
         yOA6WqyRqaP5d/sAWlFSbJZA7/viGdh1FBbXZ+GY0roQz3jPBYoqihN84O3axyh7vXsK
         yUTQpHfUKQkSy/VJYMWhxzmokxzZr4Dqb4IXqJ4kVqQ/6uYscRaAs+vicJpQMCNO4tw4
         hLrw==
X-Gm-Message-State: ANoB5pm8lnwMeH478ZGLnUqd0XkxLdxQ6oRkS1nLwe4rCcBEQlqJ+C7e
        Cv8gz4m1GYNWoZvFMcT81sQXPA==
X-Google-Smtp-Source: AA0mqf7dGVW4MXOGlUxRKNCXMQzyzk240b9VEqd1QcNaooVXqjFTk78T7hsrfzGxsU2Jndumrs3gNA==
X-Received: by 2002:a17:90a:c006:b0:219:158d:b19a with SMTP id p6-20020a17090ac00600b00219158db19amr2114270pjt.152.1669401844720;
        Fri, 25 Nov 2022 10:44:04 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x13-20020aa79a4d000000b0056ba7cda4b5sm3522287pfj.16.2022.11.25.10.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 10:44:04 -0800 (PST)
Date:   Fri, 25 Nov 2022 10:44:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Yang Yang <yang.yang29@zte.com>,
        "Xu Panda" <xu.panda@zte.com.cn>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] Revert "net: stmmac: use sysfs_streq() instead
 of strncmp()"
Message-ID: <20221125104401.0e18979f@hermes.local>
In-Reply-To: <Y4Ct37sV+/y9rcly@boxer>
References: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
        <Y4Ct37sV+/y9rcly@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Nov 2022 12:58:23 +0100
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Fri, Nov 25, 2022 at 12:53:04PM +0200, Vladimir Oltean wrote:
> > This reverts commit f72cd76b05ea1ce9258484e8127932d0ea928f22.
> > This patch is so broken, it hurts. Apparently no one reviewed it and it
> > passed the build testing (because the code was compiled out), but it was
> > obviously never compile-tested, since it produces the following build
> > error, due to an incomplete conversion where an extra argument was left,
> > although the function being called was left:
> >=20
> > stmmac_main.c: In function =E2=80=98stmmac_cmdline_opt=E2=80=99:
> > stmmac_main.c:7586:28: error: too many arguments to function =E2=80=98s=
ysfs_streq=E2=80=99
> >  7586 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
> >       |                            ^~~~~~~~~~~
> > In file included from ../include/linux/bitmap.h:11,
> >                  from ../include/linux/cpumask.h:12,
> >                  from ../include/linux/smp.h:13,
> >                  from ../include/linux/lockdep.h:14,
> >                  from ../include/linux/mutex.h:17,
> >                  from ../include/linux/notifier.h:14,
> >                  from ../include/linux/clk.h:14,
> >                  from ../drivers/net/ethernet/stmicro/stmmac/stmmac_mai=
n.c:17:
> > ../include/linux/string.h:185:13: note: declared here
> >   185 | extern bool sysfs_streq(const char *s1, const char *s2);
> >       |             ^~~~~~~~~~~
> >=20
> > What's even worse is that the patch is flat out wrong. The stmmac_cmdli=
ne_opt()
> > function does not parse sysfs input, but cmdline input such as
> > "stmmaceth=3Dtc:1,pause:1". The pattern of using strsep() followed by
> > strncmp() for such strings is not unique to stmmac, it can also be found
> > mainly in drivers under drivers/video/fbdev/.
> >=20
> > With strncmp("tc:", 3), the code matches on the "tc:1" token properly.
> > With sysfs_streq("tc:"), it doesn't.
> >=20
> > Fixes: f72cd76b05ea ("net: stmmac: use sysfs_streq() instead of strncmp=
()")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> =20
>=20
> Ah the infamous string handling in C...
>=20
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>=20
> Even when there would be no build error I agree that we should have kept
> the code as it was.
>=20
> > ---
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/driver=
s/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 1a86e66e4560..3affb7d3a005 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -7565,31 +7565,31 @@ static int __init stmmac_cmdline_opt(char *str)
> >  	if (!str || !*str)
> >  		return 1;
> >  	while ((opt =3D strsep(&str, ",")) !=3D NULL) {
> > -		if (sysfs_streq(opt, "debug:")) {
> > +		if (!strncmp(opt, "debug:", 6)) {
> >  			if (kstrtoint(opt + 6, 0, &debug))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "phyaddr:")) {
> > +		} else if (!strncmp(opt, "phyaddr:", 8)) {
> >  			if (kstrtoint(opt + 8, 0, &phyaddr))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "buf_sz:")) {
> > +		} else if (!strncmp(opt, "buf_sz:", 7)) {
> >  			if (kstrtoint(opt + 7, 0, &buf_sz))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "tc:")) {
> > +		} else if (!strncmp(opt, "tc:", 3)) {
> >  			if (kstrtoint(opt + 3, 0, &tc))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "watchdog:")) {
> > +		} else if (!strncmp(opt, "watchdog:", 9)) {
> >  			if (kstrtoint(opt + 9, 0, &watchdog))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "flow_ctrl:")) {
> > +		} else if (!strncmp(opt, "flow_ctrl:", 10)) {
> >  			if (kstrtoint(opt + 10, 0, &flow_ctrl))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "pause:", 6)) {
> > +		} else if (!strncmp(opt, "pause:", 6)) {
> >  			if (kstrtoint(opt + 6, 0, &pause))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "eee_timer:")) {
> > +		} else if (!strncmp(opt, "eee_timer:", 10)) {
> >  			if (kstrtoint(opt + 10, 0, &eee_timer))
> >  				goto err;
> > -		} else if (sysfs_streq(opt, "chain_mode:")) {
> > +		} else if (!strncmp(opt, "chain_mode:", 11)) {
> >  			if (kstrtoint(opt + 11, 0, &chain_mode))
> >  				goto err;
> >  		}
> > --=20
> > 2.34.1
> >  =20

Configuring via module options is bad idea.
If you have to do it don't roll your own key/value parsing.
If the driver just used regular module_param() for this it wouldn't have th=
is crap.
