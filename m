Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378E93B33CB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhFXQWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhFXQWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:22:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114FDC061574;
        Thu, 24 Jun 2021 09:20:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f10so3237793plg.0;
        Thu, 24 Jun 2021 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z74dwwgtRQUNlIhpbvBd55oULYHT3xtpRXCFegJuaBk=;
        b=QpojiMkpIGXZrFeJGLV5n2qfczA2Oh6WSY7PIwpX5/5cZdrklKqAvDJlDnk0BP6fvH
         kx9+wN82z5YXG1A78/pVNc3M1s6Q5x93yD1A/XIm9mUS0H3564tUVKk3f2Kix2SBRyIg
         +04aeYa9ZkXADAgLVGxNYJeOelQ6ESbFUYmWD33MOjVf00yXTd2o7HL2Zow11ORvMa9U
         C4afE4kRcyyCJhFsb6DFyopt/+LNRaYygaFxuvoTQvaMWIgNHIcQtx4HmGrSsqIxH67q
         GCo5OZBWcVe6Yr+EYZt1MIbgKQtV+sl8CPVgp8vfqVbyDPaS0BqzsjEc9ZFyyqYWdyG4
         3WtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z74dwwgtRQUNlIhpbvBd55oULYHT3xtpRXCFegJuaBk=;
        b=DDbIQsObQXDmGN2WeUoT8/Or+R6qMkRAnDcmOlq03rGnVPF6r6LEU2maCdcGxwfJd1
         E2fn5I7rgI3A/4cPxbANOt725fNXVixdMKA8DeepocsN/TXjf8UQFVkNxEBrJT9iO9Bk
         ZN5iBRP+aXDIUfdbNT1bu87XYoIwYJ6xE/bphqQYxUgogyllQhAD2uES4U+PtYX2xjg1
         eMs0Hpn+CPz6Ar8nIgyvCwYYkWsDTpG8pQ3vS4kNDMSZ7xZrDL3IkRgWfzahHIO/ZG9b
         9lqfsDyHtUIDq2BWj2BLVtGWi9hRjrsOzWbtVOHkuYrM7FCjjgsNfb8akqZ5Au7MVgVB
         yQCg==
X-Gm-Message-State: AOAM533KrvyMSX9leDSKoGa+6XsQGh3h/+Hw0l72vqR54jQS0qddwK48
        5GMbfskMqmghbQaqTx0xdFo=
X-Google-Smtp-Source: ABdhPJwU8u61c4LPsf9ja2M8QJWl85/yzOJOSnKytjVtEPpVjLGhbsuCjmIKTZGBpWd2bhthsgIEGQ==
X-Received: by 2002:a17:90b:3253:: with SMTP id jy19mr16693711pjb.196.1624551632637;
        Thu, 24 Jun 2021 09:20:32 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a9sm3246397pfv.185.2021.06.24.09.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:20:32 -0700 (PDT)
Date:   Thu, 24 Jun 2021 09:20:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Message-ID: <20210624162029.GE15473@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
 <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 02:38:46PM +0000, Min Li wrote:
> I have tested this change with ptp4l for by setting step_window to 48 (assuming 16 packets per second)
> for both 8265.2/8275.1 and they performed well.

Both of these patches assume that user space has a special
configuration that works together with the non-standard driver
behavior.

For this reason, I suggest making the new driver behavior optional,
with the default being the origin version that "just works".  In that
way, the admin/user can choose the special configuration on purpose,
and the default performance will not be degraded.

Thanks,
Richard
