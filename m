Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0844B6B8566
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCMWzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCMWyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:54:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFE08B058
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 15:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33B23B815BD
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB58C433D2;
        Mon, 13 Mar 2023 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678747983;
        bh=dgayvY1DzO/WEls52yqiGmb0tMT7G00AtguEdH5fxoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GrU6E8TY1Oq3RCgMQyKcdbPkwVzQIF999ro4V96IJa+C3hZ1XkNesRptyGcC38LbZ
         aX+baMn1h125OdjhuD6rny0CSneoDDciqgcOhNTJANmtdquk/cE/Tu6TB+hDu74tq+
         OaV/0nhdI2u2h6hdr5jNoL08NMm72npyEbv0PTvlhSXXuG/fWNdBcRYTal3lv60ZPY
         6yLnwui5EAr28k2fKvkT3q8L91cwbEy8hqTyvba8VgOgmSU1MBpJiYtVlve67GYKTX
         6EpeNpk3RNKqNUi/YSJNy+0HBxErmJPRcsrx/Gff26NiSJOLUV28goP+j+eAVODDbu
         KoUsAz9fpYNmw==
Date:   Mon, 13 Mar 2023 15:53:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
Message-ID: <20230313155302.73ca491d@kernel.org>
In-Reply-To: <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
        <20230309232126.7067af28@kernel.org>
        <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Mon, 13 Mar 2023 22:34:17 +0000 Mogilappagari, Sudheer wrote:
> > RSS contexts are somewhat under-defined, so I'd prefer to wait until we
> > actually need to extend the API before going to netlink.
> > I think I told you as much when you posted initial code for RSS?
> 
> Hi Jakub, we are making these changes based on below discussion:
> https://lore.kernel.org/netdev/0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com/
> Our thinking was to move existing functionality to netlink first and then
> add new parameter (inline-flow-steering). Hence the reason for sending RSS_GET 
> first and now RSS_SET. Are you suggesting that new parameter changes be sent
> together with this patch-set ? 

Ah, so you do have a feature. Yes, it would be somewhat helpful but my
larger concern remains. We skipped the dump implementation when
implementing GET. The admin still has no way of knowing what / how many
RSS contexts had been created. With the context ID being an unbounded
integer just going from 0 until ENOENT is not even an option.

So we need to start tracking the contexts. Add a pointer to struct
netdevice to hold an "ethtool_settings" struct. In the ethtool settings
struct add a list head. Put an object for each created RSS context on
that list.

Then implement dump, then the netlink SET. (All one series.)
