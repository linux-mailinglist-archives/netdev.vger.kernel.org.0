Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19D618F3F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKDDqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiKDDqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:46:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6853764CC;
        Thu,  3 Nov 2022 20:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B82B829AB;
        Fri,  4 Nov 2022 03:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07118C433D6;
        Fri,  4 Nov 2022 03:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667533568;
        bh=unFOAaIvuSKk5EcL2SeLMgPObcCuVqYGJEEM9s25zEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YRFviAGrAIufv3iBzwyeyka/OkeI1Gudvv3QfIlK8CgzhLbu2NwAKk3fDq6Bz+OQM
         SdlfM11Bu4G+N/S4Hz3DBOobwBhHiraAmxZmWdJkxbqkM3DbwCPhuKliPDiUO+JJhq
         fcn1nrQ26nejSpjxVU0J/XD1BuazVFaUH0gtpqS6ZQoqKCfDrtVtnmehV5hdpowE91
         Rs48z9FRuwRKQn+2I/0OUydIqqNye/lfAfH53FxSuzRO3AkUMpC/G1Xzu0rygjqvSe
         VaFkhy6VvMm6yYCxcp18hliXE7mhlEuNf3HTH8Ijn1bm1ttAp5UovQIR8xBC9jHBJe
         bPYP+KmqnaLQA==
Date:   Thu, 3 Nov 2022 20:46:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Adrien Thierry <athierry@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/net: give more time to udpgro bg processes to
 complete startup
Message-ID: <20221103204607.520b36ac@kernel.org>
In-Reply-To: <20221101184809.50013-1-athierry@redhat.com>
References: <20221101184809.50013-1-athierry@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Nov 2022 14:48:08 -0400 Adrien Thierry wrote:
> In some conditions, background processes in udpgro don't have enough
> time to set up the sockets. When foreground processes start, this
> results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
> refused". For instance, this happens from time to time on a Qualcomm
> SA8540P SoC running CentOS Stream 9.
> 
> To fix this, increase the time given to background processes to
> complete the startup before foreground processes start.
> 
> Signed-off-by: Adrien Thierry <athierry@redhat.com>
> ---
> This is a continuation of the hack that's present in those tests. Other
> ideas are welcome to fix this in a more permanent way.

Perhaps we can add an option to the Rx side to daemonize itself after
setting up the socket, that way the bash script will be locked until 
Rx is ready?
