Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923D62FD17A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbhATMtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389171AbhATL2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:28:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05A9C061575;
        Wed, 20 Jan 2021 03:27:25 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 30so14996373pgr.6;
        Wed, 20 Jan 2021 03:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNgmPmxDTYXqVVuxNtDhauIa5+ndfKYL0tyZwSQ0sU8=;
        b=PAnGRy7z8ipQXt+ToOR3gWdY0oN+BDZ3whhqD00D/9ajZKFgZd9Lq2LldXy+wAiZH+
         0dgGv/BRB63P6gDLn/BQMKH1mURKLnF2U/ku6XrLiDQP25dF9+5JwEcx3GdxYSCYabP+
         FF6AWrTQYR39LIoEMdUF2XSx0DsVcKp3jtAGQ1DIn4EyuQRGkqjGw9TcvzkS/3V5XW/Z
         hinzc/xEzLfEDaXMy4V5vmUkJgAW814QOdYfVOR7zQ8U033gZ9sm+gdmBA4zIn8+1B8d
         qfaqGouDoGj4bRatEbPAOiYh4P3s/pAdza/MtBsXlFPtj2xesQHP1s6Zs7evVWlhWXph
         feVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNgmPmxDTYXqVVuxNtDhauIa5+ndfKYL0tyZwSQ0sU8=;
        b=ZpwHV+0ujZ/FPslw9LpN2C6zwI2PZTD25QhmnkBjoikTpwVMAPmu8X140JFje+69MG
         KNSrDamcLVI/duqn1QnF4J1wh4whfaPfsibNKLv8NotXS+9Ms5XjQmdvJsWv0pJJjkZL
         gFkft7srgmIrlLP9lhDMZtH8/mbl7YetnNhmnSqK0xuNjhCqCYyE6rSZd/4xJfkx7v3P
         0DO1RCMYDqoF7uCCZ/u9uRNFaj32nI7NbOGe/rwoe2W8JcySuyIFziprzMFlmsTVStS1
         kSdRKN26MGJ/RGec0x+Ef+woIfCms1DY7WNwq7tE3DcobJ3hcXQKxTAzOxsYasLtcYhH
         524A==
X-Gm-Message-State: AOAM533eiTVGZ1ca2NoOEJTnwVc6+67jLedlL5JK/pIvRcxcHCVrN7+4
        Pen+VO5SKiJmxbrDMAfTAi/4Je2y7xHFyHJUgR6m1J8sdWg=
X-Google-Smtp-Source: ABdhPJxtyrvr+FSPvPskMhyeStnqtlV0/0LHxyp5owEGdDIRG9+TKMUo0oVNxGPYZ0jTrG3AV+0h9s+iiYjmJNlQiAE=
X-Received: by 2002:a65:4783:: with SMTP id e3mr8951650pgs.368.1611142045198;
 Wed, 20 Jan 2021 03:27:25 -0800 (PST)
MIME-Version: 1.0
References: <20210120102837.23663-1-xie.he.0141@gmail.com> <c638797f2e2ed284b39abb165bf73251@dev.tdt.de>
In-Reply-To: <c638797f2e2ed284b39abb165bf73251@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 20 Jan 2021 03:27:14 -0800
Message-ID: <CAJht_ENQyZq3wAkNWcoPje5dEjONYHTc-YDD0ebv0c3nf2fLFg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: lapb: Add locking to the lapb module
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 2:58 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Can you please add a Changelog. What was changed in v4?

Sorry, I forgot this. Here is the change log:

--- Changes from v3 to v4 ---

Only lapb_unregister has been changed.

v3 has a problem. When "del_timer_sync(&lapb->t1timer)" is called, if
the t1timer is running, it may restart itself by calling
lapb_start_t1timer. This way, del_timer_sync would not be able to
guarantee the t1timer has been completely stopped.

v4 fixed this problem by first calling lapb_stop_t1timer, making use
of its (new) ability of aborting running timers, and then calling
del_timer_sync to guarantee the t1timer has been stopped.

--- Changes from v2 to v3 ---

Created a new __lapb_disconnect_request function and made it be called
from both lapb_disconnect_request and lapb_device_event. This reduced
redundant code.

--- Changes from v1 to v2 ---

Broke long lines to keep the line lengths within 80 characters.
