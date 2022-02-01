Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670634A63C7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiBAS1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiBAS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:27:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EA7C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 10:27:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id r59so17885514pjg.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 10:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WaHT5G4W7cT3JPHoX5MjKgjz/AkX75nlv8l2WpBPp0A=;
        b=3Jun483IukzD3W6qfx7ohNnDUbzGlr9hr4T03rxGtHM8iciKY2RoQtLjhj75z+oivG
         58XGo0L7lK0xwtXmO7h+rp8SHJR5214+3+nbWTcpfFmMyPmNaIjaWHb7cxt2xj4/HoOf
         rHDIiYsXrCGQ+zz0iGBoSTi0RSeb6kjGmhwXr7AVLs5zHguo2L3N+QUsDNW+E1ouYKdH
         cbokzIFO63K+4EMoDiHtkxPUPd29tOfLbu2SnxBvoHJvoQLpFcr561bDNXybVlnIq9Gy
         HBXuHIiJzHYGqTCYgfFIjsnf36tLp0ANFclxc0zVBZaByU73a8IzOMkml47CLTV/qRgs
         RsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WaHT5G4W7cT3JPHoX5MjKgjz/AkX75nlv8l2WpBPp0A=;
        b=h9XikbyzmDNzWDmKU7ft+Yd38GjAvyyUz0C4uFxFBmdlHX1NBZGJ9Oerfw0Rw/BXAy
         5z8OwcG4rgj0fRJEHCB45JWpvkcxWz5HyCXO5EY/KyYckWefSyUQ9evTNUCvcuEObpWN
         nwBVW/BVQj1oupdH9iz9nl8tHuewsYbmrSXcAbQDGl+xW1EbvYTBarHdTBkGyclvKxkR
         ERI6CAPaVXjvqtkAqUS3bbf/fZhOM4NHA5V670vY5b4zIax07wkpL+9mv7KSJ+HcXBST
         46Nbab5huKpWLmA54GUEd1xV04aJTSsIedQkvEnzjWih/poMRygB9M/hMdwIT2SAuXOT
         pz+g==
X-Gm-Message-State: AOAM532ai/lb6S5bVpNSM1OhQ8bX2mRN6EYuDCzJijPHLTasuULPCOgl
        GtDrMAjwn/z3AhPBvppSpkBbYw==
X-Google-Smtp-Source: ABdhPJyc53HmK8JT1iSit3+qFbTsVR7fdxcgi4pKuWbz00y10pksWJhT+FOSFtaHBn9t73AYSIqr3A==
X-Received: by 2002:a17:90a:1383:: with SMTP id i3mr3796706pja.40.1643740035835;
        Tue, 01 Feb 2022 10:27:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id lj3sm3327802pjb.37.2022.02.01.10.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 10:27:15 -0800 (PST)
Date:   Tue, 1 Feb 2022 10:27:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, markzhang@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH iproute2 1/3] lib/fs: fix memory leak in get_task_name()
Message-ID: <20220201102712.1390ae4d@hermes.local>
In-Reply-To: <c7d57346ddc4d9eaaabc0f004911d038c95238af.1643736038.git.aclaudi@redhat.com>
References: <cover.1643736038.git.aclaudi@redhat.com>
        <c7d57346ddc4d9eaaabc0f004911d038c95238af.1643736038.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Feb 2022 18:39:24 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> +	if (fscanf(f, "%ms\n", &comm) != 1) {
> +		free(comm);
> +		return NULL;

This is still leaking the original comm.

Why not change it to use a local variable for the path
(avoid asprintf) and not reuse comm for both pathname
and return value.
