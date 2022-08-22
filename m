Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F314159CACF
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiHVV1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiHVV1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:27:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906F24055A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B167B80D36
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E50C433D6;
        Mon, 22 Aug 2022 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661203636;
        bh=I4bZ+qq99iN7aILSjBp+/tq8jCwiEIIeYhHwvIdDoso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJrFBfAE8B4BdLZ2sTY668jVo2RuOsaLTOh9RL6z6x6saKMvgJs1kWX4DHaPMqVzX
         kZ9WGVQu7N4VIYg3/bfElBIYmNjrhSjbzffdsGFjvGYVY/necYaTi82bRvpG/15sB/
         iMFTZG2UI/nw3iViPWQRzZ4JcX5SaRX3FrP9IUfOG9EK33zODxfSXSRjYKOfTpldcU
         CGmoAWIKBp8gcjQxbe6fqkxfgtXyGagM9Kfe7laTLb5hem9I4EcwwHn533U5ezod/a
         a7OPPYiGvVPxuLH/hJjUX7i7GdQ3xir2/ljx0bfiLIB+0aVjG00s4Bkj6WSxrDpIZ/
         nhnGvAp3GGOVQ==
Date:   Mon, 22 Aug 2022 14:27:16 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220822212716.yji3ugbppse7snfy@sx1>
References: <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220822093304.7ddc5d35@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Aug 09:33, Jakub Kicinski wrote:
>On Mon, 22 Aug 2022 11:54:42 +0300 Leon Romanovsky wrote:
>> On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
>> > On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:
>> > > Yup, that's what I thought you'd say. Can't argue with that use case
>> > > if Steffen is satisfied with the technical aspects.
>> >
>> > Yes, everything that can help to overcome the performance problems
>> > can help and I'm interested in this type of offload. But we need to
>> > make sure the API is usable by the whole community, so I don't
>> > want an API for some special case one of the NIC vendors is
>> > interested in.
>>
>> BTW, we have a performance data, I planned to send it as part of cover
>> letter for v3, but it is worth to share it now.
>>
>>  ================================================================================
>>  Performance results:
>>
>>  TCP multi-stream, using iperf3 instance per-CPU.
>>  +----------------------+--------+--------+--------+--------+---------+---------+
>>  |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
>>  |                      +--------+--------+--------+--------+---------+---------+
>>  |                      |                   BW (Gbps)                           |
>>  +----------------------+--------+--------+-------+---------+---------+---------+
>>  | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
>>  +----------------------+--------+--------+-------+---------+---------+---------+
>>  | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
>>  +----------------------+--------+--------+-------+---------+---------+---------+
>>  | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
>>  +----------------------+--------+--------+-------+---------+---------+---------+
>>  | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
>>  +----------------------+--------+--------+-------+---------+---------+---------+
>>
>>  IPsec full offload mode behaves as baseline and reaches linerate with same amount
>>  of CPUs.
>>

Just making sure: Baseline == "Clear text TCP" ?

>>  Setups details (similar for both sides):
>>  * NIC: ConnectX6-DX dual port, 100 Gbps each.
>>    Single port used in the tests.
>>  * CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz
>
>My questions about performance were more about where does
>the performance loss originate. Is it because of loss of GRO?

Performance loss between full and baseline ? it's hardly measurable .. 
less than 3% in the worst case.

>Maybe sharing perf traces could answer some of those questions?
