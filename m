Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D806ED3D5
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjDXRoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjDXRoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:44:14 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AAFE9
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:44:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b70ca0a84so6049326b3a.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682358251; x=1684950251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vswGMM6ZDsdPrviduxVDG8qzKegOjrZxPEQB+Kdd6+U=;
        b=ims1uG25XZGZAqD/xwsZ4xKS8FfKHYD0TqKnyIACtKZ1lxQ6WYYaPoD6/cBpFbwD0y
         4rmL2Vnr0kmM6equImpW7/p1dZE8wKi/LVhEeQJYKh7EIznDhCDTTtaesSQ2DNdgK/kq
         aGI+Jhq56acHVacAGDQmyVtNhwi2q8TJsWp2WKfp3eIKT0+DWmKN4yrLuAeQjfDWPYgT
         odpUuSrOhAaN+8SdiLHY6ZSHozc+bRIvvC4ll62gJcn7TI1g9CQndyUvtRHr989U7Cim
         9Dh4jsd1uC68m6lw9JrAjjkxDD7H7ujj70fr2o8OjOwuhqM/mlEvcH76/OwCgbRyPvH2
         lWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682358251; x=1684950251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vswGMM6ZDsdPrviduxVDG8qzKegOjrZxPEQB+Kdd6+U=;
        b=lu6POuCGKLF5T7e21M2aoWCVcgUHaqOx1GG3uiPs7w6kkk21VYOwkGlcNnsVO0PgE9
         2xUoVQu57WsNuZadgaBDpA/6+/hy/ZpDtp6EuiYFBrBpqSU+PlwyHQBUJpzFmc2Clhq0
         S5hiujat3NclLr8hXKq0hggGKmYHsdJcfCdKDc0T5JVxwZ3+b+yomfRVcHizHN/IcqJt
         RH9JlPwJp5ywfEQonKTywWv3jZ74rpgsl5OfkFwPcQGWj5iZQfzfMDU5NWcVVholthzW
         DC8teyU21rkP2BIWBtD+t/YUlFCO6als494xPA0XF30bJBrILpYVYB1cVEOoTzbkUSU+
         Oeow==
X-Gm-Message-State: AAQBX9fcLxs07SV9b455+HHzykVX/nCfpdgdxHpHluwGvyW4PAuHn9sx
        xrMrOVReWzdkPRo4CBI0mqoH5Q==
X-Google-Smtp-Source: AKy350aAgnIoCAdXW8Xdv6qTtW+qB3fL07OcHJHN2R8zHHM7FiHpA5TrgSTV2OGw5fjvO6Eu+rYPYg==
X-Received: by 2002:a05:6a21:6d89:b0:f2:fd1e:efc9 with SMTP id wl9-20020a056a216d8900b000f2fd1eefc9mr11112902pzb.5.1682358251001;
        Mon, 24 Apr 2023 10:44:11 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 136-20020a63008e000000b0051806da5cd6sm6705302pga.60.2023.04.24.10.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:44:10 -0700 (PDT)
Date:   Mon, 24 Apr 2023 10:44:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kernel@mojatatu.com
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
Message-ID: <20230424104408.63ba1159@hermes.local>
In-Reply-To: <20230424173602.GA27649@unreal>
References: <20230424170832.549298-1-victor@mojatatu.com>
        <20230424173602.GA27649@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 20:36:02 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> > There are cases where the device is adminstratively UP, but operationally 
> > down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
> > who's cable was pulled out, here is its ip link output:
> > 
> > 5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
> >     link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
> >     altname enp179s0f1np1
> > 
> > As you can see, it's administratively UP but operationally down.
> > In this case, sending a packet to this port caused a nasty kernel hang (so
> > nasty that we were unable to capture it). Aborting a transmit based on
> > operational status (in addition to administrative status) fixes the issue.
> > 

Then fix the driver. It shouldn't hang.
Other drivers just drop packets if link is down.
