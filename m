Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CDD522973
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiEKCJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiEKCJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:09:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0386CAA2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0F761B32
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE22C385D4;
        Wed, 11 May 2022 02:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652234969;
        bh=/X+uP670Dn+XC76wU9OeBj/YNwt4QUBFtMIOqOYIdKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l5pMkonjlH/0kkYogbcVPKE1c8OCgGv9UeP2+hn84Ms0n0wZdt3Kp51SbLeQfS5Nw
         98hiG2UorYcglzdUolTWLvYUJSNspLPU39xzwnoNMaFA6DRymWU5Fc1/98DIFNKQzy
         UA8r1gEZzxkP+h1yjMF7k452T03RxHXAAbGBaCIlaVV70Y2wImfA77u16DTZ0qoxmE
         bXRngsjsHsGy9VMoldHC2rTKU7LimkGxlhEX0KB9EAhn892i3EwgK5pfK9oM6hUae3
         cw8RbX1kPHMaEjv98DdX2dYROEMsnpEcl0zjejqgH8Afip60DGoho8d1TGdOgO+QOk
         deezcVquAPiBQ==
Date:   Tue, 10 May 2022 19:09:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 2/2] iavf: Add waiting for response from PF in
 set mac
Message-ID: <20220510190927.56004f10@kernel.org>
In-Reply-To: <20220509173547.562461-3-anthony.l.nguyen@intel.com>
References: <20220509173547.562461-1-anthony.l.nguyen@intel.com>
        <20220509173547.562461-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 May 2022 10:35:47 -0700 Tony Nguyen wrote:
> +static int iavf_set_mac(struct net_device *netdev, void *p)
> +{
> +	struct iavf_adapter *adapter = netdev_priv(netdev);
> +	struct sockaddr *addr = p;
> +	bool handle_mac = iavf_is_mac_set_handled(netdev, addr->sa_data);
> +	int ret;
> +
> +	if (!is_valid_ether_addr(addr->sa_data))
> +		return -EADDRNOTAVAIL;
> +
> +	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* If this is an initial set mac during VF spawn do not wait */
> +	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
> +		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
> +		return 0;
> +	}
> +
> +	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue, handle_mac, msecs_to_jiffies(2500));

Passing in a value as a condition looks a little odd, are you sure this
is what you want? Because you can rewrite this as:

	if (handled_mac)
		goto done;

	ret = wait_eve..(wq, false, msecs...);
	if (ret < 0)
		...
	if (!ret)
		...

done:
	if (!ether_addr_equal(netdev->dev_addr, addr->sa_data))
		return -EACCESS;
	return 0;
