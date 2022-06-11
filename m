Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92413547223
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349244AbiFKFJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFKFI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E97744A23
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C59B837C3
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F518C34116;
        Sat, 11 Jun 2022 05:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924136;
        bh=1KMGkqCCXrvhbAC3nNKbmI8rpRsawQAvM216WwW8Zvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b/O77bzzvvjG+k+xpz3I+F2xKj7OO7WydtsYRiKpbEvfm0WUVXOqKQVak+xh5m6iF
         TfP5nVDwZacApsX8fvPELeq/ur2iBhLY9TLr72fBXmL8Gn/UtRSQph8Ch4pVtDxeoR
         /saMXOtId9BOA4RLj+krbTSkzZBj1FyN+1rqzAFpv54ZcJSQJz/K2v/WfmhzpHx1EI
         g8hNVsh6A0yElhOjd9gO+H7C3ZFjYtdm1SpdcvjaioMA/NdExO2wb9krUOATy6G1q3
         K8YLmmjnp3C+7Om2lDEwv7caSZc3OFgH8ShecDHW8ngOMBSLN/Nr7/X206bHhOuOb6
         6rYW0SOUunFkQ==
Date:   Fri, 10 Jun 2022 22:08:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net 1/4] i40e: Fix adding ADQ filter to TC0
Message-ID: <20220610220854.52e5ca44@kernel.org>
In-Reply-To: <20220609162620.2619258-2-anthony.l.nguyen@intel.com>
References: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
        <20220609162620.2619258-2-anthony.l.nguyen@intel.com>
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

On Thu,  9 Jun 2022 09:26:17 -0700 Tony Nguyen wrote:
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -8542,6 +8542,11 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (!tc) {
> +		dev_err(&pf->pdev->dev, "Unable to add filter because of invalid destination");
> +		return -EINVAL;
> +	}

extacks please ?
