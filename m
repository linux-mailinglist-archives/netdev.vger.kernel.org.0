Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16232AB260
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 08:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391623AbfIFGUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 02:20:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45688 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfIFGUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 02:20:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id l16so5193282wrv.12
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 23:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzC1wElT9rlxaHSu1/cHl/a8ZAa9saEFgGc+D4Lyjdk=;
        b=aQn5r0U2D+oi8rRJO5fGwoY0hwR0dTkmaEwAJoY9FPchpTLEJ1IHPbcv1ePeqHaBig
         GoxEjK0DdIwm/M3OJbhlHulFEQInVtra1DyABhUhbued0DTE11eQ8qvdfn+joI4Mf4NB
         tVmGeNC8c8ldzV1LH0n1QIFOE733M9MqAOlfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzC1wElT9rlxaHSu1/cHl/a8ZAa9saEFgGc+D4Lyjdk=;
        b=Avj/PIXMh8i320ckCBXsrHMPBE5SWG9gPVG0KuB9axzaiadKVrTN/unXQM0FT5C2eS
         ESTSedz+cdg9ZzaVtYD0M6WCUm9w2rHeF+yv5Wt4+fZywHmoNu7tUKPFlHf1pyzvTxxt
         LyXSp8csuqH8l1pW7NYlV5vpS3APaCz1bDL/wOZnuTvBZ02OHx7TmjQra/TL0yA8I+3y
         a1IhOyi5gr+sSJT1VdQwyR4iVbVPDPMaTs6Hq0c6ePlg2O8E3BZuXXMgciCP+7ZgyREb
         TmWHTvJ5/EAwyECqPx7/rBdbZxGhEl5LeFud+6Zikpj4+7xlRKmRvrsbWxJakb8eqFfF
         3jKg==
X-Gm-Message-State: APjAAAWe+Knf+gcMwchZGedvOdoIfpsTwUH/qdI0zbN9DCQHhyonbVKH
        Ps3GQghhB+sFOwpwOeRBxmslHw==
X-Google-Smtp-Source: APXvYqzheYCU2Gk1w/GcZMi1TZZejLnNRSrRKqMuiBzsslEN1T6gxIsC68xxaYwKVYHD459IrG3Yfg==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr5552562wrt.342.1567750845572;
        Thu, 05 Sep 2019 23:20:45 -0700 (PDT)
Received: from pixies ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id j30sm6723225wrb.66.2019.09.05.23.20.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 Sep 2019 23:20:44 -0700 (PDT)
Date:   Fri, 6 Sep 2019 09:20:42 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        eyal@metanetworks.com, netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
Message-ID: <20190906092042.08f980e3@pixies>
In-Reply-To: <CAKgT0Uf-OvKKycJz7aTZ93J=RdUuwd=SFS9C9pTngieDxe0uYQ@mail.gmail.com>
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
        <CAKgT0Uf-OvKKycJz7aTZ93J=RdUuwd=SFS9C9pTngieDxe0uYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 14:49:44 -0700
Alexander Duyck <alexander.duyck@gmail.com> wrote:

> I would change the order of the tests you use here so that we can
> eliminate the possibility of needing to perform many tests for the
> more common cases. You could probably swap "list_skb" and "mss !=
> GSO_BY_FRAGS" since list_skb is more likely to be false for many of
> the common cases such as a standard TSO send from a socket. You might
> even consider moving the GSO_BY_FRAGS check toward the end of your
> checks since SCTP is the only protocol that I believe uses it and the
> likelihood of encountering it is much lower compared to other
> protocols.
> 
> You could probably test for !list_skb->head_frag before seeing if
> there is a headlen since many NICs would be generating frames using
> head_frag, so in the GRO case you mentioned above it could probably
> save you some effort on a number of NICs.
> 
> You might also consider moving this code up before we push the mac
> header back on and instead of setting sg to false you could just clear
> the NETIF_F_SG flag from features. It would save you from having to
> then remove doffset in your last check.

Thanks Alexander for the input. Will encorporate as much as possible
into a v2 patch.

BTW, I've strugged with myself regarding order of tests, and came
up with this suggestion, as my motivation was to have the tests order
tell a coherent logical story when read top-to-bottom left-to-right, FWIW.
For example, although 'mss != skb_headlen(head_skb)' could be tested
earlier, the condition by itself isn't meaningful unless we have an
existing frag_list and with a !head_frag.

Best
Shmulik
