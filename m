Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1E86E4FA1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDQRvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDQRvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2381FC3
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3311628DB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559FFC433EF;
        Mon, 17 Apr 2023 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681753872;
        bh=eA/Pmv5a2ma7V4BCaBPliTqL+YWPU3cTmWdQCfrbjqc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=a2CCPjXPhg71SF/nSbQriwEh157TiYTmTPtRcYUrcCoRklE/FwrRD9TinsG0kp6Sj
         2VCqzbbVECNRJUtAKO57M66Ud8m5+iKoHqJ3qviWX1BNTXkaFH6JdcY9FK5/qn4JMr
         aMa1WSMnJlgqiKzLCj/WGg7ifyX+lKvBlqsicuqGsnoCrjUgukk5OQc4v642ngLSbK
         tZRYkAm3zzabqjUOqjwq1YCAIoJc27H7o22l/Et5dKJRH4zsajmVXGLKOSFETVoOCN
         LqlWdjpkBuAqOZ5fObOjff9AbPCXujbcaiE9fxhLDIO8yX9NeJ5aRLIRAE2y/EUQZF
         d6SIxnnkndLyg==
Message-ID: <f04d922e-c872-b6ab-32b6-4452cb34890b@kernel.org>
Date:   Mon, 17 Apr 2023 11:51:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCHv2 net] net: rpl: fix rpl header size calculation
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, daniel@iogearbox.net,
        ymittal@redhat.com, mcascell@redhat.com,
        torvalds@linuxfoundation.org, mcr@sandelman.ca
References: <20230417130052.2316819-1-aahringo@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230417130052.2316819-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 7:00 AM, Alexander Aring wrote:
> This patch fixes a missing 8 byte for the header size calculation. The
> ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
> points to skb_transport_header(). Currently we only check on the
> calculated addresses fields using CmprI and CmprE fields, see:
> 
> https://www.rfc-editor.org/rfc/rfc6554#section-3
> 
> there is however a missing 8 byte inside the calculation which stands
> for the fields before the addresses field. Those 8 bytes are represented
> by sizeof(struct ipv6_rpl_sr_hdr) expression.
> 
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
> changes since v2:
>  - use sizeof(struct ipv6_rpl_sr_hdr) instead of hardcoded 8
> 
>  net/ipv6/rpl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

