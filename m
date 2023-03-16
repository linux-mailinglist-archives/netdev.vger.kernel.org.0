Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647A46BDA35
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCPUeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCPUe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:34:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CA1664FF;
        Thu, 16 Mar 2023 13:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 660AFB82347;
        Thu, 16 Mar 2023 20:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51BCC433EF;
        Thu, 16 Mar 2023 20:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678998847;
        bh=3HDGUZpqzbEBwq+2GtcDBA71Xism/0YDULlYa+8Vpbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bzC5bIoe4kaqeRVqwT/kgoQFguSjxpeDwiWvJtssU1XJUH88YNeCZqBNemsonbtmU
         JwDM8hagKEVO+OM2jzf+BX1HtaR9QXgUqvVpo5sW493EEBb3Fzu2aV2VPlC/9nW7G9
         7CQPtOf+H6eVUL/NkhAhj8xSu5YJn1icaISgo0gq47p55TKK0Lhl0tswX7qHLQfl1I
         r9selD/kBvWbik6u3zeOsJ9q8Ij6/UXq20702ymy7ke8nMQW81G7Naw/NB9J369cRd
         v+Kpt2gFzRtVRCNI7QfoHstCvWUDijwNjH8wqaMlwxDB4+XEbyWolYSWiAyShxacsL
         2B4sULX/iN8Sg==
Date:   Thu, 16 Mar 2023 13:34:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Message-ID: <20230316133405.0ffbea6a@kernel.org>
In-Reply-To: <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
        <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
        <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
        <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
        <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
        <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
        <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
        <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
        <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
        <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
        <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
        <20230315211329.1c7b3566@kernel.org>
        <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 05:21:42 +0000 Ronak Doshi wrote:
> Below are some sample test numbers collected by our perf team. 
>                           Test                                    socket & msg size                          base               using only gro
> 1VM    14vcpu UDP stream receive        256K 256 bytes (packets/sec)    217.01 Kps    187.98 Kps         -13.37%
> 16VM  2vcpu   TCP stream send Thpt     8K     256 bytes (Gbps)                18.00 Gbps    17.02 Gbps         -5.44%
> 1VM    14vcpu ResponseTimeMean Receive (in micro secs)                      163 us             170 us                -4.29%

A bit more than I suspected, thanks for the data.
