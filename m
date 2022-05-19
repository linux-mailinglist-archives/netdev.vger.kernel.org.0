Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA19652D935
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241705AbiESPuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241694AbiESPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25BF5D5D0;
        Thu, 19 May 2022 08:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A19F0B82565;
        Thu, 19 May 2022 15:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789FAC385AA;
        Thu, 19 May 2022 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652975333;
        bh=Z/Jz/qoto7g/A5WpTJdvGlDKQHz2io6bGK/5IyiGdpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QtZtIhnbMrGw86tlDoO7IOj5Xu0uz/syLTL+fmMf3RmZHG8L1RWEnFMuU8+uVz97n
         4HX/vaoU79DOYamBscP8n/WGptbmo2RB3QYoqWvp+KjYLoWNkZ6ThOXegna4MvE7ya
         6+UrJ4cFDm6mwXBcsOKNzxEJllnwVpfVGq3vvioVc0CqN8E/IIs2in/gQGioIvxZRl
         ZNK5jzzcj/6PlaqwESCmrzp+IyremHh7lYIYud9i+xzMQ8w7VSsXUYeG/smy4qPywm
         Gilxyh6g8NTHVSusq4tQnGXjIzslFPuOhOiGCCdwWjcPsNQd9KWpmhUm7oBQTzX1hu
         B0QpLhKyPNa9Q==
Date:   Thu, 19 May 2022 08:48:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
Message-ID: <20220519084851.4bce4bdd@kernel.org>
In-Reply-To: <20220513030339.336580-5-imagedong@tencent.com>
References: <20220513030339.336580-1-imagedong@tencent.com>
        <20220513030339.336580-5-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 11:03:39 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The 'drop_reason' that passed to kfree_skb_reason() in tcp_v4_rcv()
> and tcp_v6_rcv() can be SKB_NOT_DROPPED_YET(0), as it is used as the
> return value of tcp_inbound_md5_hash().
> 
> And it can panic the kernel with NULL pointer in
> net_dm_packet_report_size() if the reason is 0, as drop_reasons[0]
> is NULL.
> 
> Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")

This patch is in net, should this fix have been targeting net / 5.18?
