Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA938143D
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhENX3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENX3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:29:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C853C06174A;
        Fri, 14 May 2021 16:28:24 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id c20so952114ejm.3;
        Fri, 14 May 2021 16:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D622Tf1nJc9pvFg88LwUivJiCk+DCEynAgbLfcQvdbA=;
        b=GDYFjvB62k1wM+54h/TR/tteLvuS99XfOdezcWREJ0aeYt34C3zAjzEnrkl49h3o7x
         iwBqKB7AkY41CWY2QNz63p8xo9hVGFLsCyzttwcuGxpdWrvr2ntS4SkPuiRhn7eGqDEh
         uKQbQEgG62GX/XoaEYWmiw9DAa1KB5VZhqPVQx8Tv999pvB1d9ZXO8VAzNeDhLFf61Or
         IgoiwcVdQ+R1bkaPTndjgNg1RS7xaFW/AqnuTGfiy0QU7mmblNajJMJaQQ/7RMuUf6WX
         RLuCQBXievI1JAcoMJA4pZOpZzKUVg0sM2rbSQiNHUUoILoXb3Z+wRXR9uMzZESHBV9R
         P/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D622Tf1nJc9pvFg88LwUivJiCk+DCEynAgbLfcQvdbA=;
        b=odp4hVM5gfIAgRhSs9eTNpoTOUiiX6uGgW7evn8NKEQBKpw3ED9cG8Bpbk9AR8lrEq
         H4y0Z6KET26DcpJjSg5iB5jT1xHfCISTSlywofTi/ygQDI7RTywL1KooC7V+n7cu5NeC
         kVYXuuA9pN9NMJ9YxQwiDlOCMrazIWHh9jQ0e4qvIMXGWhMTfcJkGvWZKNVhpTh2g/eN
         DMYncczEzL4EXUCQ1sYperWwjlh7ghX0v7kRKoYxfQgd+bPNVcuRQ9UAe9QNml4EFGKj
         Vt6jPpea28VbP8wizBIiGR81bgWD8CeI3S8oU9rxjHA4b5juIBqG4wU+P6twssYFbV6P
         gioQ==
X-Gm-Message-State: AOAM531HfgVa4PyjuqqOxSeO7IPEArcSlAU8AZ6rbBBM+mw2RwHpLmU2
        cXoFOqqvn2molSMe2fj1Kluh0ZyhN595NTQhbfY=
X-Google-Smtp-Source: ABdhPJzTphr8Iiv6xscTNnomktOURvqkxCtK7h+DSuZ8WTiZGQ5gahOzezB0Hbo1Gye8tXn8FytcHRhAwV7mhX2Wt4M=
X-Received: by 2002:a17:906:3544:: with SMTP id s4mr51850573eja.73.1621034902581;
 Fri, 14 May 2021 16:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210514074248.780647-1-mudongliangabcd@gmail.com> <20210514123208.5792246d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514123208.5792246d@kicinski-fedora-PC1C0HJN>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Sat, 15 May 2021 07:27:44 +0800
Message-ID: <CAD-N9QViGiDWqijVvJ1sjdqNrye22EyMHwMDq3JNWaYWCveeOg@mail.gmail.com>
Subject: Re: [PATCH] NFC: nci: fix memory leak in nci_allocate_device
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Greg KH <gregkh@linuxfoundation.org>,
        bongsu.jeon@samsung.com, andrew@lunn.ch, wanghai38@huawei.com,
        zhengyongjun3@huawei.com, alexs@kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 3:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 14 May 2021 15:42:48 +0800 Dongliang Mu wrote:
> >  struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev);
> >                 void nci_hci_allocate(struct nci_dev *ndev);
>
> This patch does not build.

Sorry, it's my bad. This function should be nci_hci_deallocate. I will
send v2 now.
