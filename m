Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5666E12F6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDMQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDMQ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DDD59F9;
        Thu, 13 Apr 2023 09:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BC864035;
        Thu, 13 Apr 2023 16:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F3DC433D2;
        Thu, 13 Apr 2023 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405173;
        bh=bSkSu7wJY6E12OzsXzraNJfB/SMGar8eC+xZrs3OlPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KqbhC+LEKt2Ua+orMMdfXcL18ruziKNhKLS3lM8nbujW159cmI7wEgKp2Ca04iFDX
         1ZVKuI616uAVTOPTl1lgZxNvbuZ8l9x07alJP4D/tPdb9glEFip1eV/MzNiLNHBVJa
         IkFJeukK81mc4BdKwm0BvE550kHSFAcpbUgGHJlJNsdN6LdbbTxxIdq6yp3FAE4Ws3
         Mb04+184eVcJU3PWtr+nqlDhBvVmwoKLSDLAn1HHAcelheRJGjzraSCO+xFbXDMVzz
         FLQKbMn6KToVDBDUDEkiXkGJUl3MxZMiqTuJmY8U3AHkUlpHmpbc2jvODu8lsiFkG3
         MkKqkkoRSSYag==
Date:   Thu, 13 Apr 2023 19:59:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230413165929.GU17993@unreal>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
 <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
 <20230413130428.GO17993@unreal>
 <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230413163059.GS17993@unreal>
 <20230413094003.3fa4cd8c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413094003.3fa4cd8c@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 09:40:03AM -0700, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 19:30:59 +0300 Leon Romanovsky wrote:
> > > So the page pool is optimized for the XDP, and that sentence is applicable to drivers
> > > that have set up page pool for XDP optimization.  
> > 
> > "but it can fallback on the regular page allocator APIs."
> 
> The XDP thing is historic AFAIU, page_pool has been expanded to cover
> all uses cases, and is "just better" (tm) than using page allocator
> directly. Maybe we should update the doc.

The last sentence is always true :)
