Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9FB4CFDD8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbiCGMJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242197AbiCGMJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:09:14 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BDD22B17
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:08:10 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 25D982223A;
        Mon,  7 Mar 2022 13:08:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1646654881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Lpa4IbhT26JKa7Ojq6Q6i2UcprQqQrxCmF8mlhCks4=;
        b=NxRqfSwcMmluHIvsSKlCktnhfOMsB8jkqMhdLBtKz5DTcqxieh8Si+T5i1iTvz9pJ7k9JE
        j51/C7KqstPoL6kN8m8P9e17hL5sCTvhTJrirqOYuZwHpIJGR5Nqz3ETbty36N9qz1mxAn
        +Uz3PQzqK/XbWOHttydNvznBy2ubSF0=
From:   Michael Walle <michael@walle.cc>
To:     gerhard@engleder-embedded.com
Cc:     davem@davemloft.net, kuba@kernel.org, mlichvar@redhat.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with additional free running time
Date:   Mon,  7 Mar 2022 13:07:51 +0100
Message-Id: <20220307120751.3484125-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with ETF/TAPRIO hardware support
> is not possible anymore.
> 
> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized while
> vclocks are in use.
> 
> The physical clock could be used to synchronize the time domain of the
> TSN network and trigger ETF/TAPRIO. In parallel vclocks can be used to
> synchronize other time domains.
> 
> One year ago I thought for two time domains within a TSN network also
> two physical clocks are required. This would lead to new kernel
> interfaces for asking for the second clock, ... . But actually for a
> time triggered system like TSN there can be only one time domain that
> controls the system itself. All other time domains belong to other
> layers, but not to the time triggered system itself. So other time
> domains can be based on a free running counter if similar mechanisms
> to 2 step synchronisation are used.
> 
> Synchronisation was tested with two time domains between two directly
> connected hosts. Each host run two ptp4l instances, the first used the
> physical clock and the second used the virtual clock. I used my FPGA
> based network controller as network device. ptp4l was used in
> combination with the virtual clock support patch set from Miroslav
> Lichvar.
> 
> Please give me some feedback. For me it seems like a straight forward
> extension for ptp vclocks, but I'm new to this topic.

From what I understand, you have a second PHC which is just a second
PHC you cannot control; i.e. it is equivalent to a PHC in free running
mode. This PHC will take the timestamps for the PTP frames. You can
create multiple vclocks and you can use ptp4l to synchronize these.

The first (controlable) PHC is used to do the Qbv scheduling, thus
needs a synchronized time.

How do you synchronize the vclock with this PHC? And how precise
is it? I know that some cards can do cross timestamping in hardware
to aid the synchronization (but I think that is not supported right
now in linux).

Richard Cochran wrote:
> You are adding eight bytes per frame for what is arguably an extreme
> niche case.

I don't think it is a niche case, btw. I was always wondering why
NXP introduced the vclock thingy. And apparently it is for
802.1AS-rev, but one use case for that is 802.1Qbv and there you'll
need a (synchronized) hardware clock to control the gates. So while
we can have multiple time domain support with the vclock, we cannot
use Qbv with them. That was something I have always wondered about.
Or.. maybe I'm missing something here.

-michael
