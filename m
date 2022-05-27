Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC9C53594C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245268AbiE0G1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiE0G1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BEF313B4;
        Thu, 26 May 2022 23:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 667B2618CB;
        Fri, 27 May 2022 06:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5464AC385A9;
        Fri, 27 May 2022 06:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653632856;
        bh=L9BhbK5z8mAy1Aa7jHJx4mr/XyGaxNMknk8uKHvbA+8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QwO6dq/yaF848AYty2DzrwdCzXIHx4c23FjAG/KyexPdSjS+TRCTPGyuT7p6+B11j
         XHm2w8jw1C9qhLQtIRHMuyObfB5L5s7gUJSM2vqvg8awqtjqYOfAlmgU28GG2UiymV
         7ihcuJIOZUjbc0onUBB89VDt69bLQNvit0YrzT8cHA22uhktzXKQDS4eQVUbdhUTq1
         sdHJmnMtUORv38O0gVYkNeFq5a/OJSwZNiUonpgXzwnnyB1sQGfPWIQySbLCAl/XHS
         YKeqVqtASVTUrxBReh0oFueogB+bjeRiDHSIFzNOqzVpG93eO1f/qAfpj2HwFP2zWe
         3rN/BN/I0gPqQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Jianglei Nie <niejianglei2021@163.com>, pizza@shaftnet.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cw1200: Fix memory leak in cw1200_set_key()
References: <20220526033003.473943-1-niejianglei2021@163.com>
        <202205261656.CWDWN8nG-lkp@intel.com>
Date:   Fri, 27 May 2022 09:27:30 +0300
In-Reply-To: <202205261656.CWDWN8nG-lkp@intel.com> (kernel test robot's
        message of "Thu, 26 May 2022 17:02:43 +0800")
Message-ID: <875ylrwkvh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> Hi Jianglei,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on wireless-next/main]
> [also build test ERROR on wireless/main v5.18 next-20220526]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Jianglei-Nie/cw1200-Fix-memory-leak-in-cw1200_set_key/20220526-114747
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
> config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220526/202205261656.CWDWN8nG-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3d546191ad9d7d2ad2c7928204b9de51deafa675)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/1e40283730dea11a1556d589925313cdca295484
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Jianglei-Nie/cw1200-Fix-memory-leak-in-cw1200_set_key/20220526-114747
>         git checkout 1e40283730dea11a1556d589925313cdca295484
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/wireless/st/cw1200/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>>> drivers/net/wireless/st/cw1200/sta.c:826:26: error: use of undeclared identifier 'idx'
>                            cw1200_free_key(priv, idx);
>                                                  ^

So you don't even compile your patches? That is bad.

The patches sent to linux-wireless should be properly tested. In some
trivial cases a compilation test might enough, but even then that needs
to be clearly documented with "Compile tested only" in the commit log.

I'm getting worried how frequent it has become that people submit
untested patches or that they test them using simulation tools like
syzbot, but not on real hardware.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
