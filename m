Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699A62C8F70
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgK3Uvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgK3Uvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:51:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B0FC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:50:56 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ck29so1074783edb.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6E8EIUgMnfEX+zhOh4gyua4yKuAVa11MallxRyqdPPY=;
        b=tLnwbKIuU8dImLSkFiHF/66w7yXZSFAJzuOxphgWWnDSHgZPfHOzZ7SLG4TV+aXSYQ
         CrS0sSRmiiPmFc62vv6VTkfHJHzOxMWTY9MKy1WV1n9+s52w1c8AbAQE2fF2xH/TL1o6
         ai/8Isynm/kfyjLoLtCZvTZvLn38DoqrR6VQS5OPYkUiSfwiH91zObzNnjgABEDxm3Bm
         nTUT3yOaPPCZaJPC4bEVTmVyRLNDytX0gxFXhuvXu9o2Qa90COcu/KRORdXy4h8yjNRd
         6i1T34ss+D5Ylw1Xq2qQDrYOwk2RN8qTN15seQFXamHJ0ikuwZMA79N55sSpjU8199G0
         rCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6E8EIUgMnfEX+zhOh4gyua4yKuAVa11MallxRyqdPPY=;
        b=nUlzYAeqYEVkb2hWa7LSvsNCoQs/Ck52jHOyffzIRTTpIJsPsmp5FHKsxMP78//tE/
         qr0lXbGWsxkTP5XZcJTEVbSkpDLNkJ60SBHALyFZNiPqeoScxWJo+zwj+WOFfcl+7M8n
         zkn7/o5onHOH+e+CWCC3YY1jw7S1m1aNa2/FjKBlP+53Tp8+G4fewjRozAaQ3C+gvqy4
         OHCWU2FQhnV3akWVJy6VvNhoOkdfWdxLfoR1FlbZeEs7jSA60+CYeyxEknXWibZiNgaK
         e0PypgOOIvy9h6iT3Zkv5/sIOfouKgIGFy+T0lPY13FhK31ezZznGfHHLg8N3ImLTlbv
         GvzA==
X-Gm-Message-State: AOAM532I6xT0t15wHaNvK5Py6vfc2NgVptYL2+hmBiRyAyDUW4epxoCW
        6SZkqC1dZ8c3iK5rnNoHP9U=
X-Google-Smtp-Source: ABdhPJyYQ1lDvLaciEFp/fjLhlupfGaxPnJSVRmpQTPTfGtvqaiNfcwUAWqwSuZzoRIZVXqGEkohIg==
X-Received: by 2002:a05:6402:114b:: with SMTP id g11mr24272535edw.228.1606769455548;
        Mon, 30 Nov 2020 12:50:55 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id gj23sm9262893ejb.27.2020.11.30.12.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:50:55 -0800 (PST)
Date:   Mon, 30 Nov 2020 22:50:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130205053.mb6ouveu3nsts3np@skbuf>
References: <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf>
 <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf>
 <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf>
 <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:43:01PM +0100, Eric Dumazet wrote:
> Understood, but really dev_base_lock can only be removed _after_ we
> convert all usages to something else (mutex based, and preferably not
> the global RTNL)

Sure.
A large part of getting rid of dev_base_lock seems to be just:
- deleting the bogus usage from mlx4 infiniband and friends
- converting procfs, sysfs and friends to netdev_lists_mutex
- renaming whatever is left into something related to the RFC 2863
  operstate.

> Focusing on dev_base_lock seems a distraction really.

Maybe.
But it's going to be awkward to explain in words what the locking rules
are, when the read side can take optionally the dev_base_lock, RCU, or
netdev_lists_lock, and the write side can take optionally the dev_base_lock,
RTNL, or netdev_lists_lock. Not to mention that anybody grepping for
dev_base_lock will see the current usage and not make a lot out of it.

I'm not really sure how to order this rework to be honest.
