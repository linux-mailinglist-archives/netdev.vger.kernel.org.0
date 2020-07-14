Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D2A21F183
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgGNMjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgGNMjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:39:09 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C93C061755;
        Tue, 14 Jul 2020 05:39:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d17so22414069ljl.3;
        Tue, 14 Jul 2020 05:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=JLOHdvyYSteBhwEJW7uffo0TGL6VVEqhn0x84Jxi3qk=;
        b=Mu7sGUuEOMRnG28b8EWSexhxA6mB+gAdubs97YQAZHeOYEUWVcqsMW8uLRGOy9wW5w
         UFDpWKDMJ29m2S/3GtQuBjz+nsGUNB6Ja7vSobIJcm5omie0YaAKbngk39Q1+EZiWus/
         LDfrGmXzZmiyNWctIn85jdKczsGlQVnzTCmeicJ+OOPiw3lDbH7tIIALqkx+pF0RY6pC
         YKUhdcqs9rE6E2e/R9xuwAD0WoKHNxoeRsF9W1pSXGk9s2AU/vcGjM8ge/n82vH4yHHz
         WrdmDwzz11WyAACehn4CSMUyJ9sNhRVe2f9tvM5DMjJ9o357CNfHElG1I0sOFLti+iUT
         eh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=JLOHdvyYSteBhwEJW7uffo0TGL6VVEqhn0x84Jxi3qk=;
        b=kseruiOA2eUrK9FAqzGnG4LihEnRzFk2flGD1Yr970QwiZtNNDuIFh8SWG2ZlbWCyg
         rJRQCNw5kM/W9O1h/+4tAgQ976gg1mn0VQod9u6yst2c96g3MO7qVx17C25ynttLbkr2
         Oo9bSjJMgXHIigDWMMqGozYSKCsi1+gQcxKOj0H/OJnDvLn1+288XjrCFPbIYUFFpEDC
         Vkrnrbnk9NCyhaE0DbZMEY7k8jGi8IRB8DkLaXoX1j76GxuJ3eNqbFTpXC+G8PaoEgb1
         pkhPlIVAn0/PHiH+S34bTx+w3ZY452QslGrdPLAM+jJ3mjVhdcnan3oLgMS1jm4NsJeh
         I7nA==
X-Gm-Message-State: AOAM530vG0CFIAQc7jYAbfB4g5TzXXT44pJHnkyPrt/mXCmmADKL0yv2
        JzhAdqo/xismIoh58yLrUO0=
X-Google-Smtp-Source: ABdhPJy5jA02+aWY74G8lYig0KGgaa7eSgsbtTSLdLgLu0SeHhSdehN7LGgmXt45kwfjxQGce7JEog==
X-Received: by 2002:a2e:9907:: with SMTP id v7mr2272585lji.347.1594730347221;
        Tue, 14 Jul 2020 05:39:07 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id y13sm4635583ljd.20.2020.07.14.05.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 05:39:05 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf> <87wo387r8n.fsf@osv.gnss.ru>
        <20200712150151.55jttxaf4emgqcpc@skbuf> <87r1tg7ib9.fsf@osv.gnss.ru>
        <20200712193344.bgd5vpftaikwcptq@skbuf> <87365wgyae.fsf@osv.gnss.ru>
        <20200712231546.4k6qyaiq2cgok3ep@skbuf>
Date:   Tue, 14 Jul 2020 15:39:04 +0300
In-Reply-To: <20200712231546.4k6qyaiq2cgok3ep@skbuf> (Vladimir Oltean's
        message of "Mon, 13 Jul 2020 02:15:46 +0300")
Message-ID: <878sfmcluf.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Mon, Jul 13, 2020 at 01:32:09AM +0300, Sergey Organov wrote:

[...]

>> > From the perspective of the mainline kernel, that can never happen.
>>
>> Yet in happened to me, and in some way because of the UAPI deficiencies
>> I've mentioned, as ethtool has entirely separate code path, that happens
>> to be correct for a long time already.
>>
>
> Yup, you are right:
>

[...]

> Very bad design choice indeed...
> Given the fact that the PHY timestamping needs massaging from MAC driver
> for plenty of other reasons, now of all things, ethtool just decided
> it's not going to consult the MAC driver about the PHC it intends to
> expose to user space, and just say "here's the PHY, deal with it". This
> is a structural bug, I would say.
>
>> > From your perspective as a developer, in your private work tree, where
>> > _you_ added the necessary wiring for PHY timestamping, I fully
>> > understand that this is exactly what happened _to_you_.
>> > I am not saying that PHY timestamping doesn't need this issue fixed. It
>> > does, and if it weren't for DSA, it would have simply been a "new
>> > feature", and it would have been ok to have everything in the same
>> > patch.
>>
>> Except that it's not a "new feature", but a bug-fix of an existing one,
>> as I see it.
>>
>
> See above. It's clear that the intention of the PHY timestamping support
> is for MAC drivers to opt-in, otherwise some mechanism would have been
> devised such that not every single one of them would need to check for
> phy_has_hwtstamp() in .ndo_do_ioctl(). That simply doesn't scale. Also,
> it seems that automatically calling phy_ts_info from
> __ethtool_get_ts_info is not coherent with that intention.
>
> I need to think more about this. Anyway, if your aim is to "reduce
> confusion" for others walking in your foot steps, I think this is much
> worthier of your time: avoiding the inconsistent situation where the MAC
> driver is obviously not ready for PHY timestamping, however not all
> parts of the kernel are in agreement with that, and tell the user
> something else.

You see, I have a problem on kernel 4.9.146. After I apply this patch,
the problem goes away, at least for FEC/PHY combo that I care about, and
chances are high that for DSA as well, according to your own expertise.
Why should I care what is or is not ready for what to get a bug-fix
patch into the kernel? Why should I guess some vague "intentions" or
spend my time elsewhere?

Also please notice that if, as you suggest, I will propose only half of
the patch that will fix DSA only, then I will create confusion for
FEC/PHY users that will have no way to figure they need another part of
the fix to get their setup to work.

Could we please finally agree that, as what I suggest is indeed a simple
bug-fix, we could safely let it into the kernel?

Thanks,
-- Sergey
