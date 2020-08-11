Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF8242200
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 23:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgHKVdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 17:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgHKVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 17:33:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC87C061788
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 14:33:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so135454plz.10
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 14:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1XmU1UxtFoX+JxWRWBVQUmWx0SHpCQU0BLn06Acf+NU=;
        b=nO3gYAQ3UHUw7olEjw932d3zFLqOCCUdnacl9cVKrUgmFx2PGjAFNp8CQwEB7V4Hmy
         FGOy733ZHh3A1xH6oKC3op8DvO/HEaTRYWhxchiQa9h8rnO5vamgJzN81P21hsQ5n8I3
         t7TvIriH92cU2JNs0mnOTN8SDZ89gDDMfKKUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1XmU1UxtFoX+JxWRWBVQUmWx0SHpCQU0BLn06Acf+NU=;
        b=dB/UmSFf6dwIV7Fh29ujS4wO2qqwgxg81MhI7ZnJS6o+aNUXcff3Sqv8W31D7eoumL
         ZkR0xx+wP/o0ipaw5e7Et5hK/zHGdhzi48rA0CSb1NDdi/A2jKGMdM6AypwJ+RhgGKLZ
         GcDv9wKK8WNxu2VIJ1wz7D8o06xBwL/gcgS3aWzSR+dMWHLxv8ItOM389djdjFMvGZ3V
         la7gHpJCLrEDbGaNcR6Kx4DB2o5Qb5WY+kRS8SpLFpaNOcoVheHPmED97hd6lz3EWyuo
         BpAEZ9DeWYFP6ZeV8m8Tcu1SVJCVa7ogKLTQX6MzSy9qFA6FWVnUqt8iS9pHb6qbpXBl
         MZ8g==
X-Gm-Message-State: AOAM531X7G614z1Hg/9wvJqtxBib9s0Q7hI7GAFrhGsbD90qaST+H2DE
        Ata0PbwYaWuLsff3g8Mk4nscUA==
X-Google-Smtp-Source: ABdhPJzVUgwczR2LI6waXoChEBBAZmQiyV+rznpXD/j383hrrCcUrIvWs+lVRQIEgQVz81ia6sNYwg==
X-Received: by 2002:a17:90a:ccd:: with SMTP id 13mr2785480pjt.123.1597181595355;
        Tue, 11 Aug 2020 14:33:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k12sm3694242pjp.38.2020.08.11.14.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 14:33:14 -0700 (PDT)
Date:   Tue, 11 Aug 2020 14:33:13 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Allen <allen.lkml@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Carter <oscar.carter@gmx.com>,
        Romain Perier <romain.perier@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        alsa-devel@alsa-project.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
Message-ID: <202008111427.D00FCCF@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de>
 <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 02:16:15PM +0530, Allen wrote:
> Here's the series re-based on top of 5.8
> https://github.com/allenpais/tasklets/tree/V3

Great!

> Let me know how you would want these to be reviewed.

Was a Coccinelle script used for any of these conversions? I wonder if
it'd be easier to do a single treewide patch for the more mechanical
changes.

And, actually, I still think the "prepare" patches should just be
collapsed into the actual "covert" patches -- there are only a few.

After those, yeah, I think getting these sent to their respective
maintainers is the next step.

> Also, I was thinking if removing tasklets completely could be a task
> on KSPP wiki. If yes, I did like to take ownership of that task. I have a
> couple of ideas in mind, which could be discussed in a separate email.

Sure! I will add it to the tracker. Here's for the refactoring:
https://github.com/KSPP/linux/issues/30

and here's for the removal:
https://github.com/KSPP/linux/issues/94

if you can added details/examples of how they should be removed, that'd
help other folks too, if they wanted to jump in. :)

-Kees

-- 
Kees Cook
