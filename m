Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CBB50AA64
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 22:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392608AbiDUU4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392609AbiDUU4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 16:56:45 -0400
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 13:53:54 PDT
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C736F4EA19
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 13:53:54 -0700 (PDT)
Received: (wp-smtpd smtp.tlen.pl 20653 invoked from network); 21 Apr 2022 22:47:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1650574032; bh=uOC1fW/0uuSbuGCETmD2nbnOBndFlT09OLOf26HRiaM=;
          h=To:From:Subject:Cc;
          b=Iv/G25/v63Q81fWXkDU2p/sFBgBPmyoblHSgbQHfXvSNNJOWtatD8hgKUR8jpPtkG
           2uahVMDf9nKYTsIbKpW44RjV6zssoUTwqw+7Odi9cEkM7ThKOeiPz9mVWfWYXM5+eI
           1CdkDmzCzEwonlRqL/N+ET80S6MoCisc0dRKLLE0=
Received: from aafl13.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.141.13])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <netdev@vger.kernel.org>; 21 Apr 2022 22:47:12 +0200
Message-ID: <dbd203b1-3988-4c9c-909c-2d1f7f173a0d@o2.pl>
Date:   Thu, 21 Apr 2022 22:47:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-GB
To:     netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
Subject: "mm: uninline copy_overflow()" breaks i386 build in Mellanox MLX4
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 15cac2a73e996b392246ccbfd184ccf8
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [8RPE]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

commit ad7489d5262d ("mm: uninline copy_overflow()")

breaks for me a build for i386 in the Mellanox MLX4 driver:

        In file included from ./arch/x86/include/asm/preempt.h:7,
                         from ./include/linux/preempt.h:78,
                         from ./include/linux/percpu.h:6,
                         from ./include/linux/context_tracking_state.h:5,
                         from ./include/linux/hardirq.h:5,
                         from drivers/net/ethernet/mellanox/mlx4/cq.c:37:
        In function ‘check_copy_size’,
            inlined from ‘copy_to_user’ at ./include/linux/uaccess.h:159:6,
            inlined from ‘mlx4_init_user_cqes’ at drivers/net/ethernet/mellanox/mlx4/cq.c:317:9,
            inlined from ‘mlx4_cq_alloc’ at drivers/net/ethernet/mellanox/mlx4/cq.c:394:10:
        ./include/linux/thread_info.h:228:4: error: call to ‘__bad_copy_from’ declared with attribute error: copy source size is too small
          228 |    __bad_copy_from();
              |    ^~~~~~~~~~~~~~~~~
        make[5]: *** [scripts/Makefile.build:288: drivers/net/ethernet/mellanox/mlx4/cq.o] Błąd 1
        make[4]: *** [scripts/Makefile.build:550: drivers/net/ethernet/mellanox/mlx4] Błąd 2
        make[3]: *** [scripts/Makefile.build:550: drivers/net/ethernet/mellanox] Błąd 2
        make[2]: *** [scripts/Makefile.build:550: drivers/net/ethernet] Błąd 2
        make[1]: *** [scripts/Makefile.build:550: drivers/net] Błąd 2

Reverting this commit fixes the build. Disabling Mellanox Ethernet drivers
in Kconfig (tested only with also disabling of all Infiniband support) also fixes the build.

It appears that uninlining of copy_overflow() causes GCC to analyze the code deeper.

The code in mlx4_init_user_cqes, for reference:

        static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
        {
                int entries_per_copy = PAGE_SIZE / cqe_size;
                void *init_ents;
                int err = 0;
                int i;

                init_ents = kmalloc(PAGE_SIZE, GFP_KERNEL);
                // ...
                if (entries_per_copy < entries) {
                        // ...
                } else {
                        // BUG here
                        err = copy_to_user((void __user *)buf, init_ents,
                                        array_size(entries, cqe_size)) ?
                                -EFAULT : 0;
                }

                // ...
        }

My setup: Ubuntu 20.04, gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)

I was using lightly modified Kconfig from Debian i386 Linux packages.

Greetings,

Mateusz Jończyk

