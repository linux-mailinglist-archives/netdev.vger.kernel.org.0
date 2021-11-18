Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B37456067
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhKRQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:32968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhKRQaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:30:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FE961B3A;
        Thu, 18 Nov 2021 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637252839;
        bh=BKVKyK0RlVmHW5sfIELd2vWo+bvbaMsuAw2qnj28Ue0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ze+6hgboZl91trBQhNlBH077hrKXNgtwB6YfrpkbRCYgLPgZJ7ozp+hHd56FHqXjJ
         pm4H82eHZSfXbeGJkCzsQatDC5i2IbgjF1Kv1Xj6Bb1X+C9LdQwbVD9JsVnb3K0o/k
         71CsuygyZTMzp6QhFIvN/YfCmb+QlGQ41aqPEv4C5+MeD0eJMVNfcpXytDtATCKzyd
         flpSNnQGQsD3sHvPJocK2isgUWy1BzN1T9RbzoFHctJPglHk3O4JVVv/ifxkZGeRjc
         ZXpVA/fBP/noYRsX6F25J4zLeb+pFXxdro0ZXgIhfO4cNiB9WCvzb4mFyFJbJWCzdp
         GRNLUoYQ1W0qA==
Received: by mail-wr1-f43.google.com with SMTP id d27so12660395wrb.6;
        Thu, 18 Nov 2021 08:27:18 -0800 (PST)
X-Gm-Message-State: AOAM531u3xzm912I+65umjNtDeMTYjOQch0PQNpmfcdHNWF/sxYYDtS7
        8ojW6Z4E36pxoBtNDGr/WW9RZ6Kfke75UYRkBmc=
X-Google-Smtp-Source: ABdhPJxqq79QoLh4sUptBU5OL4FavBN2lAtrn/gnM+dcbHtabFve0M/Wdkl43chENdBC2FQ4OXkwCdIHmrQ8McCzDtc=
X-Received: by 2002:adf:f088:: with SMTP id n8mr32462459wro.411.1637252837334;
 Thu, 18 Nov 2021 08:27:17 -0800 (PST)
MIME-Version: 1.0
References: <20211118142124.526901-1-arnd@kernel.org> <YZZ5b0FoppEBRcdL@archlinux-ax161>
In-Reply-To: <YZZ5b0FoppEBRcdL@archlinux-ax161>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 18 Nov 2021 17:27:01 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1N8gsXFV=19gWAu033_kCUcf8+DoV4PXyLnaDEitSTXw@mail.gmail.com>
Message-ID: <CAK8P3a1N8gsXFV=19gWAu033_kCUcf8+DoV4PXyLnaDEitSTXw@mail.gmail.com>
Subject: Re: [PATCH] [v3] iwlwifi: pcie: fix constant-conversion warning
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Yaara Baruch <yaara.baruch@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 5:03 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Thu, Nov 18, 2021 at 03:21:02PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > gcc-11 points out a potential issue with integer overflow when
> > the iwl_dev_info_table[] array is empty:
> >
> > drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
> >         for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
> >                ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
>
> For what it's worth, I do see this warning with Clang when both
> CONFIG_IWLDVM and CONFIG_IWLMVM are disabled and looking through the GCC
> warning docs [1], I do not see a -Wconstant-conversion option? Maybe
> there is another warning that is similar but that warning right there
> appears to have come from clang, as it matches mine exactly.
>
> drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
>         for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
>                ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
> 1 error generated.
>
> [1]: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

Ok, got it: it turns out this warning /also/ happens with gcc-11 and
the initial changelog was the one for matching the clang warning.
This is the gcc output, which is very similar but has a different
warning option.

drivers/net/wireless/intel/iwlwifi/pcie/drv.c: In function
'iwl_pci_find_dev_info':
include/linux/kernel.h:46:25: error: overflow in conversion from 'long
unsigned int' to 'int' changes value from '18446744073709551615' to
'-1' [-Werror=overflow]
   46 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
__must_be_array(arr))
      |                         ^
drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:18: note: in
expansion of macro 'ARRAY_SIZE'
 1344 |         for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {

My v2 patch only addressed the clang warning, while v3 works with both
gcc and clang. I can send a v4 if I should update the changelog again
to explain that, but I suppose it's still close enough.

      Arnd
