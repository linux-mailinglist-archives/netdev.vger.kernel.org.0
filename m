Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFFF2A1B94
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 02:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgKABOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 21:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgKABOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 21:14:37 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A47C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 18:14:37 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w25so10589024edx.2
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 18:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CP9+3oGiIkssjN0OJkYoSp4fAmWTocvjxfCcVIeAijk=;
        b=AXrMQsOmf/qI7ZnapgfflaIhr3ranG8aCbrY5wW2ktfINRkn+W5xDV4yVjwpaynv4M
         Aea3FYqbO2fig76xBimamSyBcNnj3WtR5HjzxETkIEQUoQwy9Ny8QkbBIl8d7hUJSzPI
         i9YSHROawfECbMQzhNejT7QKz31mxwTkZOHkkcADjXcNSPEsPPrKWD26wokY1dGdL7VV
         XqKSSMQfazcBGNu9cJYnMboyWpvDfCYgwN99Ni40MISZ78PZ0d6B7ewzUj2VkgaRyNTJ
         58TtBWdNyWTteaFSbsJwEDGRv3eTRnJTW1aX/bY3pKl0mMwA7q8DKM4qD8Zgvxf0ZBHR
         w5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CP9+3oGiIkssjN0OJkYoSp4fAmWTocvjxfCcVIeAijk=;
        b=h82FN+8OU6qDZul3TO+fHzrZu5cRB/3H4563seR8K0LV53ntQC/8Z1FDT0Izkri4AN
         tRPmlzKwfZYxQPXBOLOpOHdCt4ixkkMAL91RdjkgF+K6prnf0X+zdf95cMOSD7VsSS+j
         meFMKdkKOhrjVn+RE+vblypnMMKY9Zhg5ArMuKZ+lBH3HCKNtBPAyhkiNNA+hQcG9BiF
         sg/2LGOffztIZ727b20CG2EP2ZeIPw9JqTuRng5pJaN0vV8aRaB+Lb0Jj/YImeTUp+Yh
         1jhP+EATw+UCN03xX5eGAe1/xnlgsOzuMNkhat6wtyymdb4OXasWEv+/iafn1SIqDYAQ
         Ukzg==
X-Gm-Message-State: AOAM531mvX3Eb+3VEQV3LUk6UMJhTtj9+CpFEOj1XWa79+BIh1awH2g6
        x8d9aPhe2DCi3rFWaNkOW44=
X-Google-Smtp-Source: ABdhPJxwIdKWpMXR4cgOpA2qiMJrD+AgJtexf/hEdyemnwt9sdxW9rPLE71balD9YC+Qlm/OGMQEgg==
X-Received: by 2002:aa7:cdd3:: with SMTP id h19mr10016266edw.330.1604193276104;
        Sat, 31 Oct 2020 18:14:36 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k26sm6882531edf.85.2020.10.31.18.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 18:14:35 -0700 (PDT)
Date:   Sun, 1 Nov 2020 03:14:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v2 net-next 01/12] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <20201101011434.e5crugmwy7drnvqt@skbuf>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
 <20201030014910.2738809-2-vladimir.oltean@nxp.com>
 <20201031180043.2f6bed15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031180043.2f6bed15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 06:00:43PM -0700, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 03:48:59 +0200 Vladimir Oltean wrote:
> > @@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> >  	 */
> >  	dsa_skb_tx_timestamp(p, skb);
> >  
> > +	if (dsa_realloc_skb(skb, dev)) {
> > +		kfree_skb(skb);
> 
> dev_kfree_skb_any()?

Just showing my ignorance, but where does the hardirq context come from?
