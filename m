Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07C447E8BE
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 21:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245188AbhLWUYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 15:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbhLWUYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 15:24:21 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B36C061401;
        Thu, 23 Dec 2021 12:24:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 2so5813649pgb.12;
        Thu, 23 Dec 2021 12:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SyEnL/SLKTuhUBnGBnB+zNmKPnzomX5LZd6Xaw6ZYA4=;
        b=XNIAbtQ9zSvmB+cSd1swu2CsO0udyu3/ujd4Qw+yaIjtSDx4NJkYTcch0ZmrajtIZe
         C5ZqMvih/dRvsOf9A/AUKgLPP1HBmYg3PrINw1/gLdndNVoFMZYu1/xLZz+wSeVSNypy
         rPWFFO40sV6f5Y+r/IohFuo3HAv7qN5ed3LzWX5ZKhIitEH2Fcpr26373KtNKbdQ1lCT
         ZZGOpKB/OkixruWembTraZlKoa2L4hhSNecsWIDQPFnRF9jF9LJTbPUVZuSWSmWdv6J/
         /y5FiAYh9Y8MRwRJIRiZ+a+0hZJyuVpei2wq/HhL6RRSCY7pCmsB3QEjVkkIIcThWY71
         OOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SyEnL/SLKTuhUBnGBnB+zNmKPnzomX5LZd6Xaw6ZYA4=;
        b=pYYtzlY0yizIxgLSkdEphsCENnQG/LHuRnfMnLgCn4jSFCFeLZCWnsvUveCcLV9WuQ
         2ywJV+ioTns14dptXKdXSwoKZZ7LLOPQW7+xytmoTS9YF+wMqCKgtaJjgEDmBKvy7+M/
         GE70ZkKCO5e17O+4NXEQkDXQSx89lL7fMyfKAsMdYCpy8DzsR1icSJHeEaPY/gLTTvT4
         1S1Q2uIDLYVVk6pmgMPaM1GOJouNi6a+e3ii1ulMKniYJHVJIQcA33Dlqb5Eatsu+8Zw
         tB1UtIr7l1WxRkraQDQbfU7u032im+OOHwd4G4UWgYwbWOPZaO+qFLVVf+elGXHJOljq
         1oqw==
X-Gm-Message-State: AOAM532qtTEw6eaTghSp6fBnPjOPAOX2k1+yg75gPdYNc/byUoHA2JcK
        9xbPpEGlctoc8NThnT/912A=
X-Google-Smtp-Source: ABdhPJxrTqw1dJQx8wlNzyAtKFnxBYn0JA3Ho+8h6oyCHJRDwg6cfdWApru1d6YMHkEP9H4QRH4X6Q==
X-Received: by 2002:a63:2166:: with SMTP id s38mr3394922pgm.125.1640291060659;
        Thu, 23 Dec 2021 12:24:20 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e24sm9440247pjt.45.2021.12.23.12.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 12:24:20 -0800 (PST)
Date:   Thu, 23 Dec 2021 12:24:17 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2 2/2] phy: nxp-c45-tja11xx: read the tx timestamp
 without lock
Message-ID: <20211223202417.GC29492@hoboy.vegasvil.org>
References: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
 <20211222213453.969005-3-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222213453.969005-3-radu-nicolae.pirea@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 11:34:53PM +0200, Radu Pirea (NXP OSS) wrote:
> Reading the tx timestamps can be done in parallel with adjusting the LTC
> value.
> 
> Calls to nxp_c45_get_hwtxts() are always serialised. If the phy
> interrupt is enabled, .do_aux_work() will not call nxp_c45_get_hwtxts.

Reviewing the code, I see what you mean.  However, the serialization
is completely non-obvious, and future changes to the driver could
easily spoil the implicit serialization.  Given that the mutex is not
highly contended, I suggest dropping this patch in order to
future-proof the driver.

Thanks,
Richard
