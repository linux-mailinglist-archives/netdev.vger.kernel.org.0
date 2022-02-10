Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DD64B1273
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbiBJQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:13:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiBJQN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:13:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F3BEB;
        Thu, 10 Feb 2022 08:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D909CB82502;
        Thu, 10 Feb 2022 16:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2B2C004E1;
        Thu, 10 Feb 2022 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644509604;
        bh=yFSefZtuKQy+rRIhxF1xA6U/rPoybWM9PhFAUBbHG4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=omKDqNLOK28NXXBpI8y/0QKJdODpuPMxSBXgJitMG6FMucQbGqWziba50lf04oWmO
         NZupU4/tQ5M6BE+zCe13cWEvGoPCHXLlROWv9dbL0YhHb1ScBhKi9GoF5ZAQ8kJBZE
         o4/2JuEIFiq61S/7ttd9ZQj9elCt38NhyCPSYUADGDHJoMlN0tO/ooXJKk2+Lr77pc
         JaFyKR+ZgZuvnM4xEnIjsLsEqtW381pogJQM42X21sosnJ3OoHoz3abs2lq/6Aoznw
         L7l3hRa3GIikd2DIe8CzEO2rywLlJv5slLdehwZDFDCy/TOVBf+iov9aWUaVIrxqaV
         2OzALRYnYl+Aw==
Date:   Thu, 10 Feb 2022 08:13:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
Message-ID: <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
        <20220128073319.1017084-2-imagedong@tencent.com>
        <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
        <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
        <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
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

On Thu, 10 Feb 2022 21:42:14 +0800 Menglong Dong wrote:
> How about introducing a field to 'struct sock' for drop reasons? As sk is
> locked during the packet process in tcp_v4_do_rcv(), this seems to work.

I find adding temporary storage to persistent data structures awkward.
You can put a structure on the stack and pass it thru the call chain,
that's just my subjective preference, tho, others may have better ideas.
