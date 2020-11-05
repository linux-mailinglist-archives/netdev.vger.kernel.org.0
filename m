Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3392A73E1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbgKEAf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732295AbgKEAf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:35:59 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7F5C0613CF;
        Wed,  4 Nov 2020 16:35:59 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a71so123900edf.9;
        Wed, 04 Nov 2020 16:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aLDQGGg5UcbYGaPXDdfvGmApVoUZefXGOzSV4bLlTjc=;
        b=oDimwz5BeDsibHpSNOEwwLrdxCgVLVO9UCfD7eIBxak4v/10FpJGGNjZxgSgHBISXP
         LE0AOgIq3X4eE3c8FlDe8FjkWf+KOGZWwue9i6PINoU5PO+HpAx7J/hJPdpovnbVolnA
         VaI11aHta4LfnwxJ9wCWIDcHf4WR0AZRzedAi5IsyfSsfEbJwhRVVatpinva8UIB7Dcz
         PKl4g20fJW85olQBD8oBpiU3fbV4Rn4HiK+9PA00ui3zsKU324WR7+g42d8I5WWxkOK/
         Fcoa5UIELIvTXCT9hhoKYOwQHRTr37Zlycal/rjgIToswvMw/NUD2Boac+q5hPbECJIi
         vsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aLDQGGg5UcbYGaPXDdfvGmApVoUZefXGOzSV4bLlTjc=;
        b=mJtEslfF4qVIKFhPwyF5HtnQ8WXZVVb2ZAOEckd2Wi+nO2Hjdk7XIu0WLmULQP8TnN
         /Ae36lg221g4uHr9iwK8T0shJ9fZ/waEiY8RveZ1g693kpUOaJeefbllPgwuKufPASYZ
         mE52dexsIoaFI4rBMkR3Hy7jExR8yE73t0s+ST901apZsBr20YsIUmHPljsiG2tup9Z9
         k1t/kKdg0bGwGYHnpeX10uZZfSR1A/lEWK2CYK8dNH0swi4G1c98UgYwfQhW/U8ntrsc
         79LbCYXBFzrNQSpZxMRLXtnuiNke1XnSIKZJAyjNlk+HsPiz0RE+ho9FDSpTC+ujoFDu
         lFtQ==
X-Gm-Message-State: AOAM5323eIwDUmB3x/aOUrmZgkhhzUxP3WYWTlDopVAVenwmaQbGq5a0
        fdNEyhRKk9Wk3BB/b02mKZM=
X-Google-Smtp-Source: ABdhPJyhh6ixb8agoVjI1D/kg+/m5kZt31NOV93wjE0lrfMhAUp8+oVGoA+1pl6PJBh166IpBb/DmQ==
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr497649edb.52.1604536557813;
        Wed, 04 Nov 2020 16:35:57 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm16109ejj.117.2020.11.04.16.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 16:35:57 -0800 (PST)
Date:   Thu, 5 Nov 2020 02:35:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     min.li.xe@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ptp: idt82p33: optimize _idt82p33_adjfine
Message-ID: <20201105003556.tpgvlh3ponyxzjjl@skbuf>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
 <1604505709-5483-3-git-send-email-min.li.xe@renesas.com>
 <20201104164657.GE16105@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104164657.GE16105@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 08:46:57AM -0800, Richard Cochran wrote:
> On Wed, Nov 04, 2020 at 11:01:49AM -0500, min.li.xe@renesas.com wrote:
> > From: Min Li <min.li.xe@renesas.com>
> >
> > Use div_s64 so that the neg_adj is not needed.
>
> Back in the day, I coded the neg_adj because there was some issue with
> signed 64 bit division that I can't recall now.  Either div_s64 didn't
> exist or it was buggy on some archs... there was _some_ reason.
>
> So unless you are sure that this works on all platforms, I would leave
> it alone.

On the other hand and with all due respect, saying that it may have been
'buggy on some archs back in the day' and then not bringing any evidence
is a bit of a strange claim to make.

I am actively using div_s64 in drivers/net/dsa/sja1105/sja1105_ptp.c
successfully on arm and arm64.

We may keep the ptp_clock_info::adjfine procedure as is, and to be
copied by everyone, because we can't make sure that it works "on all
platforms" (aka "cargo cult"). Or we could waste a few hours from
somebody's time, until he figures out how to bisect the IDT 82P33 PTP
driver (a driver with 3 patches, and 3 more with Min's series) to find a
1-line change, and then we could find out what the problem you were
seeing was. I say waste that guy's time :)
