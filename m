Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD83621DC
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 16:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhDPOLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 10:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235553AbhDPOLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 10:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3E8E611C2;
        Fri, 16 Apr 2021 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618582242;
        bh=1s9sCrJo44Veolfwl+MwQWl66gowBJVDh4jCcMWmw20=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bWtljR/0v+ciclhWmYZDIUGhhvFJ3qQ7nO0uU82MghhOsGFdSMyacApx9Rv+nHL6X
         W5cY5QnPwP6g7dxd13lON+NP7T3wxEgswnDncwfQXbUpDa1noe9/ic1qeaxTeqr1An
         xJUGxVeiTwbDQol4BcT+uJeJ/K8GtjgPzMatA+QGLBn8/pwaCrhafWYek6SKXGeGJX
         JrnAkRBsacpGTrsZXVT6wqIi5rnqa1PtXSpagwrGhkYyDEvybabUi7RBZVXZcudA+H
         4dZgdBI6yZkxxw1SMBUj5RKBCe9Uqk2xt0sX7dm9fywiRJ0wfW8Bx5Y3FStVzaPeVS
         VyQ7HbK3kn2jA==
Received: by mail-wm1-f46.google.com with SMTP id n10-20020a05600c4f8ab0290130f0d3cba3so2452761wmq.1;
        Fri, 16 Apr 2021 07:10:42 -0700 (PDT)
X-Gm-Message-State: AOAM5311rO2I/o6Ind6RThkqpjvCAbINqe/V2ca2Zxn0e895bpA76IE+
        pQhj8cZzVF3wdYjF0bFkNNhn6QVSWsiGrmNBMrQ=
X-Google-Smtp-Source: ABdhPJwer78kcpt2KUTk7pLNWv4YpxxYqG4ncdMLFchwkUndSOMZjtA8z9tZUxzlPor4R9hASXWQZTamma1KWyeXMwk=
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr8250595wmi.75.1618582241293;
 Fri, 16 Apr 2021 07:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210409185105.188284-3-willy@infradead.org> <202104100656.N7EVvkNZ-lkp@intel.com>
 <20210410024313.GX2531743@casper.infradead.org> <20210410082158.79ad09a6@carbon>
 <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com> <ab9f1a6c-4099-2b59-457d-fcc45d2396f4@ti.com>
In-Reply-To: <ab9f1a6c-4099-2b59-457d-fcc45d2396f4@ti.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 16 Apr 2021 16:10:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1+Dpu3ef+VYA+owTVGoGqfK6APbYbLSH1_ZKT0aMYQCw@mail.gmail.com>
Message-ID: <CAK8P3a1+Dpu3ef+VYA+owTVGoGqfK6APbYbLSH1_ZKT0aMYQCw@mail.gmail.com>
Subject: Re: Bogus struct page layout on 32-bit
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 11:27 AM 'Grygorii Strashko' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
> On 10/04/2021 11:52, Ilias Apalodimas wrote:
> > +CC Grygorii for the cpsw part as Ivan's email is not valid anymore
> The TI platforms am3/4/5 (cpsw) and Keystone 2 (netcp) can do only 32bit DMA even in case of LPAE (dma-ranges are used).
> Originally, as I remember, CONFIG_ARCH_DMA_ADDR_T_64BIT has not been selected for the LPAE case
> on TI platforms and the fact that it became set is the result of multi-paltform/allXXXconfig/DMA
> optimizations and unification.
> (just checked - not set in 4.14)
>
> Probable commit 4965a68780c5 ("arch: define the ARCH_DMA_ADDR_T_64BIT config symbol in lib/Kconfig").

I completely missed this change in the past, and I don't really agree
with it either.

Most 32-bit Arm platforms are in fact limited to 32-bit DMA, even when they have
MMIO or RAM areas above the 4GB boundary that require LPAE.

> The TI drivers have been updated, finally to accept ARCH_DMA_ADDR_T_64BIT=y by using
> things like (__force u32) for example.
>
> Honestly, I've done sanity check of CPSW with LPAE=y (ARCH_DMA_ADDR_T_64BIT=y) very long time ago.

This is of course a good idea, drivers should work with any
combination of 32-bit
or 64-bit phys_addr_t and dma_addr_t.

        Arnd
