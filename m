Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA511E158C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgEYVSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEYVSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:18:51 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CCDC061A0E;
        Mon, 25 May 2020 14:18:51 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e16so8771218qtg.0;
        Mon, 25 May 2020 14:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EEE9i9EJ57T3cOvJ5DFmf8mRafwm/Mp/1X37ijaEc9E=;
        b=tDij+31TJbOz1MCFnYtZNFSHf7t48PkGiXoLqCMk26I+KUt3tw1ID5KVZqa0syeuQ2
         FjCV3xfUFgdntQodSdy5U57ANMVPdc7nTTBNSt9ZWJc6kWXznzN9g6JorCM5r+g0VJPK
         XhfiGnHDDPc8nmJQT/DFdZ3v+FDoMOLeA0pZTBCQm8gnYZzUfDYOJTWRtGrEblXLj7rt
         bOLKB0R0Ke1xtjSQFzESN007F9hz8XiSNJeHcyGmbp2akWB6efgdIjp62urPSIG14NJf
         nWtZlTmPIJBM4CcT1LLKRy8zmAMrSRI7kERfykh4/lkT+i4RAeUCzxZQ9PWi1oh+LP3g
         4q2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EEE9i9EJ57T3cOvJ5DFmf8mRafwm/Mp/1X37ijaEc9E=;
        b=QjA9LGUDQyebU35R4wEjxhKys3SeUiPSLAOPuZ2/g/N/c0ZLTVlWkLkpUxtz+dRH68
         GdXF0YndYpMPJ9nrjyrnWj2Yu/C1QlzaXDqDovK96NZQfpe3KaKPoVaovScXp1+0BBLB
         JKYOB7Yd9Ntr2EswoQH8Tfi34AeuplIWoFCCSz2l1PdDP9u6rHio3mWKsA3N/VPX9TWT
         lvkv4pxvfRXSdqfLv/3YR23e/LUJq3VMDiuuz+T3ZwjeJ3l7M9ZyGLieh/Sr86gJr+gG
         W5L3+tm2bZEmDj7UKEaiGY//50CnWQ1Q+yPCL5V3qDFJvtzITqsf5Z6bOj2zABJh5V+g
         A31g==
X-Gm-Message-State: AOAM530TgCl0JfkAFRhb79t/Xrgtwbkop1U4UI2AikYs411NPtMC520N
        MeBhx7ENsSNXLALYTPfxAt8=
X-Google-Smtp-Source: ABdhPJztTPnoAsqP2u5+PFMzv8mlHNLOpYASXIgJlPJl0Z2APR0OCLBeFffNr5CoPQgMl117TmvSCw==
X-Received: by 2002:ac8:1303:: with SMTP id e3mr25556511qtj.25.1590441530208;
        Mon, 25 May 2020 14:18:50 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id y28sm17041451qtc.62.2020.05.25.14.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 14:18:49 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 197F9C1B76; Mon, 25 May 2020 18:18:47 -0300 (-03)
Date:   Mon, 25 May 2020 18:18:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     'Christoph Hellwig' <hch@lst.de>
Cc:     David Laight <David.Laight@aculab.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-ID: <20200525211847.GD2491@localhost.localdomain>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523071929.GA10466@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 09:19:29AM +0200, 'Christoph Hellwig' wrote:
> On Fri, May 22, 2020 at 11:36:23AM -0300, Marcelo Ricardo Leitner wrote:
...
> > What if you two work on a joint patchset for this? The proposals are
> > quite close. The differences around the setsockopt handling are
> > minimal already. It is basically variable naming, indentation and one
> > or another small change like:
> 
> I don't really want to waste too much time on this, as what I really
> need is to get the kernel_setsockopt removal series in ASAP.  I'm happy
> to respin this once or twice with clear maintainer guidance (like the
> memzero_explicit), but I have no idea what you even meant with your
> other example or naming.  Tell me what exact changes you want, and
> I can do a quick spin, but I don't really want a huge open ended
> discussion on how to paint the bikeshed..

What I meant is that the 2 proposals were very close already, with
only minimal differences. As David had posted his set first and you
didn't add a RFC tag nor stated that you were just sharing the
patches, I understood it was an alternative approach to David's, which
is not optimal here. This topic is far from being that polemic, that
could benefit from having 2 competing approaches. So first I wanted a
joint approach, and then build on it.

For now lets see how David's new patchset will look like. It was
almost there already.

> 
> Alternatively I'll also happily only do a partial conversion for what
> I need for the kernel_setsockopt removal and let you and Dave decided
> what you guys prefer for the rest.
