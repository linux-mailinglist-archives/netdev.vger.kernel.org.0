Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF754DE40D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 23:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbiCRWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 18:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiCRWev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 18:34:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFD330CDAA;
        Fri, 18 Mar 2022 15:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C9A5B825D5;
        Fri, 18 Mar 2022 22:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E017C340ED;
        Fri, 18 Mar 2022 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647642809;
        bh=qI3HCaVnPopzq76RCyDfqmqAdYqunH01uTRZbf866/E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Z5TwEgdF//4M5OmCsB6AAkiINDIUp7vGWTnHQQ84+GhS0uHBFXlOn+Pod751y/gmv
         z/bmRjuMjjEzJIwWarx8krJ+0FleS76ZwZBAHb0ZIXjSbxKnpXrYU646L9CZzL4k3S
         BKJTcFozqUYwuv4zJuzW24TtYMqbh0Nh63AxIfCAx59n/+TlrSeLIc9Xl+fnkKECrx
         kBB7BMUsSosFZpfXT7fKGV+gk1YgWu6KcNGmCBTSGgB9oJQjTK7vmr0M6sjrczNvXr
         Q0YYgcuqVLazawCA6Kf7cmgKZloX/ONYlT/nYrOgeHsGGViH+WVyuIGIMv+73OvKzT
         PM568R+zXRFEA==
Message-ID: <98450e8a-b3e1-22d7-86fb-3c8456a36018@kernel.org>
Date:   Fri, 18 Mar 2022 16:33:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com>
 <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org>
 <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
 <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
 <a4032cff-0d48-2690-3c1f-a2ec6c54ffb4@kernel.org>
 <CADxym3bGVebdCTCXxg3xEcPwdfSQADLyPbLTJnPnwn+phqGp3A@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CADxym3bGVebdCTCXxg3xEcPwdfSQADLyPbLTJnPnwn+phqGp3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 1:26 AM, Menglong Dong wrote:
> Yeah, PTYPE seems not suitable. I mean that replace SKB_DROP_REASON_PTYPE_ABSENT
> that is used in __netif_receive_skb_core() with L3_PROTO, which means no L3
> protocol handler (or other device handler) is not found for the
> packet. This seems more
> friendly and not code based.
> 
>>> And use SKB_DROP_REASON_L4_PROTO for the L4 protocol problem,
>>> such as GRE version not supported, ICMP type not supported, etc.
> Is this L4_PROTO followed by anyone?

how about just a generic
	SKB_DROP_REASON_UNHANDLED_PROTO  /* protocol not implemented
					  * or not supported
					  */

in place of current PTYPE_ABSENT (so a rename to remove a Linux code
reference), and then use it for no L3 protocol handler, no L4 protocol
handler, version extensions etc. The instruction pointer to symbol gives
the context of the unsupported protocol.
