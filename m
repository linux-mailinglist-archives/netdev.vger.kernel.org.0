Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD03647BC4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiLIB6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLIB6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:58:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEC06FF31
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:58:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38978B82707
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C182EC433EF;
        Fri,  9 Dec 2022 01:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670551078;
        bh=jX2AXJWBy+qdj/R0QS+Gg2E2kfiAjkXSPViHZ/ccVq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sti/52Xca2mUc2qYn1+RmRMHPialKshNE5MLUhtzhVanWEJUk0UdzE6DZXZX630xl
         lw6uR2t/5cVQXdSTsPhszjrJh1SSj3M9rm7OgnkQ9lzTAgh7bSs3z66o061QXDf0ot
         5JxmfItai7wcbR7g4SM3O3KVjP94gOw63pCYbe6Joe2aniHotBfHL40PMpTIurxKOA
         Y6AvtxqwqupOyaK0Zey9cCet8lFvFNvv07lvN3CiQgpRVTif0w/VRvP1hd5i2UK3rv
         7DZG/GM7GhNyOexA39bCZYlip2r4I2fW2oo3PfaIW2QgdhRBTexVnuvL0NvBVaPT03
         zcx2flongvAEw==
Date:   Thu, 8 Dec 2022 17:57:57 -0800
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
Message-ID: <Y5KWJYBij3bzg5hU@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
 <20221203221337.29267-15-saeed@kernel.org>
 <20221206203414.1eaf417b@kernel.org>
 <Y5AitsGhZdOdc/Fm@x130>
 <20221207092517.3320f4b4@kernel.org>
 <Y5GgNlYbZOiH3H6t@x130>
 <20221208170459.538917da@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208170459.538917da@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 17:04, Jakub Kicinski wrote:
>On Thu, 8 Dec 2022 00:28:38 -0800 Saeed Mahameed wrote:
>> So if the part in this series of adding support for 802.1ad, falls under that
>> policy, then i must agree with you. I will drop it.
>
>Part of me was hoping there's a silver bullet or a compromise,
>and I was not seeing it.. :)
>
>> But another part in this series is fixing a critical bug were we drop VF tagged
>> packets when vst in ON, we will strip that part out and send it as a
>> bug fix, it is really critical, mlx5 vst basically doesn't work upstream for
>> tagged traffic.
>
>What's the setup in that case?  My immediate thought is why would
>VST be on if it's only needed for .1ad and that's not used?

So the whole thing started from finding these gaps in our out of tree 
driver. there's the bug fix i will explain below, and the addition of .1ad
both were found missing upstream when we convinced a customer to switch
to upstream/inbox driver.

vst .1q and vst .1ad are both totally separate scenarios and use cases for
the customers.

Currently upstream mlx5 only support VST for vlan proto .1q, 
but it's buggy when traffic from the guest comes with a vlan tag, 
depending on the HW/FW version, either the packets get dropped or
the guest vlans get overridden with the VST host vlan, this is due to
wrong interpretation of the hw steering rules in the initial driver
implementation. in both cases it's a bug and the latter is even worse.


