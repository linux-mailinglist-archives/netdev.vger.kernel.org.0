Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2DD4FECB2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiDMCHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiDMCHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2919AE68
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D757618D5
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74592C385A8;
        Wed, 13 Apr 2022 02:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649815481;
        bh=Vu+KgFouk8ANRuvIxUVioi8TD5dzKVTLxlfZyOyStr0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oMWCA75tVI/a3DU0b4D8ROEQAnmjNK/m1j0epJam9eyCkHPdJfBkq+VniG4iML3kg
         BoKVDAljU/Pe/GNNEGd7BPLrb/C+LIRLdpRAzrH4sbabmkuqPNXhO+afe4r+yvBs3S
         GisDnceTSgUH/esU7j3XaZR9P6Z7nTI8itdEnWBJCUyAqdcvNQ2qxSM0vkwe7nxH2B
         eQN8f5KXRCVISg6D9yAup2eeOJVULPDOuk3Kl0zePcli439cSOdpi7JbrkLXhWlXJG
         XmxnrIxIQ06FKPqMiooKCqQvx0S3JaJFQnHjZbkG3RD+oIIVB/ZYyfhDFK1h+6OLMZ
         Q5fNsgwfKJhdQ==
Message-ID: <c418e95e-440e-0502-58f2-63179f370a98@kernel.org>
Date:   Tue, 12 Apr 2022 20:04:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220412132245.2148794-1-razor@blackwall.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 7:22 AM, Nikolay Aleksandrov wrote:
> Hi,
> This patch-set adds support to specify filtering conditions for a bulk
> delete (flush) operation. This version uses a new nlmsghdr delete flag
> called NLM_F_BULK in combination with a new ndo_fdb_del_bulk op which is
> used to signal that the driver supports bulk deletes (that avoids
> pushing common mac address checks to ndo_fdb_del implementations and
> also has a different prototype and parsed attribute expectations, more
> info in patch 03). The new delete flag can be used for any RTM_DEL*
> type, implementations just need to be careful with older kernels which
> are doing non-strict attribute parses. Here I use the fact that mac

overall it looks fine to me. The rollout of BULK delete for other
commands will be slow so we need a way to reject the BULK flag if the
handler does not support it. One thought is to add another flag to
rtnl_link_flags (e.g., RTNL_FLAG_BULK_DEL_SUPPORTED) and pass that flag
in for handlers that handle bulk delete and reject it for others in core
rtnetlink code.
