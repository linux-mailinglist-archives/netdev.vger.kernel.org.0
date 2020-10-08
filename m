Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A642870CE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgJHIgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJHIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:36:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC63C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 01:36:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so3657922pgm.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wj+dCZrTRErPs8VwdMIYFKp3Mc+zlN18FO3IuxdyW0g=;
        b=Hk63ee8GWMfMw1Xs8QdQH60XZaY+at+9Fa/9WASTEjHmZwDIjWj4ZocHoA3HXzafp+
         +3l6TgzrV0/7gD40da/VHIi7WeiUxCmfeVtZjZsHdbDffqSgRkwvX6zpNi/MCu7L37j4
         Ocs/UlOrjuAFGA0kSpVII7KDu0kKhtDOJo+nexNireEGbsgFnNk8xzNG8jWZ7Qu5OZEb
         24I61WsaYkO09e1hNuO6PmZ/c07esyO6s+ECNu3r6ewg4vw/j1XyPuob0V/fs/MHimeP
         3bn93Dr7gFzryzuAqlRaJJaOmX+ArgJM7VJJ+eto7SFBM+5+3XhdL1ySVgA4TuYqX2O7
         ussQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wj+dCZrTRErPs8VwdMIYFKp3Mc+zlN18FO3IuxdyW0g=;
        b=lcSaxYM4ft4U4RK3eNY9GS5dFctk31yszfszsGZMhI36Dj1EY0htcWjjPUhlE4wI+Y
         rnHrkdHJnhfd/c9V9+UhdBASrgQ8TIXpUt7OTxmXaYCiI31P+9gmQBq9AII4zO0sHSbH
         aYTPEUwvt9ivcLjijn8qbDq4dONJY3bEz3tJSREuu4MBZNlBP+QFP7lPxN+hu2Ppo20D
         G5ID30kitAmlZjV9C6RMkiwy6U14iQ783u3P+YyJuDU09Tcgv40Ubykrs0SP8j6UQkxo
         K93cWplbU3LU7gnEaasAOZ9hf6frSnTAclL/7HnVPN8b5f/2/WP+EYR5XDkPtm0OAHjS
         m6wg==
X-Gm-Message-State: AOAM533cTG1xLPk+WJ9A2ccjudYh4B2JMXorXR72jXcy6p7a8ShZNjK7
        kwuYqbWRq2fRxNFrrXyxcnA=
X-Google-Smtp-Source: ABdhPJzh6KvJK/ab2PLKqvkgILtORTw/dtsIXYGegN8eG/gA5L6scBzrRIYTDVoq3Gzstn9QRZMc8A==
X-Received: by 2002:a62:fccf:0:b029:152:4f37:99dc with SMTP id e198-20020a62fccf0000b02901524f3799dcmr6303298pfh.17.1602146209997;
        Thu, 08 Oct 2020 01:36:49 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d128sm6251923pfc.8.2020.10.08.01.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 01:36:49 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:36:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201008083639.GJ2531@dhcp-12-153.nay.redhat.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201007035502.3928521-3-liuhangbin@gmail.com>
 <20201007075807.4eb064c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007075807.4eb064c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 07:58:07AM -0700, Jakub Kicinski wrote:
> On Wed,  7 Oct 2020 11:55:02 +0800 Hangbin Liu wrote:
> > Based on RFC 8200, Section 4.5 Fragment Header:
> > 
> >   -  If the first fragment does not include all headers through an
> >      Upper-Layer header, then that fragment should be discarded and
> >      an ICMP Parameter Problem, Code 3, message should be sent to
> >      the source of the fragment, with the Pointer field set to zero.
> > 
> > As the packet may be any kind of L4 protocol, I only checked if there
> > has Upper-Layer header by pskb_may_pull(skb, offset + 1).
> > 
> > As the 1st truncated fragment may also be ICMP message, I also add
> > a check in ICMP code is_ineligible() to let fragment packet with nexthdr
> > ICMP but no ICMP header return false.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> net/ipv6/icmp.c:159:65: warning: incorrect type in argument 4 (different base types)
> net/ipv6/icmp.c:159:65:    expected unsigned short *fragoff
> net/ipv6/icmp.c:159:65:    got restricted __be16 *

Ah, Thanks for pointing out this error, I will fix it.

Regards
Hangbin
