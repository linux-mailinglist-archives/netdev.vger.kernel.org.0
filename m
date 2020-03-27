Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F1194E6F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgC0B22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:28:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45680 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgC0B22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:28:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id o26so3792831pgc.12;
        Thu, 26 Mar 2020 18:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tU4XA8irroYMzripT/awkGxqg4KUUGMF4aMQNnVQrEc=;
        b=HuWKfMMp13GcvvShQD4GZ6Lo/bkghLBF2++b2dcgInZA0LVD1yZomRML9odZu51CAT
         SZVFC57nqCpJ/AuVM4cMjWqK6bI/J3lnQ3y7frAGxd2Cbntuc9JjmZlmnSKoRnS0VyM/
         nnk5K9g1ol4aEg8UXyI+K+yqnJnhikQ/JHkQaVZKBzpMVe8f0wEyslwaw7bWB2X1Cv+f
         k3cjIwyBLJz4kuYrQzuUs04aESGP1e0D+GKTTS+oxVGd4e/nttc+DsyXcrBO0mYSDAvZ
         hLevwAPRd7okUy6LT0Ocn9XxsXsIRhuiR35/g8F/IGYE73uwOycfLvPXzt3DqOGetry1
         t9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tU4XA8irroYMzripT/awkGxqg4KUUGMF4aMQNnVQrEc=;
        b=Egw8WQbFKGQVbwcc3aTofml9mZZIQc1R0uZ5U+bWi2dreHnas57fzotN2dpO5eJD84
         ryErC7Oqjg4RHGyY6aDVcnWGvtWroMbv4B55qLAhsLvobbQCi5extAbVBkDCwTMNsU1o
         MkIMr1I0b07OCdz9NU3c19ZC0/mYhorfm79OSsP51G/QIdek+32CqIKzQOxSUHohD3qY
         YkP1P1hTAZojqtDGyUxrhu5PGnCfO4zd8FPqQJb4aiCQ7leZ2/hSW7GUYqFbjYZO0Bb4
         gSmHkoSCSIHX9r6LEIGt097KPRa45fBVDA34yU8WDblo67pN1wApZ47SToutHgH+AcLI
         SIVg==
X-Gm-Message-State: ANhLgQ1PoCL8nriWz8UmILACoF1d4/h6+jGwwYCkIxztizwk/21Lis4N
        J3miTmuUlZNhCW9fVd9WssA=
X-Google-Smtp-Source: ADFU+vvbJ14huQcPZe5YKPn+wUwRWgJM6wzrP5DkgRQsjFgr5CroWbeCJn+kp820/djlDMuzK9TdhA==
X-Received: by 2002:aa7:87c1:: with SMTP id i1mr11486026pfo.44.1585272507083;
        Thu, 26 Mar 2020 18:28:27 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e6sm2649643pgu.44.2020.03.26.18.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 18:28:26 -0700 (PDT)
Date:   Thu, 26 Mar 2020 18:28:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 07/11] net: ethernet: ti: cpts: rework locking
Message-ID: <20200327012824.GB9677@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-8-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-8-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:40PM +0200, Grygorii Strashko wrote:
> Now spinlock is used to synchronize everything which is not required. Add
> mutex and use to sync access to PTP interface and PTP worker and use
> spinlock only to sync FIFO/events processing.

If you haven't already, I suggest testing this change with lockdep
enabled.

Thanks,
Richard
