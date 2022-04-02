Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4693A4EFF34
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 08:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbiDBG5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 02:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiDBG5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 02:57:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 316DA764B
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 23:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648882545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZ31gR6OuppI3OSuopIkD35xeUkys2Q81lOBmdyZewY=;
        b=O6afqA7Bk+bL7xoiTZAVSNXr04XCDmNMPdeFAGrbTd1jBy+uyRTy+JqV1KTZiZKdoaOt/3
        d6N3p1BNdwYHfwkT5losjQ4BA328sN+3KYqkCCdEvhKdiiEzsfYOsHXvw8nJO082gi8jwr
        kDo09+7MO+0Pxe6afeW7ToMZYGjV/EQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-xa1AZ-w_N4ewJCFCvH6KgA-1; Sat, 02 Apr 2022 02:55:41 -0400
X-MC-Unique: xa1AZ-w_N4ewJCFCvH6KgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACA5980A0AD;
        Sat,  2 Apr 2022 06:55:40 +0000 (UTC)
Received: from sparkplug.usersys.redhat.com (unknown [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 172F720296A9;
        Sat,  2 Apr 2022 06:55:33 +0000 (UTC)
Date:   Sat, 2 Apr 2022 08:55:33 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer: add a function to adjust timeouts to be
 upper bound
Message-ID: <YkfzZWs+Nj3hCvnE@sparkplug.usersys.redhat.com>
References: <87zglcfmcv.ffs@tglx>
 <20220330082046.3512424-1-asavkov@redhat.com>
 <20220330082046.3512424-2-asavkov@redhat.com>
 <alpine.DEB.2.21.2203301514570.4409@somnus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2203301514570.4409@somnus>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 03:40:55PM +0200, Anna-Maria Behnsen wrote:
> On Wed, 30 Mar 2022, Artem Savkov wrote:
> 
> > Current timer wheel implementation is optimized for performance and
> > energy usage but lacks in precision. This, normally, is not a problem as
> > most timers that use timer wheel are used for timeouts and thus rarely
> > expire, instead they often get canceled or modified before expiration.
> > Even when they don't, expiring a bit late is not an issue for timeout
> > timers.
> > 
> > TCP keepalive timer is a special case, it's aim is to prevent timeouts,
> > so triggering earlier rather than later is desired behavior. In a
> > reported case the user had a 3600s keepalive timer for preventing firewall
> > disconnects (on a 3650s interval). They observed keepalive timers coming
> > in up to four minutes late, causing unexpected disconnects.
> > 
> > This commit adds upper_bound_timeout() function that takes a relative
> > timeout and adjusts it based on timer wheel granularity so that supplied
> > value effectively becomes an upper bound for the timer.
> > 
> 
> I think there is a problem with this approach. Please correct me, if I'm
> wrong. The timer wheel index and level calculation depends on
> timer_base::clk. The timeout/delta which is used for this calculation is
> relative to timer_base::clk (delta = expires - base::clk). timer_base::clk
> is not updated in sync with jiffies. It is forwarded before a new timer is
> queued. It is possible, that timer_base::clk is behind jiffies after
> forwarding because of a not yet expired timer.
> 
> When calculating the level/index with a relative timeout, there is no
> guarantee that the result is the same when actual enqueueing the timer with
> expiry = jiffies + timeout .

Yes, you are correct. This especially is a problem for timeouts placed
just before LVL_START(x), which is a good chunk of cases. I don't think
it is possible to get to timer_base clock without meddling with the
hot-path.

Is it possible to determine the upper limit of error margin here? My
assumption is it shouldn't be very big, so maybe it would be enough to
account for this when adjusting timeout at the edge of a level.
I know this doesn't sound good but I am running out of ideas here.

-- 
 Artem

