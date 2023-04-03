Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3A6D455A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDCNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjDCNKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0AC22EA8;
        Mon,  3 Apr 2023 06:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 307D961AC4;
        Mon,  3 Apr 2023 13:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31201C433D2;
        Mon,  3 Apr 2023 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680527444;
        bh=3b2ENjjWzb2QJ0MXawu7kgVsFRlkLRrqtQBzOOQHUks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gggQY+4wprQzVkw7hhfNN6RAyK77n5ZvqKJofkbyHOYZaLLqeTkc0bQCsBuc9ZgSA
         zgIYPSgcpjcOkS9WS0Ak0wUAiAQcAj+Hsy8m+IObyM1wAEz6M393ZCGBGm9APRkuFX
         /W6+uephIRORbWgf6P5tOaJjLH0TRYdPN4NkK7v5obnSzqI3u9KPlVcDAVT+KEcmCH
         lJ2SS93PTAKrcjny40SKb38xMi5AlpcL5HUH92dAdeWsvAPNgj7h75LjYbgaJ0U4BY
         QzsswF52xa4+1j6+xh90mbfm5b1nUrq9XKJDThvA/lO2CKBUTVG70wI+eeuYWyEzfx
         XEP+u5VhjM1mQ==
Date:   Mon, 3 Apr 2023 15:10:40 +0200
From:   Simon Horman <horms@kernel.org>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net: qrtr: correct types of trace event parameters
Message-ID: <ZCrQUANiiJrYuc3t@kernel.org>
References: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
 <20230403051436.GA4627@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403051436.GA4627@thinkpad>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:44:56AM +0530, Manivannan Sadhasivam wrote:
> On Sun, Apr 02, 2023 at 01:15:33PM +0200, Simon Horman wrote:
> > The arguments passed to the trace events are of type unsigned int,
> > however the signature of the events used __le32 parameters.
> > 
> > I may be missing the point here, but sparse flagged this and it
> > does seem incorrect to me.
> > 
> >   net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
> >   ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
> >   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
> >   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
> >   ... (a lot more similar warnings)
> >   net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
> >   net/qrtr/ns.c:115:47:    got unsigned int service
> >   net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
> >   ... (a lot more similar warnings)
> > 
> 
> You are right. The actual arguments (service, instance, node, port) transferred/
> received over QRTR are in le32 as per the protocol. But in the NS driver, the
> arguments passed to the trace events are in the native endian (i.e) before
> getting typecased to le32 for transmission.
> 
> And my intention was to trace the arguments in native endian format only. So
> this patch indeed fixes the issue.
> 
> > Signed-off-by: Simon Horman <horms@kernel.org>
> 
> Please add the fixes tag once you remove RFC,
> 
> Fixes: dfddb54043f0 ("net: qrtr: Add tracepoint support")
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Hi Manivannan,

thanks for your review.
I'll add the tags and drop the RFC designation.
