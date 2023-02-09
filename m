Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A55E69120C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBIUV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIUV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:21:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C1B1B556;
        Thu,  9 Feb 2023 12:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 332F761B9A;
        Thu,  9 Feb 2023 20:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B7EC433EF;
        Thu,  9 Feb 2023 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675974114;
        bh=fmneXG5cZ3wbS4vx7jlvnH6iEA2018GLSjQTQXpbqLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhsejxndhowRtYKqJu55G126YmnnFWz55FXBd52d0BQEevggy6/UWVHxXejlYMyg9
         YQw1itwHuQElyOpwW2bCAaSTFK9jiLNdJLfEz5o2E76sWU7DgHbqGFZQdo2ERc0lsE
         mKVaPmWPW914HKBn8+li5lg3VnfQG72iPEnWpyk8Hafy5Kv+maXz5MJ4B6njj9rWlE
         XgyxkagWtans8mqx4OYwt8xIpXpxXM2bH60kWIu6NwCa2W22XYBRoXu6OWaX0ecy+7
         MCrMJ2dKXvjROLJhHWZ1Kj4DqsHXFKK2dHpJtBPjL9FBNvFAQSw31eixbHK/L+jtdR
         38eeb1MtJvahw==
Date:   Thu, 9 Feb 2023 12:21:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Message-ID: <20230209122153.2b02faf4@kernel.org>
In-Reply-To: <PH7PR21MB311602D700C0FD965AF792F6CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
        <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
        <BYAPR21MB1688422E9CD742B482248E8BD7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
        <PH7PR21MB311602D700C0FD965AF792F6CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 19:10:16 +0000 Haiyang Zhang wrote:
> But I'm just worried about if a VM sending at high speed, and host side is,
> for some reason, not able to send them correctly, the log file will become 
> really big and difficult to download and read. With rate limit, we still see 
> dozens of messages every 5 seconds or so, and it tells you how many 
> messages are skipped. And, if the rate is lower, it won't skip anything. 
> Isn't this info sufficient to debug?
> 
> By the way, guests cannot trust the host -- probably we shouldn't allow the
> host to have a way to jam guest's log file?

+1 FWIW, the general guidance is to always rate limit prints
which may be triggered from the datapath (which I'm guessing
this is based on the names of things)
