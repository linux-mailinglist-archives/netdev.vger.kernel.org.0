Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768965635EB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiGAOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiGAOhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:37:55 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB61396BD;
        Fri,  1 Jul 2022 07:34:10 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 261EXTCu876807;
        Fri, 1 Jul 2022 16:33:29 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 261EXTCu876807
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1656686009;
        bh=66Ql3pAlEnCDWDBK1KpaLaZ5id556xQAtLfeDM/YJ94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIun5lHtXquqsIs+UbvVm13eUHAzHVhXUPGck47CMbaE5risqntEzYY3HeJwMxvTj
         7DGOFgvFCI5x3wSAL22s+JS3gl5ip/s8590PVe3OgiLpYl+8MlnJq95HcAv8cGkh4/
         s7d+uBbJRmesAUkOCppcLmJru8KByK/iAiTjhdr4=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 261EXS9v876806;
        Fri, 1 Jul 2022 16:33:28 +0200
Date:   Fri, 1 Jul 2022 16:33:28 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: fix potential memory leak in
 aq_ndev_close()
Message-ID: <Yr8FuKXVD83AW+u+@electric-eye.fr.zoreil.com>
References: <20220701065253.2183789-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701065253.2183789-1-niejianglei2021@163.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianglei Nie <niejianglei2021@163.com> :
> If aq_nic_stop() fails, aq_ndev_close() returns err without calling
> aq_nic_deinit() to release the relevant memory and resource, which
> will lead to a memory leak.
> 
> We can fix it by deleting the if condition judgment and goto statement to
> call aq_nic_deinit() directly after aq_nic_stop() to fix the memory leak.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Either (1) the hardware is stopped and the relevance of error returning
aq_nic_stop is dubious at best or (2) the hardware is not stopped and
it may not be safe to remove its kernel allocated resources behind its
back.

There is a problem but this patch is imho targeting the symptom.

A knowledgeable answer to (1), (2) could also help to avoid the
dev_{close/open} danse in drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c.

-- 
Ueimor
