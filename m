Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045714D8FE8
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245723AbiCNWz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiCNWzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC61113EAD;
        Mon, 14 Mar 2022 15:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6BBDB80E83;
        Mon, 14 Mar 2022 22:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCA0C340E9;
        Mon, 14 Mar 2022 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647298481;
        bh=NKyyDGoQqJeis8/QLo7gKyhbf8RrHnii74dSpqBoldo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Prn2BJhDfjCBNqcaTyLhkYrySAwFJhz9qEZozPch2QbN5Uae9EqqCztFm8Tw09Bt/
         DtqC96bswREOLv2OmYmBECA0nySiIwrK8KJDZs6VGntX6M4M3iXqdSRRFrC3V/J448
         pFOg/2jjDcLCx4D+NWIGwPZPZ+SwC67W5e5EGd6izY/Oq2NrW8gQucUlbzfL+cMa38
         /989DBrtVNlbR+Au9J1YK3zm6v7DnKxNdogIcmCTLenTJnpntn9gQKJtMQSxxRWIuC
         IkeCl+kqSatbOEsJfV1S3adDyxRuUFf9bG6UyTOfFU/A9LOaBtk3nSAGcOBgFPeNM0
         A05/JkN0XkCIg==
Date:   Mon, 14 Mar 2022 15:54:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20220314155440.33149b87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220312220315.64531-1-pablo@netfilter.org>
References: <20220312220315.64531-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 23:03:12 +0100 Pablo Neira Ayuso wrote:
> 1) Revert port remap to mitigate shadowing service ports, this is causing
>    problems in existing setups and this mitigation can be achieved with
>    explicit ruleset, eg.
> 
> 	... tcp sport < 16386 tcp dport >= 32768 masquerade random
> 
>   This patches provided a built-in policy similar to the one described above.
> 
> 2) Disable register tracking infrastructure in nf_tables. Florian reported
>    two issues:
> 
>    - Existing expressions with no implemented .reduce interface
>      that causes data-store on register should cancel the tracking.
>    - Register clobbering might be possible storing data on registers that
>      are larger than 32-bits.
> 
>    This might lead to generating incorrect ruleset bytecode. These two
>    issues are scheduled to be addressed in the next release cycle.

Minor nit for the future - it'd still be useful to have Fixes tags even
for reverts or current release fixes so that lowly backporters (myself
included) do not have to dig into history to double confirm patches
are not needed in the production kernels we maintain. Thanks!
