Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08214A7B2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfFRQzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:55:05 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:37081 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:55:05 -0400
Received: by mail-pf1-f177.google.com with SMTP id 19so8005770pfa.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7axUMFaPDM0hnxQTohDlCo2IcXos4uOgtakVDujJZow=;
        b=gPzWazigwjkBALDxj98Wf7Vbyz36R5Vv28wo72jKfbWAAOPL9QgU+UkdZJDRvkyO4X
         mo/A08/wh8pd81CAx2S+UZ/Oe/7VnNrzewqph9NCZiGu9tr8xs3gEXvcrNDKSiv9xO7R
         GsGlBX30RsqfvtyRHwnehJlmBeWyNG/b1OiA2pXJBTSHzzDQIEfMQBsN1u3gpL8MhX+n
         CTYsdYkKOZKbbDo6oQkBURloU3X43Lhxk9ozYgfZkT1/aLvIn75UT+Pyv611NzqpCNaK
         bz6f5/eUSp1d+v0rt1RH5+zQMJ8gahg4P1VPmV+MdspK221sHtxGejWnzqXIkdFiFSm3
         9IwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7axUMFaPDM0hnxQTohDlCo2IcXos4uOgtakVDujJZow=;
        b=MGh6eFRbJKXo4cSC0bGojsPIF276RMT0zWi8SkHxenD/AHq7AoBobrPLpimzmqAC3C
         jCOH8XUV7RV+QT/GWEj96rK+LMSdd+LpcOB+u0Pj2jf/9Qqxr8GSbmNMB58yM/aUB1of
         KrbQL4rNabBSIer1MZAknocj4qinWwfX4TKETXCqTAL29rCCdY2Qyi4YkcPWZpiJcRQB
         TKxV/zfKwYh6kdNUD3/0PbDPxUkbWrV18w2vbyTF4pjO9n9ZtpgPL4IbqhZHJrXZ6j2w
         B4ycYjRUv4irev0Yo7RCFq62WIHzk1BuBrw32Zwk6AsBfa2NK6/3v4GgtnD2DDBvoOX0
         KknA==
X-Gm-Message-State: APjAAAWPcYrnK4G+XGgJqGFxgvNJnbglppxP50ouP5xPzkSc7kQhGzdA
        IyGpQMOWA/MYBriO3c4vHh+tZ+KIuqs=
X-Google-Smtp-Source: APXvYqwAg6zWAW6MMhQ6hAUAFQTucVeOAwbdH3gXfH0O889VGg7xbXHXElbTa/z1POsaDJWsWh20Wg==
X-Received: by 2002:aa7:8ac9:: with SMTP id b9mr110052597pfd.260.1560876904820;
        Tue, 18 Jun 2019 09:55:04 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g13sm15265194pfi.93.2019.06.18.09.55.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 09:55:04 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:54:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michael Forney <mforney@mforney.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ipmroute: Prevent overlapping storage of `filter`
 global
Message-ID: <20190618095458.2d1c06b7@hermes.lan>
In-Reply-To: <20190616214602.20546-1-mforney@mforney.org>
References: <20190616214602.20546-1-mforney@mforney.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Jun 2019 14:46:02 -0700
Michael Forney <mforney@mforney.org> wrote:

> This variable has the same name as `struct xfrm_filter filter` in
> ip/ipxfrm.c, but overrides that definition since `struct rtfilter`
> is larger.
> 
> This is visible when built with -Wl,--warn-common in LDFLAGS:
> 
> 	/usr/bin/ld: ipxfrm.o: warning: common of `filter' overridden by larger common from ipmroute.o
> 
> Signed-off-by: Michael Forney <mforney@mforney.org>

Applied
