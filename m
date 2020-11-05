Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9132A845D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgKERCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKERCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:02:08 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B3AC0613D2;
        Thu,  5 Nov 2020 09:02:08 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id g7so1557317pfc.2;
        Thu, 05 Nov 2020 09:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1E/GdSgvT+IfKnf/MQnxEpHIqbogE7oTSfYMSoG+muE=;
        b=py845HUDSn6lrlHMzWWLdBEnBIvv7pnBrtqYEs7F4lClin5wEfNwRsfuebyIhBrs0F
         yq9wBocpigv9ECrczLtxDjmUTDnMWAR786Vx64Yy2bcRd0gtj84/iWFHKTy+ijgW6ZI1
         JrcddhmYxQlPyOV178ghPINfaS/SzV9Vuwt8T6XlEebjsecz8PGvI7iD1VNlX4P+4uuC
         P1j2qqd4+L1rJYPT+AXVskMPbQcW4lV5iyF2Id5QoygLx+5h7zkId0VSLBUnQMktUKfZ
         GLYoVbrP/pRMAb9Re49tHlMWnwh+TOtzdxMIKpFx0kLjncq1PXFKQ0CrwtQk0GLv4zXz
         C98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1E/GdSgvT+IfKnf/MQnxEpHIqbogE7oTSfYMSoG+muE=;
        b=bwNLdkqwi3/NqTcZP8wNee9n4NxMH7f8WR4l+kC9/pmtN6zso9gze3gclLnsipH0tX
         aGbcPGepBwhM7i/F8owT4WfR8gfY7ujq5jnt4btE+gTBSgQFzEO5Vtis3ahLidJSt1LT
         eFL58stUqIouQSP7jGdkkm+h3Iijyd6zVWZ9yTiS9/OoG8dZfEHw0DvWV15Rp6w9K/Jh
         cDyq9LUDhlkH4cXXToKQr4PPMjoBKt94Di4vqkio95BHSX6QOvPVzeLuXak97JE7quyM
         aT8AKxfe/Mc8U0UrZnwB7feD9ywsLL1rwNXljZe2EBCnH7zeSnUXfV4VljGgljLKdpQ5
         S5bg==
X-Gm-Message-State: AOAM531umHwoDEw9vuhYffAT0rx94wWRozMpvdLAD+h2GuGVbLaXEiZP
        clImbAGLsKNS/m3rZYmoORg=
X-Google-Smtp-Source: ABdhPJwbvoK5kkf0kxlXbmOFQ64ONheTWuD39VvDwGzob7HSOf95ha2r81Of2Bb41jZos3/aE9Ds2w==
X-Received: by 2002:a65:67c2:: with SMTP id b2mr3214406pgs.39.1604595728164;
        Thu, 05 Nov 2020 09:02:08 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f21sm2970903pga.32.2020.11.05.09.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 09:02:07 -0800 (PST)
Date:   Thu, 5 Nov 2020 09:02:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     min.li.xe@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ptp: idt82p33: optimize _idt82p33_adjfine
Message-ID: <20201105170204.GA5258@hoboy.vegasvil.org>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
 <1604505709-5483-3-git-send-email-min.li.xe@renesas.com>
 <20201104164657.GE16105@hoboy.vegasvil.org>
 <20201105003556.tpgvlh3ponyxzjjl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105003556.tpgvlh3ponyxzjjl@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 02:35:56AM +0200, Vladimir Oltean wrote:
> On the other hand and with all due respect, saying that it may have been
> 'buggy on some archs back in the day' and then not bringing any evidence
> is a bit of a strange claim to make.

You're right.  I made the effort to look back into the days of v3.0,
and the only thing I could find is that the 32 bit implementation of
div_s64 does extra operations and invokes an additional function call.
But the difference in performance, if any, is probably not very large.
 
> I am actively using div_s64 in drivers/net/dsa/sja1105/sja1105_ptp.c
> successfully on arm and arm64.

Yeah, I see div_s64 has found its way into the ntp code, too, so it
must be fine.

Thanks,
Richard
