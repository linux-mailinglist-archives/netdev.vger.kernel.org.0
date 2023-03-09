Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7606B1930
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCIC2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCIC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:28:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BE22914F;
        Wed,  8 Mar 2023 18:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE6D61A01;
        Thu,  9 Mar 2023 02:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB1AC433D2;
        Thu,  9 Mar 2023 02:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678328890;
        bh=M1W1SxnzY0ZiYPOAZkHO7c8bUBDWTwE0BuPCVEH0NbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SNgYG3iaaqDosg5u5uJXQuWenoQcc8lfHHF0zITuxO5YKMoqE+vfTgUdmlHBKMKQ9
         yMcsh3w9CbJBZxd4kyeFOQBNqRCSUrbjMRcFMuM4rOpUHxDYTOpnsthF55ktyi1T+D
         DPtlq8kokL+TWkCB0h/4fwbh0bZHoeOnot8yg/oFq2x00HYgaBgIFQ00H3QebiZPZI
         p4X2qPTLKJQWyBiDyT/lKCLwaHHp2wVuH9rRBDFxTxKORK1/7pzrDLI3FYunQhGKPT
         BWdsIzE4vBxMH8XMgER3V90zt7YnRmhhl8wZstZbgNSbwBLIFvHRjul2YBEWbiP+Zc
         GHCuAlYoGRTQQ==
Date:   Wed, 8 Mar 2023 18:28:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Rout, ChandanX" <chandanx.rout@intel.com>
Subject: Re: [PATCH net-next 2/8] i40e: change Rx buffer size for legacy-rx
 to support XDP multi-buffer
Message-ID: <20230308182808.60e4af6c@kernel.org>
In-Reply-To: <BY1PR11MB79845230285E702988F8536290B49@BY1PR11MB7984.namprd11.prod.outlook.com>
References: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
        <20230306210822.3381942-3-anthony.l.nguyen@intel.com>
        <20230307181829.5dcec646@kernel.org>
        <BY1PR11MB79845230285E702988F8536290B49@BY1PR11MB7984.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Mar 2023 12:22:13 +0000 Sarkar, Tirthendu wrote:
> > On Mon,  6 Mar 2023 13:08:16 -0800 Tony Nguyen wrote:  
> > > In the legacy-rx mode, driver can only configure up to 2k sized Rx buffers
> > > and with the current configuration of 2k sized Rx buffers there is no way
> > > to do tailroom reservation for skb_shared_info. Hence size of Rx buffers
> > > is now lowered to 1664 (2k - sizeof(skb_shared_info)). Also, driver can  
> > 
> > skb_shared_info is not fixed size, the number of fragments can
> > be changed in the future. What will happen to the driver and
> > this assumption, then?
> >   
> 
> This is for the non-default path in legacy mode. If for some reason number of 
> fragments increase in future, we may have to think of other options like using
> page pools.

Is it possible to add runtime checks so that in configurations where
the shinfo geometry does not match expectations we'd cleanly error out?
Better to be too careful than risk silent memory corruptions.. 
