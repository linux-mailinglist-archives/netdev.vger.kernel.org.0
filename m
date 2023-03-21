Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E36C2952
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCUEwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCUEwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:52:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B72D301A2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B384BB81232
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2441DC433D2;
        Tue, 21 Mar 2023 04:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679374350;
        bh=e9kvhy5Nm9OaywCOY3ppHGzj90KMHXOaaniqtP/tbS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BUi+E8c0oh3ri+0AbWYWAt7l20KBRzRnikGFICVyPdv+48T46hvLCUaQhdtwvTnGm
         KZo8c1+aATsPg9JOjbDmsP9Keq5JCcsoRirQPpK4g6dCvFJIC8e7HM62pjJGflycFp
         YCFu8nQ7WxQOoSYfi+k+db9Q6OktNf48BgzNNLUA4pC1FWSxoSSqLIls9dmF9tMjOV
         vMZtxcZPn6Q+XZMY4bpGKNk67aCYIRrCz/eHH92vIXXJ+hIRZQ5/QhdgNVG0mZ7K+h
         CdKnXfndImhOzj90BTkx80D/k300qov78Nh1YX2U5fZ7hhw6B3yIirvKQe8XMepQsO
         mFDiul4Kn2sVg==
Date:   Mon, 20 Mar 2023 21:52:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: Catch invalid index in XPS mapping
Message-ID: <20230320215229.53b7dfa7@kernel.org>
In-Reply-To: <20230317181941.86151-1-nnac123@linux.ibm.com>
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
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

On Fri, 17 Mar 2023 13:19:40 -0500 Nick Child wrote:
> +	if (index >= dev->num_tx_queues)
> +		return -EINVAL;

WARN_ON_ONCE()? On a quick grep virtio does not check return value 
for example. Others may assume this never fails and not print any
warning, and users will have "fun time" figuring out why their machine
fell of the network / where is the probe error coming from..

Also seems like net-next material? Why do we consider this a fix?
It's defensive / debug check, ain't no bug to assume callers are sane..
