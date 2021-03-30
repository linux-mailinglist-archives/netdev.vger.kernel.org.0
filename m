Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B85F34E0EB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhC3F51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhC3F5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:57:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAC0C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:57:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v3so10952441pgq.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=QkKS8aZxjoxGnHwxCZI9GftddQKE4mm0bz9A7vdNuio=;
        b=QztJZnn+3Y4UJDYMc34IlXE0iJLgHgVlD8Vvvz2hRz68kDJUIooryLoXNQ1fe3w4Em
         lDcpe0XKQFkIDp2RQRVWEiXuQgUu3yZSRyOhxjOm7Ij9EDV3j9FJCR8Bag0kNvKEELaN
         PdPt5t94zmPuC9n55gRo2+rozgJo8UYa5FD7T+mU9GCJ3s8BgwKcnQIBJ+nQcYnGnMJA
         Gb4m6bRMhi1k7NKz22JjGQeKlmnXDA+lq6/2xx/sL4ACxwq8isT2gBipNVMx5wz6CvyG
         x8nwAgCBlFCITR1qY1+92Q3RyUXcSG0kKgqn+vDN4Z9gdHWbu9+W7K/a7fqydCzG+IQ/
         xVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=QkKS8aZxjoxGnHwxCZI9GftddQKE4mm0bz9A7vdNuio=;
        b=l+QHbJL6KIrslwe+rK+H0DoRAVrtCAwtNtaPmvJnKJEknnUPEe0i+xe4P9WCknNC1c
         hFKJM2dry2WHkms6w7clUuyPvfA1xLBbOs8rxl7zDC6TIYxB1PJ0NttR/ZTbeNSi0jNG
         2xYmAYgtfCoSklvo9wlJDflkGI0Cx9gOncfORm3URONamOdnOdeSxPzVENaL6Mp9tAsX
         uN325BUhbfT2RgHgrpyrHPvVG6UyBmhuqsqaeqa15BjLY4W7p2juZi8cNRkSWofYwdd+
         qQkHOLahcXRnsefF9AlG7BnsFaAR8T3+hR3QuVtreSOG4MhnNKOtmMyL1Z1CrkFYKffc
         5tLg==
X-Gm-Message-State: AOAM532n5tPJAphmVKvBLrW5kmyWgrIBcISMlw5PKP6aXbi6rQP8vyCQ
        98zrUFeNTixb16VuFPnPh7d2Ew==
X-Google-Smtp-Source: ABdhPJyLBrduyyHAog2v1d9KM4hOKfibLyBUvOCfzD+4Fw37UFKeK2GPJ/FoQi7uLikzNnyiIMaadg==
X-Received: by 2002:a63:1144:: with SMTP id 4mr26640237pgr.333.1617083827368;
        Mon, 29 Mar 2021 22:57:07 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id g15sm4889075pfk.36.2021.03.29.22.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 22:57:07 -0700 (PDT)
Date:   Mon, 29 Mar 2021 22:56:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: tc f_u32 bug detected
Message-ID: <20210329225659.568c8700@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After seeing a user report of trying to use JSON with tc, started to fix some of it.

Found a surprise. The display of U32 filters confuses IPv6 and IPv4.  The code in
tc/f_u32.c is obviously wront in print_ipv6(). It is just a copy/past of IPv4.

Almost want to just remove the bad code and let it dump the raw filter.

There is still lots of code missing JSON in the Tc filters. Volunteers and patches needed.
