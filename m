Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C265F5F6A57
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiJFPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiJFPL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD98B5143
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C252619EB
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 15:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09E1C433C1;
        Thu,  6 Oct 2022 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665069086;
        bh=Z3wIJajmY8IyZ/vqpkQGUc7fyCvfv+sot57E5U/Y+qw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tKYM+5yBi3uAvcw4/XxBwQabbTFHTbmP/YPccdSip8AoY75v71QGabKCBLPvrV+QH
         oA/vZcDxkOwSU18YVh40NeQ8g+/LiyXQ+wsbr+WLOiFmfWLLA8O08tIZmaOMb4CU05
         3jNP/3Kp3yGJD2+/zQFEEZfyPmSvXR16DldPU0NTIWHWXCn01uUnCncLO6jIp9FgjS
         w8rzzdqWWPGMtkpQ0xdN4swSlSyL//n96TIyf6LblOME6UBNPHdkzndJbp+8s5LMZW
         azYkm9XOVNbCBpXUjID0BOOGy3Ebq7k7U1aj376/kDzgfmztnnsZqo3uOCd4BzFMUH
         Rucry7EcKYHwA==
Message-ID: <73a235e9-8a9c-a212-719f-15527de359fb@kernel.org>
Date:   Thu, 6 Oct 2022 09:11:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 net] ipv4: Handle attempt to delete multipath route
 when fib_info contains an nh reference
Content-Language: en-US
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Gwangun Jung <exsociety@gmail.com>
References: <20221006150842.9336-1-dsahern@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221006150842.9336-1-dsahern@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 9:08 AM, David Ahern wrote:
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index d5a0dd548989..15556138de76 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -1223,6 +1223,11 @@ ipv4_fcnal()
>  	log_test $rc 0 "Delete nexthop route warning"
>  	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
>  	run_cmd "$IP nexthop del id 12"
> +
> +	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
> +	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
> +	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
> +	log_test $? 1 "Delete multipath route with only nh id based entry"
>  }
>  
>  ipv4_grp_fcnal()

Did not intend to add this chunk to v2; it was hanging around the
branch. :-)

The return code check is wrong - should be 2, not 1. I will send a v3
later today.
