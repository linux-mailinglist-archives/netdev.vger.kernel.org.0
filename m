Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D396D998B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbjDFOZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbjDFOZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967568684;
        Thu,  6 Apr 2023 07:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32CC062B89;
        Thu,  6 Apr 2023 14:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5763C433D2;
        Thu,  6 Apr 2023 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680791106;
        bh=dVLrRKMixxYJuJxgFVKfxaLTvhfPWlQjL3ZdegVqCYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrQ4vEbqAY8KxcnwjjJnmbT/Yk4YENoIhmdid/YAyH0cqbPKOsJU5RsEvdJBhtpFr
         YbH/Y4Ry6cRD7NFkUq/mcW6RCuy4+C9qSP4ScbpNd+HtXvYzFLWPfJFcIyJhPmXT0+
         qZCj+qXajGDAhZtUKKL3BFDD7HzuenGi+I/0ROZzQuFXZezmr6MKE5E+DfL2huyXJk
         tI43BX9eOW8OFlSnz8RqNJlOsHKpr1rb6O3M5jmqTC0oUQu0grYQYm79hd/qkHgdVT
         JB0vPjHUIzCVKnU97MvxXPevOkTIPwtFVaf4O3oq3a7RLP34yAYvhgYc+JXZ2vmPIG
         fH6ktcgA64cMQ==
Date:   Thu, 6 Apr 2023 07:25:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: Re: [RESEND PATCH net 1/1] net: stmmac: check fwnode for phy device
 before scanning for phy
Message-ID: <20230406072504.68e032e6@kernel.org>
In-Reply-To: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
References: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 10:45:41 +0800 Michael Sit Wei Hong wrote:
> Some DT devices already have phy device configured in the DT/ACPI.
> Current implementation scans for a phy unconditionally even though
> there is a phy listed in the DT/ACPI and already attached.
> 
> We should check the fwnode if there is any phy device listed in
> fwnode and decide whether to scan for a phy to attach to.

Why did you resend this?
