Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA764D17B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 21:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiLNUuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 15:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLNUuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 15:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE31C132;
        Wed, 14 Dec 2022 12:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF9FB81975;
        Wed, 14 Dec 2022 20:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D48BC433D2;
        Wed, 14 Dec 2022 20:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671051017;
        bh=DLBa9y167FwzHAQQvHNMlQc3hIkNZJrjzeznR28yPkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gbGMPzTv1j2uf9ceDwUTTbW3sVOSvhElSNYPhP/PG0Tktr4Izt39lmVsCKCsiZVTC
         iYMtNLLawQHUapvmFxTx2q1mnTIwBhXGcz62YzPJ6DQgKjY7RIQ6bNrkQh6WYp5rGO
         21Ohcclyi5qvDd7oNNLjdb8+0kZvNlC5alsaE6N9GY3O4lZd8SjUB2RsO6avCGxnSH
         AKNHgyUN0MtApTGEKsIWT1Yqunbq+NSFaJ5kpUNqHTHTirWFksxV+VSLqd/VIaKlsx
         TfzAdFjRu7XuysyNbB+B4aqBQ3+Cl/+7OyHyEOI6/fgVDRVAlb1fLvaCv2cZPlSZGp
         NK4Gsgu8fe/uw==
Date:   Wed, 14 Dec 2022 12:50:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Lixue Liang <lianglixuehao@126.com>, anthony.l.nguyen@intel.com,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <20221214125016.5a23c32a@kernel.org>
In-Reply-To: <Y5obql8TVeYEsRw8@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
        <Y5l5pUKBW9DvHJAW@unreal>
        <20221214085106.42a88df1@kernel.org>
        <Y5obql8TVeYEsRw8@unreal>
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

On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> > On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:  
> > > NAK to any module driver parameter. If it is applicable to all drivers,
> > > please find a way to configure it to more user-friendly. If it is not,
> > > try to do the same as other drivers do.  
> > 
> > I think this one may be fine. Configuration which has to be set before
> > device probing can't really be per-device.  
> 
> This configuration can be different between multiple devices
> which use same igb module. Module parameters doesn't allow such
> separation.

Configuration of the device, sure, but this module param is more of 
a system policy. BTW the name of the param is not great, we're allowing
the use of random address, not an invalid address.

> Also, as a user, I despise random module parameters which I need
> to set after every HW update/replacement.

Agreed, IIUC the concern was alerting users to incorrect EEPROM values.
I thought falling back to a random address was relatively common, but
I haven't done the research.
