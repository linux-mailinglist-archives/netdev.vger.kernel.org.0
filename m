Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2304D084C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiCGU1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbiCGU1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:27:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5945677AB4;
        Mon,  7 Mar 2022 12:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB3C4614E7;
        Mon,  7 Mar 2022 20:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048F3C340E9;
        Mon,  7 Mar 2022 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646684800;
        bh=9H9QFNhmCz2eZdBLhPXpPRaAobhsiAOUNLcdZ05EXyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxcvuleX57/nPXrO8ApcBRcOrlc+72MlMr/FMiYe5gNbsndl5B//ciZu5veeypNG3
         5rp1qOnneVT/dyjEoJ0pa9igqXY+4YDcp4BsUboM4EQwS4hLUgZZwUPQ/11BwQ/Xil
         cvzlYPhZdyOaoJPdLV8pOddCqV4R+kRmI3BuEvtyQv59xibmDsblrDvR/0QjKOk6cn
         9T7tXB0JtwFC4zSknkv7k32jDTjGM5EcMenDcBgCY8IYLCGHdrOYubflIlLgnGGcj4
         ARVkJYL87VvopJr2OdnE1vVirf1/kKYozqX3Nn4Z/0dErvbT7CihwMkQw5v4chhetH
         QdfRceysXtV+g==
Date:   Mon, 7 Mar 2022 12:26:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        patchwork-bot+netdevbpf@kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
        <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
        <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
        <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
        <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
        <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 10:49:31 +0200 Roi Dayan wrote:
> >> I think there is a missing userspace fix. didnt verify yet.
> >> but in ovs userspace odp-netlink.h created from datapath/linux/compat/include/linux/openvswitch.h
> >> and that file is not synced the change here.
> >> So the new enum OVS_KEY_ATTR_IPV6_EXTHDRS is missing and also struct
> >> ovs_key_ipv6_exthdrs which is needed in lib/udp-util.c
> >> in struct ovs_flow_key_attr_lens to add expected len for
> >> OVS_KEY_ATTR_IPV6_EXTHDR.  
> > 
> > I guess if this is creating backward compatibility issues, this
> > patch should be reverted/fixed. As a kmod upgrade should not break
> > existing deployments. 
> 
> it looks like it does. we can't work with ovs without reverting this.
> can we continue with reverting this commit please?

Sure, can someone ELI5 what the problem is?

What's "kmod upgrade" in this context a kernel upgrade or loading 
a newer module in older kernel? 

How can adding a new nl attr break user space? Does the user space
actually care about the OVS_KEY_ATTR_TUNNEL_INFO wart?
