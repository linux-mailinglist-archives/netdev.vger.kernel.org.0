Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EEE6BC571
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCPFDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCPFDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3562798C;
        Wed, 15 Mar 2023 22:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9AD61E4A;
        Thu, 16 Mar 2023 05:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F99CC433EF;
        Thu, 16 Mar 2023 05:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678943008;
        bh=wuyLkAmCbXu83oP/PylzeBaITgCobx+xRrmdPzJ0nFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rp2M3JpFKwhuWELXro8JPyNvqf72kfPkz1nD53AunXOgCkOdmrwEwQvxX67J7nWgI
         Ti1WbxEztgUW0aGROlQ+bviMJU0Qwn9SSguLvJ37+Q56OP8KRxpl969GeyRvFgMoMF
         7Dvl8ol6HSwf1g5le66Swn5OXo2cpcynqo91ExhNWcKHLCUHhUoQQp46EH2VvHH+9D
         AugCo0IjvYWbTkABipRKshsA0QLqReaNPjV+/IGJfP8jHQ7/K3YoUWlcGyofv7JER0
         mr7ouTBB9rYbyOzG/IgRSflb+vLLt2dFCcxjXPzv6eh7Pr0jmxmmAl5D2IEmJSFnrn
         O8UrT4/y2urag==
Date:   Wed, 15 Mar 2023 22:03:27 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <ZBKjHwr8jPl4sBFl@x130>
References: <cover.1678364612.git.lorenzo@kernel.org>
 <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
 <20230315163900.381dd25e@kernel.org>
 <20230315172932.71de01fa@kernel.org>
 <ZBKC8lxQurwQpj4k@x130>
 <20230315195338.563e1399@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230315195338.563e1399@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 19:53, Jakub Kicinski wrote:
>On Wed, 15 Mar 2023 19:46:10 -0700 Saeed Mahameed wrote:
>> >I think so.. let me send a full patch.
>>
>> We have an  internal version of a fix, Tariq is finalizing some review
>> comments and we will be posting it ASAP.
>
>Ah, I already posted. Does it look different?
>

Yes, completely different, Tariq's fix is in mlx5 only.
He splits the xdp  feature setting into two functions, 
one to initialize the netdev's xdp before registration,
and another one to update xpd features and call the notifier in the
"after" registration set_features flows.

I like our solution more, since it's more explicit and doesn't require
patching xdp stack because mlx5 abused xdp_set_features_flag, unless other
drivers have the same issue.

>https://patchwork.kernel.org/project/netdevbpf/patch/20230316002903.492497-1-kuba@kernel.org/
>

I don't see anything wrong with your patch though.. it also looks more
elegant, i dunno, I will let you decide, here's our patch:
https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=testing/xdp-features-fix&id=72e2266525948ba1498e6a3f2d63ea10d5ee86f5


>I wanted to make sure that it's ready for tomorrow's PR


