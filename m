Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776F13D0E2C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhGULNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237391AbhGUKwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 06:52:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB6560FED;
        Wed, 21 Jul 2021 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626867163;
        bh=4Y/2dDgy3hOFpReNNfcBctn8kDvRVCFYNU5op/h2okE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvU9aJvQHtPT3F48cbvVWwNmM5ZodebOZVXEGHpazXX0pHsCDbRhtk1xq/1rrolYr
         ykN5ymTfLs7+41aIYN6rdCPL/9m3ieno7u+z7zUCogerIdCOkMkazKYpwnlWcyvTQF
         LDBi+R4YCqgUJxpO3Y+DsNLF8BaYKr1aeXY3v8zo=
Date:   Wed, 21 Jul 2021 13:32:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] selftests: add tests_sysfs module
Message-ID: <YPgF2VAoxPIiKWX1@kroah.com>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703004632.621662-2-mcgrof@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 05:46:29PM -0700, Luis Chamberlain wrote:
> This adds a new selftest module which can be used to test sysfs, which
> would otherwise require using an existing driver. This lets us muck
> with a template driver to test breaking things without affecting
> system behaviour or requiring the dependencies of a real device
> driver.
> 
> A series of 28 tests are added. Support for using two device types are
> supported:
> 
>   * misc
>   * block
> 
> Contrary to sysctls, sysfs requires a full write to happen at once, and
> so we reduce the digit tests to single writes. Two main sysfs knobs are
> provided for testing reading/storing, one which doesn't inclur any
> delays and another which can incur programmed delays. What locks are
> held, if any, are configurable, at module load time, or through dynamic
> configuration at run time.
> 
> Since sysfs is a technically filesystem, but a pseudo one, which
> requires a kernel user, our test_sysfs module and respective test script
> embraces fstests format for tests in the kernel ring bufffer. Likewise,
> a scraper for kernel crashes is provided which matches what fstests does
> as well.
> 
> Two tests are kept disabled as they currently cause a deadlock, and so
> this provides a mechanism to easily show proof and demo how the deadlock
> can happen:
> 
> Demos the deadlock with a device specific lock
> ./tools/testing/selftests/sysfs/sysfs.sh -t 0027
> 
> Demos the deadlock with rtnl_lock()
> ./tools/testing/selftests/sysfs/sysfs.sh -t 0028
> 
> Two separate solutions to the deadlock issue have been proposed,
> and so now its a matter of either documenting this limitation or
> eventually adopting a generic fix.
> 
> This selftests will shortly be expanded upon with more tests which
> require further kernel changes in order to provide better test
> coverage.

Why is this not using kunit?  We should not be adding new in-kernel
tests that are not using that api anymore.

> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  MAINTAINERS                            |    7 +
>  lib/Kconfig.debug                      |   10 +
>  lib/Makefile                           |    1 +
>  lib/test_sysfs.c                       |  943 +++++++++++++++++++
>  tools/testing/selftests/sysfs/Makefile |   12 +
>  tools/testing/selftests/sysfs/config   |    2 +
>  tools/testing/selftests/sysfs/sysfs.sh | 1202 ++++++++++++++++++++++++
>  7 files changed, 2177 insertions(+)
>  create mode 100644 lib/test_sysfs.c
>  create mode 100644 tools/testing/selftests/sysfs/Makefile
>  create mode 100644 tools/testing/selftests/sysfs/config
>  create mode 100755 tools/testing/selftests/sysfs/sysfs.sh
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 66d047dc6880..fd369ed50040 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17958,6 +17958,13 @@ L:	linux-mmc@vger.kernel.org
>  S:	Maintained
>  F:	drivers/mmc/host/sdhci-pci-dwc-mshc.c
>  
> +SYSFS TEST DRIVER
> +M:	Luis Chamberlain <mcgrof@kernel.org>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	lib/test_sysfs.c
> +F:	tools/testing/selftests/sysfs/
> +
>  SYSTEM CONFIGURATION (SYSCON)
>  M:	Lee Jones <lee.jones@linaro.org>
>  M:	Arnd Bergmann <arnd@arndb.de>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index fb370c7c4756..568838ac1189 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2360,6 +2360,16 @@ config TEST_SYSCTL
>  
>  	  If unsure, say N.
>  
> +config TEST_SYSFS
> +	tristate "sysfs test driver"
> +	depends on SYSFS
> +	help
> +	  This builds the "test_sysfs" module. This driver enables to test the
> +	  sysfs file system safely without affecting production knobs which
> +	  might alter system functionality.
> +
> +	  If unsure, say N.
> +
>  config BITFIELD_KUNIT
>  	tristate "KUnit test bitfield functions at runtime"
>  	depends on KUNIT
> diff --git a/lib/Makefile b/lib/Makefile
> index 5efd1b435a37..effd1ef806f0 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
>  obj-$(CONFIG_TEST_BITOPS) += test_bitops.o
>  CFLAGS_test_bitops.o += -Werror
>  obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
> +obj-$(CONFIG_TEST_SYSFS) += test_sysfs.o
>  obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
>  obj-$(CONFIG_TEST_IDA) += test_ida.o
>  obj-$(CONFIG_KASAN_KUNIT_TEST) += test_kasan.o
> diff --git a/lib/test_sysfs.c b/lib/test_sysfs.c
> new file mode 100644
> index 000000000000..bf43016d40b5
> --- /dev/null
> +++ b/lib/test_sysfs.c
> @@ -0,0 +1,943 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

This does not match your "boiler-plate" text below, sorry.

thanks,

greg k-h
