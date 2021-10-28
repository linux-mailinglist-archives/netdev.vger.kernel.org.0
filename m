Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38043E03D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJ1Lvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhJ1Lvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 07:51:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22C4C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 04:49:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n11so4258956plf.4
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 04:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ov6c+zPRGeMizKn7SbuWPGL+CHKcK0xeK8aIx4e+JSk=;
        b=bjiWPaaHw4svygg7KIZvLWXISfYxVJscdIMcLiK9XzmYgL46LrKhSaYZMl/vYnn7gk
         opgbIVR3/3BKpXDCkU6YKKlPLVOVsc+lm20tm+pFMjhM3+TKsAgUSsWZ4Wb8OaJjqDJi
         KWaGlT/p1gQuy4zq8p7BdXbYjvtu5C0pzTvpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ov6c+zPRGeMizKn7SbuWPGL+CHKcK0xeK8aIx4e+JSk=;
        b=oFJM+L/3ggHsQVbHJ5Jgx2lP7w30KxjjZ3SSUX4q3cSANbJVdW1jgqOmlI+i/ADluU
         lM1PpITY4lTcjWkc/0s61JEPQ90/1H8fNu9Edb1BeKpV/1vjcXb451KOyirYMwNe9DWF
         gVX6WIgjwzRyBGwZqICmfz4F9yA1G+y/j/dShm/CiK8AB5jw1t0opsk7qoCpMjmsAEEF
         0iVsvBB1u2ZqoHjo8DExBffGKR8JvokXKN7fDWgJB/cThEt83nYzCKfgKB3OHlfWfg/w
         qq5Z+e5pbX0MCLZbc0M7MzD3Nb4oDsHj6sG21XdR3rBT7T90bi7W7ccDKFtZRZe2rasS
         cSLQ==
X-Gm-Message-State: AOAM5302LxYTWKU7VukKmcuE9RrYnaumrkwUhndIbXYmYaLCaky2zMVm
        L2EgjGIyJclyD2zCaGt0fVy+3w==
X-Google-Smtp-Source: ABdhPJxwV7glc+PtUXZtnadR079SuTi4T3p/g/VoHc6SV6YA/ggip8Sr8zRDvD/iIs9FtH41IoLFnA==
X-Received: by 2002:a17:902:ab53:b0:141:7167:1c4f with SMTP id ij19-20020a170902ab5300b0014171671c4fmr3457128plb.30.1635421745269;
        Thu, 28 Oct 2021 04:49:05 -0700 (PDT)
Received: from cork (c-73-158-250-94.hsd1.ca.comcast.net. [73.158.250.94])
        by smtp.gmail.com with ESMTPSA id s10sm2769493pji.55.2021.10.28.04.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 04:49:04 -0700 (PDT)
Date:   Thu, 28 Oct 2021 04:49:03 -0700
From:   =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Caleb Sander <csander@purestorage.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 1/4] i40e: avoid spin loop in
 i40e_asq_send_command()
Message-ID: <YXqOL0PqhujmH+sd@cork>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
 <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
 <20211027090103.33e06b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211027090103.33e06b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 09:01:03AM -0700, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 10:55:05 -0700 Tony Nguyen wrote:
> > +			cond_resched();
> >  			udelay(50);
> 
> Why not switch to usleep_range() if we can sleep here?

Looking at usleep_range() vs. udelay(), I wonder if there is still a
hidden reason to prefer udelay().  Basically, if you typically want
short delays like the 50µs above, going to sleep will often result in
much longer delays, 1ms or higher.  I can easily see situations where
multiple calls to udelay(50) are fine while multiple calls to
usleep_range() will cause timeouts.

Is that a known problem and do we have good heuristics when to prefer
one over the other?

Jörn

--
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
