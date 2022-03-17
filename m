Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991764DCDF6
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbiCQSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiCQSvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:51:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1F315855B;
        Thu, 17 Mar 2022 11:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FED0CE2421;
        Thu, 17 Mar 2022 18:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135C9C340E9;
        Thu, 17 Mar 2022 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647542995;
        bh=8Z1XVSc7H5Hxk/DGfrhzpPCrEGYqxRVGj582MxmoFts=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=U3LXXsy3YjBCtFZPHXFuI+X3DzcHg9tNdkwTCn41x6XEtrKMh3VnpNf2c5OdXAnE7
         KhvplqlDxTu2OOaKmyuftp1QXcf4QWlG9f1yuUq9O1LKWsD8mIgOHy221LWkCSlkvB
         GHaTdbaWApjIIgUPhzzR3I5sSsBnOHaAub0Yl3oVPdrPWR7CUKc2xhvR3X6lpslVr+
         UAR4tiFy6QKhruRCWIKPxm/GvmRrzKixSTNJoCaMSaVV/d8CzPYzPJW4vDhJ6DMcMq
         t886+vI3CLO2tPJfkfgM8Ugb7mgmsEcY11uATWRnW11ZnhAtXijoSG6wC7Ezir6lB3
         BAy6hg5eSJnRQ==
Message-ID: <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org>
Date:   Thu, 17 Mar 2022 12:49:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
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

On 3/17/22 12:15 AM, Sun Shouxin wrote:
> This patch is implementing IPV6 RLB for balance-alb mode.
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
> changelog:
> v1-->v2:
> -Remove ndisc_bond_send_na and refactor ndisc_send_na.
> -In rlb_nd_xmit, if the lladdr is not local, return curr_active_slave.
> -Don't send neighbor advertisement message when receiving
>  neighbor advertisement message in rlb6_update_entry_from_na.
> 
> v2-->v3:
> -Don't export ndisc_send_na.
> -Use ipv6_stub->ndisc_send_na to replace ndisc_send_na
>  in rlb6_update_client.
> 
> v3-->v4:
> -Submit all code at a whole patch.

you misunderstood Jakub's comment. The code should evolve with small,
focused patches and each patch needs to compile and function correctly
(ie., no breakage).

You need to respond to Jiri's question about why this feature is needed.
After that:

1. patch 1 adds void *data to ndisc_send_na stub function and
ndisc_send_na direct function. Update all places that use both
ndisc_send_na to pass NULL as the data parameter.

2. patch 2 refactors ndisc_send_na to handle the new data argument

3. patch 3 exports any IPv6 functions. explain why each needs to be
exported.

4. patch 4 .... bonding changes. (bonding folks can respond on how to
introduce that change).

