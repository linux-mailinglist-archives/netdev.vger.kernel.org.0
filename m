Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515336BDB31
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCPV7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCPV7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:59:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E11C69CEB;
        Thu, 16 Mar 2023 14:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB08661A8D;
        Thu, 16 Mar 2023 21:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1910C433EF;
        Thu, 16 Mar 2023 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679003983;
        bh=6hsOLOVQ6N40rA5upMia75jZenTJAHAGF9t+JB46wsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VYRxLA6atcVtU4KdsZd0/f2pvYHzMXU+GoUv9F9/3OE40+qzJV5Kv37P97p21SYZU
         OClTEzYdSyVRsAUL51MgN+Jff1HSbNwWyA15aYMwDiBmOx4ct7Img29g/wM9w+iwZn
         wPlJ9zgZkr6SSVmO8kAsgKcAQloRY61iQDkmnFYJwWbe25IJm5gvOsOZWi6yPCH+Zq
         /LqXt+PSNKwD+u6WrduAqyx88LDV/+gy1CVicU7s3WHacq4lR5MT5EBuWqv3VYP2GF
         Hc09lMY/DcyxWs8fN9ots+ihuU3/zUt2ChX/6GNsmFB7Ca44QI/FVvIKe6PqCbttBX
         XTQfhUr4OYUUw==
Date:   Thu, 16 Mar 2023 14:59:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, tariqt@nvidia.com, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: xdp: don't call notifiers during driver init
Message-ID: <20230316145942.6e67e405@kernel.org>
In-Reply-To: <20230316145418.3af738c3@kernel.org>
References: <20230316002903.492497-1-kuba@kernel.org>
        <ebe10b79-34c2-4e85-2cf7-b7491266748e@gmail.com>
        <ZBL3nVZ4LVWUPRva@localhost.localdomain>
        <20230316145418.3af738c3@kernel.org>
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

On Thu, 16 Mar 2023 14:54:18 -0700 Jakub Kicinski wrote:
> > does it make sense to run call_netdevice_notifiers() in xdp_set_features_flag()
> > just if dev->reg_state is NETREG_REGISTERED?  
> 
> I was thinking - we'll adjust it if someone complains, but indeed
> the detection is somewhat weak, a call on a dead device but under
> rtnl_lock won't warn. Let me just copy what the queue helpers do,
> exactly, then.

It's just a notifier, I think I'll go with == REGISTERED.
Let me send v2.
