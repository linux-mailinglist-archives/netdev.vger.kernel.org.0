Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C24AE5DB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbiBIAVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBIAVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8890DC061576;
        Tue,  8 Feb 2022 16:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233316181A;
        Wed,  9 Feb 2022 00:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43561C004E1;
        Wed,  9 Feb 2022 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644366109;
        bh=vxqRvGYYVd1oVMFwBKGEjIrETwUfpQEIcQwo8Bn3Yyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VNk+zY9TooI97vm1g6CSEOyMtdeur7X1bGukDDzAKVET9usjeCchHmZXaLdlyu7un
         +UAyNRfdpROhVPeoZ3Lm2vFUayXL4RFDOrs8J4c8090tK0KO8/6ka/lDwOnKfMho0N
         qnOoNQM11XV/a8+0I2akxWPDLInY3JX+TVtnMIjD8ciEjx3d7Qr25+zOn5MVliC1T8
         mgSJbnFry3Wtu422jDZpVG3VyLEpmZHWyvGJU7/aDf/SZRHBy94n6A8aHQ5jf3Ht+i
         FdUJfH2ZXS13PgsmWcgCt+kAp3hJJldQy5tFlJtJ58Qd9F0Svy/x9mTlwZYxI5eQO6
         mWX4KAcuRAOHg==
Date:   Tue, 8 Feb 2022 16:21:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] can: gw: use call_rcu() instead of costly
 synchronize_rcu()
Message-ID: <20220208162148.285b5432@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207190706.1499190-1-eric.dumazet@gmail.com>
References: <20220207190706.1499190-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Feb 2022 11:07:06 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit fb8696ab14ad ("can: gw: synchronize rcu operations
> before removing gw job entry") added three synchronize_rcu() calls
> to make sure one rcu grace period was observed before freeing
> a "struct cgw_job" (which are tiny objects).
> 
> This should be converted to call_rcu() to avoid adding delays
> in device / network dismantles.
> 
> Use the rcu_head that was already in struct cgw_job,
> not yet used.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>

Adding Marc and linux-can to CC.
