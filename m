Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5649554FEA0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiFQUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiFQUp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:45:27 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16920E0D4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655498726; x=1687034726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9H0b+NLjQaPYMc19d380+95U2b/CuI7nYIzF28Lp1Tw=;
  b=G1hSvJDbA6DxRdL+AtWiY2gUzEx4gY9oUgtOtgrkLgMgkuXryzxx2WCN
   do4XTkc7AMoyM+qNXpA4MmyJg0yzmdNOXhUKc/7b5ea9BeCSNprB85W24
   8Dhehwy92CcwrPczFq2uXH5btx+uXWtNPOBgvcoTUlkLsVcH0YVyOtpWj
   o=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 17 Jun 2022 20:45:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id EA4F3838FD;
        Fri, 17 Jun 2022 20:45:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 17 Jun 2022 20:45:11 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.158) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 17 Jun 2022 20:45:08 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <lkp@intel.com>
CC:     <aams@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kbuild-all@lists.01.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <llvm@lists.linux.dev>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
Date:   Fri, 17 Jun 2022 13:44:56 -0700
Message-ID: <20220617204456.33187-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <202206180244.SIWZxbAo-lkp@intel.com>
References: <202206180244.SIWZxbAo-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D22UWC004.ant.amazon.com (10.43.162.198) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   kernel test robot <lkp@intel.com>
Date:   Sat, 18 Jun 2022 02:17:44 +0800
> Hi Kuniyuki,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220617-075046
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5dcb50c009c9f8ec1cfca6a81a05c0060a5bbf68
> config: hexagon-randconfig-r045-20220617 (https://download.01.org/0day-ci/archive/20220618/202206180244.SIWZxbAo-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d764aa7fc6b9cc3fbe960019018f5f9e941eb0a6)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/d0da436e1c42550dbd332f48fd11992d5f4af487
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220617-075046
>         git checkout d0da436e1c42550dbd332f48fd11992d5f4af487
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/unix/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> net/unix/af_unix.c:3590:1: warning: unused label 'err_sysctl' [-Wunused-label]
>    err_sysctl:
>    ^~~~~~~~~~~
>    1 warning generated.
> 
> 
> vim +/err_sysctl +3590 net/unix/af_unix.c
> 
>   3573	
>   3574		net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
>   3575					GFP_KERNEL);
>   3576		if (!net->unx.hash)
>   3577			goto err_proc;
>   3578	
>   3579		for (i = 0; i < UNIX_HASH_SIZE; i++) {
>   3580			INIT_HLIST_HEAD(&net->unx.hash[i].head);
>   3581			spin_lock_init(&net->unx.hash[i].lock);
>   3582		}
>   3583	
>   3584		return 0;
>   3585	
>   3586	err_proc:
>   3587	#ifdef CONFIG_PROC_FS
>   3588		remove_proc_entry("unix", net->proc_net);
>   3589	#endif
> > 3590	err_sysctl:

I will move this label into the #ifdef CONFIG_PROC_FS block above.

Thanks!


>   3591		unix_sysctl_unregister(net);
>   3592	out:
>   3593		return -ENOMEM;
>   3594	}
>   3595	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
