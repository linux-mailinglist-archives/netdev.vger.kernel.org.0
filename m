Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5C368CC92
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 03:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBGCdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 21:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBGCdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 21:33:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E4411E89;
        Mon,  6 Feb 2023 18:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00A360C8E;
        Tue,  7 Feb 2023 02:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912F9C433EF;
        Tue,  7 Feb 2023 02:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675737185;
        bh=lfcZBFn2TbIl3b1FVnqxOh4EPYPlCWTfGmws1y2kKP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z01qupXcA30HyhEE/r5efrMsuD1Q/6+cS5YdMIbWllM1MxI3Sal8nugJI/2zFUFDq
         2Jl55UsJG/CyG+jdT2kdekI3LaXOLOeAIFomrKOofLz0pKL0oeCUbD4x/htGskqO6n
         NoFKzlukEeFat9gVzj1qlwvHmf1BAMi43CiOn48yQ3URmWOKdR+/VdXSPJRkDxcGhu
         +eHv1CYyEW7YMiHP3QDXi/DdJqIifCaLb75fCykvU8OOUOMZtrol87O/f2WRZ3DZFF
         ciqQVKdsfrBHYTrYXC/ozFc0Fqlv+r9ZO/dxHboc4yK3lGKGzxpfpb6mM3Qk5ggsEk
         VO8dlDv+EAlqA==
Date:   Mon, 6 Feb 2023 18:33:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
Message-ID: <20230206183303.35fd1cf7@kernel.org>
In-Reply-To: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
References: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
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

On Mon,  6 Feb 2023 13:28:49 -0800 Haiyang Zhang wrote:
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> persistent. Otherwise, we are accessing freed memory when reading
> the affinity_hint file.
> 
> Also, need to clear affinity_hint before free_irq(), otherwise there
> is a one-time warning and stack trace during module unloading:

What's the difference from the previous posting? Did you just resend it?
