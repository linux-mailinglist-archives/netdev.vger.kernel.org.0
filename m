Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511EC4E462B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiCVSnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 14:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240990AbiCVSn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 14:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E2B1CC
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 11:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E24BF615FD
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A57CC340EC;
        Tue, 22 Mar 2022 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647974518;
        bh=AXz2b1Zx+ZCOL6bKs8JOOihmhSoL/TWcAqJ/LC5bZgQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfxU7mJ2WGihA2cykw1zBh1FR2LDxdH7osqnDVfasoCN+kuHBdk/s5B6+sLHYg5nZ
         ut69FRy9RlDl6cyIGGrrndfjga7G6VU9Pnlmgb+SPrZXf5DEaqRdnJjTWSd2yAES9F
         1j7Id+aYHkr+A08Tgmbp4AcZh3i+sU0Tnns3oLVKphsOiofDk2l46kBxvePbVrR1uV
         cKaI4ET1IIDh0i6pSmDEWweiK0w4d/SCZST2gYAHYi7nwyMfEf5ATRR68e7g9GFptM
         QCPQ4c185heDOeAaZeU63iyEitIQU4LpvUA6Agh/p3wxZ8+1X0qDDUv0sh5inWR+tw
         1QQtOcZ3dzeCg==
Date:   Tue, 22 Mar 2022 11:41:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <20220322114157.5013ef0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322080317.54887-1-socketcan@hartkopp.net>
References: <20220322080317.54887-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Mar 2022 09:03:17 +0100 Oliver Hartkopp wrote:
> skb_recv_datagram() has two parameters 'flags' and 'noblock' that are
> merged inside skb_recv_datagram() by 'flags | (noblock ? MSG_DONTWAIT : 0)'
> 
> As 'flags' may contain MSG_DONTWAIT as value most callers split the 'flags'
> into 'flags' and 'noblock' with finally obsolete bit operations like this:
> 
> skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &rc);
> 
> And this is not even done consistently with the 'flags' parameter.
> 
> This patch removes the obsolete and costly splitting into two parameters
> and only performs bit operations when really needed on the caller side.
> 
> One missing conversion thankfully reported by kernel test robot. I missed
> to enable kunit tests to build the mctp code.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Would it be a major inconvenience if I asked you to come back with this
patch after the merge window? We were hoping to keep net-next closed
for the time being. No new features should go in in the meantime so it's
unlikely the patch itself would break.
