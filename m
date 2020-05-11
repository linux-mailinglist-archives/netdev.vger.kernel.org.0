Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73391CDCC6
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEKONa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:13:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37778 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbgEKONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 10:13:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id x10so3992299plr.4;
        Mon, 11 May 2020 07:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OZEIorHaxAgVk8tXwMYpPYJTnU15riroFxTlZzxMGoY=;
        b=NFwnbaRdKb/MG0EhIoKzcerRLvdISY08pDODi09BCWepHTec4ARyeTzmgH5mKEzLep
         khF5Ho0acAdDLc1JzSxJFTZPF4RNkV+ZNRUzcyPQMi8y4GCzr0JK4bZr9fLSSMlx5eNH
         quY80wmvM43Sp2ZErumQ1sudYWckLUKPbjciHZ2OGDKqHCeuq4PsidBQbXbY1lCFsnS8
         RbrPAaPm5FFa7OO6XzjmFRrJ3p0xML64tT6/p2af71b5JuOoU0h89i4fFOJqOyCKGz1k
         V6RegZTrdIQU91zM6ggJ6XOUbxzziFOYdECMtiAVX0ohcAkFJfT65X642AcOTCxE+SIh
         6UhA==
X-Gm-Message-State: AGi0PuakkDQJbuVeisQ6nZwGkQUO2Mn83Po0h1mXRI632R9eSOvGZqM+
        NFgNUXMUrqhjgtyDaJ1ukpU=
X-Google-Smtp-Source: APiQypKUuFyt94VWg5zbOUc0tpZSyVaLJaz5nZz5HPWNK22nq+c7IWmoodIm6WEFGB2pMV3qQbTqlg==
X-Received: by 2002:a17:90a:ead6:: with SMTP id ev22mr22563757pjb.94.1589206409284;
        Mon, 11 May 2020 07:13:29 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q62sm4723143pfc.132.2020.05.11.07.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 07:13:27 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 0DB6940605; Mon, 11 May 2020 14:13:27 +0000 (UTC)
Date:   Mon, 11 May 2020 14:13:27 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Andrew Lunn <andrew@lunn.ch>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware crashes
Message-ID: <20200511141326.GQ11244@42.do-not-panic.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
 <20200510015814.GE362499@lunn.ch>
 <01831b19-5890-e7e0-3801-068dfab5c92a@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01831b19-5890-e7e0-3801-068dfab5c92a@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 07:15:23PM -0700, Shannon Nelson wrote:
> On 5/9/20 6:58 PM, Andrew Lunn wrote:
> > On Sat, May 09, 2020 at 06:01:51PM -0700, Shannon Nelson wrote:
> > As for firmware, how much damage can the firmware do as it crashed? If
> > it is a DMA master, it could of splattered stuff through
> > memory. Restarting the firmware is not going to reverse the damage it
> > has done.
> > 
> True, and tho' the driver might get the thing restarted, it wouldn't
> necessarily know what kind of damage had ensued.

Indeed, it is those uknowns which we currently assume is just fine, but
in reality can be damaging. Today we just move on with life, but such
information is useful for analysis.

  Luis
