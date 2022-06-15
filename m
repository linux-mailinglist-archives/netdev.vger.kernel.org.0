Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2971F54D57C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 01:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiFOXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 19:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiFOXrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 19:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737F1140B6;
        Wed, 15 Jun 2022 16:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 183E1B821FE;
        Wed, 15 Jun 2022 23:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2FCC3411A;
        Wed, 15 Jun 2022 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655336861;
        bh=FVoLheuo4GD1JuziOuirep+G8XFp/ot1nGPSR/PsIZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DZ/JDr69QJm5h+uEt/8eivoN0LIpW8yXabQS4jEhbmUot+x6BVecSlXbIM/tqjLZz
         SYMyWxE/vi9RE24hQisw/P2NeHeet4OcgpYLLY4h67HEoA4JqCxmm1rTEKr2PbiV0x
         +sl3nn2A434T1nRfkEgnNYrNd35ooi/ho030f8fMo2qu+IUp6RBNyv9wMT2bRBblsq
         otdOspreTB2WlsbTIPhQSMsVJHJNc88JOfwHWntK5M+BCrl9DPn+9pXeTXhgFPG6hz
         LCgNcfoexcuDm4gTz6hEF3xJLT4ACsEg5nMQWikoGc9XZnb7gShwxSm42Fksa+o18b
         /5t5407/YkTTQ==
Date:   Wed, 15 Jun 2022 16:47:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <20220615164740.5e1f8915@kernel.org>
In-Reply-To: <20220614174749.901044-2-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
        <20220614174749.901044-2-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 19:47:40 +0200 Maciej Fijalkowski wrote:
> +	if (if_running)
> +		ice_stop(netdev);
> +	if (ice_aq_set_mac_loopback(&pf->hw, ena, NULL))
> +		dev_err(ice_pf_to_dev(pf), "Failed to toggle loopback state\n");
> +	if (if_running)
> +		ice_open(netdev);

Loopback or not, I don't think we should be accepting the shutdown ->
set config -> pray approach in modern drivers. ice_open() seems to be
allocating all the Rx memory, and can fail.
