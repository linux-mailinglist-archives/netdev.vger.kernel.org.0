Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D8BD2AF
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410182AbfIXTcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:32:15 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39047 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404530AbfIXTcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:32:15 -0400
Received: by mail-pl1-f170.google.com with SMTP id s17so1398116plp.6
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 12:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Qmp2EIvGec0n0rRnfkFYxwuqzu3w1UZtFkxlDcuXcI=;
        b=lHEAZMgfLGt82TdJkpPLV/zil0HrxTaR9fdKike0nAev6fBdBe445Ze0kyFDyI7vyg
         GBAy99mULr3o9o26U+lBhGhrY/78eP5/J0GmUN4L60YO/Hc+iaXHLBw8wmcZPDRs4UOJ
         C6EaHAuppXT+wGmDIhU4BF0/c1Y7cq9jjzpFnluovfaA+/4ys9FEjoYTGwtlhZAhv8MY
         2xR7rNnwMZyfkRrT/bR2oKoTl2oG4A/AkOMD3/LvIeoJUP+GeXcpm4fBscYEivYMbUiu
         0Vh235FHDi7gKHr1TrI4h6jade2fKBVg9yV30S/5irZ0r9v8euB+TYJNanWkUx80zm17
         86vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Qmp2EIvGec0n0rRnfkFYxwuqzu3w1UZtFkxlDcuXcI=;
        b=SMxt5gQX6LhGGOIKVmCv+HEnXNbzS+3H0Tae0ryOBB//gkqwACWxToevMOu+Gr5gNl
         b3BC4bOC20cBZ1UT6dJGvShsz6cAwsPWujLGCLSDkN2x4xgPZuikOF21Agm5WYNobIEb
         AiOSrNOPMvoe9/kJXrb71U5xwYhVS5aPU4AqcSsiW6oFplryl+a9HLcrdjeTfza+FHR4
         m+7GHlrX9CNp8FkS42fchMl9+cE+NUNeXj2qcHr+XtDAKPDVTOF5UO1+sTJJef4iyFAC
         tMPI+JJWc0rMtt4J37o4LBxct47J5WhadwJ6FAE0pIpsL8hrORJvW67bsAjfA5xzgfEU
         gzvQ==
X-Gm-Message-State: APjAAAUfOt/UM3QDPNexKKX50sOseGJkWK0xnCoi5h0dseTKt5kHyOPm
        v0Zi5E84nE1373N04kkY8K++2HeuqgY=
X-Google-Smtp-Source: APXvYqyxEoq4RQyRBZSKqi/7eCO76e0Mb64QAAHVD9FyhmQgJ8KOs2rGL9tQlEgZ8hsi0GYMeIAyvA==
X-Received: by 2002:a17:902:d70b:: with SMTP id w11mr4562619ply.313.1569353534586;
        Tue, 24 Sep 2019 12:32:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a4sm2382630pgq.6.2019.09.24.12.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 12:32:14 -0700 (PDT)
Date:   Tue, 24 Sep 2019 12:32:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCHv2 iproute2 master] bpf: Fix race condition with map
 pinning
Message-ID: <20190924123212.44d7835d@hermes.lan>
In-Reply-To: <20190920020447.29119-1-joe@wand.net.nz>
References: <20190920020447.29119-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 19:04:47 -0700
Joe Stringer <joe@wand.net.nz> wrote:

> If two processes attempt to invoke bpf_map_attach() at the same time,
> then they will both create maps, then the first will successfully pin
> the map to the filesystem and the second will not pin the map, but will
> continue operating with a reference to its own copy of the map. As a
> result, the sharing of the same map will be broken from the two programs
> that were concurrently loaded via loaders using this library.
> 
> Fix this by adding a retry in the case where the pinning fails because
> the map already exists on the filesystem. In that case, re-attempt
> opening a fd to the map on the filesystem as it shows that another
> program already created and pinned a map at that location.
> 
> Signed-off-by: Joe Stringer <joe@wand.net.nz>

Thanks, I put this in as last patch for 5.3.
