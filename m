Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9C84C187E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241971AbiBWQX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiBWQXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:23:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE26B12D3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:22:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2C66199C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50676C340E7;
        Wed, 23 Feb 2022 16:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645633376;
        bh=L7AUJ0Ujt7SMkKgnblJmmr+YxGDw4pmHtxpO9yiy088=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dDRRiKlZdUFW9lpHF+pWvLPmEjHAZpIKm5z65T8/ceD02HmAJ/m+lU+f5JpsnxluK
         UYE6b84B/xH2/JDxyhK3vLywAclyuB/avqV5obZgw5KVZTAJorfHID38Rwktu4G0n3
         PwkdOWmqp3gaa5KyFgWdA2kL5ZvUvTaPpVPUtGxK8trtFQiO1IaZWCLTLiLKHnQ1Tz
         81En+qIMraUCSTfZ57IVZXsj6+PHOrFUX0qVXW6+aC7IwHrz+FfxCKggtlH3hRaVqU
         Vt5brfk/mEuL+S+yuGQr/lBiy5lBEoNKztF9Zyt0DwYlvHaRBQFy/LcrCipU1k9TJ9
         GMb9HseU+pnnQ==
Date:   Wed, 23 Feb 2022 08:22:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
Message-ID: <20220223082255.13136ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7184c4eb-7378-5ce3-f24e-4a8e9344aa87@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-8-roopa@nvidia.com>
        <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <920ce92c-46e2-3b8a-4d0a-40daaf049b64@nvidia.com>
        <20220222195044.06313f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7184c4eb-7378-5ce3-f24e-4a8e9344aa87@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 22:31:18 -0800 Roopa Prabhu wrote:
> > Makes sense. I wasn't quite sure if this isn't over-engineering
> >   - do deployments really use VxLAN devs with many VNIs?  
> 
> yes, vnis are unfortunately used to stretch layer 2 domains exceeding 
> the 4k vlan limit
> 
> In the example provided in this series, vnis can be deployed in the 
> ranges of more than 15k if each customer is allocated a 4k vlan range 
> (bridge domain),
> 
> and a single switch can host 3-4 customers.
> 
> the scale is also the reason to switch to dst metadata devices when 
> deployed vni numbers get large. The traditional vxlan netdev per vni 
> does not work well at this scale.

Ah, now it all clicked together, thanks!
