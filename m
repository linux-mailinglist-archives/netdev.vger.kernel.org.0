Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9DD54D8A0
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240894AbiFPCuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFPCuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:50:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B6157B21;
        Wed, 15 Jun 2022 19:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93257612A0;
        Thu, 16 Jun 2022 02:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AF6C3411A;
        Thu, 16 Jun 2022 02:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655347852;
        bh=Wr/3th+k8NUJhza5MLu2fT8FjL/q3kYO2ECCExYM1ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OsbNIRhynU56uid/iiYCHDdgucR2CA8sYFj7fErVGfAG/IhL30cKlpfCR1T4V7Hgv
         caKKrZ6QU/ML01n5Thz25Qbv2olH7htW41OOXxeX9vWtmiAEiWppNoxBLcvMGNazsH
         RfjHDbSUWI7Sjbw5grC5CwqPVgFtQkrLRYNK+VHFl6t25IidHGRD4bbrk3Mm5++t7X
         HfHmLyb5CPiuPtatGFLvAQcduY2MBapUq0X7jtTg98Z6drYw54DEVZs9LglRcYccwq
         awweRc7CialJmZTJx2nWv9YoRtlzc21rnG25xwx1jAK8DhExIWdfjSIWEmpV+kdFyc
         MgWDpQoM6n5Mg==
Date:   Wed, 15 Jun 2022 19:50:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wentao_Liang <Wentao_Liang_g@163.com>, jdmason@kudzu.us
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH net v2]vexy: Fix a use-after-free bug in
 vxge-main.c
Message-ID: <20220615195050.6e4785ef@kernel.org>
In-Reply-To: <20220615013816.6593-1-Wentao_Liang_g@163.com>
References: <20220615013816.6593-1-Wentao_Liang_g@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jon, if you're there, do you have any sense on whether this HW is still
in production somewhere? I scrolled thru last 5 years of the git history
and there doesn't seem to be any meaningful change here while there's a
significant volume of refactoring going in. 


On the patch itself:

On Wed, 15 Jun 2022 09:38:16 +0800 Wentao_Liang wrote:
> Subject: [PATCH] [PATCH net v2]vexy: Fix a use-after-free bug in vxge-main.c

No need to repeat "[PATCH]"
The driver is not called "vexy" as far as I can tell.

> The pointer vdev points to a memory region adjacent to a net_device
> structure ndev, which is a field of hldev. At line 4740, the invocation
> to vxge_device_unregister unregisters device hldev, and it also releases
> the memory region pointed by vdev->bar0. At line 4743, the freed memory
> region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
> use-after-free vulnerability. We can fix the bug by calling iounmap
> before vxge_device_unregister.

Are you sure the bar0 is not needed by the netdev? You're freeing
memory that the netdev may need until it's unregistered.
