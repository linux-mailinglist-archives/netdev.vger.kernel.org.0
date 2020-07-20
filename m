Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B842226074
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGTNIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgGTNIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:08:44 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E1CC061794;
        Mon, 20 Jul 2020 06:08:44 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id u8so7290112qvj.12;
        Mon, 20 Jul 2020 06:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZcNRc5bT6rFiMspLnEro2HYm+KRHyWtQoe9oRgtNo2w=;
        b=rd1IYwVpEJYJ5xckMH31vYhtq46ZpNKX0h3vJJD7TfpBaAlttllKOh4DfiWxAe3nuZ
         o28Ql8XRhVzhL7tsY+BiKDwiefk0VCziVcRLkQLAsA3srfls3kFQoAYGNbdJ8nV5lj88
         cCbsP6QUDmPDb0evE76zFxIcjhV8h/SwhBKfTlrZ8cWoP0QBys010B/dTSj1M+81zw5u
         Kf6kMbKMT667pahwxEMx1It0uDbX96MlmRCmvQDMdsrSWQuwyjn+4Zk1vFsotcX8i37j
         /ekyTVJOVV/W9+LbCtQhTk5+qJo54tDOdMHZhK8nvd12l8s5bBKwNKzB+zmw9MQXManL
         bEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZcNRc5bT6rFiMspLnEro2HYm+KRHyWtQoe9oRgtNo2w=;
        b=rRwcUIfXM4WPj+wH6wKLrBLNhqrh8ronpZnTVuoDpWek28G9X5ACC73gvlDJvBaX2R
         coQhTSGbuFsQfzCTOIBSbUcEKTGBxDw10kmDGi06wN1et2anPWo1j/wiMqiA3T2GV4Zl
         NEwzzhtvV7/rglkgYbtMDZtxhF2ifcfxKmesrhHHdfKIRO1EL9MAv4ToAcd3nqHi33F0
         OlavPr6na2MqZjXuDVOmy6IUAzQ/9X8H+2RIYbKXbTqkiGh+R7fr8wzOhRDhVVGOMstG
         8mYf/1y0o1mGUJvVhD8sXtfwiZOe4qLbuehJtouzv41ICeNvqOUM5nrNTruC9gKkU7an
         UkjA==
X-Gm-Message-State: AOAM530rR+Y4YU0ZB64jIsfuwZxBZWcxaN8jqN+xR1dqxig0obv2UK2u
        jN747AztB/n0D6VBfohSWx4=
X-Google-Smtp-Source: ABdhPJznKFcD6BArGICC2hipTHTnj5/HC6sC9VbNtWBt0H20ev8b7ZSjjhaCRFwJAB0xNG+Rs7M/hg==
X-Received: by 2002:ad4:4105:: with SMTP id i5mr21037246qvp.170.1595250523781;
        Mon, 20 Jul 2020 06:08:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:97d4:431e:ed87:df3d:c941])
        by smtp.gmail.com with ESMTPSA id h15sm275133qtr.2.2020.07.20.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:08:43 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8C7C4C50C5; Mon, 20 Jul 2020 10:08:40 -0300 (-03)
Date:   Mon, 20 Jul 2020 10:08:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, David.Laight@aculab.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: do a single memdup_user in sctp_setsockopt v2
Message-ID: <20200720130840.GB2491@localhost.localdomain>
References: <20200719072228.112645-1-hch@lst.de>
 <20200719.182727.141244810520299886.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719.182727.141244810520299886.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 06:27:27PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Sun, 19 Jul 2020 09:21:37 +0200
> 
> > here is a resend of my series to lift the copy_from_user out of the
> > individual sctp sockopt handlers into the main sctp_setsockopt
> > routine.
> > 
> > Changes since v1:
> >  - fixes a few sizeof calls.
> >  - use memzero_explicit in sctp_setsockopt_auth_key instead of special
> >    casing it for a kzfree in the caller
> >  - remove some minor cleanups from sctp_setsockopt_autoclose to keep
> >    it closer to the existing version
> >  - add another little only vaguely related cleanup patch
> 
> This is all very mechanical and contained to the sockopt code of SCTP,
> so I reviewed this a few times and applied it to net-next.
> 
> Thanks Christoph!

Yep! And way easier to work with, function by function.

Just for the records,
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Thanks.
