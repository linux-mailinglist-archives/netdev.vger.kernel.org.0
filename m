Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B184B8CF8
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiBPP4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:56:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiBPP4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:56:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E5295FE6;
        Wed, 16 Feb 2022 07:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E994BB81F22;
        Wed, 16 Feb 2022 15:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5C2C004E1;
        Wed, 16 Feb 2022 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645026958;
        bh=8OZ4F8L3mlbBTRmeRoe+yUd4/iypgzQCsH6kI3WopJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AvF5Ospx+1rwG5ppq98uewId0bUFWD2UhbFbmmSzTvocnPOeU3xZcI5nsNSOIaLNH
         lQJlwwh00Y0CQdjm6n5mEfdEi7pScEN5McSjz+Vo56HbxoYzexrxTHJyECLXEzwC+x
         ZHQp+S5FK33zXTRCr9NzXa5RUy84mqYwHqban3U2Wh1+iw8KQ1uoNL9fIux7TIwtaL
         bDD5OykOamWX3h9+wYxnk14QH2T+ke0LvZCJRjs9pTPnC8RKwpgWFLk0XwkQm5bKPG
         zmZnjLRaopA0DPJiFlkIAbW2Y9RBs3k8h6vfbKYk7D69PO84UXflbDJmKqZpWk3MEe
         EzLZeNapjfZNw==
Date:   Wed, 16 Feb 2022 07:55:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, edumazet@google.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: Re: [PATCH net-next 6/9] net: tcp: use kfree_skb_reason() for
 tcp_v{4,6}_do_rcv()
Message-ID: <20220216075556.39018f02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216035426.2233808-7-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
        <20220216035426.2233808-7-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 11:54:23 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() used in tcp_v4_do_rcv() and tcp_v6_do_rcv() with
> kfree_skb_reason().
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

Clang says:

net/ipv6/tcp_ipv6.c:1556:6: warning: variable 'reason' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (tcp_rcv_state_process(sk, skb))
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv6/tcp_ipv6.c:1567:24: note: uninitialized use occurs here
        kfree_skb_reason(skb, reason);
                              ^~~~~~
net/ipv6/tcp_ipv6.c:1556:2: note: remove the 'if' if its condition is always false
        if (tcp_rcv_state_process(sk, skb))
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv6/tcp_ipv6.c:1547:8: warning: variable 'reason' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                        if (tcp_child_process(sk, nsk, skb))
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv6/tcp_ipv6.c:1567:24: note: uninitialized use occurs here
        kfree_skb_reason(skb, reason);
                              ^~~~~~
net/ipv6/tcp_ipv6.c:1547:4: note: remove the 'if' if its condition is always false
                        if (tcp_child_process(sk, nsk, skb))
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv6/tcp_ipv6.c:1543:7: warning: variable 'reason' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                if (!nsk)
                    ^~~~
net/ipv6/tcp_ipv6.c:1567:24: note: uninitialized use occurs here
        kfree_skb_reason(skb, reason);
                              ^~~~~~
net/ipv6/tcp_ipv6.c:1543:3: note: remove the 'if' if its condition is always false
                if (!nsk)
                ^~~~~~~~~
net/ipv6/tcp_ipv6.c:1479:2: note: variable 'reason' is declared here
        enum skb_drop_reason reason;
        ^
