Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9554DA8ED
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353466AbiCPDbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbiCPDbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D453981F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 20:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322D8615C7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7B7C340E8;
        Wed, 16 Mar 2022 03:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401432;
        bh=g/suDQEkTVLd1RuCDFcttc+F7i4J1GQXNKeOlXkKzuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFCgvdtt714tWNua5kaodBORtvJ3z+aBKOj4Psnx9YO6KIIE2BxpqOU9z+R2RPJRl
         /cp/byP3uzBpZ0YVebaGjTWRvP5Hr76a24uulfou5rzqrQv0INY241N+/Vr8Rjgvrp
         Wu4dPuYmopNxPeYCJ1+8ZEfIxtRyu/0rA3dXl8wFBOZJ/sBVUg48lfg1gQ0Ys8Esgd
         RCEOfAQEHmLUZXRCBYAo8atgVcVWrRRAdY0aAChudie+Woc/ET5rLLt9nS9b6SqKVk
         FhGMXMQYAwaiBjoRfT4NjzXe+twABJ0qfP+GnYWMi/nGE/9Zloo7dQT1dguwJWsGT7
         dYFoxDQK51aZA==
Date:   Tue, 15 Mar 2022 20:30:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 3/3] iavf: Fix double free in iavf_reset_task
Message-ID: <20220315203031.444de6d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315211225.2923496-4-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
        <20220315211225.2923496-4-anthony.l.nguyen@intel.com>
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

On Tue, 15 Mar 2022 14:12:25 -0700 Tony Nguyen wrote:
> Fix double free possibility in iavf_disable_vf, as crit_lock is
> freed in caller, iavf_reset_task. Add kernel-doc for iavf_disable_vf.
> Remove mutex_unlock in iavf_disable_vf.
> Without this patch there is double free scenario, when calling
> iavf_reset_task.

s/free/unlock/ or s/free/release/
