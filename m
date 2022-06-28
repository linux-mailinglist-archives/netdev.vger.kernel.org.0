Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1259855EAD2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiF1RQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiF1RQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2362DA98
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89C16191F
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 17:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2555DC3411D;
        Tue, 28 Jun 2022 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656436586;
        bh=oTZ25kbo5ZOH1yPhL3JZEMmA6MsmSGt5s/8V9IXmgIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cTy6Y1sPWjSeoclh9uVcza0MmqsSMhgZOA7vEsfXdLMQyiKyja7VdV4OXrk1/gSpO
         AdBjK8vMSDw2YiTbgG0obyMNBx03OYPDzblpuQa7BkLQvyqemSLzthhEcbohqPqM3Q
         aAXzREVWd7CHI6dPMVINXCOZ66NQFzbfeDOB9qJ7ZM0yiMDCA5nbIKM8VMnNCVAbX2
         VWjEnlASl2mTm9scPPOdQ4wgF7Dec/Odf0yf+KXlgX6j4Z5K2FlTcnDqm6RSsLeEdh
         DOlGvdAUdkxO4EdvG6lDlN2b31hjnW7bF1kxVVBX+IN3mk8zIHYDIJR3rzkICDvAA2
         2Xw8/PWtwViVA==
Date:   Tue, 28 Jun 2022 10:16:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Yonan <james@openvpn.net>
Cc:     netdev@vger.kernel.org, therbert@google.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] rfs: added /proc/sys/net/core/rps_allow_ooo
 flag to tweak flow alg
Message-ID: <20220628101620.75c2941b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220628051754.365238-1-james@openvpn.net>
References: <20220624100536.4bbc1156@hermes.local>
        <20220628051754.365238-1-james@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 23:17:54 -0600 James Yonan wrote:
> rps_allow_ooo (0|1, default=0) -- if set to 1, allow RFS (receive flow
> steering) to move a flow to a new CPU even if the old CPU queue has
> pending packets.  Note that this can result in packets being delivered
> out-of-order.  If set to 0 (the default), the previous behavior is
> retained, where flows will not be moved as long as pending packets remain.
> 
> The motivation for this patch is that while it's good to prevent
> out-of-order packets, the current RFS logic requires that all previous
> packets for the flow have been dequeued before an RFS CPU switch is made,
> so as to preserve in-order delivery.  In some cases, on links with heavy
> VPN traffic, we have observed that this requirement is too onerous, and
> that it prevents an RFS CPU switch from occurring within a reasonable time
> frame if heavy traffic causes the old CPU queue to never fully drain.
> 
> So rps_allow_ooo allows the user to select the tradeoff between a more
> aggressive RFS steering policy that may reorder packets on a CPU switch
> event (rps_allow_ooo=1) vs. one that prioritizes in-order delivery
> (rps_allow_ooo=0).

BTW please see:

https://lore.kernel.org/all/20220628051754.365238-1-james@openvpn.net/

Y'all should work together.
