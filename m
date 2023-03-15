Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952696BA620
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjCOEXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjCOEXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6703B87A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A9BB81BC1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759CDC433D2;
        Wed, 15 Mar 2023 04:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678854215;
        bh=1vE7vMP4C/20PMDP2JOlSYqj42PYkxcGIrRk+6ZkjOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tnmp1KHhmb9bEXszTwP38NSk4Is3JxAXek+Uxe/AxF8GmYWTbLz8G/jzQTDAhFXan
         fZz+6PMjkGONcJ4geGcU25tvRS+cXBayHR0xJyELcbnmu2O73RFYVYVanKzxsxjBpa
         vakQCa5UjYOLmxhS7UaYfMBewpiqn8q+fvZQIKMf0jSSKUxOx+q/e1btfei6BHsTbp
         gmRiWgcJw9Qh1Vv36/D5rVKUoFHfFGTB3IQ8hZ44MoKYeyneRL5OmUv3pzkfWNX+AZ
         8o4Ch3F6GDLehcsTDdMMrxYjRBQUbm0cJbrMqjCRURvOygzc6sUHDr2oECTBz6Uvls
         1w0PJXdoatFrg==
Date:   Tue, 14 Mar 2023 21:23:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
Message-ID: <20230314212334.188ad6e0@kernel.org>
In-Reply-To: <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
        <20230309232126.7067af28@kernel.org>
        <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20230313155302.73ca491d@kernel.org>
        <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
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

On Tue, 14 Mar 2023 13:34:51 +0000 Edward Cree wrote:
> > Add a pointer to struct
> > netdevice to hold an "ethtool_settings" struct. In the ethtool settings
> > struct add a list head. Put an object for each created RSS context on
> > that list.  
> Would an IDR not be appropriate here, rather than a list?

Yup, I was too lazy how much memory IDR eats when unused, and list is
easier to explain, but let's just go for an xarray if you're doing it.

> AFAICT every driver that supports contexts either treats the context
>  ID as an opaque handle or as an index into a fixed-size array, so as
>  long as the driver reports its max context ID to the core somehow,
>  the specific ID values chosen are arbitrary and the driver doesn't
>  need to do the choosing, it can just take what comes out of the IDR.

Sounds great.
