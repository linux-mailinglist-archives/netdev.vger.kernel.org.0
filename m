Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E79D584476
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiG1Q4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiG1Q4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:56:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83748550A5;
        Thu, 28 Jul 2022 09:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BFC461D07;
        Thu, 28 Jul 2022 16:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043B2C433C1;
        Thu, 28 Jul 2022 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659027391;
        bh=B6rUCeLnh3zKa/C/9iHbOCyopE6kIGU1JVaQFJIIV2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cNkUW/MYkRnq+bDo3SzeItVJ8q+nei5gfKhFR2AfkiEyU1Pg+CtqykDMWYBZQpn5u
         D7TnN/vRrk6lHZ+oot7krwjx8tRjgVg8tdbrX2RJuNfYsCmU9z2ZoL43Pqmf8RADQJ
         y3DCN7IsaTMhVE3Npcu7PQpEEYPwlNPbOlfM4VoalWBhJgaizosly5mbky2slyX4Z/
         yB8b/Oh4NQPnCFg5GH+uZxnkRuJF/OzEiav5KeJGQ9WEilROqzzdVcgQ/V8QW43IC/
         7GVebDSvqWye3fqVI2mYUHUtQesI7/eOqFYg+vexlLuF+T0CmbaxtHzAOFpWx+wA3v
         LfgN+DSB5THFQ==
Date:   Thu, 28 Jul 2022 09:56:29 -0700
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
Message-ID: <20220728095629.6109f78c@kernel.org>
In-Reply-To: <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
        <20220727060909.2371812-1-kafai@fb.com>
        <YuFsHaTIu7dTzotG@google.com>
        <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
        <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
        <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
        <20220727184903.4d24a00a@kernel.org>
        <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
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

On Thu, 28 Jul 2022 09:31:04 -0700 Martin KaFai Lau wrote:
> If I understand the concern correctly, it may not be straight forward to
> grip the reason behind the testings at in_bpf() [ the in_task() and
> the current->bpf_ctx test ] ?  Yes, it is a valid point.
> 
> The optval.is_bpf bit can be directly traced back to the bpf_setsockopt
> helper and should be easier to reason about.

I think we're saying the opposite thing. in_bpf() the context checking
function is fine. There is a clear parallel to in_task() and combined
with the capability check it should be pretty obvious what the code
is intending to achieve.

sockptr_t::in_bpf which randomly implies that the lock is already held
will be hard to understand for anyone not intimately familiar with the
BPF code. Naming that bit is_locked seems much clearer.

Which is what I believe Stan was proposing.
