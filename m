Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911F12A5CE0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 04:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgKDDFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 22:05:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgKDDFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 22:05:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ka96c-005915-En; Wed, 04 Nov 2020 04:05:02 +0100
Date:   Wed, 4 Nov 2020 04:05:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA and ptp_classify_raw: saving some CPU cycles causes worse
 throughput?
Message-ID: <20201104030502.GT933237@lunn.ch>
References: <20201104015834.mcn2eoibxf6j3ksw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104015834.mcn2eoibxf6j3ksw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My untrained eye tells me that in the 'after patch' case (the worse
> one), there are less branch misses, and less cache misses. So by all
> perf metrics, the throughput should be better, but it isn't. What gives?

Maybe the frame has been pushed out of the L1 cache. The classify code
is pulling it back in. It suffers some cache misses to get what it
needs, but also in the background some speculative cache loads also
happen, which are 'free'. By the time the DSA tagger is called, which
also needs the header in the frame, it is all in L1 and the taggers
work is fast.

Without the classify, the tagger is getting a cold cache. And it ends
up waiting around longer since it cannot benefit from the speculative
'free' loads?

In your little patch, rather than a plain return, try calling
prefetch() on the skb data so it might be warm by the time the tagger
needs to manipulate it.

      Andrew
