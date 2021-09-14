Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBBD40A98C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhINIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:47:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55408 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhINIrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:47:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3B18A21EA2;
        Tue, 14 Sep 2021 08:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631609174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZkMH63iTQ1WWrdV9xSbbANfuGbUt17bCT5Dl2F/Da0=;
        b=XWISWXbcR3YdaeFQmM4w9+ukkxf4jSK2eqmQDo5iZ73XBLhF4jEDM8+2E0VxGtr5eFJxiC
        nmb3T0gwe1ndT5H4JdLDKKBI4kjUyc4fjA7c0T2KqDcf4D22+99oItZYY+wjvqFoIvzlqP
        K00ktKQrEH5F+uB2Tz7EXYr8uqK/J68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631609174;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZkMH63iTQ1WWrdV9xSbbANfuGbUt17bCT5Dl2F/Da0=;
        b=MJG30rqDnzxe65gQiiRdUUjTdYTTjoLnMy+u/ZtPzlpYnjvOOgqHQqAJZ29ngBM7p6RPor
        ImJkDb/zx1w6yLBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29AD313D3F;
        Tue, 14 Sep 2021 08:46:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KUIwClZhQGGpLAAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 14 Sep 2021 08:46:14 +0000
Date:   Tue, 14 Sep 2021 10:46:13 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v1] nvme-tcp: enable linger socket option on shutdown
Message-ID: <20210914084613.75qykjxweh66mdpx@carbon>
References: <20210903121757.140357-1-dwagner@suse.de>
 <YTXKHOfnuf+urV1D@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTXKHOfnuf+urV1D@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 08:58:20AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 03, 2021 at 02:17:57PM +0200, Daniel Wagner wrote:
> > When the no linger is set, the networking stack sends FIN followed by
> > RST immediately when shutting down the socket. By enabling linger when
> > shutting down we have a proper shutdown sequence on the wire.
> > 
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > ---
> > The current shutdown sequence on the wire is a bit harsh and
> > doesn't let the remote host to react. I suppose we should
> > introduce a short (how long?) linger pause when shutting down
> > the connection. Thoughs?
> 
> Why?  I'm not really a TCP expert, but why is this different from
> say iSCSI or NBD?

I am also no TCP expert. Adding netdev to Cc.

During testing the nvme-tcp subsystem by one of our partners we observed
this. Maybe this is perfectly fine. Just as I said it looks a bit weird
that a proper shutdown of the connection a RST is send out right after
the FIN.

No idea how iSCSI or NBD handles this. I'll check.
