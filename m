Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523BC51C500
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379032AbiEEQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEEQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252325BD10;
        Thu,  5 May 2022 09:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5CDB82DEE;
        Thu,  5 May 2022 16:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2F0C385A8;
        Thu,  5 May 2022 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651767468;
        bh=cftKQTOky6kP7tiOK2aeqmNnAiIpRYZNpA5v8oIziIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GglEoXZVEtbj4wnF89crfhormUiWPjSP5PItlBXQyYU+al+qq2ad+oLesXbvbis9S
         lQXNskSnv06uS/o1Yg9UsEygsfTnjTUHlQTfoMSWjiIRLkU7+TVIXkrI7u0yfMZkE9
         mxBCsIKU6jnwTRIfncE5zd2zb97JVcg4J6AO1zNMYsvKbBBz8t1+DsnZHR8ms+amoE
         nFEY2+uxMrO1gb+CTBj4rvbhO+UjgOF0ErBLJSw4vZNfmtb58w179W2S+ZQbPUwRic
         AJjjdS+AAL/tdhLg3gFFD14RXQWwKeYVGGxBvxJ9xHybKlm1bGt7E0QXhnaUz2fI7G
         Mu4KNxfbiMNhw==
Date:   Thu, 5 May 2022 09:17:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Jacky Chou <jackychou@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: ax88179_178a: Bind only to vendor-specific
 interface
Message-ID: <20220505091747.71f3cb3f@kernel.org>
In-Reply-To: <1e04603d-5fb2-9c39-4c68-7bcb7428f667@marcan.st>
References: <20220502110644.167179-1-marcan@marcan.st>
        <20220504193047.1e4b97b7@kernel.org>
        <1e04603d-5fb2-9c39-4c68-7bcb7428f667@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 21:05:29 +0900 Hector Martin wrote:
> On 05/05/2022 11.30, Jakub Kicinski wrote:
> > On Mon,  2 May 2022 20:06:44 +0900 Hector Martin wrote:  
> >> The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
> >> chipset, but exposes CDC Ethernet configurations as well as the
> >> vendor specific one.   
> > 
> > And we have reasons to believe all dongle vendors may have a similar
> > problem?  
> 
> Given this is a vendor-specific driver it seems correct to have it only
> bind to vendor-specific interfaces. That shouldn't break anything as
> long as nobody is implementing this interface with the wrong protocol
> IDs (which seems like quite a weird thing to do and fairly unlikely).
> 
> FWIW, the one I have has the generic VID/PID, not a custom vendor one.
> If you prefer I can change just that one or both of the generic ones.

I have no strong preference, maybe folks more familiar with USB in
general do and will chime in. Seems like a USB question more than
a networking one.

I know we have sort of the opposite problem with Realtek devices where
they bind to the generic driver instead of the vendor one resulting in
loss of functionality and higher power draw.

But that's not 1:1 the problem you're solving. Let's just make sure 
the commit message is more explicit about which IDs are required
to fix your system and which are just changed for a good measure,
in case of regressions.
