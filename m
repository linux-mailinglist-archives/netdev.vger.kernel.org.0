Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADC692DD4
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBKDWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBKDWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:22:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DCBDFC
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1486CE29A2
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE27C433EF;
        Sat, 11 Feb 2023 03:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676085659;
        bh=7jVs7Tz/4ecjvj6H4SeqnLEwHHJGQdIi3lJzgRcYaIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gFNSGKYxxeQD30K706H0NPsLlBwC48s6RSk78RUT5Sfs4pXH4YB3MGISFmqVIkVEP
         RuQsRLUxSI+oyPI6sJuOepZPHCR/BlXq5Td+sHY8qKhaDLrpCrmMCYLTnAeKnAOqN1
         NpTQJm/bdKKDDPNcJrP2ZxtV1qmBsctS5gXnArmetVtX08NIaHhYD/fy4ekBBeo7b/
         QtJCcrYS4AgembfTar8YEgYKngSOVh4aYGV3otVRDeuBJRBtnt5QWxk5jyBnoPh+NX
         nObYCwb81wpJBy8E+fiy3/dojGdvCvJvyXDPS1AKoGVFhkcveXwxdgyufLSIs/x5BT
         SKDCZxoMUeAmA==
Date:   Fri, 10 Feb 2023 19:20:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        razor@blackwall.org, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/4] bridge: mcast: Move validation to a policy
Message-ID: <20230210192057.4927b002@kernel.org>
In-Reply-To: <20230209071852.613102-4-idosch@nvidia.com>
References: <20230209071852.613102-1-idosch@nvidia.com>
        <20230209071852.613102-4-idosch@nvidia.com>
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

On Thu,  9 Feb 2023 09:18:51 +0200 Ido Schimmel wrote:
> +	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
> +		return -EINVAL;

Well, you're just moving it, but NL_SET_ERR_MSG_ATTR() would be better.
We shouldn't be adding _MOD() in the core implementation of the family.
