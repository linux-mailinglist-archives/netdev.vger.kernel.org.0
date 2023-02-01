Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF4F686E90
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBATBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBATBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:01:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7581846B7;
        Wed,  1 Feb 2023 11:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 255E6B8222B;
        Wed,  1 Feb 2023 19:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A05C433D2;
        Wed,  1 Feb 2023 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675278109;
        bh=F2sH/VRSSVMFPHDqC+vQxeaMcgW83fwG9MKKFsTlIT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bKhO0XjjUTPoCvORPztCkf8V7O1DVF4vbeTrZeheHuYjl20dAlEsOHf3wDwk+cuki
         y/52S1Ro36/gNSV5QRoN75nBA9VFOTs2Y/hVK5K/CTPDsaBZK8u1nWXHIlkUbgrhd1
         UsVh5iee0FUrJsO+TyibK2fVpfid0wUNv5CxVvNwA3rto+RRRH3EwTHYFPqURgaHty
         0HYOCuhnvVU7ILPbcZ6QjhXZ++LvGS6FRYara0N1R957eAJwvbk31aUEHoiK1wYWVR
         KpUEwRayfdluzJom30yMYaB3RWwXrd2IG4J/GPp5E6QyXB/NsMAcvH/7+P0Lo0iQYC
         cIePK/3UZKbaw==
Date:   Wed, 1 Feb 2023 11:01:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <20230201110148.0ddd3a0b@kernel.org>
In-Reply-To: <Y9or1SWlasbNIJpp@nanopsycho>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
        <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
        <Y9k7Ap4Irby7vnWg@nanopsycho>
        <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
        <Y9or1SWlasbNIJpp@nanopsycho>
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

On Wed, 1 Feb 2023 10:07:33 +0100 Jiri Pirko wrote:
> >This is due to the recommended/required devlink lock/unlock during 
> >driver initialization/removal.
> >
> >I think it is better to keep the lock/unlock inside the specific driver 
> >devlink code, and the functions naming reflects a time window when 
> >devlink related/dependent processing is being done.
> >
> >I'm not against changing this, maybe adding the lock/unlock suffix would 
> >be preferable?:
> >
> >int efx_probe_devlink_and_lock(struct efx_nic *efx);
> >void efx_probe_devlink_unlock(struct efx_nic *efx);
> >void efx_fini_devlink_lock(struct efx_nic *efx);
> >void efx_fini_devlink_and_unlock(struct efx_nic *efx);  
> 
> Sounds better. Thanks!

FWIW I'd just take the devl lock in the main driver code.
devlink should be viewed as a layer between bus and driver rather 
than as another subsystem the driver registers with. Otherwise reloads
and port creation get awkward.

But the above sounds okay, too.
