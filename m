Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B124B3247
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354504AbiBLBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:04:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbiBLBEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28390D82;
        Fri, 11 Feb 2022 17:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD2FB82DF8;
        Sat, 12 Feb 2022 01:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBEDC340E9;
        Sat, 12 Feb 2022 01:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644627856;
        bh=Rl10gJDjhOhJM1U/VkUE7/DkPFU8vExw1P0p65rIYco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e2nUeLfNpn3n5XU1ZcuySu8c9AwRk9RLMMjDgf+L4Fptl1ZU533mZtPKnPiLRxViO
         t7ftURCx2l8cvZ1W0G9UurKmcORuYqAOwzWqXmXNdaTnk+Ur/+osjd7r1OTI7T9Xdl
         gm/djS77BBh5KLxZ+xgCTrwLJXT/ZXB5jvnBMPR6NzOT2kmSosQlv6/w5jece8hp5s
         ewPW6jAO2w7TsTqW0fjZMpA3zSIMdD+mAJ6UJvCvhneF+1oJf8bm603+jsCgzA/uOb
         2DgD1lSKcdQaSpVSScnusiiIiorMkadQ6oPh12qJ17FbOl/QIuP2cAZgYTqDlSPH4u
         yYwutvfXiCyHg==
Date:   Fri, 11 Feb 2022 17:04:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to
 accept non-linear skb
Message-ID: <20220211170414.7223ff09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8c5e6e5f06d1ba93139f1b72137f8f010db15808.1644541123.git.lorenzo@kernel.org>
References: <cover.1644541123.git.lorenzo@kernel.org>
        <8c5e6e5f06d1ba93139f1b72137f8f010db15808.1644541123.git.lorenzo@kernel.org>
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

On Fri, 11 Feb 2022 02:20:31 +0100 Lorenzo Bianconi wrote:
> +	if (skb_shared(skb) || skb_head_is_locked(skb)) {

Is this sufficient to guarantee that the frags can be written?
skb_cow_data() tells a different story.
