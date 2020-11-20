Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D862BB55C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbgKTT1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732353AbgKTT1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 14:27:00 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E5CC061A47
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 11:27:00 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c66so8827669pfa.4
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JAgY0tq6Ik3G8Dzw77qh9IOUQgJXhqP7cfUlywmdszQ=;
        b=IpTyZPIsHzhSixSaN8+yeNKl+4Bhg7vz3+0AskxXK5poLugV+o/SaUcm6H6JfS6/a0
         FVrCONA4B6e6DjlInfbjwi2hcpX5U3wdeeWt3SW6J747MOyVWMuXF5cU6UV8Fapn6qOA
         J7VALfJ1CUpT4U/2Duh4vOxJD1wc1wY5781gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JAgY0tq6Ik3G8Dzw77qh9IOUQgJXhqP7cfUlywmdszQ=;
        b=HOht0TCXxpQUuxirk59rBwLeic3qxxcfVlaaFOD2qyeZdcWAtA5sRWlCi2X/39mnIz
         hDTOEm+3dYBZChlyvizwwIkuwkISEMBeuwc9CML1Ailmk+NQHTkffMTu0LIfXwEip87O
         oG7EeI6BX0z28335LG/tC1nmblrlLlp35EYdacLKq6Rsvwg26B2ww7mfll1CdU182hBb
         KbQnn/jPPhMuya0RkAGykJtyFkt0ae/stSCVtZx1dNJvtlg9qeLTMnc/wLn9kVmxrezB
         H6jHsOrcQaym+T8qO740Q9l2zcybCfT6Cl/QLzbpucdmsZXhSjR/+U+Ldb6clGmLQku5
         LnEg==
X-Gm-Message-State: AOAM530Q/pRKsbpNZYEEF+OaoizyUR8xG/1FMMY2R/aiLYgT7PnUqd4q
        DH8+c/mECgb2iJzwfb8E9N80qg==
X-Google-Smtp-Source: ABdhPJxNL29Qeef692HCopyeFIbwwVBljgH/IuUdVdz1s0pzb+mMNOithVjvqP4GD/3IutOxlVfTCQ==
X-Received: by 2002:a62:1887:0:b029:18c:234a:4640 with SMTP id 129-20020a6218870000b029018c234a4640mr15777245pfy.1.1605900420218;
        Fri, 20 Nov 2020 11:27:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h15sm3906086pgk.3.2020.11.20.11.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 11:26:59 -0800 (PST)
Date:   Fri, 20 Nov 2020 11:26:58 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH net] cfg80211: fix callback type mismatches in wext-compat
Message-ID: <202011201118.CE625B965@keescook>
References: <20201117205902.405316-1-samitolvanen@google.com>
 <202011171338.BB25DBD1E6@keescook>
 <CABCJKudJojTh+is8mdMicczgWiTXw+KwCuepmG5gLVmqPWjnHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKudJojTh+is8mdMicczgWiTXw+KwCuepmG5gLVmqPWjnHA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:43PM -0800, Sami Tolvanen wrote:
> On Tue, Nov 17, 2020 at 1:45 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, Nov 17, 2020 at 12:59:02PM -0800, Sami Tolvanen wrote:
> > > Instead of casting callback functions to type iw_handler, which trips
> > > indirect call checking with Clang's Control-Flow Integrity (CFI), add
> > > stub functions with the correct function type for the callbacks.
> >
> > Oh, wow. iw_handler with union iwreq_data look like really nasty hacks.
> > Aren't those just totally bypassing type checking? Where do the
> > callbacks actually happen? I couldn't find them...
> 
> The callbacks to these happen in ioctl_standard_call in wext-core.c.

Thanks! If this is all the 'old compat' code, this patch looks fine. I
think new stuff should probably encode types in some fashion (rather
than via wrappers).

-- 
Kees Cook
