Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB9CF265
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbfJHGFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:05:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39972 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbfJHGFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:05:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id d26so9671249pgl.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 23:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vBrl4vq49FCgbqgw2HnU3OTXMLhWTiLxjEoStuUa6mc=;
        b=lYIVKldkL0OaGIeWmgzRz7Ti/mjoVou2PkyOFpMa68EuAGAR0/G1r2jm+mTKRUZIaA
         UiaAAKFv+S/ezToYc4Ufm/Zv9juDAq16/3ALhJlBBwJAxBg9RzHb1O4TyZpSwiu9mJZs
         E/8dKH/+tujCTHb2CUqtsic0hDl9H0sFjYWvpuo4pJ9ezHYGzn67bontAQaj8OvEBZ3f
         u33zpjbuNUXsgqTD9IgyBOzdyPVsZ+MdvM6xRzLs5gRw229YPZBQIwijBZwMDppw7RTQ
         9JhLaODHtZu/uZXECS3QnJMKWyEvQcCHjijv8BVEjlD7ZvNMhYOK3LU8AAua7mPKKzed
         0hEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vBrl4vq49FCgbqgw2HnU3OTXMLhWTiLxjEoStuUa6mc=;
        b=Bl0DbokrEZ66QCl48BPC2+GZP0Lc6W9EUhRnAPgLmaunzofpUY9yxfr05wJS/IhWOo
         VZcwSdmmuyLFb0GrCLzCxUusX803HBbY+0KCUokF+zFBb5gPcmN6kRP0MtSjQVnmORtd
         p8fxEljC3vHbQ5jQV1QZoCkdvrCcthrf8CmKIOG8zAa0yJbwry8+pgMKDUsUonGIBEJc
         99JQ9oAaT5MC5DZOkOOuroUm19twBkXcmB/LmjaSoUoko4w6NCFt+7qP2Yrpz31m/Xyr
         1kjwBZPUOWT59n6dbBH6l2pfFAbJCGNGz04+dlMmDyeBf7fPPDLfQT2pcgTGWuGJjZmQ
         5KDA==
X-Gm-Message-State: APjAAAVZW/TLbgWrdoTaTx3Vom/igeNN1J8cQxq/vckWIxZ8A8mtGat0
        5zU34OKPeEV+PGGSxZXN2yLpQsBafB3/nYwz7Eg=
X-Google-Smtp-Source: APXvYqxnNB6CK8fEPIryZQ370U+COLHBbB2uPQ6WpswQBUhlM8PJ58ozkbkHvPkxutAidjWlW0Iyj4cu3+gyK9pDfFQ=
X-Received: by 2002:a62:7912:: with SMTP id u18mr2518688pfc.242.1570514753674;
 Mon, 07 Oct 2019 23:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com>
In-Reply-To: <20191008053507.252202-1-zenczykowski@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 7 Oct 2019 23:05:42 -0700
Message-ID: <CAM_iQpVqSg=kdR5TaXKyJmVaPATPrPv+v_H0ifjKB6U7e4zOHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] netfilter: fix a memory leak in nf_conntrack_in
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 10:35 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>

Please, at least a simple copy-n-paste of kmemleak report will
help a lot here. A changelog would save your time and mine too.

Thanks.
