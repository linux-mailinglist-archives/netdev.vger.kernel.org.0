Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B6231D217
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhBPV31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhBPV3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:29:23 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEEC06174A;
        Tue, 16 Feb 2021 13:28:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id n8so15021283wrm.10;
        Tue, 16 Feb 2021 13:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQfv48BtkQswJTPi2IAE9RUI+B8YEi5kqxn6TmhUbkQ=;
        b=BYrQhQfUrTCfPrNF1lqEFF3bDx3yUU1ZARyaZjgXaA+cNRK2n/KXtehMQ1niDGMceG
         jP24BtUrxEXfMLsKD8YmtdGGpHrB0+mHSPs3EmwT5VPcpy35y01wD7ec+SRt4w5j9FNX
         nR6oQ5UUsAWQK3nrDScy4BBipzCCdtodo/TgmUjAcgT4mVtfucJIgQJGJRoXc6+zFJhW
         ZG4BdkINVISs91y0inhpfR05hjC8xXMxIhw7dHrS+BDypt+4WcHWVzX7XDnZnKMfs592
         HO+N6hlHlGv73t7ZN+JPcRLwAbs/ngEzfk/tq8TYCuDTCm4Tx7E7aAMr1senyTYKVVh2
         T+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQfv48BtkQswJTPi2IAE9RUI+B8YEi5kqxn6TmhUbkQ=;
        b=o0dgsa650DkR9kesp4gmx1TH/skkjmqgx9sginPhLak+0cnftDExVjpryjaYcbv1tb
         v/4d4WToAYKfxC0wIOIcxNeUOhUfDzToocY1HRt1/l/wVwcBCwUCaKfh+YmdXU4tz5J0
         09OgB7zSgXZ2wpuO/Pmk12rfnqB26gKBNVpCOFgNP3oPZ2W6E2SrhTWsn6gF+m1gJH8K
         9GRqjmBZ7czYMMMRqh1ThB13MGhRufu/Xofqp9stxxJr5OSDdClpEUuWT3EyDjPyUD2v
         M07sTV1Xc5F+xg9Ms7D+s2BwBz91W1WxqdxrOxt5bTgsK421ZpKJO4uL7gssHxEpslHI
         qBdQ==
X-Gm-Message-State: AOAM5325TtMMVZSFij78Kja7aYIhjHluCwvr+xqV8v40FM6z6ClkcIpN
        ZCI1qDhusjVD4HJLCXhLXqEBg859WT7Yf6Alfio=
X-Google-Smtp-Source: ABdhPJxzyXIqbz/RLd8uv8M2y5uFe7/Ekao122IZNP763DSBVl5U7sWAWH8+a0EOsFPr8HmFchtdu+eEMIFhoi9WLeo=
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr14806672wrx.166.1613510921952;
 Tue, 16 Feb 2021 13:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20210216010806.31948-1-TheSven73@gmail.com> <20210216010806.31948-3-TheSven73@gmail.com>
 <BN8PR11MB36518045F806DAAC37BBD659FA879@BN8PR11MB3651.namprd11.prod.outlook.com>
In-Reply-To: <BN8PR11MB36518045F806DAAC37BBD659FA879@BN8PR11MB3651.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 16 Feb 2021 16:28:31 -0500
Message-ID: <CAGngYiXx3PdVtLXgWcWTXF-rakO_azWNSc6yK8PNKinnFV7+8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] lan743x: sync only the received area of
 an rx ring buffer
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bryan,

On Tue, Feb 16, 2021 at 3:50 PM <Bryan.Whitehead@microchip.com> wrote:
>
> Looks Good, Thanks Sven
> Our testing is in progress, We will let you know our results soon.
>
> Reviewed-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
>

Thank you Bryan, I really appreciate your help and expertise.
