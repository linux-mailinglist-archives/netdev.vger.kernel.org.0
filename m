Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DC96E1090
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjDMPEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjDMPEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5631783E2;
        Thu, 13 Apr 2023 08:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73A263BBE;
        Thu, 13 Apr 2023 15:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5A7C433EF;
        Thu, 13 Apr 2023 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681398247;
        bh=JdbgbeQTK4oXXpvwy/OkbrBX79V7CMl8I2rByssnbK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPGDH/bbVb36/Vi0t11lP6f2sRR4SOLUf7fIxJRUtI28miO5mrqAWIL/3j1+kYij5
         Znu5MBMUAZ+ABRUL93fKTMB8SrOPqtCDWAWceK9xh6JuqFmfUN0jdOLKeXXtxaZjlk
         Mji3Ymgy4JBemOYnGu9wR+RTKyZ/BPk926GVY3BLbrJozJPXSyT4kwpnvRSM1BGqMQ
         lDdzkfb6wkR/K9+ZE7ddssGuJ4sacrzsSzrfTlCIV7dOuOB08yFa6iiLh6ZIpQyFy4
         pQXosljbJNj3i7pKtYMvmQu2Iu5JzdM+4DG/oqhlS/RRYM3agdlvngB1MvkVuACpU7
         GLBtV7XMPP1Sw==
Date:   Thu, 13 Apr 2023 08:04:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH v1] ice: add CGU info to devlink info callback
Message-ID: <20230413080405.30bbe3bd@kernel.org>
In-Reply-To: <DM6PR11MB46577E14FE17ADA6D1E74E789B989@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
        <20230412203500.36fb7c36@kernel.org>
        <DM6PR11MB46577E14FE17ADA6D1E74E789B989@DM6PR11MB4657.namprd11.prod.outlook.com>
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

On Thu, 13 Apr 2023 13:43:52 +0000 Kubalewski, Arkadiusz wrote:
> >Is it flashed together with the rest of the FW components of the NIC?
> >Or the update method is different?  
> 
> Right now there is no mechanics for CGU firmware update at all, this is why I
> mention that this is for now mostly for debugging purposes.
> There are already some works ongoing to have CGU FW update possible, first with
> Intel's nvmupdate packages and tools. But, for Linux we probably also gonna
> need to support update through devlink, at least this seems right thing to do,
> as there is already possibility to update NIC firmware with devlink.

Only FW versions which are updated with a single flashing operation /
are part of a single FW image should be reported under the device
instance. If the flash is separate you need to create a separate
devlink (sub)instance or something along those lines.

Differently put - the components in the API are components of the FW
image, not components of a board.

We had a similar discussion about "line cards" before.
