Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298C734CE80
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhC2LJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbhC2LJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:09:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15619C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:09:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so7552008pjb.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0Qrd6iLxD+REdwDh7ecFRdGdRpfeEJpYQUhfIWlShGY=;
        b=ccdnX+4SXaehMQOTroKSCBMmnB2VpVBXA8I1YLVlhvv2FmMlr3RMWwhwqpK46Q+MA7
         wsg25WXxf16o5lYqkini61nQlEl/AZXceLwKTTs+n2zBoHkYa8ARfR3g1plo3vQwVAf8
         wd4ZU56FdQOKFHcgNiwrQVL2QJTISYML8Lie0L73t4pZtNx3DAZ746f1W0CuJz6lI+wX
         T/cqRIPmEEIOEOmXqvA5FqYRVt5U7GTt0ZFzAtl0fcu7Dba9fHvWdbkcDpH+RNueNsWn
         D1NvIpPGSoGnC/ip6YE5ImRR9bTVP0Y9QjqzoOQYC2BGqvXKzagBs1Ofl2PNWap8mXaq
         WMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0Qrd6iLxD+REdwDh7ecFRdGdRpfeEJpYQUhfIWlShGY=;
        b=LOyA9zt/6il6YQySVXS7ZmE2/2EQnUCySKmwjuhCXJjSkqg+kTJADR+dlvITOoDy5r
         micssgK6hitCFVvG6sy7q/QW0Tpjn0H8u1JHz3Escs/uvogt0G5ZVxs/NSMv91yKz1fU
         8PgQwHV71dMYCoJUPN1OVVrw+0QbVYXB77214eW2mv8ofyhQ+loQazrbGEVjP5yzdEI5
         JROJa7sCI7D2dcZvzKaQYxZWcEEwGJjcuXupXAsUyNf6d3DJEBBFX+4tDGIHkjvBvYQA
         U1zy0RHRvk+eHijo0xYIQODs0YQ1SEUB3QoJL2CUNf18dcE9jWEGjIYuZ/3G0XLYNG+7
         GIvA==
X-Gm-Message-State: AOAM530kJUtnXBCFfqpnMjqrDew/ootBcQRjBT0ihj+tMSu2hG3fUgd0
        9LYlcpXNLALSth/pe5vGxKhcJjbm0g1Z
X-Google-Smtp-Source: ABdhPJwcgJPrHB6bL35GoPQ71jmYjHaCFpmByZp1QXNOAmw3/TuazShNcybd1en5HEpDWNAMfz62iA==
X-Received: by 2002:a17:90a:5284:: with SMTP id w4mr25613736pjh.29.1617016153641;
        Mon, 29 Mar 2021 04:09:13 -0700 (PDT)
Received: from work ([103.77.37.146])
        by smtp.gmail.com with ESMTPSA id i10sm19000561pgo.75.2021.03.29.04.09.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 04:09:13 -0700 (PDT)
Date:   Mon, 29 Mar 2021 16:39:09 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <20210329110909.GD2763@work>
References: <20210327140702.4916-1-ducheng2@gmail.com>
 <YF89PtWrs2N5XSgb@kroah.com>
 <20210327142520.GA5271@ThinkCentre-M83>
 <YF9BthXs2ha7hnrF@kroah.com>
 <20210327155110.GI1719932@casper.infradead.org>
 <YGAokfl9xvl3CnQR@kroah.com>
 <20210328100417.GA14132@casper.infradead.org>
 <20210329105556.GA334561@ThinkCentre-M83>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329105556.GA334561@ThinkCentre-M83>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:55:56PM +0800, Du Cheng wrote:
> On Sun, Mar 28, 2021 at 11:04:17AM +0100, Matthew Wilcox wrote:
> > On Sun, Mar 28, 2021 at 08:56:17AM +0200, Greg Kroah-Hartman wrote:
> > > On Sat, Mar 27, 2021 at 03:51:10PM +0000, Matthew Wilcox wrote:
> > > > On Sat, Mar 27, 2021 at 03:31:18PM +0100, Greg Kroah-Hartman wrote:
> > > > > On Sat, Mar 27, 2021 at 10:25:20PM +0800, Du Cheng wrote:
> > > > > > On Sat, Mar 27, 2021 at 03:12:14PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > Adding the xarray maintainer...
> > > > > > > 
> > > > > > > On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> > > > > > > > add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> > > > > > > > due to internal use of per_cpu variables, which requires preemption
> > > > > > > > disabling/enabling.
> > > > > > > > 
> > > > > > > > reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> > > > > > > > 
> > > > > > > > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > > > > > > > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > > > > > > > ---
> > > > > > > > changelog
> > > > > > > > v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> > > > > > > > v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> > > > > > > > 
> > > > > > > >  net/qrtr/qrtr.c | 6 ++++++
> > > > > > > >  1 file changed, 6 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > > > > > > index edb6ac17ceca..6361f169490e 100644
> > > > > > > > --- a/net/qrtr/qrtr.c
> > > > > > > > +++ b/net/qrtr/qrtr.c
> > > > > > > > @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > > > > > > >  	mutex_lock(&qrtr_port_lock);
> > > > > > > >  	if (!*port) {
> > > > > > > >  		min_port = QRTR_MIN_EPH_SOCKET;
> > > > > > > > +		idr_preload(GFP_ATOMIC);
> > > > > > > >  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > > > > > > > +		idr_preload_end();
> > > > > > > 

[...]

> > > Ok, it looks like this code is just abandonded, should we remove it
> > > entirely as no one wants to maintain it?
> > 
> > Fine by me.  I don't use it.  Better to get rid of abandonware than keep
> > a potential source of security holes.
> 
> Hi Manivannan,
> 
> For your information.
> 

Thanks for letting me know. I'll look into it once back to work.

Thanks,
Mani

> Regards,
> Du Cheng
