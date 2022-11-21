Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA51E632B0E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiKURd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiKURd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:33:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8CA57B44
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8444261368
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 17:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5A9C433D6;
        Mon, 21 Nov 2022 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669052005;
        bh=dENgJaUlE/WjMyKaGZKZYy3qwvGcyd0ua0zDVUXVPLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vrlhs7DffarPXm3R5YHD37eJJeT45hUMRj4CmTradrb7anlH0nYUohrMBE7U0LvxV
         eB0/5ivnld9XaPFloDte4NVagjRmClKrNhpQSclqKC1EYlnqtQ4UCsRRpz8/IXY5gc
         i0q66oqBJkBpg2KDiFqUerMwMU6bJ3OqyGErwW4czKV5Yn9xlOUyDI7rNHOqR/H9H7
         dU7aobqbOHP+YEXtCHOew5hsglK4MEUhydRRAMz4pHEAxmR/jiriIpQFQdJmtb8qj5
         fld0QAFaUOGGSGR4NmmXqTB8HM8FbCjSlPh2gpP/MXTD+91n74PWF1ALgRCkNx841V
         d/GNaBB25RWeg==
Date:   Mon, 21 Nov 2022 09:33:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [Need Help] tls selftest failed
Message-ID: <20221121093324.74fc794f@kernel.org>
In-Reply-To: <Y3mcParyv6lpQbnk@Laptop-X1>
References: <Y3c9zMbKsR+tcLHk@Laptop-X1>
        <20221118081309.75cd2ae0@kernel.org>
        <Y3mcParyv6lpQbnk@Laptop-X1>
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

On Sun, 20 Nov 2022 11:17:17 +0800 Hangbin Liu wrote:
> On Fri, Nov 18, 2022 at 08:13:09AM -0800, Jakub Kicinski wrote:
> > Hm, looks like a config problem. CRYPTO_SM4 is not enabled in the
> > config, even tho it's listed in tools/testing/selftests/net/config. 
> > Maybe it's not the right symbol to list in the test, or there is
> > a dependency we missed?  
> 
> From the build log[1], the CKI will read selftests/net/config and reset
> CONFIGs if it is not defined or need redefined. e.g.
> 
> ```
> Value of CONFIG_MPLS_IPTUNNEL is redefined by fragment
> ./tools/testing/selftests/net/config:
> Previous value: CONFIG_MPLS_IPTUNNEL=y
> New value: CONFIG_MPLS_IPTUNNEL=m
> 
> Value of CONFIG_NET_SCH_INGRESS is redefined by fragment
> ./tools/testing/selftests/net/config:
> Previous value: CONFIG_NET_SCH_INGRESS=y
> New value: CONFIG_NET_SCH_INGRESS=m
> 
> Value of CONFIG_NET_CLS_FLOWER is redefined by fragment
> ./tools/testing/selftests/net/config:
> Previous value: CONFIG_NET_CLS_FLOWER=y
> New value: CONFIG_NET_CLS_FLOWER=m
> ```

But these only list downgrades from =y to =m,
none of them actually enable things.
 
> And in the config file[2], all the CONFIGs in selftests/net/config are
> set correctly except CONFIG_CRYPTO_SM4. I saw in the config file it shows
> 
> # CONFIG_CRYPTO_SM4_GENERIC is not set
> 
> Is there any dependence for CONFIG_CRYPTO_SM4?

none that I can see:

config CRYPTO_SM4
        tristate
