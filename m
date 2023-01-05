Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60D165F3ED
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbjAESpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbjAESpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:45:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5B52030
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB72761BD2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D058EC433D2;
        Thu,  5 Jan 2023 18:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672944319;
        bh=Wvox5HO5U/l/+KdMek/+nOY1pCCL4DRB2EMvkbt+Czs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hLExPmDGQXGapRDuaDYLNVrg9nHY0c5GvhqT+rjFjEoQjTc03Fmtu1tCUZCi57JPN
         +Thw8zR0HP/UpS3OBCqNem9YCetLBfTqJAtJNbGoj0EtspEmNzjGUbaHTq1BtsHyo9
         /U/lMFNJMOMApLo5mX9hUu+wKjtOUTEiiZbqpzMZrni11zbKsYI2Ie22uCbCk1TRpM
         H9RhYB5hsiOxomw0yZ7uJ9rSa8AsBnMWwsK+UrP05UbJ9gFXuMmCARiMr8CHHyj0N0
         9cLeLD9Thqt50LEqL0Po4m5VX4uQWFF2qbLbFKMSQdY7UJn1G3ydfLCWw7Sjn7OIxP
         SWUZyq/6EzA7w==
Date:   Thu, 5 Jan 2023 10:45:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mateusz Palczewski <mateusz.palczewski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Message-ID: <20230105104517.79cd83ed@kernel.org>
In-Reply-To: <20230105120518.29776-1-mateusz.palczewski@intel.com>
References: <20230105120518.29776-1-mateusz.palczewski@intel.com>
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

On Thu,  5 Jan 2023 07:05:18 -0500 Mateusz Palczewski wrote:
>  		ret = ice_vsi_alloc_q_vectors(vsi);
> -		if (ret)
> -			goto err_rings;
> +		if (ret){
> +			ice_vsi_clear_rings(vsi);
> +			goto err_reset;
> +		}
>  
>  		ret = ice_vsi_setup_vector_base(vsi);
>  		if (ret)

Why do cases which jump to err_vectors no need any changes?
