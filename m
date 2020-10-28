Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8195F29DFC6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404144AbgJ2BEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgJ1WGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:06:13 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAECC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:06:12 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a23so447821qkg.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=em1UkxWJ9idsvmwiA6+mB4JFVSjEKYk7JDBS5sWZCBI=;
        b=X0ExGhJdCJotNFfTMfAn07bnEVeDDjmYhvZvqC7ZMTm9OidOnhMm7F51BGUpR5P9i3
         PgP2W2VFBktjosddDfYnLUte4AS8BWPSj2Bxpc3E+B0gpOfnIwD+TJU5jQLJB4mNV76y
         c1J8UvajRCCqloS0+Fm3e5UFofYCOekCHa0aXCtbR+1GYrblD6wcsOln7XqGjaY2Yg7R
         zDszvL5Cev9TyT8aCqCWJQLy3VTdaEyyy/0pZHGzKmW+UE9+/12DsvxCZMUGyXB8DW/M
         cdBJfW3n/w/07LD8Y4WO06TYu0gghaksfK2rNoXX6GQhVrj3nVuhtKMzvTIFjTrEfRTX
         b4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=em1UkxWJ9idsvmwiA6+mB4JFVSjEKYk7JDBS5sWZCBI=;
        b=Z1KQJINM20kFRqEWTzpkUq4ZeT6lm4ZXxAloPArQRpcvzJuDhSzb/MZZvNAs5QpG+J
         V3yIiDypuNaMc3vCcYYZr/dXE6qNKMr1cGyLhQuVJZpAsB+bypBRsQu8xkECUFX/4p6j
         4ohd2WecH/KT90mbcnStgQhFSRMIotp8hvmep7iDIjXHPF1eDakp4Iyu2o5z6BkyOFVv
         ooUk6cqRXOZjTD2YlV5G+8/hoSJ3Uj/U/BM8N56NEpFYVtdhYPigBWYO9VGGvW7nh2V6
         atbL7kfTcbBmEmVqaDgTRqbedSn5SGCc6e/IUIXZqXu/cqJy9CXlhB06LPqUgqCzrb7S
         EQqw==
X-Gm-Message-State: AOAM532actzCXpjn+aAbrToTkp08gpFgEHcurF2JvqQmprugSy/zXLIv
        khcit955FUcJzYWnKBM2hkjCd8nqTeWwiCIZcfT+5jB3TwthJQ==
X-Google-Smtp-Source: ABdhPJxclALkeRBt+T6BJUCrQY+qoH56hU/EZig4e4UJcUDUjJFd4iXaycdnaORTw7pePK/4nY/hXNY8w3ybxcyNyag=
X-Received: by 2002:a02:a518:: with SMTP id e24mr636917jam.131.1603913352276;
 Wed, 28 Oct 2020 12:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
 <CAM_iQpWsUyxSni9+4Khuu28jvski+vfphjJSVgXJH+xS_NWsUQ@mail.gmail.com> <DB7PR05MB431592FDCD6EEB96C8DB0EE688170@DB7PR05MB4315.eurprd05.prod.outlook.com>
In-Reply-To: <DB7PR05MB431592FDCD6EEB96C8DB0EE688170@DB7PR05MB4315.eurprd05.prod.outlook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Oct 2020 12:29:01 -0700
Message-ID: <CAM_iQpXquceLTrbVER1mQGBWk3WFjDTAawNBVSj1a2R6OTp-9w@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Xin Long <lucien.xin@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:23 PM Tung Quang Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> Hi Cong,
>
> No, I have never ignored any comment from reviewers. I sent v2 on Oct 26 after discussing with Xin Long, and v3 on Oct 27 after receiving comment from Jakub.
> I received your 3 emails nearly at the same time on Oct 28. It's weird. Your emails did not appear in this email archive either: https://sourceforge.net/p/tipc/mailman/tipc-discussion/
>
> Anyway, I answer your questions:

Oh, I just realized you meant shinfo->dataref, not skb->users...
Then it makes sense now.

Thanks.
