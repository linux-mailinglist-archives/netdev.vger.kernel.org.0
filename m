Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD5667292
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjALMuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjALMts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:49:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0C03BB
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673527737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rno5HiyRqGhwFsXWgj2wBj/GKHwQLrsWjfu68P1ONBY=;
        b=GyywjqVH8IvJqTqlxBYPRXLPEEd0KKhh2w8k/SqbKd93XL8avk67SDqeM5TVZjcvFmnTdr
        OUvYjxPgSu6HnYU17sJH7q1AXBsQcUQeSBGiJ04YIgj9NUUbqhwP1DeX7DhoR6qnl5vp5b
        2v1WBHfqaHqJg0y+hkk6Efg5epQ+6nM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-bN3gA3YHOf-_E2mjcelE8Q-1; Thu, 12 Jan 2023 07:48:56 -0500
X-MC-Unique: bN3gA3YHOf-_E2mjcelE8Q-1
Received: by mail-qk1-f200.google.com with SMTP id i4-20020a05620a248400b006febc1651bbso12904598qkn.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:48:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rno5HiyRqGhwFsXWgj2wBj/GKHwQLrsWjfu68P1ONBY=;
        b=Wi5sKn0GwcJGzqZtzXwCSZLKnX16TOZi4hRi4NjIdBN8JRcfsZmVf2dFZY2JIt8jqH
         BEl0lqOjfud/M8RESI3Y9vYiXBbuHWyUC8/Q/EsKh+r01nrnmgmIP72aCOG0YkdsByFp
         wlzrOS5YHL+VdjwfxqzMoJxu9WfkuxD5bYVJ+bqmu76WrQQTFapiayLuCLS4so4L3T0H
         gLNl1uYu6Mw4uNKyG5rWDbFGIw5i7Jw08Aj97n2+9b+tTpOlMPsfa6Ze8NkbHCe/AwU2
         vHNQVvEsXa+GLFge5M2YLXhs1f37gqPPuRZq4eJ3ICkP11qs3gnUAgkCpPpmKz5siD4r
         p87g==
X-Gm-Message-State: AFqh2koVSy6ZpRQCrN6jk4HO5x7XYlXE6TlOTZjIeXT/v0LwcKsK/Ycv
        CRqkHeJib9Qp1WNSDL8buO0C84K0q6I2HxZw54Z/DChVMkmEefPNo0q2QSxNZ7gppwLV1fWOmYs
        0y4BwM3J3Hru28vzg
X-Received: by 2002:ac8:4a03:0:b0:3a8:47e:3683 with SMTP id x3-20020ac84a03000000b003a8047e3683mr14682284qtq.56.1673527735182;
        Thu, 12 Jan 2023 04:48:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuZS+6LYv70XNzuRBfKgSLfWrQlwLKIKlXW0YPfUujmfHY9koyjEYeg2PCxt45t5GG9QxZ0Cw==
X-Received: by 2002:ac8:4a03:0:b0:3a8:47e:3683 with SMTP id x3-20020ac84a03000000b003a8047e3683mr14682265qtq.56.1673527734914;
        Thu, 12 Jan 2023 04:48:54 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id e7-20020ac80647000000b003a69225c2cdsm9028818qth.56.2023.01.12.04.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 04:48:54 -0800 (PST)
Message-ID: <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Herv=E9?= Boisse <admin@netgeek.ovh>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 Jan 2023 13:48:51 +0100
In-Reply-To: <20230110191725.22675-2-admin@netgeek.ovh>
References: <20230110191725.22675-1-admin@netgeek.ovh>
         <20230110191725.22675-2-admin@netgeek.ovh>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2023-01-10 at 20:17 +0100, Hervé Boisse wrote:
> When an application sends a packet on a SOCK_RAW socket over a VLAN device,
> there is a possibility that the skb network header is incorrectly set.
> 
> The issue happens when the device used to send the packet is a VLAN device
> whose underlying device has no VLAN tx hardware offloading support.
> In that case, the VLAN driver reports a LL header size increased by 4 bytes
> to take into account the tag that will be added in software.
> 
> However, the socket user has no clue about that and still provides a normal
> LL header without tag.
> This results in the network header of the skb being shifted 4 bytes too far
> in the packet. This shift makes tc classifiers fail as they point to
> incorrect data.

I'm unsure I read correctly the use case: teh user-space application is
providing an L2 header and is expecting the Linux stack to add a vlan
tag? Or the linux application is sending packets on top of a vlan
device and desire no tag on the egress packet? or something else?

(Note: I think that in the fisrt 2 cases above the fix belong to the
user-space application).

Thanks!

Paolo

