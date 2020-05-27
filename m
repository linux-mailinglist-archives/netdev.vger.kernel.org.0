Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB41E51D1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgE0XaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgE0XaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:30:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CFEC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:30:18 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id nr22so13702085ejb.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Qn1sNN93vjGFHV23I2hJe/V3lPZZX+YpFcwc+6cSrQ=;
        b=nwnoO3iXHW/L1m4aGdLp6EnhL+RSzsYj7+7eflHqLiuiVNEBp8N4q6jPl/v87MonCo
         unOBrt+NFgCSj6RsuD4dMP2bAc65nziMgEvFGM07rbL5gZT+U/H3jpOPZH2aH8DygQUO
         37vD0bxm3xh/WEoXfXOcH2d/nQ6BOhJTjPwq6rsgyn45x7gT19rZNxv2xINcxbC300TX
         HSVwyKDOpX1p65iNR/kTG1RNZb9le3r51idPf4njeJnNSs/5XfrFeTeWI9d3qFf38U0x
         0F5D8C5r7CV/S0Lkt5eMZUZtfAUFLXCvtfl/wBBk7FDQkRyXKf+p3FIY/kWhFXqL9L5y
         /Y+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Qn1sNN93vjGFHV23I2hJe/V3lPZZX+YpFcwc+6cSrQ=;
        b=OHOC8QL6GpmuPyck4dviG/WRexBl+SvR4/9monmIKTcmMzm33lSzRnhejrMTzBdwUX
         sOgEAWNWZhoHLa90EBCdZjlvD30gkCSi5uAExS23Zs6028klMriJJcmUc8BqL1+XcD65
         5fihbEFfaRMKoZwOmA5VNzGMHmUO+bqQaXOWS1UFPBhGCASyT+DavbgjliEZUXpG63cO
         OX+Ixg+KAYMFQJU68FBZIuEdzbIINuNlekFNgeTIgvZVSAPSIhC8LqB93ymoeIA25cDZ
         jtoAUmi2qdDMt8QwDOYhsRWrNWdEcNz2OaxuXGCRlH7H4n7JhygvGbq9oxp4rl2Lt5f5
         eLvA==
X-Gm-Message-State: AOAM533B7IWqCtzKhvCNN7vle3B0JXWFdoxE6MdDXU/KjvA8Wa3c4MB+
        nv65RoONHOf3lxWPPFcZubvE+XUsQO5sUJobLgA=
X-Google-Smtp-Source: ABdhPJxTX8eW33atG7lLPT6DTMZtnCsDH+4dm4m7R277QtJ1Xt1PEWwIHhvpzf2yOZUogpma0x6RiBg1vP/UF2jFdTw=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr689522ejz.100.1590622216876;
 Wed, 27 May 2020 16:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200527203850.1354202-1-olteanv@gmail.com> <87eer5j6um.fsf@intel.com>
In-Reply-To: <87eer5j6um.fsf@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 28 May 2020 02:30:05 +0300
Message-ID: <CA+h21hpLnZRHX75MXE7utoers2Dcfoz-K60ru5cN_b1+y5zLMg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: offload the Credit-Based
 Shaper qdisc
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 at 02:28, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > SJA1105, being AVB/TSN switches, provide hardware assist for the
> > Credit-Based Shaper as described in the IEEE 8021Q-2018 document.
> >
> > First generation has 10 shapers, freely assignable to any of the 4
> > external ports and 8 traffic classes, and second generation has 16
> > shapers.
> >
> > We also need to provide a dummy implementation of mqprio qdisc offload,
> > since this seems to be necessary for shaping any traffic class other
> > than zero.
>
> This is false, right?
>
>
> Cheers,
> --
> Vinicius

Yes, good catch, I forgot to remove this paragraph from the commit
description. Do I need to send a v3, I wonder?

Thanks,
-Vladimir
