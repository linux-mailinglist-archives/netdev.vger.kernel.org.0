Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D9674BED
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjATFPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjATFOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:14:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9512B095
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E9DBB821A7
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DEBC433D2;
        Thu, 19 Jan 2023 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674148568;
        bh=4ShIbkxhTwdv/JH9XFWMGXbW9qa8XWgki60SOvlYE/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQKnmkzbQLOoYVTChFgVmxZ4teEwqJA6MiYWT7Vlr+QbJdLkWJvUHTjluazbFIWSR
         zzlaBXXXzy9AkEJ+Bjchq2G0XmtSD68+g/cSuIkwOY3fk5WuiBMViLxAUbsmXIOEWT
         VlwHS9utUNUVyJxmcOv15sJEzg/lvnh0WBTSklw8/STvT0rGt2/k26cfDheH8a5L59
         vSvNReCxPVxvc3bBZ5gteKwGaDzkO+8jqJ3dPFGVKnPxHfI6bNazLVf/U7vrNY4szQ
         rak3kFNC16uA+hufSeVJFSaovs2sR8+HTOAQiJZ6oahLh9oQ8ppKFzj6Xu7AGUY8Ba
         /QJFybIwkPsDg==
Date:   Thu, 19 Jan 2023 09:16:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alejandro.lucero-palau@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm@gmail.com>, <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Message-ID: <20230119091606.2ee5a807@kernel.org>
In-Reply-To: <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
        <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
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

On Thu, 19 Jan 2023 11:31:34 +0000 alejandro.lucero-palau@amd.com wrote:
> +		devlink_unregister(efx->devlink);
> +		devlink_free(efx->devlink);

Please use the devl_ APIs and take the devl_lock() explicitly.
Once you start adding sub-objects the API with implicit locking
gets racy.
