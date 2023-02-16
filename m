Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D541699B58
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjBPRcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjBPRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:32:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1895B4C6FD
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDA05B8292F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 17:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F414CC433EF;
        Thu, 16 Feb 2023 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676568744;
        bh=qtttyzniSz497oVHHKOp7thoOpQYFyGZ3vgSAZjkOsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mgTT2RFntVPu37eOSO1nY1Hh187E/waGvf5PV9yY9qahm2zFqbCTLVTuOofDIW65d
         dBhubjnc184ceEYMClrzvzwjYCPCu0jgsRYv6MuNLrVHruL5jRmS/EJddVrnwptdQS
         UUqHw5OhyyQ+ulFZOGNmTIpgnNOSoxLXNue/ZMOocoq4b01V+9AuUqPSSHU/XNfGX1
         Fo+FUFFBBMrD3uJSjilYcRtF8+z/PEDJu0hkSHXcHn2IaAFUIBCkuCIYIr/5b2aGb7
         vGaF0RBuWxxwg4AlRhPt/XCewnJjkg0f4lNszIS+v8I99MGxbixFZI1NMhVFJlaipA
         gomY8RrpFuRvA==
Date:   Thu, 16 Feb 2023 09:32:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: Kernel interface to configure queue-group parameters
Message-ID: <20230216093222.18f9cefe@kernel.org>
In-Reply-To: <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
        <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
        <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
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

On Thu, 16 Feb 2023 02:35:35 -0800 Nambiar, Amritha wrote:
> > The biggest issue I see is that there isn't any sort of sysfs interface
> > exposed for NAPI which is what you would essentially need to justify
> > something like this since that is what you are modifying.
> 
> Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
> Maybe, initially there would be as many napis as queues due to 1:1 
> association, but as the queues bitmap is tuned for the napi, only those 
> napis that have queue[s] associated with it would be exposed.

Forget about using sysfs, please. We've been talking about making
"queues first class citizen", mapping to pollers is part of that
problem space. And it's complex enough to be better suited for netlink.
