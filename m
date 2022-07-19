Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4845757A828
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiGSUWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiGSUWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:22:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E15F3F319
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8FD1B81D01
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5320CC341C6;
        Tue, 19 Jul 2022 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262155;
        bh=MOPU3ZYL9bfuKzbwO6FhXKODRUIFG5H3UFfeKoeiXb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gzuDUGEPD9z2E0D0V1MyvrtkuoSWNMIaDDwvxl28Rdy2L7i/mpIXbcYYB9ISTtwW6
         9r7RRF52WKR7Otj3F/qU2PDL2ZYggt/3E1KgQTPZF2VS5D4vyBC5G3LnmF3UMzMbWD
         My8aEG1539+dkc3wMomX+h63jGINmZsCe8sBdB0y4J30sy5juPCixClM+m7ugXU9/Y
         W8tROceGroL1ORFvtNXVUrFZckw5pI3PvfQJS2e5PuQ/2g8RQjKoBSamKCk2xnB7HT
         z/PSAGgQQEG9tYIQzhGqH3JOw8lUFEO5cjauHQdLR8OlX5tv+yOliKdiRobMfZyBF8
         eqYNsUcaBVGqA==
Date:   Tue, 19 Jul 2022 13:22:34 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Message-ID: <20220719202234.sym2tqtsko5iond2@sx1>
References: <20220717213352.89838-1-saeed@kernel.org>
 <20220717213352.89838-4-saeed@kernel.org>
 <20220718202504.3d189f57@kernel.org>
 <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Jul 14:13, Gal Pressman wrote:
>On 19/07/2022 06:25, Jakub Kicinski wrote:
>> On Sun, 17 Jul 2022 14:33:41 -0700 Saeed Mahameed wrote:
>>> From: Gal Pressman <gal@nvidia.com>
>>>
>>> Add the rx_oversize_pkts_buffer counter to ethtool statistics.
>>> This counter exposes the number of dropped received packets due to
>>> length which arrived to RQ and exceed software buffer size allocated by
>>> the device for incoming traffic. It might imply that the device MTU is
>>> larger than the software buffers size.
>> Is it counted towards any of the existing stats as well? It needs
>> to end up in struct rtnl_link_stats64::rx_length_errors somehow.

it is already counted in ethtool->rx_wqe_err, but rx wqe err is more
general purpose and can include other errors too, the idea is to have a
better resolution for the error reason. 

>
>Probably makes sense to count it in rx_over_errors:
> *   The recommended interpretation for high speed interfaces is -
> *   number of packets dropped because they did not fit into buffers
> *   provided by the host, e.g. packets larger than MTU or next buffer
> *   in the ring was not available for a scatter transfer.
>
>It doesn't fit the rx_length_errors (802.3) as these packets are not
>dropped on the MAC.
>Will change.

I will drop this patch until we have a decision. but i tend to agree with
Gal.

