Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6488647D20
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 06:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLIFF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 00:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIFF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 00:05:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BC46D7D1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 21:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF56620DB
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 05:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC791C433EF;
        Fri,  9 Dec 2022 05:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670562325;
        bh=X2ldztFRWY1hBdbUyFOnPGgwPiJcnBDBau7Tk9viz7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hhycTgVOiCln7x8enYOTiNCO+AWNO2hk9nPXnW5HT3WhWebLoUi+FSVZ0v0qf+iIY
         iqwr9sWJSa1ty5D3UqqzenN2QP1m7mXiH5HsOSDAJGrcHyGcn91LYtr3NfzQKa2HnK
         LGqaM+tL8i7LBF1CxLwztwi5Y3uAUR4ZNdJJX7rZS3XiNFMO8ArqdF63PRb5eNq98o
         9WnnCjLa9nwrCHjNdZQvIF9ao4MoKONjWOqtY3aW6cOxC+EMEvMrbYC3vQX3ERG0Qt
         MqM3QwDN0LAalIDBB2z41CZ3RLoSjuEDQooY55RAcYkNX8ZX7Z+LD+R1uQ2Fyb4wPi
         KTWI4lCl9lkkA==
Date:   Thu, 8 Dec 2022 21:05:23 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <Y5LCE57xAaMQqOYd@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
 <20221203221337.29267-15-saeed@kernel.org>
 <20221206203414.1eaf417b@kernel.org>
 <Y5AitsGhZdOdc/Fm@x130>
 <20221207092517.3320f4b4@kernel.org>
 <Y5GgNlYbZOiH3H6t@x130>
 <20221208170459.538917da@kernel.org>
 <Y5KWJYBij3bzg5hU@x130>
 <20221208180442.2b2452fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208180442.2b2452fb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 18:04, Jakub Kicinski wrote:
>On Thu, 8 Dec 2022 17:57:57 -0800 Saeed Mahameed wrote:
>> So the whole thing started from finding these gaps in our out of tree
>> driver. there's the bug fix i will explain below, and the addition of .1ad
>> both were found missing upstream when we convinced a customer to switch
>> to upstream/inbox driver.
>>
>> vst .1q and vst .1ad are both totally separate scenarios and use cases for
>> the customers.
>>
>> Currently upstream mlx5 only support VST for vlan proto .1q,
>> but it's buggy when traffic from the guest comes with a vlan tag,
>> depending on the HW/FW version, either the packets get dropped or
>> the guest vlans get overridden with the VST host vlan, this is due to
>> wrong interpretation of the hw steering rules in the initial driver
>> implementation. in both cases it's a bug and the latter is even worse.
>
>I see, but that's the fix? Uniformly drop?
>Start stacking with just .1q?
>Auto-select the ethtype for .1ad if there's already a tag?

push the vst .1q tag. keep original tags intact.
per policy we won't have .1ad support :( .. 

