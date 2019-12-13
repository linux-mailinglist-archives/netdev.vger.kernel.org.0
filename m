Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5982911EE99
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLMXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:38:49 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45359 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMXit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:38:49 -0500
Received: by mail-lj1-f194.google.com with SMTP id d20so449029ljc.12
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/C/dNXw9jXRBbpt2VneFJ2EKEuNVryzCHwyYuX+uJiU=;
        b=GoRboWLvwk4Ut8iNMk08A9D3pRTvxzABl6eXb/YLxto8E1dujBexvyW18qxKQ+KfTz
         lXgXSvyoH9DAhmEp8mByhvuezVlkCTDr0hM7nIBR7oN+qHxtM1FNLHk3/z3o6XRAgQwA
         6t/K23AFKG+Xs4jRyJ0++oyjhfrCvg8jZhzvokPLfGH3bF8TuMZ/P4WhlQ+VM4IfNxqD
         /jdq/fDmmbqlcpxWTeMGhCrrhea8Peq5i+44CstGvtKyPJgumOri9VwKTVkjW9olEs+D
         NY2L7uuTl5wp6bTmY+RIntBowqJ+guv0IxtWSv22sQ/xif41SnyCpT+rBAUWroqxyNL3
         pnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/C/dNXw9jXRBbpt2VneFJ2EKEuNVryzCHwyYuX+uJiU=;
        b=KogRswf0EvafdqNnIS1Dejs1l2paPp9MLJzWxLSxbAojG6bkhohGHP5Fo3dmvMNheB
         cA5HQH/cS/IqiPXToKWMFC1SgRgylvkJfJjdBiFLoXXIOtyPIuW2tX+5RZtJ8upshhKW
         2DIt3pJUAU5lnZQAvJb5I8DUR5+85jRl1MDURMq3NG/REHtoRL4svq7SYFBqW4pQbL4B
         RuAnP/Xki2osSm+m8P3zOYfeRmQ29w4s+o0WApztM2PNFv+8P1VMyXTRjNr84XX/s74q
         r1DsnOlS7rr3q+TgisSkIHVSRCMxvQiQ2jOvfJLSNETtamWUXi0+BCBx36xSuJspg7tP
         CBwA==
X-Gm-Message-State: APjAAAW6fym4l0kgPBMmxYYLJu/p3SpdP5OxuxofAqyihEKKDnLmyfPM
        tacMS/ZEpitPbokEQksVVFCcnw==
X-Google-Smtp-Source: APXvYqwtgodCtaMq/95A9YEXmcdegXFdGgHxGN+zsjoKUwZ3Z/nT0fMyrbGB9XY6g/9eYJbFYOpgyQ==
X-Received: by 2002:a05:651c:208:: with SMTP id y8mr11547682ljn.36.1576280327062;
        Fri, 13 Dec 2019 15:38:47 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e14sm6335670ljj.36.2019.12.13.15.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 15:38:46 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:38:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, <michael.chan@broadcom.com>
Subject: Re: [PATCH net] bnxt: apply computed clamp value for coalece
 parameter
Message-ID: <20191213153840.7d9d4187@cakuba.netronome.com>
In-Reply-To: <20191210163946.2887753-1-jonathan.lemon@gmail.com>
References: <20191210163946.2887753-1-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 08:39:46 -0800, Jonathan Lemon wrote:
> After executing "ethtool -C eth0 rx-usecs-irq 0", the box becomes
> unresponsive, likely due to interrupt livelock.  It appears that
> a minimum clamp value for the irq timer is computed, but is never
> applied.
> 
> Fix by applying the corrected clamp value.
> 
> Fixes: 74706afa712d ("bnxt_en: Update interrupt coalescing logic.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied, and queued for stable, thanks!
