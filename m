Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A779A40C10A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhIOH4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:56:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60070 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhIOH4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:56:19 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 24EE32214A;
        Wed, 15 Sep 2021 07:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631692500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIta2I9XsXZcxTWSHaAC7NHANPAr0ZPeLNepZ3aW9Lg=;
        b=rI1PEFSs/PUrf2oumXj3vZDGm+ltc0tNMU4uzKp3U/GU2iOf1TC7Y72CmwBYvk9YgMh00d
        Eq3ajMXzv386ClWpr9o4aYX042chvIMiXmc+PCOyi5gxsgb1SA6bzVHep5h5HuoIF6wtci
        1YozgA75XPtvBL1ONbdChK3cLfOIlWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631692500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIta2I9XsXZcxTWSHaAC7NHANPAr0ZPeLNepZ3aW9Lg=;
        b=xJmi+WxpS10EZ66ojlThwqq8+WfAE+5Yv0MpbU9X2jy2o58GrnEq/b9+vuq+IFk1nxOUEQ
        fa2v4Eeh0uGIHmDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B93213C21;
        Wed, 15 Sep 2021 07:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iLLwGNOmQWFwJAAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 15 Sep 2021 07:54:59 +0000
Date:   Wed, 15 Sep 2021 09:54:57 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v1] nvme-tcp: enable linger socket option on shutdown
Message-ID: <20210915075457.sdj3oq3bhn7itqop@carbon.lan>
References: <20210903121757.140357-1-dwagner@suse.de>
 <YTXKHOfnuf+urV1D@infradead.org>
 <20210914084613.75qykjxweh66mdpx@carbon>
 <a79bf503-b1d5-8d18-5f02-c63e665e2e07@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a79bf503-b1d5-8d18-5f02-c63e665e2e07@grimberg.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 05:20:46PM +0300, Sagi Grimberg wrote:
> > During testing the nvme-tcp subsystem by one of our partners we observed
> > this. Maybe this is perfectly fine. Just as I said it looks a bit weird
> > that a proper shutdown of the connection a RST is send out right after
> > the FIN.
> 
> The point here is that when we close the connection we may have inflight
> requests that we already failed to upper layers and we don't want them
> to get through as we proceed to error handling. This is why we want the
> socket to go away asap.

Thanks for the explanation. The RST is on purpose, got it.
