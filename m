Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2036A6BA979
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjCOHj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjCOHi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:38:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02F62597C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:37:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8162A21958;
        Wed, 15 Mar 2023 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678865857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ju6K31RwQTxowS/99Qlvy5GW4bETwCzwYP1STl/ymhs=;
        b=OyD6lvUPOL9j1mKd4bI3otCdSOz0NKBV4Co9Rg1TGXDgAzgzCWGyGgh5yeWwqXA9MupH0U
        ceSHu1F+q3TwZXimghnKy5uJQawWIwbOy2Kfbv5dpZcEC5D8SXMEVR7g/KZxdHncZ3mGNG
        joFNau44loLWx9FYxRjTGAlGcl1d1ZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678865857;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ju6K31RwQTxowS/99Qlvy5GW4bETwCzwYP1STl/ymhs=;
        b=zlg3CD8yN+xzFrTN0CoblNNbHMgWN+nhjVmXZ+hsBL4OvmcyngtjCfOl9ioLJfAy9hKgTv
        hgblQo1LPMuvzRCA==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.prg.suse.de [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6771E2C141;
        Wed, 15 Mar 2023 07:37:36 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C057A60314; Wed, 15 Mar 2023 08:37:32 +0100 (CET)
Date:   Wed, 15 Mar 2023 08:37:32 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
Message-ID: <20230315073732.jjcxv2ywkbw6vvuk@lion.mk-sys.cz>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
 <20230309232126.7067af28@kernel.org>
 <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230313155302.73ca491d@kernel.org>
 <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
 <IA1PR11MB62665C2D537234726DAF87D9E4BE9@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230314212427.123be0ee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314212427.123be0ee@kernel.org>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:24:27PM -0700, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 23:51:00 +0000 Mogilappagari, Sudheer wrote:
> > How to get devname to be WILDCARD_DEVNAME ?
> 
> Isn't it just \* ?
> 
> $ ethtool \*

Yes, that's how it's supposed to work:

------------------------------------------------------------------------
mike@lion:~> /usr/sbin/ethtool -l '*'

Channel parameters for eth0:
Pre-set maximums:
RX:             n/a
TX:             n/a
Other:          1
Combined:       8
Current hardware settings:
RX:             n/a
TX:             n/a
Other:          1
Combined:       8

Channel parameters for eth1:
Pre-set maximums:
RX:             n/a
TX:             n/a
Other:          1
Combined:       8
Current hardware settings:
RX:             n/a
TX:             n/a
Other:          1
Combined:       8

Channel parameters for eth2:
Pre-set maximums:
RX:             n/a
TX:             n/a
Other:          1
Combined:       2
Current hardware settings:
RX:             n/a
TX:             n/a
Other:          1
Combined:       2
------------------------------------------------------------------------

In some cases where the output for a single device can consist of
many entries it may also make sense to iterate over something else.
Listing flow rules might be an example.

Michal
