Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ECF5345AB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 23:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344376AbiEYVNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 17:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiEYVNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 17:13:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8B635AA3
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 14:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 365CECE204C
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 21:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F78C385B8;
        Wed, 25 May 2022 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653513176;
        bh=r9fGapBd4Ok/ReqbY3MWa/fV+Pv4Ckd2gUm6qDYlaaE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dBMNCC1e767ul+6l7BEiWbflnZV3aW1iwLyDUi50WJQCfacBAsas0B1ySqJKmVJ1W
         oXmq5MRq6ZXtfJsiDrhy6Tx0dEiNnpMI/r/t55cEcwSmF1o93q3k10Aej1DylkoPus
         MuLUkmmuvYJtWfwEwlTSpyiUFXJUdzmiJSgXHhhNg+bnh1lHe7tOZHZ6qZLVc1yAsH
         HUqJ4Zc2TG6qKwf1CMV7XBmkgD7lbD4EKIdEgcR3zATw8MCCI+56fQ9ZsBLXZb5wVH
         eqGWCX3/7evqzwNiZBgy1IHf5KhTk406QwSxCf1C7S2otuJUnt+yRgoNJMoTMVuvkI
         kaRu1dL+2ltvg==
Message-ID: <df95ef08-4b8f-1b23-9a8e-ae9ad0538a9d@kernel.org>
Date:   Wed, 25 May 2022 15:12:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net] vrf: fix vrf driver unloading
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org
References: <20220525204628.297931-1-eyal.birger@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220525204628.297931-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/22 2:46 PM, Eyal Birger wrote:
> The commit referenced in the "Fixes" tag has removed the vrf driver
> cleanup function leading to a "Device or resource busy" error when
> trying to rmmod vrf.
> 
> Fix by re-introducing the cleanup function with the relevant changes.
> 
> Fixes: 9ab179d83b4e ("net: vrf: Fix dst reference counting")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> Note: the commit message in 9ab179d83b4e did not document it
> and it is not apparent to me why the ability to rmmod the driver is
> linked to that change, but maybe there's some hidden reason.

dst output handler references VRF functions. You can not remove the
module until all dst references have been dropped. Since there is no way
to know and the rmmod command can not just hang waiting for dst entries
to be dropped the module can not be unloaded. The same is true for IPv6
as module; it can not be removed and I believe for the same reason.

