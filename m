Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38E4332169
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCII5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCII5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:57:13 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B59AC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 00:57:13 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id bd6so18685295edb.10
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 00:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Myx4qcG7usuxzVf+LTFNh+RF0r/lar9S1TIjtqXm1c=;
        b=NM6f3ZYhfEQlbCM3lTGHLYclD83X1X9siQVGwA3OYG3FEz7GmM9v1XjxMSMvtu5PGg
         p2/+cGfvvfKc6Pr6Z7Kf4Qpe9cemM2Tg1Q+rtYf213l5v0jK5iN/4bgJJk/+hh+Hi/pJ
         a4YPgffgkeSqU+tkm1xzYMvZodPO7IzDRZSiQN0v32FfxbH+QAQKF7YbmqjZo5Sem/+g
         nrFfIo/GXHPqVgMoHDfn3Mmm3f1qo9UnpZSb2YXv+m1fWq8cqFDnhMxONWzLTByAgap9
         Twi9lU28JVFwRNBjszu3pJTkKj/RhaFEVFSHQt0AzY8K5Oy3y+X0fYWLCc1fL7AghVaH
         fCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Myx4qcG7usuxzVf+LTFNh+RF0r/lar9S1TIjtqXm1c=;
        b=eJG+trIHmiK6K944DYrsiWRPcGRgOGwQuG06OY8j8u3bdHG2Fsb5XOvmE625M+C4t+
         Av+pqr2DB+PloyDlMepcq300otSEY0XNNJ8N/Y8jHts5o3NlccFp8sSfNm3shp6/+rnD
         QveCuWNFh4HZDUm4fxNGLO9TKfZUVhpa6nYzqavh+zh0/nQmBUzYzfgkexnd+i/qhho1
         dLBk+9M5Z5qKaCoCzlqqudUVfaNw+eWbTlT+ZTlEKq7EGWaqKnAiU1GXLTNbdGkJvc7o
         KzesKA/lRsOZfaQ2FU/uLrme0cxU/506+iOz+hjANnlxwVlG1NaelWk5B6qoDDiAw9qh
         lmOw==
X-Gm-Message-State: AOAM5301v/UmKJLwEV1rPs/p56PmrCJwNU0wHzF5nGGmDk6Gmna29p+0
        mz0qKA4V6ew9GoMxmBpHevM=
X-Google-Smtp-Source: ABdhPJzILEBnEMDHDiDbtShjfXl/aKBuEsMCCwKQ6zv+QTD1W/EnSRK3zmtBnPWJQtJ72T1MYw9unQ==
X-Received: by 2002:a05:6402:5:: with SMTP id d5mr2860547edu.121.1615280232060;
        Tue, 09 Mar 2021 00:57:12 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm2857384edw.28.2021.03.09.00.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 00:57:11 -0800 (PST)
Date:   Tue, 9 Mar 2021 10:57:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] net: dsa: only unset VLAN filtering when last port
 leaves last VLAN-aware bridge
Message-ID: <20210309085710.xdo2h6xmm3oamdks@skbuf>
References: <20210308135509.3040286-1-olteanv@gmail.com>
 <87r1kon8hu.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1kon8hu.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 07:31:25AM +0100, Kurt Kanzenbach wrote:
> > @@ -124,13 +124,16 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
> >  	 * it. That is a good thing, because that lets us handle it and also
> >  	 * handle the case where the switch's vlan_filtering setting is global
> >  	 * (not per port). When that happens, the correct moment to trigger the
> > -	 * vlan_filtering callback is only when the last port left this bridge.
> > +	 * vlan_filtering callback is only when the last port the last
> 
> Somehow "left" got missing. Shouldn't that line be:
> 
> "vlan_filtering callback is only when the last port left the last" ?
> 

Thanks, you're right, I don't know how it happened, I'll resend.
