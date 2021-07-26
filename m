Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7303D5979
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhGZLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 07:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhGZLrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 07:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A6F360F56
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627302462;
        bh=+L5MKqGmGDmm48Srf75gv7j5aXz9fPzSpZNsmRbTaNs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kl6z/zxpZ7Ibb3vwlccYvdnkFQvzLqNyvLRurETB2y5VTYkGqShBLasCfndowqkj1
         4SAyt1ZhjbnU0U/rQ39CddU8AHURPN4Piv710Fk3FqRCiJ1RiLk1I+auMjsTWCctbS
         0bdPdyP1ZDIQALhGsVGG+rWdbpPcalbMxOYivgJIR7jiuzlPbteJtzamXj8xRyofqL
         QvnopCHbmy92HkaKx+s7pnAqsYQORQhWjwTfYseu3Y16Pd3EfV4a9Ri8P14BMyc4bQ
         dh6IwerV7cp6eNk5x8SPj9fcgWVEBZZnDlrLKlkfjkYTTPOI99GIX3dUCW1HPaMNxt
         gJ7rkrcBlRuMw==
Received: by mail-wm1-f43.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2017823wmd.3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 05:27:42 -0700 (PDT)
X-Gm-Message-State: AOAM5320cF+B/fvqes9yY7TkjnfXPe28bbl5rersKwpr6QeR1DLJPcNa
        YQN+f1SI6NdbktjJfA3cPW1B0moRV7eSNtVYHNg=
X-Google-Smtp-Source: ABdhPJxFoU8+H3HyGCjGiIF2pwUNLIVqfFMEO8wkuWwiZYqEh7pyquvFuQUkHpPgxgaVT8rngzP+kTkufWqgWIJ13Ok=
X-Received: by 2002:a7b:c385:: with SMTP id s5mr16446971wmj.43.1627302461095;
 Mon, 26 Jul 2021 05:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210726084540.3282344-1-arnd@kernel.org> <202107261848.FV7RhndS-lkp@intel.com>
In-Reply-To: <202107261848.FV7RhndS-lkp@intel.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 26 Jul 2021 14:27:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a05D_P20Jjt5cf-0V2=dY_HvVRWJTBtpf_txc1e7b-POw@mail.gmail.com>
Message-ID: <CAK8P3a05D_P20Jjt5cf-0V2=dY_HvVRWJTBtpf_txc1e7b-POw@mail.gmail.com>
Subject: Re: [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     kernel test robot <lkp@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        kbuild-all@lists.01.org, Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 12:29 PM kernel test robot <lkp@intel.com> wrote:

> >> drivers/i2c/Kconfig:8:error: recursive dependency detected!
>    drivers/i2c/Kconfig:8: symbol I2C is selected by IGB
>    drivers/net/ethernet/intel/Kconfig:87: symbol IGB depends on PTP_1588_CLOCK
>    drivers/ptp/Kconfig:8: symbol PTP_1588_CLOCK is implied by MLX4_EN
>    drivers/net/ethernet/mellanox/mlx4/Kconfig:6: symbol MLX4_EN depends on NET_VENDOR_MELLANOX
>    drivers/net/ethernet/mellanox/Kconfig:6: symbol NET_VENDOR_MELLANOX depends on I2C
>    For a resolution refer to Documentation/kbuild/kconfig-language.rst
>    subsection "Kconfig recursive dependency limitations"

Sorry about this, the patch I was testing with has this additional hunk

@@ -88,7 +88,7 @@ config IGB
        tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
        depends on PCI
        depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
-       select I2C
+       depends on I2C
        select I2C_ALGOBIT
        help
          This driver supports Intel(R) 82575/82576 gigabit ethernet family of

that I even describe in the changelog but forgot to include in the patch I sent.

        Arnd
