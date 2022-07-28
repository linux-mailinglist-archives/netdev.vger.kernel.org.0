Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA158452C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiG1Rkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG1Rkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5841A743DF;
        Thu, 28 Jul 2022 10:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78DE61D67;
        Thu, 28 Jul 2022 17:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA964C433C1;
        Thu, 28 Jul 2022 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659030030;
        bh=NAxXDnSczzozx1WrRkURk3q4OYlqYARSYkqGoCWcuxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ayTTvDzcHZd5mgPzNrw1FgMXC4UBpKIDe2fVqk0DANBhvaUJ488sp+rg4sK8wLpcP
         zncZSmDEY+WIxZjY9OLYwJEekOzTp/C70dnh/calXPZpxFCaiCirSpphI8N9TnfnR2
         dShpP4txufRLq6HKWKZxOrlAK24SAw/XA4lJ/CuGhQWsE7HAJ/zgTtmBMg0IMf3ZE2
         oNhTtiAH1bYv/OTaa0ii++3OEA8T8PtMSOm8qADUcz/uDiDe2SN0s51KBc4y1uFnzW
         kcK6MDIWgVnrBHNeBzJAddW4mCRBDhLFW5xnTbTZFsIJvwXGrKPP6ng9iQZoYQNEf6
         QxwLgnECwvZ9g==
Date:   Thu, 28 Jul 2022 10:40:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220728104028.04cd6842@kernel.org>
In-Reply-To: <20220728172004.6mpkycl52sszuudc@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060909.2371812-1-kafai@fb.com>
        <YuFsHaTIu7dTzotG@google.com>
        <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
        <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
        <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
        <20220727184903.4d24a00a@kernel.org>
        <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
        <20220728095629.6109f78c@kernel.org>
        <20220728172004.6mpkycl52sszuudc@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 10:20:04 -0700 Martin KaFai Lau wrote:
> > Which is what I believe Stan was proposing.  
> Yeah, I think I read the 'vote against @in_bpf' in the other way. :)

My bad, I didn't read the proposal in sufficient detail to realize 
the helper is called the same thing as the bit :D
