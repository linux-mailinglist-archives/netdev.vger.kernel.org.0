Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23BC6C10D8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjCTLds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCTLdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:33:47 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6510A9E;
        Mon, 20 Mar 2023 04:33:42 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32KBXHVs290814;
        Mon, 20 Mar 2023 12:33:18 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32KBXHVs290814
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1679311998;
        bh=WDBibh0YJk9V2rl30DaTNzmEwy/kTkf6Jqnw+Jv0vCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxU0ZjtxV29BTvZ4EaJ6UwdLMsISR+m3DjCFANETqElAHpwz7Y4gob+saJaUVQdZp
         aCHP5hhn530PCShBI9og+FP5PRoFCxhB8IB/ptvdQcaQISaLsZDko5+FCsQtjaZdJo
         c3JkigHJiSTH5EjjkCbD98pooRTtJiaDj9bnTTVs=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32KBXHtp290813;
        Mon, 20 Mar 2023 12:33:17 +0100
Date:   Mon, 20 Mar 2023 12:33:17 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
Message-ID: <20230320113317.GA290683@electric-eye.fr.zoreil.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
 <20230319224642.GA239003@electric-eye.fr.zoreil.com>
 <PH7PR21MB31162F5F9E5C8C146760AF10CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB31162F5F9E5C8C146760AF10CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haiyang Zhang <haiyangz@microsoft.com> :
> > From: Francois Romieu <romieu@fr.zoreil.com>
[...]
> > I do not see where the driver could depend on the MTU. Even if it fails,
> > a single call to mana_change_mtu should thus never wreck the old working
> > state/configuration.
> > 
> > Stated differently, the detach/attach implementation is simple but
> > it makes the driver less reliable than it could be.
> > 
> > No ?
> 
> No, it doesn't make the driver less reliable. To safely remove and reallocate 
> DMA buffers with different size, we have to stop the traffic. So, mana_detach() 
> is called. We also call mana_detach() in mana_close(). So the process in 
> mana_change_mtu() is no more risky than ifdown/ifup of the NIC. 
> 
> In some rare cases, if the system memory is running really low, the bigger 
> buffer allocation may fail, so we re-try with the previous MTU. I don't expect 
> it to fail again. But we still check & log the error code for completeness and 
> debugging.

In a ideal world, I would expect change_mtu() to allocate the new resources,
bail out if some allocation fails, stop the traffic, swap the old and new
resources, then restart the traffic and release the old resources.
This way the device is never left in a failed state.

-- 
Ueimor
