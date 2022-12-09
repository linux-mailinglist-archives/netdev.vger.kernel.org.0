Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A107647BD6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLICEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiLICEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:04:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B217D093
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 18:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BA36210D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E8C433D2;
        Fri,  9 Dec 2022 02:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670551484;
        bh=l5MTcSQ/v1/+zAgbWIg+JJuUgg1pcvuT9mA7lqo1JG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fw782NJ669ZzqYhNNVa+ASwqz7QuhSROivkSrcnw7oYMzg/Nx48VOLfzhOfRw6X0/
         9NvL44d1ug4t5GxOFaxl35ZWZgPnxAgkIi3zgD2oPWuY+R5GYb6cDQi0ic6pK/SWSl
         FPpdVGR3CqO74XU4GkWN+7fKkfqls39yQ/aViIEv9ytOP7Eh+Z2yXhg/cioy5etV8h
         9u7bx2GWJvQwl7yPxZysa1rWYrOZ+FTmlkSZd5De0dgv+/cvDQ3xwIFFmlFlAyffmw
         lxU+CtOTRKLj0caj0RCyl8XzXVLyOpTVyQ8vwW9EmXLPbMFRsa2d/fm//MiQL/glvd
         gwi4ULievnCsQ==
Date:   Thu, 8 Dec 2022 18:04:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <20221208180442.2b2452fb@kernel.org>
In-Reply-To: <Y5KWJYBij3bzg5hU@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
        <20221203221337.29267-15-saeed@kernel.org>
        <20221206203414.1eaf417b@kernel.org>
        <Y5AitsGhZdOdc/Fm@x130>
        <20221207092517.3320f4b4@kernel.org>
        <Y5GgNlYbZOiH3H6t@x130>
        <20221208170459.538917da@kernel.org>
        <Y5KWJYBij3bzg5hU@x130>
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

On Thu, 8 Dec 2022 17:57:57 -0800 Saeed Mahameed wrote:
> So the whole thing started from finding these gaps in our out of tree 
> driver. there's the bug fix i will explain below, and the addition of .1ad
> both were found missing upstream when we convinced a customer to switch
> to upstream/inbox driver.
> 
> vst .1q and vst .1ad are both totally separate scenarios and use cases for
> the customers.
> 
> Currently upstream mlx5 only support VST for vlan proto .1q, 
> but it's buggy when traffic from the guest comes with a vlan tag, 
> depending on the HW/FW version, either the packets get dropped or
> the guest vlans get overridden with the VST host vlan, this is due to
> wrong interpretation of the hw steering rules in the initial driver
> implementation. in both cases it's a bug and the latter is even worse.

I see, but that's the fix? Uniformly drop?
Start stacking with just .1q? 
Auto-select the ethtype for .1ad if there's already a tag?
