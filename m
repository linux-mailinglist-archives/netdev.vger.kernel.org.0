Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B796CABEF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjC0RhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjC0RhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:37:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8E26BD;
        Mon, 27 Mar 2023 10:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69EAAB817B1;
        Mon, 27 Mar 2023 17:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F55C433EF;
        Mon, 27 Mar 2023 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679938633;
        bh=MuO52qaReqcIdln0NNIIySF7AxqlHDIpBM5VMCT2wUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DGI9BwjhcAXlq/YTscQOGBnqoTxUhfBwhV+jRtf6RNgRegYfDp41f8sRhNajMyTo+
         Na+9cVqFjlwHIPqqXgx77sKZLvtUhULQSVyVDI1h2bgkCc8n5KCF1oKZpP+fhW0rZu
         ti3C1IGtFDAMWC8g88j3Yzo/Si+tC3fSwL9yROZeeHbqRrHYI9a5qzNvdfkGQBBCSe
         skVFkMlVtv6WgZxCROvIsvobWot0AXwCZAkoubZqCMornTpFGPjYv8Wrk/DzJihf1i
         YHIyX6mWpI2MOSr0YT4kiXC5JD9n2MmcNs0v6rPk5vO9/AyudKzrOr4pBX/A1UVTUa
         JZOXTnHY8NlmA==
Date:   Mon, 27 Mar 2023 10:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     Min Li <lnimi@hotmail.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee@kernel.org" <lee@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mfd-n 1/2] ptp: clockmatrix: support 32-bit address
 space
Message-ID: <20230327103711.7d73ea09@kernel.org>
In-Reply-To: <OS3PR01MB6593510463322D4410EB8D59BA8B9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <MW5PR03MB69324DE0DEA03E3C62C57447A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
        <20230323095626.14d6d4da@kernel.org>
        <OS3PR01MB6593510463322D4410EB8D59BA8B9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 14:54:41 +0000 Min Li wrote:
> > On Thu, 23 Mar 2023 12:15:17 -0400 Min Li wrote:  
> > > -		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> > > +		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
> > >  				  &temp, sizeof(temp));  
> > 
> > The flipping of the arguments should also be a separate patch.  
> 
> Hi Jakub
> 
> If I separate this change, the other patch would be broken since it changed
> HW_Q8_CTRL_SPARE from a u16 value to u32 and it doesn't fit the function's
> particular parameter anymore

Both arguments are u16 now, so nothing can overflow until you change
the addresses to be u32.

patch 1 - reorder the arguments
patch 2 - bump the types to u32
patch 3 - change the addresses
