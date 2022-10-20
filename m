Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599E3605BC7
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJTKCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJTKCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33177270C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666260117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7IUYOhzeuyc+CvCyFdQqPRa5begr27mKnMbe0QZvpVo=;
        b=JTHh6TwfXFIZNrYCXrPLZY2GZkxny7EWbUb2Hr6ApbL6ABQ+N3qTObcM0o67rMMzDNXTqJ
        7T8QatgGM2msf1o9hX8MxW7V5FbjpvNC3MQtE7tibJErkl7b3KHAQqnK8lN3KvdDU0H0MD
        uGhbGL1m/BZgRo7Oh7rr9xBRTZmuHK0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-467-Wd1pT2b1O76djFQS0UrlEw-1; Thu, 20 Oct 2022 06:01:56 -0400
X-MC-Unique: Wd1pT2b1O76djFQS0UrlEw-1
Received: by mail-qk1-f198.google.com with SMTP id h9-20020a05620a244900b006ee944ec451so16952584qkn.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7IUYOhzeuyc+CvCyFdQqPRa5begr27mKnMbe0QZvpVo=;
        b=R7QtV2GtQ+JSt+c44XpFYv6uGw4lWo6J2t0bWv3+9+UM7s/78p4o3jzq3Dk1+DiLKC
         xBB08xL68EfRqEc2WtQSSGqbLSldv9zgGE40NuQcedpA7nxJVQp9eXv5qY0gwFUsDTTa
         1qjCXQUekSwsGKmPFogxNe5KF8Nsq+Di/CaW7hvrjQNBorcU6cD2qI2QylWUx35kZvaT
         yQztuLC5N9BVxBPRlIIE0ecjuAz+dJAjjnwI5alELglEa6h1DHP8g1woVkHZAKc6s10I
         qnVjaErAtRCWAlrz2OKbVGGTrKDiG7SuqVNekuyWWHeZbxpNAHEEdOFvCgXi5hpiLdIF
         VO+w==
X-Gm-Message-State: ACrzQf0o6fy+piyeTv3Z96pnfuDPB4wQQIMbMrtNVPxOqgGR+LNajUDk
        9iO2aUxkSsTV7vCztmsWlYs0oOIqfTpSP5VQSTd24q95ccphXmEuDIt4Fbnnl7fPEJn32yFkuUO
        hf9jq9+drxG4rHghM
X-Received: by 2002:a05:620a:29cd:b0:6d2:c5d6:6fe0 with SMTP id s13-20020a05620a29cd00b006d2c5d66fe0mr8902973qkp.148.1666260115370;
        Thu, 20 Oct 2022 03:01:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6u4Cw0xdMvHD/bD0LbBi+bLRWROc3JkUovuWyzZU6Flh9tkWJAa4r1LzWLL2+KnDGykxlfsQ==
X-Received: by 2002:a05:620a:29cd:b0:6d2:c5d6:6fe0 with SMTP id s13-20020a05620a29cd00b006d2c5d66fe0mr8902958qkp.148.1666260115163;
        Thu, 20 Oct 2022 03:01:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id az13-20020a05620a170d00b006eea461177csm7177053qkb.29.2022.10.20.03.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 03:01:54 -0700 (PDT)
Message-ID: <5cf6d7cbb2824f03fcfee2f60e21c4eddf732320.camel@redhat.com>
Subject: Re: [net 02/16] net/mlx5: Wait for firmware to enable CRS before
 pci_restore_state
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Date:   Thu, 20 Oct 2022 12:01:51 +0200
In-Reply-To: <20221019063813.802772-3-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
         <20221019063813.802772-3-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-10-18 at 23:37 -0700, Saeed Mahameed wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> After firmware reset driver should verify firmware already enabled CRS
> and became responsive to pci config cycles before restoring pci state.
> Fix that by waiting till device_id is readable through PCI again.
> 
> Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

@Saeed: in the PR, this commit is missing your SoB:

https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=mlx5-fixes-2022-10-14&id=e63eae9bf56d005a79ee5f8aca0aea757e208598

Could you update the PR?

Thanks!

Paolo

